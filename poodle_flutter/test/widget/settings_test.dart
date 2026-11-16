import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/repositories/settings_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';

void main() {
  testWidgets('Help opens Synchronisation from the existing settings branch', (
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
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
    router.go('/more/feature/settings');
    await tester.pumpAndSettle();
    router.push('/help');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Synchronisation'));
    await tester.tap(find.text('Synchronisation'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Synchronisation'), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('More opens Settings and About, then returns', (tester) async {
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
        loadAppVersion: () async => '1.2.3',
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Settings'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('General'), findsOneWidget);
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Poodle is'), findsOneWidget);
    expect(find.text('Version 1.2.3'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('General'), findsOneWidget);
  });

  testWidgets(
    'General saves language and size; other pages explain availability',
    (tester) async {
      final auth = FakeAuthRepository(
        latency: Duration.zero,
        restoredSession: const AuthSession('student@example.com'),
      );
      final onboarding = OnboardingRepository(
        MemoryOnboardingStore(completed: true),
      );
      final settings = MemorySettingsRepository();
      addTearDown(auth.dispose);
      addTearDown(onboarding.dispose);
      await tester.pumpWidget(
        PoodleApp(
          repository: auth,
          onboardingRepository: onboarding,
          settingsRepository: settings,
          minimumSplashDuration: Duration.zero,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('account-menu')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(PopupMenuItem<String>, 'Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('General'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Українська'));
      await tester.pumpAndSettle();
      expect(find.text('Мова'), findsOneWidget);
      await tester.tap(find.text('Дуже великий'));
      await tester.pumpAndSettle();
      expect(settings.settings.language, 'uk');
      expect(settings.settings.textSize, 2);
      expect(find.text('Розмір тексту'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Використання пам’яті'), findsOneWidget);
      for (final (label, body) in [
        (
          'Використання пам’яті',
          'Дані про використання пам’яті поки недоступні.',
        ),
        ('Спільні файли', 'Спільні файли поки недоступні.'),
      ]) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(find.text(body), findsOneWidget);
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Синхронізація'));
      await tester.pumpAndSettle();
      expect(find.text('Оновлено'), findsWidgets);
      expect(find.text('Синхронізувати зараз'), findsOneWidget);
    },
  );
}
