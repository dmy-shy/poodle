import 'package:flutter/foundation.dart';
import '../../../../data/repositories/auth_repository.dart';

class AccountViewModel extends ChangeNotifier {
  AccountViewModel(this._repository);
  final AuthRepository _repository;
  AuthSession? account;
  AuthFailure? error;
  bool busy = false;
  bool _disposed = false;
  bool get googleAvailable => _repository.googleAvailable;
  Future<void> linkGoogle() async {
    if (busy || _disposed) return;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await _repository.linkGoogle();
      if (!_disposed) account = _repository.session;
    } on AuthFailure catch (failure) {
      if (!_disposed && failure != AuthFailure.cancelled) error = failure;
    } finally {
      if (!_disposed) {
        busy = false;
        notifyListeners();
      }
    }
  }

  Future<void> load() async {
    if (busy) return;
    if (_repository.isPreview) {
      account = _repository.session;
      error = null;
      notifyListeners();
      return;
    }
    busy = true;
    error = null;
    notifyListeners();
    try {
      final result = await _repository.refreshAccount();
      if (!_disposed) account = result;
    } on AuthFailure catch (failure) {
      if (!_disposed) error = failure;
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

class InvitationsViewModel extends ChangeNotifier {
  InvitationsViewModel(this._repository);
  final AuthRepository _repository;
  List<TeacherInvitation> invitations = [];
  AuthFailure? error;
  bool busy = false;
  bool created = false;
  int offset = 0;
  bool _disposed = false;

  Future<void> _run(Future<void> Function() operation) async {
    if (busy || _disposed) return;
    busy = true;
    error = null;
    notifyListeners();
    try {
      final account = await _repository.refreshAccount();
      if (_disposed) return;
      if (!account.isAdmin) throw AuthFailure.forbidden;
      await operation();
    } on AuthFailure catch (failure) {
      if (!_disposed) error = failure;
    } finally {
      if (!_disposed) {
        busy = false;
        notifyListeners();
      }
    }
  }

  Future<void> _fetch() async {
    final result = await _repository.listInvitations(offset: offset);
    if (!_disposed) invitations = result;
  }

  Future<void> load() => _run(_fetch);
  Future<void> create(String email) => _run(() async {
    await _repository.createInvitation(email.trim());
    if (_disposed) return;
    created = true;
    offset = 0;
    await _fetch();
  });
  Future<void> revoke(String id) => _run(() async {
    await _repository.revokeInvitation(id);
    if (!_disposed) await _fetch();
  });
  Future<void> page(int delta) => _run(() async {
    offset = (offset + delta * 20).clamp(0, 1 << 30);
    await _fetch();
  });
  @override
  void dispose() {
    _disposed = true;
    invitations = [];
    super.dispose();
  }
}
