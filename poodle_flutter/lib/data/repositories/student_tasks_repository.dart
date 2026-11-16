import 'package:poodle_client/poodle_client.dart';

import '../services/serverpod_auth_gateway.dart';

abstract interface class StudentTasksRepository {
  Future<StudentTasksResponse> listTasks();
}

class ServerpodStudentTasksRepository implements StudentTasksRepository {
  const ServerpodStudentTasksRepository(this._gateway);
  final ServerpodAuthGateway _gateway;

  @override
  Future<StudentTasksResponse> listTasks() =>
      _gateway.withClient((client) => client.studentLearning.listTasks());
}
