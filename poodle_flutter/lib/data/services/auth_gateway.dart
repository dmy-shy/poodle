import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';

/// SDK boundary. Raw credentials never cross into application session state.
abstract class AuthGateway extends ChangeNotifier {
  bool get hasCredentials;
  bool get googleAvailable => false;
  Future<AuthSession> loginGoogle(bool rememberMe) async =>
      throw AuthFailure.unavailable;
  Future<AuthSession> linkGoogle() async => throw AuthFailure.unavailable;
  Future<AuthSession?> restore();
  Future<AuthSession> login(String email, String password, bool rememberMe);
  Future<bool> logout();
  Future<void> discard();
  Future<void> requestCode(String email, {required bool reset});
  Future<void> verifyCode(String code, {required bool reset});
  Future<AuthSession> register(String password, bool rememberMe);
  Future<void> resetPassword(String password);
  void cancelVerification();
  Future<AuthSession> account();
  Future<List<TeacherInvitation>> invitations(int offset);
  Future<void> invite(String email);
  Future<void> revoke(String id);
  Future<PendingEmailChange?> pendingEmailChange();
  Future<PendingEmailChange> startEmailChange({
    required String email,
    required String currentPassword,
    required String locale,
  });
  Future<PendingEmailChange> resendEmailChange();
  Future<void> confirmEmailChange(String code);
  Future<void> cancelEmailChange();
}
