import '../../core/course_tenancy.dart';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../../generated/protocol.dart';
import '../search/search_index_queue.dart';
import '../../core/account_authorization.dart';
import '../courses/course_service.dart';
import 'teaching_policy.dart';
import '../notifications/notification_service.dart';

part 'teaching_projection.dart';

/// Course locks serialize grading, replacement submissions, and test starts.
class TeachingService {
  Future<T> _run<T>(
    Session s,
    UuidValue courseId,
    bool teacher,
    Future<T> Function(Transaction, CourseMembership) body,
  ) => s.db.transaction((tx) async {
    await s.db.unsafeQuery(
      'SELECT pg_advisory_xact_lock(hashtextextended(@key, 0))',
      parameters: QueryParameters.named({'key': 'teaching:$courseId'}),
      transaction: tx,
    );
    final access = await CourseService().requireMember(s, courseId);
    if (teacher && access.membership.role != 'teacher') {
      throw TeachingError(code: 'unavailable');
    }
    return body(tx, access.membership);
  });
  Future<TeachingActivityRecord> _record(
    Session s,
    UuidValue courseId,
    UuidValue id,
    Transaction tx,
    CourseMembership member,
  ) async {
    final row = await TeachingActivityRecord.db.findFirstRow(
      s,
      where: (t) => t.activityId.equals(id) & t.courseId.equals(courseId),
      transaction: tx,
    );
    final activity = await CourseActivityRecord.db.findById(
      s,
      id,
      transaction: tx,
    );
    final section = activity == null
        ? null
        : await CourseSectionRecord.db.findById(
            s,
            activity.sectionId,
            transaction: tx,
          );
    if (row == null ||
        activity == null ||
        section == null ||
        section.courseId != courseId ||
        (member.role != 'teacher' &&
            (!row.published || !activity.published || !section.published))) {
      throw TeachingError(code: 'unavailable');
    }
    return row;
  }

  Future<List<TeachingSubmissionRecord>> _submissions(
    Session s,
    UuidValue id,
    Transaction tx,
  ) => TeachingSubmissionRecord.db.find(
    s,
    where: (t) => t.activityId.equals(id),
    orderByList: (t) => [t.submittedAt.desc(), t.id.desc()],
    transaction: tx,
  );
  Future<List<TeachingAttemptRecord>> _attempts(
    Session s,
    UuidValue id,
    Transaction tx,
  ) async {
    final rows = await TeachingAttemptRecord.db.find(
      s,
      where: (t) => t.activityId.equals(id),
      orderBy: (t) => t.startedAt,
      transaction: tx,
    );
    for (var i = 0; i < rows.length; i++) {
      if (rows[i].submittedAt == null &&
          !DateTime.now().toUtc().isBefore(rows[i].expiresAt)) {
        rows[i] = await TeachingAttemptRecord.db.updateRow(
          s,
          rows[i].copyWith(
            submittedAt: rows[i].expiresAt,
            score: TeachingPolicy.score(
              rows[i].questions,
              rows[i].answers,
              rows[i].maxPoints,
            ),
          ),
          transaction: tx,
        );
      }
    }
    return rows;
  }

  Future<TeachingActivityView> get(Session s, UuidValue course, UuidValue id) =>
      _run(
        s,
        course,
        false,
        (tx, m) async => _view(s, await _record(s, course, id, tx, m), tx, m),
      );
  Future<List<TeachingActivityView>> list(Session s, UuidValue course) =>
      _run(s, course, true, (tx, m) async {
        final rows = await TeachingActivityRecord.db.find(
          s,
          where: (t) => t.courseId.equals(course),
          transaction: tx,
        );
        return [for (final row in rows) await _view(s, row, tx, m)];
      });
  Future<List<TeachingCourseView>> dashboard(Session s) async {
    final account = await AccountAuthorization.requireAccount(s);
    final memberships = await CourseTenancy.filter(
      s,
      await CourseMembership.db.find(
        s,
        where: (t) =>
            t.authUserId.equals(account.authUserId) &
            t.active.equals(true) &
            t.role.equals('teacher'),
      ),
    );
    final result = <TeachingCourseView>[];
    for (final member in memberships) {
      final course = await CourseRecord.db.findById(s, member.courseId);
      if (course == null) continue;
      final activities = await list(s, member.courseId);
      var pending = 0;
      for (final a in activities) {
        final latest = <UuidValue, TeachingSubmissionView>{};
        for (final v in a.submissions) {
          latest.putIfAbsent(v.ownerId, () => v);
        }
        pending += latest.values.where((v) => !v.published).length;
      }
      result.add(
        TeachingCourseView(
          courseId: member.courseId,
          title: course.title,
          pendingGrades: pending,
          drafts: activities.where((a) => !a.published).length,
          unreleasedTests: activities
              .where(
                (a) =>
                    a.kind == 'test' &&
                    a.published &&
                    !a.released &&
                    a.attempts.isNotEmpty &&
                    a.settings.closesAt != null &&
                    !a.settings.closesAt!.isAfter(DateTime.now().toUtc()),
              )
              .length,
          upcomingDeadlines:
              activities
                  .where(
                    (a) =>
                        a.published &&
                        a.settings.closesAt != null &&
                        a.settings.closesAt!.isAfter(DateTime.now().toUtc()),
                  )
                  .map((a) => a.settings.closesAt!)
                  .toList()
                ..sort(),
        ),
      );
    }
    return result;
  }

  Future<List<TeachingMemberView>> members(Session s, UuidValue course) =>
      _run(s, course, true, (tx, m) async {
        final rows = await CourseTenancy.filter(
          s,
          await CourseMembership.db.find(
            s,
            where: (t) =>
                t.courseId.equals(course) &
                t.active.equals(true) &
                t.role.equals("student"),
            transaction: tx,
          ),
          transaction: tx,
        );
        return [
          for (final v in rows)
            TeachingMemberView(
              id: v.authUserId,
              label: await _label(s, v.authUserId, tx),
              role: v.role,
            ),
        ];
      });
  Future<TeachingActivityView> save(
    Session s,
    TeachingSaveInput input,
  ) => _run(s, input.courseId, true, (tx, m) async {
    TeachingPolicy.validate(
      input.settings,
      input.kind,
      input.questions,
      publish: input.publish,
    );
    final section = await CourseSectionRecord.db.findById(
      s,
      input.sectionId,
      transaction: tx,
    );
    if (section == null || section.courseId != input.courseId) {
      throw TeachingError(code: 'unavailable');
    }
    final old = await TeachingActivityRecord.db.findFirstRow(
      s,
      where: (t) => t.activityId.equals(input.activityId),
      transaction: tx,
    );
    final content = await CourseActivityRecord.db.findById(
      s,
      input.activityId,
      transaction: tx,
    );
    if ((old == null && (input.expectedRevision != 0 || content != null)) ||
        (old != null &&
            (old.courseId != input.courseId ||
                old.revision != input.expectedRevision ||
                old.kind != input.kind ||
                old.released))) {
      throw TeachingError(code: 'conflict');
    }
    if (old != null && old.kind == 'assignment') {
      final subs = await _submissions(s, old.activityId, tx);
      if (subs.isNotEmpty &&
          old.settings.maxPoints != input.settings.maxPoints) {
        throw TeachingError(code: 'conflict');
      }
    }
    final revision = (old?.revision ?? 0) + 1;
    final row = TeachingActivityRecord(
      id: old?.id,
      courseId: input.courseId,
      activityId: input.activityId,
      kind: input.kind,
      revision: revision,
      published: input.publish,
      released: false,
      settings: input.settings,
      questions: input.questions,
    );
    final saved = old == null
        ? await TeachingActivityRecord.db.insertRow(s, row, transaction: tx)
        : await TeachingActivityRecord.db.updateRow(s, row, transaction: tx);
    final activity = CourseActivityRecord(
      id: input.activityId,
      sectionId: input.sectionId,
      title: input.settings.title.trim(),
      kind: input.kind,
      sortOrder: content?.sortOrder ?? DateTime.now().millisecondsSinceEpoch,
      published: input.publish,
      assessment: CourseAssessmentInfo(
        instructions: input.settings.instructions,
        opensAt: input.settings.opensAt,
        closesAt: input.settings.closesAt,
        attemptLimit: input.kind == 'test' ? input.settings.attemptLimit : null,
        timeLimitMinutes: input.kind == 'test'
            ? input.settings.timeLimitMinutes
            : null,
      ),
    );
    if (content == null) {
      await CourseActivityRecord.db.insertRow(s, activity, transaction: tx);
    } else {
      await CourseActivityRecord.db.updateRow(s, activity, transaction: tx);
    }
    await enqueueSearchActivity(s, activity, tx);
    if (input.kind == 'test' && input.publish) {
      await TeachingVersionRecord.db.insertRow(
        s,
        TeachingVersionRecord(
          activityId: input.activityId,
          revision: revision,
          settings: input.settings,
          questions: input.questions,
        ),
        transaction: tx,
      );
    }
    if (input.kind == 'assignment' && input.publish) {
      final category = old == null || !old.published
          ? 'assignment'
          : old.settings.closesAt != input.settings.closesAt
          ? 'deadline'
          : null;
      if (category != null) {
        await NotificationService().forCourseStudents(
          s,
          tx,
          courseId: input.courseId,
          activityId: input.activityId,
          eventKey: '$category:${input.activityId}:$revision',
          category: category,
          title: input.settings.title.trim(),
        );
      }
    }
    return _view(s, saved, tx, m);
  });
  Future<TeachingSettings> defaults(Session s, TeachingSettings? value) async {
    final account = await AccountAuthorization.requireAccount(s);
    final membership = await CourseMembership.db.findFirstRow(
      s,
      where: (t) =>
          t.authUserId.equals(account.authUserId) &
          t.active.equals(true) &
          t.role.equals('teacher'),
    );
    if (membership == null) throw TeachingError(code: 'unavailable');
    return _run(s, membership.courseId, true, (tx, m) async {
      final old = await TeacherDefaultsRecord.db.findFirstRow(
        s,
        where: (t) => t.ownerId.equals(account.authUserId),
        transaction: tx,
      );
      if (value == null) {
        return old?.settings ?? TeachingSettings(title: '', instructions: '');
      }
      TeachingPolicy.validate(
        value.copyWith(title: 'Defaults'),
        'assignment',
        [],
      );
      final row = TeacherDefaultsRecord(
        id: old?.id,
        ownerId: account.authUserId,
        settings: value.copyWith(
          title: '',
          instructions: '',
          opensAt: null,
          closesAt: null,
        ),
      );
      if (old == null) {
        await TeacherDefaultsRecord.db.insertRow(s, row, transaction: tx);
      } else {
        await TeacherDefaultsRecord.db.updateRow(s, row, transaction: tx);
      }
      return row.settings;
    });
  }

  Future<TeachingUploadTicket> upload(
    Session s,
    UuidValue course,
    UuidValue id,
    String name,
    int size,
  ) => _run(s, course, false, (tx, m) async {
    final row = await _record(s, course, id, tx, m);
    final previous = (await _submissions(
      s,
      id,
      tx,
    )).where((v) => v.ownerId == m.authUserId).firstOrNull;
    final settings = previous?.reopenUntil == null
        ? row.settings
        : row.settings.copyWith(closesAt: previous!.reopenUntil);
    if (m.role != 'student' ||
        row.kind != 'assignment' ||
        !row.settings.allowFile ||
        !TeachingPolicy.available(settings, DateTime.now().toUtc()) ||
        previous?.grade != null ||
        size < 1 ||
        size > 20 * 1024 * 1024 ||
        name.length > 180 ||
        RegExp(r'[/\\\x00-\x1f]').hasMatch(name) ||
        !{
          'pdf',
          'docx',
          'jpg',
          'jpeg',
          'png',
        }.contains(name.split('.').last.toLowerCase())) {
      throw TeachingError(code: 'invalid_upload');
    }
    final recent = await TeachingUploadRecord.db.count(
      s,
      where: (t) =>
          t.ownerId.equals(m.authUserId) &
          (t.createdAt >
              DateTime.now().toUtc().subtract(const Duration(days: 1))),
      transaction: tx,
    );
    if (recent >= 50) throw TeachingError(code: 'upload_limit');
    final uploadId = const Uuid().v4obj();
    final path = 'submissions/${m.authUserId}/$id/$uploadId';
    final description = await s.storage.createUploadDescription(
      storageId: 'private',
      path: path,
      options: UploadOptions(
        expirationDuration: const Duration(minutes: 10),
        maxFileSize: size,
        contentLength: size,
        preventOverwrite: true,
      ),
    );
    await TeachingUploadRecord.db.insertRow(
      s,
      TeachingUploadRecord(
        id: uploadId,
        activityId: id,
        ownerId: m.authUserId,
        fileName: name,
        sizeBytes: size,
        path: path,
        createdAt: DateTime.now().toUtc(),
      ),
      transaction: tx,
    );
    return TeachingUploadTicket(id: uploadId, description: description);
  });
  Future<TeachingActivityView> submit(
    Session s,
    UuidValue course,
    UuidValue id,
    String text,
    UuidValue? uploadId,
    String key,
  ) => _run(s, course, false, (tx, m) async {
    final row = await _record(s, course, id, tx, m);
    if (m.role != 'student' ||
        row.kind != 'assignment' ||
        key.length < 16 ||
        key.length > 100) {
      throw TeachingError(code: 'unavailable');
    }
    final existing = await TeachingSubmissionRecord.db.findFirstRow(
      s,
      where: (t) => t.ownerId.equals(m.authUserId) & t.requestKey.equals(key),
      transaction: tx,
    );
    if (existing != null) {
      if (existing.activityId != id ||
          existing.text != text ||
          existing.uploadId != uploadId) {
        throw TeachingError(code: 'conflict');
      }
      return _view(s, row, tx, m);
    }
    final previous = (await _submissions(
      s,
      id,
      tx,
    )).where((v) => v.ownerId == m.authUserId).firstOrNull;
    if (!TeachingPolicy.available(
          previous?.reopenUntil == null
              ? row.settings
              : row.settings.copyWith(closesAt: previous!.reopenUntil),
          DateTime.now().toUtc(),
        ) ||
        previous?.grade != null) {
      throw TeachingError(code: 'submission_locked');
    }
    if (text.length > 20000 ||
        (text.trim().isEmpty && uploadId == null) ||
        (!row.settings.allowText && text.isNotEmpty) ||
        (!row.settings.allowFile && uploadId != null)) {
      throw TeachingError(code: 'invalid_submission');
    }
    if (uploadId != null) {
      final file = await TeachingUploadRecord.db.findById(
        s,
        uploadId,
        transaction: tx,
      );
      if (file == null ||
          file.ownerId != m.authUserId ||
          file.activityId != id ||
          file.createdAt.isBefore(
            DateTime.now().toUtc().subtract(const Duration(hours: 1)),
          )) {
        throw TeachingError(code: 'invalid_upload');
      }
      await s.storage.verifyUpload(storageId: 'private', path: file.path);
      final stat = await s.storage.statFile(
        storageId: 'private',
        path: file.path,
      );
      if (stat.size != file.sizeBytes) {
        throw TeachingError(code: 'invalid_upload');
      }
    }
    await TeachingSubmissionRecord.db.insertRow(
      s,
      TeachingSubmissionRecord(
        activityId: id,
        ownerId: m.authUserId,
        requestKey: key,
        text: text,
        uploadId: uploadId,
        reopenUntil: previous?.reopenUntil,
        submittedAt: DateTime.now().toUtc(),
      ),
      transaction: tx,
    );
    return _view(s, row, tx, m);
  });
  Future<TeachingActivityView> grade(
    Session s,
    UuidValue course,
    UuidValue id,
    UuidValue submission,
    double points,
    String feedback,
    bool publish,
  ) => _run(s, course, true, (tx, m) async {
    final row = await _record(s, course, id, tx, m);
    final sub = await TeachingSubmissionRecord.db.findById(
      s,
      submission,
      transaction: tx,
    );
    if (sub == null || sub.activityId != id || row.kind != 'assignment') {
      throw TeachingError(code: 'unavailable');
    }
    final latest = (await _submissions(
      s,
      id,
      tx,
    )).firstWhere((v) => v.ownerId == sub.ownerId);
    if (latest.id != sub.id ||
        !points.isFinite ||
        points < 0 ||
        points > row.settings.maxPoints ||
        feedback.length > 10000) {
      throw TeachingError(code: 'conflict');
    }
    await TeachingSubmissionRecord.db.updateRow(
      s,
      sub.copyWith(
        grade: points,
        feedback: feedback,
        gradedBy: m.authUserId,
        published: publish,
      ),
      transaction: tx,
    );
    if (publish &&
        (!sub.published || sub.grade != points || sub.feedback != feedback)) {
      await NotificationService().forUser(
        s,
        tx,
        recipientId: sub.ownerId,
        courseId: course,
        activityId: id,
        eventKey:
            'grade:$submission:${sha256.convert(utf8.encode('$points:$feedback'))}',
        category: 'grade',
        title: row.settings.title,
      );
    }
    return _view(s, row, tx, m);
  });
  Future<TeachingActivityView> reopen(
    Session s,
    UuidValue course,
    UuidValue id,
    UuidValue owner,
    DateTime deadline,
  ) => _run(s, course, true, (tx, m) async {
    final row = await _record(s, course, id, tx, m);
    if (row.kind != 'assignment' ||
        !deadline.isAfter(DateTime.now().toUtc()) ||
        (row.settings.closesAt != null &&
            !deadline.isAfter(row.settings.closesAt!))) {
      throw TeachingError(code: 'invalid_settings');
    }
    final previous = (await _submissions(
      s,
      id,
      tx,
    )).where((v) => v.ownerId == owner).firstOrNull;
    if (previous == null) throw TeachingError(code: 'unavailable');
    if (previous.reopenUntil != null &&
        !deadline.isAfter(previous.reopenUntil!)) {
      throw TeachingError(code: 'invalid_settings');
    }
    // An ungraded revision opens the new cycle; historical grades remain attached to their versions.
    await TeachingSubmissionRecord.db.insertRow(
      s,
      TeachingSubmissionRecord(
        activityId: id,
        ownerId: owner,
        requestKey: const Uuid().v4(),
        text: previous.text,
        uploadId: previous.uploadId,
        reopenUntil: deadline.toUtc(),
        submittedAt: DateTime.now().toUtc(),
      ),
      transaction: tx,
    );
    return _view(s, row, tx, m);
  });
  Future<CourseFileAccess> file(
    Session s,
    UuidValue course,
    UuidValue id,
    UuidValue submission,
  ) => _run(s, course, false, (tx, m) async {
    await _record(s, course, id, tx, m);
    final sub = await TeachingSubmissionRecord.db.findById(
      s,
      submission,
      transaction: tx,
    );
    if (sub == null ||
        sub.activityId != id ||
        (m.role != 'teacher' && sub.ownerId != m.authUserId) ||
        sub.uploadId == null) {
      throw TeachingError(code: 'unavailable');
    }
    final upload = (await TeachingUploadRecord.db.findById(
      s,
      sub.uploadId!,
      transaction: tx,
    ))!;
    final url = await s.storage.temporaryDownloadUrl(
      storageId: 'private',
      path: upload.path,
      options: TemporaryDownloadUrlOptions(
        expirationDuration: const Duration(seconds: 60),
        downloadFileName: upload.fileName,
      ),
    );
    return CourseFileAccess(
      url: url.toString(),
      expiresAt: DateTime.now().toUtc().add(const Duration(seconds: 60)),
    );
  });
  Future<TeachingActivityView> start(
    Session s,
    UuidValue course,
    UuidValue id,
  ) => _run(s, course, false, (tx, m) async {
    final row = await _record(s, course, id, tx, m);
    if (m.role != 'student' ||
        row.kind != 'test' ||
        row.released ||
        !TeachingPolicy.available(row.settings, DateTime.now().toUtc())) {
      throw TeachingError(code: 'unavailable');
    }
    final attempts = (await _attempts(
      s,
      id,
      tx,
    )).where((v) => v.ownerId == m.authUserId).toList();
    if (attempts.any((v) => v.submittedAt == null)) return _view(s, row, tx, m);
    if (attempts.length >= row.settings.attemptLimit) {
      throw TeachingError(code: 'attempt_limit');
    }
    final version = await TeachingVersionRecord.db.findFirstRow(
      s,
      where: (t) => t.activityId.equals(id) & t.revision.equals(row.revision),
      transaction: tx,
    );
    if (version == null) throw TeachingError(code: 'unavailable');
    final questions = version.questions.map((v) => v.copyWith()).toList();
    if (version.settings.shuffle) questions.shuffle(Random.secure());
    final now = DateTime.now().toUtc();
    final timeout = now.add(
      Duration(minutes: version.settings.timeLimitMinutes),
    );
    final expires = timeout.isBefore(version.settings.closesAt!)
        ? timeout
        : version.settings.closesAt!;
    await TeachingAttemptRecord.db.insertRow(
      s,
      TeachingAttemptRecord(
        activityId: id,
        ownerId: m.authUserId,
        versionId: version.id!,
        questions: questions,
        answers: List.filled(questions.length, -1),
        startedAt: now,
        expiresAt: expires,
        maxPoints: version.settings.maxPoints,
      ),
      transaction: tx,
    );
    return _view(s, row, tx, m);
  });
  Future<TeachingActivityView> answer(
    Session s,
    UuidValue course,
    UuidValue id,
    UuidValue attemptId,
    List<int> answers,
    bool finish,
  ) => _run(s, course, false, (tx, m) async {
    final row = await _record(s, course, id, tx, m);
    await _attempts(s, id, tx);
    final attempt = await TeachingAttemptRecord.db.findById(
      s,
      attemptId,
      transaction: tx,
    );
    if (attempt == null ||
        attempt.activityId != id ||
        attempt.ownerId != m.authUserId ||
        m.role != 'student') {
      throw TeachingError(code: 'unavailable');
    }
    if (attempt.submittedAt != null) return _view(s, row, tx, m);
    TeachingPolicy.answers(attempt.questions, answers);
    await TeachingAttemptRecord.db.updateRow(
      s,
      attempt.copyWith(
        answers: answers,
        submittedAt: finish ? DateTime.now().toUtc() : null,
        score: finish
            ? TeachingPolicy.score(
                attempt.questions,
                answers,
                attempt.maxPoints,
              )
            : null,
      ),
      transaction: tx,
    );
    return _view(s, row, tx, m);
  });
  Future<TeachingActivityView> release(
    Session s,
    UuidValue course,
    UuidValue id,
  ) => _run(s, course, true, (tx, m) async {
    final row = await _record(s, course, id, tx, m);
    if (row.kind != 'test' ||
        !row.published ||
        row.settings.closesAt == null ||
        row.settings.closesAt!.isAfter(DateTime.now().toUtc())) {
      throw TeachingError(code: 'test_open');
    }
    // A new version cannot shorten the clock of already running attempts.
    if ((await _attempts(s, id, tx)).any((v) => v.submittedAt == null)) {
      throw TeachingError(code: 'test_open');
    }
    final updated = await TeachingActivityRecord.db.updateRow(
      s,
      row.copyWith(released: true),
      transaction: tx,
    );
    return _view(s, updated, tx, m);
  });
}
