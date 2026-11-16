import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:poodle_server/notebook_worker.dart';
import 'package:serverpod/serverpod.dart';

import '../extractors/text_extractor.dart';
import '../extractors/document_extractor.dart';
import '../extractors/upload_scanner.dart';

part 'chat_worker.dart';
part 'studio_worker.dart';
part 'studio_format.dart';
part 'notebook_budget.dart';

typedef NotebookObjectReader =
    Future<ByteData> Function(Session session, String storageId, String path);

/// One extraction at a time across processes. Database leases fence all writes;
/// no transaction is held open during object reads or embedding requests.
class NotebookIngestionWorker {
  NotebookIngestionWorker({
    required this.provider,
    required this.embeddingMicrosPerMillionTokens,
    required this.embeddingSpace,
    NotebookObjectReader? readObject,
    this.extractor = const NotebookDocumentExtractor(),
    this.scanUpload = scanNotebookUpload,
    this.leaseDuration = const Duration(minutes: 10),
  }) : readObject = readObject ?? _readObject {
    if (embeddingSpace.trim().isEmpty ||
        embeddingMicrosPerMillionTokens <= 0 ||
        leaseDuration < const Duration(minutes: 8)) {
      throw ArgumentError(
        'A positive configured price and >=8 minute lease are required.',
      );
    }
  }

  final NotebookAiProvider provider;
  final int embeddingMicrosPerMillionTokens;
  final String embeddingSpace;
  final NotebookObjectReader readObject;
  final NotebookExtractor extractor;
  final Future<void> Function(Uint8List) scanUpload;
  final Duration leaseDuration;
  static const maximumAttempts = 3;
  String get jobType => 'ingest';

  void _requirePrivateSession(Session session) {
    if (session.enableLogging) {
      throw StateError('Worker sessions must use enableLogging: false.');
    }
  }

  static Future<ByteData> _readObject(
    Session session,
    String storageId,
    String path,
  ) => session.storage.retrieveFile(storageId: storageId, path: path);

  Future<void> _lock(Session session, Transaction tx) async {
    await session.db.unsafeQuery(
      "SELECT pg_advisory_xact_lock(hashtextextended('poodle.notebook:ingestion', 0))",
      transaction: tx,
    );
  }

  Future<DateTime> _now(Session session, Transaction tx) async =>
      (await session.db.unsafeQuery(
            'SELECT CURRENT_TIMESTAMP',
            transaction: tx,
          )).single.single
          as DateTime;

  /// Claims queued work or recovers a crashed worker's expired lease. An
  /// exhausted lease is failed rather than leaving a source processing forever.
  Future<NotebookJobRecord?> claim(Session session) => session.db.transaction((
    tx,
  ) async {
    _requirePrivateSession(session);
    await _lock(session, tx);
    final now = await _now(session, tx);
    final active = await NotebookJobRecord.db.findFirstRow(
      session,
      where: (t) =>
          t.jobType.equals(jobType) &
          t.status.equals('processing') &
          (t.leaseExpiresAt > now),
      transaction: tx,
    );
    if (active != null) return null;
    final expired = await NotebookJobRecord.db.find(
      session,
      where: (t) =>
          t.jobType.equals(jobType) &
          t.status.equals('processing') &
          (t.leaseExpiresAt <= now),
      transaction: tx,
    );
    for (final job in expired) {
      await _discardExpiredOutput(session, job);
      await _settleBudget(
        session,
        job,
        tx,
      ); // Unknown prior usage is charged conservatively.
      final exhausted = job.attempts >= maximumAttempts;
      await NotebookJobRecord.db.updateRow(
        session,
        job.copyWith(
          status: exhausted ? 'failed' : 'queued',
          leaseToken: null,
          leaseExpiresAt: null,
          privatePayload: _withoutBudget(job),
          failureCode: exhausted ? 'retry_exhausted' : null,
          updatedAt: now,
        ),
        transaction: tx,
      );
      if (exhausted) await _sourceFailure(session, job, 'retry_exhausted', tx);
    }
    final candidate = await NotebookJobRecord.db.findFirstRow(
      session,
      where: (t) =>
          t.jobType.equals(jobType) &
          t.status.equals('queued') &
          (t.attempts < maximumAttempts) &
          (t.leaseExpiresAt.equals(null) | (t.leaseExpiresAt <= now)),
      orderBy: (t) => t.createdAt,
      transaction: tx,
    );
    if (candidate == null) return null;
    final claimed = candidate.copyWith(
      status: 'processing',
      attempts: candidate.attempts + 1,
      leaseToken: const Uuid().v4(),
      leaseExpiresAt: now.add(leaseDuration),
      failureCode: null,
      updatedAt: now,
    );
    final stored = await NotebookJobRecord.db.updateRow(
      session,
      claimed,
      transaction: tx,
    );
    try {
      final source = await _validateSource(session, stored, transaction: tx);
      await NotebookSourceRecord.db.updateRow(
        session,
        source.copyWith(
          status: 'processing',
          failureCode: null,
          updatedAt: now,
        ),
        transaction: tx,
      );
    } on NotebookIngestionException {
      // process() records a public failure code without exposing source data.
    }
    return stored;
  });

  /// Returns false when the queue is idle or another process owns a live lease.
  Future<bool> runOnce(Session session) async {
    final job = await claim(session);
    if (job == null) return false;
    await process(session, job);
    return true;
  }

  Future<void> _discardExpiredOutput(
    Session session,
    NotebookJobRecord job,
  ) async {}

  /// Host this loop in the separate worker process, using internal Serverpod
  /// sessions configured with the same private storage as the API. Shutdown
  /// finishes the current job, closes its session and stops polling.
  Future<void> run({
    required Future<Session> Function() openSession,
    required Future<void> stopSignal,
    Duration idleDelay = const Duration(seconds: 2),
  }) async {
    if (idleDelay <= Duration.zero) throw ArgumentError.value(idleDelay);
    var stopping = false;
    final stopped = stopSignal.then((_) {
      stopping = true;
    });
    while (!stopping) {
      final session = await openSession();
      final bool worked;
      try {
        worked = await runOnce(session);
      } finally {
        await session.close();
      }
      if (!worked && !stopping) {
        await Future.any([stopped, Future<void>.delayed(idleDelay)]);
      }
    }
  }

  Future<NotebookJobRecord?> _fenced(
    Session session,
    NotebookJobRecord job,
    Transaction tx,
  ) async {
    final now = await _now(session, tx);
    return NotebookJobRecord.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(job.id) &
          t.jobType.equals(jobType) &
          t.status.equals('processing') &
          t.leaseToken.equals(job.leaseToken) &
          (t.leaseExpiresAt > now),
      transaction: tx,
    );
  }

  Map<String, dynamic> _payload(NotebookJobRecord job) {
    try {
      final value = jsonDecode(job.privatePayload ?? '');
      if (value is! Map<String, dynamic>) throw const FormatException();
      return value;
    } on FormatException {
      throw const NotebookIngestionException('invalid_job');
    }
  }

  String _withoutBudget(NotebookJobRecord job) {
    try {
      return jsonEncode(_payload(job)..remove('budget'));
    } on NotebookIngestionException {
      return '{}';
    }
  }

  Future<NotebookSourceRecord> _validateSource(
    Session session,
    NotebookJobRecord job, {
    Transaction? transaction,
    bool requirePublished = true,
  }) async {
    final payload = _payload(job);
    var source = job.sourceId == null
        ? null
        : await NotebookSourceRecord.db.findById(
            session,
            job.sourceId!,
            transaction: transaction,
          );
    if (source != null && transaction != null) {
      // Share the API's course lock so a newly configured source cannot be
      // overwritten by an older ingestion completion.
      await session.db.unsafeQuery(
        'SELECT pg_advisory_xact_lock(hashtextextended(@resource, 0))',
        parameters: QueryParameters.named({
          'resource': 'poodle.notebook:course:${source.courseId}',
        }),
        transaction: transaction,
      );
      source = await NotebookSourceRecord.db.findById(
        session,
        source.id!,
        transaction: transaction,
      );
    }
    if (source == null ||
        source.status == 'deleted' ||
        payload['storageId'] != 'private' ||
        source.storageId != 'private' ||
        source.storagePath != payload['storagePath'] ||
        source.format != payload['format'] ||
        payload['checksum'] is! String ||
        payload['sizeBytes'] is! int ||
        (payload['sizeBytes'] as int) <= 0 ||
        (payload['sizeBytes'] as int) > NotebookTextExtractor.maximumBytes) {
      throw const NotebookIngestionException('source_unavailable');
    }
    if (source.ownerUserId != null) {
      if (source.notebookId == null ||
          source.activityId != null ||
          job.ownerUserId != source.ownerUserId ||
          job.notebookId != source.notebookId ||
          source.storagePath !=
              'notebook-uploads/${source.ownerUserId}/${source.notebookId}/${source.id}.${source.format}') {
        throw const NotebookIngestionException('source_unavailable');
      }
      try {
        final access = await NotebookExecutionAccess.require(
          session,
          source.notebookId!,
          source.ownerUserId!,
          transaction: transaction,
        );
        if (access.notebook.courseId != source.courseId ||
            !access.config.allowedFormats.contains(source.format)) {
          throw const NotebookIngestionException('source_unavailable');
        }
      } on NotebookError {
        throw const NotebookIngestionException('source_unavailable');
      }
      return source;
    }
    if (source.notebookId != null || source.activityId == null) {
      throw const NotebookIngestionException('source_unavailable');
    }
    final activity = await CourseActivityRecord.db.findById(
      session,
      source.activityId!,
      transaction: transaction,
    );
    final section = activity == null
        ? null
        : await CourseSectionRecord.db.findById(
            session,
            activity.sectionId,
            transaction: transaction,
          );
    if (activity == null ||
        section == null ||
        (requirePublished && (!activity.published || !section.published)) ||
        section.courseId != source.courseId ||
        activity.kind != 'file' ||
        activity.storageId != source.storageId ||
        activity.storagePath != source.storagePath ||
        activity.file?.fileName != source.fileName ||
        activity.file?.mimeType !=
            const {
              'txt': 'text/plain',
              'md': 'text/markdown',
              'pdf': 'application/pdf',
              'docx':
                  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            }[source.format] ||
        activity.file?.checksum != payload['checksum'] ||
        activity.file?.sizeBytes != payload['sizeBytes']) {
      throw const NotebookIngestionException('source_unavailable');
    }
    return source;
  }

  Future<void> _validateWork(
    Session session,
    NotebookJobRecord job,
    Transaction tx,
  ) async {
    await _validateSource(session, job, transaction: tx);
  }

  /// Embeddings are injected; this library never loads provider credentials.
  Future<void> process(Session session, NotebookJobRecord claimed) async {
    _requirePrivateSession(session);
    try {
      final validLease = await session.db.transaction(
        (tx) => _fenced(session, claimed, tx),
      );
      if (validLease == null) return;
      final source = await _validateSource(session, claimed);
      final payload = _payload(claimed);
      if (!{'txt', 'md', 'pdf', 'docx'}.contains(source.format)) {
        throw const NotebookIngestionException('unsupported_format');
      }
      final data = await readObject(
        session,
        'private',
        source.storagePath,
      ).timeout(const Duration(seconds: 30));
      if (source.ownerUserId != null) {
        await scanUpload(
          NotebookTextExtractor.validatedBytes(
            data,
            checksum: payload['checksum'] as String,
            expectedSize: payload['sizeBytes'] as int,
          ),
        );
      }
      final blocks = await extractor.extract(
        data,
        format: source.format,
        checksum: payload['checksum'] as String,
        expectedSize: payload['sizeBytes'] as int,
      );
      final versionId = UuidValue.withValidation(const Uuid().v4());
      final chunks = const NotebookChunker().chunk([
        for (final block in blocks)
          NotebookTextBlock(
            sourceVersionId: versionId.toString(),
            blockId: block.id,
            location: NotebookSourceLocation(page: block.page, block: block.id),
            text: block.text,
          ),
      ]);
      if (chunks.isEmpty ||
          chunks.length > 256 ||
          chunks.any((chunk) => utf8.encode(chunk.text).length > 8000)) {
        throw const NotebookIngestionException('extraction_limit');
      }
      // UTF-8 bytes plus per-input allowance conservatively bound input tokens.
      final tokenAllowance = chunks.fold<int>(
        0,
        (sum, c) => sum + utf8.encode(c.text).length + 32,
      );
      await _reserveBudget(session, claimed, tokenAllowance);
      final vectors = <List<double>>[];
      var tokens = 0;
      for (var start = 0; start < chunks.length; start += 32) {
        if (await session.db.transaction(
              (tx) => _fenced(session, claimed, tx),
            ) ==
            null) {
          return;
        }
        final batch = chunks.skip(start).take(32).toList();
        final embedded = await provider
            .embed(batch.map((c) => c.text).toList())
            .timeout(const Duration(seconds: 45));
        if (embedded.vectors.length != batch.length ||
            embedded.inputTokens < 0 ||
            embedded.vectors.any(
              (v) => v.length != 1536 || v.any((n) => !n.isFinite),
            )) {
          throw const NotebookIngestionException('invalid_embeddings');
        }
        vectors.addAll(embedded.vectors);
        tokens += embedded.inputTokens;
        if (tokens > tokenAllowance) {
          throw const NotebookIngestionException('embedding_usage_exceeded');
        }
      }
      await session.db.transaction((tx) async {
        await _lock(session, tx);
        final job = await _fenced(session, claimed, tx);
        if (job == null) return;
        final currentSource = await _validateSource(
          session,
          job,
          transaction: tx,
        );
        final version = currentSource.currentVersion + 1;
        await NotebookSourceVersionRecord.db.insertRow(
          session,
          NotebookSourceVersionRecord(
            id: versionId,
            sourceId: source.id!,
            version: version,
            checksum: payload['checksum'] as String,
            title: source.fileName,
            extractedText: blocks.map((b) => b.text).join('\n\n'),
            status: 'ready',
            embeddingSpace: embeddingSpace,
          ),
          transaction: tx,
        );
        for (var i = 0; i < chunks.length; i++) {
          final chunk = chunks[i];
          await NotebookChunkRecord.db.insertRow(
            session,
            NotebookChunkRecord(
              sourceId: source.id!,
              sourceVersionId: versionId,
              blockId: chunk.blockId,
              locationLabel: chunk.location.block,
              content: chunk.text,
              embedding: Vector(vectors[i]),
            ),
            transaction: tx,
          );
        }
        await _settleBudget(session, job, tx, actualTokens: tokens);
        final now = await _now(session, tx);
        await NotebookSourceRecord.db.updateRow(
          session,
          currentSource.copyWith(
            currentVersion: version,
            status: 'ready',
            failureCode: null,
            updatedAt: now,
          ),
          transaction: tx,
        );
        await NotebookJobRecord.db.updateRow(
          session,
          job.copyWith(
            status: 'complete',
            leaseToken: null,
            leaseExpiresAt: null,
            failureCode: null,
            privatePayload: _withoutBudget(job),
            updatedAt: now,
          ),
          transaction: tx,
        );
      });
    } on NotebookIngestionException catch (error) {
      await _fail(session, claimed, error.code, retryable: error.retryable);
    } on NotebookProviderException catch (error) {
      await _fail(
        session,
        claimed,
        error.code,
        retryable: {
          'rate_limited',
          'provider_unavailable',
          'timeout',
        }.contains(error.code),
      );
    } on TimeoutException {
      await _fail(session, claimed, 'timeout', retryable: true);
    } on CloudStorageException {
      await _fail(session, claimed, 'storage_unavailable', retryable: true);
    } catch (_) {
      // Never include object contents, provider bodies or questions in logs/errors.
      await _fail(session, claimed, 'ingestion_failed', retryable: true);
    }
  }

  Future<void> _sourceFailure(
    Session session,
    NotebookJobRecord job,
    String code,
    Transaction tx,
  ) async {
    try {
      final source = await _validateSource(
        session,
        job,
        transaction: tx,
        requirePublished: false,
      );
      await NotebookSourceRecord.db.updateRow(
        session,
        source.copyWith(
          status: 'failed',
          failureCode: code,
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: tx,
      );
    } on NotebookIngestionException {
      // Superseded jobs must not change a newer source's status.
    }
  }

  Future<void> _fail(
    Session session,
    NotebookJobRecord claimed,
    String code, {
    required bool retryable,
  }) async {
    await session.db.transaction((tx) async {
      await _lock(session, tx);
      final job = await _fenced(session, claimed, tx);
      if (job == null) return;
      await _settleBudget(session, job, tx);
      final retry = retryable && job.attempts < maximumAttempts;
      final now = await _now(session, tx);
      await NotebookJobRecord.db.updateRow(
        session,
        job.copyWith(
          status: retry ? 'queued' : 'failed',
          failureCode: code,
          leaseToken: null,
          leaseExpiresAt: retry
              ? now.add(Duration(seconds: 5 * job.attempts))
              : null,
          privatePayload: _withoutBudget(job),
          updatedAt: now,
        ),
        transaction: tx,
      );
      if (!retry) await _sourceFailure(session, job, code, tx);
      if (retry) {
        try {
          final source = await _validateSource(session, job, transaction: tx);
          await NotebookSourceRecord.db.updateRow(
            session,
            source.copyWith(
              status: 'queued',
              failureCode: code,
              updatedAt: now,
            ),
            transaction: tx,
          );
        } on NotebookIngestionException {
          // A superseded job does not own the source's new state.
        }
      }
    });
  }
}
