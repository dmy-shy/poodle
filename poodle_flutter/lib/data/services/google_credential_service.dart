import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../repositories/auth_repository.dart';

abstract class GoogleCredentialService {
  bool get available;
  Future<String> acquire();
  Future<void> signOut();
}

class NativeGoogleCredentialService implements GoogleCredentialService {
  static Future<void>? _initialization;
  @override
  bool get available =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  @override
  Future<String> acquire() async {
    if (!available) throw AuthFailure.unavailable;
    try {
      // The native SDK reads the app's bundled OAuth configuration.
      await (_initialization ??= GoogleSignIn.instance.initialize());
      final user = await GoogleSignIn.instance.authenticate();
      final token = user.authentication.idToken;
      if (token == null) throw AuthFailure.googleProofInvalid;
      return token;
    } on GoogleSignInException catch (error) {
      if (error.code != GoogleSignInExceptionCode.canceled && kDebugMode) {
        debugPrint('Google sign-in failed (${error.code.name}).');
      }
      throw error.code == GoogleSignInExceptionCode.canceled
          ? AuthFailure.cancelled
          : AuthFailure.unavailable;
    }
  }

  @override
  Future<void> signOut() async {
    if (_initialization != null) await GoogleSignIn.instance.signOut();
  }
}
