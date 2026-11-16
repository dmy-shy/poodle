import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../courses/course_service.dart';
import 'notebook_material_policy.dart';
import 'notebook_repository.dart';

/// Teacher-only settings; never reads students' notebooks or private sources.
class NotebookSettingsService {
  Future<NotebookAssessmentSetup> read(
    Session session,
    UuidValue courseId,
    UuidValue assessmentActivityId,
  ) async {
    final access = await CourseService().requireMember(session, courseId);
    if (access.membership.role != 'teacher') {
      throw NotebookError(code: 'unavailable');
    }
    final repository = NotebookRepository();
    return session.db.transaction((tx) async {
      await repository.lock(session, 'course:$courseId', tx);
      final assessment = await CourseActivityRecord.db.findById(
        session,
        assessmentActivityId,
        transaction: tx,
      );
      final sections = await CourseSectionRecord.db.find(
        session,
        where: (t) => t.courseId.equals(courseId) & t.published.equals(true),
        transaction: tx,
      );
      final sectionIds = sections.map((s) => s.id!).toSet();
      if (assessment == null ||
          !assessment.published ||
          !sectionIds.contains(assessment.sectionId) ||
          !{'module', 'test'}.contains(assessment.kind) ||
          assessment.assessment == null) {
        throw NotebookError(code: 'unavailable');
      }
      final current = await repository.config(
        session,
        courseId,
        assessmentActivityId,
        transaction: tx,
      );
      final defaults = current == null
          ? <NotebookAssessmentMaterialRecord>[]
          : await repository.materials(session, current.id!, transaction: tx);
      final materials = <NotebookMaterialOption>[];
      for (final section in sections) {
        final activities = await CourseActivityRecord.db.find(
          session,
          where: (t) =>
              t.sectionId.equals(section.id) &
              t.published.equals(true) &
              t.kind.equals('file'),
          orderBy: (t) => t.sortOrder,
          transaction: tx,
        );
        for (final activity in activities) {
          try {
            final format = NotebookMaterialPolicy.format(activity);
            materials.add(
              NotebookMaterialOption(
                id: activity.id!,
                title: activity.title,
                format: format,
              ),
            );
          } on NotebookError {
            // Public storage, unsupported types and incomplete uploads are not choices.
          }
        }
      }
      return NotebookAssessmentSetup(
        configuration: NotebookAssessmentConfigView(
          courseId: courseId,
          assessmentActivityId: assessmentActivityId,
          revision: current?.revision ?? 0,
          defaultMaterialActivityIds: defaults
              .map((m) => m.activityId)
              .toList(),
          allowedFormats: current?.allowedFormats ?? ['txt', 'md'],
        ),
        materials: materials,
      );
    });
  }
}
