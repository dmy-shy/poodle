import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:poodle_server/src/auth/identity_auth_config.dart';
import 'package:poodle_server/src/modules/notebook/development_notebook_seed.dart';
import 'package:poodle_server/src/modules/course_content/development_course_seed.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart'
    show CloudStorageDirectDownloadEntry;
import 'package:serverpod/src/server/server.dart' show ServerInternalMethods;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Notebook material registration and isolation', (
    builder,
    endpoints,
  ) {
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
        CourseRecord course,
        CourseActivityRecord test,
        CourseActivityRecord material,
        (UuidValue, String) teacher,
        (UuidValue, String) student,
        CourseMembership membership,
      })
    >
    fixture() async {
      final teacher = await account();
      final student = await account();
      final course = await CourseRecord.db.insertRow(
        session,
        CourseRecord(title: 'Notebook test data'),
      );
      await CourseMembership.db.insertRow(
        session,
        CourseMembership(
          courseId: course.id!,
          authUserId: teacher.$1,
          role: 'teacher',
        ),
      );
      final membership = await CourseMembership.db.insertRow(
        session,
        CourseMembership(
          courseId: course.id!,
          authUserId: student.$1,
          role: 'student',
        ),
      );
      final section = await CourseSectionRecord.db.insertRow(
        session,
        CourseSectionRecord(
          courseId: course.id!,
          title: 'Test data / Тестові дані',
          sortOrder: 0,
          published: true,
        ),
      );
      final assessment = await CourseActivityRecord.db.insertRow(
        session,
        CourseActivityRecord(
          sectionId: section.id!,
          title: 'Test data',
          kind: 'test',
          sortOrder: 1,
          published: true,
          assessment: CourseAssessmentInfo(
            instructions: 'Prepare using the selected sources.',
          ),
        ),
      );
      final material = await CourseActivityRecord.db.insertRow(
        session,
        CourseActivityRecord(
          sectionId: section.id!,
          title: 'Study notes',
          kind: 'file',
          sortOrder: 0,
          published: true,
          file: CourseFileInfo(
            fileName: 'test-data.txt',
            mimeType: 'text/plain',
            sizeBytes: 100,
            checksum: 'fixture-v1',
          ),
          storageId: 'private',
          storagePath: 'notebook-tests/fixture-v1.txt',
        ),
      );
      return (
        course: course,
        test: assessment,
        material: material,
        teacher: teacher,
        student: student,
        membership: membership,
      );
    }

    Map<String, dynamic> configBody(
      UuidValue course,
      UuidValue assessment,
      List<UuidValue> materials, {
      int revision = 0,
    }) => {
      'input': {
        '__className__': 'NotebookAssessmentConfigInput',
        'courseId': course.toString(),
        'assessmentActivityId': assessment.toString(),
        'defaultMaterialActivityIds': materials
            .map((id) => id.toString())
            .toList(),
        'allowedFormats': ['txt', 'pdf'],
        'expectedRevision': revision,
      },
    };

    test(
      'private upload is owner-only, verified before queueing, and removable',
      () async {
        final f = await fixture();
        await request(
          'notebook',
          'configureAssessment',
          configBody(f.course.id!, f.test.id!, [f.material.id!]),
          token: f.teacher.$2,
        );
        final opened = await request('notebook', 'openNotebook', {
          'courseId': f.course.id.toString(),
          'assessmentActivityId': f.test.id.toString(),
        }, token: f.student.$2);
        final notebookId = opened.$2['notebookId'] as String;
        final body = {
          'input': {
            '__className__': 'NotebookUploadInput',
            'notebookId': notebookId,
            'fileName': 'private.txt',
            'sizeBytes': 5,
            'checksum': 'a' * 64,
            'requestKey': 'upload-test-request-1234',
          },
        };
        final denied = await request(
          'notebook',
          'beginUpload',
          body,
          token: f.teacher.$2,
        );
        expect(denied.$1, greaterThanOrEqualTo(400));
        var begun = await request(
          'notebook',
          'beginUpload',
          body,
          token: f.student.$2,
        );
        expect(begun.$1, 200, reason: '${begun.$2}');
        final sourceId = begun.$2['sourceId'] as String;
        final jobId = begun.$2['jobId'] as String;
        final whileUploading = await request('notebook', 'openNotebook', {
          'courseId': f.course.id.toString(),
          'assessmentActivityId': f.test.id.toString(),
        }, token: f.student.$2);
        expect(
          (whileUploading.$2['sources'] as List).any(
            (dynamic source) => source['id'] == sourceId,
          ),
          false,
        );
        final other = await account();
        await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: f.course.id!,
            authUserId: other.$1,
            role: 'student',
          ),
        );
        expect(
          (await request('notebook', 'beginUpload', body, token: other.$2)).$1,
          greaterThanOrEqualTo(400),
        );
        final originalInput = Map<String, dynamic>.from(body['input'] as Map);
        for (final invalid in [
          {...originalInput, 'fileName': '../private.txt'},
          {...originalInput, 'fileName': 'private.docx'},
          {...originalInput, 'sizeBytes': 26 * 1024 * 1024},
          {...originalInput, 'checksum': 'invalid'},
          {...originalInput, 'fileName': 'changed.txt'},
        ]) {
          expect(
            (await request('notebook', 'beginUpload', {
              'input': invalid,
            }, token: f.student.$2)).$1,
            greaterThanOrEqualTo(400),
          );
        }
        begun = await request(
          'notebook',
          'beginUpload',
          body,
          token: f.student.$2,
        );
        expect(begun.$2['jobId'], jobId);
        final finish = {'notebookId': notebookId, 'jobId': jobId};
        final incomplete = await request(
          'notebook',
          'finishUpload',
          finish,
          token: f.student.$2,
        );
        expect(incomplete.$1, greaterThanOrEqualTo(400));
        expect(
          (await NotebookJobRecord.db.findById(
            session,
            UuidValue.withValidation(jobId),
          ))!.status,
          'awaiting_upload',
        );
        final upload =
            jsonDecode(begun.$2['uploadDescription'] as String) as Map;
        final client = HttpClient();
        try {
          final put = await client.postUrl(
            Uri.parse(
              upload['url'] as String,
            ).replace(port: session.serverpod.server.port),
          );
          put.headers.contentType = ContentType.binary;
          put.contentLength = 5;
          put.add(utf8.encode('hello'));
          final response = await put.close();
          await response.drain<void>();
          expect(response.statusCode, anyOf(200, 204));
        } finally {
          client.close(force: true);
        }
        expect(
          (await request(
            'notebook',
            'finishUpload',
            finish,
            token: f.teacher.$2,
          )).$1,
          greaterThanOrEqualTo(400),
        );
        expect(
          (await request(
            'notebook',
            'finishUpload',
            finish,
            token: f.student.$2,
          )).$1,
          200,
        );
        expect(
          (await request(
            'notebook',
            'finishUpload',
            finish,
            token: f.student.$2,
          )).$1,
          200,
        );
        expect(
          (await NotebookJobRecord.db.findById(
            session,
            UuidValue.withValidation(jobId),
          ))!.status,
          'queued',
        );
        final remove = {'notebookId': notebookId, 'sourceId': sourceId};
        expect(
          (await request(
            'notebook',
            'removeUpload',
            remove,
            token: f.teacher.$2,
          )).$1,
          greaterThanOrEqualTo(400),
        );
        expect(
          (await request(
            'notebook',
            'removeUpload',
            remove,
            token: f.student.$2,
          )).$1,
          200,
        );
        final after = await request('notebook', 'openNotebook', {
          'courseId': f.course.id.toString(),
          'assessmentActivityId': f.test.id.toString(),
        }, token: f.student.$2);
        expect(
          (after.$2['sources'] as List).where((s) => s['id'] == sourceId),
          isEmpty,
        );
      },
    );

    test('a new upload reclaims an expired unfinished source', () async {
      final f = await fixture();
      await request(
        'notebook',
        'configureAssessment',
        configBody(f.course.id!, f.test.id!, [f.material.id!]),
        token: f.teacher.$2,
      );
      final opened = await request('notebook', 'openNotebook', {
        'courseId': f.course.id.toString(),
        'assessmentActivityId': f.test.id.toString(),
      }, token: f.student.$2);
      final input = {
        '__className__': 'NotebookUploadInput',
        'notebookId': opened.$2['notebookId'],
        'fileName': 'private.txt',
        'sizeBytes': 5,
        'checksum': 'a' * 64,
        'requestKey': 'expired-upload-request-1234',
      };
      final first = await request(
        'notebook',
        'beginUpload',
        {'input': input},
        token: f.student.$2,
      );
      expect(first.$1, 200);
      final oldJobId = UuidValue.withValidation(first.$2['jobId'] as String);
      final oldJob = (await NotebookJobRecord.db.findById(session, oldJobId))!;
      await NotebookJobRecord.db.updateRow(
        session,
        oldJob.copyWith(
          createdAt: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
        ),
      );
      final next = await request(
        'notebook',
        'beginUpload',
        {
          'input': {...input, 'requestKey': 'next-upload-request-1234'},
        },
        token: f.student.$2,
      );
      expect(next.$1, 200);
      expect(
        (await NotebookJobRecord.db.findById(session, oldJobId))!.status,
        'failed',
      );
      expect(
        (await NotebookSourceRecord.db.findById(
          session,
          UuidValue.withValidation(first.$2['sourceId'] as String),
        ))!.status,
        'deleted',
      );
      expect(
        (await request('notebook', 'removeUpload', {
          'notebookId': opened.$2['notebookId'],
          'sourceId': next.$2['sourceId'],
        }, token: f.student.$2)).$1,
        200,
      );
    });

    test(
      'teacher setup is read-only, course-scoped and lists only eligible published materials',
      () async {
        final f = await fixture();
        final body = {
          'courseId': f.course.id.toString(),
          'assessmentActivityId': f.test.id.toString(),
        };
        Future<(int, dynamic)> read({String? token}) =>
            request('notebook', 'getAssessmentSetup', body, token: token);
        final initial = await read(token: f.teacher.$2);
        expect(initial.$1, 200);
        expect(initial.$2['configuration']['revision'], 0);
        expect(
          initial.$2['configuration']['defaultMaterialActivityIds'],
          isEmpty,
        );
        expect(initial.$2['materials'].single['id'], f.material.id.toString());
        expect(
          await NotebookAssessmentConfigRecord.db.count(
            session,
            where: (t) => t.courseId.equals(f.course.id),
          ),
          0,
        );
        expect((await read()).$1, isNot(200));
        expect((await read(token: f.student.$2)).$1, isNot(200));
        final other = await fixture();
        expect((await read(token: other.teacher.$2)).$1, isNot(200));
        expect(
          (await request('notebook', 'getAssessmentSetup', {
            ...body,
            'assessmentActivityId': other.test.id.toString(),
          }, token: f.teacher.$2)).$1,
          isNot(200),
        );
        for (final bad in [
          f.material.copyWith(id: Uuid().v7obj(), published: false),
          f.material.copyWith(id: Uuid().v7obj(), storageId: 'public'),
          f.material.copyWith(
            id: Uuid().v7obj(),
            file: f.material.file!.copyWith(sizeBytes: 26 * 1024 * 1024),
          ),
          f.material.copyWith(
            id: Uuid().v7obj(),
            file: f.material.file!.copyWith(mimeType: 'image/png'),
          ),
        ]) {
          await CourseActivityRecord.db.insertRow(session, bad);
        }
        final hiddenSection = await CourseSectionRecord.db.insertRow(
          session,
          CourseSectionRecord(
            courseId: f.course.id!,
            title: 'Draft section',
            sortOrder: 1,
            published: false,
          ),
        );
        await CourseActivityRecord.db.insertRow(
          session,
          f.material.copyWith(id: Uuid().v7obj(), sectionId: hiddenSection.id!),
        );
        expect((await read(token: f.teacher.$2)).$2['materials'], hasLength(1));
        final configured = await request(
          'notebook',
          'configureAssessment',
          configBody(f.course.id!, f.test.id!, [f.material.id!]),
          token: f.teacher.$2,
        );
        expect(configured.$1, 200);
        final saved = await read(token: f.teacher.$2);
        expect(saved.$2['configuration']['revision'], 1);
        expect(saved.$2['configuration']['defaultMaterialActivityIds'], [
          f.material.id.toString(),
        ]);
        await CourseActivityRecord.db.updateRow(
          session,
          f.material.copyWith(published: false),
        );
        final withdrawn = await read(token: f.teacher.$2);
        expect(withdrawn.$2['materials'], isEmpty);
        expect(withdrawn.$2['configuration']['defaultMaterialActivityIds'], [
          f.material.id.toString(),
        ]);
        final membership = (await CourseMembership.db.find(
          session,
          where: (t) =>
              t.courseId.equals(f.course.id) &
              t.authUserId.equals(f.teacher.$1),
        )).single;
        await CourseMembership.db.updateRow(
          session,
          membership.copyWith(active: false),
        );
        expect((await read(token: f.teacher.$2)).$1, isNot(200));
        await CourseMembership.db.updateRow(session, membership);
        await CourseActivityRecord.db.updateRow(
          session,
          f.test.copyWith(published: false),
        );
        expect((await read(token: f.teacher.$2)).$1, isNot(200));
      },
    );

    test(
      'history and citation passages enforce ownership and current source authority',
      () async {
        final f = await fixture();
        await request(
          'notebook',
          'configureAssessment',
          configBody(f.course.id!, f.test.id!, [f.material.id!]),
          token: f.teacher.$2,
        );
        final opened = await request('notebook', 'openNotebook', {
          'courseId': f.course.id.toString(),
          'assessmentActivityId': f.test.id.toString(),
        }, token: f.student.$2);
        final notebookId = UuidValue.withValidation(
          opened.$2['notebookId'] as String,
        );
        var source = (await NotebookSourceRecord.db.find(
          session,
          where: (t) => t.courseId.equals(f.course.id),
        )).single;
        source = await NotebookSourceRecord.db.updateRow(
          session,
          source.copyWith(status: 'ready', currentVersion: 1),
        );
        final version = await NotebookSourceVersionRecord.db.insertRow(
          session,
          NotebookSourceVersionRecord(
            sourceId: source.id!,
            version: 1,
            checksum: 'fixture-v1',
            title: 'Study notes',
            extractedText: 'Private evidence',
            status: 'ready',
            embeddingSpace: 'test',
          ),
        );
        final chunk = await NotebookChunkRecord.db.insertRow(
          session,
          NotebookChunkRecord(
            sourceId: source.id!,
            sourceVersionId: version.id!,
            blockId: 'block-1',
            content: 'Private evidence',
            embedding: Vector(List.filled(1536, 0.1)),
          ),
        );
        final turn = await NotebookTurnRecord.db.insertRow(
          session,
          NotebookTurnRecord(
            notebookId: notebookId,
            ownerUserId: f.student.$1,
            requestKey: 'history-test',
            turnIndex: 0,
            role: 'assistant',
            content: 'Private answer',
            sourceRevision: 1,
            citationsJson: jsonEncode([
              NotebookCitation(
                chunkId: chunk.id!,
                sourceId: source.id!,
                sourceVersionId: version.id!,
                sourceVersion: 1,
                title: 'Study notes',
              ).toJson(),
            ]),
          ),
        );
        final body = {'notebookId': notebookId.toString()};
        final history = await request(
          'notebook',
          'getTurns',
          body,
          token: f.student.$2,
        );
        expect(history.$1, 200);
        expect(history.$2.single['content'], 'Private answer');
        expect(history.$2.single['stale'], false);
        final noteInput = {...body, 'turnId': turn.id.toString()};
        final saved = await request(
          'notebook',
          'saveNote',
          noteInput,
          token: f.student.$2,
        );
        expect(saved.$1, 200);
        expect(saved.$2['content'], 'Private answer');
        final savedAgain = await request(
          'notebook',
          'saveNote',
          noteInput,
          token: f.student.$2,
        );
        expect(savedAgain.$2['id'], saved.$2['id']);
        final notes = await request(
          'notebook',
          'getNotes',
          body,
          token: f.student.$2,
        );
        expect(notes.$1, 200);
        expect(notes.$2.single['id'], saved.$2['id']);
        final denied = await request(
          'notebook',
          'getNotes',
          body,
          token: f.teacher.$2,
        );
        expect(denied.$1, isNot(200));
        final deleted = await request('notebook', 'deleteNote', {
          ...body,
          'noteId': saved.$2['id'],
        }, token: f.student.$2);
        expect(deleted.$1, 200);
        final afterDelete = await request(
          'notebook',
          'getNotes',
          body,
          token: f.student.$2,
        );
        expect(afterDelete.$2, isEmpty);
        final passageBody = {
          ...body,
          'turnId': turn.id.toString(),
          'chunkId': chunk.id.toString(),
        };
        Future<(int, dynamic)> passage({String? token}) => request(
          'notebook',
          'getCitationPassage',
          passageBody,
          token: token,
        );
        expect(await passage(token: f.student.$2), (200, 'Private evidence'));
        expect((await passage(token: f.teacher.$2)).$1, isNot(200));
        expect((await passage()).$1, isNot(200));
        final other = await account();
        await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: f.course.id!,
            authUserId: other.$1,
            role: 'student',
          ),
        );
        expect((await passage(token: other.$2)).$1, isNot(200));
        final uncited = await NotebookChunkRecord.db.insertRow(
          session,
          chunk.copyWith(id: Uuid().v7obj(), content: 'Uncited evidence'),
        );
        for (final forged in [
          {...passageBody, 'chunkId': uncited.id.toString()},
          {...passageBody, 'turnId': Uuid().v7obj().toString()},
        ]) {
          expect(
            (await request(
              'notebook',
              'getCitationPassage',
              forged,
              token: f.student.$2,
            )).$1,
            isNot(200),
          );
        }
        final studioBody = {
          'input': {
            ...body,
            'kind': 'audio',
            'language': 'uk',
            'requestKey': 'studio-test',
          },
        };
        Future<(int, dynamic)> studio(
          String method,
          Map<String, dynamic> payload, {
          String? token,
        }) =>
            request('notebook', method, payload, token: token ?? f.student.$2);
        final queued = await studio('generateStudioItem', studioBody);
        expect(queued.$1, 200);
        expect(queued.$2['status'], 'queued');
        expect(
          (await studio('generateStudioItem', studioBody)).$2['id'],
          queued.$2['id'],
        );
        expect(
          (await studio('generateStudioItem', studioBody, token: other.$2)).$1,
          isNot(200),
        );
        final listed = await studio('getStudioItems', body);
        expect(listed.$2.single['status'], 'queued');
        expect(listed.$2.single['language'], 'uk');

        final job = (await NotebookJobRecord.db.findById(
          session,
          UuidValue.withValidation(queued.$2['id'] as String),
        ))!;
        final audioPath = 'test-studio/${job.id}.mp3';
        final audioBytes = Uint8List.fromList([0xff, 0xfb, 0x90, 0x00]);
        await session.storage.storeFile(
          storageId: 'private',
          path: audioPath,
          byteData: ByteData.sublistView(audioBytes),
        );
        final audio = await NotebookArtifactRecord.db.insertRow(
          session,
          NotebookArtifactRecord(
            notebookId: notebookId,
            ownerUserId: f.student.$1,
            kind: 'audio',
            title: 'Конспект',
            language: 'uk',
            sourceRevision: 1,
            jobId: job.id,
            audioStoragePath: audioPath,
            sourceSnapshotJson: job.privatePayload,
            contentJson: jsonEncode({
              'schemaVersion': 1,
              'transcript': 'Приватний конспект',
              'sections': [
                {
                  'text': 'Приватний конспект',
                  'citationIds': [chunk.id.toString()],
                },
              ],
            }),
          ),
        );
        await NotebookJobRecord.db.updateRow(
          session,
          job.copyWith(status: 'complete'),
        );
        final audioBody = {...body, 'artifactId': audio.id.toString()};
        final detail = await studio('getStudioItem', audioBody);
        expect(detail.$1, 200);
        expect(detail.$2['citations'].single['chunkId'], chunk.id.toString());
        expect(
          (await studio('getStudioItems', body)).$2.single['contentJson'],
          isEmpty,
        );
        expect(
          (await studio('getStudioItem', audioBody, token: other.$2)).$1,
          isNot(200),
        );
        expect(
          await studio('getStudioCitationPassage', {
            ...audioBody,
            'chunkId': chunk.id.toString(),
          }),
          (200, 'Private evidence'),
        );
        expect(
          (await studio('getStudioCitationPassage', {
            ...audioBody,
            'chunkId': uncited.id.toString(),
          })).$1,
          isNot(200),
        );
        expect(
          (await studio('getStudioAudioAccess', audioBody, token: other.$2)).$1,
          isNot(200),
        );
        final access = await studio('getStudioAudioAccess', audioBody);
        expect(access.$1, 200);
        expect(
          DateTime.parse(
            access.$2['expiresAt'] as String,
          ).difference(DateTime.now()).inSeconds,
          inInclusiveRange(14 * 60, 15 * 60),
        );
        final url = Uri.parse(
          access.$2['url'] as String,
        ).replace(port: session.serverpod.server.port);
        final audioClient = HttpClient();
        try {
          final response = await (await audioClient.getUrl(url)).close();
          expect(response.statusCode, 200);
          expect(response.headers.contentType?.mimeType, 'audio/mpeg');
          expect(await response.expand((bytes) => bytes).toList(), audioBytes);
          final entry = (await CloudStorageDirectDownloadEntry.db.findFirstRow(
            session,
            where: (t) => t.path.equals(audioPath),
          ))!;
          await CloudStorageDirectDownloadEntry.db.updateRow(
            session,
            entry.copyWith(
              expiration: DateTime.now().toUtc().subtract(
                const Duration(seconds: 1),
              ),
            ),
          );
          final expired = await (await audioClient.getUrl(url)).close();
          await expired.drain<void>();
          expect(expired.statusCode, isNot(200));
        } finally {
          audioClient.close(force: true);
        }
        await CourseActivityRecord.db.updateRow(
          session,
          f.material.copyWith(published: false),
        );
        expect((await passage(token: f.student.$2)).$1, isNot(200));
        await CourseActivityRecord.db.updateRow(session, f.material);
        await CourseMembership.db.updateRow(
          session,
          f.membership.copyWith(active: false),
        );
        expect((await passage(token: f.student.$2)).$1, isNot(200));
        await CourseMembership.db.updateRow(session, f.membership);
        await NotebookSourceRecord.db.updateRow(
          session,
          source.copyWith(currentVersion: 2),
        );
        expect((await passage(token: f.student.$2)).$1, isNot(200));
        await NotebookSourceRecord.db.updateRow(session, source);
        await NotebookTurnRecord.db.updateRow(
          session,
          turn.copyWith(sourceRevision: 99),
        );
        expect((await passage(token: f.student.$2)).$1, isNot(200));
        await NotebookTurnRecord.db.updateRow(session, turn);
        expect(await passage(token: f.student.$2), (200, 'Private evidence'));

        expect(
          (await request('notebook', 'getTurns', body, token: f.teacher.$2)).$1,
          isNot(200),
        );
        expect((await request('notebook', 'getTurns', body)).$1, isNot(200));
        await NotebookSourceSelectionRecord.db.insertRow(
          session,
          NotebookSourceSelectionRecord(
            notebookId: notebookId,
            sourceId: source.id!,
            selected: false,
            selectedVersion: 1,
          ),
        );
        final hidden = await request(
          'notebook',
          'getTurns',
          body,
          token: f.student.$2,
        );
        expect(hidden.$2.single['stale'], true);
        expect(hidden.$2.single['content'], '');
        expect(hidden.$2.single['citations'], isEmpty);
        expect((await passage(token: f.student.$2)).$1, isNot(200));
        final staleStudio = await studio('getStudioItem', audioBody);
        expect(staleStudio.$2['status'], 'stale');
        expect(staleStudio.$2['contentJson'], isEmpty);
        expect(
          (await studio('getStudioAudioAccess', audioBody)).$1,
          isNot(200),
        );
        expect(
          (await studio('generateStudioItem', studioBody)).$2['id'],
          queued.$2['id'],
        );
      },
    );

    test(
      'development notebook seed stores real bilingual bytes and preserves teacher edits',
      () async {
        final teacher = await account(admin: true, bootstrap: true);
        await DevelopmentCourseSeed.ensure(session, testFixture: true);
        await DevelopmentNotebookSeed.ensure(session, testFixture: true);
        final courseId = UuidValue.withValidation(
          DevelopmentCourseSeed.courseIds.first,
        );
        final config = (await NotebookAssessmentConfigRecord.db.find(
          session,
          where: (t) => t.courseId.equals(courseId),
        )).single;
        final source = (await NotebookSourceRecord.db.find(
          session,
          where: (t) => t.courseId.equals(courseId),
        )).single;
        final data = await session.storage.retrieveFile(
          storageId: 'private',
          path: source.storagePath,
        );
        final text = utf8.decode(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
        expect(text, contains('Retrieval selects'));
        expect(text, contains('Посилання'));
        expect(
          await NotebookJobRecord.db.count(
            session,
            where: (t) => t.sourceId.equals(source.id),
          ),
          1,
        );
        await NotebookAssessmentConfigRecord.db.updateRow(
          session,
          config.copyWith(revision: 9),
        );
        await DevelopmentNotebookSeed.ensure(session, testFixture: true);
        expect(
          (await NotebookAssessmentConfigRecord.db.findById(
            session,
            config.id!,
          ))!.revision,
          9,
        );
        final member = (await CourseMembership.db.findFirstRow(
          session,
          where: (t) =>
              t.courseId.equals(courseId) & t.authUserId.equals(teacher.$1),
        ))!;
        await CourseMembership.db.updateRow(
          session,
          member.copyWith(active: false),
        );
        await DevelopmentNotebookSeed.ensure(session, testFixture: true);
        expect(
          (await CourseMembership.db.findById(session, member.id!))!.active,
          false,
        );
      },
    );

    test(
      'configuration registers one shared source and durable ingestion job atomically',
      () async {
        final f = await fixture();
        final body = configBody(f.course.id!, f.test.id!, [f.material.id!]);
        expect(
          (await request(
            'notebook',
            'configureAssessment',
            body,
            token: f.student.$2,
          )).$1,
          isNot(200),
        );
        final configured = await request(
          'notebook',
          'configureAssessment',
          body,
          token: f.teacher.$2,
        );
        expect(configured.$1, 200);
        final sources = await NotebookSourceRecord.db.find(
          session,
          where: (t) => t.courseId.equals(f.course.id),
        );
        expect(sources, hasLength(1));
        expect(sources.single.ownerUserId, isNull);
        expect(sources.single.status, 'queued');
        final jobs = await NotebookJobRecord.db.find(
          session,
          where: (t) => t.sourceId.equals(sources.single.id),
        );
        expect(jobs, hasLength(1));
        expect(jobs.single.jobType, 'ingest');
        expect(jobs.single.status, 'queued');
        final updated = configBody(f.course.id!, f.test.id!, [
          f.material.id!,
        ], revision: 1);
        final concurrent = await Future.wait([
          request(
            'notebook',
            'configureAssessment',
            updated,
            token: f.teacher.$2,
          ),
          request(
            'notebook',
            'configureAssessment',
            updated,
            token: f.teacher.$2,
          ),
        ]);
        expect(concurrent.where((result) => result.$1 == 200), hasLength(1));
        expect(
          await NotebookSourceRecord.db.count(
            session,
            where: (t) => t.courseId.equals(f.course.id),
          ),
          1,
        );
        expect(
          await NotebookJobRecord.db.count(
            session,
            where: (t) => t.sourceId.equals(sources.single.id),
          ),
          1,
        );
        final concurrentOpens = await Future.wait([
          for (var i = 0; i < 2; i++)
            request('notebook', 'openNotebook', {
              'courseId': f.course.id.toString(),
              'assessmentActivityId': f.test.id.toString(),
            }, token: f.student.$2),
        ]);
        expect(concurrentOpens.map((r) => r.$1), [200, 200]);
        expect(
          concurrentOpens.map((r) => r.$2['notebookId']).toSet(),
          hasLength(1),
        );
        final overview = concurrentOpens.first;
        expect(overview.$1, 200);
        expect(overview.$2['sources'], hasLength(1));
        expect(overview.$2['sources'][0]['selected'], true);
        expect(overview.$2['sources'][0]['teacherDefault'], true);
      },
    );

    test(
      'private source selection and jobs stay isolated and revoked materials disappear',
      () async {
        final f = await fixture();
        expect(
          (await request(
            'notebook',
            'configureAssessment',
            configBody(f.course.id!, f.test.id!, [f.material.id!]),
            token: f.teacher.$2,
          )).$1,
          200,
        );
        final openBody = {
          'courseId': f.course.id.toString(),
          'assessmentActivityId': f.test.id.toString(),
        };
        final overview = await request(
          'notebook',
          'openNotebook',
          openBody,
          token: f.student.$2,
        );
        final notebookId = UuidValue.withValidation(
          overview.$2['notebookId'] as String,
        );
        final other = await account();
        await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: f.course.id!,
            authUserId: other.$1,
            role: 'student',
          ),
        );
        final private = await NotebookSourceRecord.db.insertRow(
          session,
          NotebookSourceRecord(
            courseId: f.course.id!,
            notebookId: notebookId,
            ownerUserId: f.student.$1,
            fileName: 'Private notes',
            format: 'txt',
            storageId: 'private',
            storagePath: 'private-notes',
            status: 'ready',
            currentVersion: 1,
          ),
        );
        final otherOverview = await request(
          'notebook',
          'openNotebook',
          openBody,
          token: other.$2,
        );
        expect(
          otherOverview.$2['sources'].any(
            (dynamic row) => row['id'] == private.id.toString(),
          ),
          false,
        );
        expect(
          (await request('notebook', 'setSelectedSources', {
            'notebookId': notebookId.toString(),
            'sourceIds': [private.id.toString()],
          }, token: other.$2)).$1,
          isNot(200),
        );
        expect(
          (await request('notebook', 'setSelectedSources', {
            'notebookId': notebookId.toString(),
            'sourceIds': [private.id.toString()],
          }, token: f.student.$2)).$1,
          200,
        );
        final asked = await request('notebook', 'ask', {
          'input': {
            '__className__': 'NotebookChatInput',
            'notebookId': notebookId.toString(),
            'question': 'What do my notes say?',
            'requestKey': 'private-question',
          },
        }, token: f.student.$2);
        expect(asked.$1, 200);
        final queued = (await NotebookJobRecord.db.findById(
          session,
          UuidValue.withValidation(asked.$2['id'] as String),
        ))!;
        final payload =
            jsonDecode(queued.privatePayload!) as Map<String, dynamic>;
        payload['budget'] = {'month': '2026-10-01', 'micros': 100};
        await NotebookJobRecord.db.updateRow(
          session,
          queued.copyWith(privatePayload: jsonEncode(payload)),
        );
        await request('notebook', 'setSelectedSources', {
          'notebookId': notebookId.toString(),
          'sourceIds': <String>[],
        }, token: f.student.$2);
        final retried = await request('notebook', 'ask', {
          'input': {
            '__className__': 'NotebookChatInput',
            'notebookId': notebookId.toString(),
            'question': 'What do my notes say?',
            'requestKey': 'private-question',
          },
        }, token: f.student.$2);
        expect(retried.$1, 200);
        expect(retried.$2['id'], asked.$2['id']);
        for (final token in [other.$2, f.teacher.$2]) {
          expect(
            (await request('notebook', 'getJobStatus', {
              'notebookId': notebookId.toString(),
              'jobId': asked.$2['id'],
            }, token: token)).$1,
            isNot(200),
          );
        }
        await CourseActivityRecord.db.updateRow(
          session,
          f.material.copyWith(published: false),
        );
        final after = await request(
          'notebook',
          'openNotebook',
          openBody,
          token: f.student.$2,
        );
        expect(after.$2['sources'], hasLength(1));
        expect(after.$2['sources'][0]['id'], private.id.toString());
        await CourseMembership.db.updateRow(
          session,
          f.membership.copyWith(active: false),
        );
        expect(
          (await request(
            'notebook',
            'openNotebook',
            openBody,
            token: f.student.$2,
          )).$1,
          isNot(200),
        );
      },
    );

    test('invalid material registration rolls back config and queue', () async {
      final f = await fixture();
      final unsafe = await CourseActivityRecord.db.insertRow(
        session,
        f.material.copyWith(id: null, storageId: 'public'),
      );
      expect(
        (await request(
          'notebook',
          'configureAssessment',
          configBody(f.course.id!, f.test.id!, [f.material.id!, unsafe.id!]),
          token: f.teacher.$2,
        )).$1,
        isNot(200),
      );
      expect(
        await NotebookAssessmentConfigRecord.db.count(
          session,
          where: (t) => t.courseId.equals(f.course.id),
        ),
        0,
      );
      expect(
        await NotebookSourceRecord.db.count(
          session,
          where: (t) => t.courseId.equals(f.course.id),
        ),
        0,
      );
    });
  }, rollbackDatabase: RollbackDatabase.disabled);
}
