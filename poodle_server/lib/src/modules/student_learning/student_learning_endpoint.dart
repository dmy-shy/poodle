import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import 'student_learning_service.dart';

class StudentLearningEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = StudentLearningService();

  Future<StudentTasksResponse> listTasks(Session session) =>
      _service.listTasks(session);

  Future<StudentGradesResponse> listGrades(Session session) =>
      _service.listGrades(session);
}
