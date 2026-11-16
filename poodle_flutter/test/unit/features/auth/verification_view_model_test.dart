import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/features/auth/presentation/view_models/verification_view_model.dart';
import '../../../support/live_auth_fixture.dart';

void main() {
  test(
    'invitation validates each step and only signs in after password completion',
    () async {
      final repository = LiveAuthFixture();
      final model = VerificationViewModel(repository, reset: false);
      addTearDown(repository.dispose);
      addTearDown(model.dispose);
      await model.submit('bad');
      expect(model.step, VerificationStep.email);
      expect(model.emailIssue, isNotNull);
      await model.submit(' member@example.test ');
      expect(repository.requestedEmail, 'member@example.test');
      expect(model.step, VerificationStep.code);
      await model.submit('');
      expect(model.error, AuthFailure.invalidCode);
      await model.submit('valid-code');
      expect(model.step, VerificationStep.password);
      await model.submit('short', confirmation: 'short');
      expect(model.error, AuthFailure.passwordPolicy);
      await model.submit('Long-password', confirmation: 'different');
      expect(model.mismatch, isTrue);
      expect(repository.session, isNull);
      await model.submit('Long-password', confirmation: 'Long-password');
      expect(repository.session?.email, 'member@example.test');
      expect(model.step, VerificationStep.done);
    },
  );

  test(
    'reset failures remain retryable and proofs are cleared on cancel',
    () async {
      final repository = LiveAuthFixture();
      final model = VerificationViewModel(repository, reset: true);
      addTearDown(repository.dispose);
      await model.submit('member@example.test');
      repository.verificationFailure = AuthFailure.invalidCode;
      await model.submit('bad');
      expect(model.step, VerificationStep.code);
      expect(model.error, AuthFailure.invalidCode);
      repository.verificationFailure = null;
      await model.submit('valid');
      await model.submit('Long-password', confirmation: 'Long-password');
      expect(repository.resets, 1);
      expect(repository.session, isNull);
      model.startOver();
      expect(model.step, VerificationStep.email);
      model.dispose();
      expect(repository.cancellations, 2);
    },
  );
}
