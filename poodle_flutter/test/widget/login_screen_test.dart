import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/features/auth/presentation/view_models/login_view_model.dart';
import 'package:poodle_flutter/features/auth/presentation/views/login_screen.dart';
import '../support/test_app.dart';

void main() {
  testWidgets(
    'login validates input and offers only Google as a social provider',
    (tester) async {
      final repository = FakeAuthRepository(latency: Duration.zero);
      final model = LoginViewModel(repository);
      addTearDown(model.dispose);
      addTearDown(repository.dispose);
      await tester.pumpWidget(
        testApp(
          ChangeNotifierProvider.value(
            value: model,
            child: const LoginScreen(),
          ),
        ),
      );
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.textContaining('Facebook'), findsNothing);
      await tester.ensureVisible(find.text('Log in'));
      await tester.tap(find.text('Log in'));
      await tester.pump();
      expect(find.text('Enter your email address.'), findsOneWidget);
      expect(find.text('Enter your password.'), findsOneWidget);
      expect(repository.session, isNull);
    },
  );
  testWidgets('password visibility and remember-me controls respond to taps', (
    tester,
  ) async {
    final repository = FakeAuthRepository(latency: Duration.zero);
    final model = LoginViewModel(repository);
    addTearDown(model.dispose);
    addTearDown(repository.dispose);
    await tester.pumpWidget(
      testApp(
        ChangeNotifierProvider.value(value: model, child: const LoginScreen()),
      ),
    );
    await tester.enterText(
      find.byKey(const ValueKey('password')),
      'my password',
    );
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(find.byTooltip('Hide password'), findsOneWidget);
    await tester.ensureVisible(find.text('Remember me'));
    await tester.tap(find.text('Remember me'));
    await tester.pump();
    expect(model.state.rememberMe, isTrue);
  });
  testWidgets(
    'forgot password previews a reset and invitation link explains access',
    (tester) async {
      final repository = FakeAuthRepository(latency: Duration.zero);
      final model = LoginViewModel(repository);
      addTearDown(model.dispose);
      addTearDown(repository.dispose);
      await tester.pumpWidget(
        testApp(
          ChangeNotifierProvider<AuthRepository>.value(
            value: repository,
            child: ChangeNotifierProvider.value(
              value: model,
              child: const LoginScreen(),
            ),
          ),
        ),
      );
      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'student@example.com',
      );
      await tester.ensureVisible(find.text('Forgot password?'));
      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send reset instructions'));
      await tester.pumpAndSettle();
      expect(find.text('Reset request'), findsOneWidget);
      expect(find.text('No email was sent.'), findsOneWidget);
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Join by invitation'));
      await tester.tap(find.text('Join by invitation'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Ask your teacher or administrator'),
        findsOneWidget,
      );
    },
  );
}
