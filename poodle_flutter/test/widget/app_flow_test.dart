import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';

OnboardingRepository completedTour() {
  final repository = OnboardingRepository(
    MemoryOnboardingStore(completed: true),
  );
  addTearDown(repository.dispose);
  return repository;
}

void main() {
  testWidgets('app stays light when the device uses dark mode', (tester) async {
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    addTearDown(
      tester.binding.platformDispatcher.clearPlatformBrightnessTestValue,
    );
    final repository = FakeAuthRepository(latency: Duration.zero);
    addTearDown(repository.dispose);
    await tester.pumpWidget(
      PoodleApp(
        onboardingRepository: completedTour(),
        repository: repository,
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        minimumSplashDuration: Duration.zero,
      ),
    );
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.light,
    );
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.light,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('Google sign-in disables repeat submission and routes to Home', (
    tester,
  ) async {
    final repository = FakeAuthRepository(
      latency: const Duration(milliseconds: 300),
    );
    addTearDown(repository.dispose);
    await tester.pumpWidget(
      PoodleApp(
        onboardingRepository: completedTour(),
        repository: repository,
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Sign in with Google'));
    await tester.tap(find.text('Sign in with Google'));
    await tester.pump();
    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
      isNull,
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Upcoming tasks'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('restored preview session bypasses login after splash', (
    tester,
  ) async {
    final repository = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('learner@example.com'),
    );
    addTearDown(repository.dispose);
    await tester.pumpWidget(
      PoodleApp(
        onboardingRepository: completedTour(),
        repository: repository,
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Upcoming tasks'), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets(
    'launch routes through login to Home and sign-out clears the form',
    (tester) async {
      final repository = FakeAuthRepository(latency: Duration.zero);
      addTearDown(repository.dispose);
      await tester.pumpWidget(
        PoodleApp(
          onboardingRepository: completedTour(),
          repository: repository,
          dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
          minimumSplashDuration: Duration.zero,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'student@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password')),
        'my password',
      );
      await tester.ensureVisible(find.text('Log in'));
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();
      expect(find.text('Upcoming tasks'), findsOneWidget);
      expect(await tester.binding.handlePopRoute(), isFalse);
      await tester.tap(find.text('More').last);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Sign out'),
        250,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('student@example.com'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets(
    'system language changes preserve input and unsupported primary languages use English',
    (tester) async {
      tester.binding.platformDispatcher.localesTestValue = const [
        Locale('uk', 'UA'),
      ];
      addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
      final repository = FakeAuthRepository(latency: Duration.zero);
      addTearDown(repository.dispose);
      await tester.pumpWidget(
        PoodleApp(
          onboardingRepository: completedTour(),
          repository: repository,
          dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
          minimumSplashDuration: Duration.zero,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('З поверненням'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'student@example.com',
      );
      tester.binding.platformDispatcher.localesTestValue = const [
        Locale('en', 'GB'),
      ];
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('student@example.com'), findsOneWidget);
      tester.binding.platformDispatcher.localesTestValue = const [
        Locale('pl', 'PL'),
        Locale('uk', 'UA'),
      ];
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
