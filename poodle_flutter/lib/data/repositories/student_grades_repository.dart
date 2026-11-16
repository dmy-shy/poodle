import 'package:poodle_client/poodle_client.dart';
import '../services/serverpod_auth_gateway.dart';

export 'package:poodle_client/poodle_client.dart'
    show StudentGradeRow, StudentGradeCourse, StudentGradesResponse;

abstract class StudentGradesRepository {
  Future<StudentGradesResponse> listGrades();
}

class ServerpodStudentGradesRepository implements StudentGradesRepository {
  ServerpodStudentGradesRepository(this.gateway);
  final ServerpodAuthGateway gateway;

  @override
  Future<StudentGradesResponse> listGrades() =>
      gateway.withClient((client) => client.studentLearning.listGrades());
}
