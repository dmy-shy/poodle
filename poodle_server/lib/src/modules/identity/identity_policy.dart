/// Input and lifecycle rules shared by identity operations.
abstract final class IdentityPolicy {
  static String normalizeEmail(String input) {
    final email = input.trim().toLowerCase();
    if (email.length > 254 ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      throw const FormatException('Invalid email address.');
    }
    return email;
  }

  static void validatePage({required int limit, required int offset}) {
    if (limit < 1 || limit > 100 || offset < 0) {
      throw ArgumentError('Use a page size of 1–100 and a nonnegative offset.');
    }
  }

  static DateTime invitationExpiry(DateTime createdAt) =>
      createdAt.toUtc().add(const Duration(days: 7));

  static bool invitationUsable({
    required DateTime now,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    DateTime? revokedAt,
  }) => acceptedAt == null && revokedAt == null && now.isBefore(expiresAt);
}
