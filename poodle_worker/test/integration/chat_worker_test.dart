import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

import 'package:poodle_server/notebook_worker.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:poodle_worker/poodle_worker.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../../../poodle_server/test/integration/test_tools/serverpod_test_tools.dart';

class ChatProvider implements NotebookAiProvider {
  int embeds = 0;
  int generations = 0;
  bool forged = false;
  bool insufficient = false;
  bool unavailable = false;
  Future<void> Function()? duringGeneration;
  List<NotebookContextChunk> evidence = [];
  @override
  Future<NotebookEmbeddingBatch> embed(List<String> texts) async {
    embeds++;
    if (unavailable) throw const NotebookProviderException('rate_limited');
    return NotebookEmbeddingBatch(
      vectors: [List.filled(1536, 0.1)],
      inputTokens: 4,
    );
  }

  @override
  Future<NotebookGenerationResult> generate({
    required String instructions,
    required String question,
    required List<NotebookContextChunk> context,
  }) async {
    generations++;
    evidence = context;
    await duringGeneration?.call();
    return NotebookGenerationResult(
      json: {
        'answer': 'Grounded answer',
        'citationIds': [forged ? const Uuid().v4() : context.first.id],
        'insufficientEvidence': insufficient,
      },
      inputTokens: 40,
      outputTokens: 8,
    );
  }
}

class StudioProvider extends OpenAiNotebookProvider {
  StudioProvider() : super(apiKey: 'unused', generationModel: 'fixture');
  bool forged = false, insufficient = false, unavailable = false;
  String kind = 'flashcards';
  final languages = <String>[];
  Future<void> Function()? duringGeneration;

  @override
  Future<NotebookGenerationResult> generateStructured({
    required String instructions,
    required String question,
    required List<NotebookContextChunk> context,
    Map<String, Object?>? schema,
    int maxOutputTokens = 1200,
  }) async {
    final uk = question.contains('Ukrainian');
    languages.add(uk ? 'uk' : 'en');
    await duringGeneration?.call();
    if (unavailable) throw const NotebookProviderException('rate_limited');
    final ids = [forged ? const Uuid().v4() : context.single.id];
    return NotebookGenerationResult(
      json: {
        'title': uk ? 'Навчальні матеріали' : 'Study materials',
        'insufficientEvidence': insufficient,
        if (kind == 'quiz')
          'items': [
            for (var i = 0; i < 8; i++)
              {
                'type': i < 6 ? 'multipleChoice' : 'shortAnswer',
                'prompt': 'Question $i',
                'options': i < 6
                    ? ['Evidence', 'Guess', 'Unrelated', 'Unclear']
                    : null,
                'correctIndex': i < 6 ? 0 : null,
                'answer': 'Evidence',
                'explanation': 'Retrieval finds relevant evidence.',
                'citationIds': ids,
              },
          ]
        else if (kind == 'audio')
          'sections': [
            for (var i = 0; i < 3; i++)
              {
                'text': uk
                    ? 'Розділ $i. Джерело містить докази.'
                    : 'Section $i. Retrieval finds evidence.',
                'citationIds': ids,
              },
          ]
        else
          'cards': [
            for (var i = 0; i < 12; i++)
              {
                'front': 'Запитання $i',
                'back': 'Пошук знаходить відповідні докази.',
                'citationIds': ids,
              },
          ],
      },
      inputTokens: 40,
      outputTokens: 8,
    );
  }
}

/// Deterministic PCM fixture. The integration test runs the real MP3 encoder.
Uint8List studioWav() {
  const sampleRate = 8000;
  const bytes = sampleRate * 2 * 43;
  final data = ByteData(bytes + 44);
  void tag(int offset, String value) {
    for (final (i, unit) in value.codeUnits.indexed) {
      data.setUint8(offset + i, unit);
    }
  }

  tag(0, 'RIFF');
  tag(8, 'WAVE');
  tag(12, 'fmt ');
  tag(36, 'data');
  data
    ..setUint32(4, bytes + 36, Endian.little)
    ..setUint32(16, 16, Endian.little)
    ..setUint16(20, 1, Endian.little)
    ..setUint16(22, 1, Endian.little)
    ..setUint32(24, sampleRate, Endian.little)
    ..setUint32(28, sampleRate * 2, Endian.little)
    ..setUint16(32, 2, Endian.little)
    ..setUint16(34, 16, Endian.little)
    ..setUint32(40, bytes, Endian.little);
  return data.buffer.asUint8List();
}

void main() {
  withServerpod(
    'Private notebook chat execution',
    (builder, endpoints) {
      late Session session;
      late ChatProvider provider;
      late NotebookChatWorker worker;
      setUp(() async {
        session = builder.build();
        addTearDown(session.close);
        provider = ChatProvider();
        worker = NotebookChatWorker(
          provider: provider,
          embeddingSpace: 'test-chat-v1',
          embeddingMicrosPerMillionTokens: 1000000,
          generationInputMicrosPerMillionTokens: 1000000,
          generationOutputMicrosPerMillionTokens: 1000000,
        );
      });
      Future<
        ({
          NotebookJobRecord job,
          NotebookRecord notebook,
          NotebookSourceRecord source,
          CourseActivityRecord material,
          CourseMembership membership,
          NotebookAssessmentConfigRecord config,
        })
      >
      fixture({
        String space = 'test-chat-v1',
        String? studioKind,
        String language = 'en',
      }) async {
        final user = await AuthUser.db.insertRow(
          session,
          AuthUser(scopeNames: <String>{}, blocked: false),
        );
        await AccountAccess.db.insertRow(
          session,
          AccountAccess(authUserId: user.id!),
        );
        final course = await CourseRecord.db.insertRow(
          session,
          CourseRecord(title: 'Test data'),
        );
        final membership = await CourseMembership.db.insertRow(
          session,
          CourseMembership(
            courseId: course.id!,
            authUserId: user.id!,
            role: 'student',
          ),
        );
        final section = await CourseSectionRecord.db.insertRow(
          session,
          CourseSectionRecord(
            courseId: course.id!,
            title: 'Test data',
            sortOrder: 0,
            published: true,
          ),
        );
        final test = await CourseActivityRecord.db.insertRow(
          session,
          CourseActivityRecord(
            sectionId: section.id!,
            title: 'Test data',
            kind: 'test',
            sortOrder: 1,
            published: true,
            assessment: CourseAssessmentInfo(instructions: 'Prepare'),
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
            storageId: 'private',
            storagePath: 'chat/${course.id}',
            file: CourseFileInfo(
              fileName: 'notes.txt',
              mimeType: 'text/plain',
              sizeBytes: 42,
              checksum: 'v1',
            ),
          ),
        );
        final config = await NotebookAssessmentConfigRecord.db.insertRow(
          session,
          NotebookAssessmentConfigRecord(
            courseId: course.id!,
            assessmentActivityId: test.id!,
            teacherUserId: user.id!,
            allowedFormats: ['txt'],
          ),
        );
        await NotebookAssessmentMaterialRecord.db.insertRow(
          session,
          NotebookAssessmentMaterialRecord(
            configId: config.id!,
            activityId: material.id!,
            sortOrder: 0,
          ),
        );
        final notebook = await NotebookRecord.db.insertRow(
          session,
          NotebookRecord(
            courseId: course.id!,
            assessmentActivityId: test.id!,
            ownerUserId: user.id!,
          ),
        );
        final source = await NotebookSourceRecord.db.insertRow(
          session,
          NotebookSourceRecord(
            courseId: course.id!,
            activityId: material.id!,
            fileName: 'notes.txt',
            format: 'txt',
            storageId: 'private',
            storagePath: material.storagePath!,
            status: 'ready',
            currentVersion: 1,
          ),
        );
        final version = await NotebookSourceVersionRecord.db.insertRow(
          session,
          NotebookSourceVersionRecord(
            sourceId: source.id!,
            version: 1,
            checksum: 'v1',
            title: 'Study notes',
            extractedText: 'Retrieval finds relevant evidence.',
            status: 'ready',
            embeddingSpace: space,
          ),
        );
        await NotebookChunkRecord.db.insertRow(
          session,
          NotebookChunkRecord(
            sourceId: source.id!,
            sourceVersionId: version.id!,
            blockId: 'block-1',
            locationLabel: 'Paragraph 1',
            content: 'Retrieval finds relevant evidence.',
            embedding: Vector(List.filled(1536, 0.1)),
          ),
        );
        final job = await NotebookJobRecord.db.insertRow(
          session,
          NotebookJobRecord(
            ownerUserId: user.id!,
            notebookId: notebook.id!,
            jobType: studioKind == null ? 'chat' : 'studio',
            requestKey: const Uuid().v4(),
            privatePayload: jsonEncode({
              'question': 'How does retrieval work?',
              'sourceIds': [source.id.toString()],
              'sourceVersions': {source.id.toString(): 1},
              'configRevision': config.revision,
              'kind': ?studioKind,
              if (studioKind != null) 'language': language,
            }),
          ),
        );
        return (
          job: job,
          notebook: notebook,
          source: source,
          material: material,
          membership: membership,
          config: config,
        );
      }

      Future<NotebookJobRecord> stored(NotebookJobRecord job) async =>
          (await NotebookJobRecord.db.findById(session, job.id!))!;
      Future<List<NotebookTurnRecord>> turns(NotebookRecord notebook) =>
          NotebookTurnRecord.db.find(
            session,
            where: (t) => t.notebookId.equals(notebook.id),
            orderBy: (t) => t.turnIndex,
          );

      NotebookStudioWorker studio(
        StudioProvider provider, {
        NotebookNarration? narrate,
      }) {
        addTearDown(provider.close);
        return NotebookStudioWorker(
          provider: provider,
          embeddingSpace: 'test-chat-v1',
          embeddingMicrosPerMillionTokens: 1000000,
          generationInputMicrosPerMillionTokens: 1000000,
          generationOutputMicrosPerMillionTokens: 1000000,
          audioReservationMicros: 500000,
          narrate:
              narrate ??
              (_, _) async => throw StateError('Unexpected speech call'),
        );
      }

      test(
        'Studio publishes a mixed quiz and Ukrainian flashcards once and settles budget',
        () async {
          final quiz = await fixture(studioKind: 'quiz');
          final cards = await fixture(studioKind: 'flashcards', language: 'uk');
          final provider = StudioProvider()..kind = 'quiz';
          final worker = studio(provider);
          expect(await worker.runOnce(session), isTrue);
          provider.kind = 'flashcards';
          expect(await worker.runOnce(session), isTrue);
          expect(await worker.runOnce(session), isFalse);
          expect(provider.languages, ['en', 'uk']);
          for (final job in [quiz.job, cards.job]) {
            expect((await stored(job)).status, 'complete');
            final artifact = (await NotebookArtifactRecord.db.find(
              session,
              where: (t) => t.jobId.equals(job.id),
            )).single;
            final body = jsonDecode(artifact.contentJson) as Map;
            final items = (body['items'] ?? body['cards']) as List;
            expect(items, hasLength(artifact.kind == 'quiz' ? 8 : 12));
            if (artifact.kind == 'quiz') {
              expect(
                items.where((row) => row['type'] == 'shortAnswer'),
                hasLength(2),
              );
            }
            expect(
              await turns(
                job.id == quiz.job.id ? quiz.notebook : cards.notebook,
              ),
              isEmpty,
            );
          }
          final usage = await NotebookUsageMonthRecord.db.findFirstRow(session);
          expect(usage!.reservedMicros, 0);
          expect(usage.spentMicros, 96);
        },
      );

      test(
        'Studio refuses invented citations and evidence changed during generation',
        () async {
          final forged = await fixture(studioKind: 'flashcards');
          final changed = await fixture(studioKind: 'flashcards');
          final empty = await fixture(studioKind: 'flashcards');
          final provider = StudioProvider()..forged = true;
          final worker = studio(provider);
          await worker.runOnce(session);
          expect((await stored(forged.job)).failureCode, 'invalid_response');
          provider.forged = false;
          provider.duringGeneration = () async {
            await NotebookSourceRecord.db.updateRow(
              session,
              changed.source.copyWith(currentVersion: 2),
            );
          };
          await worker.runOnce(session);
          expect((await stored(changed.job)).failureCode, 'sources_changed');
          provider.duringGeneration = null;
          provider.insufficient = true;
          await worker.runOnce(session);
          expect(
            (await stored(empty.job)).failureCode,
            'insufficient_evidence',
          );
          expect(
            await NotebookArtifactRecord.db.find(
              session,
              where: (t) => t.jobId.inSet({
                forged.job.id!,
                changed.job.id!,
                empty.job.id!,
              }),
            ),
            isEmpty,
          );
          expect(
            (await NotebookUsageMonthRecord.db.findFirstRow(
              session,
            ))!.reservedMicros,
            0,
          );
        },
      );

      test(
        'Studio retries provider failures and reclaims an abandoned audio lease',
        () async {
          final f = await fixture(studioKind: 'audio', language: 'uk');
          final provider = StudioProvider()
            ..kind = 'audio'
            ..unavailable = true;
          var narration = 0;
          final worker = studio(
            provider,
            narrate: (script, language) async {
              narration++;
              expect(language, 'uk');
              return (wav: studioWav(), transcript: script);
            },
          );
          await worker.runOnce(session);
          var job = await stored(f.job);
          expect(job.status, 'queued');
          expect(job.failureCode, 'rate_limited');
          final lease = const Uuid().v4();
          final abandoned = 'notebook-studio/${job.id}/$lease.mp3';
          await session.storage.storeFile(
            storageId: 'private',
            path: abandoned,
            byteData: ByteData(1),
          );
          await NotebookJobRecord.db.updateRow(
            session,
            job.copyWith(
              status: 'processing',
              leaseToken: lease,
              attempts: 2,
              leaseExpiresAt: DateTime.now().toUtc().subtract(
                const Duration(minutes: 1),
              ),
            ),
          );
          provider.unavailable = false;
          await worker.runOnce(session);
          job = await stored(f.job);
          expect(job.status, 'complete', reason: job.failureCode);
          expect(narration, 3);
          expect(
            await session.storage.fileExists(
              storageId: 'private',
              path: abandoned,
            ),
            isFalse,
          );
          final artifact = (await NotebookArtifactRecord.db.find(
            session,
            where: (t) => t.jobId.equals(job.id),
          )).single;
          expect(artifact.language, 'uk');
          expect(artifact.audioStoragePath, isNotNull);
          expect(
            await session.storage.fileExists(
              storageId: 'private',
              path: artifact.audioStoragePath!,
            ),
            isTrue,
          );
          expect(
            (jsonDecode(artifact.contentJson) as Map)['transcript'],
            contains('Розділ 2'),
          );
        },
      );

      test(
        'hybrid retrieval persists two private turns with server-owned citations and settles budget',
        () async {
          final f = await fixture();
          // A different course's equally similar content must never reach the provider.
          final other = await fixture();
          await NotebookJobRecord.db.updateRow(
            session,
            other.job.copyWith(status: 'failed'),
          );
          final priorSpent =
              (await NotebookUsageMonthRecord.db.findFirstRow(
                session,
              ))?.spentMicros ??
              0;
          await worker.runOnce(session);
          expect((await stored(f.job)).status, 'complete');
          final saved = await turns(f.notebook);
          expect(saved.map((t) => t.role), ['user', 'assistant']);
          expect(saved.last.content, 'Grounded answer');
          final citation =
              (jsonDecode(saved.last.citationsJson) as List).single as Map;
          expect(citation['sourceId'], f.source.id.toString());
          expect(citation['title'], 'Study notes');
          expect(provider.evidence, hasLength(1));
          final usage = await NotebookUsageMonthRecord.db.findFirstRow(session);
          expect(usage!.reservedMicros, 0);
          expect(usage.spentMicros - priorSpent, 52);
          expect(await worker.runOnce(session), false);
          expect(await turns(f.notebook), hasLength(2));
        },
      );
      test(
        'forged citation fails permanently without saving an answer',
        () async {
          final f = await fixture();
          provider.forged = true;
          await worker.runOnce(session);
          expect((await stored(f.job)).failureCode, 'invalid_citations');
          expect((await stored(f.job)).status, 'failed');
          expect(await turns(f.notebook), isEmpty);
        },
      );
      test(
        'insufficient evidence replaces model text with server refusal',
        () async {
          final f = await fixture();
          provider.insufficient = true;
          await worker.runOnce(session);
          final saved = await turns(f.notebook);
          expect(saved.last.insufficientEvidence, true);
          expect(saved.last.content, contains('not contain enough'));
          expect(saved.last.citationsJson, '[]');
        },
      );
      test(
        'embedding spaces cannot be mixed even with identical dimensions',
        () async {
          final f = await fixture(space: 'different-provider');
          await worker.runOnce(session);
          expect((await stored(f.job)).failureCode, 'sources_changed');
          expect(provider.embeds, 0);
        },
      );
      test('revoked membership blocks provider access', () async {
        final f = await fixture();
        await CourseMembership.db.updateRow(
          session,
          f.membership.copyWith(active: false),
        );
        await worker.runOnce(session);
        expect((await stored(f.job)).failureCode, 'unavailable');
        expect(provider.embeds, 0);
      });
      test(
        'withdrawal during generation prevents saving either turn',
        () async {
          final f = await fixture();
          provider.duringGeneration = () async {
            await CourseActivityRecord.db.updateRow(
              session,
              f.material.copyWith(published: false),
            );
          };
          await worker.runOnce(session);
          expect((await stored(f.job)).failureCode, 'sources_changed');
          expect(await turns(f.notebook), isEmpty);
        },
      );
      test(
        'deselection before processing invalidates the queued snapshot',
        () async {
          final f = await fixture();
          await NotebookSourceSelectionRecord.db.insertRow(
            session,
            NotebookSourceSelectionRecord(
              notebookId: f.notebook.id!,
              sourceId: f.source.id!,
              selected: false,
              selectedVersion: 1,
            ),
          );
          await worker.runOnce(session);
          expect((await stored(f.job)).failureCode, 'sources_changed');
          expect(provider.embeds, 0);
        },
      );
      test(
        'provider throttling retries with durable backoff and releases reservation',
        () async {
          final f = await fixture();
          provider.unavailable = true;
          await worker.runOnce(session);
          final job = await stored(f.job);
          expect(job.status, 'queued');
          expect(job.failureCode, 'rate_limited');
          expect(job.leaseExpiresAt, isNotNull);
          expect(await worker.claim(session), isNull);
          // Prevent this intentionally delayed job from affecting later tests.
          await NotebookJobRecord.db.updateRow(
            session,
            job.copyWith(status: 'failed'),
          );
          expect(
            (await NotebookUsageMonthRecord.db.findFirstRow(
              session,
            ))!.reservedMicros,
            0,
          );
        },
      );
      for (final scenario in ['clean', 'unsafe', 'deleted', 'revoked']) {
        test(
          'private ingestion checks ownership and scanner before embeddings: $scenario',
          () async {
            final f = await fixture();
            final bytes = Uint8List.fromList(
              utf8.encode('Private study notes about retrieval.'),
            );
            final path =
                'notebook-uploads/${f.notebook.ownerUserId}/${f.notebook.id}/${f.source.id}.txt';
            await NotebookSourceRecord.db.updateRow(
              session,
              f.source.copyWith(
                ownerUserId: f.notebook.ownerUserId,
                notebookId: f.notebook.id,
                activityId: null,
                storagePath: path,
                status: 'queued',
                currentVersion: 1,
              ),
            );
            await NotebookJobRecord.db.updateRow(
              session,
              f.job.copyWith(
                jobType: 'ingest',
                sourceId: f.source.id,
                privatePayload: jsonEncode({
                  'checksum': sha256.convert(bytes).toString(),
                  'sizeBytes': bytes.length,
                  'storageId': 'private',
                  'storagePath': path,
                  'format': 'txt',
                }),
              ),
            );
            var scans = 0;
            final ingestion = NotebookIngestionWorker(
              provider: provider,
              embeddingSpace: 'test-chat-v1',
              embeddingMicrosPerMillionTokens: 1000000,
              readObject: (_, _, _) async => ByteData.sublistView(bytes),
              scanUpload: (_) async {
                scans++;
                if (scenario == 'unsafe') {
                  throw const NotebookIngestionException('unsafe_upload');
                }
                if (scenario == 'deleted') {
                  final source = (await NotebookSourceRecord.db.findById(
                    session,
                    f.source.id!,
                  ))!;
                  await NotebookSourceRecord.db.updateRow(
                    session,
                    source.copyWith(status: 'deleted'),
                  );
                }
                if (scenario == 'revoked') {
                  await CourseMembership.db.updateRow(
                    session,
                    f.membership.copyWith(active: false),
                  );
                }
              },
            );
            await ingestion.runOnce(session);
            expect(scans, 1);
            expect(provider.embeds, scenario == 'clean' ? 1 : 0);
            expect(
              (await stored(f.job)).status,
              scenario == 'clean' ? 'complete' : 'failed',
            );
            if (scenario == 'unsafe') {
              expect((await stored(f.job)).failureCode, 'unsafe_upload');
            }
          },
        );
      }
    },
    serverDirectory: Directory('../poodle_server').absolute,
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
