import 'identity_locks.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import '../../auth/transactional_email.dart';
import 'identity_policy.dart';
import 'identity_service.dart';

/// Replaces a signed-in account's Poodle email after a fresh password proof.
/// The current address remains authoritative until [confirm] consumes the code.
abstract final class AccountEmailService {
  static const _lifetime = Duration(minutes: 15);
  static const _maxCodeAttempts = 3;

  static Future<PendingEmailChangeSummary?> pending(Session session) async {
    final account = await AccountAuthorization.requireAccount(session);
    final request = await PendingEmailChange.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(account.authUserId),
    );
    if (request == null) return null;
    if (!DateTime.now().toUtc().isBefore(request.expiresAt)) {
      await PendingEmailChange.db.deleteRow(session, request);
      return null;
    }
    return _summary(request);
  }

  static Future<PendingEmailChangeSummary> start(
    Session session, {
    required String newEmail,
    required String currentPassword,
    String locale = 'en',
  }) async {
    final account = await AccountAuthorization.requireAccount(session);
    final normalized = IdentityPolicy.normalizeEmail(newEmail);
    if (locale != 'uk') locale = 'en';
    final now = DateTime.now().toUtc();
    return session.db.transaction((tx) async {
      await IdentityLocks.email(
        session,
        account.authUserId.toString(),
        tx,
      );
      await IdentityLocks.email(session, normalized, tx);
      final access = await AccountAccess.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(account.authUserId),
        transaction: tx,
      );
      final emailAccount = await EmailAccount.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(account.authUserId),
        transaction: tx,
      );
      if (access == null || emailAccount == null) {
        throw IdentityAccessException(code: 'passwordUnavailable');
      }
      if (normalized == account.email) {
        throw IdentityAccessException(code: 'emailUnchanged');
      }
      await AuthServices.instance.emailIdp.utils.authentication.authenticate(
        session,
        email: emailAccount.email,
        password: currentPassword,
        transaction: tx,
      );
      if (await IdentityService.emailOwnedByOther(
        session,
        normalized,
        except: account.authUserId,
        transaction: tx,
      )) {
        throw IdentityAccessException(code: 'emailUnavailable');
      }
      await PendingEmailChange.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(account.authUserId),
        transaction: tx,
      );
      final code = IdentityService.newVerificationCode();
      final request = await PendingEmailChange.db.insertRow(
        session,
        PendingEmailChange(
          authUserId: account.authUserId,
          requestedEmail: normalized,
          verificationCodeHash: IdentityService.verificationCodeHash(code),
          credentialVersion: access.credentialVersion,
          expiresAt: now.add(_lifetime),
          resendAvailableAt: IdentityService.resendAvailableAt(now),
          locale: locale,
        ),
        transaction: tx,
      );
      await TransactionalEmail.sendCode(
        session,
        email: normalized,
        code: code,
        purpose: 'email',
        requestId: request.id!.toString(),
        locale: locale,
        expiresAt: request.expiresAt,
      );
      return _summary(request);
    });
  }

  static Future<PendingEmailChangeSummary> resend(Session session) async {
    final account = await AccountAuthorization.requireAccount(session);
    final now = DateTime.now().toUtc();
    return session.db.transaction((tx) async {
      await IdentityLocks.email(session, account.authUserId.toString(), tx);
      final request = await PendingEmailChange.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(account.authUserId),
        transaction: tx,
      );
      if (request == null || !now.isBefore(request.expiresAt)) {
        throw IdentityAccessException(code: 'emailChangeExpired');
      }
      if (now.isBefore(request.resendAvailableAt)) {
        throw IdentityAccessException(code: 'emailChangeThrottled');
      }
      final code = IdentityService.newVerificationCode();
      final updated = request.copyWith(
        verificationCodeHash: IdentityService.verificationCodeHash(code),
        verificationAttempts: 0,
        resendAvailableAt: IdentityService.resendAvailableAt(now),
      );
      await PendingEmailChange.db.updateRow(session, updated, transaction: tx);
      await TransactionalEmail.sendCode(
        session,
        email: updated.requestedEmail,
        code: code,
        purpose: 'email',
        requestId: updated.id!.toString(),
        locale: updated.locale,
        expiresAt: updated.expiresAt,
      );
      return _summary(updated);
    });
  }

  static Future<void> cancel(Session session) async {
    final account = await AccountAuthorization.requireAccount(session);
    await PendingEmailChange.db.deleteWhere(
      session,
      where: (t) => t.authUserId.equals(account.authUserId),
    );
  }

  static Future<void> confirm(Session session, {required String code}) async {
    final account = await AccountAuthorization.requireAccount(session);
    final now = DateTime.now().toUtc();
    await session.db.transaction((tx) async {
      await IdentityLocks.email(
        session,
        account.authUserId.toString(),
        tx,
      );
      final request = await PendingEmailChange.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(account.authUserId),
        transaction: tx,
      );
      final access = await AccountAccess.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(account.authUserId),
        transaction: tx,
      );
      if (request == null ||
          access == null ||
          !now.isBefore(request.expiresAt)) {
        throw IdentityAccessException(code: 'emailChangeExpired');
      }
      if (request.credentialVersion != access.credentialVersion ||
          request.verificationAttempts >= _maxCodeAttempts) {
        throw IdentityAccessException(code: 'emailChangeInvalid');
      }
      if (request.verificationCodeHash !=
          IdentityService.verificationCodeHash(code.trim())) {
        await PendingEmailChange.db.updateRow(
          session,
          request.copyWith(
            verificationAttempts: request.verificationAttempts + 1,
          ),
          transaction: tx,
        );
        throw IdentityAccessException(code: 'emailChangeInvalid');
      }
      await IdentityLocks.email(session, request.requestedEmail, tx);
      if (await IdentityService.emailOwnedByOther(
        session,
        request.requestedEmail,
        except: account.authUserId,
        transaction: tx,
      )) {
        throw IdentityAccessException(code: 'emailUnavailable');
      }
      final emailAccount = await EmailAccount.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(account.authUserId),
        transaction: tx,
      );
      if (emailAccount != null) {
        await EmailAccount.db.updateRow(
          session,
          emailAccount.copyWith(email: request.requestedEmail),
          transaction: tx,
        );
      }
      await AccountAccess.db.updateRow(
        session,
        access.copyWith(
          verifiedEmail: request.requestedEmail,
          credentialVersion: access.credentialVersion + 1,
        ),
        transaction: tx,
      );
      await PendingEmailChange.db.deleteRow(session, request, transaction: tx);
      await AuthServices.instance.tokenManager.revokeAllTokens(
        session,
        authUserId: account.authUserId,
        transaction: tx,
      );
    });
  }

  static PendingEmailChangeSummary _summary(PendingEmailChange request) =>
      PendingEmailChangeSummary(
        id: request.id!,
        requestedEmail: request.requestedEmail,
        expiresAt: request.expiresAt,
        resendAvailableAt: request.resendAvailableAt,
      );
}
