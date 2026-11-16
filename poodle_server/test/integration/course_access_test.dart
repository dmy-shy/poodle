import 'dart:convert';
import 'dart:io';
import 'package:poodle_server/src/auth/identity_auth_config.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:poodle_server/src/modules/course_content/development_course_seed.dart';
import 'package:serverpod/serverpod.dart';
import 'package:poodle_server/src/modules/notebook/notebook_ai_provider.dart';
import 'package:poodle_server/src/modules/search/search_document.dart';
import 'package:poodle_server/src/modules/search/search_service.dart';
import 'package:serverpod/src/server/server.dart' show ServerInternalMethods;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

class _FixtureEmbedding implements EmbeddingProvider {
  static final vector = List<double>.generate(1536, (i) => i == 0 ? 1 : 0);
  bool fail = false;

  @override
  Future<NotebookEmbeddingBatch> embed(List<String> texts) async {
    if (fail) throw const NotebookProviderException('provider_unavailable');
    return NotebookEmbeddingBatch(vectors: [vector], inputTokens: 1);
  }
}

void main() {
  withServerpod('Course bearer and persistence boundary', (builder, endpoints) {
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

    test(
      'admin overview counts mixed memberships and denies nonadmins',
      () async {
        final admin = await account(admin: true);
        final mixed = await account();
        final first = await CourseRecord.db.insertRow(
          session,
          CourseRecord(title: 'Admin overview A'),
        );
        final second = await CourseRecord.db.insertRow(
          session,
          CourseRecord(title: 'Admin overview B'),
        );
        for (final entry in [(first.id!, 'teacher'), (second.id!, 'student')]) {
          await CourseMembership.db.insertRow(
            session,
            CourseMembership(
              courseId: entry.$1,
              authUserId: mixed.$1,
              role: entry.$2,
            ),
          );
        }
        final denied = await request(
          'adminOverview',
          'summary',
          {},
          token: mixed.$2,
        );
        expect(denied.$1, isNot(200));
        final summary = await request(
          'adminOverview',
          'summary',
          {},
          token: admin.$2,
        );
        expect(summary.$1, 200);
        expect(summary.$2['students'], greaterThanOrEqualTo(1));
        expect(summary.$2['teachers'], greaterThanOrEqualTo(1));
        for (final category in ['students', 'teachers']) {
          final response = await request('adminOverview', 'list', {
            'category': category,
            'offset': 0,
          }, token: admin.$2);
          expect(response.$1, 200);
          expect(
            (response.$2 as List).any(
              (row) => row['id'] == mixed.$1.toString(),
            ),
            isTrue,
          );
        }
        final invalid = await request('adminOverview', 'list', {
          'category': 'private',
          'offset': -1,
        }, token: admin.$2);
        expect(invalid.$1, isNot(200));
      },
    );

    test('star and hide stay private to the enrolled account', () async {
      final first = await account();
      final second = await account();
      final course = await CourseRecord.db.insertRow(
        session,
        CourseRecord(title: 'Shared course'),
      );
      for (final user in [first.$1, second.$1]) {
        await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: course.id!,
            authUserId: user,
            role: 'student',
          ),
        );
      }
      final result = await request('course', 'setStarred', {
        'courseId': course.id.toString(),
        'starred': true,
      }, token: first.$2);
      expect(result.$1, 200);
      expect(result.$2['starred'], true);
      final hidden = await request('course', 'setHidden', {
        'courseId': course.id.toString(),
        'hidden': true,
      }, token: first.$2);
      expect(hidden.$1, 200);
      expect(hidden.$2['hidden'], true);
      final other = await request(
        'course',
        'listMyCourses',
        {},
        token: second.$2,
      );
      expect(other.$1, 200);
      expect(other.$2.single['starred'], false);
      expect(other.$2.single['hidden'], false);
    });

    test(
      'live search relevance across four language pairs',
      () async {
        final provider = OpenAiEmbeddingProvider(
          apiKey: Platform.environment['OPENAI_API_KEY']!,
        );
        addTearDown(provider.close);
        final user = await account();
        final authenticated = await session.serverpod.createSession(
          enableLogging: false,
        );
        addTearDown(authenticated.close);
        authenticated.updateAuthenticated(
          await AuthServices.instance.authenticationHandler(
            authenticated,
            user.$2,
          ),
        );
        final fixtures = (await File(
          'test/fixtures/search_relevance.tsv',
        ).readAsLines()).map((line) => line.split('\t')).toList();
        final titles = [for (final fixture in fixtures) ...fixture.take(2)];
        final vectors = (await provider.embed(titles)).vectors;
        final ids = <UuidValue>[];
        for (var i = 0; i < titles.length; i++) {
          final course = await CourseRecord.db.insertRow(
            session,
            CourseRecord(title: titles[i]),
          );
          ids.add(course.id!);
          await CourseMembership.db.insertRow(
            session,
            CourseMembership(
              courseId: course.id!,
              authUserId: user.$1,
              role: 'student',
            ),
          );
          final doc = SearchDocument.course(course);
          final job = await SearchIndexJob.db.insertRow(
            session,
            SearchIndexJob(
              fingerprint: doc.fingerprint,
              targetId: course.id!,
              state: 'ready',
            ),
          );
          await SearchIndexChunk.db.insertRow(
            session,
            SearchIndexChunk(
              jobId: job.id!,
              ordinal: 0,
              content: doc.content,
              embeddingSpace: searchEmbeddingSpace,
              embedding: Vector(vectors[i]),
            ),
          );
        }
        var now = DateTime.now().toUtc();
        final service = SearchService(
          embeddings: provider,
          semanticEnabled: true,
          clock: () => now,
        );
        for (var input = 0; input < 2; input++) {
          for (var output = 0; output < 2; output++) {
            var correct = 0;
            for (var i = 0; i < fixtures.length; i++) {
              now = now.add(const Duration(seconds: 3));
              final result = await service.search(
                authenticated,
                fixtures[i][2 + input],
              );
              expect(result.keywordOnly, isFalse);
              if (result.results
                  .take(5)
                  .any((hit) => hit.targetId == ids[i * 2 + output])) {
                correct++;
              }
            }
            expect(
              correct / fixtures.length,
              greaterThanOrEqualTo(0.90),
              reason:
                  '${input == 0 ? 'en' : 'uk'} → ${output == 0 ? 'en' : 'uk'}',
            );
          }
        }
        for (final query in [
          'buy a red winter coat',
          'dog grooming appointment',
          'купити квиток на потяг',
          'адреса найближчої кав’ярні',
        ]) {
          now = now.add(const Duration(seconds: 3));
          expect((await service.search(authenticated, query)).results, isEmpty);
        }
      },
      skip:
          Platform.environment['POODLE_RUN_LIVE_SEARCH_EVAL'] != 'true' ||
              (Platform.environment['OPENAI_API_KEY']?.isEmpty ?? true)
          ? 'Opt in with POODLE_RUN_LIVE_SEARCH_EVAL=true and an embedding credential'
          : false,
      timeout: const Timeout(Duration(minutes: 5)),
    );

    test(
      'semantic search uses matching-space vectors and ignores changed content',
      () async {
        final student = await account();
        final course = await CourseRecord.db.insertRow(
          session,
          CourseRecord(title: 'Структури даних'),
        );
        await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: course.id!,
            authUserId: student.$1,
            role: 'student',
          ),
        );
        final doc = SearchDocument.course(course);
        final job = await SearchIndexJob.db.insertRow(
          session,
          SearchIndexJob(
            fingerprint: doc.fingerprint,
            targetId: course.id!,
            state: 'ready',
          ),
        );
        final chunk = await SearchIndexChunk.db.insertRow(
          session,
          SearchIndexChunk(
            jobId: job.id!,
            ordinal: 0,
            content: 'Двійкові дерева',
            embeddingSpace: searchEmbeddingSpace,
            embedding: Vector(_FixtureEmbedding.vector),
          ),
        );
        final authenticated = await session.serverpod.createSession(
          enableLogging: false,
        );
        addTearDown(authenticated.close);
        authenticated.updateAuthenticated(
          await AuthServices.instance.authenticationHandler(
            authenticated,
            student.$2,
          ),
        );
        final fake = _FixtureEmbedding();
        final service = SearchService(embeddings: fake, semanticEnabled: true);
        final result = await service.search(authenticated, 'binary tree');
        expect(result.keywordOnly, isFalse);
        expect(result.results.single.targetId, course.id);
        await SearchIndexChunk.db.updateRow(
          session,
          chunk.copyWith(embeddingSpace: 'incompatible'),
        );
        expect(
          (await service.search(authenticated, 'binary tree')).results,
          isEmpty,
        );
        await SearchIndexChunk.db.updateRow(session, chunk);
        await CourseRecord.db.updateRow(
          session,
          course.copyWith(title: 'Мережі'),
        );
        expect(
          (await service.search(authenticated, 'binary tree')).results,
          isEmpty,
        );
        fake.fail = true;
        final fallback = await service.search(authenticated, 'мережі');
        expect(fallback.keywordOnly, isTrue);
        expect(fallback.results.single.targetId, course.id);
      },
    );

    test(
      'bilingual search respects visibility and keeps private bounded history',
      () async {
        final student = await account();
        final teacher = await account();
        final course = await CourseRecord.db.insertRow(
          session,
          CourseRecord(title: 'Структури даних'),
        );
        final member = await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: course.id!,
            authUserId: student.$1,
            role: 'student',
          ),
        );
        await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: course.id!,
            authUserId: teacher.$1,
            role: 'teacher',
          ),
        );
        final section = await CourseSectionRecord.db.insertRow(
          session,
          CourseSectionRecord(
            courseId: course.id!,
            title: 'Дерева',
            sortOrder: 0,
            published: true,
          ),
        );
        final visible = await CourseActivityRecord.db.insertRow(
          session,
          CourseActivityRecord(
            sectionId: section.id!,
            title: 'Оголошення',
            sortOrder: 0,
            published: true,
            kind: 'announcement',
            announcement: CourseAnnouncementInfo(body: 'Бінарні дерева'),
          ),
        );
        final draft = await CourseActivityRecord.db.insertRow(
          session,
          CourseActivityRecord(
            sectionId: section.id!,
            title: 'Прихований чернетковий матеріал',
            sortOrder: 1,
            kind: 'announcement',
            announcement: CourseAnnouncementInfo(body: 'Бінарні дерева'),
          ),
        );
        Future<SearchResponse> search(String token, String query) async {
          final result = await request('search', 'search', {
            'query': query,
          }, token: token);
          expect(result.$1, 200, reason: '${result.$2}');
          return SearchResponse.fromJson(Map<String, dynamic>.from(result.$2));
        }

        final matches = await search(student.$2, 'бінарні');
        expect(matches.results.map((hit) => hit.targetId), [visible.id]);
        expect(matches.results.single.excerpt, contains('Бінарні'));
        expect(
          (await search(
            teacher.$2,
            'бінарні',
          )).results.map((hit) => hit.targetId),
          unorderedEquals([visible.id, draft.id]),
        );
        await CourseMembership.db.updateRow(
          session,
          member.copyWith(active: false),
        );
        expect((await search(student.$2, 'бінарні')).results, isEmpty);

        Future<List<SearchRecent>> history(
          String token,
          String method, [
          Map<String, dynamic> params = const {},
        ]) async {
          final result = await request('search', method, params, token: token);
          expect(result.$1, 200, reason: '${result.$2}');
          return (result.$2 as List)
              .map(
                (e) =>
                    SearchRecent.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList();
        }

        await history(student.$2, 'saveRecent', {'query': 'Їжа   України'});
        final recent = await history(student.$2, 'saveRecent', {
          'query': 'і\u0308жа України',
        });
        expect(recent, hasLength(1));
        await history(teacher.$2, 'deleteRecent', {'id': recent.single.id});
        expect(await history(teacher.$2, 'listRecent'), isEmpty);
        expect(await history(student.$2, 'listRecent'), hasLength(1));
        final spaced = await history(student.$2, 'saveRecent', {
          'query': '  English \n  lesson  ',
        });
        expect(spaced.first.query, 'English lesson');
        for (final query in ['bad\u0000input', 'bad\u0007input']) {
          final invalidSearch = await request('search', 'search', {
            'query': query,
          }, token: student.$2);
          expect(invalidSearch.$1, isNot(200));
          final invalidHistory = await request('search', 'saveRecent', {
            'query': query,
          }, token: student.$2);
          expect(invalidHistory.$1, isNot(200));
        }
        await SearchHistoryRecord.db.insertRow(
          session,
          SearchHistoryRecord(
            authUserId: student.$1,
            query: 'expired',
            normalized: 'expired',
            lastUsed: DateTime.now().toUtc().subtract(const Duration(days: 91)),
          ),
        );
        expect(await history(student.$2, 'listRecent'), hasLength(2));
        for (var i = 0; i < 21; i++) {
          await history(student.$2, 'saveRecent', {'query': 'Query $i'});
        }
        expect(await history(student.$2, 'listRecent'), hasLength(20));
        expect(await history(student.$2, 'clearRecent'), isEmpty);
      },
    );

    test(
      'real JWT cannot bypass membership, publication, UUID parsing or revocation',
      () async {
        final student = await account();
        final teacher = await account();
        final admin = await account(admin: true);
        final course = await CourseRecord.db.insertRow(
          session,
          CourseRecord(title: 'Private course'),
        );
        final other = await CourseRecord.db.insertRow(
          session,
          CourseRecord(title: 'Other course'),
        );
        final membership = await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: course.id!,
            authUserId: student.$1,
            role: 'student',
          ),
        );
        await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: course.id!,
            authUserId: teacher.$1,
            role: 'teacher',
          ),
        );
        final section = await CourseSectionRecord.db.insertRow(
          session,
          CourseSectionRecord(
            courseId: course.id!,
            title: 'Materials',
            sortOrder: 0,
            published: true,
          ),
        );
        final published = await CourseActivityRecord.db.insertRow(
          session,
          CourseActivityRecord(
            sectionId: section.id!,
            title: 'Visible',
            kind: 'announcement',
            sortOrder: 2,
            published: true,
            announcement: CourseAnnouncementInfo(body: 'Published text'),
          ),
        );
        final draft = await CourseActivityRecord.db.insertRow(
          session,
          CourseActivityRecord(
            sectionId: section.id!,
            title: 'Secret file',
            kind: 'file',
            sortOrder: 1,
            published: false,
            file: CourseFileInfo(
              fileName: 'private.pdf',
              mimeType: 'application/pdf',
              sizeBytes: 10,
              checksum: 'test',
            ),
            storageId: 'private',
            storagePath: 'secret',
          ),
        );
        final unpublishedSection = await CourseSectionRecord.db.insertRow(
          session,
          CourseSectionRecord(
            courseId: course.id!,
            title: 'Secret section',
            sortOrder: 1,
          ),
        );
        await CourseActivityRecord.db.insertRow(
          session,
          CourseActivityRecord(
            sectionId: unpublishedSection.id!,
            title: 'Hidden by section',
            kind: 'announcement',
            sortOrder: 0,
            published: true,
            announcement: CourseAnnouncementInfo(body: 'Hidden'),
          ),
        );
        final courseBody = {'courseId': course.id.toString()};
        final studentContent = await request(
          'courseContent',
          'getCourseContent',
          courseBody,
          token: student.$2,
        );
        expect(studentContent.$1, 200);
        expect(studentContent.$2['sections'], hasLength(1));
        final rows = studentContent.$2['sections'][0]['activities'] as List;
        expect(rows, hasLength(1));
        expect(rows.single['id'], published.id.toString());
        expect(rows.single['previousId'], isNull);
        expect(rows.single['nextId'], isNull);
        final teacherContent = await request(
          'courseContent',
          'getCourseContent',
          courseBody,
          token: teacher.$2,
        );
        expect(teacherContent.$1, 200);
        expect(teacherContent.$2['sections'], hasLength(2));
        expect(
          teacherContent.$2['sections'][0]['activities'][0]['draft'],
          true,
        );
        for (final token in <String?>[null, admin.$2]) {
          final denied = await request(
            'courseContent',
            'getCourseContent',
            courseBody,
            token: token,
          );
          expect(denied.$1, isNot(200));
          expect(jsonEncode(denied.$2), isNot(contains('Secret')));
        }
        for (final method in ['getActivity', 'getFileUrl']) {
          expect(
            (await request('courseContent', method, {
              ...courseBody,
              'activityId': draft.id.toString(),
            }, token: student.$2)).$1,
            isNot(200),
          );
          expect(
            (await request('courseContent', method, {
              'courseId': other.id.toString(),
              'activityId': published.id.toString(),
            }, token: teacher.$2)).$1,
            isNot(200),
          );
        }
        for (final id in ['1', 'course-design', 'not-a-uuid']) {
          expect(
            (await request('course', 'getCourse', {
              'courseId': id,
            }, token: student.$2)).$1,
            isNot(200),
          );
        }
        await CourseMembership.db.updateRow(
          session,
          membership.copyWith(active: false),
        );
        expect(
          (await request(
            'courseContent',
            'getCourseContent',
            courseBody,
            token: student.$2,
          )).$1,
          isNot(200),
        );
        expect(
          (await request('course', 'listMyCourses', {}, token: student.$2)).$2,
          isEmpty,
        );
      },
    );

    test(
      'seed is explicit, preserves teacher edits and never reactivates membership',
      () async {
        await expectLater(
          DevelopmentCourseSeed.ensure(session),
          throwsStateError,
        );
        final admin = await account(admin: true, bootstrap: true);
        await DevelopmentCourseSeed.ensure(session, testFixture: true);
        final id = UuidValue.withValidation(
          DevelopmentCourseSeed.courseIds.first,
        );
        final course = (await CourseRecord.db.findById(session, id))!;
        final member = (await CourseMembership.db.findFirstRow(
          session,
          where: (t) => t.courseId.equals(id) & t.authUserId.equals(admin.$1),
        ))!;
        await CourseRecord.db.updateRow(
          session,
          course.copyWith(title: 'Teacher edit'),
        );
        await CourseMembership.db.updateRow(
          session,
          member.copyWith(active: false),
        );
        final courseCount = await CourseRecord.db.count(session);
        final sectionCount = await CourseSectionRecord.db.count(session);
        final activityCount = await CourseActivityRecord.db.count(session);
        await DevelopmentCourseSeed.ensure(session, testFixture: true);
        expect(await CourseRecord.db.count(session), courseCount);
        expect(await CourseSectionRecord.db.count(session), sectionCount);
        expect(await CourseActivityRecord.db.count(session), activityCount);
        expect(
          (await CourseRecord.db.findById(session, id))!.title,
          'Teacher edit',
        );
        expect(
          (await CourseMembership.db.findById(session, member.id!))!.active,
          false,
        );
      },
    );
  }, rollbackDatabase: RollbackDatabase.disabled);
}
