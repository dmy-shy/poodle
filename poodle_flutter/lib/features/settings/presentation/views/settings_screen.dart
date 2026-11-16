import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../view_models/settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(text.dashboardSettings),
        leading: BackButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/more'),
        ),
      ),
      body: ListView(
        children: [
          _row(context, Icons.tune, text.settingsGeneral, 'general'),
          _row(context, Icons.storage, text.settingsSpaceUsage, 'space-usage'),
          _row(
            context,
            Icons.sync,
            text.settingsSynchronisation,
            'synchronisation',
          ),
          _row(
            context,
            Icons.folder_outlined,
            text.settingsSharedFiles,
            'shared-files',
          ),
          _row(context, Icons.info_outline, text.settingsAbout, 'about'),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String title, String path) =>
      ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/more/feature/settings/$path'),
      );
}

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final model = context.watch<SettingsViewModel>();
    final language = model.settings.language;
    final size = model.settings.textSize;
    return Scaffold(
      appBar: AppBar(
        title: Text(text.settingsGeneral),
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('/more/feature/settings'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            text.settingsLanguage,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          RadioGroup<String>(
            groupValue: language,
            onChanged: (selected) => model.update(language: selected),
            child: Column(
              children: [
                for (final (value, label) in [
                  ('system', text.settingsSystem),
                  ('en', 'English'),
                  ('uk', 'Українська'),
                ])
                  RadioListTile<String>(
                    title: Text(label),
                    value: value,
                  ),
              ],
            ),
          ),
          const Divider(),
          Text(
            text.settingsTextSize,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          RadioGroup<int>(
            groupValue: size,
            onChanged: (selected) => model.update(textSize: selected),
            child: Column(
              children: [
                for (final (value, label) in [
                  (0, text.settingsStandard),
                  (1, text.settingsLarge),
                  (2, text.settingsExtraLarge),
                ])
                  RadioListTile<int>(
                    title: Text(label),
                    value: value,
                  ),
              ],
            ),
          ),
          if (model.saveFailed)
            Text(
              text.settingsSaveFailed,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          const Divider(),
          SwitchListTile(
            title: Text(
              Localizations.localeOf(context).languageCode == 'uk'
                  ? 'Завантажувати лише через Wi-Fi'
                  : 'Download over Wi-Fi only',
            ),
            value: model.settings.wifiOnlyDownloads,
            onChanged: (value) => model.update(wifiOnlyDownloads: value),
          ),
        ],
      ),
    );
  }
}

class UnavailableSettingsScreen extends StatelessWidget {
  const UnavailableSettingsScreen({super.key, required this.kind});
  final String kind;
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final (title, body, icon) = switch (kind) {
      'space-usage' => (
        text.settingsSpaceUsage,
        text.settingsSpaceUnavailable,
        Icons.storage_outlined,
      ),
      'synchronisation' => (
        text.settingsSynchronisation,
        text.settingsSyncUnavailable,
        Icons.sync_disabled,
      ),
      _ => (
        text.settingsSharedFiles,
        text.settingsFilesUnavailable,
        Icons.folder_off_outlined,
      ),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('/more/feature/settings'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56),
              const SizedBox(height: 16),
              Text(body, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutSettingsScreen extends StatelessWidget {
  const AboutSettingsScreen({super.key, required this.loadVersion});
  final Future<String> Function() loadVersion;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(text.settingsAbout),
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('/more/feature/settings'),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(text.settingsAboutDescription),
          ),
          ListTile(
            leading: const Icon(Icons.copyright_outlined),
            title: Text(text.settingsLicences),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                showLicensePage(context: context, applicationName: 'Poodle'),
          ),
          for (final (icon, label) in [
            (Icons.privacy_tip_outlined, text.settingsPrivacy),
            (Icons.accessibility_new, text.settingsAccessibility),
          ])
            ListTile(
              leading: Icon(icon),
              title: Text(label),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(label),
                  content: Text(text.settingsResourceComingSoon),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        MaterialLocalizations.of(dialogContext).okButtonLabel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          FutureBuilder<String>(
            future: loadVersion(),
            builder: (_, snapshot) => Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                snapshot.hasData
                    ? '${text.settingsVersion} ${snapshot.data}'
                    : text.settingsVersionUnavailable,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
