import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../courses/course_policy.dart';
import '../courses/course_service.dart';
import 'course_content_repository.dart';

class CourseContentService {
  CourseContentService({
    CourseService? courses,
    CourseContentRepository? repository,
    DateTime Function()? clock,
  }) : _courses = courses ?? CourseService(),
       _repository = repository ?? CourseContentRepository(),
       _clock = clock ?? DateTime.now;
  final CourseService _courses;
  final CourseContentRepository _repository;
  final DateTime Function() _clock;

  static bool isReadableActivity(CourseActivityRecord row) {
    final count = [
      row.file,
      row.link,
      row.announcement,
      row.assessment,
    ].where((v) => v != null).length;
    if (count != 1) return false;
    switch (row.kind) {
      case 'file':
        return row.file != null;
      case 'link':
        final uri = Uri.tryParse(row.link?.url ?? '');
        return row.link != null &&
            uri != null &&
            uri.scheme == 'https' &&
            uri.host.isNotEmpty &&
            uri.userInfo.isEmpty;
      case 'announcement':
        return row.announcement != null;
      case 'module':
      case 'lab':
      case 'assignment':
      case 'test':
        return row.assessment != null;
      default:
        return false;
    }
  }

  Future<CourseDetail> getContent(Session session, UuidValue courseId) async {
    final access = await _courses.requireMember(session, courseId);
    final teacher = access.membership.role == 'teacher';
    final now = _clock().toUtc();
    final managed = await _repository.managedAssessments(session, courseId);
    final sections = <CourseSection>[];
    final rows = await _repository.sections(session, courseId);
    rows.sort((a, b) => _order(a.sortOrder, a.id!, b.sortOrder, b.id!));
    for (final section in rows) {
      if (!teacher && !section.published) continue;
      final records = await _repository.activities(session, section.id!);
      records.sort((a, b) => _order(a.sortOrder, a.id!, b.sortOrder, b.id!));
      final activities = records
          .where((r) => (teacher || r.published) && isReadableActivity(r))
          .map(
            (r) => CourseActivity(
              id: r.id!,
              courseId: courseId,
              title: r.title,
              description: r.description,
              kind: r.kind,
              draft: !r.published || !section.published,
              managedAssessment: managed.contains(r.id),
              file: r.file,
              link: r.link,
              announcement: r.announcement,
              assessment: r.assessment,
              availability: r.assessment == null
                  ? null
                  : CoursePolicy.availability(
                      now,
                      r.assessment!.opensAt,
                      r.assessment!.closesAt,
                    ),
            ),
          )
          .toList();
      sections.add(
        CourseSection(
          id: section.id!,
          title: section.title,
          description: section.description,
          draft: !section.published,
          activities: activities,
        ),
      );
    }
    final flat = sections.expand((s) => s.activities).toList();
    for (var i = 0; i < flat.length; i++) {
      flat[i].previousId = i == 0 ? null : flat[i - 1].id;
      flat[i].nextId = i + 1 == flat.length ? null : flat[i + 1].id;
    }
    return CourseDetail(
      course: await _courses.get(session, courseId),
      sections: sections,
      teacherView: teacher,
      serverTime: now,
    );
  }

  int _order(int a, UuidValue aId, int b, UuidValue bId) {
    final value = a.compareTo(b);
    return value != 0 ? value : aId.toString().compareTo(bId.toString());
  }

  Future<CourseActivity> getActivity(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
  ) async {
    final detail = await getContent(session, courseId);
    for (final section in detail.sections) {
      for (final activity in section.activities) {
        if (activity.id == activityId) return activity;
      }
    }
    throw CourseReadException(code: 'unavailable');
  }

  Future<CourseFileAccess> getFileUrl(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
  ) async {
    final activity = await getActivity(session, courseId, activityId);
    final file = activity.file;
    if (file == null ||
        !const [
          'application/pdf',
          'text/markdown',
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        ].contains(file.mimeType)) {
      session.log(
        'Course download rejected: activity=$activityId, unsupported MIME type=${file?.mimeType}',
        level: LogLevel.warning,
      );
      throw CourseReadException(code: 'unavailable');
    }
    final record = await _repository.activity(session, activityId);
    if (record == null ||
        record.storageId != 'private' ||
        record.storagePath == null) {
      session.log(
        'Course download rejected: activity=$activityId, missing private storage reference',
        level: LogLevel.warning,
      );
      throw CourseReadException(code: 'unavailable');
    }
    try {
      final url = await session.storage.temporaryDownloadUrl(
        storageId: 'private',
        path: record.storagePath!,
        options: TemporaryDownloadUrlOptions(
          expirationDuration: const Duration(seconds: 60),
          downloadFileName: file.fileName,
          contentType: file.mimeType,
        ),
      );
      return CourseFileAccess(
        url: url.toString(),
        expiresAt: _clock().toUtc().add(const Duration(seconds: 60)),
      );
    } on CloudStorageException catch (error) {
      session.log(
        'Course download rejected: activity=$activityId, storage error=${error.runtimeType}',
        level: LogLevel.warning,
      );
      throw CourseReadException(code: 'unavailable');
    }
  }
}
