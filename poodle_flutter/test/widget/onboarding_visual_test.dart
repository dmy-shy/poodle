import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/features/onboarding/onboarding_story.dart';
import 'package:poodle_flutter/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:poodle_flutter/features/onboarding/presentation/views/onboarding_screen.dart';
import '../support/load_fonts.dart';
import '../support/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadPreviewFonts);
  for (final variant in [
    (index: 0, locale: const Locale('en')),
    (index: 2, locale: const Locale('uk')),
    (index: 9, locale: const Locale('en')),
  ]) {
    testWidgets('onboarding visual ${variant.index} ${variant.locale}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final model = OnboardingViewModel()..setPaused(PauseReason.manual, true);
      for (var i = 0; i < variant.index; i++) {
        model.next();
      }
      await tester.pumpWidget(
        testApp(
          ChangeNotifierProvider.value(
            value: model,
            child: OnboardingScreen(onComplete: () async {}),
          ),
          locale: variant.locale,
        ),
      );
      await tester.runAsync(
        () => precacheImage(
          const AssetImage('assets/images/mascot.png'),
          tester.element(find.byType(OnboardingScreen)),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(OnboardingScreen),
        matchesGoldenFile(
          'goldens/onboarding_${variant.index}_${variant.locale.languageCode}.png',
        ),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      model.dispose();
    });
  }

  for (final variant in [
    (size: const Size(320, 568), scale: 2.0, locale: const Locale('uk')),
    (size: const Size(390, 844), scale: 1.0, locale: const Locale('en')),
    (size: const Size(844, 390), scale: 2.0, locale: const Locale('en')),
    (size: const Size(768, 1024), scale: 2.0, locale: const Locale('uk')),
  ]) {
    testWidgets(
      'all ten stories fit ${variant.size} ${variant.scale}x ${variant.locale}',
      (tester) async {
        tester.view.physicalSize = variant.size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final model = OnboardingViewModel()
          ..setPaused(PauseReason.manual, true);
        await tester.pumpWidget(
          testApp(
            MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(variant.scale),
              ),
              child: ChangeNotifierProvider.value(
                value: model,
                child: OnboardingScreen(onComplete: () async {}),
              ),
            ),
            locale: variant.locale,
          ),
        );
        for (var i = 0; i < OnboardingStory.values.length; i++) {
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: OnboardingStory.values[i].name,
          );
          expect(
            find.text(
              i == 9
                  ? (variant.locale.languageCode == 'uk'
                        ? 'Почати'
                        : 'Get started')
                  : (variant.locale.languageCode == 'uk' ? 'Далі' : 'Next'),
            ),
            findsOneWidget,
          );
          model.next();
        }
        await tester.pumpWidget(const SizedBox.shrink());
        model.dispose();
      },
    );
  }
}
