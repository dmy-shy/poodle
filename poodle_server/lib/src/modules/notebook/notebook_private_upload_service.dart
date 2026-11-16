import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../courses/course_service.dart';
import 'notebook_execution_access.dart';
import 'notebook_repository.dart';

/// Private object paths are generated here; callers never supply a storage key.
class NotebookUploadService {
  final _repository = NotebookRepository();
  Future<({UuidValue userId, NotebookRecord notebook})> _requireNotebookOwner(
    Session session,
    UuidValue notebookId,
  ) async {
    final notebook = await NotebookRecord.db.findById(session, notebookId);
    if (notebook == null) throw NotebookError(code: 'unavailable');
    final access = await CourseService().requireMember(
      session,
      notebook.courseId,
    );
    if (access.membership.role != 'student' ||
        access.membership.authUserId != notebook.ownerUserId) {
      throw NotebookError(code: 'unavailable');
    }
    await NotebookExecutionAccess.require(
      session,
      notebookId,
      notebook.ownerUserId,
    );
    return (userId: notebook.ownerUserId, notebook: notebook);
  }

  NotebookJobStatus _projectJob(NotebookJobRecord job) => NotebookJobStatus(
    id: job.id!,
    status: job.status,
    failureCode: job.failureCode,
    createdAt: job.createdAt,
  );
  static const maximumUploadBytes = 25 * 1024 * 1024;

  Future<NotebookUploadTicket> beginUpload(
    Session session,
    NotebookUploadInput input,
  ) async {
    final owner = await _requireNotebookOwner(session, input.notebookId);
    final name = input.fileName.trim();
    final format = name.split('.').last.toLowerCase();
    if (name.isEmpty ||
        name.length > 180 ||
        RegExp(r'[/\\\x00-\x1f\x7f]').hasMatch(name) ||
        !{'txt', 'md', 'pdf', 'docx'}.contains(format) ||
        input.sizeBytes <= 0 ||
        input.sizeBytes > maximumUploadBytes ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(input.checksum) ||
        !RegExp(r'^[a-zA-Z0-9_-]{16,100}$').hasMatch(input.requestKey)) {
      throw NotebookError(code: 'invalid_upload');
    }
    final private = await session.serverpod.createSession(enableLogging: false);
    try {
      final expiredPaths = <String>[];
      final payload = jsonEncode({
        'fileName': name,
        'format': format,
        'sizeBytes': input.sizeBytes,
        'checksum': input.checksum,
      });
      final job = await private.db.transaction((tx) async {
        await _repository.lock(
          private,
          'course:${owner.notebook.courseId}',
          tx,
        );
        await _repository.lock(private, 'uploads:${owner.userId}', tx);
        await _repository.lock(private, 'notebook:${input.notebookId}', tx);
        final snapshot = await NotebookExecutionAccess.require(
          private,
          input.notebookId,
          owner.userId,
          transaction: tx,
        );
        if (!snapshot.config.allowedFormats.contains(format)) {
          throw NotebookError(code: 'upload_format_not_allowed');
        }
        final key = 'upload:${input.requestKey}';
        final existing = await NotebookJobRecord.db.findFirstRow(
          private,
          where: (t) =>
              t.ownerUserId.equals(owner.userId) & t.requestKey.equals(key),
          transaction: tx,
        );
        if (existing != null) {
          final old = jsonDecode(existing.privatePayload!) as Map;
          if (existing.notebookId != input.notebookId ||
              old['uploadMetadata'] != payload) {
            throw NotebookError(code: 'configuration_conflict');
          }
          return existing;
        }
        // Uploads abandoned before finalization cannot be processed. Reclaim
        // their source slots when this owner next begins an upload.
        final expired = await NotebookJobRecord.db.find(
          private,
          where: (t) =>
              t.ownerUserId.equals(owner.userId) &
              t.status.equals('awaiting_upload') &
              t.requestKey.like('upload:%') &
              (t.createdAt <
                  DateTime.now().toUtc().subtract(const Duration(minutes: 30))),
          transaction: tx,
        );
        for (final old in expired) {
          final oldSource = await NotebookSourceRecord.db.findById(
            private,
            old.sourceId!,
            transaction: tx,
          );
          if (oldSource != null && oldSource.status == 'uploading') {
            await NotebookSourceRecord.db.updateRow(
              private,
              oldSource.copyWith(
                status: 'deleted',
                updatedAt: DateTime.now().toUtc(),
              ),
              transaction: tx,
            );
            await NotebookSourceSelectionRecord.db.deleteWhere(
              private,
              where: (t) => t.sourceId.equals(old.sourceId),
              transaction: tx,
            );
            expiredPaths.add(oldSource.storagePath);
          }
          await NotebookJobRecord.db.updateRow(
            private,
            old.copyWith(
              status: 'failed',
              failureCode: 'upload_expired',
              updatedAt: DateTime.now().toUtc(),
            ),
            transaction: tx,
          );
        }
        final count = await NotebookSourceRecord.db.count(
          private,
          where: (t) =>
              t.ownerUserId.equals(owner.userId) &
              t.status.notEquals('deleted'),
          transaction: tx,
        );
        final recent = await NotebookJobRecord.db.count(
          private,
          where: (t) =>
              t.ownerUserId.equals(owner.userId) &
              t.requestKey.like('upload:%') &
              (t.createdAt >
                  DateTime.now().toUtc().subtract(const Duration(days: 1))),
          transaction: tx,
        );
        if (count >= 20 || recent >= 50) {
          throw NotebookError(code: 'upload_limit');
        }
        final sourceId = const Uuid().v4obj();
        final path =
            'notebook-uploads/${owner.userId}/${input.notebookId}/$sourceId.$format';
        await NotebookSourceRecord.db.insertRow(
          private,
          NotebookSourceRecord(
            id: sourceId,
            courseId: owner.notebook.courseId,
            notebookId: input.notebookId,
            ownerUserId: owner.userId,
            fileName: name,
            format: format,
            storageId: 'private',
            storagePath: path,
            status: 'uploading',
          ),
          transaction: tx,
        );
        await NotebookSourceSelectionRecord.db.insertRow(
          private,
          NotebookSourceSelectionRecord(
            notebookId: input.notebookId,
            sourceId: sourceId,
            selected: true,
            selectedVersion: 0,
          ),
          transaction: tx,
        );
        return NotebookJobRecord.db.insertRow(
          private,
          NotebookJobRecord(
            ownerUserId: owner.userId,
            notebookId: input.notebookId,
            sourceId: sourceId,
            jobType: 'ingest',
            status: 'awaiting_upload',
            requestKey: key,
            privatePayload: jsonEncode({
              'uploadMetadata': payload,
              'checksum': input.checksum,
              'sizeBytes': input.sizeBytes,
              'format': format,
              'storageId': 'private',
              'storagePath': path,
            }),
          ),
          transaction: tx,
        );
      });
      for (final path in expiredPaths) {
        try {
          await private.storage.deleteFile(storageId: 'private', path: path);
        } catch (_) {
          // The abandoned capability is expired and its source is inaccessible.
        }
      }
      final source = await NotebookSourceRecord.db.findById(
        private,
        job.sourceId!,
      );
      if (source == null || source.status == 'deleted') {
        throw NotebookError(code: 'unavailable');
      }
      String? description;
      if (job.status == 'awaiting_upload') {
        if (DateTime.now().toUtc().difference(job.createdAt) >
            const Duration(minutes: 30)) {
          throw NotebookError(code: 'upload_expired');
        }
        if (await private.storage.fileExists(
              storageId: 'private',
              path: source.storagePath,
            ) ||
            await private.storage.verifyUpload(
              storageId: 'private',
              path: source.storagePath,
            )) {
          await finishUpload(session, input.notebookId, job.id!);
          return NotebookUploadTicket(sourceId: source.id!, jobId: job.id!);
        }
        description = await private.storage.createUploadDescription(
          storageId: 'private',
          path: source.storagePath,
          options: UploadOptions(
            expirationDuration: const Duration(minutes: 10),
            maxFileSize: input.sizeBytes,
            contentLength: input.sizeBytes,
            preventOverwrite: true,
          ),
        );
      }
      return NotebookUploadTicket(
        sourceId: source.id!,
        jobId: job.id!,
        uploadDescription: description,
      );
    } finally {
      await private.close();
    }
  }

  Future<NotebookJobStatus> finishUpload(
    Session session,
    UuidValue notebookId,
    UuidValue jobId,
  ) async {
    final owner = await _requireNotebookOwner(session, notebookId);
    final private = await session.serverpod.createSession(enableLogging: false);
    try {
      return await private.db.transaction((tx) async {
        await _repository.lock(
          private,
          'course:${owner.notebook.courseId}',
          tx,
        );
        await _repository.lock(private, 'notebook:$notebookId', tx);
        final snapshot = await NotebookExecutionAccess.require(
          private,
          notebookId,
          owner.userId,
          transaction: tx,
        );
        final job = await NotebookJobRecord.db.findById(
          private,
          jobId,
          transaction: tx,
        );
        if (job == null ||
            job.ownerUserId != owner.userId ||
            job.notebookId != notebookId ||
            !job.requestKey.startsWith('upload:')) {
          throw NotebookError(code: 'unavailable');
        }
        final source = await NotebookSourceRecord.db.findById(
          private,
          job.sourceId!,
          transaction: tx,
        );
        if (source == null ||
            source.status == 'deleted' ||
            source.ownerUserId != owner.userId ||
            source.notebookId != notebookId) {
          throw NotebookError(code: 'unavailable');
        }
        if (!snapshot.config.allowedFormats.contains(source.format)) {
          throw NotebookError(code: 'upload_format_not_allowed');
        }
        if (job.status != 'awaiting_upload') return _projectJob(job);
        if (DateTime.now().toUtc().difference(job.createdAt) >
            const Duration(minutes: 30)) {
          throw NotebookError(code: 'upload_expired');
        }
        if (!await private.storage.verifyUpload(
              storageId: 'private',
              path: source.storagePath,
            ) &&
            !await private.storage.fileExists(
              storageId: 'private',
              path: source.storagePath,
            )) {
          throw NotebookError(code: 'upload_incomplete');
        }
        final metadata = jsonDecode(job.privatePayload!) as Map;
        final stat = await private.storage.statFile(
          storageId: 'private',
          path: source.storagePath,
        );
        if (stat.size != metadata['sizeBytes'] ||
            stat.size > maximumUploadBytes) {
          throw NotebookError(code: 'invalid_upload');
        }
        await NotebookSourceRecord.db.updateRow(
          private,
          source.copyWith(status: 'queued', updatedAt: DateTime.now().toUtc()),
          transaction: tx,
        );
        final updated = await NotebookJobRecord.db.updateRow(
          private,
          job.copyWith(status: 'queued', updatedAt: DateTime.now().toUtc()),
          transaction: tx,
        );
        return _projectJob(updated);
      });
    } finally {
      await private.close();
    }
  }

  Future<void> removeUpload(
    Session session,
    UuidValue notebookId,
    UuidValue sourceId,
  ) async {
    final owner = await _requireNotebookOwner(session, notebookId);
    final private = await session.serverpod.createSession(enableLogging: false);
    try {
      final source = await private.db.transaction((tx) async {
        await _repository.lock(
          private,
          'course:${owner.notebook.courseId}',
          tx,
        );
        await _repository.lock(private, 'notebook:$notebookId', tx);
        final source = await NotebookSourceRecord.db.findById(
          private,
          sourceId,
          transaction: tx,
        );
        if (source == null ||
            source.ownerUserId != owner.userId ||
            source.notebookId != notebookId ||
            source.activityId != null) {
          throw NotebookError(code: 'unavailable');
        }
        await NotebookChunkRecord.db.deleteWhere(
          private,
          where: (t) => t.sourceId.equals(sourceId),
          transaction: tx,
        );
        await NotebookSourceVersionRecord.db.deleteWhere(
          private,
          where: (t) => t.sourceId.equals(sourceId),
          transaction: tx,
        );
        await NotebookSourceSelectionRecord.db.deleteWhere(
          private,
          where: (t) =>
              t.notebookId.equals(notebookId) & t.sourceId.equals(sourceId),
          transaction: tx,
        );
        return NotebookSourceRecord.db.updateRow(
          private,
          source.copyWith(status: 'deleted', updatedAt: DateTime.now().toUtc()),
          transaction: tx,
        );
      });
      await private.storage.deleteFile(
        storageId: 'private',
        path: source.storagePath,
      );
    } finally {
      await private.close();
    }
  }
}
