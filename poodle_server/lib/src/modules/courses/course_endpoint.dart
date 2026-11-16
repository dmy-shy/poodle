import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import 'course_service.dart';
import 'course_preference_service.dart';

/// University-scoped course access and creation.
class CourseEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;
  Future<CourseSummary> create(Session session, String title) =>
      CourseService().create(session, title);
  Future<CourseSummary> setPublished(
    Session session,
    UuidValue courseId,
    bool published,
  ) => CourseService().setPublished(session, courseId, published);
  Future<List<CourseSummary>> listMyCourses(Session session) =>
      CourseService().list(session);
  Future<CourseSummary> getCourse(Session session, UuidValue courseId) =>
      CourseService().get(session, courseId);
  Future<CourseSummary> setStarred(
    Session session,
    UuidValue courseId,
    bool starred,
  ) => CoursePreferenceService().set(session, courseId, starred: starred);
  Future<CourseSummary> setHidden(
    Session session,
    UuidValue courseId,
    bool hidden,
  ) => CoursePreferenceService().set(session, courseId, hidden: hidden);
}
