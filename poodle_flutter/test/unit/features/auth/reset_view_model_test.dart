import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/features/auth/presentation/view_models/login_view_model.dart';
import 'package:poodle_flutter/features/auth/presentation/view_models/reset_view_model.dart';

void main() {
  test(
    'reset validates email, exposes failure, and confirms a successful retry',
    () async {
      final repository = FakeAuthRepository(
        latency: Duration.zero,
        resetFailure: AuthFailure.network,
      );
      final model = ResetViewModel(repository);
      addTearDown(model.dispose);
      addTearDown(repository.dispose);
      await model.submit('');
      expect(model.state.emailIssue, EmailIssue.required);
      await model.submit('student@example.com');
      expect(model.state.error, AuthFailure.network);
      expect(model.state.sent, isFalse);
      repository.resetFailure = null;
      final pending = model.submit('student@example.com');
      expect(model.state.busy, isTrue);
      await pending;
      expect(model.state.sent, isTrue);
      expect(model.state.error, isNull);
    },
  );
}
