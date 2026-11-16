import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:poodle_flutter/data/repositories/calendar_repository.dart';
import 'package:poodle_flutter/data/repositories/course_repository.dart';
import 'package:poodle_flutter/data/repositories/account_notebook_cache.dart';
import 'dart:io';

class OfflineCourses extends CourseRepository {
  bool stale = false;
  @override
  String get cacheNamespace => 'server-a';
  @override
  bool get listIsStale => stale;
  @override
  bool contentIsStale(String id) => stale;
  @override
  Future<List<CourseInfo>> list() async => const [
    CourseInfo(id: sampleDesignId, title: 'Course A'),
  ];
  @override
  Future<CourseContent> content(String id) async => CourseContent(
    course: const CourseInfo(id: sampleDesignId, title: 'Course A'),
    serverTime: DateTime.utc(2026, 11, 12),
    sections: [
      ContentSection(
        id: 'section-1',
        title: 'Tasks',
        activities: [
          CourseActivity(
            id: 'activity-1',
            courseId: id,
            title: 'Assignment',
            kind: ActivityKind.assignment,
            closesAt: DateTime.utc(2026, 11, 20),
          ),
        ],
      ),
    ],
  );
  @override
  Future<CourseActivity> activity(String courseId, String id) async =>
      throw CourseFailure.unavailable;
  @override
  Future<FileAccess> file(String courseId, String id) async =>
      throw CourseFailure.unavailable;
}

class DelayedCalendarCache extends AccountNotebookCache {
  DelayedCalendarCache() : super(namespace: 'delayed-calendar');

  final alice = Completer<NotebookCacheSnapshot?>();

  @override
  Future<NotebookCacheSnapshot?> read(String account, String key) =>
      account == 'alice' ? alice.future : Future.value();

  @override
  Future<void> purge(String account) async {}

  @override
  Future<void> write(
    String account,
    String key,
    Map<String, dynamic> value,
    DateTime refreshedAt,
  ) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'calendar keeps cached reads stale when course data came from offline cache',
    skip: kIsWeb,
    () async {
      SharedPreferences.setMockInitialValues({});
      final courses = OfflineCourses();
      final root = await Directory.systemTemp.createTemp(
        'calendar-cache-test-',
      );
      addTearDown(() => root.delete(recursive: true));
      final calendar = CalendarRepository(
        courses,
        cache: AccountNotebookCache(root: root, namespace: 'calendar-test'),
      );
      calendar.bindAccount('alice');
      await calendar.load();
      expect(calendar.snapshot?.stale, isFalse);
      expect(calendar.snapshot?.events.single.activity.title, 'Assignment');
      courses.stale = true;
      await calendar.load(refresh: true);
      expect(calendar.snapshot?.stale, isTrue);
      expect(calendar.snapshot?.events.single.activity.title, 'Assignment');
      calendar.dispose();
      courses.dispose();
    },
  );
  test('late calendar read cannot replace the new account snapshot', () async {
    final courses = OfflineCourses();
    final cache = DelayedCalendarCache();
    final calendar = CalendarRepository(courses, cache: cache);
    addTearDown(courses.dispose);
    addTearDown(calendar.dispose);

    calendar.bindAccount('alice');
    final oldLoad = calendar.load();
    calendar.bindAccount('bob');
    await calendar.load();
    final current = calendar.snapshot;
    expect(current?.events.single.course.title, 'Course A');

    cache.alice.complete(
      NotebookCacheSnapshot({
        'serverTime': '2026-11-12T00:00:00Z',
        'courses': [
          {
            'id': 'previous-course',
            'title': 'Previous account course',
            'activities': [
              {
                'id': 'previous-activity',
                'title': 'Previous account assignment',
                'kind': 'assignment',
                'closesAt': '2026-11-20T00:00:00Z',
              },
            ],
          },
        ],
      }, DateTime.utc(2026, 11, 12)),
    );
    expect(await oldLoad, isNull);
    expect(calendar.snapshot, same(current));
  }, skip: kIsWeb);

  test('disposing the calendar invalidates pending reads', () async {
    final courses = OfflineCourses();
    final cache = DelayedCalendarCache();
    final calendar = CalendarRepository(courses, cache: cache);
    addTearDown(courses.dispose);

    calendar.bindAccount('alice');
    final pending = calendar.load();
    calendar.dispose();

    cache.alice.complete(null);
    expect(await pending, isNull);
    expect(calendar.snapshot, isNull);
  }, skip: kIsWeb);

  for (final malformed in ['not JSON', '[]']) {
    test('web recovers from calendar cache: $malformed', () async {
      final scope = sha256.convert(utf8.encode('server-a:alice'));
      final key = 'calendar.snapshot.$scope';
      SharedPreferences.setMockInitialValues({key: malformed});
      final courses = OfflineCourses()..stale = true;
      final calendar = CalendarRepository(courses);
      addTearDown(courses.dispose);
      addTearDown(calendar.dispose);

      calendar.bindAccount('alice');
      final snapshot = await calendar.load();
      expect(snapshot?.events.single.activity.title, 'Assignment');
      expect((await SharedPreferences.getInstance()).getString(key), isNull);
    }, skip: !kIsWeb);
  }
}
