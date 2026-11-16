import 'package:flutter/foundation.dart';
import '../../../../data/repositories/institution_repository.dart';

class AdministratorRequestViewModel extends ChangeNotifier {
  AdministratorRequestViewModel(this._repository);
  final InstitutionRepository _repository;
  bool busy = false, submitted = false;
  String? requestId, error;
  bool _disposed = false;
  Map<String, String>? _fields;
  Future<void> send(Map<String, String> fields) => _run(() async {
    requestId = await _repository.requestAdministrator(fields);
    _fields = Map.unmodifiable(fields);
  });
  Future<void> resend() => _run(() async {
    if (_fields == null) return;
    requestId = await _repository.requestAdministrator(_fields!);
  });
  void changeEmail() {
    if (busy || _disposed) return;
    requestId = null;
    _fields = null;
    error = null;
    notifyListeners();
  }

  Future<void> verify(String code) => _run(() async {
    if (requestId == null || code.trim().isEmpty) {
      throw const InstitutionProblem('invalidCode');
    }
    await _repository.verifyAdministrator(requestId!, code.trim());
    submitted = true;
  });
  Future<void> _run(Future<void> Function() action) async {
    if (busy || _disposed) return;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } on InstitutionProblem catch (e) {
      error = e.code;
    } catch (_) {
      error = 'unavailable';
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
