import 'package:flutter/foundation.dart';

import '../../../../data/repositories/auth_repository.dart';

class EmailChangeViewModel extends ChangeNotifier {
  EmailChangeViewModel(this._repository);

  final AuthRepository _repository;
  bool _disposed = false;
  bool sent = false;
  bool busy = false;
  AuthFailure? failure;

  Future<void> start(String email, String password, String locale) async {
    if (await _run(() async {
          await _repository.startEmailChange(
            email: email.trim(),
            currentPassword: password,
            locale: locale,
          );
        }) &&
        !_disposed) {
      sent = true;
      notifyListeners();
    }
  }

  Future<bool> confirm(String code) =>
      _run(() => _repository.confirmEmailChange(code));

  Future<void> resend() async {
    await _run(() async {
      await _repository.resendEmailChange();
    });
  }

  Future<bool> cancel() async =>
      !sent || await _run(_repository.cancelEmailChange, clearFailure: false);

  Future<bool> _run(
    Future<void> Function() operation, {
    bool clearFailure = true,
  }) async {
    if (busy || _disposed) return false;
    busy = true;
    if (clearFailure) failure = null;
    notifyListeners();
    try {
      await operation();
      return !_disposed;
    } on AuthFailure catch (error) {
      if (!_disposed) failure = error;
      return false;
    } finally {
      if (!_disposed) {
        busy = false;
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
