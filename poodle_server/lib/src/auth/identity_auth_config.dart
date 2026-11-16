import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import '../generated/protocol.dart';
import '../modules/identity/identity_policy.dart';
import '../modules/identity/identity_service.dart';
import 'transactional_email.dart';
import 'email_delivery_context.dart';

typedef VerificationDelivery =
    Future<void> Function({
      required String email,
      required String code,
      required bool passwordReset,
    });

/// Uses SDK verification and hashing; only delivery and app access are customized.
EmailIdpConfig identityEmailConfig({
  required String pepper,
  required String runMode,
  VerificationDelivery? delivery,
}) {
  const verificationLifetime = Duration(minutes: 15);
  Future<void> send(
    Session session,
    String email,
    String code,
    bool reset,
    UuidValue requestId,
    Transaction? transaction,
  ) async {
    if (runMode == ServerpodRunMode.test && delivery != null) {
      await delivery(email: email, code: code, passwordReset: reset);
    } else if (runMode != ServerpodRunMode.development &&
        !TransactionalEmail.configured) {
      throw StateError(
        'Email delivery is not configured for this environment.',
      );
    } else {
      final createdAt = reset
          ? (await EmailAccountPasswordResetRequest.db.findById(
              session,
              requestId,
              transaction: transaction,
            ))?.createdAt
          : (await EmailAccountRequest.db.findById(
              session,
              requestId,
              transaction: transaction,
            ))?.createdAt;
      if (createdAt == null) {
        throw StateError('Verification request is unavailable.');
      }
      await TransactionalEmail.sendCode(
        session,
        email: email,
        code: code,
        purpose: reset ? 'reset' : 'registration',
        requestId: requestId.toString(),
        expiresAt: createdAt.add(verificationLifetime),
        locale: EmailDeliveryContext.locale,
      );
    }
  }

  return EmailIdpConfig(
    secretHashPepper: pepper,
    registrationVerificationCodeGenerator: IdentityService.newVerificationCode,
    passwordResetVerificationCodeGenerator: IdentityService.newVerificationCode,
    registrationVerificationCodeLifetime: verificationLifetime,
    passwordResetVerificationCodeLifetime: verificationLifetime,
    sendRegistrationVerificationCode:
        (
          session, {
          required email,
          required accountRequestId,
          required verificationCode,
          required transaction,
        }) => send(
          session,
          email,
          verificationCode,
          false,
          accountRequestId,
          transaction,
        ),
    sendPasswordResetVerificationCode:
        (
          session, {
          required email,
          required passwordResetRequestId,
          required verificationCode,
          required transaction,
        }) => send(
          session,
          email,
          verificationCode,
          true,
          passwordResetRequestId,
          transaction,
        ),
    onAfterAccountCreated:
        (
          session, {
          required email,
          required authUserId,
          required emailAccountId,
          required transaction,
        }) async {
          if (transaction == null) {
            throw StateError('Account creation requires a transaction.');
          }
          await IdentityService.acceptInvitation(
            session,
            email: email,
            authUserId: authUserId,
            transaction: transaction,
          );
          final access = await AccountAccess.db.findFirstRow(
            session,
            where: (t) => t.authUserId.equals(authUserId),
            transaction: transaction,
          );
          if (access != null && access.verifiedEmail == null) {
            await AccountAccess.db.updateRow(
              session,
              access.copyWith(
                verifiedEmail: IdentityPolicy.normalizeEmail(email),
              ),
              transaction: transaction,
            );
          }
        },
    onPasswordResetCompleted:
        (session, {required emailAccountId, required transaction}) async {
          final account = await EmailAccount.db.findById(
            session,
            emailAccountId,
            transaction: transaction,
          );
          if (account == null) {
            throw StateError('Reset account is unavailable.');
          }
          await AuthServices.instance.tokenManager.revokeAllTokens(
            session,
            authUserId: account.authUserId,
            transaction: transaction,
          );
          final access = await AccountAccess.db.findFirstRow(
            session,
            where: (t) => t.authUserId.equals(account.authUserId),
            transaction: transaction,
          );
          if (access != null) {
            await AccountAccess.db.updateRow(
              session,
              access.copyWith(credentialVersion: access.credentialVersion + 1),
              transaction: transaction,
            );
            await PendingEmailChange.db.deleteWhere(
              session,
              where: (t) => t.authUserId.equals(account.authUserId),
              transaction: transaction,
            );
          }
        },
  );
}
