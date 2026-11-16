import '../../core/course_tenancy.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../../generated/protocol.dart';

class NotebookExecutionSnapshot {
  const NotebookExecutionSnapshot(this.notebook, this.config, this.versions);
  final NotebookRecord notebook;
  final NotebookAssessmentConfigRecord config;
  final Map<UuidValue, NotebookSourceVersionRecord> versions;
}

/// Internal job authorization: rechecks persisted authority, publication,
/// selection and versions without impersonating a user's JWT session.
abstract final class NotebookExecutionAccess {
  static Future<NotebookExecutionSnapshot> require(
    Session session,
    UuidValue notebookId,
    UuidValue ownerId, {
    Transaction? transaction,
    String? embeddingSpace,
  }) async {
    final notebook = await NotebookRecord.db.findById(
      session,
      notebookId,
      transaction: transaction,
    );
    final user = await AuthUser.db.findById(
      session,
      ownerId,
      transaction: transaction,
    );
    final access = await AccountAccess.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(ownerId),
      transaction: transaction,
    );
    if (notebook == null ||
        notebook.ownerUserId != ownerId ||
        user == null ||
        user.blocked ||
        access == null) {
      throw NotebookError(code: 'unavailable');
    }
    final member = await CourseMembership.db.findFirstRow(
      session,
      where: (t) =>
          t.courseId.equals(notebook.courseId) & t.authUserId.equals(ownerId),
      transaction: transaction,
    );
    final course = await CourseRecord.db.findById(
      session,
      notebook.courseId,
      transaction: transaction,
    );
    final assessment = await CourseActivityRecord.db.findById(
      session,
      notebook.assessmentActivityId,
      transaction: transaction,
    );
    final section = assessment == null
        ? null
        : await CourseSectionRecord.db.findById(
            session,
            assessment.sectionId,
            transaction: transaction,
          );
    final config = await NotebookAssessmentConfigRecord.db.findFirstRow(
      session,
      where: (t) =>
          t.courseId.equals(notebook.courseId) &
          t.assessmentActivityId.equals(notebook.assessmentActivityId),
      transaction: transaction,
    );
    if (member == null ||
        !await CourseTenancy.permits(
          session,
          member,
          transaction: transaction,
        ) ||
        member.role != 'student' ||
        course == null ||
        assessment == null ||
        !assessment.published ||
        assessment.assessment == null ||
        !{'module', 'test'}.contains(assessment.kind) ||
        section == null ||
        !section.published ||
        section.courseId != notebook.courseId ||
        config == null) {
      throw NotebookError(code: 'unavailable');
    }
    final materials = await NotebookAssessmentMaterialRecord.db.find(
      session,
      where: (t) => t.configId.equals(config.id),
      transaction: transaction,
    );
    final defaults = materials.map((m) => m.activityId).toSet();
    final selections = await NotebookSourceSelectionRecord.db.find(
      session,
      where: (t) => t.notebookId.equals(notebookId),
      transaction: transaction,
    );
    final selected = {for (final s in selections) s.sourceId: s.selected};
    final sources = await NotebookSourceRecord.db.find(
      session,
      where: (t) =>
          t.courseId.equals(notebook.courseId) & t.status.equals('ready'),
      transaction: transaction,
    );
    final versions = <UuidValue, NotebookSourceVersionRecord>{};
    for (final source in sources) {
      final shared = source.ownerUserId == null;
      final isDefault =
          shared &&
          source.notebookId == null &&
          defaults.contains(source.activityId);
      if (!(selected[source.id] ?? isDefault)) continue;
      if (shared && !isDefault) continue;
      if (!shared &&
          (source.ownerUserId != ownerId ||
              (source.notebookId != null && source.notebookId != notebookId))) {
        continue;
      }
      if (source.storageId != 'private') continue;
      if (!shared && !config.allowedFormats.contains(source.format)) continue;
      final version = await NotebookSourceVersionRecord.db.findFirstRow(
        session,
        where: (t) =>
            t.sourceId.equals(source.id) &
            t.version.equals(source.currentVersion) &
            t.status.equals('ready'),
        transaction: transaction,
      );
      if (version == null ||
          (embeddingSpace != null &&
              version.embeddingSpace != embeddingSpace)) {
        continue;
      }
      if (shared) {
        final activity = source.activityId == null
            ? null
            : await CourseActivityRecord.db.findById(
                session,
                source.activityId!,
                transaction: transaction,
              );
        final materialSection = activity == null
            ? null
            : await CourseSectionRecord.db.findById(
                session,
                activity.sectionId,
                transaction: transaction,
              );
        if (activity == null ||
            !activity.published ||
            activity.kind != 'file' ||
            materialSection == null ||
            !materialSection.published ||
            materialSection.courseId != notebook.courseId ||
            activity.storageId != 'private' ||
            activity.storagePath != source.storagePath ||
            activity.file?.checksum != version.checksum) {
          continue;
        }
      }
      versions[source.id!] = version;
    }
    return NotebookExecutionSnapshot(
      notebook,
      config,
      Map.unmodifiable(versions),
    );
  }
}
