import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';

/// Explicit test double for live-only screens; never used by app compositions.
class LiveAuthFixture extends FakeAuthRepository {
  LiveAuthFixture({super.restoredSession}) : super(latency: Duration.zero);
  bool googleConfigured = false;
  @override
  bool get googleAvailable => googleConfigured;
  bool failStartup = false;
  bool _unavailable = false;
  int cancellations = 0;
  int resets = 0;
  int adminWrites = 0;
  String? requestedEmail;
  AuthFailure? verificationFailure;
  final invitations = <TeacherInvitation>[];
  @override
  bool get isPreview => false;
  @override
  AuthLifecycle get lifecycle =>
      _unavailable ? AuthLifecycle.unavailable : super.lifecycle;
  @override
  AuthFailure? get startupFailure => _unavailable ? AuthFailure.network : null;
  @override
  Future<AuthSession?> restoreSession() async {
    _unavailable = failStartup;
    notifyListeners();
    return _unavailable ? null : session;
  }

  @override
  Future<void> requestInvitation(String email) async {
    requestedEmail = email;
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    requestedEmail = email;
  }

  @override
  Future<void> verifyInvitation(String code) async {
    if (verificationFailure case final failure?) throw failure;
  }

  @override
  Future<void> verifyPasswordReset(String code) => verifyInvitation(code);
  @override
  Future<void> completeInvitation(
    String password, {
    required bool rememberMe,
  }) => signInWithEmail(
    email: requestedEmail!,
    password: password,
    rememberMe: rememberMe,
  );
  @override
  Future<void> completePasswordReset(String password) async {
    resets++;
  }

  @override
  void cancelVerification() {
    cancellations++;
  }

  @override
  Future<AuthSession> refreshAccount() async => session!;
  @override
  Future<List<TeacherInvitation>> listInvitations({int offset = 0}) async =>
      invitations.skip(offset).take(20).toList();
  @override
  Future<void> createInvitation(String email) async {
    adminWrites++;
    invitations.add(
      TeacherInvitation(
        id: '$adminWrites',
        email: email,
        expiresAt: DateTime.now().toUtc().add(const Duration(days: 7)),
      ),
    );
  }

  @override
  Future<void> revokeInvitation(String id) async {
    adminWrites++;
    invitations.removeWhere((item) => item.id == id);
  }
}
