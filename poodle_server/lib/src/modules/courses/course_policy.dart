abstract final class CoursePolicy {
  static bool canRead({required bool active, required String role}) =>
      active && (role == 'student' || role == 'teacher');

  static String availability(DateTime now, DateTime? opens, DateTime? closes) {
    if (opens == null && closes == null) return 'unscheduled';
    if (opens != null && now.isBefore(opens)) return 'upcoming';
    if (closes != null && !now.isBefore(closes)) return 'closed';
    return 'available';
  }

  static bool seedAllowed(String mode, {bool testFixture = false}) =>
      mode == 'development' || (mode == 'test' && testFixture);
}
