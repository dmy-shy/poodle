import 'package:poodle_server/src/auth/identity_auth_config.dart';
import 'package:poodle_server/src/modules/identity/development_admin_seed.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

class UnusedSession implements Session {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('Unexpected session access');
}

void main() {
  test('bootstrap permits development and explicit test fixtures only', () {
    expect(
      DevelopmentAdminSeed.allowedMode(ServerpodRunMode.development),
      isTrue,
    );
    expect(DevelopmentAdminSeed.allowedMode(ServerpodRunMode.test), isFalse);
    expect(
      DevelopmentAdminSeed.allowedMode(
        ServerpodRunMode.test,
        testFixture: true,
      ),
      isTrue,
    );
    for (final mode in [
      ServerpodRunMode.staging,
      ServerpodRunMode.production,
    ]) {
      expect(DevelopmentAdminSeed.allowedMode(mode), isFalse);
      expect(
        DevelopmentAdminSeed.allowedMode(mode, testFixture: true),
        isFalse,
      );
    }
  });

  test(
    'test verification delivery is captured without logging or real email',
    () async {
      final codes = <String>[];
      final config = identityEmailConfig(
        pepper: 'test-only-pepper',
        runMode: ServerpodRunMode.test,
        delivery:
            ({required email, required code, required passwordReset}) async {
              codes.add('$passwordReset:$email:$code');
            },
      );
      await config.sendRegistrationVerificationCode!(
        UnusedSession(),
        email: 'member@example.test',
        accountRequestId: const Uuid().v7obj(),
        verificationCode: 'captured',
        transaction: null,
      );
      await config.sendPasswordResetVerificationCode!(
        UnusedSession(),
        email: 'member@example.test',
        passwordResetRequestId: const Uuid().v7obj(),
        verificationCode: 'captured-reset',
        transaction: null,
      );
      expect(codes, [
        'false:member@example.test:captured',
        'true:member@example.test:captured-reset',
      ]);
    },
  );

  test('nondevelopment environments never fall back to code logging', () async {
    for (final mode in [
      ServerpodRunMode.test,
      ServerpodRunMode.staging,
      ServerpodRunMode.production,
    ]) {
      final config = identityEmailConfig(
        pepper: 'test-only-pepper',
        runMode: mode,
      );
      await expectLater(
        config.sendRegistrationVerificationCode!(
          UnusedSession(),
          email: 'member@example.test',
          accountRequestId: const Uuid().v7obj(),
          verificationCode: 'must-not-log',
          transaction: null,
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'failure',
            'Email delivery is not configured for this environment.',
          ),
        ),
      );
    }
  });
}
