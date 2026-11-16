import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../generated/protocol.dart';

/// Validates stored memberships with two batched reads, independent of row count.
abstract final class CourseTenancy {
  static Future<List<CourseMembership>> filter(
    Session session,
    List<CourseMembership> rows, {
    Transaction? transaction,
  }) async {
    final candidates = rows
        .where((r) => r.active && {'teacher', 'student'}.contains(r.role))
        .toList();
    if (candidates.isEmpty) return [];
    final userIds = candidates.map((r) => r.authUserId).toSet();
    final courseIds = candidates.map((r) => r.courseId).toSet();
    final accounts = await AccountAccess.db.find(
      session,
      where: (t) => t.authUserId.inSet(userIds),
      include: AccountAccess.include(
        authUser: AuthUser.include(),
        university: UniversityRecord.include(),
      ),
      transaction: transaction,
    );
    final courses = await CourseRecord.db.find(
      session,
      where: (t) => t.id.inSet(courseIds),
      transaction: transaction,
    );
    final byUser = {for (final a in accounts) a.authUserId: a};
    final byCourse = {for (final c in courses) c.id!: c};
    final legacyAllowed =
        session.serverpod.runMode == ServerpodRunMode.test ||
        session.serverpod.runMode == ServerpodRunMode.development;
    return candidates.where((row) {
      final account = byUser[row.authUserId];
      final course = byCourse[row.courseId];
      return account != null &&
          account.authUser?.blocked == false &&
          course != null &&
          account.universityId == course.universityId &&
          (course.published || row.role == 'teacher') &&
          (course.universityId == null
              ? legacyAllowed
              : account.university?.active == true);
    }).toList();
  }

  static Future<bool> permits(
    Session session,
    CourseMembership row, {
    Transaction? transaction,
  }) async =>
      (await filter(session, [row], transaction: transaction)).isNotEmpty;
}
