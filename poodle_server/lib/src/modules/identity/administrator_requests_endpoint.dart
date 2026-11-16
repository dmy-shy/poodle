import 'identity_locks.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../../auth/transactional_email.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import 'identity_policy.dart';
import 'identity_service.dart';
import 'institution_mail.dart';
import '../notifications/notification_service.dart';

/// Public requests do not grant account access. Review requires platform authority.
class AdministratorRequestsEndpoint extends Endpoint {
  static final _emails = DatabaseRateLimiter(
    RateLimiterConfig(
      domain: 'poodle.adminRequests',
      source: 'email',
      maxAttempts: 3,
      timeframe: const Duration(hours: 1),
    ),
  );
  static final _global = DatabaseRateLimiter(
    RateLimiterConfig(
      domain: 'poodle.adminRequests',
      source: 'global',
      maxAttempts: 100,
      timeframe: const Duration(hours: 1),
    ),
  );

  Future<UuidValue> begin(
    Session session, {
    required String name,
    required String email,
    required String university,
    required String position,
    required String note,
    required String locale,
  }) async {
    final normalized = IdentityPolicy.normalizeEmail(email);
    for (final field in [(name, 120), (university, 200), (position, 120)]) {
      if (field.$1.trim().isEmpty || field.$1.length > field.$2) {
        throw IdentityAccessException(code: 'invalid_input');
      }
    }
    if (note.length > 2000 || !['en', 'uk'].contains(locale)) {
      throw IdentityAccessException(code: 'invalid_input');
    }
    if (!await _global.tryRecordAttempt(session, key: 'all') ||
        !await _emails.tryRecordAttempt(session, key: normalized)) {
      return const Uuid().v7obj();
    }
    final code = IdentityService.newVerificationCode();
    final row = await AdministratorRequestRecord.db.insertRow(
      session,
      AdministratorRequestRecord(
        name: name.trim(),
        email: normalized,
        university: university.trim(),
        position: position.trim(),
        note: note.trim(),
        locale: locale,
        codeHash: IdentityService.verificationCodeHash(code),
        expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 15)),
      ),
    );
    await TransactionalEmail.sendCode(
      session,
      email: normalized,
      code: code,
      purpose: 'administratorRequest',
      requestId: row.id!.toString(),
      locale: locale,
      expiresAt: row.expiresAt,
    );
    return row.id!;
  }

  Future<void> verify(
    Session session, {
    required UuidValue requestId,
    required String code,
  }) async {
    final valid = await session.db.transaction((tx) async {
      await IdentityLocks.email(session, 'admin-request:$requestId', tx);
      final row = await AdministratorRequestRecord.db.findById(
        session,
        requestId,
        transaction: tx,
      );
      if (row == null ||
          row.status != 'unverified' ||
          row.attempts >= 5 ||
          !row.expiresAt.isAfter(DateTime.now().toUtc())) {
        return false;
      }
      if (row.codeHash != IdentityService.verificationCodeHash(code.trim())) {
        await AdministratorRequestRecord.db.updateRow(
          session,
          row.copyWith(attempts: row.attempts + 1),
          transaction: tx,
        );
        return false;
      }
      // Only one verified pending request per address; duplicate forms are harmless.
      await IdentityLocks.email(session, row.email, tx);
      final pending = await AdministratorRequestRecord.db.findFirstRow(
        session,
        where: (t) => t.email.equals(row.email) & t.status.equals('pending'),
        transaction: tx,
      );
      final now = DateTime.now().toUtc();
      await AdministratorRequestRecord.db.updateRow(
        session,
        row.copyWith(
          status: pending == null ? 'pending' : 'duplicate',
          codeHash: '',
          verifiedAt: now,
        ),
        transaction: tx,
      );
      if (pending == null) {
        final admins = await AccountAccess.db.find(
          session,
          where: (t) => t.isAdmin.equals(true),
          transaction: tx,
        );
        for (final admin in admins) {
          await NotificationService().forUser(
            session,
            tx,
            recipientId: admin.authUserId,
            eventKey: 'administrator-request:$requestId',
            category: 'universityRequest',
            title: row.university,
            requestId: requestId,
          );
        }
      }
      final inbox = session.serverpod
          .getPassword('administratorRequestInbox')
          ?.trim();
      if (pending == null && inbox != null && inbox.isNotEmpty) {
        await InstitutionMailRecord.db.insertRow(
          session,
          InstitutionMailRecord(
            key: 'admin-request:$requestId',
            email: inbox,
            subject: 'Poodle administrator request',
            body:
                'A verified administrator request is ready for review. Open Administrator requests in Poodle. Request: $requestId',
          ),
          transaction: tx,
        );
      }
      return true;
    });
    if (!valid) throw IdentityAccessException(code: 'invalidCode');
  }

  Future<List<AdministratorRequestSummary>> list(
    Session session, {
    int offset = 0,
  }) async {
    await AccountAuthorization.requireAdmin(session);
    IdentityPolicy.validatePage(limit: 20, offset: offset);
    final rows = await AdministratorRequestRecord.db.find(
      session,
      where: (t) =>
          t.verifiedAt.notEquals(null) & t.status.notEquals('duplicate'),
      orderBy: (t) => t.createdAt.desc(),
      limit: 20,
      offset: offset,
    );
    return rows.map(_summary).toList();
  }

  Future<int> pendingCount(Session session) async {
    await AccountAuthorization.requireAdmin(session);
    return AdministratorRequestRecord.db.count(
      session,
      where: (t) => t.status.equals('pending') & t.verifiedAt.notEquals(null),
    );
  }

  Future<AdministratorRequestSummary?> get(
    Session session,
    UuidValue requestId,
  ) async {
    await AccountAuthorization.requireAdmin(session);
    final row = await AdministratorRequestRecord.db.findById(
      session,
      requestId,
    );
    if (row == null || row.verifiedAt == null || row.status == 'duplicate') {
      return null;
    }
    return _summary(row);
  }

  AdministratorRequestSummary _summary(AdministratorRequestRecord row) =>
      AdministratorRequestSummary(
        id: row.id!,
        name: row.name,
        email: row.email,
        university: row.university,
        position: row.position,
        note: row.note,
        status: row.status,
        createdAt: row.createdAt,
        reviewNote: row.reviewNote,
      );

  Future<List<UniversitySummary>> universities(Session session) async {
    await AccountAuthorization.requireAdmin(session);
    return (await UniversityRecord.db.find(
      session,
      where: (t) => t.active.equals(true),
      orderBy: (t) => t.name,
      limit: 200,
    )).map((r) => UniversitySummary(id: r.id!, name: r.name)).toList();
  }

  Future<UniversitySummary> approve(
    Session session, {
    required UuidValue requestId,
    required String universityName,
    required String slug,
    required String reviewNote,
    UuidValue? universityId,
  }) async {
    final operator = await AccountAuthorization.requireAdmin(session);
    if (reviewNote.trim().isEmpty ||
        reviewNote.length > 2000 ||
        universityName.trim().isEmpty ||
        universityName.length > 200 ||
        !RegExp(r'^[a-z0-9][a-z0-9-]{1,79}$').hasMatch(slug)) {
      throw IdentityAccessException(code: 'invalid_input');
    }
    return session.db.transaction((tx) async {
      await IdentityLocks.email(session, 'admin-request:$requestId', tx);
      final request = await AdministratorRequestRecord.db.findById(
        session,
        requestId,
        transaction: tx,
      );
      if (request == null || request.status != 'pending') {
        throw IdentityAccessException(code: 'requestUnavailable');
      }
      await IdentityLocks.email(session, request.email, tx);
      if (await IdentityService.emailOwnedByOther(
        session,
        request.email,
        transaction: tx,
      )) {
        throw IdentityAccessException(code: 'accountAlreadyExists');
      }
      if (await IdentityService.activeInvitation(
            session,
            request.email,
            transaction: tx,
          ) !=
          null) {
        throw IdentityAccessException(code: 'invitationConflict');
      }
      final university = universityId == null
          ? await UniversityRecord.db.insertRow(
              session,
              UniversityRecord(name: universityName.trim(), slug: slug),
              transaction: tx,
            )
          : await UniversityRecord.db.findById(
              session,
              universityId,
              transaction: tx,
            );
      if (university == null || !university.active) {
        throw IdentityAccessException(code: 'unavailable');
      }
      final invitation = await AccountInvitation.db.insertRow(
        session,
        AccountInvitation(
          email: request.email,
          purpose: 'universityAdmin',
          universityId: university.id!,
          issuerId: operator.authUserId,
          expiresAt: IdentityPolicy.invitationExpiry(DateTime.now().toUtc()),
        ),
        transaction: tx,
      );
      await AdministratorRequestRecord.db.updateRow(
        session,
        request.copyWith(
          status: 'approved',
          reviewedAt: DateTime.now().toUtc(),
          reviewerId: operator.authUserId,
          reviewNote: reviewNote.trim(),
          approvedUniversityId: university.id,
        ),
        transaction: tx,
      );
      await InstitutionMail.queue(
        session,
        key: 'invitation:${invitation.id}',
        email: request.email,
        subject: 'Poodle — administrator request approved / Заявку схвалено',
        body: InstitutionMail.invitationBody(
          request.email,
          university.name,
          'university administrator / адміністратора університету',
        ),
        transaction: tx,
      );
      return UniversitySummary(id: university.id!, name: university.name);
    });
  }

  Future<void> reject(
    Session session, {
    required UuidValue requestId,
    required String reason,
  }) async {
    final operator = await AccountAuthorization.requireAdmin(session);
    if (reason.trim().isEmpty || reason.length > 2000) {
      throw IdentityAccessException(code: 'invalid_input');
    }
    await session.db.transaction((tx) async {
      await IdentityLocks.email(session, 'admin-request:$requestId', tx);
      final row = await AdministratorRequestRecord.db.findById(
        session,
        requestId,
        transaction: tx,
      );
      if (row == null || row.status != 'pending') {
        throw IdentityAccessException(code: 'requestUnavailable');
      }
      await AdministratorRequestRecord.db.updateRow(
        session,
        row.copyWith(
          status: 'rejected',
          reviewedAt: DateTime.now().toUtc(),
          reviewerId: operator.authUserId,
          reviewNote: reason.trim(),
        ),
        transaction: tx,
      );
      await InstitutionMail.queue(
        session,
        key: 'request-rejected:$requestId',
        email: row.email,
        subject: 'Poodle — administrator request / Заявка адміністратора',
        body:
            'Your request was not approved. / Вашу заявку не схвалено.\n${reason.trim()}',
        transaction: tx,
      );
    });
  }

  Future<int> retryMail(Session session) async {
    await AccountAuthorization.requireAdmin(session);
    return InstitutionMail.deliverPending(session);
  }
}
