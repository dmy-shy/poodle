import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class CourseContentRepository {
  Future<Set<UuidValue>> managedAssessments(
    Session session,
    UuidValue courseId,
  ) async => (await TeachingActivityRecord.db.find(
    session,
    where: (t) => t.courseId.equals(courseId),
  )).map((r) => r.activityId).toSet();

  Future<List<CourseSectionRecord>> sections(
    Session session,
    UuidValue courseId,
  ) => CourseSectionRecord.db.find(
    session,
    where: (t) => t.courseId.equals(courseId),
    orderBy: (t) => t.sortOrder,
  );
  Future<List<CourseActivityRecord>> activities(
    Session session,
    UuidValue sectionId,
  ) => CourseActivityRecord.db.find(
    session,
    where: (t) => t.sectionId.equals(sectionId),
    orderBy: (t) => t.sortOrder,
  );
  Future<CourseActivityRecord?> activity(Session session, UuidValue id) =>
      CourseActivityRecord.db.findById(session, id);
}
