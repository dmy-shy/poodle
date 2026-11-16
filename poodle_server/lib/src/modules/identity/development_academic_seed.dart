import 'identity_locks.dart';
import 'legacy_university.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../generated/protocol.dart';
import '../notebook/development_english_seed.dart';
import '../notebook/development_notebook_seed.dart';
import 'development_admin_seed.dart';
import 'identity_policy.dart';

typedef DevelopmentLogin = ({
  String email,
  String password,
  UuidValue? expectedUserId,
});

enum DevelopmentPersona { admin, teacher, student }

class _SeedConflict implements Exception {
  const _SeedConflict(this.reason);
  final String reason;
}

/// Installs the academic fixture once, without taking over accounts by email.
abstract final class DevelopmentAcademicSeed {
  static Future<void> fromLocalConfig(Serverpod pod) async {
    if (pod.runMode != ServerpodRunMode.development) return;
    String? read(DevelopmentPersona persona, String key) {
      final name = persona.name;
      return pod.getPassword(
        'poodleDevelopment${name[0].toUpperCase()}${name.substring(1)}$key',
      );
    }

    final config = {
      for (final persona in DevelopmentPersona.values)
        persona: (
          email: read(persona, 'Email'),
          password: read(persona, 'Password'),
          expected: read(persona, 'ExpectedAuthUserId'),
        ),
    };
    if (config.values.every(
      (v) => v.email == null && v.password == null && v.expected == null,
    )) {
      return;
    }
    final session = await pod.createSession(enableLogging: false);
    String? message;
    try {
      final logins = <DevelopmentPersona, DevelopmentLogin>{};
      for (final MapEntry(:key, :value) in config.entries) {
        final (email: email, password: password, expected: expected) = value;
        if (email == null || password == null || password.isEmpty) {
          throw _SeedConflict('incomplete ${key.name} credentials');
        }
        logins[key] = (
          email: email,
          password: password,
          expectedUserId: expected == null
              ? null
              : UuidValue.withValidation(expected.trim()),
        );
      }
      final installed = await ensure(session, logins);
      await DevelopmentNotebookSeed.ensureLinearAlgebra(
        session,
        courseId: _id(0, 1),
        sectionId: _id(0, 2),
      );
      if (installed != null) {
        message = 'Installed academic development fixtures.';
        await DevelopmentEnglishSeed.fromLocalConfig(
          pod,
          teacher: installed[DevelopmentPersona.teacher]!,
          student: installed[DevelopmentPersona.student]!,
        );
      }
    } on FormatException {
      message = 'Academic development seed skipped: invalid email or user ID.';
    } on _SeedConflict catch (error) {
      message = 'Academic development seed skipped: ${error.reason}.';
    } finally {
      await session.close();
    }
    if (message != null) {
      final logger = await pod.createSession();
      try {
        logger.log(message);
      } finally {
        await logger.close();
      }
    }
  }

  static Future<Map<DevelopmentPersona, UuidValue>?> ensure(
    Session session,
    Map<DevelopmentPersona, DevelopmentLogin> logins, {
    bool testFixture = false,
  }) async {
    if (!DevelopmentAdminSeed.allowedMode(
      session.serverpod.runMode,
      testFixture: testFixture,
    )) {
      throw StateError('Academic fixtures are restricted to development.');
    }
    if (logins.length != DevelopmentPersona.values.length ||
        logins.values.any((login) => login.password.isEmpty)) {
      throw const _SeedConflict('incomplete credentials');
    }
    final emails = logins.map(
      (key, login) => MapEntry(key, IdentityPolicy.normalizeEmail(login.email)),
    );
    if (emails.values.toSet().length != emails.length ||
        !emails[DevelopmentPersona.student]!.endsWith('@lntu.edu.ua')) {
      throw const _SeedConflict('expected distinct logins and an LNTU student');
    }

    return session.db.transaction((tx) async {
      await IdentityLocks.email(session, 'academic-fixtures-v1', tx);
      await LegacyUniversity.ensure(session, tx);
      final installed = await AccountAccess.db.count(
        session,
        where: (t) => t.developmentPersona.inSet(
          DevelopmentPersona.values.map((persona) => persona.name).toSet(),
        ),
        transaction: tx,
      );
      if (installed == logins.length) return null;
      if (installed != 0) {
        throw const _SeedConflict('fixture accounts were partially removed');
      }
      for (final email in emails.values.toList()..sort()) {
        await IdentityLocks.email(session, email, tx);
      }
      for (var i = 0; i < _courses.length; i++) {
        if (await CourseRecord.db.findById(
              session,
              _id(i, 1),
              transaction: tx,
            ) !=
            null) {
          throw const _SeedConflict('academic course ID already exists');
        }
      }
      final ids = <DevelopmentPersona, UuidValue>{};
      for (final persona in DevelopmentPersona.values) {
        ids[persona] = await _provision(
          session,
          tx,
          persona,
          emails[persona]!,
          logins[persona]!,
        );
      }
      for (var i = 0; i < _courses.length; i++) {
        await _seedCourse(session, tx, i, ids);
      }
      return ids;
    });
  }

  static Future<UuidValue> _provision(
    Session session,
    Transaction tx,
    DevelopmentPersona persona,
    String email,
    DevelopmentLogin login,
  ) async {
    final auth = AuthServices.instance;
    final emailRows = await EmailAccount.db.find(
      session,
      where: (t) => t.email.equals(email),
      transaction: tx,
    );
    final googleRows = await GoogleAccount.db.find(
      session,
      where: (t) => t.email.equals(email),
      transaction: tx,
    );
    final accessRows = await AccountAccess.db.find(
      session,
      where: (t) => t.verifiedEmail.equals(email),
      transaction: tx,
    );
    final owners = {
      ...emailRows.map((row) => row.authUserId),
      ...googleRows.map((row) => row.authUserId),
      ...accessRows.map((row) => row.authUserId),
    };
    final admin = persona == DevelopmentPersona.admin;
    final teacher = persona == DevelopmentPersona.teacher;
    final expected = login.expectedUserId;
    if (owners.isEmpty && expected == null) {
      final user = await auth.authUsers.create(session, transaction: tx);
      await auth.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: user.id,
        email: email,
        password: login.password,
        transaction: tx,
      );
      await AccountAccess.db.insertRow(
        session,
        AccountAccess(
          authUserId: user.id,
          verifiedEmail: email,
          isAdmin: admin,
          universityId: admin ? null : LegacyUniversity.id,
          isUniversityAdmin: teacher,
          teacherApproved: teacher,
          developmentPersona: persona.name,
        ),
        transaction: tx,
      );
      return user.id;
    }
    if (expected == null ||
        owners.length != 1 ||
        owners.single != expected ||
        (emailRows.isEmpty && googleRows.isEmpty)) {
      throw _SeedConflict('verify the local ${persona.name} account ID');
    }
    final user = await AuthUser.db.findById(session, expected, transaction: tx);
    final access = await AccountAccess.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(expected),
      transaction: tx,
    );
    final linkedEmail = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(expected),
      transaction: tx,
    );
    if (user == null ||
        user.blocked ||
        access == null ||
        access.developmentPersona != null ||
        (access.verifiedEmail != null && access.verifiedEmail != email) ||
        (linkedEmail != null && linkedEmail.email != email) ||
        (!admin && access.isAdmin)) {
      throw _SeedConflict('incompatible local ${persona.name} account');
    }
    if (linkedEmail == null) {
      await auth.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: expected,
        email: email,
        password: login.password,
        transaction: tx,
      );
    } else {
      await auth.emailIdp.admin.setPassword(
        session,
        email: email,
        password: login.password,
        transaction: tx,
      );
    }
    await AccountAccess.db.updateRow(
      session,
      access.copyWith(
        isAdmin: admin,
        teacherApproved: teacher || access.teacherApproved,
        universityId: admin ? null : LegacyUniversity.id,
        isUniversityAdmin: teacher,
        developmentPersona: persona.name,
        verifiedEmail: email,
        credentialVersion: access.credentialVersion + 1,
      ),
      transaction: tx,
    );
    await PendingEmailChange.db.deleteWhere(
      session,
      where: (t) => t.authUserId.equals(expected),
      transaction: tx,
    );
    await auth.tokenManager.revokeAllTokens(
      session,
      authUserId: expected,
      transaction: tx,
    );
    return expected;
  }

  static UuidValue _id(int course, int row) => UuidValue.withValidation(
    '019a0acf-0050-7000-8000-${(course * 10 + row).toString().padLeft(12, '0')}',
  );

  static const _courses = [
    (
      'Linear Algebra',
      'Linear systems / Системи лінійних рівнянь',
      'Solve x + y = 5 and 2x − y = 1. / Розв’яжіть систему x + y = 5 та 2x − y = 1.',
      'Explain how row reduction works. / Поясніть метод Гауса.',
    ),
    (
      'Discrete Mathematics',
      'Propositional logic / Логіка висловлень',
      'Build a truth table for p → q. / Побудуйте таблицю істинності для p → q.',
      'Compare an implication with its converse. / Порівняйте імплікацію з оберненою.',
    ),
    (
      'OOP',
      'Classes and encapsulation / Класи та інкапсуляція',
      'Design a bank account class with a private balance. / Спроєктуйте клас рахунку з приватним балансом.',
      'Explain how to enforce an invariant. / Поясніть, як забезпечити інваріант.',
    ),
  ];

  static Future<void> _seedCourse(
    Session session,
    Transaction tx,
    int index,
    Map<DevelopmentPersona, UuidValue> ids,
  ) async {
    final (title, topic, exercise, draft) = _courses[index];
    final courseId = _id(index, 1);
    final sectionId = _id(index, 2);
    await CourseRecord.db.insertRow(
      session,
      CourseRecord(
        id: courseId,
        title: title,
        summary: topic,
        seedOwned: true,
        universityId: LegacyUniversity.id,
      ),
      transaction: tx,
    );
    await CourseMembership.db.insert(session, [
      CourseMembership(
        courseId: courseId,
        authUserId: ids[DevelopmentPersona.teacher]!,
        role: index == 1 ? 'student' : 'teacher',
      ),
      if (index != 2)
        CourseMembership(
          courseId: courseId,
          authUserId: ids[DevelopmentPersona.student]!,
          role: 'student',
        ),
    ], transaction: tx);
    await CourseSectionRecord.db.insertRow(
      session,
      CourseSectionRecord(
        id: sectionId,
        courseId: courseId,
        title: topic,
        sortOrder: 0,
        published: true,
      ),
      transaction: tx,
    );
    for (final (order, instructions) in [exercise, draft].indexed) {
      final activityId = _id(index, order + 3);
      final published = order == 0;
      final name = published
          ? 'Practice / Практика'
          : 'Follow-up / Наступне завдання';
      await CourseActivityRecord.db.insertRow(
        session,
        CourseActivityRecord(
          id: activityId,
          sectionId: sectionId,
          title: name,
          kind: 'assignment',
          sortOrder: order,
          published: published,
          assessment: CourseAssessmentInfo(instructions: instructions),
        ),
        transaction: tx,
      );
      await TeachingActivityRecord.db.insertRow(
        session,
        TeachingActivityRecord(
          courseId: courseId,
          activityId: activityId,
          kind: 'assignment',
          published: published,
          settings: TeachingSettings(
            title: name,
            instructions: instructions,
            allowFile: false,
          ),
          questions: [],
        ),
        transaction: tx,
      );
    }
  }
}
