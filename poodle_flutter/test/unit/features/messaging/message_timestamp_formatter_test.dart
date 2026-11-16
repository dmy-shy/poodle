import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poodle_flutter/features/messaging/message_timestamp_formatter.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('uk');
  });
  final now = DateTime(2026, 11, 15, 12);

  test('inbox uses local calendar days and a 24-hour clock', () {
    const formatter = MessageTimestampFormatter('en');
    expect(formatter.inbox(DateTime(2026, 11, 15, 1, 49), now), '01:49');
    expect(formatter.inbox(DateTime(2026, 11, 14, 23), now), 'Sat');
    expect(formatter.inbox(DateTime(2026, 11, 9, 9), now), 'Mon');
    expect(formatter.inbox(DateTime(2026, 11, 8, 23), now), '11/8/2026');
    expect(formatter.inbox(DateTime(2027, 1, 1), now), '1/1/2027');
  });

  test('Ukrainian labels and day dividers follow the selected locale', () {
    const formatter = MessageTimestampFormatter('uk');
    expect(formatter.inbox(DateTime(2026, 3, 24), now), '24.03.2026');
    expect(
      formatter.day(
        DateTime(2026, 11, 15),
        now,
        today: 'Сьогодні',
        yesterday: 'Учора',
      ),
      'Сьогодні',
    );
    expect(
      formatter.day(
        DateTime(2026, 11, 14),
        now,
        today: 'Сьогодні',
        yesterday: 'Учора',
      ),
      'Учора',
    );
    expect(
      formatter.sameDay(DateTime(2026, 11, 14, 1), DateTime(2026, 11, 14, 23)),
      isTrue,
    );
    expect(
      formatter.sameDay(DateTime(2026, 11, 14, 23), DateTime(2026, 11, 15)),
      isFalse,
    );
  });
}
