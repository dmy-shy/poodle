import 'auth_repository.dart';

/// Preview-only authentication. No passwords, tokens, or sessions are persisted.
class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository({
    this.latency = const Duration(milliseconds: 700),
    AuthSession? restoredSession,
    this.emailFailure,
    this.googleFailure,
    this.resetFailure,
    this.cancelGoogle = false,
  }) : _session = restoredSession;
  final Duration latency;
  AuthSession? _session;
  bool rememberMe = false;
  AuthFailure? emailFailure;
  AuthFailure? googleFailure;
  AuthFailure? resetFailure;
  bool cancelGoogle;

  @override
  AuthSession? get session => _session;

  @override
  Future<AuthSession?> restoreSession() async => _session;

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    await Future<void>.delayed(latency);
    if (emailFailure case final failure?) throw failure;
    this.rememberMe = rememberMe;
    _session = AuthSession(email);
    notifyListeners();
  }

  @override
  Future<void> signInWithGoogle({bool rememberMe = false}) async {
    this.rememberMe = rememberMe;
    await Future<void>.delayed(latency);
    if (googleFailure case final failure?) throw failure;
    if (cancelGoogle) return;
    _session = const AuthSession('learner@example.com');
    notifyListeners();
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await Future<void>.delayed(latency);
    if (resetFailure case final failure?) throw failure;
  }

  @override
  Future<void> signOut() async {
    _session = null;
    rememberMe = false;
    notifyListeners();
  }
}
