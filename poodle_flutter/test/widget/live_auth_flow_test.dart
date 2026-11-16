import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';
import 'package:poodle_flutter/ui/components/email_avatar.dart';
import '../support/live_auth_fixture.dart';

void main() {
  Future<void> launch(WidgetTester tester, LiveAuthFixture repository) async {
    await tester.pumpWidget(
      PoodleApp(
        repository: repository,
        minimumSplashDuration: Duration.zero,
        onboardingRepository: OnboardingRepository(
          MemoryOnboardingStore(completed: true),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Google can sign in with empty email and password fields', (
    tester,
  ) async {
    final repository = LiveAuthFixture()..googleConfigured = true;
    addTearDown(repository.dispose);
    await launch(tester, repository);
    await tester.ensureVisible(find.text('Sign in with Google'));
    await tester.tap(find.text('Sign in with Google'));
    await tester.pumpAndSettle();
    expect(repository.session?.email, 'learner@example.com');
  });

  testWidgets(
    'live login shows unavailable Google and reset completes all steps',
    (tester) async {
      final repository = LiveAuthFixture();
      addTearDown(repository.dispose);
      await launch(tester, repository);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(
        tester
            .widget<OutlinedButton>(
              find.widgetWithText(OutlinedButton, 'Sign in with Google'),
            )
            .onPressed,
        isNull,
      );
      expect(find.text('UI preview · simulated sign-in'), findsNothing);
      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('verification-email')),
        'member@example.test',
      );
      await tester.tap(find.text('Request verification code'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('verification-code')),
        'valid-code',
      );
      await tester.tap(find.text('Verify code'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('verification-password')),
        'Long-password',
      );
      await tester.enterText(
        find.byKey(const ValueKey('verification-confirm')),
        'Long-password',
      );
      await tester.tap(find.text('Save password'));
      await tester.pumpAndSettle();
      expect(
        find.text('Password updated. Sign in with your new password.'),
        findsOneWidget,
      );
      expect(repository.resets, 1);
      await tester.tap(find.text('Return to login'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
    },
  );

  testWidgets(
    'startup connection failure offers retry instead of permanent splash',
    (tester) async {
      final repository = LiveAuthFixture()..failStartup = true;
      addTearDown(repository.dispose);
      await launch(tester, repository);
      expect(find.text('Unable to restore your session'), findsOneWidget);
      repository.failStartup = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
    },
  );

  testWidgets('both Profile entries open the same route and Back returns', (
    tester,
  ) async {
    final repository = LiveAuthFixture(
      restoredSession: const AuthSession('member@example.test'),
    );
    addTearDown(repository.dispose);
    await launch(tester, repository);
    final header = find.byKey(const ValueKey('account-menu'));
    final router = GoRouter.of(tester.element(header));
    final profileTitle = find.widgetWithText(AppBar, 'Profile');

    await tester.tap(header);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(PopupMenuItem<String>, 'Profile'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/profile');
    expect(profileTitle, findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/home');

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    final profileRow = find.widgetWithText(ListTile, 'Profile');
    await tester.scrollUntilVisible(find.text('Sign out'), 150);
    expect(find.widgetWithText(ListTile, 'Account'), findsNothing);
    await tester.scrollUntilVisible(profileRow, -150);
    expect(profileRow, findsOneWidget);
    await tester.tap(profileRow);
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/profile');
    expect(profileTitle, findsOneWidget);
    expect(find.byType(EmailAvatar), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/more');
    expect(profileRow, findsOneWidget);
  });

  for (final signedIn in [true, false]) {
    testWidgets('legacy account URL with signedIn=$signedIn', (tester) async {
      final repository = LiveAuthFixture(
        restoredSession: signedIn
            ? const AuthSession('member@example.test')
            : null,
      );
      addTearDown(repository.dispose);
      await launch(tester, repository);
      final router = GoRouter.of(
        tester.element(
          signedIn
              ? find.byKey(const ValueKey('account-menu'))
              : find.text('Welcome back'),
        ),
      );
      router.go('/more/account');
      await tester.pumpAndSettle();

      expect(router.state.uri.path, signedIn ? '/profile' : '/login');
      expect(
        find.widgetWithText(AppBar, 'Profile'),
        signedIn ? findsOneWidget : findsNothing,
      );
      if (!signedIn) expect(find.text('Welcome back'), findsOneWidget);
    });
  }

  testWidgets('real Profile screen exposes server-confirmed authority', (
    tester,
  ) async {
    final repository = LiveAuthFixture(
      restoredSession: const AuthSession(
        'admin@example.test',
        userId: 'admin',
        isAdmin: true,
        teacherApproved: true,
      ),
    );
    addTearDown(repository.dispose);
    await launch(tester, repository);
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.widgetWithText(ListTile, 'Profile'),
      200,
    );
    await tester.tap(find.widgetWithText(ListTile, 'Profile'));
    await tester.pumpAndSettle();
    expect(find.text('admin@example.test'), findsOneWidget);
    expect(find.text('Administrator'), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Profile'), findsOneWidget);
    expect(
      find.text('Approved for future teacher memberships'),
      findsOneWidget,
    );
    await tester.tap(find.text('Teacher invitations'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('invite-email')),
      'teacher@example.test',
    );
    await tester.tap(find.text('Create invitation'));
    await tester.pumpAndSettle();
    expect(find.text('teacher@example.test'), findsOneWidget);
    await tester.tap(find.text('Revoke'));
    await tester.pumpAndSettle();
    expect(repository.adminWrites, 2);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Profile'), findsOneWidget);
  });
}
