import '../../core/course_tenancy.dart';
import 'package:serverpod/serverpod.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';

/// Administrative metadata only; global admin authority grants no content access.
class AdminOverviewService {
  Future<AdminOverview> summary(Session session) async {
    await AccountAuthorization.requireAdmin(session);
    final people = await _people(session);
    final now = DateTime.now().toUtc();
    final invitations = await AccountInvitation.db.find(session);
    return AdminOverview(
      accounts: people.length,
      students: people.where((p) => p.student).length,
      teachers: people.where((p) => p.teacher).length,
      admins: people.where((p) => p.admin).length,
      courses: await CourseRecord.db.count(session),
      pendingInvitations: invitations
          .where(
            (i) =>
                i.acceptedAt == null &&
                i.revokedAt == null &&
                i.expiresAt.isAfter(now),
          )
          .length,
    );
  }

  Future<List<AdminDirectoryRow>> list(
    Session session,
    String category,
    int offset,
  ) async {
    await AccountAuthorization.requireAdmin(session);
    if (offset < 0 ||
        ![
          'accounts',
          'students',
          'teachers',
          'admins',
          'courses',
        ].contains(category)) {
      throw IdentityAccessException(code: 'invalid_input');
    }
    if (category == 'courses') {
      final courses = await CourseRecord.db.find(
        session,
        orderByList: (t) => [t.title, t.id],
        limit: 50,
        offset: offset,
      );
      final members = await CourseTenancy.filter(
        session,
        await CourseMembership.db.find(
          session,
          where: (t) => t.active.equals(true),
        ),
      );
      return [
        for (final c in courses)
          AdminDirectoryRow(
            id: c.id.toString(),
            label: c.title,
            students: members
                .where((m) => m.courseId == c.id && m.role == 'student')
                .length,
            teachers: members
                .where((m) => m.courseId == c.id && m.role == 'teacher')
                .length,
          ),
      ];
    }
    final people = (await _people(session))
        .where(
          (p) => switch (category) {
            'students' => p.student,
            'teachers' => p.teacher,
            'admins' => p.admin,
            _ => true,
          },
        )
        .toList();
    return people.skip(offset).take(50).toList();
  }

  Future<List<AdminDirectoryRow>> _people(Session session) async {
    final accounts = await AccountAccess.db.find(session);
    final members = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) => t.active.equals(true),
      ),
    );
    final result = [
      for (final a in accounts)
        AdminDirectoryRow(
          id: a.authUserId.toString(),
          label: a.verifiedEmail ?? a.authUserId.toString(),
          admin: a.isAdmin,
          student: members.any(
            (m) => m.authUserId == a.authUserId && m.role == 'student',
          ),
          teacher: members.any(
            (m) => m.authUserId == a.authUserId && m.role == 'teacher',
          ),
        ),
    ];
    result.sort((a, b) {
      final label = a.label.compareTo(b.label);
      return label != 0 ? label : a.id.compareTo(b.id);
    });
    return result;
  }
}
