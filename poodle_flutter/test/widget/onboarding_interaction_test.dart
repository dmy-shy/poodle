import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/features/onboarding/onboarding_story.dart';
import 'package:poodle_flutter/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:poodle_flutter/features/onboarding/presentation/views/onboarding_screen.dart';
import '../support/test_app.dart';

Widget tour(OnboardingViewModel model, {Locale locale = const Locale('en')}) =>
    testApp(
      ChangeNotifierProvider.value(
        value: model,
        child: OnboardingScreen(onComplete: () async {}),
      ),
      locale: locale,
    );

void main() {
  testWidgets(
    'mounting while already inactive pauses before the first boundary',
    (tester) async {
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      var now = Duration.zero;
      final model = OnboardingViewModel(now: () => now);
      await tester.pumpWidget(tour(model));
      await tester.pump();
      now += const Duration(seconds: 20);
      await tester.pump(const Duration(seconds: 20));
      expect(model.state.index, 0);
      expect(model.state.paused, isTrue);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      now += const Duration(seconds: 8);
      await tester.pump(const Duration(seconds: 8));
      expect(model.state.index, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      model.dispose();
    },
  );

  testWidgets('background time does not consume remaining story time', (
    tester,
  ) async {
    var now = Duration.zero;
    final model = OnboardingViewModel(now: () => now);
    await tester.pumpWidget(tour(model));
    await tester.pump();
    now += const Duration(seconds: 3);
    await tester.pump(const Duration(seconds: 3));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    now += const Duration(minutes: 1);
    await tester.pump(const Duration(minutes: 1));
    expect(model.progress, 3 / 8);
    expect(model.state.index, 0);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    now += const Duration(seconds: 5);
    await tester.pump(const Duration(seconds: 5));
    expect(model.state.index, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    model.dispose();
  });

  testWidgets(
    'holding, canceling and explicit pause never override each other',
    (tester) async {
      final model = OnboardingViewModel(now: () => Duration.zero);
      await tester.pumpWidget(tour(model));
      await tester.pump();
      final area = find.byKey(const ValueKey('story-illustration'));
      final hold = await tester.startGesture(tester.getCenter(area));
      await tester.pump(const Duration(seconds: 1));
      expect(model.state.paused, isTrue);
      model.setPaused(PauseReason.manual, true);
      await hold.cancel();
      await tester.pump();
      expect(model.state.paused, isTrue);
      model.togglePlayback();
      await tester.pump();
      expect(model.state.paused, isFalse);
      final holdAgain = await tester.startGesture(tester.getCenter(area));
      await tester.pump(const Duration(seconds: 1));
      await holdAgain.up();
      await tester.pump();
      expect(model.state.index, 0);
      expect(model.state.paused, isFalse);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(model.state.paused, isTrue);
      await tester.pumpWidget(const SizedBox.shrink());
      model.dispose();
    },
  );

  testWidgets(
    'locale and rotation keep position; route cover pauses playback',
    (tester) async {
      final model = OnboardingViewModel(now: () => Duration.zero)
        ..setPaused(PauseReason.manual, true);
      model.next();
      model.next();
      await tester.pumpWidget(tour(model));
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(tour(model, locale: const Locale('uk')));
      await tester.pumpAndSettle();
      expect(model.state.index, 2);
      expect(
        find.text('Історія 3 з ${OnboardingStory.values.length}'),
        findsOneWidget,
      );
      model.togglePlayback();
      await tester.pump();
      final context = tester.element(find.byType(OnboardingScreen));
      final dialog = showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(model.state.paused, isTrue);
      await tester.tap(find.text('Close'));
      await tester.pump();
      await dialog;
      await tester.pump(const Duration(milliseconds: 300));
      expect(model.state.paused, isFalse);
      await tester.pumpWidget(const SizedBox.shrink());
      model.dispose();
    },
  );

  testWidgets(
    'screen reader gets one story announcement, without tick updates',
    (tester) async {
      final semantics = tester.ensureSemantics();
      var now = Duration.zero;
      final model = OnboardingViewModel(now: () => now);
      await tester.pumpWidget(tour(model));
      await tester.pump();
      final story = find.byKey(const ValueKey('story-courses'));
      final initial = tester.getSemantics(story).label;
      expect(
        initial,
        contains(
          'Story 1 of ${OnboardingStory.values.length}. Your learning, in one place.',
        ),
      );
      now += const Duration(seconds: 2);
      await tester.pump(const Duration(seconds: 2));
      expect(tester.getSemantics(story).label, initial);
      semantics.dispose();
      await tester.pumpWidget(const SizedBox.shrink());
      model.dispose();
    },
  );
}
