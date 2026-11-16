import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:poodle_flutter/features/onboarding/presentation/views/onboarding_screen.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('controls, swipe, keyboard and final action navigate the tour', (
    tester,
  ) async {
    final model = OnboardingViewModel()..setPaused(PauseReason.manual, true);
    var completed = 0;
    await tester.pumpWidget(
      testApp(
        ChangeNotifierProvider.value(
          value: model,
          child: OnboardingScreen(
            onComplete: () async {
              completed++;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Your learning, in one place.'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(model.state.index, 1);
    await tester.drag(
      find.byKey(const ValueKey('story-illustration')),
      const Offset(-200, 0),
    );
    await tester.pumpAndSettle();
    expect(model.state.index, 2);
    await tester.tap(find.byTooltip('Previous story'));
    await tester.pumpAndSettle();
    expect(model.state.index, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(model.state.index, 2);
    while (!model.isLast) {
      model.next();
    }
    await tester.pumpAndSettle();
    expect(find.text('Get started'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(completed, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    model.dispose();
  });

  testWidgets(
    'small Ukrainian layout at 2x text stays accessible and scrollable',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final model = OnboardingViewModel()..setAccessible(true);
      model.next();
      model.next();
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        testApp(
          MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(2),
              disableAnimations: true,
              accessibleNavigation: true,
            ),
            child: ChangeNotifierProvider.value(
              value: model,
              child: OnboardingScreen(onComplete: () async {}),
            ),
          ),
          locale: const Locale('uk'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Далі'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
      await tester.pumpWidget(const SizedBox.shrink());
      model.dispose();
    },
  );
}
