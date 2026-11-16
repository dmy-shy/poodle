import '../../../../data/repositories/student_grades_repository.dart';

class StudentGradesViewModel {
  StudentGradesViewModel(this._repository) {
    reload();
  }

  final StudentGradesRepository _repository;
  late Future<StudentGradesResponse> _result;
  Future<StudentGradesResponse> get result => _result;

  Future<StudentGradesResponse> reload() => _result = _repository.listGrades();
}
