import '../services/auth_gateway.dart';
import 'auth_repository.dart';

class LiveAuthRepository extends AuthRepository {
  LiveAuthRepository(this._gateway) {
    _gateway.addListener(_credentialsChanged);
  }
  final AuthGateway _gateway;
  AuthSession? _session;
  AuthLifecycle _lifecycle = AuthLifecycle.restoring;
  AuthFailure? _startupFailure;
  AuthFailure? _logoutFailure;
  int _generation = 0;
  bool _disposed = false;
  @override
  bool get isPreview => false;
  @override
  AuthSession? get session => _session;
  @override
  AuthLifecycle get lifecycle => _lifecycle;
  @override
  AuthFailure? get startupFailure => _startupFailure;
  @override
  AuthFailure? get logoutFailure => _logoutFailure;

  void _emit() {
    if (!_disposed) notifyListeners();
  }

  void _credentialsChanged() {
    if (_session != null && !_gateway.hasCredentials) {
      ++_generation;
      _session = null;
      _lifecycle = AuthLifecycle.signedOut;
      _emit();
    }
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final generation = ++_generation;
    _lifecycle = AuthLifecycle.restoring;
    _startupFailure = null;
    _emit();
    try {
      final restored = await _gateway.restore();
      if (generation != _generation || _disposed) return null;
      _session = restored;
      _lifecycle = restored == null
          ? AuthLifecycle.signedOut
          : AuthLifecycle.signedIn;
    } on AuthFailure catch (error) {
      if (generation != _generation || _disposed) return null;
      _session = null;
      if (error == AuthFailure.invalidCredentials) {
        try {
          await _gateway.discard();
        } on AuthFailure catch (cleanupFailure) {
          if (generation != _generation || _disposed) return null;
          _startupFailure = cleanupFailure;
          _lifecycle = AuthLifecycle.unavailable;
          _emit();
          return null;
        }
        if (generation != _generation || _disposed) return null;
        _lifecycle = AuthLifecycle.signedOut;
      } else {
        _startupFailure = error;
        _lifecycle = AuthLifecycle.unavailable;
      }
    } catch (_) {
      if (generation != _generation || _disposed) return null;
      _session = null;
      _startupFailure = AuthFailure.unavailable;
      _lifecycle = AuthLifecycle.unavailable;
    }
    _emit();
    return _session;
  }

  Future<void> _signIn(Future<AuthSession> Function() operation) async {
    final generation = ++_generation;
    _logoutFailure = null;
    try {
      final account = await operation();
      if (generation != _generation || _disposed) return;
      _session = account;
      _lifecycle = AuthLifecycle.signedIn;
      _emit();
    } on AuthFailure {
      if (generation != _generation || _disposed) return;
      _session = null;
      _lifecycle = AuthLifecycle.signedOut;
      _emit();
      rethrow;
    }
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
    required bool rememberMe,
  }) => _signIn(() => _gateway.login(email, password, rememberMe));
  @override
  Future<void> signInWithGoogle({bool rememberMe = false}) =>
      _signIn(() => _gateway.loginGoogle(rememberMe));
  @override
  bool get googleAvailable => _gateway.googleAvailable;
  @override
  Future<void> linkGoogle() async {
    final generation = _generation;
    final account = await _gateway.linkGoogle();
    if (generation != _generation || _disposed) return;
    _session = account;
    _emit();
  }

  @override
  Future<void> signOut() async {
    final generation = ++_generation;
    _session = null;
    _lifecycle = AuthLifecycle.signingOut;
    _logoutFailure = null;
    cancelVerification();
    _emit();
    try {
      if (!await _gateway.logout()) _logoutFailure = AuthFailure.network;
    } on AuthFailure catch (error) {
      _logoutFailure = error;
    } finally {
      try {
        await _gateway.discard();
      } on AuthFailure catch (error) {
        _logoutFailure = error;
      }
      if (generation == _generation && !_disposed) {
        _lifecycle = AuthLifecycle.signedOut;
        _emit();
      }
    }
  }

  @override
  Future<void> requestPasswordReset(String email) =>
      _gateway.requestCode(email, reset: true);
  @override
  Future<void> requestInvitation(String email) =>
      _gateway.requestCode(email, reset: false);
  @override
  Future<void> verifyPasswordReset(String code) =>
      _gateway.verifyCode(code, reset: true);
  @override
  Future<void> verifyInvitation(String code) =>
      _gateway.verifyCode(code, reset: false);
  @override
  Future<void> completePasswordReset(String password) =>
      _gateway.resetPassword(password);
  @override
  Future<void> completeInvitation(
    String password, {
    required bool rememberMe,
  }) => _signIn(() => _gateway.register(password, rememberMe));
  @override
  void cancelVerification() => _gateway.cancelVerification();
  @override
  Future<AuthSession> refreshAccount() async {
    final generation = _generation;
    final account = await _gateway.account();
    if (generation != _generation || _disposed) throw AuthFailure.cancelled;
    _session = account;
    _emit();
    return account;
  }

  @override
  Future<List<TeacherInvitation>> listInvitations({int offset = 0}) =>
      _gateway.invitations(offset);
  @override
  Future<void> createInvitation(String email) => _gateway.invite(email);
  @override
  Future<void> revokeInvitation(String id) => _gateway.revoke(id);
  @override
  Future<PendingEmailChange?> pendingEmailChange() =>
      _gateway.pendingEmailChange();
  @override
  Future<PendingEmailChange> startEmailChange({
    required String email,
    required String currentPassword,
    String locale = 'en',
  }) => _gateway.startEmailChange(
    email: email,
    currentPassword: currentPassword,
    locale: locale,
  );
  @override
  Future<PendingEmailChange> resendEmailChange() =>
      _gateway.resendEmailChange();
  @override
  Future<void> confirmEmailChange(String code) async {
    await _gateway.confirmEmailChange(code);
    await signOut();
  }

  @override
  Future<void> cancelEmailChange() => _gateway.cancelEmailChange();
  @override
  void dispose() {
    ++_generation;
    _disposed = true;
    _gateway.removeListener(_credentialsChanged);
    _gateway.cancelVerification();
    _gateway.dispose();
    super.dispose();
  }
}
