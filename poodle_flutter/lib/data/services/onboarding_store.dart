import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingStore {
  Future<bool> readCompleted();
  Future<void> writeCompleted();
}

/// Installation preference: intentionally independent of account caches.
class PreferencesOnboardingStore implements OnboardingStore {
  static const key = 'poodle.onboarding.completed';

  @override
  Future<bool> readCompleted() async =>
      (await SharedPreferences.getInstance()).getBool(key) ?? false;

  @override
  Future<void> writeCompleted() async {
    final saved = await (await SharedPreferences.getInstance()).setBool(
      key,
      true,
    );
    if (!saved) throw StateError('Could not save onboarding preference');
  }
}

/// Isolated store for tests and previews; never changes real preferences.
class MemoryOnboardingStore implements OnboardingStore {
  MemoryOnboardingStore({
    this.completed = false,
    this.failRead = false,
    this.failWrite = false,
  });
  bool completed;
  final bool failRead;
  final bool failWrite;

  @override
  Future<bool> readCompleted() async {
    if (failRead) throw StateError('Unavailable preference');
    return completed;
  }

  @override
  Future<void> writeCompleted() async {
    if (failWrite) throw StateError('Unavailable preference');
    completed = true;
  }
}
