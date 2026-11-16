import 'package:poodle_server/src/modules/identity/identity_policy.dart';
import 'package:test/test.dart';

void main() {
  test('normalizes only email case and surrounding whitespace', () {
    expect(
      IdentityPolicy.normalizeEmail(' Teacher+Class@Example.COM '),
      'teacher+class@example.com',
    );
  });

  test('rejects invalid email before storage or delivery', () {
    for (final email in [
      '',
      'name',
      '@host.test',
      'a@',
      'a b@host.test',
      'a@host.test\nBcc: victim@host.test',
      '${'a' * 250}@example.test',
    ]) {
      expect(() => IdentityPolicy.normalizeEmail(email), throwsFormatException);
    }
  });

  test('requires a bounded page size and nonnegative offset', () {
    IdentityPolicy.validatePage(limit: 1, offset: 0);
    IdentityPolicy.validatePage(limit: 100, offset: 50);
    for (final limit in [-1, 0, 101]) {
      expect(
        () => IdentityPolicy.validatePage(limit: limit, offset: 0),
        throwsArgumentError,
      );
    }
    expect(
      () => IdentityPolicy.validatePage(limit: 20, offset: -1),
      throwsArgumentError,
    );
  });

  group('invitation eligibility', () {
    final created = DateTime.utc(2026, 10, 22);
    final expiry = created.add(const Duration(days: 7));

    test('expires after seven days at the exact expiry instant', () {
      expect(IdentityPolicy.invitationExpiry(created), expiry);
      expect(
        IdentityPolicy.invitationUsable(
          now: expiry.subtract(const Duration(microseconds: 1)),
          expiresAt: expiry,
        ),
        isTrue,
      );
      expect(
        IdentityPolicy.invitationUsable(now: expiry, expiresAt: expiry),
        isFalse,
      );
      expect(
        IdentityPolicy.invitationUsable(
          now: expiry.add(const Duration(seconds: 1)),
          expiresAt: expiry,
        ),
        isFalse,
      );
    });

    test('accepted or revoked invitations never authorize reuse', () {
      expect(
        IdentityPolicy.invitationUsable(
          now: created,
          expiresAt: expiry,
          acceptedAt: created,
        ),
        isFalse,
      );
      expect(
        IdentityPolicy.invitationUsable(
          now: created,
          expiresAt: expiry,
          revokedAt: created,
        ),
        isFalse,
      );
    });
  });
}
