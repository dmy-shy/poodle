import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:poodle_server/notebook_worker.dart';
import 'package:poodle_worker/poodle_worker.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../../../poodle_server/test/integration/test_tools/serverpod_test_tools.dart';

class FakeProvider implements NotebookAiProvider {
  int calls = 0;
  int dimensions = 1536;
  bool fail = false;
  Completer<void>? hold;
  final started = Completer<void>();
  @override
  Future<NotebookEmbeddingBatch> embed(List<String> texts) async {
    calls++;
    if (!started.isCompleted) started.complete();
    await hold?.future;
    if (fail) throw const NotebookProviderException('rate_limited');
    return NotebookEmbeddingBatch(
      vectors: [for (final _ in texts) List<double>.filled(dimensions, 0.1)],
      inputTokens: texts.length * 20,
    );
  }

  @override
  Future<NotebookGenerationResult> generate({
    required String instructions,
    required String question,
    required List<NotebookContextChunk> context,
  }) => throw UnimplementedError();
}

void main() {
  withServerpod(
    'Durable notebook ingestion',
    (builder, endpoints) {
      late Session session;
      late FakeProvider provider;
      late NotebookIngestionWorker worker;
      setUp(() {
        session = builder.build();
        addTearDown(session.close);
        provider = FakeProvider();
        worker = NotebookIngestionWorker(
          provider: provider,
          embeddingMicrosPerMillionTokens: 1000000,
          embeddingSpace: 'test-v1',
        );
      });
      Future<
        ({
          NotebookSourceRecord source,
          NotebookJobRecord job,
          CourseActivityRecord material,
        })
      >
      fixture({
        String? checksum,
        String format = 'md',
        Uint8List? sourceBytes,
        bool missingObject = false,
      }) async {
        final course = await CourseRecord.db.insertRow(
          session,
          CourseRecord(title: 'Worker test data'),
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
        final bytes =
            sourceBytes ?? await File('test/fixtures/study.md').readAsBytes();
        final hash = checksum ?? sha256.convert(bytes).toString();
        final path = 'worker-test/${course.id}/study.$format';
        if (!missingObject) {
          await session.storage.storeFile(
            storageId: 'private',
            path: path,
            byteData: ByteData.sublistView(bytes),
          );
        }
        final material = await CourseActivityRecord.db.insertRow(
          session,
          CourseActivityRecord(
            sectionId: section.id!,
            title: 'Test data',
            kind: 'file',
            sortOrder: 0,
            published: true,
            file: CourseFileInfo(
              fileName: 'study.$format',
              mimeType: switch (format) {
                'md' => 'text/markdown',
                'docx' =>
                  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                _ => 'application/pdf',
              },
              sizeBytes: bytes.length,
              checksum: hash,
            ),
            storageId: 'private',
            storagePath: path,
          ),
        );
        final source = await NotebookSourceRecord.db.insertRow(
          session,
          NotebookSourceRecord(
            courseId: course.id!,
            activityId: material.id!,
            fileName: 'study.$format',
            format: format,
            storageId: 'private',
            storagePath: path,
          ),
        );
        final job = await NotebookJobRecord.db.insertRow(
          session,
          NotebookJobRecord(
            ownerUserId: UuidValue.withValidation(const Uuid().v4()),
            sourceId: source.id!,
            jobType: 'ingest',
            requestKey: 'ingest:${source.id}:$hash',
            privatePayload: jsonEncode({
              'checksum': hash,
              'format': format,
              'storageId': 'private',
              'storagePath': path,
              'sizeBytes': bytes.length,
            }),
          ),
        );
        return (source: source, job: job, material: material);
      }

      Future<NotebookJobRecord> stored(NotebookJobRecord job) async =>
          (await NotebookJobRecord.db.findById(session, job.id!))!;
      Future<void> expire(NotebookJobRecord job, {int? attempts}) async {
        final current = await stored(job);
        await NotebookJobRecord.db.updateRow(
          session,
          current.copyWith(
            leaseExpiresAt: DateTime.utc(2000),
            attempts: attempts ?? current.attempts,
          ),
        );
      }

      test(
        'real private bytes become located pgvector chunks and one immutable version',
        () async {
          final f = await fixture();
          expect(await worker.runOnce(session), true);
          final source = (await NotebookSourceRecord.db.findById(
            session,
            f.source.id!,
          ))!;
          expect(source.status, 'ready');
          expect(source.currentVersion, 1);
          expect((await stored(f.job)).status, 'complete');
          final versions = await NotebookSourceVersionRecord.db.find(
            session,
            where: (t) => t.sourceId.equals(source.id),
          );
          expect(versions, hasLength(1));
          final chunks = await NotebookChunkRecord.db.find(
            session,
            where: (t) => t.sourceVersionId.equals(versions.single.id),
          );
          expect(chunks, hasLength(3));
          expect(chunks.map((c) => c.content).join(' '), contains('Пошук'));
          expect(
            chunks.every((c) => c.locationLabel!.startsWith('block-')),
            true,
          );
          final charged = await NotebookUsageMonthRecord.db.findFirstRow(
            session,
          );
          expect(charged!.reservedMicros, 0);
          expect(charged.spentMicros, 60);
          await worker.process(
            session,
            f.job,
          ); // Duplicate/stale deliveries do nothing.
          expect(provider.calls, 1);
          expect(await worker.runOnce(session), false);
        },
      );

      test(
        'PDF and DOCX private bytes commit immutable versions and located vectors',
        () async {
          worker = NotebookIngestionWorker(
            provider: provider,
            embeddingMicrosPerMillionTokens: 1000000,
            embeddingSpace: 'test-v1',
            extractor: NotebookDocumentExtractor(
              pdfInfoExecutable:
                  Platform.environment['NOTEBOOK_PDFINFO_EXECUTABLE'] ??
                  'pdfinfo',
              pdfTextExecutable:
                  Platform.environment['NOTEBOOK_PDFTOTEXT_EXECUTABLE'] ??
                  'pdftotext',
            ),
          );
          for (final format in ['pdf', 'docx']) {
            final f = await fixture(
              format: format,
              sourceBytes: await File(
                'test/fixtures/study.$format',
              ).readAsBytes(),
            );
            expect(await worker.runOnce(session), true);
            final job = await stored(f.job);
            expect(job.status, 'complete', reason: job.failureCode);
            final chunks = await NotebookChunkRecord.db.find(
              session,
              where: (t) => t.sourceId.equals(f.source.id),
            );
            expect(
              chunks.map((c) => c.content).join(' '),
              contains('Посилання'),
            );
            expect(
              chunks.every(
                (c) => c.locationLabel!.startsWith(
                  format == 'pdf' ? 'page-' : 'paragraph-',
                ),
              ),
              true,
            );
            expect(
              await NotebookSourceVersionRecord.db.count(
                session,
                where: (t) => t.sourceId.equals(f.source.id),
              ),
              1,
            );
          }
          expect(provider.calls, 2);
          expect(
            (await NotebookUsageMonthRecord.db.findFirstRow(
              session,
            ))!.reservedMicros,
            0,
          );
        },
      );

      test(
        'competing workers claim only one job and expired tokens cannot complete',
        () async {
          final f = await fixture();
          await fixture();
          final claims = await Future.wait([
            worker.claim(session),
            worker.claim(session),
          ]);
          expect(claims.whereType<NotebookJobRecord>(), hasLength(1));
          final first = claims.whereType<NotebookJobRecord>().single;
          await expire(first);
          final recovered = (await worker.claim(session))!;
          expect(recovered.id, f.job.id);
          expect(recovered.leaseToken, isNot(first.leaseToken));
          await worker.process(session, first);
          expect(provider.calls, 0);
          await worker.process(session, recovered);
          expect((await stored(f.job)).status, 'complete');
          await worker.runOnce(
            session,
          ); // Drain second job for the following scenario.
        },
      );

      test(
        'bad checksum and mismatched binary signatures never call the provider',
        () async {
          for (final options in [
            (checksum: 'wrong', format: 'md'),
            (checksum: null, format: 'pdf'),
          ]) {
            final f = await fixture(
              checksum: options.checksum,
              format: options.format,
            );
            await worker.runOnce(session);
            expect(
              (await stored(f.job)).failureCode,
              options.format == 'pdf'
                  ? 'signature_mismatch'
                  : 'checksum_mismatch',
            );
            expect((await stored(f.job)).status, 'failed');
            expect(
              await NotebookSourceVersionRecord.db.count(
                session,
                where: (t) => t.sourceId.equals(f.source.id),
              ),
              0,
            );
          }
          expect(provider.calls, 0);
        },
      );

      test(
        'invalid embeddings roll back all chunks and settle the reservation',
        () async {
          final f = await fixture();
          provider.dimensions = 3;
          await worker.runOnce(session);
          expect((await stored(f.job)).failureCode, 'invalid_embeddings');
          expect(
            await NotebookSourceVersionRecord.db.count(
              session,
              where: (t) => t.sourceId.equals(f.source.id),
            ),
            0,
          );
          expect(
            await NotebookChunkRecord.db.count(
              session,
              where: (t) => t.sourceId.equals(f.source.id),
            ),
            0,
          );
          final budget = await NotebookUsageMonthRecord.db.findFirstRow(
            session,
          );
          expect(budget!.reservedMicros, 0);
        },
      );

      test(
        'provider failure retries with backoff and stops after three attempts',
        () async {
          final f = await fixture();
          provider.fail = true;
          await worker.runOnce(session);
          expect((await stored(f.job)).status, 'queued');
          expect(await worker.runOnce(session), false);
          for (var i = 0; i < 2; i++) {
            await expire(f.job);
            await worker.runOnce(session);
          }
          final failed = await stored(f.job);
          expect(failed.status, 'failed');
          expect(failed.attempts, 3);
          expect(provider.calls, 3);
          expect(
            (await NotebookSourceRecord.db.findById(
              session,
              f.source.id!,
            ))!.status,
            'failed',
          );
        },
      );

      test(
        'crash exhaustion clears a processing source and does not retry forever',
        () async {
          final f = await fixture();
          final job = (await worker.claim(session))!;
          await expire(job, attempts: 3);
          expect(await worker.claim(session), null);
          expect((await stored(f.job)).failureCode, 'retry_exhausted');
          expect(
            (await NotebookSourceRecord.db.findById(
              session,
              f.source.id!,
            ))!.status,
            'failed',
          );
        },
      );

      test(
        'publication revoked during embedding prevents version completion',
        () async {
          final f = await fixture();
          provider.hold = Completer<void>();
          final pending = worker.runOnce(session);
          await provider.started.future;
          await CourseActivityRecord.db.updateRow(
            session,
            f.material.copyWith(published: false),
          );
          provider.hold!.complete();
          await pending;
          expect((await stored(f.job)).failureCode, 'source_unavailable');
          expect(
            await NotebookSourceVersionRecord.db.count(
              session,
              where: (t) => t.sourceId.equals(f.source.id),
            ),
            0,
          );
        },
      );

      test(
        'recovery accounts for a crashed reservation and fences its late response',
        () async {
          final f = await fixture();
          provider.hold = Completer<void>();
          final pending = worker.runOnce(session);
          await provider.started.future;
          final before = (await NotebookUsageMonthRecord.db.findFirstRow(
            session,
          ))!;
          expect(before.reservedMicros, greaterThan(0));
          await expire(f.job);
          final recovered = (await worker.claim(session))!;
          final recoveredBudget = (await NotebookUsageMonthRecord.db
              .findFirstRow(session))!;
          expect(recoveredBudget.reservedMicros, 0);
          expect(
            recoveredBudget.spentMicros,
            before.spentMicros + before.reservedMicros,
          );
          provider.hold!.complete();
          await pending;
          expect(
            await NotebookSourceVersionRecord.db.count(
              session,
              where: (t) => t.sourceId.equals(f.source.id),
            ),
            0,
          );
          await worker.process(session, recovered);
          expect((await stored(f.job)).status, 'complete');
          expect(
            await NotebookSourceVersionRecord.db.count(
              session,
              where: (t) => t.sourceId.equals(f.source.id),
            ),
            1,
          );
        },
      );

      test('a malformed job fails without blocking later work', () async {
        final f = await fixture();
        await NotebookJobRecord.db.updateRow(
          session,
          f.job.copyWith(privatePayload: 'not json'),
        );
        await worker.runOnce(session);
        expect((await stored(f.job)).status, 'failed');
        expect((await stored(f.job)).failureCode, 'invalid_job');
        final next = await fixture();
        await worker.runOnce(session);
        expect((await stored(next.job)).status, 'complete');
      });

      test('missing objects retry without calling the provider', () async {
        final f = await fixture(missingObject: true);
        await worker.runOnce(session);
        expect(provider.calls, 0);
        expect((await stored(f.job)).status, 'queued');
        // Exhaust the retry deliberately so this test leaves no queued work.
        await expire(f.job, attempts: 2);
        await worker.runOnce(session);
        expect((await stored(f.job)).status, 'failed');
      });

      test(
        'refresh appends a version and preserves the earlier snapshot',
        () async {
          final f = await fixture();
          await worker.runOnce(session);
          final bytes = Uint8List.fromList(
            utf8.encode('Updated notes / Оновлені нотатки'),
          );
          final hash = sha256.convert(bytes).toString();
          final path = '${f.source.storagePath}.v2';
          await session.storage.storeFile(
            storageId: 'private',
            path: path,
            byteData: ByteData.sublistView(bytes),
          );
          await CourseActivityRecord.db.updateRow(
            session,
            f.material.copyWith(
              storagePath: path,
              file: f.material.file!.copyWith(
                checksum: hash,
                sizeBytes: bytes.length,
              ),
            ),
          );
          final ready = (await NotebookSourceRecord.db.findById(
            session,
            f.source.id!,
          ))!;
          await NotebookSourceRecord.db.updateRow(
            session,
            ready.copyWith(status: 'queued', storagePath: path),
          );
          final next = await NotebookJobRecord.db.insertRow(
            session,
            f.job.copyWith(
              id: null,
              requestKey: 'ingest:${f.source.id}:$hash',
              privatePayload: jsonEncode({
                'checksum': hash,
                'format': 'md',
                'storageId': 'private',
                'storagePath': path,
                'sizeBytes': bytes.length,
              }),
            ),
          );
          await worker.runOnce(session);
          expect((await stored(next)).status, 'complete');
          final versions = await NotebookSourceVersionRecord.db.find(
            session,
            where: (t) => t.sourceId.equals(f.source.id),
            orderBy: (t) => t.version,
          );
          expect(versions.map((v) => v.version), [1, 2]);
          expect(versions.first.extractedText, contains('Retrieval finds'));
          expect(versions.last.extractedText, contains('Оновлені'));
          expect(
            (await NotebookSourceRecord.db.findById(
              session,
              f.source.id!,
            ))!.currentVersion,
            2,
          );
        },
      );

      test(
        'a superseded checksum never overwrites a newer source state',
        () async {
          final f = await fixture();
          final claimed = (await worker.claim(session))!;
          await CourseActivityRecord.db.updateRow(
            session,
            f.material.copyWith(
              file: f.material.file!.copyWith(checksum: 'new-version'),
            ),
          );
          final current = (await NotebookSourceRecord.db.findById(
            session,
            f.source.id!,
          ))!;
          await NotebookSourceRecord.db.updateRow(
            session,
            current.copyWith(status: 'queued'),
          );
          await worker.process(session, claimed);
          expect(provider.calls, 0);
          expect((await stored(f.job)).status, 'failed');
          expect(
            (await NotebookSourceRecord.db.findById(
              session,
              f.source.id!,
            ))!.status,
            'queued',
          );
        },
      );

      test(
        'worker loop finishes its current job and stops opening sessions',
        () async {
          final f = await fixture();
          var opened = 0;
          await worker.run(
            openSession: () async {
              opened++;
              return builder.build();
            },
            stopSignal: provider.started.future,
          );
          expect(opened, 1);
          expect((await stored(f.job)).status, 'complete');
        },
      );

      test(
        'logging sessions cannot read or persist private notebook content',
        () async {
          final logging = builder.copyWith(enableLogging: true).build();
          addTearDown(logging.close);
          await expectLater(worker.claim(logging), throwsStateError);
        },
      );

      test(
        'private, public-storage and cross-course source records are rejected',
        () async {
          for (final scenario in ['private-owner', 'public', 'cross-course']) {
            final f = await fixture();
            final changed = switch (scenario) {
              'private-owner' => f.source.copyWith(
                ownerUserId: f.job.ownerUserId,
              ),
              'public' => f.source.copyWith(storageId: 'public'),
              _ => f.source.copyWith(
                courseId: UuidValue.withValidation(const Uuid().v4()),
              ),
            };
            await NotebookSourceRecord.db.updateRow(session, changed);
            await worker.runOnce(session);
            expect((await stored(f.job)).failureCode, 'source_unavailable');
            expect((await stored(f.job)).status, 'failed');
          }
          expect(provider.calls, 0);
        },
      );

      test('monthly cap denies embeddings before a provider call', () async {
        final f = await fixture();
        final now = DateTime.now().toUtc();
        final month = DateTime.utc(now.year, now.month);
        var budget = await NotebookUsageMonthRecord.db.findFirstRow(
          session,
          where: (t) => t.monthUtc.equals(month),
        );
        budget ??= await NotebookUsageMonthRecord.db.insertRow(
          session,
          NotebookUsageMonthRecord(monthUtc: month),
        );
        await NotebookUsageMonthRecord.db.updateRow(
          session,
          budget.copyWith(capMicros: 1, spentMicros: 1),
        );
        await worker.runOnce(session);
        expect(provider.calls, 0);
        expect((await stored(f.job)).failureCode, 'monthly_budget_exceeded');
      });
    },
    serverDirectory: Directory('../poodle_server').absolute,
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
