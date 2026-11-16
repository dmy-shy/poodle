import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('completion survives a new repository and store instance', () async {
    SharedPreferences.setMockInitialValues({});
    final first = OnboardingRepository(PreferencesOnboardingStore());
    await first.load();
    expect(first.completed, isFalse);
    await first.complete();
    final next = OnboardingRepository(PreferencesOnboardingStore());
    await next.load();
    expect(next.completed, isTrue);
    first.dispose();
    next.dispose();
  });
  test('read and write failures never block in-process completion', () async {
    final model = OnboardingRepository(
      MemoryOnboardingStore(failRead: true, failWrite: true),
    );
    await model.load();
    expect(model.ready, isTrue);
    expect(model.completed, isFalse);
    await Future.wait([model.complete(), model.complete()]);
    expect(model.completed, isTrue);
    model.dispose();
  });
  test(
    'fresh preview store never changes another installations flag',
    () async {
      final saved = MemoryOnboardingStore(completed: true);
      final preview = OnboardingRepository(MemoryOnboardingStore());
      await preview.load();
      expect(preview.completed, isFalse);
      expect(await saved.readCompleted(), isTrue);
      preview.dispose();
    },
  );
}
