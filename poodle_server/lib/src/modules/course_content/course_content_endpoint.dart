import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import 'course_content_service.dart';

class CourseContentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;
  Future<CourseDetail> getCourseContent(Session session, UuidValue courseId) =>
      CourseContentService().getContent(session, courseId);
  Future<CourseActivity> getActivity(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
  ) => CourseContentService().getActivity(session, courseId, activityId);
  Future<CourseFileAccess> getFileUrl(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
  ) => CourseContentService().getFileUrl(session, courseId, activityId);
}
