import '../../core/course_tenancy.dart';
import 'package:serverpod/serverpod.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';

class MyFilesService {
  Future<List<MyUpload>> listUploads(Session session) async {
    final userId = (await AccountAuthorization.requireAccount(
      session,
    )).authUserId;
    final memberships = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) => t.authUserId.equals(userId) & t.active.equals(true),
      ),
    );
    final courses = <UuidValue, CourseRecord>{};
    for (final membership in memberships) {
      if (membership.role != 'student') continue;
      final course = await CourseRecord.db.findById(
        session,
        membership.courseId,
      );
      if (course != null) courses[membership.courseId] = course;
    }
    if (courses.isEmpty) return [];

    final rows = <MyUpload>[];
    final visible = <UuidValue, (CourseActivityRecord, CourseRecord)>{};
    Future<(CourseActivityRecord, CourseRecord)?> activity(
      UuidValue activityId,
      UuidValue courseId,
    ) async {
      final cached = visible[activityId];
      if (cached != null) return cached.$2.id == courseId ? cached : null;
      final course = courses[courseId];
      if (course == null) return null;
      final item = await CourseActivityRecord.db.findById(session, activityId);
      if (item == null || !item.published) return null;
      final section = await CourseSectionRecord.db.findById(
        session,
        item.sectionId,
      );
      if (section == null ||
          !section.published ||
          section.courseId != courseId) {
        return null;
      }
      return visible[activityId] = (item, course);
    }

    final notebooks = <UuidValue, NotebookRecord>{};
    for (final notebook in await NotebookRecord.db.find(
      session,
      where: (t) => t.ownerUserId.equals(userId),
    )) {
      if (notebook.id != null &&
          courses.containsKey(notebook.courseId) &&
          await activity(notebook.assessmentActivityId, notebook.courseId) !=
              null) {
        notebooks[notebook.id!] = notebook;
      }
    }
    final sources = await NotebookSourceRecord.db.find(
      session,
      where: (t) => t.ownerUserId.equals(userId),
    );
    for (final source in sources) {
      final notebook = notebooks[source.notebookId];
      if (source.id == null ||
          notebook == null ||
          source.activityId != null ||
          source.courseId != notebook.courseId ||
          {'deleted', 'uploading'}.contains(source.status)) {
        continue;
      }
      final context = await activity(
        notebook.assessmentActivityId,
        notebook.courseId,
      );
      if (context == null ||
          !{'module', 'test'}.contains(context.$1.kind) ||
          context.$1.assessment == null) {
        continue;
      }
      final config = await NotebookAssessmentConfigRecord.db.findFirstRow(
        session,
        where: (t) =>
            t.courseId.equals(notebook.courseId) &
            t.assessmentActivityId.equals(notebook.assessmentActivityId),
      );
      if (config == null) continue;
      rows.add(
        MyUpload(
          id: source.id!,
          fileName: source.fileName,
          kind: 'notebook',
          uploadedAt: source.createdAt,
          courseId: notebook.courseId,
          courseTitle: context.$2.title,
          activityId: notebook.assessmentActivityId,
          activityTitle: context.$1.title,
          processingStatus: source.status,
        ),
      );
    }

    final uploads = <UuidValue, TeachingUploadRecord>{};
    for (final upload in await TeachingUploadRecord.db.find(
      session,
      where: (t) => t.ownerId.equals(userId),
    )) {
      if (upload.id != null) uploads[upload.id!] = upload;
    }
    final seen = <UuidValue>{};
    for (final submission in await TeachingSubmissionRecord.db.find(
      session,
      where: (t) => t.ownerId.equals(userId),
    )) {
      final uploadId = submission.uploadId;
      if (uploadId == null || seen.contains(uploadId)) continue;
      final upload = uploads[uploadId];
      if (upload == null ||
          upload.activityId != submission.activityId ||
          upload.ownerId != userId) {
        continue;
      }
      final teaching = await TeachingActivityRecord.db.findFirstRow(
        session,
        where: (t) => t.activityId.equals(upload.activityId),
      );
      if (teaching == null ||
          teaching.kind != 'assignment' ||
          !teaching.published) {
        continue;
      }
      final context = await activity(upload.activityId, teaching.courseId);
      if (context == null || context.$1.kind != 'assignment') continue;
      seen.add(uploadId);
      rows.add(
        MyUpload(
          id: uploadId,
          fileName: upload.fileName,
          kind: 'assignment',
          uploadedAt: upload.createdAt,
          courseId: teaching.courseId,
          courseTitle: context.$2.title,
          activityId: upload.activityId,
          activityTitle: context.$1.title,
        ),
      );
    }
    rows.sort((a, b) {
      final date = b.uploadedAt.compareTo(a.uploadedAt);
      return date != 0 ? date : b.id.toString().compareTo(a.id.toString());
    });
    return rows;
  }
}
