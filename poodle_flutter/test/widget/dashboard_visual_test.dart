import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';
import 'package:poodle_flutter/features/dashboard/presentation/views/dashboard_screen.dart';
import '../support/load_fonts.dart';

// Home displays local times. Fix the wall-clock time across runner time zones.
DateTime _dashboardTime() => DateTime(2026, 10, 20, 15);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadPreviewFonts);
  for (final locale in [const Locale('en'), const Locale('uk')]) {
    testWidgets('Home light visual ${locale.languageCode}', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.binding.platformDispatcher.localesTestValue = [locale];
      addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
      final auth = FakeAuthRepository(
        latency: Duration.zero,
        restoredSession: const AuthSession('student@example.com'),
      );
      final onboarding = OnboardingRepository(
        MemoryOnboardingStore(completed: true),
      );
      await tester.pumpWidget(
        PoodleApp(
          repository: auth,
          onboardingRepository: onboarding,
          dashboardRepository: FakeDashboardRepository(
            latency: Duration.zero,
            clock: _dashboardTime,
          ),
          minimumSplashDuration: Duration.zero,
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(PoodleApp),
        matchesGoldenFile('goldens/home_${locale.languageCode}_light.png'),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      onboarding.dispose();
      auth.dispose();
    });
  }
  for (final scenario in [
    DashboardPreviewScenario.empty,
    DashboardPreviewScenario.loadFailure,
    DashboardPreviewScenario.offline,
  ]) {
    testWidgets('Home $scenario visual', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final auth = FakeAuthRepository(
        latency: Duration.zero,
        restoredSession: const AuthSession('student@example.com'),
      );
      final onboarding = OnboardingRepository(
        MemoryOnboardingStore(completed: true),
      );
      await tester.pumpWidget(
        PoodleApp(
          repository: auth,
          onboardingRepository: onboarding,
          dashboardRepository: FakeDashboardRepository(
            scenario: scenario,
            latency: Duration.zero,
            clock: _dashboardTime,
          ),
          minimumSplashDuration: Duration.zero,
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(PoodleApp),
        matchesGoldenFile('goldens/home_${scenario.name}_light.png'),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      onboarding.dispose();
      auth.dispose();
    });
  }
  testWidgets('Home loading visual', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('student@example.com'),
    );
    final onboarding = OnboardingRepository(
      MemoryOnboardingStore(completed: true),
    );
    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        onboardingRepository: onboarding,
        dashboardRepository: FakeDashboardRepository(
          latency: const Duration(seconds: 5),
          clock: _dashboardTime,
        ),
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Loading'), findsOneWidget);
    await expectLater(
      find.byType(PoodleApp),
      matchesGoldenFile('goldens/home_loading_light.png'),
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpWidget(const SizedBox.shrink());
    onboarding.dispose();
    auth.dispose();
  });
}
