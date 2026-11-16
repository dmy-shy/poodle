import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:poodle_client/poodle_client.dart' as api;
import 'package:crypto/crypto.dart';
import '../services/notebook_file_picker.dart';
import '../services/serverpod_auth_gateway.dart';
import 'auth_repository.dart';
import 'notebook_repository.dart';
import 'account_notebook_cache.dart';
import '../../server_url.dart';

class ServerpodNotebookRepository extends NotebookRepository {
  ServerpodNotebookRepository(
    this._gateway, {
    this.filePicker = const NotebookFilePicker(),
    this.sendFile = _sendFile,
    AccountNotebookCache? cache,
  }) {
    _cache = cache ?? AccountNotebookCache(namespace: _gateway.serverIdentity);
  }
  final NotebookFilePicker filePicker;
  final Future<bool> Function(String, ByteData) sendFile;
  static Future<bool> _sendFile(String description, ByteData data) =>
      api.FileUploader(description)
          .uploadByteData(data)
          .timeout(
            const Duration(minutes: 3),
            onTimeout: () => false,
          );
  final ServerpodAuthGateway _gateway;
  late final AccountNotebookCache _cache;
  Future<void> _cacheTail = Future.value();
  final Set<String> _staleKeys = {};
  DateTime? _lastRefreshedAt;
  @override
  bool get isStale => _staleKeys.isNotEmpty;
  @override
  DateTime? get lastRefreshedAt => _lastRefreshedAt;

  @override
  void bindAccount(String? value) {
    final old = account;
    super.bindAccount(value);
    if (old == value) return;
    _staleKeys.clear();
    _lastRefreshedAt = null;
    if (old != null && !kIsWeb) {
      _cacheTail = _cacheTail.catchError((_) {}).then((_) => _cache.purge(old));
      unawaited(_cacheTail.catchError((_) {}));
    }
  }

  Future<T> _cached<T>(
    String key,
    Future<T> Function() fetch,
    Map<String, dynamic> Function(T) encode,
    T Function(Map<String, dynamic>) decode,
  ) async {
    final owner = account;
    final epoch = generation;
    try {
      final value = await fetch();
      if (epoch != generation || owner == null) throw NotebookFailure.cancelled;
      final now = DateTime.now().toUtc();
      if (!kIsWeb) {
        try {
          final write = _cacheTail.catchError((_) {}).then((_) async {
            if (epoch == generation) {
              await _cache.write(owner, key, encode(value), now);
            }
          });
          _cacheTail = write.catchError((_) {});
          await write;
        } catch (_) {
          // An online read remains usable when local storage is unavailable.
        }
      }
      if (epoch != generation) throw NotebookFailure.cancelled;
      _staleKeys.remove(key);
      _lastRefreshedAt = now;
      return value;
    } on NotebookFailure catch (failure) {
      if (failure == NotebookFailure.unavailable && owner != null && !kIsWeb) {
        await _cacheTail.catchError((_) {});
        if (epoch == generation) {
          await _cache.remove(owner, key);
        }
      }
      if (failure != NotebookFailure.network ||
          owner == null ||
          epoch != generation ||
          kIsWeb) {
        rethrow;
      }
      await _cacheTail.catchError((_) {});
      if (epoch != generation) throw NotebookFailure.cancelled;
      final saved = await _cache.read(owner, key);
      if (epoch != generation) throw NotebookFailure.cancelled;
      if (saved == null) rethrow;
      try {
        final value = decode(saved.value);
        _staleKeys.add(key);
        _lastRefreshedAt = saved.refreshedAt;
        return value;
      } catch (_) {
        await _cache.remove(owner, key);
        rethrow;
      }
    }
  }

  api.UuidValue _id(String id) => api.UuidValue.withValidation(id);
  Future<T> _request<T>(Future<T> Function(api.Client) operation) async {
    final epoch = generation;
    if (account == null) throw NotebookFailure.cancelled;
    try {
      final result = await _gateway.withClient(operation);
      if (epoch != generation) throw NotebookFailure.cancelled;
      return result;
    } on api.NotebookError catch (error) {
      if (error.code == 'unavailable') {
        await _purgeCurrentAccount(epoch);
      }
      throw switch (error.code) {
        'no_ready_sources' => NotebookFailure.noSources,
        'monthly_budget_exceeded' => NotebookFailure.budget,
        'invalid_upload' ||
        'upload_format_not_allowed' => NotebookFailure.invalidUpload,
        'upload_limit' => NotebookFailure.uploadLimit,
        'sources_changed' ||
        'configuration_conflict' => NotebookFailure.changed,
        _ => NotebookFailure.unavailable,
      };
    } catch (error) {
      if (epoch != generation || error == NotebookFailure.cancelled) {
        throw NotebookFailure.cancelled;
      }
      if (error is NotebookFailure) rethrow;
      if (error == AuthFailure.network) throw NotebookFailure.network;
      throw NotebookFailure.unavailable;
    }
  }

  Future<void> _purgeCurrentAccount(int epoch) async {
    final owner = account;
    if (owner == null || kIsWeb || epoch != generation) return;
    final purge = _cacheTail.catchError((_) {}).then((_) async {
      if (epoch == generation) await _cache.purge(owner);
    });
    _cacheTail = purge.catchError((_) {});
    await purge;
    if (epoch == generation) {
      _staleKeys.clear();
      _lastRefreshedAt = null;
    }
  }

  @override
  Future<StudyNotebookSetup> assessmentSetup(
    String courseId,
    String assessmentId,
  ) => _request((client) async {
    final result = await client.notebook.getAssessmentSetup(
      _id(courseId),
      _id(assessmentId),
    );
    final config = result.configuration;
    return StudyNotebookSetup(
      config.revision,
      config.defaultMaterialActivityIds.map((id) => id.toString()),
      config.allowedFormats,
      result.materials.map(
        (m) => StudyMaterialOption(m.id.toString(), m.title, m.format),
      ),
    );
  });
  @override
  Future<void> configure(
    String courseId,
    String assessmentId,
    int revision,
    List<String> materialIds,
    List<String> formats,
  ) async {
    await _request((client) async {
      await client.notebook.configureAssessment(
        api.NotebookAssessmentConfigInput(
          courseId: _id(courseId),
          assessmentActivityId: _id(assessmentId),
          expectedRevision: revision,
          defaultMaterialActivityIds: materialIds.map(_id).toList(),
          allowedFormats: formats,
        ),
      );
    });
    await _purgeCurrentAccount(generation);
  }

  @override
  Future<StudyNotebook> open(String courseId, String assessmentId) => _cached(
    'overview:$courseId:$assessmentId',
    () => _request((client) async {
      final value = await client.notebook.openNotebook(
        _id(courseId),
        _id(assessmentId),
      );
      return StudyNotebook(
        value.notebookId?.toString(),
        value.configured,
        value.sources.map(
          (s) => StudySource(
            s.id.toString(),
            s.title,
            s.status,
            s.selected,
            failureCode: s.failureCode,
            privateUpload: s.privateUpload,
          ),
        ),
        allowedFormats: value.allowedFormats,
      );
    }),
    _encodeNotebook,
    _decodeNotebook,
  );

  Map<String, dynamic> _encodeNotebook(StudyNotebook value) => {
    'id': value.id,
    'configured': value.configured,
    'allowedFormats': value.allowedFormats,
    'sources': [
      for (final source in value.sources)
        {
          'id': source.id,
          'title': source.title,
          'status': source.status,
          'selected': source.selected,
          'failureCode': source.failureCode,
          'privateUpload': source.privateUpload,
        },
    ],
  };

  StudyNotebook _decodeNotebook(Map<String, dynamic> value) => StudyNotebook(
    value['id'] as String?,
    value['configured'] as bool,
    [
      for (final row in value['sources'] as List<dynamic>)
        StudySource(
          row['id'] as String,
          row['title'] as String,
          row['status'] as String,
          row['selected'] as bool,
          failureCode: row['failureCode'] as String?,
          privateUpload: row['privateUpload'] as bool? ?? false,
        ),
    ],
    allowedFormats: (value['allowedFormats'] as List<dynamic>).cast<String>(),
  );
  @override
  Future<StudyJob?> upload(
    String notebookId,
    List<String> formats,
    String requestKey, {
    void Function(String name)? onPicked,
  }) async {
    final epoch = generation;
    final NotebookPickedFile? file;
    try {
      file = await filePicker.pick(formats);
    } on FormatException {
      throw NotebookFailure.invalidUpload;
    }
    if (epoch != generation || account == null) throw NotebookFailure.cancelled;
    final picked = file;
    if (picked == null) return null;
    onPicked?.call(picked.name);
    final ticket = await _request(
      (client) => client.notebook.beginUpload(
        api.NotebookUploadInput(
          notebookId: _id(notebookId),
          fileName: picked.name,
          sizeBytes: picked.bytes.length,
          checksum: sha256.convert(picked.bytes).toString(),
          requestKey: requestKey,
        ),
      ),
    );
    if (epoch != generation) throw NotebookFailure.cancelled;
    if (ticket.uploadDescription != null) {
      try {
        final description = resolveUploadDescription(
          description: ticket.uploadDescription!,
          serverUrl: _gateway.serverIdentity,
        );
        if (!await sendFile(description, ByteData.sublistView(picked.bytes))) {
          throw NotebookFailure.network;
        }
      } catch (_) {
        // A failed transfer must not leave an indefinitely preparing source.
        if (epoch == generation) {
          try {
            await removeUpload(notebookId, ticket.sourceId.toString());
          } catch (_) {
            // The original upload error is the useful one to surface.
          }
        }
        rethrow;
      }
      if (epoch != generation) throw NotebookFailure.cancelled;
    }
    final job = await _request(
      (client) => client.notebook.finishUpload(_id(notebookId), ticket.jobId),
    );
    return StudyJob(job.id.toString(), job.status);
  }

  @override
  Future<void> removeUpload(String notebookId, String sourceId) async {
    await _request(
      (client) => client.notebook.removeUpload(_id(notebookId), _id(sourceId)),
    );
    await _purgeCurrentAccount(generation);
  }

  @override
  Future<String> citationPassage(
    String notebookId,
    String turnId,
    String chunkId,
  ) => _cached(
    'passage:$notebookId:$turnId:$chunkId',
    () => _request(
      (client) => client.notebook.getCitationPassage(
        _id(notebookId),
        _id(turnId),
        _id(chunkId),
      ),
    ),
    (text) => {'text': text},
    (value) => value['text'] as String,
  );
  StudyNote _note(api.NotebookNoteView note) => (
    id: note.id.toString(),
    turnId: note.turnId.toString(),
    content: note.content,
    stale: note.stale,
    createdAt: note.createdAt,
  );

  @override
  Future<StudyNote> saveNote(String notebookId, String turnId) => _request(
    (c) async => _note(await c.notebook.saveNote(_id(notebookId), _id(turnId))),
  );

  @override
  Future<List<StudyNote>> notes(String notebookId) => _request(
    (c) async =>
        (await c.notebook.getNotes(_id(notebookId))).map(_note).toList(),
  );

  @override
  Future<void> deleteNote(String notebookId, String noteId) => _request(
    (c) => c.notebook.deleteNote(_id(notebookId), _id(noteId)),
  );

  @override
  Future<List<StudyTurn>> turns(String notebookId) => _cached(
    'turns:$notebookId',
    () => _request(
      (client) async => List.unmodifiable(
        (await client.notebook.getTurns(_id(notebookId))).map(
          (t) => StudyTurn(
            t.id.toString(),
            t.role,
            t.content,
            t.stale,
            t.citations.map(
              (c) => StudyCitation(
                c.title,
                c.pageNumber == null ? c.locationLabel : '${c.pageNumber}',
                c.sourceVersion,
                chunkId: c.chunkId.toString(),
              ),
            ),
          ),
        ),
      ),
    ),
    (turns) => {
      'turns': [
        for (final turn in turns)
          {
            'id': turn.id,
            'role': turn.role,
            'content': turn.content,
            'stale': turn.stale,
            'citations': [
              for (final c in turn.citations)
                {
                  'title': c.title,
                  'location': c.location,
                  'version': c.version,
                  'chunkId': c.chunkId,
                },
            ],
          },
      ],
    },
    (value) => List<StudyTurn>.unmodifiable([
      for (final row in value['turns'] as List<dynamic>)
        StudyTurn(
          row['id'] as String,
          row['role'] as String,
          row['content'] as String,
          row['stale'] as bool,
          [
            for (final c in row['citations'] as List<dynamic>)
              StudyCitation(
                c['title'] as String,
                c['location'] as String?,
                c['version'] as int,
                chunkId: c['chunkId'] as String?,
              ),
          ],
        ),
    ]),
  );
  @override
  Future<void> select(String notebookId, List<String> sourceIds) async {
    await _request(
      (client) => client.notebook.setSelectedSources(
        _id(notebookId),
        sourceIds.map(_id).toList(),
      ),
    );
    await _purgeCurrentAccount(generation);
  }

  @override
  Future<StudyJob> ask(String notebookId, String question, String requestKey) =>
      _request((client) async {
        final value = await client.notebook.ask(
          api.NotebookChatInput(
            notebookId: _id(notebookId),
            question: question,
            requestKey: requestKey,
          ),
        );
        return StudyJob(value.id.toString(), value.status);
      });
  @override
  Future<StudyJob> job(String notebookId, String jobId) async {
    final value = await _request(
      (client) => client.notebook.getJobStatus(_id(notebookId), _id(jobId)),
    );
    if (value.status == 'failed') {
      throw switch (value.failureCode) {
        'monthly_budget_exceeded' => NotebookFailure.budget,
        'sources_changed' => NotebookFailure.changed,
        'no_ready_sources' => NotebookFailure.noSources,
        // The status request succeeded: a worker failure is not an access error.
        _ => NotebookFailure.processing,
      };
    }
    return StudyJob(value.id.toString(), value.status);
  }

  StudyStudioItem _studio(api.NotebookStudioItem item) => StudyStudioItem(
    id: item.id.toString(),
    kind: StudioKind.values.byName(item.kind),
    language: item.language,
    title: item.title,
    status: item.status,
    contentJson: item.contentJson,
    citations: List.unmodifiable(
      item.citations.map(
        (c) => StudyCitation(
          c.title,
          c.pageNumber?.toString() ?? c.locationLabel,
          c.sourceVersion,
          chunkId: c.chunkId.toString(),
        ),
      ),
    ),
    createdAt: item.createdAt,
    failureCode: item.failureCode,
  );

  Map<String, dynamic> _encodeStudio(StudyStudioItem item) => {
    'id': item.id,
    'kind': item.kind.name,
    'language': item.language,
    'title': item.title,
    'status': item.status,
    'contentJson': item.contentJson,
    'createdAt': item.createdAt.toUtc().toIso8601String(),
    'failureCode': item.failureCode,
    'citations': [
      for (final c in item.citations)
        {
          'title': c.title,
          'location': c.location,
          'version': c.version,
          'chunkId': c.chunkId,
        },
    ],
  };

  StudyStudioItem _decodeStudio(Map<String, dynamic> value) => StudyStudioItem(
    id: value['id'] as String,
    kind: StudioKind.values.byName(value['kind'] as String),
    language: value['language'] as String,
    title: value['title'] as String,
    status: value['status'] as String,
    contentJson: value['contentJson'] as String,
    createdAt: DateTime.parse(value['createdAt'] as String),
    failureCode: value['failureCode'] as String?,
    citations: [
      for (final c in value['citations'] as List<dynamic>)
        StudyCitation(
          c['title'] as String,
          c['location'] as String?,
          c['version'] as int,
          chunkId: c['chunkId'] as String?,
        ),
    ],
  );

  @override
  Future<List<StudyStudioItem>> studioItems(String notebookId) => _cached(
    'studio:$notebookId',
    () => _request(
      (client) async => (await client.notebook.getStudioItems(
        _id(notebookId),
      )).map(_studio).toList(growable: false),
    ),
    (items) => {'items': items.map(_encodeStudio).toList()},
    (value) => List<StudyStudioItem>.unmodifiable([
      for (final row in value['items'] as List<dynamic>)
        _decodeStudio(row as Map<String, dynamic>),
    ]),
  );

  @override
  Future<void> generateStudio(
    String notebookId,
    StudioKind kind,
    String language,
    String requestKey,
  ) => _request((client) async {
    await client.notebook.generateStudioItem(
      api.NotebookStudioRequest(
        notebookId: _id(notebookId),
        kind: kind.name,
        language: language,
        requestKey: requestKey,
      ),
    );
  });

  @override
  Future<StudyStudioItem> studioItem(String notebookId, String artifactId) =>
      _cached(
        'studioItem:$notebookId:$artifactId',
        () => _request(
          (client) async => _studio(
            await client.notebook.getStudioItem(
              _id(notebookId),
              _id(artifactId),
            ),
          ),
        ),
        _encodeStudio,
        _decodeStudio,
      );

  @override
  Future<String> studioPassage(
    String notebookId,
    String artifactId,
    String chunkId,
  ) => _cached(
    'studioPassage:$notebookId:$artifactId:$chunkId',
    () => _request(
      (client) => client.notebook.getStudioCitationPassage(
        _id(notebookId),
        _id(artifactId),
        _id(chunkId),
      ),
    ),
    (text) => {'text': text},
    (value) => value['text'] as String,
  );

  @override
  Future<StudyAudioAccess> studioAudio(String notebookId, String artifactId) =>
      _request((client) async {
        final access = await client.notebook.getStudioAudioAccess(
          _id(notebookId),
          _id(artifactId),
        );
        return (url: access.url, expiresAt: access.expiresAt);
      });
}
