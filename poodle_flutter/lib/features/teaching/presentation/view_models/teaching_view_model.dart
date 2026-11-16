import 'package:flutter/foundation.dart';
import '../../../../data/repositories/teaching_repository.dart';

/// Discards work after session changes and exposes server-confirmed state only.
class TeachingViewModel<T> extends ChangeNotifier {
  TeachingViewModel(this.repository, this.loader) {
    repository.addListener(_changed);
  }
  final TeachingRepository repository;
  final Future<T> Function() loader;
  T? value;
  DateTime receivedAt = DateTime.now().toUtc();
  bool busy = false;
  String? error;
  bool _disposed = false;
  void _changed() {
    value = null;
    error = null;
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<bool> run(Future<T> Function() operation) async {
    if (busy || _disposed) return false;
    final epoch = repository.generation;
    busy = true;
    error = null;
    _notify();
    try {
      final next = await operation();
      if (!_disposed && epoch == repository.generation) {
        value = next;
        receivedAt = DateTime.now().toUtc();
        return true;
      }
    } catch (e) {
      if (!_disposed && epoch == repository.generation) {
        error = e is TeachingFailure ? e.code : 'unavailable';
      }
    } finally {
      busy = false;
      _notify();
    }
    return false;
  }

  Future<void> load() async {
    await run(loader);
  }

  @override
  void dispose() {
    _disposed = true;
    repository.removeListener(_changed);
    super.dispose();
  }
}
