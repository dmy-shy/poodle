import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/settings_repository.dart';
import 'package:poodle_flutter/features/settings/presentation/view_models/settings_view_model.dart';

class _FailingSettingsRepository implements SettingsRepository {
  @override
  Future<AppSettings> read() async => const AppSettings(language: 'uk');
  @override
  Future<void> write(AppSettings settings) async =>
      throw StateError('save failed');
}

void main() {
  test('saved preferences load and survive reopening', () async {
    final repository = MemorySettingsRepository();
    final first = SettingsViewModel(repository);
    await first.load();
    await first.update(language: 'uk', textSize: 2, wifiOnlyDownloads: true);
    final reopened = SettingsViewModel(repository);
    await reopened.load();
    expect(reopened.settings.language, 'uk');
    expect(reopened.settings.textSize, 2);
    expect(reopened.settings.wifiOnlyDownloads, true);
    first.dispose();
    reopened.dispose();
  });

  test('failed save keeps the previous visible selection', () async {
    final model = SettingsViewModel(_FailingSettingsRepository());
    await model.load();
    await model.update(language: 'en');
    expect(model.settings.language, 'uk');
    expect(model.saveFailed, isTrue);
    model.dispose();
  });
}
