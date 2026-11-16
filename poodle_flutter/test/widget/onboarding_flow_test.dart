import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';

void main() {
  for (final failingStorage in [false, true]) {
    testWidgets(
      'fresh tour exits without a loop, storage failure: $failingStorage',
      (tester) async {
        tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
            const FakeAccessibilityFeatures(disableAnimations: true);
        addTearDown(
          tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
        );
        final auth = FakeAuthRepository(latency: Duration.zero);
        final store = MemoryOnboardingStore(
          failRead: failingStorage,
          failWrite: failingStorage,
        );
        final onboarding = OnboardingRepository(store);
        await tester.pumpWidget(
          PoodleApp(
            repository: auth,
            onboardingRepository: onboarding,
            dashboardRepository: FakeDashboardRepository(
              latency: Duration.zero,
            ),
            minimumSplashDuration: Duration.zero,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Your learning, in one place.'), findsOneWidget);
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
        expect(find.text('Find what you need to learn.'), findsOneWidget);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.text('Your learning, in one place.'), findsOneWidget);
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
        expect(find.text('Welcome back'), findsOneWidget);
        expect(await tester.binding.handlePopRoute(), isFalse);
        await tester.pumpWidget(const SizedBox.shrink());
        final nextLaunch = OnboardingRepository(store);
        await tester.pumpWidget(
          PoodleApp(
            repository: auth,
            onboardingRepository: nextLaunch,
            minimumSplashDuration: Duration.zero,
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(
            failingStorage ? 'Your learning, in one place.' : 'Welcome back',
          ),
          findsOneWidget,
        );
        await tester.pumpWidget(const SizedBox.shrink());
        onboarding.dispose();
        nextLaunch.dispose();
        auth.dispose();
      },
    );
  }
  testWidgets(
    'restored session bypasses an incomplete tour and logout keeps it eligible',
    (tester) async {
      tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final auth = FakeAuthRepository(
        latency: Duration.zero,
        restoredSession: const AuthSession('learner@example.com'),
      );
      final onboarding = OnboardingRepository(MemoryOnboardingStore());
      await tester.pumpWidget(
        PoodleApp(
          repository: auth,
          onboardingRepository: onboarding,
          dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
          minimumSplashDuration: Duration.zero,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Upcoming tasks'), findsOneWidget);
      expect(onboarding.completed, isFalse);
      await tester.tap(find.text('More').last);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Sign out'),
        250,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      expect(find.text('Your learning, in one place.'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      onboarding.dispose();
      auth.dispose();
    },
  );
}
