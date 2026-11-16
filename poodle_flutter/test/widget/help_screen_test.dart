import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/features/help/presentation/views/help_screen.dart';

void main() {
  for (final (locale, question, answer, shortcut) in [
    (
      const Locale('en'),
      'Where can I find my work and grades?',
      'Tasks',
      'Profile',
    ),
    (const Locale('uk'), 'Де знайти завдання й оцінки?', 'Завдання', 'Профіль'),
  ]) {
    testWidgets('offline FAQ and shortcuts in ${locale.languageCode}', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/help',
        routes: [
          GoRoute(path: '/help', builder: (_, _) => const HelpScreen()),
          GoRoute(
            path: '/profile',
            builder: (_, _) =>
                const Scaffold(body: Text('Profile destination')),
          ),
          GoRoute(
            path: '/more/feature/settings/synchronisation',
            builder: (_, _) => const Scaffold(body: Text('Sync destination')),
          ),
          GoRoute(
            path: '/more/feature/settings/about',
            builder: (_, _) => const Scaffold(body: Text('About destination')),
          ),
        ],
      );
      await tester.pumpWidget(
        MaterialApp.router(
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('uk')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
        ),
      );
      expect(find.text(answer), findsNothing);
      await tester.tap(find.text(question));
      await tester.pumpAndSettle();
      expect(find.textContaining(answer), findsWidgets);
      await tester.scrollUntilVisible(find.text(shortcut), 200);
      await tester.tap(find.text(shortcut));
      await tester.pumpAndSettle();
      expect(find.text('Profile destination'), findsOneWidget);
      router.pop();
      await tester.pumpAndSettle();
      for (final (label, destination) in [
        (
          locale.languageCode == 'uk' ? 'Синхронізація' : 'Synchronisation',
          'Sync destination',
        ),
        (
          locale.languageCode == 'uk' ? 'Про застосунок' : 'About',
          'About destination',
        ),
      ]) {
        await tester.scrollUntilVisible(find.text(label), 200);
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(find.text(destination), findsOneWidget);
        router.go('/help');
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
    });
  }
}
