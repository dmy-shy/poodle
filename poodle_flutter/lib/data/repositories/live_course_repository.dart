import 'dart:async';
import '../../server_url.dart';
import 'package:flutter/foundation.dart';
import 'package:poodle_client/poodle_client.dart' as api;
import 'account_course_cache.dart';
import 'auth_repository.dart';
import 'course_repository.dart';
import '../services/serverpod_auth_gateway.dart';

class ServerpodCourseRepository extends CourseRepository {
  @override
  bool get listIsStale => _listIsStale;
  @override
  DateTime? get listRefreshedAt => _listRefreshedAt;
  bool _listIsStale = false;
  DateTime? _listRefreshedAt;
  final _contentStale = <String, bool>{};
  final _contentRefreshedAt = <String, DateTime>{};
  @override
  bool contentIsStale(String id) => _contentStale[id] ?? false;
  @override
  DateTime? contentRefreshedAt(String id) => _contentRefreshedAt[id];
  String? _account;
  Future<void> _cacheTail = Future<void>.value();
  late final AccountCourseCache _cache = AccountCourseCache(
    namespace: _gateway.serverIdentity,
  );
  @override
  void bindAccount(String? account) {
    super.bindAccount(account);
    _account = account;
    _listIsStale = false;
    _listRefreshedAt = null;
    _contentStale.clear();
    _contentRefreshedAt.clear();
  }

  @override
  void clear() {
    final old = _account;
    _account = null;
    _listIsStale = false;
    _listRefreshedAt = null;
    _contentStale.clear();
    _contentRefreshedAt.clear();
    super.clear();
    if (old != null && !kIsWeb) {
      _cacheTail = _cacheTail.catchError((_) {}).then((_) => _cache.purge(old));
      unawaited(_cacheTail.catchError((_) {}));
    }
  }

  @override
  bool get supportsPreferences => true;
  @override
  String get cacheNamespace => _gateway.serverIdentity;
  ServerpodCourseRepository(this._gateway);
  final ServerpodAuthGateway _gateway;
  Future<T> _read<T>(Future<T> Function(api.Client client) read) async {
    final start = generation;
    final result = await _gateway
        .withClient((client) async {
          try {
            return await read(client);
          } on api.CourseReadException {
            throw CourseFailure.unavailable;
          }
        })
        .catchError((Object error) {
          if (error is CourseFailure) throw error;
          if (error == AuthFailure.network) throw CourseFailure.network;
          throw CourseFailure.unavailable;
        });
    if (start != generation) throw CourseFailure.cancelled;
    return result;
  }

  api.UuidValue _id(String value) {
    if (!validCourseId(value)) throw CourseFailure.unavailable;
    return api.UuidValue.withValidation(value);
  }

  CourseInfo _course(api.CourseSummary value) => CourseInfo(
    id: value.id.toString(),
    role: value.role,
    title: value.title,
    category: value.category,
    summary: value.summary,
    teacherName: value.teacherName,
    sample: value.sample,
    starred: value.starred,
    hidden: value.hidden,
  );
  @override
  Future<CourseInfo> setStarred(String id, bool starred) => _read(
    (client) async => _course(await client.course.setStarred(_id(id), starred)),
  );
  @override
  Future<CourseInfo> setHidden(String id, bool hidden) => _read(
    (client) async => _course(await client.course.setHidden(_id(id), hidden)),
  );
  CourseActivity _activity(api.CourseActivity v) => CourseActivity(
    id: v.id.toString(),
    courseId: v.courseId.toString(),
    title: v.title,
    description: v.description,
    kind: ActivityKind.values.byName(v.kind),
    draft: v.draft,
    managedAssessment: v.managedAssessment,
    file: v.file == null
        ? null
        : CourseFile(
            name: v.file!.fileName,
            mimeType: v.file!.mimeType,
            sizeBytes: v.file!.sizeBytes,
            checksum: v.file!.checksum,
          ),
    url: v.link?.url,
    body: v.announcement?.body,
    author: v.announcement?.author,
    publishedAt: v.announcement?.publishedAt,
    instructions: v.assessment?.instructions,
    opensAt: v.assessment?.opensAt,
    closesAt: v.assessment?.closesAt,
    attemptLimit: v.assessment?.attemptLimit,
    timeLimitMinutes: v.assessment?.timeLimitMinutes,
    availability: v.availability,
    previousId: v.previousId?.toString(),
    nextId: v.nextId?.toString(),
  );
  @override
  Future<List<CourseInfo>> list() async {
    final account = _account;
    final epoch = generation;
    try {
      final courses = await _read(
        (client) async => (await client.course.listMyCourses())
            .map(_course)
            .toList(growable: false),
      );
      if (account == null || epoch != generation) throw CourseFailure.cancelled;
      final refreshedAt = DateTime.now().toUtc();
      try {
        if (kIsWeb) return courses;
        final write = _cacheTail.catchError((_) {}).then((_) async {
          if (epoch == generation) {
            await _cache.write(account, courses, refreshedAt);
          }
        });
        _cacheTail = write.catchError((_) {});
        await write;
        if (epoch == generation) _listRefreshedAt = refreshedAt;
      } catch (_) {
        // A working server read must not fail because local storage is full.
      }
      if (epoch != generation) throw CourseFailure.cancelled;
      _listIsStale = false;
      return courses;
    } on CourseFailure catch (error) {
      if (error != CourseFailure.network ||
          account == null ||
          epoch != generation ||
          kIsWeb) {
        rethrow;
      }
      await _cacheTail.catchError((_) {});
      if (epoch != generation) throw CourseFailure.cancelled;
      final cached = await _cache.read(account);
      if (epoch != generation) throw CourseFailure.cancelled;
      if (cached == null) rethrow;
      _listIsStale = true;
      _listRefreshedAt = cached.refreshedAt;
      return cached.courses;
    }
  }

  @override
  Future<CourseContent> content(String id) async {
    final courseId = _id(id);
    final account = _account;
    final epoch = generation;
    try {
      final content = await _read((client) async {
        late final api.CourseDetail v;
        try {
          v = await client.courseContent.getCourseContent(courseId);
        } on api.CourseReadException {
          if (account != null && !kIsWeb && epoch == generation) {
            await _cacheTail.catchError((_) {});
            await _cache.removeContent(account, id);
          }
          rethrow;
        }
        return CourseContent(
          course: _course(v.course),
          teacherView: v.teacherView,
          serverTime: v.serverTime,
          sections: v.sections
              .map(
                (s) => ContentSection(
                  id: s.id.toString(),
                  title: s.title,
                  description: s.description,
                  draft: s.draft,
                  activities: s.activities.map(_activity).toList(),
                ),
              )
              .toList(),
        );
      });
      if (account == null || epoch != generation) throw CourseFailure.cancelled;
      final refreshedAt = DateTime.now().toUtc();
      if (!kIsWeb) {
        try {
          final write = _cacheTail.catchError((_) {}).then((_) async {
            if (epoch == generation) {
              await _cache.writeContent(account, content, refreshedAt);
            }
          });
          _cacheTail = write.catchError((_) {});
          await write;
        } catch (_) {
          // A successful server response remains usable if local storage fails.
        }
      }
      if (epoch != generation) throw CourseFailure.cancelled;
      _contentStale[id] = false;
      _contentRefreshedAt[id] = refreshedAt;
      return content;
    } on CourseFailure catch (error) {
      if (error != CourseFailure.network ||
          account == null ||
          epoch != generation ||
          kIsWeb) {
        rethrow;
      }
      await _cacheTail.catchError((_) {});
      if (epoch != generation) throw CourseFailure.cancelled;
      final saved = await _cache.readContent(account, id);
      if (epoch != generation) throw CourseFailure.cancelled;
      if (saved == null) rethrow;
      _contentStale[id] = true;
      _contentRefreshedAt[id] = saved.refreshedAt;
      return saved.content;
    }
  }

  @override
  Future<CourseActivity> activity(String courseId, String id) async {
    final c = _id(courseId), a = _id(id);
    final account = _account;
    final epoch = generation;
    try {
      final result = await _read((client) async {
        try {
          return _activity(await client.courseContent.getActivity(c, a));
        } on api.CourseReadException {
          if (account != null && !kIsWeb && epoch == generation) {
            await _cacheTail.catchError((_) {});
            await _cache.removeContent(account, courseId);
          }
          rethrow;
        }
      });
      if (epoch != generation) throw CourseFailure.cancelled;
      _contentStale[courseId] = false;
      return result;
    } on CourseFailure catch (error) {
      if (error != CourseFailure.network) rethrow;
      if (epoch != generation) throw CourseFailure.cancelled;
      final cached = await content(courseId);
      final item = cached.sections
          .expand((s) => s.activities)
          .where((a) => a.id == id)
          .firstOrNull;
      if (item == null) throw CourseFailure.unavailable;
      return item;
    }
  }

  @override
  Future<FileAccess> file(String courseId, String id) {
    final c = _id(courseId), a = _id(id);
    return _read((client) async {
      final value = await client.courseContent.getFileUrl(c, a);
      return FileAccess(
        resolveDownloadUrl(
          downloadUrl: value.url,
          serverUrl: _gateway.serverIdentity,
        ),
        value.expiresAt,
      );
    });
  }
}
