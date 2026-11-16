import 'package:serverpod_auth_idp_server/core.dart';
import 'package:poodle_server/src/auth/transactional_email.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:poodle_server/src/modules/identity/institution_mail.dart';
import 'package:poodle_server/src/modules/identity/platform_operator_bootstrap.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Operator bootstrap recovery', (builder, _) {
    late Session session;
    final recipients = <String>[];
    setUp(() {
      session = builder.build();
      addTearDown(session.close);
      recipients.clear();
      TransactionalEmail.testDelivery =
          ({
            required email,
            required subject,
            required text,
            required key,
          }) async {
            recipients.add(email);
          };
    });
    tearDown(() => TransactionalEmail.testDelivery = null);

    test('revoked bootstrap invitation can be replaced', () async {
      const email = 'revoked-operator@example.test';
      await AccountInvitation.db.insertRow(
        session,
        AccountInvitation(
          email: email,
          purpose: 'platformOperator',
          revokedAt: DateTime.now().toUtc(),
          expiresAt: DateTime.now().toUtc().add(const Duration(days: 1)),
        ),
      );
      await PlatformOperatorBootstrap.ensure(session, email);
      expect(await InstitutionMail.deliverPending(session), 1);
      expect(recipients, [email]);
    });

    test(
      'an existing operator suppresses bootstrap for a different mailbox',
      () async {
        final user = await AuthUser.db.insertRow(
          session,
          AuthUser(scopeNames: {}),
        );
        await AccountAccess.db.insertRow(
          session,
          AccountAccess(authUserId: user.id!, isAdmin: true),
        );
        await PlatformOperatorBootstrap.ensure(
          session,
          'second-operator@example.test',
        );
        expect(await InstitutionMail.deliverPending(session), 0);
        expect(recipients, isEmpty);
      },
    );

    test(
      'expired bootstrap invitation can be reissued without duplicate delivery',
      () async {
        const email = 'operator@example.test';
        await AccountInvitation.db.insertRow(
          session,
          AccountInvitation(
            email: email,
            purpose: 'platformOperator',
            expiresAt: DateTime.now().toUtc().subtract(const Duration(days: 1)),
          ),
        );
        await PlatformOperatorBootstrap.ensure(session, email);
        await PlatformOperatorBootstrap.ensure(session, email);
        expect(await InstitutionMail.deliverPending(session), 1);
        expect(recipients, [email]);
        expect(await InstitutionMail.deliverPending(session), 0);
      },
    );
  });
}
