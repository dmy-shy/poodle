import 'package:poodle_server/src/modules/courses/course_policy.dart';
import 'package:test/test.dart';

void main() {
  test('only active student or teacher membership permits course reads', () {
    expect(CoursePolicy.canRead(active: true, role: 'student'), isTrue);
    expect(CoursePolicy.canRead(active: true, role: 'teacher'), isTrue);
    expect(CoursePolicy.canRead(active: false, role: 'teacher'), isFalse);
    expect(CoursePolicy.canRead(active: true, role: 'admin'), isFalse);
  });
  test('opening and closing boundaries use server time', () {
    final opens = DateTime.utc(2026, 10, 20, 9);
    final closes = opens.add(const Duration(hours: 1));
    expect(
      CoursePolicy.availability(
        opens.subtract(const Duration(seconds: 1)),
        opens,
        closes,
      ),
      'upcoming',
    );
    expect(CoursePolicy.availability(opens, opens, closes), 'available');
    expect(CoursePolicy.availability(closes, opens, closes), 'closed');
    expect(CoursePolicy.availability(opens, null, null), 'unscheduled');
  });
  test('development seed is never enabled in staging or production', () {
    expect(CoursePolicy.seedAllowed('development'), isTrue);
    expect(CoursePolicy.seedAllowed('test'), isFalse);
    expect(CoursePolicy.seedAllowed('test', testFixture: true), isTrue);
    expect(CoursePolicy.seedAllowed('production', testFixture: true), isFalse);
    expect(CoursePolicy.seedAllowed('staging', testFixture: true), isFalse);
  });
}
