import 'package:flutter/foundation.dart';
import 'package:file_selector/file_selector.dart';
import 'package:poodle_client/poodle_client.dart' as api;
import '../services/serverpod_auth_gateway.dart';

export 'package:poodle_client/poodle_client.dart'
    show
        TeachingActivityView,
        TeachingSettings,
        TeachingQuestion,
        TeachingCourseView,
        TeachingSubmissionView,
        TeachingAttemptView,
        TeachingMemberView,
        TeachingSaveInput,
        UuidValue;

String createTeachingId() => const api.Uuid().v4();

class TeachingFailure implements Exception {
  const TeachingFailure(this.code);
  final String code;
}

abstract class TeachingRepository extends ChangeNotifier {
  int generation = 0;
  String? account;
  void bindAccount(String? value) {
    generation++;
    account = value;
    notifyListeners();
  }

  Future<List<api.TeachingCourseView>> dashboard();
  Future<List<api.TeachingActivityView>> activities(String course);
  Future<List<api.TeachingMemberView>> members(String course);
  Future<List<({String id, String title})>> sections(String course);
  Future<api.TeachingActivityView> activity(String course, String id);
  Future<api.TeachingSettings> defaults([api.TeachingSettings? value]);
  Future<api.TeachingActivityView> save(api.TeachingSaveInput input);
  Future<api.TeachingActivityView> submit(
    String course,
    String id,
    String text,
    String key, {
    String? uploadId,
  });
  Future<String?> upload(String course, String id);
  Future<api.TeachingActivityView> grade(
    String course,
    String id,
    String submission,
    double points,
    String feedback,
    bool publish,
  );
  Future<api.TeachingActivityView> reopen(
    String course,
    String id,
    String owner,
    DateTime deadline,
  );
  Future<String> file(String course, String id, String submission);
  Future<api.TeachingActivityView> start(String course, String id);
  Future<api.TeachingActivityView> answers(
    String course,
    String id,
    String attempt,
    List<int> answers,
    bool finish,
  );
  Future<api.TeachingActivityView> release(String course, String id);
}

class ServerpodTeachingRepository extends TeachingRepository {
  ServerpodTeachingRepository(this.gateway);
  final ServerpodAuthGateway gateway;
  api.UuidValue _id(String value) => api.UuidValue.withValidation(value);
  Future<T> _call<T>(Future<T> Function(api.Client) operation) async {
    final epoch = generation;
    if (account == null) throw const TeachingFailure('cancelled');
    try {
      final result = await gateway.withClient(operation);
      if (epoch != generation) throw const TeachingFailure('cancelled');
      return result;
    } catch (e) {
      if (epoch != generation) throw const TeachingFailure('cancelled');
      if (e is TeachingFailure) rethrow;
      if (e is api.TeachingError) throw TeachingFailure(e.code);
      throw const TeachingFailure('unavailable');
    }
  }

  @override
  Future<List<api.TeachingCourseView>> dashboard() =>
      _call((c) => c.teaching.dashboard());
  @override
  Future<List<api.TeachingActivityView>> activities(String course) =>
      _call((c) => c.teaching.listActivities(_id(course)));
  @override
  Future<List<({String id, String title})>> sections(String course) => _call(
    (c) async => (await c.courseContent.getCourseContent(
      _id(course),
    )).sections.map((v) => (id: v.id.toString(), title: v.title)).toList(),
  );
  @override
  Future<List<api.TeachingMemberView>> members(String course) =>
      _call((c) => c.teaching.members(_id(course)));
  @override
  Future<api.TeachingActivityView> activity(String course, String id) =>
      _call((c) => c.teaching.getActivity(_id(course), _id(id)));
  @override
  Future<api.TeachingSettings> defaults([api.TeachingSettings? value]) => _call(
    (c) => value == null
        ? c.teaching.getDefaults()
        : c.teaching.saveDefaults(value),
  );
  @override
  Future<api.TeachingActivityView> save(api.TeachingSaveInput input) =>
      _call((c) => c.teaching.saveActivity(input));
  @override
  Future<api.TeachingActivityView> submit(
    String course,
    String id,
    String text,
    String key, {
    String? uploadId,
  }) => _call(
    (c) => c.teaching.submitAssignment(
      _id(course),
      _id(id),
      text,
      uploadId == null ? null : _id(uploadId),
      key,
    ),
  );
  @override
  Future<String?> upload(String course, String id) async {
    final epoch = generation;
    final file = await openFile(
      acceptedTypeGroups: [
        const XTypeGroup(
          label: 'PDF, DOCX, JPEG, PNG',
          extensions: ['pdf', 'docx', 'jpg', 'jpeg', 'png'],
        ),
      ],
    );
    if (file == null) return null;
    final size = await file.length();
    if (size < 1 || size > 20 * 1024 * 1024) {
      throw const TeachingFailure('invalid_upload');
    }
    if (epoch != generation) throw const TeachingFailure('cancelled');
    final ticket = await _call(
      (c) => c.teaching.beginUpload(_id(course), _id(id), file.name, size),
    );
    final bytes = await file.readAsBytes();
    if (epoch != generation) throw const TeachingFailure('cancelled');
    if (!await api.FileUploader(
      ticket.description,
    ).uploadByteData(ByteData.sublistView(bytes))) {
      throw const TeachingFailure('unavailable');
    }
    if (epoch != generation) throw const TeachingFailure('cancelled');
    return ticket.id.toString();
  }

  @override
  Future<api.TeachingActivityView> grade(
    String course,
    String id,
    String submission,
    double points,
    String feedback,
    bool publish,
  ) => _call(
    (c) => c.teaching.gradeAssignment(
      _id(course),
      _id(id),
      _id(submission),
      points,
      feedback,
      publish,
    ),
  );
  @override
  Future<api.TeachingActivityView> reopen(
    String course,
    String id,
    String owner,
    DateTime deadline,
  ) => _call(
    (c) => c.teaching.reopenAssignment(
      _id(course),
      _id(id),
      _id(owner),
      deadline.toUtc(),
    ),
  );
  @override
  Future<String> file(String course, String id, String submission) => _call(
    (c) async => (await c.teaching.submissionFile(
      _id(course),
      _id(id),
      _id(submission),
    )).url,
  );
  @override
  Future<api.TeachingActivityView> start(String course, String id) =>
      _call((c) => c.teaching.startTest(_id(course), _id(id)));
  @override
  Future<api.TeachingActivityView> answers(
    String course,
    String id,
    String attempt,
    List<int> answers,
    bool finish,
  ) => _call(
    (c) => c.teaching.saveAnswers(
      _id(course),
      _id(id),
      _id(attempt),
      answers,
      finish,
    ),
  );
  @override
  Future<api.TeachingActivityView> release(String course, String id) =>
      _call((c) => c.teaching.releaseTest(_id(course), _id(id)));
}
