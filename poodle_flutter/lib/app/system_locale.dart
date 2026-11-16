import 'package:flutter/widgets.dart';

/// Only the primary system locale determines the interface language.
Locale resolveSystemLocale(Locale? locale) =>
    Locale(locale?.languageCode == 'uk' ? 'uk' : 'en');
