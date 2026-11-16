import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../course_content/course_content_service.dart';

const searchEmbeddingSpace = 'openai:text-embedding-3-small:1536:v1';

class SearchDocument {
  SearchDocument({
    required this.hit,
    required List<String?> fields,
    this.file,
    this.storagePath,
  }) : content = fields.whereType<String>().join('\n').trim() {
    fingerprint = sha256
        .convert(
          utf8.encode(
            jsonEncode([
              searchEmbeddingSpace,
              hit.kind,
              hit.targetId.toString(),
              hit.courseId.toString(),
              hit.sectionId?.toString(),
              content,
              file?.checksum,
              file?.mimeType,
              file?.sizeBytes,
            ]),
          ),
        )
        .toString();
  }

  final SearchHit hit;
  final String content;
  final CourseFileInfo? file;
  final String? storagePath;
  late final String fingerprint;

  factory SearchDocument.course(CourseRecord course) => SearchDocument(
    hit: SearchHit(
      targetId: course.id!,
      courseId: course.id!,
      kind: 'course',
      title: course.title,
      breadcrumb: '',
      excerpt: '',
      draft: false,
    ),
    fields: [course.title, course.category, course.summary],
  );

  factory SearchDocument.section(
    CourseRecord course,
    CourseSectionRecord section,
  ) => SearchDocument(
    hit: SearchHit(
      targetId: section.id!,
      courseId: course.id!,
      sectionId: section.id,
      kind: 'section',
      title: section.title,
      breadcrumb: course.title,
      excerpt: '',
      draft: !section.published,
    ),
    fields: [section.title, section.description],
  );

  factory SearchDocument.activity(
    CourseRecord course,
    CourseSectionRecord section,
    CourseActivityRecord activity,
  ) {
    final published = section.published && activity.published;
    final file = activity.file;
    final indexFile =
        published &&
        activity.kind == 'file' &&
        file != null &&
        activity.storageId == 'private' &&
        activity.storagePath != null &&
        file.sizeBytes > 0 &&
        file.sizeBytes <= 25 * 1024 * 1024 &&
        file.checksum.isNotEmpty &&
        const {
              'pdf': 'application/pdf',
              'docx':
                  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
              'txt': 'text/plain',
              'md': 'text/markdown',
            }[file.fileName.split('.').last.toLowerCase()] ==
            file.mimeType;
    return SearchDocument(
      hit: SearchHit(
        targetId: activity.id!,
        courseId: course.id!,
        sectionId: section.id,
        activityId: activity.id,
        kind: 'activity',
        title: activity.title,
        breadcrumb: '${course.title} / ${section.title}',
        excerpt: '',
        draft: !published,
      ),
      fields: [
        activity.title,
        activity.description,
        activity.file?.fileName,
        activity.kind == 'announcement' ? activity.announcement?.body : null,
        activity.kind == 'assignment' && published
            ? activity.assessment?.instructions
            : null,
      ],
      file: indexFile ? file : null,
      storagePath: indexFile ? activity.storagePath : null,
    );
  }

  /// Current authoritative catalog. Passing roles restricts the catalog before
  /// any chunk lookup or ranking; the trusted indexing worker omits roles.
  static Future<List<SearchDocument>> catalog(
    Session session, {
    Map<UuidValue, String>? roles,
    UuidValue? courseId,
    Transaction? transaction,
  }) async {
    if (roles?.isEmpty == true) return [];
    final courses = await CourseRecord.db.find(
      session,
      where: (t) => courseId != null
          ? t.id.equals(courseId)
          : roles != null
          ? t.id.inSet(roles.keys.toSet())
          : Constant.bool(true),
      transaction: transaction,
    );
    final ids = courses.map((c) => c.id!).toSet();
    if (ids.isEmpty) return [];
    final sections = await CourseSectionRecord.db.find(
      session,
      where: (t) => t.courseId.inSet(ids),
      transaction: transaction,
    );
    final visible = sections
        .where(
          (s) => roles == null || s.published || roles[s.courseId] == 'teacher',
        )
        .toList();
    final sectionIds = visible.map((s) => s.id!).toSet();
    final activities = sectionIds.isEmpty
        ? <CourseActivityRecord>[]
        : await CourseActivityRecord.db.find(
            session,
            where: (t) => t.sectionId.inSet(sectionIds),
            transaction: transaction,
          );
    final byCourse = {for (final c in courses) c.id!: c};
    final bySection = {for (final s in visible) s.id!: s};
    return [
      for (final c in courses) SearchDocument.course(c),
      for (final s in visible) SearchDocument.section(byCourse[s.courseId]!, s),
      for (final a in activities)
        if ((roles == null ||
                a.published ||
                roles[bySection[a.sectionId]!.courseId] == 'teacher') &&
            CourseContentService.isReadableActivity(a))
          SearchDocument.activity(
            byCourse[bySection[a.sectionId]!.courseId]!,
            bySection[a.sectionId]!,
            a,
          ),
    ];
  }
}
