import 'package:flutter/foundation.dart';
import '../../../../data/repositories/institution_repository.dart';

class TeacherCoursesViewModel extends ChangeNotifier {
  TeacherCoursesViewModel(this._repository, {this.onChanged});
  final InstitutionRepository _repository;
  final VoidCallback? onChanged;
  List<ManagedCourse> courses = [];
  bool busy = false, sent = false, _disposed = false;
  String? error;
  Future<void> _load() async {
    final result = await _repository.courses();
    if (!_disposed) courses = result;
  }

  Future<void> load() => _run(_load);
  Future<void> create(String title) => _run(() async {
    final name = title.trim();
    if (name.isEmpty || name.length > 200) {
      throw const InstitutionProblem('invalidCourseTitle');
    }
    await _repository.createCourse(name);
    onChanged?.call();
    await _load();
  });
  Future<void> publish(String id, bool published) => _run(() async {
    await _repository.publish(id, published);
    onChanged?.call();
    await _load();
  });
  Future<void> invite(String courseId, String email) => _run(() async {
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim())) {
      throw const InstitutionProblem('invalid_input');
    }
    await _repository.invite(email.trim(), 'student', courseId: courseId);
    sent = true;
  });
  Future<void> _run(Future<void> Function() action) async {
    if (busy || _disposed) return;
    busy = true;
    error = null;
    sent = false;
    notifyListeners();
    try {
      await action();
    } on InstitutionProblem catch (e) {
      if (!_disposed) error = e.code;
    } catch (_) {
      if (!_disposed) error = 'unavailable';
    }
    if (!_disposed) {
      busy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
