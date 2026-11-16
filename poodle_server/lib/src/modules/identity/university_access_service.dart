import 'university_access_authorization.dart';
import 'identity_locks.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import 'identity_policy.dart';
import 'identity_service.dart';
import 'institution_mail.dart';

class UniversityAccessService {
  Future<AccountSnapshot> _administrator(Session session) async {
    final account = await AccountAuthorization.requireAccount(session);
    if (!account.isUniversityAdmin || account.universityId == null) {
      throw IdentityAccessException(code: 'forbidden');
    }
    return account;
  }

  Future<void> invite(
    Session session, {
    required String email,
    required String purpose,
    UuidValue? courseId,
  }) async {
    final account = await AccountAuthorization.requireAccount(session);
    if (account.universityId == null ||
        !['universityAdmin', 'teacherCandidate', 'student'].contains(purpose)) {
      throw IdentityAccessException(code: 'forbidden');
    }
    if ((purpose == 'student') != (courseId != null)) {
      throw IdentityAccessException(code: 'invalid_input');
    }
    final normalized = IdentityPolicy.normalizeEmail(email);
    await session.db.transaction((tx) async {
      await IdentityLocks.email(session, normalized, tx);
      final university = await UniversityAccessAuthorization.requireGrant(
        session,
        issuerId: account.authUserId,
        universityId: account.universityId!,
        purpose: purpose,
        courseId: courseId,
        transaction: tx,
      );
      final existing = await AccountAccess.db.findFirstRow(
        session,
        where: (t) => t.verifiedEmail.equals(normalized),
        transaction: tx,
      );
      if (existing != null) {
        if (existing.universityId != account.universityId || existing.isAdmin) {
          throw IdentityAccessException(code: 'universityConflict');
        }
        if (purpose == 'student') {
          final member = await CourseMembership.db.findFirstRow(
            session,
            where: (t) =>
                t.courseId.equals(courseId!) &
                t.authUserId.equals(existing.authUserId),
            transaction: tx,
          );
          if (member == null) {
            await CourseMembership.db.insertRow(
              session,
              CourseMembership(
                courseId: courseId!,
                authUserId: existing.authUserId,
                role: 'student',
              ),
              transaction: tx,
            );
          } else if (!member.active) {
            await CourseMembership.db.updateRow(
              session,
              member.copyWith(active: true),
              transaction: tx,
            );
          }
        } else {
          await AccountAccess.db.updateRow(
            session,
            existing.copyWith(
              isUniversityAdmin: purpose == 'universityAdmin'
                  ? true
                  : existing.isUniversityAdmin,
              teacherApproved: purpose == 'teacherCandidate'
                  ? true
                  : existing.teacherApproved,
            ),
            transaction: tx,
          );
        }
        await AccessGrantAudit.db.insertRow(
          session,
          AccessGrantAudit(
            actorId: account.authUserId,
            subjectEmail: normalized,
            universityId: account.universityId,
            action: purpose,
          ),
          transaction: tx,
        );
        final eventId = const Uuid().v7obj();
        await InstitutionMail.queue(
          session,
          key: 'access:$eventId',
          email: normalized,
          subject: 'Poodle — access updated / Доступ оновлено',
          body:
              '${university.name}: $purpose. Sign in to Poodle. / Увійдіть до Poodle.',
          transaction: tx,
        );
        return;
      }
      if (await IdentityService.emailOwnedByOther(
        session,
        normalized,
        transaction: tx,
      )) {
        throw IdentityAccessException(code: 'accountAlreadyExists');
      }
      final pending = await IdentityService.activeInvitation(
        session,
        normalized,
        transaction: tx,
      );
      if (pending != null) {
        if (pending.universityId != account.universityId ||
            pending.purpose != purpose ||
            pending.courseId != courseId) {
          throw IdentityAccessException(code: 'invitationConflict');
        }
        return;
      }
      final invitation = await AccountInvitation.db.insertRow(
        session,
        AccountInvitation(
          email: normalized,
          purpose: purpose,
          universityId: account.universityId,
          courseId: courseId,
          issuerId: account.authUserId,
          expiresAt: IdentityPolicy.invitationExpiry(DateTime.now().toUtc()),
        ),
        transaction: tx,
      );
      await InstitutionMail.queue(
        session,
        key: 'invitation:${invitation.id}',
        email: normalized,
        subject: 'Poodle — invitation / Запрошення',
        body: InstitutionMail.invitationBody(
          normalized,
          university.name,
          purpose,
        ),
        transaction: tx,
      );
    });
  }

  Future<List<InvitationSummary>> invitations(
    Session session, {
    int offset = 0,
  }) async {
    final account = await _administrator(session);
    IdentityPolicy.validatePage(limit: 20, offset: offset);
    final rows = await AccountInvitation.db.find(
      session,
      where: (t) => t.universityId.equals(account.universityId),
      orderBy: (t) => t.createdAt.desc(),
      limit: 20,
      offset: offset,
    );
    return rows.map(IdentityService.summary).toList();
  }

  Future<void> revoke(Session session, UuidValue invitationId) async {
    final account = await _administrator(session);
    final original = await AccountInvitation.db.findById(session, invitationId);
    if (original == null || original.universityId != account.universityId) {
      throw IdentityAccessException(code: 'forbidden');
    }
    await session.db.transaction((tx) async {
      await IdentityLocks.email(session, original.email, tx);
      await UniversityAccessAuthorization.requireGrant(
        session,
        issuerId: account.authUserId,
        universityId: account.universityId!,
        purpose: 'universityAdmin',
        transaction: tx,
      );
      await IdentityService.revokeInvitation(
        session,
        invitationId,
        transaction: tx,
      );
    });
  }

  Future<List<UniversityMemberSummary>> members(
    Session session, {
    int offset = 0,
  }) async {
    final account = await _administrator(session);
    IdentityPolicy.validatePage(limit: 50, offset: offset);
    final rows = await AccountAccess.db.find(
      session,
      where: (t) => t.universityId.equals(account.universityId),
      orderBy: (t) => t.authUserId,
      limit: 50,
      offset: offset,
    );
    return rows
        .map(
          (r) => UniversityMemberSummary(
            userId: r.authUserId,
            email: r.verifiedEmail ?? r.authUserId.toString(),
            administrator: r.isUniversityAdmin,
            teacherApproved: r.teacherApproved,
          ),
        )
        .toList();
  }

  Future<void> setAdministrator(
    Session session, {
    required UuidValue userId,
    required bool enabled,
  }) async {
    final account = await _administrator(session);
    await session.db.transaction((tx) async {
      await UniversityAccessAuthorization.requireGrant(
        session,
        issuerId: account.authUserId,
        universityId: account.universityId!,
        purpose: 'universityAdmin',
        transaction: tx,
      );
      final target = await AccountAccess.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(userId),
        transaction: tx,
      );
      if (target == null ||
          target.universityId != account.universityId ||
          target.isAdmin) {
        throw IdentityAccessException(code: 'forbidden');
      }
      if (!enabled && target.isUniversityAdmin) {
        final others = await AccountAccess.db.find(
          session,
          where: (t) =>
              t.universityId.equals(account.universityId) &
              t.isUniversityAdmin.equals(true) &
              t.authUserId.notEquals(userId),
          include: AccountAccess.include(authUser: AuthUser.include()),
          transaction: tx,
        );
        if (!others.any((row) => row.authUser?.blocked == false)) {
          throw IdentityAccessException(code: 'lastAdministrator');
        }
      }
      await AccountAccess.db.updateRow(
        session,
        target.copyWith(isUniversityAdmin: enabled),
        transaction: tx,
      );
      await AccessGrantAudit.db.insertRow(
        session,
        AccessGrantAudit(
          actorId: account.authUserId,
          subjectEmail: target.verifiedEmail ?? target.authUserId.toString(),
          universityId: account.universityId,
          action: 'administrator:$enabled',
        ),
        transaction: tx,
      );
      final eventId = const Uuid().v7obj();
      final targetEmail = await AccountAuthorization.emailForUser(
        session,
        target.authUserId,
        verifiedEmail: target.verifiedEmail,
        transaction: tx,
      );
      if (targetEmail == null) return;
      await InstitutionMail.queue(
        session,
        key: 'admin-grant:$eventId',
        email: targetEmail,
        subject: 'Poodle — administrator access / Доступ адміністратора',
        body:
            'University administrator access: $enabled. Changed by ${account.email}. / Доступ адміністратора університету: $enabled.',
        transaction: tx,
      );
    });
  }
}
