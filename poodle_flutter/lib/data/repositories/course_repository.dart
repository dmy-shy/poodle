import 'package:flutter/foundation.dart';
import '../../domain/models/course.dart';
export '../../domain/models/course.dart';

/// Shared by Home and Courses. clear invalidates every outstanding screen read.
abstract class CourseRepository extends ChangeNotifier {
  int _generation = 0;
  bool _sessionActive = false;
  bool get sessionActive => _sessionActive;
  int get generation => _generation;
  Future<List<CourseInfo>> list();
  Future<CourseContent> content(String id);
  Future<CourseActivity> activity(String courseId, String id);
  Future<FileAccess> file(String courseId, String id);
  bool get supportsPreferences => false;
  String? get cacheNamespace => null;
  bool get listIsStale => false;
  DateTime? get listRefreshedAt => null;
  bool contentIsStale(String id) => false;
  DateTime? contentRefreshedAt(String id) => null;
  Future<CourseInfo> setStarred(String id, bool starred) =>
      throw CourseFailure.unavailable;
  Future<CourseInfo> setHidden(String id, bool hidden) =>
      throw CourseFailure.unavailable;
  void clear() {
    _sessionActive = false;
    _generation++;
    notifyListeners();
  }

  void bindAccount(String? account) {
    clear();
    if (account != null) {
      _sessionActive = true;
      notifyListeners();
    }
  }
}

class PreviewCourseRepository extends CourseRepository {
  @override
  Future<List<CourseInfo>> list() async => const [
    CourseInfo(
      id: sampleDesignId,
      title: 'Creative thinking / Творче мислення',
      category: 'Arts / Мистецтво',
      teacherName: 'Poodle sample teacher',
      sample: true,
      summary:
          'Sample materials for exploring Poodle. / Навчальні приклади Poodle.',
    ),
    CourseInfo(
      id: sampleWritingId,
      title: 'Writing with purpose / Усвідомлене письмо',
      category: 'Language / Мови',
      sample: true,
    ),
  ];

  @override
  Future<CourseContent> content(String id) async {
    if (!validCourseId(id)) throw CourseFailure.unavailable;
    final courses = await list();
    final course = courses.where((c) => c.id == id).firstOrNull;
    if (course == null) throw CourseFailure.unavailable;
    final activities = <CourseActivity>[];
    final kinds = ActivityKind.values;
    String activityId(int i) =>
        '019a0acf-0001-7000-8000-${(id == sampleDesignId ? i + 1 : i + 101).toString().padLeft(12, '0')}';
    const order = [2, 3, 0, 1, 6, 7, 4, 5];
    for (final i in order) {
      final kind = i == 1 ? ActivityKind.file : kinds[i == 0 ? 0 : i - 1];
      final docx = i == 1;
      activities.add(
        CourseActivity(
          id: activityId(i),
          courseId: id,
          title: switch (kind) {
            ActivityKind.file =>
              docx ? 'Top countries in Europe' : 'Halloween English',
            ActivityKind.link =>
              'Flutter learning resources / Навчальні ресурси Flutter',
            ActivityKind.announcement => 'Welcome / Вітаємо',
            ActivityKind.module => 'Module 1 / Модуль 1',
            ActivityKind.lab => 'Lab 1 / Лабораторна 1',
            ActivityKind.assignment => 'Assignment 1 / Завдання 1',
            ActivityKind.test => 'Test 1 / Тест 1',
          },
          kind: kind,
          file: kind == ActivityKind.file
              ? CourseFile(
                  name: docx
                      ? 'Top countries in Europe.docx'
                      : 'Halloween-English.pdf',
                  mimeType: docx
                      ? 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                      : 'application/pdf',
                  sizeBytes: docx ? 7951 : 88136,
                  checksum: docx
                      ? 'd4b66088ca48caec167d891f142a3f74347be66215d026716ff6c51c04d6f2fd'
                      : '112d7aa9cce411dae7733e3c821b3942851385f2e23139f8f40309628b3b9422',
                )
              : null,
          url: kind == ActivityKind.link
              ? 'https://docs.flutter.dev/learn'
              : null,
          body: kind == ActivityKind.announcement
              ? 'Explore the materials at your own pace. / Опрацьовуйте матеріали у власному темпі.'
              : null,
          author: kind == ActivityKind.announcement
              ? 'Poodle sample teacher'
              : null,
          publishedAt: kind == ActivityKind.announcement
              ? DateTime.utc(2026, 10, 1)
              : null,
          instructions:
              kind == ActivityKind.module ||
                  kind == ActivityKind.lab ||
                  kind == ActivityKind.assignment ||
                  kind == ActivityKind.test
              ? 'Read the notes and prepare a short reflection. / Прочитайте нотатки та підготуйте коротку рефлексію.'
              : null,
          opensAt: kind == ActivityKind.module
              ? DateTime.utc(2026, 10, 1)
              : null,
          closesAt: kind == ActivityKind.module
              ? DateTime.utc(2026, 12, 1)
              : null,
          attemptLimit: kind == ActivityKind.module ? 1 : null,
          timeLimitMinutes: kind == ActivityKind.module ? 20 : null,
          availability: kind == ActivityKind.module
              ? 'available'
              : kind == ActivityKind.lab
              ? 'unscheduled'
              : null,
          previousId: order.indexOf(i) == 0
              ? null
              : activityId(order[order.indexOf(i) - 1]),
          nextId: order.indexOf(i) == order.length - 1
              ? null
              : activityId(order[order.indexOf(i) + 1]),
        ),
      );
    }
    return CourseContent(
      course: course,
      serverTime: DateTime.utc(2026, 10, 22),
      sections: [
        for (var s = 0; s < 3; s++)
          ContentSection(
            id: '019a0acf-0002-7000-8000-${((id == sampleDesignId ? 0 : 100) + s + 1).toString().padLeft(12, '0')}',
            title: [
              'Information / Інформація',
              'Learning materials / Навчальні матеріали',
              'Modules and labs / Модулі та лабораторні',
            ][s],
            activities: activities
                .where(
                  (a) => switch (s) {
                    0 =>
                      a.kind == ActivityKind.link ||
                          a.kind == ActivityKind.announcement,
                    1 => a.kind == ActivityKind.file,
                    _ =>
                      a.kind == ActivityKind.module ||
                          a.kind == ActivityKind.lab ||
                          a.kind == ActivityKind.assignment ||
                          a.kind == ActivityKind.test,
                  },
                )
                .toList(),
          ),
      ],
    );
  }

  @override
  Future<CourseActivity> activity(String courseId, String id) async {
    if (!validCourseId(id)) throw CourseFailure.unavailable;
    final result = (await content(courseId)).sections
        .expand((s) => s.activities)
        .where((a) => a.id == id)
        .firstOrNull;
    if (result == null) throw CourseFailure.unavailable;
    return result;
  }

  @override
  Future<FileAccess> file(String courseId, String id) async {
    final value = await activity(courseId, id);
    if (value.file == null) throw CourseFailure.unavailable;
    return FileAccess(
      '',
      DateTime.now().add(const Duration(minutes: 1)),
      asset: 'assets/course_samples/${value.file!.name}',
    );
  }
}
