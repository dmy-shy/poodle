import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/features/account/presentation/view_models/account_view_model.dart';
import '../../support/live_auth_fixture.dart';

void main() {
  test(
    'fresh account projection controls admin UI without fabricating roles',
    () async {
      final repository = LiveAuthFixture(
        restoredSession: const AuthSession('member@example.test'),
      );
      final account = AccountViewModel(repository);
      final invitations = InvitationsViewModel(repository);
      addTearDown(repository.dispose);
      addTearDown(account.dispose);
      addTearDown(invitations.dispose);
      await account.load();
      expect(account.account?.isAdmin, isFalse);
      await invitations.create('teacher@example.test');
      expect(invitations.error, AuthFailure.forbidden);
      expect(repository.adminWrites, 0);
    },
  );
  test(
    'admin create, pagination and revoke reload current invitations',
    () async {
      final repository = LiveAuthFixture(
        restoredSession: const AuthSession('admin@example.test', isAdmin: true),
      );
      final model = InvitationsViewModel(repository);
      addTearDown(repository.dispose);
      addTearDown(model.dispose);
      await model.load();
      await model.create(' teacher@example.test ');
      expect(model.invitations.single.email, 'teacher@example.test');
      expect(model.created, isTrue);
      await model.page(1);
      expect(model.offset, 20);
      expect(model.invitations, isEmpty);
      await model.page(-1);
      await model.revoke('1');
      expect(model.invitations, isEmpty);
      expect(repository.adminWrites, 2);
    },
  );
}
