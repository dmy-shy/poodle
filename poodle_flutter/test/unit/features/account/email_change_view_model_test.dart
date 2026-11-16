import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/features/account/presentation/view_models/email_change_view_model.dart';

class _EmailRepository extends FakeAuthRepository {
  final startResult = Completer<PendingEmailChange>();
  String? email;
  int starts = 0;

  @override
  Future<PendingEmailChange> startEmailChange({
    required String email,
    required String currentPassword,
    String locale = 'en',
  }) {
    this.email = email;
    starts++;
    return startResult.future;
  }

  @override
  Future<void> confirmEmailChange(String code) async =>
      throw AuthFailure.invalidCredentials;
}

void main() {
  test('blocks duplicate sends and reports a failed confirmation', () async {
    final repo = _EmailRepository();
    final model = EmailChangeViewModel(repo);
    addTearDown(repo.dispose);
    addTearDown(model.dispose);
    final operation = model.start(' name@example.org ', 'password', 'uk');
    await model.start('duplicate@example.org', 'password', 'en');
    expect(repo.starts, 1);
    expect(repo.email, 'name@example.org');
    expect(model.busy, isTrue);

    repo.startResult.complete(
      PendingEmailChange(
        id: 'pending',
        email: repo.email!,
        expiresAt: DateTime.utc(2026, 11, 16, 1),
        resendAvailableAt: DateTime.utc(2026, 11, 16),
      ),
    );
    await operation;
    expect(model.sent, isTrue);
    expect(await model.confirm('wrong'), isFalse);
    expect(model.failure, AuthFailure.invalidCredentials);
    expect(model.busy, isFalse);
  });
}
