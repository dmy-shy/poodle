import 'university_access_authorization.dart';
import 'identity_locks.dart';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

import '../../generated/protocol.dart';
import 'identity_policy.dart';

/// Transactional invitation operations shared with the email provider.
abstract final class IdentityService {
  static String verificationCodeHash(String code) =>
      sha256.convert(utf8.encode(code)).toString();

  static String newVerificationCode() {
    const digits = '123456789';
    final random = Random.secure();
    return List.generate(
      8,
      (_) => digits[random.nextInt(digits.length)],
    ).join();
  }

  static DateTime emailChangeExpiry(DateTime now) =>
      now.toUtc().add(const Duration(minutes: 15));

  static DateTime resendAvailableAt(DateTime now) =>
      now.toUtc().add(const Duration(minutes: 1));
  static Future<bool> emailOwnedByOther(
    Session session,
    String email, {
    UuidValue? except,
    Transaction? transaction,
  }) async {
    final emails = await EmailAccount.db.find(
      session,
      where: (t) => t.email.equals(email),
      transaction: transaction,
    );
    final google = await GoogleAccount.db.find(
      session,
      where: (t) => t.email.equals(email),
      transaction: transaction,
    );
    return emails.any((a) => a.authUserId != except) ||
        google.any((a) => a.authUserId != except);
  }

  static Future<AccountInvitation?> activeInvitation(
    Session session,
    String email, {
    Transaction? transaction,
  }) => AccountInvitation.db.findFirstRow(
    session,
    where: (t) =>
        t.email.equals(email) &
        t.acceptedAt.equals(null) &
        t.revokedAt.equals(null) &
        (t.expiresAt > DateTime.now().toUtc()),
    orderBy: (t) => t.id,
    transaction: transaction,
  );

  static InvitationSummary summary(AccountInvitation invitation) =>
      InvitationSummary(
        id: invitation.id!,
        email: invitation.email,
        purpose: invitation.purpose,
        courseId: invitation.courseId,
        createdAt: invitation.createdAt,
        expiresAt: invitation.expiresAt,
        acceptedAt: invitation.acceptedAt,
        revokedAt: invitation.revokedAt,
      );

  static Future<InvitationSummary> createInvitation(
    Session session, {
    required String email,
    required UuidValue issuerId,
  }) async {
    final normalized = IdentityPolicy.normalizeEmail(email);
    return session.db.transaction((tx) async {
      await IdentityLocks.email(session, normalized, tx);
      if (await emailOwnedByOther(session, normalized, transaction: tx)) {
        throw IdentityAccessException(code: 'accountAlreadyExists');
      }
      final existing = await activeInvitation(
        session,
        normalized,
        transaction: tx,
      );
      if (existing != null) return summary(existing);
      final now = DateTime.now().toUtc();
      return summary(
        await AccountInvitation.db.insertRow(
          session,
          AccountInvitation(
            email: normalized,
            purpose: 'teacherCandidate',
            issuerId: issuerId,
            createdAt: now,
            expiresAt: IdentityPolicy.invitationExpiry(now),
          ),
          transaction: tx,
        ),
      );
    });
  }

  static Future<void> revokeInvitation(
    Session session,
    UuidValue id, {
    Transaction? transaction,
  }) async {
    Future<void> revoke(Transaction tx) async {
      final original = await AccountInvitation.db.findById(
        session,
        id,
        transaction: tx,
      );
      if (original == null) return;
      await IdentityLocks.email(session, original.email, tx);
      final current = await AccountInvitation.db.findById(
        session,
        id,
        transaction: tx,
      );
      if (current == null ||
          current.acceptedAt != null ||
          current.revokedAt != null) {
        return;
      }
      await AccountInvitation.db.updateRow(
        session,
        current.copyWith(revokedAt: DateTime.now().toUtc()),
        transaction: tx,
      );
    }

    if (transaction != null) {
      await revoke(transaction);
    } else {
      await session.db.transaction(revoke);
    }
  }

  /// Runs inside the email provider's account-creation transaction. Throwing
  /// rolls back both the built-in account and the application access record.
  static Future<void> acceptInvitation(
    Session session, {
    required String email,
    required UuidValue authUserId,
    required Transaction transaction,
  }) async {
    final normalized = IdentityPolicy.normalizeEmail(email);
    await IdentityLocks.email(session, normalized, transaction);
    if (await emailOwnedByOther(
      session,
      normalized,
      except: authUserId,
      transaction: transaction,
    )) {
      throw IdentityAccessException(code: 'accountAlreadyExists');
    }
    final invitation = await activeInvitation(
      session,
      normalized,
      transaction: transaction,
    );
    if (invitation == null ||
        !IdentityPolicy.invitationUsable(
          now: DateTime.now().toUtc(),
          expiresAt: invitation.expiresAt,
          acceptedAt: invitation.acceptedAt,
          revokedAt: invitation.revokedAt,
        )) {
      throw IdentityAccessException(code: 'invitationUnavailable');
    }
    if (![
      'teacherCandidate',
      'universityAdmin',
      'student',
      'platformOperator',
    ].contains(invitation.purpose)) {
      throw IdentityAccessException(code: 'invitationUnavailable');
    }
    if (invitation.purpose == 'platformOperator') {
      // The bootstrap mailbox must match server configuration and no operator may exist yet.
      await IdentityLocks.operatorBootstrap(session, transaction);
      final configured = session.serverpod.getPassword(
        'initialPlatformOperatorEmail',
      );
      if (configured == null ||
          IdentityPolicy.normalizeEmail(configured) != normalized ||
          await AccountAccess.db.count(
                session,
                where: (t) => t.isAdmin.equals(true),
                transaction: transaction,
              ) !=
              0) {
        throw IdentityAccessException(code: 'invitationUnavailable');
      }
    } else if (invitation.universityId != null) {
      if (invitation.issuerId == null) {
        throw IdentityAccessException(code: 'invitationUnavailable');
      }
      try {
        await UniversityAccessAuthorization.requireGrant(
          session,
          issuerId: invitation.issuerId!,
          universityId: invitation.universityId!,
          purpose: invitation.purpose,
          courseId: invitation.courseId,
          allowOperator: true,
          transaction: transaction,
        );
      } on IdentityAccessException {
        throw IdentityAccessException(code: 'invitationUnavailable');
      }
    }
    await AccessGrantAudit.db.insertRow(
      session,
      AccessGrantAudit(
        actorId: invitation.issuerId,
        subjectEmail: normalized,
        universityId: invitation.universityId,
        action: 'accepted:${invitation.purpose}',
      ),
      transaction: transaction,
    );
    await AccountAccess.db.insertRow(
      session,
      AccountAccess(
        authUserId: authUserId,
        teacherApproved: invitation.purpose == 'teacherCandidate',
        universityId: invitation.universityId,
        isUniversityAdmin: invitation.purpose == 'universityAdmin',
        isAdmin: invitation.purpose == 'platformOperator',
        verifiedEmail: normalized,
      ),
      transaction: transaction,
    );
    if (invitation.purpose == 'student') {
      final course = invitation.courseId == null
          ? null
          : await CourseRecord.db.findById(
              session,
              invitation.courseId!,
              transaction: transaction,
            );
      if (course == null || course.universityId != invitation.universityId) {
        throw IdentityAccessException(code: 'invitationUnavailable');
      }
      await CourseMembership.db.insertRow(
        session,
        CourseMembership(
          courseId: course.id!,
          authUserId: authUserId,
          role: 'student',
        ),
        transaction: transaction,
      );
    }
    await AccountInvitation.db.updateRow(
      session,
      invitation.copyWith(
        acceptedAt: DateTime.now().toUtc(),
        acceptedById: authUserId,
      ),
      transaction: transaction,
    );
  }
}
