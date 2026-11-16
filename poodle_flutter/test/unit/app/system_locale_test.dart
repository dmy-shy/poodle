import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/app/system_locale.dart';

void main() {
  test(
    'primary system language resolves to Ukrainian, English, or English fallback',
    () {
      expect(resolveSystemLocale(const Locale('uk', 'UA')), const Locale('uk'));
      expect(resolveSystemLocale(const Locale('en', 'GB')), const Locale('en'));
      expect(resolveSystemLocale(const Locale('en', 'US')), const Locale('en'));
      expect(resolveSystemLocale(const Locale('pl', 'PL')), const Locale('en'));
      expect(resolveSystemLocale(null), const Locale('en'));
    },
  );
}
