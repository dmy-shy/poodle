import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Rechecks persisted authority and session validity on every protected call.
abstract final class AccountAuthorization {
  static Future<String?> emailForUser(
    Session session,
    UuidValue userId, {
    String? verifiedEmail,
    Transaction? transaction,
  }) async {
    if (verifiedEmail != null) return verifiedEmail;
    final email = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    if (email != null) return email.email;
    return (await GoogleAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    ))?.email;
  }

  static Future<AccountSnapshot> requireAccount(Session session) async {
    final authentication = session.authenticated;
    if (authentication == null) {
      throw IdentityAccessException(code: 'unauthenticated');
    }
    final UuidValue userId;
    final UuidValue tokenId;
    try {
      userId = UuidValue.withValidation(authentication.userIdentifier);
      tokenId = UuidValue.withValidation(authentication.authId);
    } on FormatException {
      throw IdentityAccessException(code: 'unauthenticated');
    }
    final user = await AuthUser.db.findById(session, userId);
    final token = await RefreshToken.db.findById(session, tokenId);
    final lifetime = AuthServices.getTokenManager<JwtTokenManager>()
        .jwt
        .config
        .refreshTokenLifetime;
    if (user == null ||
        user.blocked ||
        token == null ||
        token.authUserId != userId ||
        !token.lastUpdatedAt.add(lifetime).isAfter(DateTime.now().toUtc())) {
      throw IdentityAccessException(code: 'unauthenticated');
    }
    final access = await AccountAccess.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    final email = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    final google = await GoogleAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    if (access == null || (email == null && google == null)) {
      throw IdentityAccessException(code: 'unauthenticated');
    }
    final university = access.universityId == null
        ? null
        : await UniversityRecord.db.findById(session, access.universityId!);
    if (access.universityId != null &&
        (university == null || !university.active)) {
      throw IdentityAccessException(code: 'forbidden');
    }
    return AccountSnapshot(
      authUserId: userId,
      email: access.verifiedEmail ?? email?.email ?? google!.email,
      googleLinked: google != null,
      hasPassword: email?.passwordHash.isNotEmpty ?? false,
      isAdmin: access.isAdmin,
      universityId: access.universityId,
      isUniversityAdmin: access.isUniversityAdmin,
      teacherApproved: access.teacherApproved,
    );
  }

  static Future<AccountSnapshot> requireAdmin(Session session) async {
    final account = await requireAccount(session);
    if (!account.isAdmin) throw IdentityAccessException(code: 'forbidden');
    return account;
  }
}
