import 'identity_locks.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import '../../generated/protocol.dart';
import 'identity_policy.dart';
import 'identity_service.dart';

/// Explicit local bootstrap. Administrative password policy exceptions never
/// affect registration/reset. Existing accounts are never promoted or reset.
abstract final class DevelopmentAdminSeed {
  static bool allowedMode(String mode, {bool testFixture = false}) =>
      mode == ServerpodRunMode.development ||
      (mode == ServerpodRunMode.test && testFixture);

  static Future<void> ensure(
    Session session, {
    required String email,
    required String password,
    bool testFixture = false,
  }) async {
    final mode = session.serverpod.runMode;
    if (!allowedMode(mode, testFixture: testFixture)) {
      throw StateError(
        'Development bootstrap is not allowed in this environment.',
      );
    }
    final normalized = IdentityPolicy.normalizeEmail(email);
    if (password.isEmpty) {
      throw ArgumentError('Bootstrap password is required.');
    }
    await session.db.transaction((tx) async {
      await IdentityLocks.email(session, 'bootstrap', tx);
      await IdentityLocks.email(session, normalized, tx);
      if (await IdentityService.emailOwnedByOther(
        session,
        normalized,
        transaction: tx,
      )) {
        final google = await GoogleAccount.db.findFirstRow(
          session,
          where: (t) => t.email.equals(normalized),
          transaction: tx,
        );
        if (google != null) {
          throw StateError('Bootstrap email collides with Google identity.');
        }
      }
      final existing = await EmailAccount.db.findFirstRow(
        session,
        where: (t) => t.email.equals(normalized),
        transaction: tx,
      );
      if (existing != null) {
        final access = await AccountAccess.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(existing.authUserId),
          transaction: tx,
        );
        if (access?.developmentBootstrap != true) {
          throw StateError(
            'Bootstrap email collides with an existing account.',
          );
        }
        return;
      }
      // Keep a marker even if an operator removed only the email login.
      if (await AccountAccess.db.findFirstRow(
            session,
            where: (t) => t.developmentBootstrap.equals(true),
            transaction: tx,
          ) !=
          null) {
        throw StateError(
          'Bootstrap identity already exists; operator resolution is required.',
        );
      }
      final user = await AuthServices.instance.authUsers.create(
        session,
        transaction: tx,
      );
      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: user.id,
        email: normalized,
        password: password,
        transaction: tx,
      );
      await AccountAccess.db.insertRow(
        session,
        AccountAccess(
          authUserId: user.id,
          isAdmin: true,
          developmentBootstrap: true,
          verifiedEmail: normalized,
        ),
        transaction: tx,
      );
    });
  }

  static Future<void> fromLocalConfig(Serverpod pod) async {
    if (pod.runMode != ServerpodRunMode.development) return;
    final email = pod.getPassword('poodleDevelopmentAdminEmail');
    final password = pod.getPassword('poodleDevelopmentAdminPassword');
    if (email == null && password == null) return;
    if (email == null || password == null) {
      throw StateError('Incomplete development bootstrap configuration.');
    }
    final session = await pod.createSession();
    try {
      await ensure(session, email: email, password: password);
    } finally {
      await session.close();
    }
  }
}
