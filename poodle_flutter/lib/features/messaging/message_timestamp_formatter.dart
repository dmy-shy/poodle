import 'package:intl/intl.dart';

class MessageTimestampFormatter {
  const MessageTimestampFormatter(this.locale);

  final String locale;

  DateTime localDate(DateTime instant) => instant.toLocal();

  String time(DateTime instant) =>
      DateFormat('HH:mm', locale).format(localDate(instant));

  String inbox(DateTime instant, DateTime now) {
    final date = localDate(instant);
    final today = _day(localDate(now));
    final age = today.difference(_day(date)).inDays;
    if (age == 0) return time(instant);
    if (age >= 1 && age <= 6) return DateFormat.E(locale).format(date);
    return DateFormat.yMd(locale).format(date);
  }

  String day(
    DateTime instant,
    DateTime now, {
    required String today,
    required String yesterday,
  }) {
    final date = localDate(instant);
    final age = _day(localDate(now)).difference(_day(date)).inDays;
    if (age == 0) return today;
    if (age == 1) return yesterday;
    return DateFormat.yMMMMd(locale).format(date);
  }

  String full(DateTime instant) =>
      DateFormat.yMMMMEEEEd(locale).add_Hm().format(localDate(instant));

  bool sameDay(DateTime first, DateTime second) =>
      _day(localDate(first)) == _day(localDate(second));

  // UTC calendar arithmetic keeps daylight-saving days from becoming 23 or 25 hours.
  DateTime _day(DateTime date) => DateTime.utc(date.year, date.month, date.day);
}
