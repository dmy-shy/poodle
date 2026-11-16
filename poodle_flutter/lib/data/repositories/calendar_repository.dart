import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'course_repository.dart';
import 'account_notebook_cache.dart';

enum CalendarMoment { opening, closing }

@immutable
class CalendarEvent {
  const CalendarEvent({
    required this.activity,
    required this.course,
    required this.moment,
    required this.atUtc,
  });
  final CourseActivity activity;
  final CourseInfo course;
  final CalendarMoment moment;
  final DateTime atUtc;
  String get id => '${activity.id}:${moment.name}';
}

@immutable
class CalendarSnapshot {
  CalendarSnapshot({
    required List<CalendarEvent> events,
    required this.serverTimeUtc,
    this.stale = false,
  }) : events = List.unmodifiable(events);
  final List<CalendarEvent> events;
  final DateTime serverTimeUtc;
  final bool stale;
}

class CalendarRepository extends ChangeNotifier {
  CalendarRepository(
    this._courses, {
    this.preview = false,
    AccountNotebookCache? cache,
  }) {
    _cache =
        cache ??
        AccountNotebookCache(
          namespace: '${_courses.cacheNamespace ?? 'preview'}:calendar',
        );
  }
  final CourseRepository _courses;
  late final AccountNotebookCache _cache;
  final bool preview;
  String? _account;
  int _generation = 0;
  CalendarSnapshot? _snapshot;
  CalendarSnapshot? get snapshot => _snapshot;

  void bindAccount(String? account) {
    if (_account == account) return;
    final old = _account;
    _account = account;
    _generation++;
    _snapshot = null;
    notifyListeners();
    if (old != null) {
      unawaited(_removeCache(old));
    }
    if (account != null && !preview) load();
  }

  String _key(String account) {
    final scope = '${_courses.cacheNamespace ?? 'preview'}:$account';
    return 'calendar.snapshot.${sha256.convert(utf8.encode(scope))}';
  }

  Future<void> _removeCache(String account) async {
    if (preview) return;
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key(account));
    } else {
      await _cache.purge(account);
    }
  }

  Future<void> _writeCache(String account, Map<String, dynamic> data) async {
    if (preview) return;
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key(account), jsonEncode(data));
    } else {
      await _cache.write(account, 'snapshot', data, DateTime.now().toUtc());
    }
  }

  Future<CalendarSnapshot?> _readCache(String account) async {
    if (preview) return null;
    try {
      final Map<String, dynamic>? data;
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final raw = prefs.getString(_key(account));
        if (raw == null) return null;
        data = jsonDecode(raw) as Map<String, dynamic>;
      } else {
        data = (await _cache.read(account, 'snapshot'))?.value;
        if (data == null) return null;
      }
      final courses = (data['courses'] as List).cast<Map>();
      final events = <CalendarEvent>[];
      for (final row in courses) {
        final course = CourseInfo(id: row['id'], title: row['title']);
        for (final item in (row['activities'] as List).cast<Map>()) {
          final kind = ActivityKind.values.byName(item['kind'] as String);
          final activity = CourseActivity(
            id: item['id'] as String,
            courseId: course.id,
            title: item['title'] as String,
            kind: kind,
            opensAt: item['opensAt'] == null
                ? null
                : DateTime.parse(item['opensAt'] as String),
            closesAt: item['closesAt'] == null
                ? null
                : DateTime.parse(item['closesAt'] as String),
            availability: item['availability'] as String?,
          );
          events.addAll(_events(activity, course));
        }
      }
      return CalendarSnapshot(
        events: events,
        serverTimeUtc: DateTime.parse(data['serverTime'] as String),
        stale: true,
      );
    } catch (_) {
      await _removeCache(account);
      return null;
    }
  }

  Future<CalendarSnapshot?> load({bool refresh = false}) async {
    final account = _account;
    if (account == null) return _snapshot;
    final generation = _generation;
    if (_snapshot == null) {
      final cached = await _readCache(account);
      if (generation != _generation) return null;
      _snapshot = cached;
      notifyListeners();
    }
    try {
      final courses = await _courses.list();
      final contents = await Future.wait(
        courses.map((course) => _courses.content(course.id)),
      );
      if (generation != _generation) return null;
      final stale =
          _courses.listIsStale ||
          courses.any((course) => _courses.contentIsStale(course.id));
      final now =
          contents
              .map((c) => c.serverTime ?? DateTime.now().toUtc())
              .fold<DateTime?>(
                null,
                (current, value) =>
                    current == null || value.isAfter(current) ? value : current,
              ) ??
          DateTime.now().toUtc();
      final events = <CalendarEvent>[];
      final serializedCourses = <Map<String, Object?>>[];
      for (final content in contents) {
        final activities = content.sections
            .where((section) => !section.draft)
            .expand((section) => section.activities)
            .where(
              (activity) => !activity.draft && _isAssessment(activity.kind),
            )
            .toList();
        for (final activity in activities) {
          events.addAll(_events(activity, content.course));
        }
        serializedCourses.add({
          'id': content.course.id,
          'title': content.course.title,
          'activities': [
            for (final activity in activities)
              {
                'id': activity.id,
                'title': activity.title,
                'kind': activity.kind.name,
                'opensAt': activity.opensAt?.toUtc().toIso8601String(),
                'closesAt': activity.closesAt?.toUtc().toIso8601String(),
                'availability': activity.availability,
              },
          ],
        });
      }
      events.sort((a, b) {
        final date = a.atUtc.compareTo(b.atUtc);
        return date != 0 ? date : a.id.compareTo(b.id);
      });
      _snapshot = CalendarSnapshot(
        events: events,
        serverTimeUtc: now,
        stale: stale,
      );
      if (generation == _generation) {
        if (!stale) {
          await _writeCache(account, {
            'serverTime': now.toIso8601String(),
            'courses': serializedCourses,
          });
        }
        if (generation == _generation) notifyListeners();
      }
    } catch (error) {
      if (generation == _generation && _snapshot != null) {
        _snapshot = CalendarSnapshot(
          events: _snapshot!.events,
          serverTimeUtc: _snapshot!.serverTimeUtc,
          stale: true,
        );
        notifyListeners();
      }
    }
    return generation == _generation ? _snapshot : null;
  }

  bool _isAssessment(ActivityKind kind) => const {
    ActivityKind.module,
    ActivityKind.lab,
    ActivityKind.assignment,
    ActivityKind.test,
  }.contains(kind);

  List<CalendarEvent> _events(CourseActivity activity, CourseInfo course) {
    final opens = activity.opensAt?.toUtc();
    final closes = activity.closesAt?.toUtc();
    if (opens != null && closes != null && !closes.isAfter(opens)) return [];
    return [
      if (opens != null)
        CalendarEvent(
          activity: activity,
          course: course,
          moment: CalendarMoment.opening,
          atUtc: opens,
        ),
      if (closes != null)
        CalendarEvent(
          activity: activity,
          course: course,
          moment: CalendarMoment.closing,
          atUtc: closes,
        ),
    ];
  }

  List<CourseActivity> get openActivities {
    final snapshot = _snapshot;
    if (snapshot == null) return const [];
    final grouped = <String, CourseActivity>{};
    for (final event in snapshot.events) {
      final item = event.activity;
      final now = snapshot.serverTimeUtc;
      if ((item.opensAt == null || !now.isBefore(item.opensAt!)) &&
          (item.closesAt == null || now.isBefore(item.closesAt!))) {
        grouped[item.id] = item;
      }
    }
    final result = grouped.values.toList();
    result.sort((a, b) {
      final ac = a.closesAt?.toUtc(), bc = b.closesAt?.toUtc();
      if (ac == null) return bc == null ? a.title.compareTo(b.title) : 1;
      if (bc == null) return -1;
      return ac.compareTo(bc);
    });
    return result;
  }

  @override
  void dispose() {
    // A pending cache read or refresh must not notify after disposal.
    _generation++;
    super.dispose();
  }

  void clear() {
    final account = _account;
    _account = null;
    _generation++;
    _snapshot = null;
    if (account != null) {
      unawaited(_removeCache(account));
    }
    notifyListeners();
  }
}
