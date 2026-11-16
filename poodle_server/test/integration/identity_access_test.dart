import 'package:poodle_server/src/generated/protocol.dart';
import 'package:poodle_server/src/modules/identity/identity_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Identity access persistence', (builder, endpoints) {
    late Session session;
    late UuidValue issuer;
    setUp(() async {
      session = builder.build();
      addTearDown(() => session.close());
      issuer = (await const AuthUsers().create(session)).id;
    });

    test(
      'creates and consumes an invitation with account access atomically',
      () async {
        final invitation = await IdentityService.createInvitation(
          session,
          email: 'Invited@Example.test',
          issuerId: issuer,
        );
        final user = (await const AuthUsers().create(session)).id;
        await session.db.transaction(
          (tx) => IdentityService.acceptInvitation(
            session,
            email: 'invited@example.test',
            authUserId: user,
            transaction: tx,
          ),
        );
        final access = await AccountAccess.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(user),
        );
        expect(access?.teacherApproved, isTrue);
        expect(access?.isAdmin, isFalse);
        final accepted = await AccountInvitation.db.findById(
          session,
          invitation.id,
        );
        expect(accepted?.acceptedById, user);
        expect(accepted?.acceptedAt, isNotNull);
        await expectLater(
          session.db.transaction(
            (tx) => IdentityService.acceptInvitation(
              session,
              email: 'invited@example.test',
              authUserId: user,
              transaction: tx,
            ),
          ),
          throwsA(isA<IdentityAccessException>()),
        );
      },
    );

    test('duplicate active invites reuse the existing invitation', () async {
      final first = await IdentityService.createInvitation(
        session,
        email: 'same@example.test',
        issuerId: issuer,
      );
      final second = await IdentityService.createInvitation(
        session,
        email: ' SAME@example.test ',
        issuerId: issuer,
      );
      expect(second.id, first.id);
    });

    test('final acceptance rejects a revoked invitation', () async {
      final invitation = await IdentityService.createInvitation(
        session,
        email: 'revoked@example.test',
        issuerId: issuer,
      );
      await IdentityService.revokeInvitation(session, invitation.id);
      final user = (await const AuthUsers().create(session)).id;
      await expectLater(
        session.db.transaction(
          (tx) => IdentityService.acceptInvitation(
            session,
            email: 'revoked@example.test',
            authUserId: user,
            transaction: tx,
          ),
        ),
        throwsA(isA<IdentityAccessException>()),
      );
      expect(
        await AccountAccess.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(user),
        ),
        isNull,
      );
    });

    test('anonymous account and admin endpoints reject access', () async {
      await expectLater(endpoints.account.me(builder), throwsA(anything));
      await expectLater(
        endpoints.adminInvitations.list(builder, limit: 20, offset: 0),
        throwsA(anything),
      );
    });
  });
}
