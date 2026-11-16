import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../../generated/protocol.dart';
import 'identity_locks.dart';

/// The shared grant policy for issuing and accepting scoped invitations.
abstract final class UniversityAccessAuthorization {
  static Future<UniversityRecord> requireGrant(
    Session session, {
    required UuidValue issuerId,
    required UuidValue universityId,
    required String purpose,
    required Transaction transaction,
    UuidValue? courseId,
    bool allowOperator = false,
  }) async {
    await IdentityLocks.university(session, universityId, transaction);
    final user = await AuthUser.db.findById(
      session,
      issuerId,
      lockMode: LockMode.forShare,
      transaction: transaction,
    );
    final issuer = await AccountAccess.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(issuerId),
      lockMode: LockMode.forShare,
      transaction: transaction,
    );
    final university = await UniversityRecord.db.findById(
      session,
      universityId,
      lockMode: LockMode.forShare,
      transaction: transaction,
    );
    if (user == null ||
        user.blocked ||
        issuer == null ||
        university == null ||
        !university.active) {
      throw IdentityAccessException(code: 'forbidden');
    }
    if (allowOperator && issuer.isAdmin) return university;
    if (issuer.universityId != universityId) {
      throw IdentityAccessException(code: 'forbidden');
    }
    if (purpose == 'student') {
      if (courseId == null) throw IdentityAccessException(code: 'forbidden');
      final course = await CourseRecord.db.findById(
        session,
        courseId,
        lockMode: LockMode.forShare,
        transaction: transaction,
      );
      final membership = await CourseMembership.db.findFirstRow(
        session,
        where: (t) =>
            t.authUserId.equals(issuerId) &
            t.courseId.equals(courseId) &
            t.active.equals(true) &
            t.role.equals('teacher'),
        lockMode: LockMode.forShare,
        transaction: transaction,
      );
      if (course == null ||
          course.universityId != universityId ||
          membership == null) {
        throw IdentityAccessException(code: 'forbidden');
      }
    } else if (!issuer.isUniversityAdmin ||
        !{'universityAdmin', 'teacherCandidate'}.contains(purpose)) {
      throw IdentityAccessException(code: 'forbidden');
    }
    return university;
  }
}
