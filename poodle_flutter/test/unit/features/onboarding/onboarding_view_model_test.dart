import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/features/onboarding/presentation/view_models/onboarding_view_model.dart';

void main() {
  testWidgets(
    'backward input at an automatic boundary cannot transition twice',
    (tester) async {
      var now = Duration.zero;
      final model = OnboardingViewModel(now: () => now);
      model.next();
      var transitions = 0;
      model.addListener(() => transitions++);
      now += const Duration(seconds: 8);
      await tester.pump(const Duration(seconds: 8));
      model.previous();
      expect(transitions, 1);
      expect(model.state.index, 2);
      model.dispose();
    },
  );
  testWidgets(
    'eight-second stories stop on the final story without completing',
    (tester) async {
      var now = Duration.zero;
      final model = OnboardingViewModel(now: () => now);
      expect(model.state.index, 0);
      now += const Duration(seconds: 7);
      await tester.pump(const Duration(seconds: 7));
      expect(model.state.index, 0);
      now += const Duration(seconds: 1);
      await tester.pump(const Duration(seconds: 1));
      expect(model.state.index, 1);
      for (var i = 0; i < 9; i++) {
        now += const Duration(seconds: 8);
        await tester.pump(const Duration(seconds: 8));
      }
      expect(model.state.index, 9);
      expect(model.progress, 1);
      expect(model.state.paused, isTrue);
      model.dispose();
    },
  );

  testWidgets('overlapping pause reasons preserve remaining reading time', (
    tester,
  ) async {
    var now = Duration.zero;
    final model = OnboardingViewModel(now: () => now);
    now += const Duration(seconds: 3);
    await tester.pump(const Duration(seconds: 3));
    model.setPaused(PauseReason.hold, true);
    model.setPaused(PauseReason.lifecycle, true);
    now += const Duration(minutes: 1);
    await tester.pump(const Duration(minutes: 1));
    model.setPaused(PauseReason.hold, false);
    expect(model.state.paused, isTrue);
    expect(model.progress, 3 / 8);
    model.setPaused(PauseReason.lifecycle, false);
    now += const Duration(seconds: 5);
    await tester.pump(const Duration(seconds: 5));
    expect(model.state.index, 1);
    model.dispose();
  });

  testWidgets(
    'manual navigation resets elapsed and cannot leave story bounds',
    (tester) async {
      final model = OnboardingViewModel(now: () => Duration.zero);
      model.previous();
      expect(model.state.index, 0);
      model.next();
      expect(model.state.index, 1);
      expect(model.progress, 0);
      model.previous();
      for (var i = 0; i < 20; i++) {
        model.next();
      }
      expect(model.state.index, 9);
      model.previous();
      expect(model.state.index, 8);
      model.dispose();
    },
  );

  testWidgets(
    'accessibility remains manual after settings turn off until Play',
    (tester) async {
      final model = OnboardingViewModel(now: () => Duration.zero);
      model.setAccessible(true);
      model.setPaused(PauseReason.hold, true);
      model.setPaused(PauseReason.hold, false);
      model.togglePlayback();
      expect(model.state.paused, isTrue);
      model.setAccessible(false);
      expect(model.state.paused, isTrue);
      model.togglePlayback();
      expect(model.state.paused, isFalse);
      model.dispose();
    },
  );

  testWidgets('timer and gesture at the same boundary advance just once', (
    tester,
  ) async {
    var now = Duration.zero;
    final model = OnboardingViewModel(now: () => now);
    now += const Duration(seconds: 8);
    await tester.pump(const Duration(seconds: 8));
    model.next();
    expect(model.state.index, 1);
    model.dispose();
    await tester.pump(const Duration(minutes: 1));
  });
}
