import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import 'teaching_service.dart';

class TeachingEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;
  final _service = TeachingService();
  Future<List<TeachingCourseView>> dashboard(Session session) =>
      _service.dashboard(session);
  Future<List<TeachingMemberView>> members(
    Session session,
    UuidValue courseId,
  ) => _service.members(session, courseId);
  Future<List<TeachingActivityView>> listActivities(
    Session session,
    UuidValue courseId,
  ) => _service.list(session, courseId);
  Future<TeachingActivityView> getActivity(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
  ) => _service.get(session, courseId, activityId);
  Future<TeachingActivityView> saveActivity(
    Session session,
    TeachingSaveInput input,
  ) => _service.save(session, input);
  Future<TeachingSettings> getDefaults(Session session) =>
      _service.defaults(session, null);
  Future<TeachingSettings> saveDefaults(
    Session session,
    TeachingSettings settings,
  ) => _service.defaults(session, settings);
  Future<TeachingUploadTicket> beginUpload(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
    String fileName,
    int sizeBytes,
  ) => _service.upload(session, courseId, activityId, fileName, sizeBytes);
  Future<TeachingActivityView> submitAssignment(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
    String text,
    UuidValue? uploadId,
    String requestKey,
  ) => _service.submit(
    session,
    courseId,
    activityId,
    text,
    uploadId,
    requestKey,
  );
  Future<TeachingActivityView> gradeAssignment(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
    UuidValue submissionId,
    double points,
    String feedback,
    bool publish,
  ) => _service.grade(
    session,
    courseId,
    activityId,
    submissionId,
    points,
    feedback,
    publish,
  );
  Future<TeachingActivityView> reopenAssignment(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
    UuidValue ownerId,
    DateTime deadline,
  ) => _service.reopen(session, courseId, activityId, ownerId, deadline);
  Future<CourseFileAccess> submissionFile(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
    UuidValue submissionId,
  ) => _service.file(session, courseId, activityId, submissionId);
  Future<TeachingActivityView> startTest(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
  ) => _service.start(session, courseId, activityId);
  Future<TeachingActivityView> saveAnswers(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
    UuidValue attemptId,
    List<int> answers,
    bool finish,
  ) => _service.answer(
    session,
    courseId,
    activityId,
    attemptId,
    answers,
    finish,
  );
  Future<TeachingActivityView> releaseTest(
    Session session,
    UuidValue courseId,
    UuidValue activityId,
  ) => _service.release(session, courseId, activityId);
}
