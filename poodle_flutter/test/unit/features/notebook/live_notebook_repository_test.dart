import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:poodle_flutter/data/services/notebook_file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_client/poodle_client.dart' as api;
import 'package:poodle_flutter/data/repositories/notebook_repository.dart';
import 'package:poodle_flutter/data/repositories/live_notebook_repository.dart';
import 'package:poodle_flutter/data/repositories/account_notebook_cache.dart';
import 'package:poodle_flutter/data/services/serverpod_auth_gateway.dart';
import 'package:poodle_flutter/data/services/session_credential_store.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class _Memory implements ClientAuthSuccessStorage {
  @override
  Future<AuthSuccess?> get() async => null;
  @override
  Future<void> set(AuthSuccess? data) async {}
}

class _Picker extends NotebookFilePicker {
  final picked = Completer<NotebookPickedFile?>();
  @override
  Future<NotebookPickedFile?> pick(List<String> formats) => picked.future;
}

void main() {
  const id = '019a0acf-0000-7000-8000-000000000001';
  late HttpServer server;
  late ServerpodAuthGateway gateway;
  late ServerpodNotebookRepository repository;
  late Directory cacheRoot;
  final received = <String, Map<String, dynamic>>{};
  final uuid = api.UuidValue.withValidation(id);
  Completer<void>? hold;
  Completer<void>? arrived;
  String? failureCode;
  setUp(() async {
    received.clear();
    hold = null;
    arrived = null;
    failureCode = null;
    cacheRoot = await Directory.systemTemp.createTemp('poodle-notebook-live-');
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      received[request.uri.path] =
          jsonDecode(await utf8.decoder.bind(request).join())
              as Map<String, dynamic>;
      if (arrived != null && !arrived!.isCompleted) arrived!.complete();
      await hold?.future;
      final value = switch (request.uri.path) {
        '/notebook/openNotebook' => api.NotebookOverview(
          notebookId: uuid,
          courseId: uuid,
          assessmentActivityId: uuid,
          configured: true,
          configRevision: 1,
          allowedFormats: ['txt'],
          sources: [
            api.NotebookSourceInfo(
              id: uuid,
              title: 'Notes',
              format: 'txt',
              status: 'ready',
              selected: true,
              teacherDefault: true,
              currentVersion: 1,
            ),
          ],
        ).toJson(),
        '/notebook/getTurns' => [
          api.NotebookTurnView(
            id: uuid,
            role: 'assistant',
            content: 'Answer',
            citations: [
              api.NotebookCitation(
                chunkId: uuid,
                sourceId: uuid,
                sourceVersionId: uuid,
                sourceVersion: 1,
                title: 'Notes',
                locationLabel: 'block-1',
              ),
            ],
            insufficientEvidence: false,
            stale: false,
            createdAt: DateTime.utc(2026),
          ).toJson(),
        ],
        '/notebook/getCitationPassage' => 'Stored evidence',
        '/notebook/getStudioItems' => [
          api.NotebookStudioItem(
            id: uuid,
            kind: 'flashcards',
            language: 'en',
            title: 'Cards',
            contentJson: '{"cards":[]}',
            citations: [],
            stale: false,
            createdAt: DateTime.utc(2026),
          ).toJson(),
        ],
        '/notebook/getStudioItem' => api.NotebookStudioItem(
          id: uuid,
          kind: 'flashcards',
          language: 'en',
          title: 'Cards',
          contentJson: '{"cards":[]}',
          citations: [],
          stale: false,
          createdAt: DateTime.utc(2026),
        ).toJson(),
        '/notebook/getAssessmentSetup' => api.NotebookAssessmentSetup(
          configuration: api.NotebookAssessmentConfigView(
            courseId: uuid,
            assessmentActivityId: uuid,
            revision: 3,
            defaultMaterialActivityIds: [uuid],
            allowedFormats: ['txt'],
          ),
          materials: [
            api.NotebookMaterialOption(
              id: uuid,
              title: 'Course notes',
              format: 'txt',
            ),
          ],
        ).toJson(),
        '/notebook/configureAssessment' => api.NotebookAssessmentConfigView(
          courseId: uuid,
          assessmentActivityId: uuid,
          revision: 4,
          defaultMaterialActivityIds: [uuid],
          allowedFormats: ['txt', 'pdf'],
        ).toJson(),

        '/notebook/beginUpload' => api.NotebookUploadTicket(
          sourceId: uuid,
          jobId: uuid,
          uploadDescription: jsonEncode({
            'type': 'binary',
            'url':
                'http://localhost:${server.port}/serverpod_cloud_storage?key=secret',
          }),
        ).toJson(),
        '/notebook/finishUpload' ||
        '/notebook/ask' ||
        '/notebook/getJobStatus' => api.NotebookJobStatus(
          id: uuid,
          status: failureCode == null ? 'complete' : 'failed',
          failureCode: failureCode,
          createdAt: DateTime.utc(2026),
        ).toJson(),
        _ => null,
      };
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(value));
      await request.response.close();
    });
    gateway = ServerpodAuthGateway(
      'http://127.0.0.1:${server.port}/',
      SessionCredentialStore(_Memory()),
      monitorConnectivity: false,
    );
    repository = ServerpodNotebookRepository(
      gateway,
      cache: AccountNotebookCache(
        root: cacheRoot,
        namespace: gateway.serverIdentity,
      ),
    )..bindAccount('alice');
  });
  tearDown(() async {
    repository.dispose();
    gateway.dispose();
    await server.close(force: true);
    await cacheRoot.delete(recursive: true);
  });
  test(
    'saved notebook answers and cited passages open after network loss',
    () async {
      await repository.open(id, id);
      await repository.turns(id);
      await repository.citationPassage(id, id, id);
      await server.close(force: true);
      expect((await repository.open(id, id)).sources.single.title, 'Notes');
      expect((await repository.turns(id)).single.content, 'Answer');
      expect(await repository.citationPassage(id, id, id), 'Stored evidence');
      expect(repository.isStale, isTrue);
    },
  );
  test('saved study outputs remain readable after network loss', () async {
    expect((await repository.studioItems(id)).single.title, 'Cards');
    expect((await repository.studioItem(id, id)).contentJson, '{"cards":[]}');
    await server.close(force: true);
    expect((await repository.studioItems(id)).single.title, 'Cards');
    expect((await repository.studioItem(id, id)).contentJson, '{"cards":[]}');
    expect(repository.isStale, isTrue);
  });
  test(
    'server-confirmed source changes invalidate saved notebook reads',
    () async {
      await repository.open(id, id);
      await repository.turns(id);
      await repository.select(id, []);
      await server.close(force: true);
      await expectLater(
        repository.open(id, id),
        throwsA(NotebookFailure.network),
      );
    },
  );
  test(
    'generated client contracts map sources, turns, citations and durable job IDs',
    () async {
      final notebook = await repository.open(id, id);
      expect(notebook.sources.single.title, 'Notes');
      expect(() => notebook.sources.clear(), throwsUnsupportedError);
      final turns = await repository.turns(id);
      expect(turns.single.citations.single.location, 'block-1');
      expect(turns.single.citations.single.chunkId, id);
      expect(await repository.citationPassage(id, id, id), 'Stored evidence');
      expect(received['/notebook/getCitationPassage'], {
        'notebookId': id,
        'turnId': id,
        'chunkId': id,
      });
      await repository.select(id, [id]);
      expect(received['/notebook/setSelectedSources']!['sourceIds'], [id]);
      expect((await repository.ask(id, 'Question', 'stable-key')).id, id);
      expect(received['/notebook/ask']!['input']['requestKey'], 'stable-key');
      expect((await repository.job(id, id)).status, 'complete');
    },
  );
  test(
    'teacher settings map revision and send exact selected material and format policy',
    () async {
      final setup = await repository.assessmentSetup(id, id);
      expect(setup.revision, 3);
      expect(setup.materials.single.title, 'Course notes');
      expect(setup.materialIds, [id]);
      await repository.configure(id, id, setup.revision, [id], ['txt', 'pdf']);
      expect(received['/notebook/configureAssessment']!['input'], {
        '__className__': 'NotebookAssessmentConfigInput',
        'courseId': id,
        'assessmentActivityId': id,
        'expectedRevision': 3,
        'defaultMaterialActivityIds': [id],
        'allowedFormats': ['txt', 'pdf'],
      });
    },
  );
  test(
    'durable failures retain user-facing budget and source-change categories',
    () async {
      failureCode = 'monthly_budget_exceeded';
      await expectLater(
        repository.job(id, id),
        throwsA(NotebookFailure.budget),
      );
      failureCode = 'sources_changed';
      await expectLater(
        repository.job(id, id),
        throwsA(NotebookFailure.changed),
      );
      failureCode = 'invalid_citations';
      await expectLater(
        repository.job(id, id),
        throwsA(NotebookFailure.processing),
      );
    },
  );
  test('retired account cannot receive a late notebook response', () async {
    hold = Completer<void>();
    arrived = Completer<void>();
    final response = repository.open(id, id);
    final assertion = expectLater(response, throwsA(NotebookFailure.cancelled));
    await arrived!.future;
    repository.bindAccount('bob');
    hold!.complete();
    await assertion;
  });
  test(
    'private upload sends bytes only after an owner-bound ticket and finalizes',
    () async {
      final picker = _Picker();
      repository.dispose();
      repository = ServerpodNotebookRepository(
        gateway,
        filePicker: picker,
        sendFile: (ticket, bytes) async {
          expect(
            (jsonDecode(ticket) as Map<String, dynamic>)['url'],
            'http://127.0.0.1:${server.port}/serverpod_cloud_storage?key=secret',
          );
          expect(bytes.lengthInBytes, 5);
          expect(received.containsKey('/notebook/beginUpload'), isTrue);
          return true;
        },
      )..bindAccount('alice');
      picker.picked.complete(
        NotebookPickedFile(
          'notes.txt',
          Uint8List.fromList(utf8.encode('hello')),
        ),
      );
      expect(
        (await repository.upload(id, [
          'txt',
        ], 'upload-request-key-1234'))!.status,
        'complete',
      );
      expect(
        received['/notebook/beginUpload']!['input']['checksum'],
        hasLength(64),
      );
      expect(received['/notebook/finishUpload']!['jobId'], id);
    },
  );
  test('failed transfer removes the unfinished private source', () async {
    final picker = _Picker();
    repository.dispose();
    repository = ServerpodNotebookRepository(
      gateway,
      filePicker: picker,
      sendFile: (_, _) async => false,
    )..bindAccount('alice');
    picker.picked.complete(
      NotebookPickedFile('notes.txt', Uint8List.fromList(utf8.encode('hello'))),
    );
    await expectLater(
      repository.upload(id, ['txt'], 'upload-request-key-1234'),
      throwsA(NotebookFailure.network),
    );
    expect(received.containsKey('/notebook/removeUpload'), isTrue);
    expect(received.containsKey('/notebook/finishUpload'), isFalse);
  });
  test(
    'account change while picking a private file sends no request or bytes',
    () async {
      final picker = _Picker();
      repository.dispose();
      repository = ServerpodNotebookRepository(
        gateway,
        filePicker: picker,
        sendFile: (_, _) async => fail('must not upload'),
      )..bindAccount('alice');
      final upload = repository.upload(id, ['txt'], 'upload-request-key-1234');
      final assertion = expectLater(upload, throwsA(NotebookFailure.cancelled));
      repository.bindAccount('bob');
      picker.picked.complete(
        NotebookPickedFile('private.txt', Uint8List.fromList([1])),
      );
      await assertion;
      expect(received, isEmpty);
    },
  );
  test('signed-out access makes no HTTP request', () async {
    repository.bindAccount(null);
    await expectLater(
      repository.open(id, id),
      throwsA(NotebookFailure.cancelled),
    );
    expect(received, isEmpty);
  });
}
