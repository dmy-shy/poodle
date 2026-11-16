import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../data/repositories/course_repository.dart';
import '../../../../data/services/course_file_service.dart';
import '../../../../data/services/course_download_service.dart';
import '../../../../data/services/course_link_policy.dart';

@immutable
class CourseViewState {
  const CourseViewState({
    this.courses,
    this.value,
    this.activity,
    this.failure,
    this.busy = false,
    this.pdfPath,
    this.markdown,
    this.opening = false,
    this.openFailure,
  });
  final List<CourseInfo>? courses;
  final CourseContent? value;
  final CourseActivity? activity;
  final CourseFailure? failure, openFailure;
  final bool busy, opening;
  final String? pdfPath, markdown;
}

/// Each route owns a model; repository invalidation clears retained shell views.
class CourseViewModel extends ChangeNotifier {
  CourseViewModel(
    this.repository, {
    this.courseId,
    this.activityId,
    this.files,
    this.downloads,
  }) {
    repository.addListener(_clear);
  }
  final CourseRepository repository;
  final CourseFileService? files;
  final CourseDownloadService? downloads;
  String? downloadingCourseId;
  int downloadDone = 0, downloadTotal = 0;
  CourseFailure? downloadFailure;
  final downloadedCourseIds = <String>{};

  Future<int> downloadBytes(String id) async {
    final detail = await repository.content(id);
    final files = detail.sections
        .where((s) => !s.draft)
        .expand((s) => s.activities)
        .where((a) => !a.draft && a.file?.supportsOfflineCopy == true);
    return files.fold<int>(0, (sum, a) => sum + a.file!.sizeBytes);
  }

  Future<void> refreshDownloads() async {
    if (downloads == null) return;
    final saved = await downloads!.list();
    if (_disposed) return;
    downloadedCourseIds
      ..clear()
      ..addAll(saved.map((f) => f.courseId));
    notifyListeners();
  }

  Future<bool> downloadCourse(String id) async {
    if (downloads == null || downloadingCourseId != null) return false;
    downloadingCourseId = id;
    downloadDone = downloadTotal = 0;
    downloadFailure = null;
    notifyListeners();
    try {
      await downloads!.downloadCourse(
        id,
        onProgress: (done, total) {
          if (_disposed) return;
          downloadDone = done;
          downloadTotal = total;
          notifyListeners();
        },
      );
      await refreshDownloads();
      return true;
    } on CourseFailure catch (error) {
      downloadFailure = error;
      return false;
    } catch (_) {
      downloadFailure = CourseFailure.file;
      return false;
    } finally {
      downloadingCourseId = null;
      if (!_disposed) notifyListeners();
    }
  }

  void cancelDownload() => downloads?.cancel();
  String? pdfPath, markdown;
  bool opening = false;
  CourseFailure? openFailure;
  final String? courseId, activityId;
  List<CourseInfo>? courses;
  CourseContent? value;
  CourseActivity? activity;
  CourseFailure? failure;
  bool busy = false;
  CourseViewState get state => CourseViewState(
    courses: courses,
    value: value,
    activity: activity,
    failure: failure,
    busy: busy,
    pdfPath: pdfPath,
    markdown: markdown,
    opening: opening,
    openFailure: openFailure,
  );
  bool _disposed = false;
  Future<void> setStarred(CourseInfo course) async {
    try {
      await repository.setStarred(course.id, !course.starred);
      await load();
    } on CourseFailure catch (error) {
      failure = error;
      notifyListeners();
    }
  }

  Future<void> setHidden(CourseInfo course) async {
    try {
      await repository.setHidden(course.id, !course.hidden);
      await load();
    } on CourseFailure catch (error) {
      failure = error;
      notifyListeners();
    }
  }

  int _request = 0;
  void _clear() {
    _request++;
    courses = null;
    value = null;
    activity = null;
    failure = null;
    busy = false;
    pdfPath = null;
    markdown = null;
    opening = false;
    openFailure = null;
    if (!_disposed) notifyListeners();
    if (!_disposed && repository.sessionActive) unawaited(load());
  }

  Future<Uri?> open() async {
    final item = activity;
    if (opening || item == null || _disposed) return null;
    final request = _request;
    opening = true;
    openFailure = null;
    notifyListeners();
    try {
      if (item.kind == ActivityKind.link) {
        final current = await repository.activity(item.courseId, item.id);
        if (_disposed || request != _request) return null;
        if (current.kind != ActivityKind.link ||
            current.id != item.id ||
            current.courseId != item.courseId ||
            current.url != item.url) {
          throw CourseFailure.unavailable;
        }
        final uri = courseLinkUri(current.url);
        if (uri == null) throw CourseFailure.file;
        return uri;
      } else {
        if (files == null) throw CourseFailure.file;
        final file = item.file!;
        final saved = await downloads?.pathFor(item.id);
        if (_disposed || request != _request) return null;
        final path =
            saved ??
            await files!.prepare(
              file,
              await repository.file(item.courseId, item.id),
            );
        if (_disposed || request != _request) return null;
        if (file.mimeType == 'application/pdf') {
          pdfPath = path;
        } else if (file.mimeType == 'text/markdown') {
          final value = await File(path).readAsString();
          if (_disposed || request != _request) return null;
          markdown = value;
        } else {
          await files!.openDocument(path);
        }
      }
    } on CourseFailure catch (error) {
      if (!_disposed && request == _request) openFailure = error;
    } catch (_) {
      if (!_disposed && request == _request) openFailure = CourseFailure.file;
    } finally {
      if (!_disposed && request == _request) {
        opening = false;
        notifyListeners();
      }
    }
    return null;
  }

  Future<void> load() async {
    if (busy || _disposed) return;
    if ((courseId != null && !validCourseId(courseId!)) ||
        (activityId != null && !validCourseId(activityId!))) {
      failure = CourseFailure.unavailable;
      notifyListeners();
      return;
    }
    final request = ++_request;
    pdfPath = null;
    markdown = null;
    busy = true;
    failure = null;
    notifyListeners();
    try {
      if (courseId == null) {
        final result = await repository.list();
        if (_disposed || request != _request) return;
        if (downloads != null && !repository.listIsStale) {
          try {
            await downloads!.reconcileInventory(result);
          } catch (_) {}
          if (_disposed || request != _request) return;
        }
        courses = List.unmodifiable(result);
        unawaited(refreshDownloads().catchError((_) {}));
      } else if (activityId == null) {
        final result = await repository.content(courseId!);
        if (_disposed || request != _request) return;
        if (downloads != null && !repository.contentIsStale(courseId!)) {
          try {
            await downloads!.reconcileContent(result);
          } catch (_) {}
          if (_disposed || request != _request) return;
        }
        value = result;
      } else {
        final result = await repository.activity(courseId!, activityId!);
        if (_disposed || request != _request) return;
        activity = result;
      }
    } on CourseFailure catch (error) {
      if (_disposed || request != _request) return;
      failure = error;
      value = null;
      activity = null;
      courses = null;
    } catch (_) {
      if (_disposed || request != _request) return;
      failure = CourseFailure.network;
      value = null;
      activity = null;
      courses = null;
    } finally {
      if (!_disposed && request == _request) {
        busy = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _request++;
    repository.removeListener(_clear);
    super.dispose();
  }
}
