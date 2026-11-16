import 'package:flutter/foundation.dart';
import '../../../../data/repositories/auth_repository.dart';

enum EmailIssue { required, invalid }

enum AuthAction { idle, email, google }

EmailIssue? validateEmail(String email) {
  if (email.trim().isEmpty) return EmailIssue.required;
  return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim())
      ? null
      : EmailIssue.invalid;
}

@immutable
class LoginState {
  const LoginState({
    this.action = AuthAction.idle,
    this.rememberMe = false,
    this.passwordVisible = false,
    this.emailIssue,
    this.passwordMissing = false,
    this.error,
  });
  final AuthAction action;
  final bool rememberMe;
  final bool passwordVisible;
  final EmailIssue? emailIssue;
  final bool passwordMissing;
  final AuthFailure? error;
  bool get busy => action != AuthAction.idle;
}

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this._repository);
  final AuthRepository _repository;
  bool get googleAvailable => _repository.googleAvailable;
  bool get isPreview => _repository.isPreview;
  AuthFailure? get logoutFailure => _repository.logoutFailure;
  Future<void> retrySignOut() => _repository.signOut();
  LoginState _state = const LoginState();
  LoginState get state => _state;
  bool _disposed = false;

  void _emit({
    AuthAction action = AuthAction.idle,
    bool? rememberMe,
    bool? passwordVisible,
    EmailIssue? emailIssue,
    bool passwordMissing = false,
    AuthFailure? error,
    bool preserveFeedback = false,
  }) {
    if (_disposed) return;
    _state = LoginState(
      action: action,
      rememberMe: rememberMe ?? _state.rememberMe,
      passwordVisible: passwordVisible ?? _state.passwordVisible,
      emailIssue: preserveFeedback ? _state.emailIssue : emailIssue,
      passwordMissing: preserveFeedback
          ? _state.passwordMissing
          : passwordMissing,
      error: preserveFeedback ? _state.error : error,
    );
    notifyListeners();
  }

  void setRememberMe(bool value) {
    if (!_state.busy) _emit(rememberMe: value, preserveFeedback: true);
  }

  void togglePassword() {
    if (!_state.busy) {
      _emit(passwordVisible: !_state.passwordVisible, preserveFeedback: true);
    }
  }

  Future<void> submitGoogle() async {
    if (_state.busy) return;
    _emit(action: AuthAction.google);
    try {
      await _repository.signInWithGoogle(rememberMe: _state.rememberMe);
      _emit();
    } on AuthFailure catch (error) {
      _emit(error: error == AuthFailure.cancelled ? null : error);
    }
  }

  Future<void> submitEmail(String email, String password) async {
    if (_state.busy) return;
    final issue = validateEmail(email);
    if (issue != null || password.isEmpty) {
      _emit(emailIssue: issue, passwordMissing: password.isEmpty);
      return;
    }
    _emit(action: AuthAction.email);
    try {
      await _repository.signInWithEmail(
        email: email.trim(),
        password: password,
        rememberMe: _state.rememberMe,
      );
      _emit();
    } on AuthFailure catch (error) {
      _emit(error: error == AuthFailure.cancelled ? null : error);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
