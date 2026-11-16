import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:poodle_server/notebook_worker.dart';
import 'package:poodle_server/search_worker.dart';
import 'package:poodle_worker/poodle_worker.dart';
import 'package:poodle_worker/src/jobs/search_index_worker.dart';
import 'package:test/test.dart';

import '../../../poodle_server/test/integration/test_tools/serverpod_test_tools.dart';

class _Embeddings implements EmbeddingProvider {
  bool fail = false;
  @override
  Future<NotebookEmbeddingBatch> embed(List<String> texts) async {
    if (fail) throw const NotebookProviderException('timeout');
    return NotebookEmbeddingBatch(
      vectors: [for (final _ in texts) List.filled(1536, 0.1)],
      inputTokens: texts.length,
    );
  }
}

void main() {
  withServerpod('Search indexing', (builder, _) {
    test(
      'backfills a course file without a notebook and fences obsolete versions',
      () async {
        final session = builder.build();
        addTearDown(session.close);
        final course = await CourseRecord.db.insertRow(
          session,
          CourseRecord(title: 'Algorithms'),
        );
        final section = await CourseSectionRecord.db.insertRow(
          session,
          CourseSectionRecord(
            courseId: course.id!,
            title: 'Trees',
            sortOrder: 0,
            published: true,
          ),
        );
        final bytes = Uint8List.fromList(
          utf8.encode('Двійкові дерева та обхід графів.'),
        );
        final path = 'search-test/${course.id}/trees.txt';
        await session.storage.storeFile(
          storageId: 'private',
          path: path,
          byteData: ByteData.sublistView(bytes),
        );
        final activity = await CourseActivityRecord.db.insertRow(
          session,
          CourseActivityRecord(
            sectionId: section.id!,
            title: 'Reading',
            kind: 'file',
            published: true,
            sortOrder: 0,
            storageId: 'private',
            storagePath: path,
            file: CourseFileInfo(
              fileName: 'trees.txt',
              mimeType: 'text/plain',
              checksum: sha256.convert(bytes).toString(),
              sizeBytes: bytes.length,
            ),
          ),
        );
        final original = SearchDocument.activity(course, section, activity);
        var now = DateTime.now().toUtc().add(const Duration(seconds: 10));
        final provider = _Embeddings();
        final worker = SearchIndexWorker(
          provider: provider,
          extractor: const NotebookTextExtractor(),
          clock: () => now,
        );
        for (var i = 0; i < 3; i++) {
          expect(await worker.runOnce(session), isTrue);
        }
        final ready = await SearchIndexJob.db.findFirstRow(
          session,
          where: (t) => t.fingerprint.equals(original.fingerprint),
        );
        expect(ready?.state, 'ready');
        final passages = await SearchIndexChunk.db.find(
          session,
          where: (t) => t.jobId.equals(ready!.id),
        );
        expect(
          passages.any((chunk) => chunk.content.contains('обхід графів')),
          isTrue,
        );
        expect(
          passages.every(
            (chunk) => chunk.embeddingSpace == searchEmbeddingSpace,
          ),
          isTrue,
        );

        final draft = await CourseActivityRecord.db.updateRow(
          session,
          activity.copyWith(published: false),
        );
        final next = SearchDocument.activity(course, section, draft);
        expect(next.fingerprint, isNot(original.fingerprint));
        provider.fail = true;
        now = now.add(const Duration(minutes: 2));
        expect(await worker.runOnce(session), isTrue);
        expect(await SearchIndexJob.db.findById(session, ready!.id!), isNull);
        expect(
          await SearchIndexChunk.db.count(
            session,
            where: (t) => t.jobId.equals(ready.id),
          ),
          0,
        );
        for (var i = 0; i < 2; i++) {
          now = now.add(const Duration(minutes: 3));
          expect(await worker.runOnce(session), isTrue);
        }
        final failed = await SearchIndexJob.db.findFirstRow(
          session,
          where: (t) => t.fingerprint.equals(next.fingerprint),
        );
        expect(failed?.state, 'failed');
        expect(failed?.attempts, 3);
      },
    );
  }, serverDirectory: Directory('../poodle_server').absolute);
}
