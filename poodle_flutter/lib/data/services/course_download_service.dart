import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_async/sqlite_async.dart';

import '../repositories/course_repository.dart';
import 'course_file_service.dart';

class DownloadedCourseFile {
  const DownloadedCourseFile({
    required this.courseId,
    required this.activityId,
    required this.title,
    required this.path,
    required this.sizeBytes,
    this.checksum = '',
    this.courseTitle = '',
  });
  final String courseId, activityId, title, path, courseTitle;
  final int sizeBytes;
  final String checksum;
}

/// Explicit mobile downloads. Each completed file is published atomically.
class CourseDownloadService extends ChangeNotifier {
  CourseDownloadService({
    required this.courses,
    required this.files,
    required this.namespace,
    this.root,
  });
  final CourseRepository courses;
  final CourseFileService files;
  final String namespace;
  final Directory? root;
  bool wifiOnlyDownloads = false;
  String? _account;
  int _generation = 0;
  String? get currentAccount => _account;
  int get generation => _generation;
  Completer<void>? _activeDownload;
  Future<void> _cleanup = Future<void>.value();

  void bindAccount(String? account) {
    final epoch = ++_generation;
    _account = account;
    _cleanup = account == null ? Future<void>.value() : _sweep(account, epoch);
    notifyListeners();
  }

  void cancel() {
    _generation++;
  }

  Future<void> _sweep(String account, int epoch) async {
    final dir = await _directory(account);
    if (!await dir.exists() || epoch != _generation) return;
    final db = await _open(account);
    final names = <String>{};
    try {
      for (final row in await db.getAll('SELECT file_name FROM files')) {
        names.add(row['file_name'] as String);
      }
    } finally {
      await db.close();
    }
    await for (final entity in dir.list()) {
      if (epoch != _generation) return;
      if (entity is! File) continue;
      final name = entity.uri.pathSegments.last;
      if (name.endsWith('.partial') ||
          (RegExp(r'^[a-f0-9]{64}\.(pdf|docx|md)$').hasMatch(name) &&
              !names.contains(name))) {
        await entity.delete();
      }
    }
  }

  Future<Directory> _directory(String account) async {
    final base =
        root ??
        Directory(
          '${(await getApplicationSupportDirectory()).path}/poodle-downloads',
        );
    final key = sha256.convert(utf8.encode('$namespace:$account'));
    return Directory('${base.path}/$key');
  }

  Future<SqliteDatabase> _open(String account) async {
    final dir = await _directory(account);
    await dir.create(recursive: true);
    final db = SqliteDatabase(path: '${dir.path}/manifest.sqlite');
    await db.execute(
      "CREATE TABLE IF NOT EXISTS files (activity_id TEXT PRIMARY KEY, course_id TEXT NOT NULL, title TEXT NOT NULL, file_name TEXT NOT NULL, size_bytes INTEGER NOT NULL, checksum TEXT NOT NULL DEFAULT '')",
    );
    final columns = await db.getAll('PRAGMA table_info(files)');
    if (!columns.any((row) => row['name'] == 'checksum')) {
      await db.execute(
        "ALTER TABLE files ADD COLUMN checksum TEXT NOT NULL DEFAULT ''",
      );
    }
    if (!columns.any((row) => row['name'] == 'course_title')) {
      await db.execute(
        "ALTER TABLE files ADD COLUMN course_title TEXT NOT NULL DEFAULT ''",
      );
    }
    return db;
  }

  Future<List<DownloadedCourseFile>> list() async {
    await _cleanup;
    final account = _account;
    final epoch = _generation;
    if (account == null) return [];
    final dir = await _directory(account);
    if (!await dir.exists()) return [];
    final db = await _open(account);
    try {
      final rows = await db.getAll(
        'SELECT activity_id, course_id, course_title, title, file_name, size_bytes, checksum FROM files ORDER BY title',
      );
      final result = <DownloadedCourseFile>[];
      for (final row in rows) {
        final name = row['file_name'] as String;
        if (!RegExp(r'^[a-f0-9]{64}\.(pdf|docx|md)$').hasMatch(name)) continue;
        final path = '${dir.path}/$name';
        result.add(
          DownloadedCourseFile(
            courseId: row['course_id'] as String,
            activityId: row['activity_id'] as String,
            title: row['title'] as String,
            path: path,
            sizeBytes: row['size_bytes'] as int,
            checksum: row['checksum'] as String,
            courseTitle: row['course_title'] as String,
          ),
        );
      }
      if (epoch != _generation) throw CourseFailure.cancelled;
      return result;
    } finally {
      await db.close();
    }
  }

  Future<String?> pathFor(String activityId) async {
    for (final item in await list()) {
      if (item.activityId == activityId) return validatedPath(item);
    }
    return null;
  }

  Future<String?> validatedPath(DownloadedCourseFile item) async {
    await _cleanup;
    final account = _account;
    final epoch = _generation;
    if (account == null) return null;
    final dir = await _directory(account);
    if (!await dir.exists()) return null;
    final db = await _open(account);
    try {
      final rows = await db.getAll(
        'SELECT course_id, file_name, size_bytes, checksum FROM files WHERE activity_id = ?',
        [item.activityId],
      );
      if (rows.length != 1) return null;
      final row = rows.single;
      final name = row['file_name'] as String;
      if (row['course_id'] != item.courseId ||
          row['size_bytes'] != item.sizeBytes ||
          row['checksum'] != item.checksum ||
          !RegExp(r'^[a-f0-9]{64}\.(pdf|docx|md)$').hasMatch(name) ||
          item.path != '${dir.path}/$name') {
        return null;
      }
    } finally {
      await db.close();
    }
    final file = File(item.path);
    if (!await file.exists() || await file.length() != item.sizeBytes) {
      return null;
    }
    if (item.checksum.isNotEmpty &&
        (await sha256.bind(file.openRead()).first).toString() !=
            item.checksum) {
      return null;
    }
    if (epoch != _generation || account != _account) return null;
    return item.path;
  }

  Future<void> reconcileInventory(List<CourseInfo> authorized) async {
    final allowed = authorized.map((c) => c.id).toSet();
    final saved = await list();
    for (final id in saved.map((f) => f.courseId).toSet().difference(allowed)) {
      await removeCourse(id);
    }
  }

  Future<void> reconcileContent(CourseContent detail) async {
    await _reconcileContent(detail);
  }

  Future<void> _reconcileContent(
    CourseContent detail, {
    bool refreshing = false,
  }) async {
    final account = _account;
    final allowed = detail.sections
        .where((s) => !s.draft)
        .expand((s) => s.activities)
        .where((a) => !a.draft && a.file != null)
        .map((a) => a.id)
        .toSet();
    for (final item in await list()) {
      if (account != _account) throw CourseFailure.cancelled;
      if (item.courseId == detail.course.id &&
          !allowed.contains(item.activityId)) {
        await _removeActivity(item.activityId, refreshing: refreshing);
      }
    }
  }

  /// Returns saved activity IDs whose authorized server version changed.
  Future<Set<String>> changedFiles(String courseId) async {
    final epoch = _generation;
    final detail = await courses.content(courseId);
    if (epoch != _generation) throw CourseFailure.cancelled;
    if (courses.contentIsStale(courseId)) throw CourseFailure.network;
    return _changedFiles(detail, epoch);
  }

  Future<Set<String>> _changedFiles(CourseContent detail, int epoch) async {
    final courseId = detail.course.id;
    final current = {
      for (final section in detail.sections.where((section) => !section.draft))
        for (final activity in section.activities.where(
          (activity) => !activity.draft && activity.file != null,
        ))
          activity.id: activity.file!,
    };
    final saved = (await list()).where((item) => item.courseId == courseId);
    if (epoch != _generation) throw CourseFailure.cancelled;
    final changed = {
      for (final item in saved)
        if (current[item.activityId] case final file?)
          if ((file.checksum.isNotEmpty && file.checksum != item.checksum) ||
              file.sizeBytes != item.sizeBytes ||
              await validatedPath(item) == null)
            item.activityId,
    };
    if (epoch != _generation) throw CourseFailure.cancelled;
    return changed;
  }

  Future<List<DownloadedCourseFile>> refreshDownloadedFiles(
    String courseId, {
    void Function(int done, int total)? onProgress,
  }) async {
    if (_activeDownload != null) throw CourseFailure.cancelled;
    final active = Completer<void>();
    _activeDownload = active;
    final epoch = _generation;
    try {
      await _cleanup;
      await _requireWifi();
      return await _withWifiWatch(() async {
        if (epoch != _generation) throw CourseFailure.cancelled;
        final detail = await courses.content(courseId);
        if (epoch != _generation) throw CourseFailure.cancelled;
        if (courses.contentIsStale(courseId)) throw CourseFailure.network;
        await _reconcileContent(detail, refreshing: true);
        final changed = await _changedFiles(detail, epoch);
        await _requireWifi();
        if (epoch != _generation) throw CourseFailure.cancelled;
        if (changed.isEmpty) {
          onProgress?.call(1, 1);
          return (await list())
              .where((item) => item.courseId == courseId)
              .toList();
        }
        return _downloadFiles(
          courseId,
          onProgress: onProgress,
          activityIds: changed,
        );
      });
    } finally {
      _activeDownload = null;
      active.complete();
    }
  }

  Future<void> _removeActivity(
    String activityId, {
    bool refreshing = false,
  }) async {
    final account = _account;
    if (!refreshing && _activeDownload != null) {
      cancel();
      await _activeDownload!.future;
    }
    if (account == null || account != _account) throw CourseFailure.cancelled;
    final dir = await _directory(account);
    final db = await _open(account);
    try {
      final rows = await db.getAll(
        'SELECT file_name FROM files WHERE activity_id = ?',
        [activityId],
      );
      await db.execute('DELETE FROM files WHERE activity_id = ?', [activityId]);
      for (final row in rows) {
        final name = row['file_name'] as String;
        if (RegExp(r'^[a-f0-9]{64}\.(pdf|docx|md)$').hasMatch(name)) {
          final file = File('${dir.path}/$name');
          if (await file.exists()) await file.delete();
        }
      }
    } finally {
      await db.close();
    }
  }

  Future<List<DownloadedCourseFile>> downloadCourse(
    String courseId, {
    void Function(int done, int total)? onProgress,
  }) async {
    if (_activeDownload != null) throw CourseFailure.cancelled;
    final active = Completer<void>();
    _activeDownload = active;
    try {
      return await _downloadCourse(courseId, onProgress: onProgress);
    } finally {
      _activeDownload = null;
      active.complete();
    }
  }

  Future<List<DownloadedCourseFile>> _downloadCourse(
    String courseId, {
    void Function(int done, int total)? onProgress,
  }) async {
    await _cleanup;
    await _requireWifi();
    return _withWifiWatch(
      () => _downloadFiles(courseId, onProgress: onProgress),
    );
  }

  Future<T> _withWifiWatch<T>(Future<T> Function() operation) async {
    StreamSubscription<List<ConnectivityResult>>? wifiWatch;
    var wifiLost = false;
    if (wifiOnlyDownloads) {
      wifiWatch = Connectivity().onConnectivityChanged.listen((transports) {
        if (!transports.contains(ConnectivityResult.wifi)) {
          wifiLost = true;
          cancel();
        }
      });
    }
    try {
      return await operation();
    } on CourseFailure catch (error) {
      if (wifiLost && error == CourseFailure.cancelled) {
        throw CourseFailure.wifiRequired;
      }
      rethrow;
    } finally {
      await wifiWatch?.cancel();
    }
  }

  Future<void> _requireWifi() async {
    if (!wifiOnlyDownloads) return;
    try {
      final transports = await Connectivity().checkConnectivity();
      if (!transports.contains(ConnectivityResult.wifi)) {
        throw CourseFailure.wifiRequired;
      }
    } on CourseFailure {
      rethrow;
    } catch (_) {
      throw CourseFailure.network;
    }
  }

  Future<List<DownloadedCourseFile>> _downloadFiles(
    String courseId, {
    void Function(int done, int total)? onProgress,
    Set<String>? activityIds,
  }) async {
    final account = _account;
    final epoch = _generation;
    if (account == null) throw CourseFailure.cancelled;
    final detail = await courses.content(courseId);
    if (epoch != _generation) throw CourseFailure.cancelled;
    final activities = detail.sections
        .where((s) => !s.draft)
        .expand((s) => s.activities)
        .where(
          (a) =>
              !a.draft &&
              a.file?.supportsOfflineCopy == true &&
              (activityIds == null || activityIds.contains(a.id)),
        )
        .toList();
    if (activities.isEmpty) return [];
    final dir = await _directory(account);
    await dir.create(recursive: true);
    var done = 0;
    for (final activity in activities) {
      await _requireWifi();
      if (epoch != _generation) throw CourseFailure.cancelled;
      late final FileAccess access;
      late final String source;
      try {
        access = await courses.file(courseId, activity.id);
        if (epoch != _generation) throw CourseFailure.cancelled;
        source = await files.prepare(activity.file!, access);
      } catch (_) {
        if (epoch != _generation) throw CourseFailure.cancelled;
        rethrow;
      }
      if (epoch != _generation) throw CourseFailure.cancelled;
      final extension = switch (activity.file!.mimeType) {
        'application/pdf' => 'pdf',
        'text/markdown' => 'md',
        _ => 'docx',
      };
      final digest = sha256.convert(
        utf8.encode('$courseId:${activity.id}:${activity.file!.checksum}'),
      );
      final name = '$digest.$extension';
      final staged = File('${dir.path}/$name.partial');
      final target = File('${dir.path}/$name');
      try {
        await File(source).copy(staged.path);
        final length = await staged.length();
        final actual = await sha256.bind(staged.openRead()).first;
        if (epoch != _generation) throw CourseFailure.cancelled;
        if (length == 0 ||
            (activity.file!.sizeBytes > 0 &&
                length != activity.file!.sizeBytes) ||
            (activity.file!.checksum.isNotEmpty &&
                actual.toString() != activity.file!.checksum)) {
          throw CourseFailure.file;
        }
        await staged.rename(target.path);
        final db = await _open(account);
        try {
          if (epoch != _generation) throw CourseFailure.cancelled;
          final previous = await db.getAll(
            'SELECT file_name FROM files WHERE activity_id = ?',
            [activity.id],
          );
          await db.execute(
            'INSERT OR REPLACE INTO files (activity_id, course_id, course_title, title, file_name, size_bytes, checksum) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [
              activity.id,
              courseId,
              detail.course.title,
              activity.title,
              name,
              length,
              actual.toString(),
            ],
          );
          if (previous.isNotEmpty) {
            final oldName = previous.single['file_name'] as String;
            if (oldName != name &&
                RegExp(r'^[a-f0-9]{64}\.(pdf|docx|md)$').hasMatch(oldName)) {
              final old = File('${dir.path}/$oldName');
              if (await old.exists()) await old.delete();
            }
          }
        } finally {
          await db.close();
        }
        done++;
        onProgress?.call(done, activities.length);
      } finally {
        if (await staged.exists()) await staged.delete();
      }
    }
    if (epoch != _generation) throw CourseFailure.cancelled;
    return (await list()).where((f) => f.courseId == courseId).toList();
  }

  Future<void> removeCourse(String courseId) async {
    if (_activeDownload != null) {
      cancel();
      await _activeDownload!.future;
    }
    await _cleanup;
    final account = _account;
    final epoch = _generation;
    if (account == null) throw CourseFailure.cancelled;
    final dir = await _directory(account);
    if (!await dir.exists()) return;
    final db = await _open(account);
    try {
      if (epoch != _generation) throw CourseFailure.cancelled;
      final rows = await db.getAll(
        'SELECT file_name FROM files WHERE course_id = ?',
        [courseId],
      );
      await db.execute('DELETE FROM files WHERE course_id = ?', [courseId]);
      for (final row in rows) {
        final name = row['file_name'] as String;
        if (RegExp(r'^[a-f0-9]{64}\.(pdf|docx|md)$').hasMatch(name)) {
          final file = File('${dir.path}/$name');
          if (await file.exists()) await file.delete();
        }
      }
    } finally {
      await db.close();
    }
  }

  Future<void> purge(String account) async {
    final cleanup = _cleanup;
    if (_account == account) bindAccount(null);
    await cleanup.catchError((_) {});
    await _activeDownload?.future;
    final dir = await _directory(account);
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}
