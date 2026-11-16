import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/app/preview_scenarios.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';

void main() {
  test(
    'preview scenarios expose deterministic errors, cancellation, and restored sessions',
    () async {
      for (final scenario in [
        'normal',
        'invalidCredentials',
        'networkFailure',
        'googleCancelled',
        'resetFailure',
        'restoredSession',
      ]) {
        final repository = createPreviewRepository(
          scenario,
          latency: Duration.zero,
        );
        addTearDown(repository.dispose);
        switch (scenario) {
          case 'invalidCredentials':
            await expectLater(
              repository.signInWithEmail(
                email: 'a@b.co',
                password: 'pass',
                rememberMe: false,
              ),
              throwsA(AuthFailure.invalidCredentials),
            );
          case 'networkFailure':
            await expectLater(
              repository.signInWithGoogle(),
              throwsA(AuthFailure.network),
            );
          case 'googleCancelled':
            await repository.signInWithGoogle();
            expect(repository.session, isNull);
          case 'resetFailure':
            await expectLater(
              repository.requestPasswordReset('a@b.co'),
              throwsA(AuthFailure.network),
            );
          case 'restoredSession':
            expect(
              (await repository.restoreSession())?.email,
              'learner@example.com',
            );
          case 'normal':
            expect(await repository.restoreSession(), isNull);
        }
      }
      expect(() => createPreviewRepository('typo'), throwsArgumentError);
    },
  );
}
