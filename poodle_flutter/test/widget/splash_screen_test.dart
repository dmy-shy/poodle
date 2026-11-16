import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/features/auth/presentation/views/splash_screen.dart';
import 'package:poodle_flutter/features/auth/quotes.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('all splash quotations follow the app locale', (tester) async {
    const english = [
      ('Learn from others, but do not forsake your own.', 'Taras Shevchenko'),
      ('No, I am alive! I will live forever!', 'Lesia Ukrainka'),
      ('Keep hoping, even without hope.', 'Lesia Ukrainka'),
      ('Only by struggling do we live…', 'Ivan Franko'),
      ('Rise, wake up, come alive!', 'Ivan Franko'),
    ];
    const ukrainian = [
      ('І чужому научайтесь, й свого не цурайтесь.', 'Тарас Шевченко'),
      ('Ні! я жива! Я буду вічно жити!', 'Леся Українка'),
      ('Без надії таки сподіватись', 'Леся Українка'),
      ('Лиш боротись значить жить…', 'Іван Франко'),
      ('Встань, прокинься, пробудись!', 'Іван Франко'),
    ];
    for (final (locale, expected) in [
      (const Locale('en'), english),
      (const Locale('uk'), ukrainian),
    ]) {
      for (var i = 0; i < SplashQuoteId.values.length; i++) {
        await tester.pumpWidget(
          testApp(
            SplashScreen(quote: SplashQuoteId.values[i], animate: false),
            locale: locale,
          ),
        );
        expect(find.text(expected[i].$1), findsOneWidget);
        expect(find.text(expected[i].$2), findsOneWidget);
      }
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'splash shows an accessible brand mark and the selected quote with author on a small phone',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        testApp(
          const SplashScreen(
            quote: SplashQuoteId.shevchenko,
            animate: false,
          ),
        ),
      );
      expect(find.bySemanticsLabel('Poodle LMS'), findsOneWidget);
      expect(
        find.text('Learn from others, but do not forsake your own.'),
        findsOneWidget,
      );
      expect(find.text('Taras Shevchenko'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(
        testApp(
          const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: SplashScreen(animate: false),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('wordmark types in place and reduced motion completes it', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const SplashScreen()));
    Finder fadeFor(String letter) => find
        .ancestor(of: find.text(letter), matching: find.byType(FadeTransition))
        .first;
    double opacity(String letter) =>
        tester.widget<FadeTransition>(fadeFor(letter)).opacity.value;
    final position = tester.getTopLeft(fadeFor('M'));
    expect(opacity('L'), 0);
    await tester.pump(const Duration(milliseconds: 180));
    expect(opacity('L'), closeTo(1, 0.00001));
    expect(opacity('M'), 0);
    expect(tester.getTopLeft(fadeFor('M')), position);
    await tester.pumpWidget(
      testApp(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: SplashScreen(),
        ),
      ),
    );
    expect(opacity('S'), 1);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets(
    'quote shimmer animates unless system reduced motion is enabled',
    (tester) async {
      await tester.pumpWidget(testApp(const SplashScreen()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.binding.transientCallbackCount, greaterThan(0));
      await tester.pumpWidget(
        testApp(
          const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: SplashScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
  );
}
