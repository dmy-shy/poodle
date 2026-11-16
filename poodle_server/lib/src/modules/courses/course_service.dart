import 'package:serverpod/serverpod.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import 'course_policy.dart';
import 'course_repository.dart';

class CourseService {
  CourseService({CourseRepository? repository})
    : _repository = repository ?? CourseRepository();
  final CourseRepository _repository;

  Future<CourseSummary> create(Session session, String title) async {
    final account = await AccountAuthorization.requireAccount(session);
    if (!account.teacherApproved || account.universityId == null) {
      throw IdentityAccessException(code: 'forbidden');
    }
    final university = await UniversityRecord.db.findById(
      session,
      account.universityId!,
    );
    if (university == null || !university.active) {
      throw IdentityAccessException(code: 'forbidden');
    }
    final normalized = title.trim();
    if (normalized.isEmpty || normalized.length > 200) {
      throw IdentityAccessException(code: 'invalidCourseTitle');
    }
    return session.db.transaction((tx) async {
      final course = await CourseRecord.db.insertRow(
        session,
        CourseRecord(
          title: normalized,
          universityId: account.universityId,
          published: false,
        ),
        transaction: tx,
      );
      await CourseMembership.db.insertRow(
        session,
        CourseMembership(
          courseId: course.id!,
          authUserId: account.authUserId,
          role: 'teacher',
        ),
        transaction: tx,
      );
      return project(course, role: 'teacher');
    });
  }

  Future<CourseSummary> setPublished(
    Session session,
    UuidValue courseId,
    bool published,
  ) async {
    final access = await requireMember(session, courseId);
    if (access.membership.role != 'teacher') {
      throw IdentityAccessException(code: 'forbidden');
    }
    final updated = await CourseRecord.db.updateRow(
      session,
      access.course.copyWith(published: published),
    );
    return project(updated, role: 'teacher');
  }

  Future<({CourseRecord course, CourseMembership membership})> requireMember(
    Session session,
    UuidValue courseId,
  ) async {
    final account = await AccountAuthorization.requireAccount(session);
    final member = await _repository.membership(
      session,
      courseId,
      account.authUserId,
    );
    if (member == null ||
        !CoursePolicy.canRead(active: member.active, role: member.role)) {
      throw CourseReadException(code: 'unavailable');
    }
    final course = await _repository.course(session, courseId);
    if (course == null ||
        course.universityId != account.universityId ||
        (!course.published && member.role != 'teacher')) {
      throw CourseReadException(code: 'unavailable');
    }
    return (course: course, membership: member);
  }

  CourseSummary project(
    CourseRecord course, {
    CoursePreference? preference,
    String? role,
  }) => CourseSummary(
    id: course.id!,
    role: role,
    title: course.title,
    published: course.published,
    category: course.category,
    summary: course.summary,
    teacherName: course.teacherName,
    sample: course.seedOwned,
    starred: preference?.starred ?? false,
    hidden: preference?.hidden ?? false,
  );

  Future<List<CourseSummary>> list(Session session) async {
    final account = await AccountAuthorization.requireAccount(session);
    final courses = await _repository.list(
      session,
      account.authUserId,
    );
    return [
      for (final row in courses)
        if (row.course.universityId == account.universityId)
          project(
            row.course,
            role: row.membership.role,
            preference: row.preference,
          ),
    ];
  }

  Future<CourseSummary> get(Session session, UuidValue courseId) async {
    final account = await AccountAuthorization.requireAccount(session);
    final access = await requireMember(session, courseId);
    return project(
      access.course,
      role: access.membership.role,
      preference: await _repository.preference(
        session,
        account.authUserId,
        courseId,
      ),
    );
  }
}
