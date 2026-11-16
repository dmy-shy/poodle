import 'package:flutter/foundation.dart';
import '../../../../data/repositories/settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(this.repository);
  final SettingsRepository repository;
  AppSettings settings = const AppSettings();
  bool saveFailed = false;

  Future<void> load() async {
    try {
      settings = await repository.read();
    } catch (_) {
      settings = const AppSettings();
    }
    notifyListeners();
  }

  Future<void> update({
    String? language,
    int? textSize,
    bool? wifiOnlyDownloads,
  }) async {
    final next = AppSettings(
      language: language ?? settings.language,
      textSize: textSize ?? settings.textSize,
      wifiOnlyDownloads: wifiOnlyDownloads ?? settings.wifiOnlyDownloads,
    );
    try {
      await repository.write(next);
      settings = next;
      saveFailed = false;
    } catch (_) {
      saveFailed = true;
    }
    notifyListeners();
  }
}
