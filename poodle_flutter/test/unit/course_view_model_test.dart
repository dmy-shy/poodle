import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/course_repository.dart';
import 'package:poodle_flutter/features/courses/presentation/view_models/course_view_model.dart';
import 'package:poodle_flutter/data/services/course_file_service.dart';

class RevocableCourses extends PreviewCourseRepository {
  bool revoked = false;
  @override
  Future<CourseActivity> activity(String courseId, String id) {
    if (revoked) throw CourseFailure.unavailable;
    return super.activity(courseId, id);
  }
}

class RecordingFiles extends CourseFileService {
  @override
  Future<String> prepare(CourseFile file, FileAccess access) async =>
      'temporary.docx';
  @override
  Future<void> openDocument(String path) async => throw CourseFailure.noHandler;
}

class MutableLinkCourses extends RevocableCourses {
  String? replacementUrl;
  ActivityKind? replacementKind;
  Completer<CourseActivity>? pending;
  @override
  Future<CourseActivity> activity(String courseId, String id) async {
    final item = await super.activity(courseId, id);
    if (pending != null) return pending!.future;
    return CourseActivity(
      id: item.id,
      courseId: item.courseId,
      title: item.title,
      kind: replacementKind ?? item.kind,
      url: replacementUrl ?? item.url,
    );
  }
}

class PendingCourses extends CourseRepository {
  final result = Completer<CourseContent>();
  int requests = 0;
  @override
  Future<CourseContent> content(String id) {
    requests++;
    return result.future;
  }

  @override
  Future<List<CourseInfo>> list() async => [];
  @override
  Future<CourseActivity> activity(String courseId, String id) async =>
      (await content(
        courseId,
      )).sections.expand((s) => s.activities).firstWhere((a) => a.id == id);
  @override
  Future<FileAccess> file(String courseId, String id) async =>
      throw CourseFailure.unavailable;
}

void main() {
  test('a stale link is reauthorized before browser handoff', () async {
    final repository = RevocableCourses();
    final content = await repository.content(sampleDesignId);
    final link = content.sections
        .expand((s) => s.activities)
        .firstWhere((a) => a.kind == ActivityKind.link);
    final model = CourseViewModel(
      repository,
      courseId: sampleDesignId,
      activityId: link.id,
    );
    await model.load();
    repository.revoked = true;
    expect(await model.open(), isNull);
    expect(model.openFailure, CourseFailure.unavailable);
    model.dispose();
    repository.dispose();
  });
  test('an authorized HTTPS link is returned without a file service', () async {
    final repository = MutableLinkCourses();
    final content = await repository.content(sampleDesignId);
    final link = content.sections
        .expand((s) => s.activities)
        .firstWhere((a) => a.kind == ActivityKind.link);
    final model = CourseViewModel(
      repository,
      courseId: sampleDesignId,
      activityId: link.id,
    );
    await model.load();
    expect(await model.open(), Uri.parse('https://docs.flutter.dev/learn'));
    expect(model.openFailure, isNull);
    for (final replacement in ['https://example.com', 'http://example.com']) {
      repository.replacementUrl = replacement;
      expect(await model.open(), isNull);
      expect(model.openFailure, isNotNull);
    }
    repository.replacementUrl = null;
    repository.replacementKind = ActivityKind.file;
    expect(await model.open(), isNull);
    model.dispose();
    repository.dispose();
  });
  test('account invalidation cancels a pending link recheck', () async {
    final repository = MutableLinkCourses();
    final content = await repository.content(sampleDesignId);
    final link = content.sections
        .expand((s) => s.activities)
        .firstWhere((a) => a.kind == ActivityKind.link);
    final model = CourseViewModel(
      repository,
      courseId: sampleDesignId,
      activityId: link.id,
    );
    await model.load();
    repository.pending = Completer<CourseActivity>();
    final opening = model.open();
    repository.clear();
    repository.pending!.complete(link);
    expect(await opening, isNull);
    expect(model.activity, isNull);
    model.dispose();
    repository.dispose();
  });
  test('a missing DOCX handler is exposed for a retry', () async {
    final repository = PreviewCourseRepository();
    final content = await repository.content(sampleDesignId);
    final docx = content.sections
        .expand((s) => s.activities)
        .firstWhere((a) => a.file?.name.endsWith('.docx') == true);
    final model = CourseViewModel(
      repository,
      courseId: sampleDesignId,
      activityId: docx.id,
      files: RecordingFiles(),
    );
    await model.load();
    await model.open();
    expect(model.openFailure, CourseFailure.noHandler);
    expect(model.opening, false);
    expect(model.pdfPath, isNull);
    model.dispose();
    repository.dispose();
  });
  test('malformed identifiers never reach the repository', () async {
    final repository = PendingCourses();
    final model = CourseViewModel(repository, courseId: '1');
    await model.load();
    expect(repository.requests, 0);
    expect(model.failure, CourseFailure.unavailable);
    model.dispose();
  });
  test(
    'session clear removes content and ignores an outstanding read',
    () async {
      final repository = PendingCourses();
      final model = CourseViewModel(repository, courseId: sampleDesignId);
      final pending = model.load();
      repository.clear();
      repository.result.complete(
        CourseContent(
          course: const CourseInfo(id: sampleDesignId, title: 'Private'),
          sections: const [],
        ),
      );
      await pending;
      expect(model.value, isNull);
      expect(model.busy, false);
      model.dispose();
    },
  );
  test(
    'preview exposes all supported content kinds with UUID identifiers',
    () async {
      final repository = PreviewCourseRepository();
      final courses = await repository.list();
      final content = await repository.content(courses.first.id);
      final activities = content.sections.expand((s) => s.activities).toList();
      expect(
        activities.map((a) => a.kind).toSet(),
        containsAll(ActivityKind.values),
      );
      expect(activities.every((a) => validCourseId(a.id)), true);
      expect(activities.first.previousId, isNull);
      expect(activities.last.nextId, isNull);
      expect(activities.first.nextId, activities[1].id);
      expect(
        () => repository.content('course-design'),
        throwsA(CourseFailure.unavailable),
      );
      repository.dispose();
    },
  );
}
