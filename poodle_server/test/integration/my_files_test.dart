import 'dart:convert';
import 'dart:io';
import 'package:poodle_server/src/auth/identity_auth_config.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/server.dart' show ServerInternalMethods;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('My files', (builder, _) {
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

    Future<(int, dynamic)> list(String? token) async {
      final client = HttpClient();
      try {
        final req = await client.postUrl(
          Uri.parse(
            'http://localhost:${session.serverpod.server.port}/myFiles/listUploads',
          ),
        );
        req.headers.contentType = ContentType.json;
        if (token != null) req.headers.set('authorization', 'Bearer $token');
        req.write('{}');
        final response = await req.close();
        final body = await utf8.decoder.bind(response).join();
        return (response.statusCode, body.isEmpty ? null : jsonDecode(body));
      } finally {
        client.close(force: true);
      }
    }

    Future<(UuidValue, String)> account() async {
      final email =
          'course-${DateTime.now().microsecondsSinceEpoch}-${sequence++}@example.test';
      final user = await AuthServices.instance.authUsers.create(session);
      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: user.id,
        email: email,
        password: 'Course-password-123',
      );
      expect(
        await EmailAccount.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(user.id),
        ),
        isNotNull,
      );
      await AccountAccess.db.insertRow(
        session,
        AccountAccess(
          authUserId: user.id,
          isAdmin: false,
          developmentBootstrap: false,
        ),
      );
      final client = HttpClient();
      try {
        final req = await client.postUrl(
          Uri.parse(
            'http://localhost:${session.serverpod.server.port}/emailIdp/login',
          ),
        );
        req.headers.contentType = ContentType.json;
        req.write(
          jsonEncode({'email': email, 'password': 'Course-password-123'}),
        );
        final response = await req.close();
        final body = await utf8.decoder.bind(response).join();
        expect(response.statusCode, 200);
        return (
          user.id,
          AuthSuccess.fromJson(
            Map<String, dynamic>.from(jsonDecode(body)),
          ).token,
        );
      } finally {
        client.close(force: true);
      }
    }

    test('lists only owned, visible, completed uploads once', () async {
      final owner = await account();
      final other = await account();
      final course = await CourseRecord.db.insertRow(
        session,
        CourseRecord(title: 'Biology'),
      );
      final membership = await CourseMembership.db.insertRow(
        session,
        CourseMembership(
          courseId: course.id!,
          authUserId: owner.$1,
          role: 'student',
        ),
      );
      await CourseMembership.db.insertRow(
        session,
        CourseMembership(
          courseId: course.id!,
          authUserId: other.$1,
          role: 'student',
        ),
      );
      final section = await CourseSectionRecord.db.insertRow(
        session,
        CourseSectionRecord(
          courseId: course.id!,
          title: 'Week 1',
          sortOrder: 0,
          published: true,
        ),
      );
      final activity = await CourseActivityRecord.db.insertRow(
        session,
        CourseActivityRecord(
          sectionId: section.id!,
          title: 'Essay',
          kind: 'assignment',
          sortOrder: 0,
          published: true,
        ),
      );
      await TeachingActivityRecord.db.insertRow(
        session,
        TeachingActivityRecord(
          courseId: course.id!,
          activityId: activity.id!,
          kind: 'assignment',
          published: true,
          settings: TeachingSettings(title: 'Essay', instructions: ''),
          questions: [],
        ),
      );
      final assessment = await CourseActivityRecord.db.insertRow(
        session,
        CourseActivityRecord(
          sectionId: section.id!,
          title: 'Study',
          kind: 'test',
          sortOrder: 1,
          published: true,
          assessment: CourseAssessmentInfo(instructions: 'Study'),
        ),
      );
      final notebook = await NotebookRecord.db.insertRow(
        session,
        NotebookRecord(
          courseId: course.id!,
          assessmentActivityId: assessment.id!,
          ownerUserId: owner.$1,
        ),
      );
      await NotebookAssessmentConfigRecord.db.insertRow(
        session,
        NotebookAssessmentConfigRecord(
          courseId: course.id!,
          teacherUserId: other.$1,
          assessmentActivityId: assessment.id!,
          allowedFormats: ['pdf'],
        ),
      );
      Future<void> source(
        String name,
        UuidValue? user,
        String status,
        UuidValue? notebookId,
      ) async {
        await NotebookSourceRecord.db.insertRow(
          session,
          NotebookSourceRecord(
            courseId: course.id!,
            notebookId: notebookId,
            ownerUserId: user,
            fileName: name,
            format: 'pdf',
            storageId: 'private',
            storagePath: 'hidden/$name',
            status: status,
          ),
        );
      }

      await source('mine.pdf', owner.$1, 'ready', notebook.id);
      await source('uploading.pdf', owner.$1, 'uploading', notebook.id);
      await source('removed.pdf', owner.$1, 'deleted', notebook.id);
      await source('course.pdf', null, 'ready', null);
      await source('other.pdf', other.$1, 'ready', notebook.id);
      final upload = await TeachingUploadRecord.db.insertRow(
        session,
        TeachingUploadRecord(
          activityId: activity.id!,
          ownerId: owner.$1,
          fileName: 'answer.pdf',
          sizeBytes: 1,
          path: 'private/answer',
          createdAt: DateTime.utc(2025),
        ),
      );
      await TeachingUploadRecord.db.insertRow(
        session,
        TeachingUploadRecord(
          activityId: activity.id!,
          ownerId: owner.$1,
          fileName: 'unfinished.pdf',
          sizeBytes: 1,
          path: 'private/unfinished',
          createdAt: DateTime.utc(2025),
        ),
      );
      for (var i = 0; i < 2; i++) {
        await TeachingSubmissionRecord.db.insertRow(
          session,
          TeachingSubmissionRecord(
            activityId: activity.id!,
            ownerId: owner.$1,
            requestKey: 'revision-$i',
            text: '',
            uploadId: upload.id,
            submittedAt: DateTime.utc(2025, 1, i + 1),
          ),
        );
      }
      final unauthenticated = await list(null);
      expect(unauthenticated.$1, isNot(200));
      final otherFiles = await list(other.$2);
      expect(otherFiles.$1, 200);
      expect(otherFiles.$2, isEmpty);
      final result = await list(owner.$2);
      expect(result.$1, 200);
      final rows = result.$2 as List;
      expect(
        rows.map((row) => row['fileName']),
        containsAll(['mine.pdf', 'answer.pdf']),
      );
      expect(rows, hasLength(2));
      expect(rows.first['fileName'], 'mine.pdf');
      expect(jsonEncode(rows), isNot(contains('private/')));
      expect(jsonEncode(rows), isNot(contains('hidden/')));
      await CourseSectionRecord.db.updateRow(
        session,
        section.copyWith(published: false),
      );
      expect((await list(owner.$2)).$2, isEmpty);
      await CourseSectionRecord.db.updateRow(
        session,
        section.copyWith(published: true),
      );
      await CourseMembership.db.updateRow(
        session,
        membership.copyWith(active: false),
      );
      expect((await list(owner.$2)).$2, isEmpty);
    });
  }, rollbackDatabase: RollbackDatabase.disabled);
}
