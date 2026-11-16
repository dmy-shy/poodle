import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/features/auth/presentation/view_models/login_view_model.dart';

void main() {
  test(
    'preference controls preserve validation and authentication errors',
    () async {
      final repository = FakeAuthRepository(
        latency: Duration.zero,
        emailFailure: AuthFailure.invalidCredentials,
      );
      final model = LoginViewModel(repository);
      addTearDown(model.dispose);
      addTearDown(repository.dispose);
      await model.submitEmail('', '');
      model.setRememberMe(true);
      model.togglePassword();
      expect(model.state.emailIssue, EmailIssue.required);
      expect(model.state.passwordMissing, isTrue);
      await model.submitEmail('student@example.com', 'pass');
      model.togglePassword();
      expect(model.state.error, AuthFailure.invalidCredentials);
    },
  );
  test('invalid fields show validation without creating a session', () async {
    final repository = FakeAuthRepository(latency: Duration.zero);
    final model = LoginViewModel(repository);
    addTearDown(model.dispose);
    addTearDown(repository.dispose);
    await model.submitEmail('not-an-email', '');
    expect(model.state.emailIssue, EmailIssue.invalid);
    expect(model.state.passwordMissing, isTrue);
    expect(repository.session, isNull);
  });
  test(
    'email submission trims the email, preserves remember choice, and ignores duplicate submissions',
    () async {
      final repository = FakeAuthRepository(latency: Duration.zero);
      final model = LoginViewModel(repository);
      addTearDown(model.dispose);
      addTearDown(repository.dispose);
      model.setRememberMe(true);
      final pending = model.submitEmail(
        '  student@example.com  ',
        ' pass word ',
      );
      expect(model.state.busy, isTrue);
      await model.submitEmail('duplicate@example.com', 'different');
      await pending;
      expect(repository.session?.email, 'student@example.com');
      expect(repository.rememberMe, isTrue);
      expect(model.state.busy, isFalse);
    },
  );
  test(
    'failed email login can retry and Google cancellation returns to idle',
    () async {
      final repository = FakeAuthRepository(
        latency: Duration.zero,
        emailFailure: AuthFailure.invalidCredentials,
        cancelGoogle: true,
      );
      final model = LoginViewModel(repository);
      addTearDown(model.dispose);
      addTearDown(repository.dispose);
      await model.submitEmail('student@example.com', 'pass');
      expect(model.state.error, AuthFailure.invalidCredentials);
      expect(model.state.busy, isFalse);
      await model.submitGoogle();
      expect(model.state.error, isNull);
      expect(model.state.busy, isFalse);
      expect(repository.session, isNull);
      repository.emailFailure = null;
      await model.submitEmail('student@example.com', 'pass');
      expect(repository.session, isNotNull);
    },
  );
}
