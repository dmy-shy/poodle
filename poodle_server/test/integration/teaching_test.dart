import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:poodle_server/src/auth/identity_auth_config.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/server.dart' show ServerInternalMethods;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Teaching workflows', (builder, endpoints) {
    late Session session;
    var sequence = 0;
    setUp(() {
      session = builder.build();
      addTearDown(session.close);
      session.serverpod.initializeAuthServices(
        tokenManagerBuilders: [
          JwtConfig(
            algorithm: JwtAlgorithm.hmacSha512(
              SecretKey('course-test-signing-key'),
            ),
            refreshTokenHashPepper: 'course-test-refresh-pepper',
            issuer: 'poodle',
          ),
        ],
        identityProviderBuilders: [
          identityEmailConfig(
            pepper: 'course-test-email-pepper',
            runMode: ServerpodRunMode.test,
          ),
        ],
      );
      session.serverpod.server.setAuthenticationHandlerForTesting(
        AuthServices.instance.authenticationHandler,
      );
    });
    Future<(int, dynamic)> request(
      String endpoint,
      String method,
      Map<String, dynamic> body, {
      String? token,
    }) async {
      final client = HttpClient();
      try {
        final request = await client.postUrl(
          Uri.parse(
            'http://localhost:${session.serverpod.server.port}/$endpoint/$method',
          ),
        );
        request.headers.contentType = ContentType.json;
        if (token != null) {
          request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
        }
        request.write(jsonEncode(body));
        final response = await request.close();
        final text = await utf8.decoder.bind(response).join();
        if (text.isEmpty) return (response.statusCode, null);
        try {
          return (response.statusCode, jsonDecode(text));
        } on FormatException {
          // Parameter parsing can fail before Serverpod's JSON response layer.
          if (response.statusCode < 400) rethrow;
          return (response.statusCode, text);
        }
      } finally {
        client.close(force: true);
      }
    }

    Future<(UuidValue, String)> account({
      bool admin = false,
      bool bootstrap = false,
    }) async {
      final email =
          'course-${DateTime.now().microsecondsSinceEpoch}-${sequence++}@example.test';
      final user = await AuthServices.instance.authUsers.create(session);
      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: user.id,
        email: email,
        password: 'Course-password-123',
      );
      await AccountAccess.db.insertRow(
        session,
        AccountAccess(
          authUserId: user.id,
          isAdmin: admin,
          developmentBootstrap: bootstrap,
        ),
      );
      final response = await request('emailIdp', 'login', {
        'email': email,
        'password': 'Course-password-123',
      });
      expect(response.$1, 200);
      return (
        user.id,
        AuthSuccess.fromJson(Map<String, dynamic>.from(response.$2)).token,
      );
    }

    Future<
      ({
        UuidValue course,
        UuidValue section,
        (UuidValue, String) teacher,
        (UuidValue, String) student,
      })
    >
    fixture() async {
      final teacher = await account();
      final student = await account();
      final course = await CourseRecord.db.insertRow(
        session,
        CourseRecord(title: 'Teaching course'),
      );
      for (final entry in [(teacher.$1, 'teacher'), (student.$1, 'student')]) {
        await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: course.id!,
            authUserId: entry.$1,
            role: entry.$2,
          ),
        );
      }
      final section = await CourseSectionRecord.db.insertRow(
        session,
        CourseSectionRecord(
          courseId: course.id!,
          title: 'Section',
          sortOrder: 0,
          published: true,
        ),
      );
      return (
        course: course.id!,
        section: section.id!,
        teacher: teacher,
        student: student,
      );
    }

    Future<TeachingActivityView> view(
      UuidValue course,
      UuidValue id,
      String token,
    ) async {
      final result = await request('teaching', 'getActivity', {
        'courseId': course.toString(),
        'activityId': id.toString(),
      }, token: token);
      expect(result.$1, 200, reason: '${result.$2}');
      return TeachingActivityView.fromJson(
        Map<String, dynamic>.from(result.$2),
      );
    }

    test('student grades reveal only the current published result', () async {
      final f = await fixture();
      final other = await account();
      await CourseMembership.db.insertRow(
        session,
        CourseMembership(
          courseId: f.course,
          authUserId: other.$1,
          role: 'student',
        ),
      );
      final now = DateTime.now().toUtc();
      Future<UuidValue> activity(
        String title,
        String kind, {
        bool published = true,
      }) async {
        final id = const Uuid().v4obj();
        await CourseActivityRecord.db.insertRow(
          session,
          CourseActivityRecord(
            id: id,
            sectionId: f.section,
            title: title,
            kind: kind,
            sortOrder: 0,
            published: published,
          ),
        );
        await TeachingActivityRecord.db.insertRow(
          session,
          TeachingActivityRecord(
            activityId: id,
            courseId: f.course,
            kind: kind,
            published: published,
            settings: TeachingSettings(
              title: title,
              instructions: '',
              maxPoints: 50,
            ),
            questions: [],
          ),
        );
        return id;
      }

      Future<Map<String, dynamic>> grades(String token) async {
        final result = await request(
          'studentLearning',
          'listGrades',
          {},
          token: token,
        );
        expect(result.$1, 200, reason: '${result.$2}');
        return Map<String, dynamic>.from(result.$2);
      }

      final essay = await activity('Essay', 'assignment');
      final quiz = await activity('Quiz', 'test');
      final version = await TeachingVersionRecord.db.insertRow(
        session,
        TeachingVersionRecord(
          activityId: quiz,
          revision: 1,
          settings: TeachingSettings(
            title: 'Quiz',
            instructions: '',
            maxPoints: 25,
          ),
          questions: [],
        ),
      );
      await activity('Hidden', 'assignment', published: false);
      await TeachingSubmissionRecord.db.insertRow(
        session,
        TeachingSubmissionRecord(
          activityId: essay,
          ownerId: other.$1,
          requestKey: 'other-grade',
          text: 'Other work',
          submittedAt: now,
          grade: 49,
          feedback: 'Another student',
          published: true,
        ),
      );
      final own = await TeachingSubmissionRecord.db.insertRow(
        session,
        TeachingSubmissionRecord(
          activityId: essay,
          ownerId: f.student.$1,
          requestKey: 'own-grade',
          text: 'Mine',
          submittedAt: now.add(const Duration(seconds: 1)),
          grade: 0,
          feedback: 'Draft feedback',
        ),
      );
      final attempt = await TeachingAttemptRecord.db.insertRow(
        session,
        TeachingAttemptRecord(
          activityId: quiz,
          ownerId: f.student.$1,
          versionId: version.id!,
          questions: [],
          answers: [],
          startedAt: now,
          expiresAt: now,
          maxPoints: 25,
        ),
      );
      var rows = (await grades(f.student.$2))['courses'] as List;
      expect(rows, hasLength(1));
      var results = (rows.single['grades'] as List)
          .cast<Map<String, dynamic>>();
      expect(results.map((r) => r['activityTitle']), ['Essay', 'Quiz']);
      expect(results.map((r) => r['status']), ['pending', 'pending']);
      expect(results.first['points'], isNull);
      expect(results.first['feedback'], isNull);
      expect(jsonEncode(rows), isNot(contains('Another student')));
      expect(jsonEncode(rows), isNot(contains('Draft feedback')));
      final finalized = await TeachingAttemptRecord.db.findById(
        session,
        attempt.id!,
      );
      expect(finalized!.submittedAt, isNotNull);
      await TeachingSubmissionRecord.db.updateRow(
        session,
        own.copyWith(published: true),
      );
      await TeachingActivityRecord.db.updateRow(
        session,
        (await TeachingActivityRecord.db.findFirstRow(
          session,
          where: (t) => t.activityId.equals(quiz),
        ))!.copyWith(released: true),
      );
      results =
          (((await grades(f.student.$2))['courses'] as List).single['grades']
                  as List)
              .cast<Map<String, dynamic>>();
      expect(results.map((r) => r['status']), ['graded', 'graded']);
      expect(results.first['points'], 0);
      expect(results.first['maximum'], 50);
      expect(results.first['feedback'], 'Draft feedback');
      expect(results.last['points'], 0);
      expect(results.last['maximum'], 25);
      await TeachingSubmissionRecord.db.insertRow(
        session,
        TeachingSubmissionRecord(
          activityId: essay,
          ownerId: f.student.$1,
          requestKey: 'reopened',
          text: '',
          submittedAt: now.add(const Duration(seconds: 2)),
        ),
      );
      results =
          (((await grades(f.student.$2))['courses'] as List).single['grades']
                  as List)
              .cast<Map<String, dynamic>>();
      expect(results.first['status'], 'pending');
      expect(results.first['points'], isNull);
      expect(results.first['feedback'], isNull);
      expect(
        (await request('studentLearning', 'listGrades', {})).$1,
        anyOf(401, 403),
      );
    });

    test('student tasks expose only published, actionable deadlines', () async {
      final f = await fixture();
      final now = DateTime.now().toUtc();
      final past = now.subtract(const Duration(days: 1));
      final future = now.add(const Duration(days: 1));
      final expiry = now.add(const Duration(minutes: 30));

      Future<UuidValue> activity(
        String title,
        DateTime? deadline, {
        String kind = 'assignment',
        bool published = true,
        bool contentPublished = true,
        bool released = false,
        int limit = 1,
      }) async {
        final id = const Uuid().v4obj();
        await CourseActivityRecord.db.insertRow(
          session,
          CourseActivityRecord(
            id: id,
            sectionId: f.section,
            title: title,
            kind: kind,
            sortOrder: 0,
            published: contentPublished,
          ),
        );
        await TeachingActivityRecord.db.insertRow(
          session,
          TeachingActivityRecord(
            activityId: id,
            courseId: f.course,
            kind: kind,
            published: published,
            released: released,
            settings: TeachingSettings(
              title: title,
              instructions: 'Private instructions',
              closesAt: deadline,
              attemptLimit: limit,
            ),
            questions: [],
          ),
        );
        return id;
      }

      var revision = 0;
      Future<void> submit(UuidValue id, [DateTime? reopenUntil]) async {
        final version = revision++;
        await TeachingSubmissionRecord.db.insertRow(
          session,
          TeachingSubmissionRecord(
            activityId: id,
            ownerId: f.student.$1,
            requestKey: 'revision-$version',
            text: 'Private submission',
            submittedAt: past.add(Duration(seconds: version)),
            reopenUntil: reopenUntil,
          ),
        );
      }

      Future<void> attempt(UuidValue id, DateTime expiresAt) async {
        await TeachingAttemptRecord.db.insertRow(
          session,
          TeachingAttemptRecord(
            activityId: id,
            ownerId: f.student.$1,
            versionId: const Uuid().v4obj(),
            questions: [],
            answers: [0],
            startedAt: past,
            expiresAt: expiresAt,
            maxPoints: 100,
          ),
        );
      }

      final overdue = await activity('Late essay', past);
      final reopened = await activity('Reopened essay', past);
      await submit(reopened);
      await submit(reopened, future);
      final replaced = await activity('Replacement essay', past);
      await submit(replaced);
      await submit(replaced, future);
      await submit(replaced, future);
      final ordinary = await activity('Submitted essay', future);
      await submit(ordinary);
      await activity('No deadline', null);
      await activity('Teaching draft', future, published: false);
      await activity('Content draft', future, contentPublished: false);
      await activity('Released test', past, kind: 'test', released: true);
      final running = await activity('Running test', future, kind: 'test');
      await attempt(running, expiry);
      final exhausted = await activity('Expired attempt', future, kind: 'test');
      await attempt(exhausted, past);
      final remaining = await activity(
        'Remaining attempt',
        future,
        kind: 'test',
        limit: 2,
      );
      await attempt(remaining, past);
      final older = await activity(
        'Older deadline',
        past.subtract(const Duration(days: 1)),
      );

      Future<(int, dynamic)> tasks([String? token]) =>
          request('studentLearning', 'listTasks', {}, token: token);
      final result = await tasks(f.student.$2);
      expect(result.$1, 200, reason: '${result.$2}');
      expect((await tasks()).$1, anyOf(401, 403));
      final response = result.$2 as Map<String, dynamic>;
      final serverTime = DateTime.parse(response['serverTime'] as String);
      expect(serverTime.isBefore(now), isFalse);
      expect(serverTime.isAfter(DateTime.now().toUtc()), isFalse);
      final rows = (response['tasks'] as List).cast<Map<String, dynamic>>();
      final tied = [reopened.toString(), remaining.toString()]..sort();
      expect(rows.map((row) => row['activityId']), [
        overdue.toString(),
        older.toString(),
        running.toString(),
        ...tied,
      ]);
      expect(DateTime.parse(rows[2]['deadline'] as String), expiry);
      expect(DateTime.parse(rows.first['deadline'] as String), past);
      expect(rows.first['courseTitle'], 'Teaching course');
      expect(rows.first['activityTitle'], 'Late essay');
      for (final row in rows) {
        expect(
          row.keys.where((key) => key != '__className__'),
          unorderedEquals([
            'courseId',
            'courseTitle',
            'activityId',
            'activityTitle',
            'kind',
            'deadline',
          ]),
        );
        expect(row['courseId'], f.course.toString());
      }
      expect((await tasks(f.teacher.$2)).$2['tasks'], isEmpty);

      final member = (await CourseMembership.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(f.student.$1),
      ))!;
      await CourseMembership.db.updateRow(
        session,
        member.copyWith(active: false),
      );
      expect((await tasks(f.student.$2)).$2['tasks'], isEmpty);
    });

    test(
      'assignment publication, idempotency, draft grade privacy, locking and reopen',
      () async {
        final f = await fixture();
        final id = const Uuid().v4obj();
        final input = TeachingSaveInput(
          courseId: f.course,
          sectionId: f.section,
          activityId: id,
          kind: 'assignment',
          expectedRevision: 0,
          publish: true,
          settings: TeachingSettings(
            title: 'Essay',
            instructions: 'Write',
            closesAt: DateTime.now().toUtc().add(const Duration(days: 1)),
          ),
          questions: [],
        );
        expect(
          (await request('teaching', 'saveActivity', {
            'input': input.toJson(),
          }, token: f.student.$2)).$1,
          greaterThanOrEqualTo(400),
        );
        expect(
          (await request('teaching', 'saveActivity', {
            'input': input.toJson(),
          }, token: f.teacher.$2)).$1,
          200,
        );
        final body = {
          'courseId': f.course.toString(),
          'activityId': id.toString(),
          'text': 'My essay',
          'uploadId': null,
          'requestKey': 'assignment-request-0001',
        };
        for (var i = 0; i < 2; i++) {
          expect(
            (await request(
              'teaching',
              'submitAssignment',
              body,
              token: f.student.$2,
            )).$1,
            200,
          );
        }
        var student = await view(f.course, id, f.student.$2);
        expect(student.submissions, hasLength(1));
        final sub = student.submissions.single.id;
        final grading = {
          'courseId': f.course.toString(),
          'activityId': id.toString(),
          'submissionId': sub.toString(),
          'points': 75.0,
          'feedback': 'Private feedback',
          'publish': false,
        };
        expect(
          (await request(
            'teaching',
            'gradeAssignment',
            grading,
            token: f.teacher.$2,
          )).$1,
          200,
        );
        student = await view(f.course, id, f.student.$2);
        expect(student.submissions.single.grade, isNull);
        expect(student.submissions.single.feedback, isNull);
        expect(student.submissions.single.underReview, isTrue);
        expect(
          (await request('teaching', 'submitAssignment', {
            ...body,
            'requestKey': 'assignment-request-0002',
          }, token: f.student.$2)).$1,
          greaterThanOrEqualTo(400),
        );
        expect(
          (await request('teaching', 'gradeAssignment', {
            ...grading,
            'publish': true,
          }, token: f.teacher.$2)).$1,
          200,
        );
        expect(
          (await view(f.course, id, f.student.$2)).submissions.single.grade,
          75,
        );
        final deadline = DateTime.now().toUtc().add(const Duration(days: 2));
        expect(
          (await request('teaching', 'reopenAssignment', {
            'courseId': f.course.toString(),
            'activityId': id.toString(),
            'ownerId': f.student.$1.toString(),
            'deadline': deadline.toIso8601String(),
          }, token: f.teacher.$2)).$1,
          200,
        );
        student = await view(f.course, id, f.student.$2);
        expect(student.submissions, hasLength(2));
        expect(student.submissions.first.grade, isNull);
        expect(student.submissions.last.grade, 75);
        expect(student.settings.closesAt, deadline);
        final stranger = await account(admin: true);
        expect(
          (await request('teaching', 'getActivity', {
            'courseId': f.course.toString(),
            'activityId': id.toString(),
          }, token: stranger.$2)).$1,
          greaterThanOrEqualTo(400),
        );
        expect(
          (await request('teaching', 'listActivities', {
            'courseId': f.course.toString(),
          }, token: f.student.$2)).$1,
          greaterThanOrEqualTo(400),
        );
      },
    );
    test(
      'test attempts pin versions, hide keys and scores, enforce limits and release',
      () async {
        final f = await fixture();
        final id = const Uuid().v4obj();
        var input = TeachingSaveInput(
          courseId: f.course,
          sectionId: f.section,
          activityId: id,
          kind: 'test',
          expectedRevision: 0,
          publish: true,
          settings: TeachingSettings(
            title: 'Test',
            instructions: 'Choose',
            attemptLimit: 2,
            closesAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
          ),
          questions: [
            TeachingQuestion(
              prompt: 'First question',
              kind: 'choice',
              options: ['A', 'B'],
              correctIndex: 0,
              points: 1,
            ),
          ],
        );
        Future<void> save() async {
          final r = await request('teaching', 'saveActivity', {
            'input': input.toJson(),
          }, token: f.teacher.$2);
          expect(r.$1, 200, reason: '${r.$2}');
        }

        await save();
        final target = {
          'courseId': f.course.toString(),
          'activityId': id.toString(),
        };
        expect(
          (await request(
            'teaching',
            'startTest',
            target,
            token: f.student.$2,
          )).$1,
          200,
        );
        final first = (await view(f.course, id, f.student.$2)).attempts.single;
        expect(first.questions.single.correctIndex, isNull);
        input = input.copyWith(
          expectedRevision: 1,
          questions: [
            TeachingQuestion(
              prompt: 'Second version',
              kind: 'trueFalse',
              options: ['True', 'False'],
              correctIndex: 1,
              points: 1,
            ),
          ],
        );
        await save();
        expect(
          (await view(
            f.course,
            id,
            f.student.$2,
          )).attempts.single.questions.single.prompt,
          'First question',
        );
        final submit = {
          ...target,
          'attemptId': first.id.toString(),
          'answers': [0],
          'finish': true,
        };
        expect(
          (await request(
            'teaching',
            'saveAnswers',
            submit,
            token: f.student.$2,
          )).$1,
          200,
        );
        expect(
          (await view(f.course, id, f.student.$2)).attempts.single.score,
          isNull,
        );
        expect(
          (await view(f.course, id, f.teacher.$2)).attempts.single.score,
          100,
        );
        expect(
          (await request(
            'teaching',
            'releaseTest',
            target,
            token: f.teacher.$2,
          )).$1,
          greaterThanOrEqualTo(400),
        );
        expect(
          (await request(
            'teaching',
            'startTest',
            target,
            token: f.student.$2,
          )).$1,
          200,
        );
        var state = await view(f.course, id, f.student.$2);
        final second = state.attempts.last;
        expect(second.revision, 2);
        await request('teaching', 'saveAnswers', {
          ...submit,
          'attemptId': second.id.toString(),
          'answers': [0],
        }, token: f.student.$2);
        expect(
          (await request(
            'teaching',
            'startTest',
            target,
            token: f.student.$2,
          )).$1,
          greaterThanOrEqualTo(400),
        );
        input = input.copyWith(
          expectedRevision: 2,
          settings: input.settings.copyWith(
            closesAt: DateTime.now().toUtc().subtract(
              const Duration(seconds: 1),
            ),
          ),
        );
        await save();
        expect(
          (await request(
            'teaching',
            'releaseTest',
            target,
            token: f.teacher.$2,
          )).$1,
          200,
        );
        state = await view(f.course, id, f.student.$2);
        expect(state.released, isTrue);
        expect(state.attempts.map((v) => v.score), [100, 0]);
        expect(state.attempts.first.questions.single.correctIndex, 0);
        expect(
          (await request(
            'teaching',
            'startTest',
            target,
            token: f.student.$2,
          )).$1,
          greaterThanOrEqualTo(400),
        );
      },
    );

    test(
      'private uploads require ownership, real bytes and current membership',
      () async {
        final f = await fixture();
        session.serverpod.addCloudStorage(DatabaseCloudStorage('private'));
        final id = const Uuid().v4obj();
        final input = TeachingSaveInput(
          courseId: f.course,
          sectionId: f.section,
          activityId: id,
          kind: 'assignment',
          expectedRevision: 0,
          publish: true,
          settings: TeachingSettings(title: 'Upload', instructions: ''),
          questions: [],
        );
        expect(
          (await request('teaching', 'saveActivity', {
            'input': input.toJson(),
          }, token: f.teacher.$2)).$1,
          200,
        );
        final target = {
          'courseId': f.course.toString(),
          'activityId': id.toString(),
        };
        final invalid = await request('teaching', 'beginUpload', {
          ...target,
          'fileName': '../bad.pdf',
          'sizeBytes': 12,
        }, token: f.student.$2);
        expect(invalid.$1, greaterThanOrEqualTo(400));
        final ticketResponse = await request('teaching', 'beginUpload', {
          ...target,
          'fileName': 'work.pdf',
          'sizeBytes': 12,
        }, token: f.student.$2);
        expect(ticketResponse.$1, 200, reason: '${ticketResponse.$2}');
        final ticket = TeachingUploadTicket.fromJson(
          Map<String, dynamic>.from(ticketResponse.$2),
        );
        final upload = (await TeachingUploadRecord.db.findById(
          session,
          ticket.id,
        ))!;
        await session.storage.storeFile(
          storageId: 'private',
          path: upload.path,
          byteData: ByteData.sublistView(
            Uint8List.fromList(utf8.encode('%PDF-1.4 end')),
          ),
        );
        final body = {
          ...target,
          'text': 'File response',
          'uploadId': ticket.id.toString(),
          'requestKey': 'upload-request-00001',
        };
        expect(
          (await request(
            'teaching',
            'submitAssignment',
            body,
            token: f.student.$2,
          )).$1,
          200,
        );
        final state = await view(f.course, id, f.student.$2);
        final fileRequest = {
          ...target,
          'submissionId': state.submissions.single.id.toString(),
        };
        expect(
          (await request(
            'teaching',
            'submissionFile',
            fileRequest,
            token: f.teacher.$2,
          )).$1,
          200,
        );
        final stranger = await account();
        await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: f.course,
            authUserId: stranger.$1,
            role: 'student',
          ),
        );
        expect(
          (await request(
            'teaching',
            'submissionFile',
            fileRequest,
            token: stranger.$2,
          )).$1,
          greaterThanOrEqualTo(400),
        );
        expect(
          (await request('teaching', 'submitAssignment', {
            ...body,
            'requestKey': 'upload-request-00002',
          }, token: stranger.$2)).$1,
          greaterThanOrEqualTo(400),
        );
        final membership = (await CourseMembership.db.findFirstRow(
          session,
          where: (t) =>
              t.courseId.equals(f.course) & t.authUserId.equals(f.student.$1),
        ))!;
        await CourseMembership.db.updateRow(
          session,
          membership.copyWith(active: false),
        );
        expect(
          (await request(
            'teaching',
            'submissionFile',
            fileRequest,
            token: f.student.$2,
          )).$1,
          greaterThanOrEqualTo(400),
        );
      },
    );
  }, rollbackDatabase: RollbackDatabase.disabled);
}
