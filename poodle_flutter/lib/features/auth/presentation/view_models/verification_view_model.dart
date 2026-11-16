import 'package:flutter/foundation.dart';
import '../../../../data/repositories/auth_repository.dart';
import 'login_view_model.dart';

enum VerificationStep { email, code, password, done }

class VerificationViewModel extends ChangeNotifier {
  VerificationViewModel(this._repository, {required this.reset});
  final AuthRepository _repository;
  final bool reset;
  VerificationStep step = VerificationStep.email;
  bool busy = false;
  bool rememberMe = false;
  bool mismatch = false;
  EmailIssue? emailIssue;
  AuthFailure? error;
  bool _disposed = false;

  Future<void> submit(String value, {String? confirmation}) async {
    if (busy || _disposed || step == VerificationStep.done) return;
    emailIssue = null;
    error = null;
    mismatch = false;
    if (step == VerificationStep.email) {
      emailIssue = validateEmail(value);
    } else if (step == VerificationStep.code && value.trim().isEmpty) {
      error = AuthFailure.invalidCode;
    } else if (step == VerificationStep.password) {
      if (value.length < 8 || value != value.trim()) {
        error = AuthFailure.passwordPolicy;
      }
      mismatch = value != confirmation;
    }
    if (emailIssue != null || error != null || mismatch) {
      notifyListeners();
      return;
    }
    busy = true;
    notifyListeners();
    final current = step;
    try {
      switch (current) {
        case VerificationStep.email:
          if (reset) {
            await _repository.requestPasswordReset(value.trim());
          } else {
            await _repository.requestInvitation(value.trim());
          }
        case VerificationStep.code:
          if (reset) {
            await _repository.verifyPasswordReset(value.trim());
          } else {
            await _repository.verifyInvitation(value.trim());
          }
        case VerificationStep.password:
          if (reset) {
            await _repository.completePasswordReset(value);
          } else {
            await _repository.completeInvitation(value, rememberMe: rememberMe);
          }
        case VerificationStep.done:
          return;
      }
      if (!_disposed) step = VerificationStep.values[current.index + 1];
    } on AuthFailure catch (failure) {
      if (!_disposed) error = failure;
    } finally {
      if (!_disposed) {
        busy = false;
        notifyListeners();
      }
    }
  }

  void startOver() {
    if (busy) return;
    _repository.cancelVerification();
    step = VerificationStep.email;
    error = null;
    emailIssue = null;
    mismatch = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _repository.cancelVerification();
    super.dispose();
  }
}
