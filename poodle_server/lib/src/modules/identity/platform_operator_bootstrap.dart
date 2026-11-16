import 'identity_locks.dart';
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import 'identity_policy.dart';
import 'identity_service.dart';
import 'institution_mail.dart';

/// Explicit deployment opt-in. Never promotes an existing account by email.
abstract final class PlatformOperatorBootstrap {
  static Future<void> fromConfig(Serverpod pod) async {
    final configured = pod.getPassword('initialPlatformOperatorEmail')?.trim();
    if (configured == null || configured.isEmpty) return;
    final email = IdentityPolicy.normalizeEmail(configured);
    final session = await pod.createSession();
    try {
      await ensure(session, email);
    } finally {
      await session.close();
    }
  }

  /// Startup boundary, also used by deployment recovery verification.
  static Future<void> ensure(Session session, String configuredEmail) async {
    final email = IdentityPolicy.normalizeEmail(configuredEmail);
    await session.db.transaction((tx) async {
      await IdentityLocks.email(session, email, tx);
      await IdentityLocks.operatorBootstrap(session, tx);
      if (await AccountAccess.db.count(
            session,
            where: (t) => t.isAdmin.equals(true),
            transaction: tx,
          ) !=
          0) {
        return;
      }
      if (await AccountInvitation.db.findFirstRow(
            session,
            where: (t) =>
                t.purpose.equals('platformOperator') &
                t.email.equals(email) &
                t.acceptedAt.equals(null) &
                t.revokedAt.equals(null) &
                (t.expiresAt > DateTime.now().toUtc()),
            transaction: tx,
          ) !=
          null) {
        return;
      }
      if (await IdentityService.emailOwnedByOther(
        session,
        email,
        transaction: tx,
      )) {
        throw StateError(
          'Operator bootstrap requires an unregistered email.',
        );
      }
      final invitation = await AccountInvitation.db.insertRow(
        session,
        AccountInvitation(
          email: email,
          purpose: 'platformOperator',
          expiresAt: IdentityPolicy.invitationExpiry(DateTime.now().toUtc()),
        ),
        transaction: tx,
      );
      await InstitutionMail.queue(
        session,
        key: 'operator-bootstrap:${invitation.id}',
        email: email,
        subject: 'Poodle — platform operator invitation',
        body: InstitutionMail.invitationBody(
          email,
          'Poodle',
          'platformOperator',
        ),
        transaction: tx,
      );
    });
  }
}
