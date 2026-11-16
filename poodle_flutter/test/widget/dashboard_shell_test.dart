import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/app/preview_destinations.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';

void main() {
  testWidgets('narrow Ukrainian Android tabs keep labels on one line', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(345, 760);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.platformDispatcher.localesTestValue = const [Locale('uk')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('student@example.com'),
    );
    final onboarding = OnboardingRepository(
      MemoryOnboardingStore(completed: true),
    );
    addTearDown(auth.dispose);
    addTearDown(onboarding.dispose);

    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        onboardingRepository: onboarding,
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();

    Finder label(String text) => find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(text),
    );
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(
      (bar.destinations[2] as NavigationDestination).tooltip,
      'Повідомлення',
    );
    await tester.tap(find.byIcon(Icons.chat_bubble_outline));
    await tester.pumpAndSettle();
    final chats = tester.renderObject<RenderParagraph>(label('Чати'));
    expect(chats.maxLines, 1);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      2,
    );

    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.tap(find.byIcon(Icons.notifications_none));
    await tester.pumpAndSettle();
    final notifications = tester.renderObject<RenderParagraph>(
      label('Сповіщення'),
    );
    expect(notifications.maxLines, 1);
    expect(notifications.overflow, TextOverflow.ellipsis);
    expect(tester.takeException(), isNull);
  });

  testWidgets('header opens profile and Android search without losing Home', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('student@example.com'),
    );
    final onboarding = OnboardingRepository(
      MemoryOnboardingStore(completed: true),
    );
    addTearDown(auth.dispose);
    addTearDown(onboarding.dispose);
    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        onboardingRepository: onboarding,
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('account-menu')));
    await tester.pumpAndSettle();
    expect(find.text('student@example.com'), findsOneWidget);
    await tester.tap(find.widgetWithText(PopupMenuItem<String>, 'Profile'));
    await tester.pumpAndSettle();
    expect(find.text('student@example.com'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Upcoming tasks'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('header-search')));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Search'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Upcoming tasks'), findsOneWidget);
  });

  testWidgets('restored session opens Home and tabs remain reachable', (
    tester,
  ) async {
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
          clock: () => DateTime.utc(2026, 10, 20, 12),
        ),
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Upcoming tasks'), findsOneWidget);
    expect(find.byKey(const ValueKey('account-menu')), findsOneWidget);
    await tester.tap(find.text('Courses').last);
    await tester.pumpAndSettle();
    expect(
      find.text('Writing with purpose / Усвідомлене письмо'),
      findsOneWidget,
    );
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    expect(find.text('Upcoming tasks'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    onboarding.dispose();
    auth.dispose();
  });

  testWidgets('More sign-out removes dashboard and keeps completion', (
    tester,
  ) async {
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
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
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
    expect(find.text('Upcoming tasks'), findsNothing);
    expect(onboarding.completed, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    onboarding.dispose();
    auth.dispose();
  });

  testWidgets(
    'task preview returns to Home and signed-out deep link stays private',
    (
      tester,
    ) async {
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
          dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
          minimumSplashDuration: Duration.zero,
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('task-reflection')));
      await tester.tap(find.byKey(const ValueKey('task-reflection')));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'This feature is unavailable.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Upcoming tasks'), findsOneWidget);
      await auth.signOut();
      await tester.pumpAndSettle();
      GoRouter.of(
        tester.element(find.text('Welcome back')),
      ).go('/home/task/task-reflection');
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Upcoming tasks'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
      onboarding.dispose();
      auth.dispose();
    },
  );

  testWidgets('system back from a secondary tab returns to Home', (
    tester,
  ) async {
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
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Messages').last);
    await tester.pumpAndSettle();
    expect(find.text('Private messages'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Upcoming tasks'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    onboarding.dispose();
    auth.dispose();
  });

  testWidgets('Home omits quick links and Tasks stays available in More', (
    tester,
  ) async {
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
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Quick links'), findsNothing);
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tasks').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tasks').last);
    await tester.pumpAndSettle();
    expect(find.text('Tasks'), findsOneWidget);
    expect(
      find.text(
        'This feature is unavailable.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(MoreDestination), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    onboarding.dispose();
    auth.dispose();
  });

  testWidgets(
    'contextual previews and legacy demo route stay in the signed-in shell',
    (
      tester,
    ) async {
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
          dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
          minimumSplashDuration: Duration.zero,
        ),
      );
      await tester.pumpAndSettle();
      final router = GoRouter.of(tester.element(find.text('Upcoming tasks')));
      router.go('/home/course/019a0acf-0000-7000-8000-000000000001');
      await tester.pumpAndSettle();
      expect(find.text('Creative thinking / Творче мислення'), findsOneWidget);
      router.go('/home/announcements');
      await tester.pumpAndSettle();
      expect(find.text("This week's materials"), findsOneWidget);
      router.go('/home/announcement/announcement-week');
      await tester.pumpAndSettle();
      expect(
        find.text(
          'The new reading list is ready. Explore the next topic when you have time.',
        ),
        findsOneWidget,
      );
      router.go('/notifications');
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(PreviewDestination, 'Notifications'),
        findsOneWidget,
      );
      router.go('/demo');
      await tester.pumpAndSettle();
      expect(find.text('Upcoming tasks'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      onboarding.dispose();
      auth.dispose();
    },
  );

  testWidgets('switching tabs preserves Home scroll position', (tester) async {
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
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    final before = tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .pixels;
    expect(before, greaterThan(0));
    await tester.tap(find.text('Courses').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    final after = tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .pixels;
    expect(after, closeTo(before, 1));
    await tester.pumpWidget(const SizedBox.shrink());
    onboarding.dispose();
    auth.dispose();
  });

  for (final scenario in [
    DashboardPreviewScenario.empty,
    DashboardPreviewScenario.loadFailure,
    DashboardPreviewScenario.offline,
  ]) {
    testWidgets('$scenario exposes its recovery or empty state', (
      tester,
    ) async {
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
            clock: () => DateTime.utc(2026, 10, 20, 12),
          ),
          minimumSplashDuration: Duration.zero,
        ),
      );
      await tester.pumpAndSettle();
      switch (scenario) {
        case DashboardPreviewScenario.empty:
          expect(
            find.text('No upcoming tasks.'),
            findsOneWidget,
          );
        case DashboardPreviewScenario.loadFailure:
          expect(
            find.text("Couldn't load your dashboard. Try again."),
            findsOneWidget,
          );
          await tester.tap(find.text('Retry'));
          await tester.pumpAndSettle();
          expect(find.text('No upcoming tasks.'), findsNothing);
          expect(find.byKey(const ValueKey('task-reflection')), findsOneWidget);
        case DashboardPreviewScenario.offline:
          expect(
            find.text('Offline · saved data may be out of date.'),
            findsOneWidget,
          );
          await tester.drag(
            find.byType(CustomScrollView),
            const Offset(0, 350),
          );
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('task-reflection')), findsOneWidget);
        case DashboardPreviewScenario.normal:
          fail('not included');
      }
      await tester.pumpWidget(const SizedBox.shrink());
      onboarding.dispose();
      auth.dispose();
    });
  }

  for (final variant in [
    (size: const Size(320, 568), locale: const Locale('uk')),
    (size: const Size(768, 1024), locale: const Locale('en')),
  ]) {
    testWidgets('navigation remains usable at ${variant.size} and 2x text', (
      tester,
    ) async {
      tester.view.physicalSize = variant.size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.binding.platformDispatcher.localesTestValue = [variant.locale];
      addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
      final auth = FakeAuthRepository(
        latency: Duration.zero,
        restoredSession: const AuthSession('student@example.com'),
      );
      final onboarding = OnboardingRepository(
        MemoryOnboardingStore(completed: true),
      );
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: variant.size,
            textScaler: const TextScaler.linear(2),
          ),
          child: PoodleApp(
            repository: auth,
            onboardingRepository: onboarding,
            dashboardRepository: FakeDashboardRepository(
              latency: Duration.zero,
            ),
            minimumSplashDuration: Duration.zero,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final isUkrainian = variant.locale.languageCode == 'uk';
      expect(
        find.text(isUkrainian ? 'Найближчі завдання' : 'Upcoming tasks'),
        findsOneWidget,
      );
      expect(
        find.byType(variant.size.width < 600 ? NavigationBar : NavigationRail),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      onboarding.dispose();
      auth.dispose();
    });
  }
}
