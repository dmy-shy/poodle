import '../../core/course_tenancy.dart';
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class CourseRepository {
  Future<CoursePreference?> preference(
    Session session,
    UuidValue userId,
    UuidValue courseId,
  ) => CoursePreference.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(userId) & t.courseId.equals(courseId),
  );
  Future<CourseRecord?> course(Session session, UuidValue id) =>
      CourseRecord.db.findById(session, id);

  Future<CourseMembership?> membership(
    Session session,
    UuidValue courseId,
    UuidValue userId,
  ) => CourseMembership.db.findFirstRow(
    session,
    where: (t) => t.courseId.equals(courseId) & t.authUserId.equals(userId),
  );

  Future<
    List<
      ({
        CourseRecord course,
        CourseMembership membership,
        CoursePreference? preference,
      })
    >
  >
  list(Session session, UuidValue userId) async {
    final memberships = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) => t.authUserId.equals(userId) & t.active.equals(true),
      ),
    );
    if (memberships.isEmpty) return [];
    final ids = memberships.map((m) => m.courseId).toSet();
    final courses = await CourseRecord.db.find(
      session,
      where: (t) => t.id.inSet(ids),
      orderByList: (t) => [t.title, t.id],
    );
    final preferences = await CoursePreference.db.find(
      session,
      where: (t) => t.authUserId.equals(userId) & t.courseId.inSet(ids),
    );
    final membersByCourse = {for (final m in memberships) m.courseId: m};
    final preferencesByCourse = {for (final p in preferences) p.courseId: p};
    return [
      for (final course in courses)
        (
          course: course,
          membership: membersByCourse[course.id]!,
          preference: preferencesByCourse[course.id],
        ),
    ];
  }
}
