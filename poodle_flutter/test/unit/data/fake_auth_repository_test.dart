import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';

void main() {
  test(
    'preview email login restores a demo session and sign-out clears it',
    () async {
      final repository = FakeAuthRepository(latency: Duration.zero);
      addTearDown(repository.dispose);
      await repository.signInWithEmail(
        email: 'student@example.com',
        password: ' preview password ',
        rememberMe: true,
      );
      expect((await repository.restoreSession())?.email, 'student@example.com');
      expect(repository.rememberMe, isTrue);
      await repository.signOut();
      expect(await repository.restoreSession(), isNull);
    },
  );
  test('configured failures leave the session empty and allow retry', () async {
    final repository = FakeAuthRepository(
      latency: Duration.zero,
      emailFailure: AuthFailure.invalidCredentials,
    );
    addTearDown(repository.dispose);
    await expectLater(
      repository.signInWithEmail(
        email: 'student@example.com',
        password: 'anything',
        rememberMe: false,
      ),
      throwsA(AuthFailure.invalidCredentials),
    );
    expect(repository.session, isNull);
    repository.emailFailure = null;
    await repository.signInWithEmail(
      email: 'student@example.com',
      password: 'anything',
      rememberMe: false,
    );
    expect(repository.session?.email, 'student@example.com');
  });
  test('cancelled Google sign-in leaves the session empty', () async {
    final repository = FakeAuthRepository(
      latency: Duration.zero,
      cancelGoogle: true,
    );
    addTearDown(repository.dispose);
    await repository.signInWithGoogle();
    expect(repository.session, isNull);
  });
}
