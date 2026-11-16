import 'package:flutter/foundation.dart';

class AuthSession {
  const AuthSession(
    this.email, {
    this.userId,
    this.isAdmin = false,
    this.universityId,
    this.isUniversityAdmin = false,
    this.googleLinked = false,
    this.hasPassword = false,
    this.teacherApproved = false,
    this.offline = false,
  });
  final String email;
  final String? userId;
  final bool isAdmin;
  final String? universityId;
  final bool isUniversityAdmin;
  final bool googleLinked;
  final bool hasPassword;
  final bool teacherApproved;
  final bool offline;
}

enum AuthFailure {
  invalidCredentials,
  network,
  storage,
  forbidden,
  invalidCode,
  passwordPolicy,
  unavailable,
  cancelled,
  googleProofInvalid,
  googleLinkRequired,
  googleEmailMismatch,
  googleLinkConflict,
  invitationUnavailable,
  emailUnavailable,
  emailChangeExpired,
  emailChangeThrottled,
  passwordUnavailable,
}

enum AuthLifecycle { restoring, signedOut, signedIn, unavailable, signingOut }

class TeacherInvitation {
  const TeacherInvitation({
    required this.id,
    required this.email,
    required this.expiresAt,
    this.acceptedAt,
    this.revokedAt,
  });
  final String id;
  final String email;
  final DateTime expiresAt;
  final DateTime? acceptedAt;
  final DateTime? revokedAt;
}

class PendingEmailChange {
  const PendingEmailChange({
    required this.id,
    required this.email,
    required this.expiresAt,
    required this.resendAvailableAt,
  });
  final String id;
  final String email;
  final DateTime expiresAt;
  final DateTime resendAvailableAt;
}

/// Application boundary for live authentication and explicit preview fakes.
abstract class AuthRepository extends ChangeNotifier {
  AuthSession? get session;
  bool get isPreview => true;
  AuthLifecycle get lifecycle =>
      session == null ? AuthLifecycle.signedOut : AuthLifecycle.signedIn;
  AuthFailure? get startupFailure => null;
  AuthFailure? get logoutFailure => null;
  Future<AuthSession?> restoreSession();
  Future<void> signInWithEmail({
    required String email,
    required String password,
    required bool rememberMe,
  });
  bool get googleAvailable => isPreview;
  Future<void> signInWithGoogle({bool rememberMe = false});
  Future<void> linkGoogle() async => throw AuthFailure.unavailable;
  Future<void> requestPasswordReset(String email);
  Future<void> signOut();
  Future<void> requestInvitation(String email) =>
      throw UnsupportedError('Preview');
  Future<void> verifyInvitation(String code) =>
      throw UnsupportedError('Preview');
  Future<void> completeInvitation(
    String password, {
    required bool rememberMe,
  }) => throw UnsupportedError('Preview');
  Future<void> verifyPasswordReset(String code) =>
      throw UnsupportedError('Preview');
  Future<void> completePasswordReset(String password) =>
      throw UnsupportedError('Preview');
  void cancelVerification() {}
  Future<AuthSession> refreshAccount() => throw UnsupportedError('Preview');
  Future<List<TeacherInvitation>> listInvitations({int offset = 0}) =>
      throw UnsupportedError('Preview');
  Future<void> createInvitation(String email) =>
      throw UnsupportedError('Preview');
  Future<void> revokeInvitation(String id) => throw UnsupportedError('Preview');
  Future<PendingEmailChange?> pendingEmailChange() =>
      throw UnsupportedError('Preview');
  Future<PendingEmailChange> startEmailChange({
    required String email,
    required String currentPassword,
    String locale = 'en',
  }) => throw UnsupportedError('Preview');
  Future<PendingEmailChange> resendEmailChange() =>
      throw UnsupportedError('Preview');
  Future<void> confirmEmailChange(String code) =>
      throw UnsupportedError('Preview');
  Future<void> cancelEmailChange() => throw UnsupportedError('Preview');
}
