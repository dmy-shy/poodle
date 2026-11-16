import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({
    this.language = 'system',
    this.textSize = 0,
    this.wifiOnlyDownloads = false,
  });
  final String language;
  final int textSize;
  final bool wifiOnlyDownloads;
}

abstract interface class SettingsRepository {
  Future<AppSettings> read();
  Future<void> write(AppSettings settings);
}

class PreferencesSettingsRepository implements SettingsRepository {
  static const _key = 'poodle.settings';

  @override
  Future<AppSettings> read() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == null) return const AppSettings();
    final data = jsonDecode(saved) as Map<String, dynamic>;
    final language = data['language'];
    final size = data['textSize'];
    final wifiOnly = data['wifiOnlyDownloads'];
    return AppSettings(
      language: language == 'en' || language == 'uk'
          ? language as String
          : 'system',
      textSize: size is int && size >= 0 && size <= 2 ? size : 0,
      wifiOnlyDownloads: wifiOnly == true,
    );
  }

  @override
  Future<void> write(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(
      _key,
      jsonEncode({
        'language': settings.language,
        'textSize': settings.textSize,
        'wifiOnlyDownloads': settings.wifiOnlyDownloads,
      }),
    )) {
      throw StateError('Could not save settings');
    }
  }
}

class MemorySettingsRepository implements SettingsRepository {
  MemorySettingsRepository([this.settings = const AppSettings()]);
  AppSettings settings;
  @override
  Future<AppSettings> read() async => settings;
  @override
  Future<void> write(AppSettings value) async => settings = value;
}
