import 'package:flutter/material.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/ui/theme/poodle_theme.dart';

Widget testApp(
  Widget child, {
  Locale locale = const Locale('en'),
}) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: PoodleTheme.build(),
  home: child,
);
