import 'package:flutter/foundation.dart';
import '../../../../data/repositories/auth_repository.dart';
import 'login_view_model.dart';

@immutable
class ResetState {
  const ResetState({
    this.busy = false,
    this.sent = false,
    this.emailIssue,
    this.error,
  });
  final bool busy;
  final bool sent;
  final EmailIssue? emailIssue;
  final AuthFailure? error;
}

class ResetViewModel extends ChangeNotifier {
  ResetViewModel(this._repository);
  final AuthRepository _repository;
  ResetState _state = const ResetState();
  ResetState get state => _state;
  bool _disposed = false;

  void _emit(ResetState state) {
    if (_disposed) return;
    _state = state;
    notifyListeners();
  }

  Future<void> submit(String email) async {
    if (_state.busy || _state.sent) return;
    final issue = validateEmail(email);
    if (issue != null) {
      _emit(ResetState(emailIssue: issue));
      return;
    }
    _emit(const ResetState(busy: true));
    try {
      await _repository.requestPasswordReset(email.trim());
      _emit(const ResetState(sent: true));
    } on AuthFailure catch (error) {
      _emit(ResetState(error: error));
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
