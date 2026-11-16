import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import 'notebook_execution_access.dart';
import 'notebook_repository.dart';

/// Owner-only access to durable, generated study artifacts.
class NotebookStudioService {
  Future<T> _withAccess<T>(
    Session session,
    UuidValue notebookId,
    Future<T> Function(Session, NotebookExecutionSnapshot) action,
  ) async {
    final account = await AccountAuthorization.requireAccount(session);
    final privateSession = await session.serverpod.createSession(
      enableLogging: false,
    );
    try {
      final access = await NotebookExecutionAccess.require(
        privateSession,
        notebookId,
        account.authUserId,
      );
      return await action(privateSession, access);
    } finally {
      await privateSession.close();
    }
  }

  Map<String, int> _versions(NotebookExecutionSnapshot access) => {
    for (final entry in access.versions.entries)
      entry.key.toString(): entry.value.version,
  };

  bool _stale(
    NotebookArtifactRecord artifact,
    NotebookExecutionSnapshot access,
  ) {
    try {
      final saved = jsonDecode(artifact.sourceSnapshotJson ?? '') as Map;
      final versions = saved['sourceVersions'];
      final current = _versions(access);
      return artifact.stale ||
          artifact.sourceRevision != access.config.revision ||
          versions is! Map ||
          versions.length != current.length ||
          current.entries.any((entry) => versions[entry.key] != entry.value);
    } catch (_) {
      return true;
    }
  }

  Future<NotebookJobStatus> generate(
    Session session,
    NotebookStudioRequest input,
  ) => _withAccess(session, input.notebookId, (privateSession, access) async {
    if (!{'quiz', 'audio', 'flashcards'}.contains(input.kind) ||
        !{'en', 'uk'}.contains(input.language) ||
        input.requestKey.trim().isEmpty ||
        input.requestKey.length > 100) {
      throw NotebookError(code: 'invalid_request');
    }
    return privateSession.db.transaction((tx) async {
      await NotebookRepository().lock(
        privateSession,
        'request:${access.notebook.ownerUserId}:${input.requestKey}',
        tx,
      );
      final existing = await NotebookJobRecord.db.findFirstRow(
        privateSession,
        where: (t) =>
            t.ownerUserId.equals(access.notebook.ownerUserId) &
            t.requestKey.equals(input.requestKey),
        transaction: tx,
      );
      if (existing != null) {
        final prior = jsonDecode(existing.privatePayload ?? '{}') as Map;
        if (existing.notebookId != input.notebookId ||
            existing.jobType != 'studio' ||
            prior['kind'] != input.kind ||
            prior['language'] != input.language) {
          throw NotebookError(code: 'request_key_conflict');
        }
        return NotebookJobStatus(
          id: existing.id!,
          status: existing.status,
          failureCode: existing.failureCode,
          createdAt: existing.createdAt,
        );
      }
      if (access.versions.isEmpty) {
        throw NotebookError(code: 'no_ready_sources');
      }
      final job = await NotebookJobRecord.db.insertRow(
        privateSession,
        NotebookJobRecord(
          ownerUserId: access.notebook.ownerUserId,
          notebookId: input.notebookId,
          jobType: 'studio',
          status: 'queued',
          requestKey: input.requestKey,
          privatePayload: jsonEncode({
            'kind': input.kind,
            'language': input.language,
            'configRevision': access.config.revision,
            'sourceVersions': _versions(access),
          }),
        ),
        transaction: tx,
      );
      return NotebookJobStatus(
        id: job.id!,
        status: job.status,
        failureCode: null,
        createdAt: job.createdAt,
      );
    });
  });

  Future<List<NotebookJobStatus>> jobs(
    Session session,
    UuidValue notebookId,
  ) => _withAccess(session, notebookId, (privateSession, access) async {
    final rows = await NotebookJobRecord.db.find(
      privateSession,
      where: (t) =>
          t.notebookId.equals(notebookId) &
          t.ownerUserId.equals(access.notebook.ownerUserId) &
          t.jobType.equals('studio'),
      orderBy: (t) => t.createdAt.desc(),
      limit: 100,
    );
    return [
      for (final row in rows)
        NotebookJobStatus(
          id: row.id!,
          status: row.status,
          failureCode: row.failureCode,
          createdAt: row.createdAt,
        ),
    ];
  });

  Future<List<NotebookStudioItem>> items(
    Session session,
    UuidValue notebookId,
  ) => _withAccess(session, notebookId, (privateSession, access) async {
    final rows = await NotebookArtifactRecord.db.find(
      privateSession,
      where: (t) =>
          t.notebookId.equals(notebookId) &
          t.ownerUserId.equals(access.notebook.ownerUserId),
      orderBy: (t) => t.createdAt.desc(),
      limit: 100,
    );
    final pending = await NotebookJobRecord.db.find(
      privateSession,
      where: (t) =>
          t.notebookId.equals(notebookId) &
          t.ownerUserId.equals(access.notebook.ownerUserId) &
          t.jobType.equals('studio') &
          t.status.inSet({'queued', 'processing', 'failed'}),
      orderBy: (t) => t.createdAt.desc(),
      limit: 100,
    );
    final result = [
      for (final row in rows.where((row) => row.jobId != null))
        _view(row, access),
      for (final job in pending) ?_jobView(job),
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result.take(100).toList();
  });

  NotebookStudioItem? _jobView(NotebookJobRecord job) {
    try {
      final payload = jsonDecode(job.privatePayload ?? '');
      if (payload is! Map) return null;
      final kind = payload['kind'];
      final language = payload['language'];
      if (kind is! String || language is! String) return null;
      return NotebookStudioItem(
        id: job.id!,
        kind: kind,
        language: language,
        title: '',
        status: job.status,
        failureCode: job.failureCode,
        contentJson: '',
        citations: const [],
        stale: false,
        createdAt: job.createdAt,
      );
    } on FormatException {
      return null;
    }
  }

  NotebookStudioItem _view(
    NotebookArtifactRecord row,
    NotebookExecutionSnapshot access, {
    bool detail = false,
    List<NotebookCitation> citations = const [],
  }) {
    final stale = _stale(row, access);
    final content = stale || !detail ? '' : row.contentJson;
    return NotebookStudioItem(
      id: row.id!,
      kind: row.kind,
      language: row.language ?? 'en',
      title: stale ? '' : row.title,
      status: stale ? 'stale' : 'ready',
      contentJson: content,
      citations: stale ? const [] : citations,
      stale: stale,
      createdAt: row.createdAt,
    );
  }

  Future<NotebookStudioItem> item(
    Session session,
    UuidValue notebookId,
    UuidValue artifactId,
  ) => _withAccess(session, notebookId, (privateSession, access) async {
    final row = await NotebookArtifactRecord.db.findById(
      privateSession,
      artifactId,
    );
    if (row == null ||
        row.notebookId != notebookId ||
        row.ownerUserId != access.notebook.ownerUserId) {
      throw NotebookError(code: 'unavailable');
    }
    if (_stale(row, access)) return _view(row, access);
    final ids = _citationIds(row.contentJson);
    final chunks = ids.isEmpty
        ? <NotebookChunkRecord>[]
        : await NotebookChunkRecord.db.find(
            privateSession,
            where: (t) => t.id.inSet(ids),
          );
    return _view(
      row,
      access,
      detail: true,
      citations: [
        for (final chunk in chunks)
          if (access.versions[chunk.sourceId] case final version?)
            if (version.id == chunk.sourceVersionId)
              NotebookCitation(
                chunkId: chunk.id!,
                sourceId: chunk.sourceId,
                sourceVersionId: chunk.sourceVersionId,
                sourceVersion: version.version,
                title: version.title,
                locationLabel: chunk.locationLabel,
                pageNumber: chunk.pageNumber,
              ),
      ],
    );
  });

  Set<UuidValue> _citationIds(String content) {
    final result = <UuidValue>{};
    try {
      final body = jsonDecode(content);
      if (body is! Map || body['schemaVersion'] != 1) return result;
      for (final key in ['items', 'cards', 'sections']) {
        final rows = body[key];
        if (rows is! List) continue;
        for (final row in rows) {
          final ids = row is Map ? row['citationIds'] : null;
          if (ids is! List) continue;
          for (final id in ids.whereType<String>()) {
            result.add(UuidValue.withValidation(id));
          }
        }
      }
      return result;
    } on FormatException {
      return {};
    }
  }

  Future<String> passage(
    Session session,
    UuidValue notebookId,
    UuidValue artifactId,
    UuidValue chunkId,
  ) => _withAccess(session, notebookId, (privateSession, access) async {
    final artifact = await NotebookArtifactRecord.db.findById(
      privateSession,
      artifactId,
    );
    if (artifact == null ||
        artifact.notebookId != notebookId ||
        artifact.ownerUserId != access.notebook.ownerUserId ||
        _stale(artifact, access)) {
      throw NotebookError(code: 'unavailable');
    }
    if (!_citationIds(artifact.contentJson).contains(chunkId)) {
      throw NotebookError(code: 'unavailable');
    }
    final chunk = await NotebookChunkRecord.db.findById(
      privateSession,
      chunkId,
    );
    if (chunk == null ||
        !access.versions.values.any((v) => v.id == chunk.sourceVersionId)) {
      throw NotebookError(code: 'unavailable');
    }
    return chunk.content;
  });

  Future<NotebookAudioAccess> audio(
    Session session,
    UuidValue notebookId,
    UuidValue artifactId,
  ) => _withAccess(session, notebookId, (privateSession, access) async {
    final row = await NotebookArtifactRecord.db.findById(
      privateSession,
      artifactId,
    );
    if (row == null ||
        row.notebookId != notebookId ||
        row.ownerUserId != access.notebook.ownerUserId ||
        row.kind != 'audio' ||
        row.audioStoragePath == null ||
        _stale(row, access)) {
      throw NotebookError(code: 'unavailable');
    }
    const duration = Duration(minutes: 15);
    final expiresAt = DateTime.now().toUtc().add(duration);
    try {
      final url = await privateSession.storage.temporaryDownloadUrl(
        storageId: 'private',
        path: row.audioStoragePath!,
        options: TemporaryDownloadUrlOptions(
          expirationDuration: duration,
          contentType: 'audio/mpeg',
        ),
      );
      return NotebookAudioAccess(url: url.toString(), expiresAt: expiresAt);
    } on CloudStorageException {
      throw NotebookError(code: 'unavailable');
    }
  });
}
