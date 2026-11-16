import 'dart:async';

/// Request-local language for SDK callbacks that have no locale parameter.
abstract final class EmailDeliveryContext {
  static final _localeKey = Object();
  static String get locale => Zone.current[_localeKey] as String? ?? 'en';

  static Future<T> run<T>(String locale, Future<T> Function() operation) =>
      runZoned(
        operation,
        zoneValues: {_localeKey: locale == 'uk' ? 'uk' : 'en'},
      );
}
