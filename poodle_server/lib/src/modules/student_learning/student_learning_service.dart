import '../../core/course_tenancy.dart';
import 'package:serverpod/serverpod.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import '../teaching/teaching_service.dart';
import 'student_tasks_repository.dart';

/// Student-only read projection. TeachingService.get enforces course membership,
/// all three publication flags, ownership, and expired-attempt finalization.
class StudentLearningService {
  Future<List<({CourseRecord course, TeachingActivityView view, String title})>>
  _visible(Session session) async {
    final account = await AccountAuthorization.requireAccount(session);
    final memberships = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) =>
            t.authUserId.equals(account.authUserId) &
            t.active.equals(true) &
            t.role.equals('student'),
      ),
    );
    final result =
        <({CourseRecord course, TeachingActivityView view, String title})>[];
    for (final member in memberships) {
      final course = await CourseRecord.db.findById(session, member.courseId);
      if (course == null) continue;
      final records = await TeachingActivityRecord.db.find(
        session,
        where: (t) =>
            t.courseId.equals(member.courseId) & t.published.equals(true),
      );
      for (final record in records) {
        final activity = await CourseActivityRecord.db.findById(
          session,
          record.activityId,
        );
        if (activity == null || !activity.published) continue;
        final section = await CourseSectionRecord.db.findById(
          session,
          activity.sectionId,
        );
        if (section == null ||
            section.courseId != member.courseId ||
            !section.published) {
          continue;
        }
        final view = await TeachingService().get(
          session,
          member.courseId,
          record.activityId,
        );
        result.add((course: course, view: view, title: activity.title));
      }
    }
    return result;
  }

  Future<StudentGradesResponse> listGrades(Session session) async {
    final visible = await _visible(session);
    final courses = <UuidValue, StudentGradeCourse>{};
    for (final item in visible) {
      final view = item.view;
      if (view.kind != 'assignment' && view.kind != 'test') continue;
      String status = 'notSubmitted';
      double? points;
      double? maximum;
      String? feedback;
      if (view.kind == 'assignment') {
        final submissions = [...view.submissions]
          ..sort((a, b) {
            final date = b.submittedAt.compareTo(a.submittedAt);
            return date != 0
                ? date
                : b.id.toString().compareTo(a.id.toString());
          });
        if (submissions.isNotEmpty) {
          final latest = submissions.first;
          status = latest.published && latest.grade != null
              ? 'graded'
              : 'pending';
          if (status == 'graded') {
            points = latest.grade;
            maximum = view.settings.maxPoints;
            feedback = latest.feedback;
          }
        }
      } else {
        final attempts =
            view.attempts.where((a) => a.submittedAt != null).toList()
              ..sort((a, b) {
                final date = b.submittedAt!.compareTo(a.submittedAt!);
                return date != 0
                    ? date
                    : b.id.toString().compareTo(a.id.toString());
              });
        if (attempts.isNotEmpty) {
          final latest = attempts.first;
          status = view.released && latest.score != null ? 'graded' : 'pending';
          if (status == 'graded') {
            points = latest.score;
            maximum = latest.maxPoints;
          }
        }
      }
      final courseId = item.course.id!;
      final group = courses.putIfAbsent(
        courseId,
        () => StudentGradeCourse(
          courseId: courseId,
          courseTitle: item.course.title,
          grades: [],
        ),
      );
      group.grades.add(
        StudentGradeRow(
          courseId: courseId,
          courseTitle: item.course.title,
          activityId: view.activityId,
          activityTitle: item.title,
          kind: view.kind,
          status: status,
          points: points,
          maximum: maximum,
          feedback: feedback,
        ),
      );
    }
    final sorted = courses.values.toList()
      ..sort((a, b) {
        final title = a.courseTitle.compareTo(b.courseTitle);
        return title != 0
            ? title
            : a.courseId.toString().compareTo(b.courseId.toString());
      });
    for (final course in sorted) {
      course.grades.sort((a, b) {
        final title = a.activityTitle.compareTo(b.activityTitle);
        return title != 0
            ? title
            : a.activityId.toString().compareTo(b.activityId.toString());
      });
    }
    return StudentGradesResponse(courses: sorted);
  }

  Future<StudentTasksResponse> listTasks(Session session) async {
    final account = await AccountAuthorization.requireAccount(session);
    final now = DateTime.now().toUtc();
    return StudentTasksResponse(
      serverTime: now,
      tasks: await StudentTasksRepository().list(
        session,
        account.authUserId,
        now,
      ),
    );
  }
}
