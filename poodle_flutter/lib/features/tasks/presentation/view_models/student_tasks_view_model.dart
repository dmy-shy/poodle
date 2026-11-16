import 'package:flutter/foundation.dart';
import 'package:poodle_client/poodle_client.dart';

import '../../../../data/repositories/student_tasks_repository.dart';

class StudentTasksViewModel extends ChangeNotifier {
  StudentTasksViewModel(this._repository);

  final StudentTasksRepository _repository;
  StudentTasksResponse? _response;
  String? _courseId;
  bool _failed = false;
  bool _loading = false;
  bool _disposed = false;

  bool get failed => _failed;
  bool get loading => _loading;
  String? get courseId => _courseId;

  Map<String, String> get courses => Map.fromEntries(
    (_response?.tasks ?? const <StudentTaskRow>[])
        .map((task) => MapEntry(task.courseId.toString(), task.courseTitle))
        .toList()
      ..sort((a, b) {
        final byTitle = a.value.compareTo(b.value);
        return byTitle == 0 ? a.key.compareTo(b.key) : byTitle;
      }),
  );

  List<StudentTaskRow> get overdue => _group(upcoming: false);
  List<StudentTaskRow> get upcoming => _group(upcoming: true);

  List<StudentTaskRow> _group({required bool upcoming}) {
    final response = _response;
    if (response == null) return const [];
    return [
      for (final task in response.tasks)
        if ((_courseId == null || task.courseId.toString() == _courseId) &&
            task.deadline.isAfter(response.serverTime) == upcoming)
          task,
    ];
  }

  void filter(String? courseId) {
    _courseId = courseId;
    notifyListeners();
  }

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    _failed = false;
    notifyListeners();
    try {
      final response = await _repository.listTasks();
      if (_disposed) return;
      _response = response;
      if (!courses.containsKey(_courseId)) _courseId = null;
    } catch (_) {
      if (_disposed) return;
      _response = null;
      _failed = true;
    } finally {
      if (!_disposed) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
