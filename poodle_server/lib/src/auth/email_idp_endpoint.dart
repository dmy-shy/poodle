import '../modules/identity/identity_locks.dart';
import 'dart:convert';
import 'email_delivery_context.dart';

import 'package:serverpod_auth_idp_server/providers/google.dart';
import '../core/account_authorization.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import '../generated/protocol.dart';
import '../modules/identity/identity_policy.dart';
import '../modules/identity/identity_service.dart';

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  static final _requests = DatabaseRateLimiter(
    RateLimiterConfig(
      domain: 'poodle.identity',
      source: 'registration',
      maxAttempts: 3,
      timeframe: const Duration(hours: 1),
    ),
  );

  @override
  Future<AuthSuccess> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    return session.db.transaction((tx) async {
      final success = await emailIdp.login(
        session,
        email: email.trim(),
        password: password,
        transaction: tx,
      );
      final access = await AccountAccess.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(success.authUserId),
        transaction: tx,
      );
      if (access == null) {
        throw EmailAccountLoginException(
          reason: EmailAccountLoginExceptionReason.invalidCredentials,
        );
      }
      return success;
    });
  }

  @override
  Future<UuidValue> startRegistration(
    Session session, {
    required String email,
    String? locale,
  }) async {
    final normalized = IdentityPolicy.normalizeEmail(email);
    // Record the same budget regardless of invitation/account existence.
    if (!await _requests.tryRecordAttempt(session, key: normalized) ||
        await IdentityService.activeInvitation(session, normalized) == null) {
      return const Uuid().v7obj();
    }
    return EmailDeliveryContext.run(
      locale ?? 'en',
      () => super.startRegistration(session, email: normalized),
    );
  }

  // Verification and completion use the SDK's proof validation. The configured
  // onAfterAccountCreated hook consumes the invitation in that same transaction.
  @override
  Future<UuidValue> startPasswordReset(
    Session session, {
    required String email,
    String? locale,
  }) async {
    try {
      return await EmailDeliveryContext.run(
        locale ?? 'en',
        () => super.startPasswordReset(
          session,
          email: IdentityPolicy.normalizeEmail(email),
        ),
      );
    } on EmailAccountPasswordResetException catch (error) {
      if (error.reason !=
          EmailAccountPasswordResetExceptionReason.tooManyAttempts) {
        rethrow;
      }
      return const Uuid().v7obj();
    }
  }

  Future<GoogleAccountDetails> _verify(Session session, String token) async {
    GoogleIdp? provider;
    try {
      provider = AuthServices.instance.googleIdp;
      return await provider.utils.fetchAccountDetails(
        session,
        idToken: token,
        accessToken: null,
      );
    } catch (error) {
      if (session.serverpod.runMode == ServerpodRunMode.development) {
        final audience = provider?.config.clientSecret.clientId;
        final diagnostic = audience == null
            ? 'provider not registered; Google credential loaded: '
                  '${session.serverpod.getPassword('googleClientSecret')?.trim().isNotEmpty ?? false}'
            : 'provider registered; ${_googleProofDiagnostic(token, audience)}';
        session.log(
          'Google verification rejected (${error.runtimeType}): $diagnostic.',
          level: LogLevel.warning,
        );
      }
      throw IdentityAccessException(code: 'googleProofInvalid');
    }
  }

  // Unverified claims are only used for diagnostics. Never log their values.
  String _googleProofDiagnostic(String token, String expectedAudience) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return 'malformed token';
      final claims =
          jsonDecode(
                utf8.decode(
                  base64Url.decode(
                    base64Url.normalize(parts[1]),
                  ),
                ),
              )
              as Map<String, dynamic>;
      final audience = claims['aud'];
      if (audience != expectedAudience &&
          !(audience is List && audience.contains(expectedAudience))) {
        return 'audience mismatch';
      }
      if (claims['email_verified'] != true) return 'email not verified';
      return 'audience matches and email is marked verified';
    } on Object {
      return 'malformed token';
    }
  }

  Future<void> _lock(Session session, String key, Transaction tx) async {
    await session.db.unsafeQuery(
      'SELECT pg_advisory_xact_lock(hashtextextended(@key, 0))',
      parameters: QueryParameters.named({'key': 'poodle.google:$key'}),
      transaction: tx,
    );
  }

  Future<AuthSuccess> googleLogin(
    Session session, {
    required String idToken,
  }) async {
    final details = await _verify(session, idToken);
    final email = IdentityPolicy.normalizeEmail(details.email);
    return session.db.transaction((tx) async {
      await _lock(session, details.userIdentifier, tx);
      await IdentityLocks.email(session, email, tx);
      final linked = await GoogleAccount.db.findFirstRow(
        session,
        where: (t) => t.userIdentifier.equals(details.userIdentifier),
        transaction: tx,
      );
      UuidValue userId;
      if (linked != null) {
        userId = linked.authUserId;
      } else {
        if (await IdentityService.emailOwnedByOther(
          session,
          email,
          transaction: tx,
        )) {
          throw IdentityAccessException(code: 'googleLinkRequired');
        }
        final user = await AuthServices.instance.authUsers.create(
          session,
          transaction: tx,
        );
        userId = user.id;
        await IdentityService.acceptInvitation(
          session,
          email: email,
          authUserId: userId,
          transaction: tx,
        );
        await AuthServices.instance.googleIdp.utils.linkGoogleAuthentication(
          session,
          authUserId: userId,
          accountDetails: details,
          transaction: tx,
        );
      }
      final user = await AuthUser.db.findById(session, userId, transaction: tx);
      final access = await AccountAccess.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(userId),
        transaction: tx,
      );
      if (user == null || user.blocked || access == null) {
        throw IdentityAccessException(code: 'forbidden');
      }
      return AuthServices.instance.tokenManager.issueToken(
        session,
        authUserId: userId,
        method: 'google',
        transaction: tx,
      );
    });
  }

  Future<void> linkGoogle(Session session, {required String idToken}) async {
    await AccountAuthorization.requireAccount(session);
    final details = await _verify(session, idToken);
    await session.db.transaction((tx) async {
      await _lock(session, details.userIdentifier, tx);
      final account = await AccountAuthorization.requireAccount(session);
      await IdentityLocks.email(session, account.email, tx);
      await _lock(session, account.authUserId.toString(), tx);
      if (IdentityPolicy.normalizeEmail(details.email) != account.email) {
        throw IdentityAccessException(code: 'googleEmailMismatch');
      }
      final subject = await GoogleAccount.db.findFirstRow(
        session,
        where: (t) => t.userIdentifier.equals(details.userIdentifier),
        transaction: tx,
      );
      final existing = await GoogleAccount.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(account.authUserId),
        transaction: tx,
      );
      if (subject != null && subject.authUserId == account.authUserId) return;
      if (subject != null || existing != null) {
        throw IdentityAccessException(code: 'googleLinkConflict');
      }
      await AuthServices.instance.googleIdp.utils.linkGoogleAuthentication(
        session,
        authUserId: account.authUserId,
        accountDetails: details,
        transaction: tx,
      );
    });
  }
}
