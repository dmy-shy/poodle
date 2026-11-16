import 'package:poodle_server/notebook_worker.dart';
import 'package:poodle_server/search_worker.dart';
import 'package:serverpod/serverpod.dart';

import '../extractors/text_extractor.dart';

class SearchIndexWorker {
  SearchIndexWorker({
    required this.provider,
    required this.extractor,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  final EmbeddingProvider provider;
  final NotebookExtractor extractor;
  final DateTime Function() clock;
  DateTime? _lastReconcile;
  Map<String, SearchDocument> _catalog = {};
  static const _maximumAttempts = 3;

  Future<void> _reconcile(Session session, DateTime now) async {
    await session.db.transaction((tx) async {
      await session.db.unsafeQuery(
        "SELECT pg_advisory_xact_lock(hashtextextended('poodle.search.reconcile', 0))",
        transaction: tx,
      );
      final jobs = await SearchIndexJob.db.find(session, transaction: tx);
      final current = await SearchDocument.catalog(session, transaction: tx);
      _catalog = {for (final doc in current) doc.fingerprint: doc};
      final existing = jobs.map((job) => job.fingerprint).toSet();
      for (final doc in current) {
        if (!existing.contains(doc.fingerprint)) {
          await enqueueSearchIndex(session, doc, transaction: tx);
        }
      }
      final obsolete = jobs
          .where((job) => !_catalog.containsKey(job.fingerprint))
          .map((job) => job.id!)
          .toSet();
      if (obsolete.isNotEmpty) {
        await SearchIndexJob.db.deleteWhere(
          session,
          where: (t) => t.id.inSet(obsolete),
          transaction: tx,
        );
      }
      await SearchHistoryRecord.db.deleteWhere(
        session,
        where: (t) => t.lastUsed <= now.subtract(const Duration(days: 90)),
        transaction: tx,
      );
    });
    _lastReconcile = now;
  }

  Future<bool> runOnce(Session session) async {
    if (session.enableLogging) {
      throw StateError('Use a private worker session.');
    }
    final now = clock().toUtc();
    if (_lastReconcile == null ||
        now.difference(_lastReconcile!) >= const Duration(minutes: 1)) {
      await _reconcile(session, now);
    }
    final claimTime = clock().toUtc();
    final claimed = await session.db.transaction((tx) async {
      final row = await SearchIndexJob.db.findFirstRow(
        session,
        where: (t) =>
            ((t.state.equals('queued') & (t.availableAt <= claimTime)) |
            (t.state.equals('working') & (t.leaseUntil <= claimTime))),
        orderByList: (t) => [t.availableAt.asc(), t.id.asc()],
        transaction: tx,
        lockMode: LockMode.forUpdate,
        lockBehavior: LockBehavior.skipLocked,
      );
      if (row == null) return null;
      return SearchIndexJob.db.updateRow(
        session,
        row.copyWith(
          attempts: row.attempts + 1,
          state: 'working',
          leaseUntil: claimTime.add(const Duration(minutes: 15)),
        ),
        transaction: tx,
      );
    });
    if (claimed == null) return false;
    final doc =
        _catalog[claimed.fingerprint] ??
        (await SearchDocument.catalog(
          session,
        )).where((doc) => doc.fingerprint == claimed.fingerprint).firstOrNull;
    if (doc == null || claimed.attempts > _maximumAttempts) {
      await _finish(session, claimed, null);
      return true;
    }
    try {
      final chunks = await _chunks(
        session,
        claimed,
        doc,
      ).timeout(const Duration(minutes: 10));
      await _finish(session, claimed, chunks, doc: doc);
    } catch (_) {
      await _finish(session, claimed, null);
      // Do not log file text, storage keys, or provider response bodies.
      session.log('search index attempt failed (attempt=${claimed.attempts})');
    }
    return true;
  }

  Future<List<SearchIndexChunk>> _chunks(
    Session session,
    SearchIndexJob job,
    SearchDocument doc,
  ) async {
    final blocks = [
      NotebookTextBlock(
        sourceVersionId: doc.fingerprint,
        blockId: 'metadata',
        location: const NotebookSourceLocation(),
        text: doc.content,
      ),
    ];
    final file = doc.file;
    final chunks = <SearchIndexChunk>[];
    if (file != null) {
      final sources = await NotebookSourceRecord.db.find(
        session,
        where: (t) =>
            t.activityId.equals(doc.hit.activityId) &
            t.courseId.equals(doc.hit.courseId) &
            t.ownerUserId.equals(null) &
            t.notebookId.equals(null) &
            t.storagePath.equals(doc.storagePath) &
            t.status.equals('ready'),
      );
      for (final source in sources) {
        final version = await NotebookSourceVersionRecord.db.findFirstRow(
          session,
          where: (t) =>
              t.sourceId.equals(source.id) &
              t.version.equals(source.currentVersion) &
              t.checksum.equals(file.checksum) &
              t.status.equals('ready') &
              t.embeddingSpace.equals(searchEmbeddingSpace),
        );
        if (version == null) continue;
        final stored = await NotebookChunkRecord.db.find(
          session,
          where: (t) =>
              t.sourceId.equals(source.id) &
              t.sourceVersionId.equals(version.id),
          orderBy: (t) => t.id,
        );
        for (final chunk in stored) {
          chunks.add(
            SearchIndexChunk(
              jobId: job.id!,
              ordinal: chunks.length,
              content: chunk.content,
              page: chunk.pageNumber,
              location: chunk.locationLabel,
              embeddingSpace: searchEmbeddingSpace,
              embedding: chunk.embedding,
            ),
          );
        }
        if (chunks.isNotEmpty) break;
      }
      if (chunks.isEmpty) {
        final data = await session.storage
            .retrieveFile(storageId: 'private', path: doc.storagePath!)
            .timeout(const Duration(seconds: 30));
        final extracted = await extractor.extract(
          data,
          format: file.fileName.split('.').last.toLowerCase(),
          checksum: file.checksum,
          expectedSize: file.sizeBytes,
        );
        blocks.addAll(
          extracted.map(
            (block) => NotebookTextBlock(
              sourceVersionId: doc.fingerprint,
              blockId: block.id,
              location: NotebookSourceLocation(
                page: block.page,
                block: block.id,
              ),
              text: block.text,
            ),
          ),
        );
      }
    }
    final texts = const NotebookChunker(
      maxWords: 256,
      overlapWords: 32,
    ).chunk(blocks);
    for (var start = 0; start < texts.length; start += 32) {
      final batch = texts.skip(start).take(32).toList();
      final result = await provider.embed(
        batch.map((chunk) => chunk.text).toList(),
      );
      if (result.vectors.length != batch.length ||
          result.vectors.any(
            (v) =>
                v.length != 1536 ||
                v.any((x) => !x.isFinite) ||
                !v.any((x) => x != 0),
          )) {
        throw const NotebookIngestionException('invalid_embeddings');
      }
      for (var i = 0; i < batch.length; i++) {
        chunks.add(
          SearchIndexChunk(
            jobId: job.id!,
            ordinal: chunks.length,
            content: batch[i].text,
            page: batch[i].location.page,
            location: batch[i].blockId == 'metadata'
                ? null
                : batch[i].location.block,
            embeddingSpace: searchEmbeddingSpace,
            embedding: Vector(result.vectors[i]),
          ),
        );
      }
    }
    return chunks;
  }

  Future<void> _finish(
    Session session,
    SearchIndexJob claimed,
    List<SearchIndexChunk>? chunks, {
    SearchDocument? doc,
  }) => session.db.transaction((tx) async {
    final row = await SearchIndexJob.db.findById(
      session,
      claimed.id!,
      transaction: tx,
      lockMode: LockMode.forUpdate,
    );
    if (row == null ||
        row.state != 'working' ||
        row.attempts != claimed.attempts) {
      return;
    }
    final now = clock().toUtc();
    if (row.leaseUntil?.isAfter(now) != true) return;
    if (doc != null &&
        !(await SearchDocument.catalog(
          session,
          courseId: doc.hit.courseId,
          transaction: tx,
        )).any((current) => current.fingerprint == row.fingerprint)) {
      await SearchIndexJob.db.deleteRow(session, row, transaction: tx);
      return;
    }
    if (chunks != null) {
      if (chunks.isNotEmpty) {
        await SearchIndexChunk.db.insert(session, chunks, transaction: tx);
      }
    }
    await SearchIndexJob.db.updateRow(
      session,
      row.copyWith(
        state: chunks != null
            ? 'ready'
            : row.attempts >= _maximumAttempts
            ? 'failed'
            : 'queued',
        availableAt: now.add(Duration(minutes: row.attempts)),
        leaseUntil: null,
      ),
      transaction: tx,
    );
  });
}
