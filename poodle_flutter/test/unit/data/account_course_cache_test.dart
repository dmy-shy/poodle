import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/account_course_cache.dart';
import 'package:poodle_flutter/domain/models/course.dart';

void main() {
  test(
    'course detail survives reopening with ordered sections and file metadata',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'poodle-detail-cache-',
      );
      addTearDown(() => root.delete(recursive: true));
      final cache = AccountCourseCache(root: root, namespace: 'server-a');
      final content = CourseContent(
        course: const CourseInfo(
          id: sampleDesignId,
          title: 'Course A',
          role: 'teacher',
        ),
        serverTime: DateTime.utc(2026, 11, 12),
        sections: [
          ContentSection(
            id: 'section-1',
            title: 'Materials',
            activities: [
              const CourseActivity(
                id: 'file-1',
                courseId: sampleDesignId,
                title: 'Handout',
                kind: ActivityKind.file,
                file: CourseFile(
                  name: 'handout.pdf',
                  mimeType: 'application/pdf',
                  sizeBytes: 42,
                  checksum: 'abc',
                ),
              ),
            ],
          ),
        ],
      );
      await cache.writeContent(
        'user-1',
        content,
        DateTime.utc(2026, 11, 12, 10),
      );
      final reopened = AccountCourseCache(root: root, namespace: 'server-a');
      final saved = await reopened.readContent('user-1', sampleDesignId);
      expect(
        saved?.content.sections.single.activities.single.file?.checksum,
        'abc',
      );
      expect(saved?.content.sections.single.title, 'Materials');
      expect(saved?.content.course.role, 'teacher');
      expect(saved?.refreshedAt, DateTime.utc(2026, 11, 12, 10));
      expect(await reopened.readContent('user-2', sampleDesignId), isNull);
    },
  );
  test(
    'fresh inventory removes details for courses no longer assigned',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'poodle-detail-prune-',
      );
      addTearDown(() => root.delete(recursive: true));
      final cache = AccountCourseCache(root: root, namespace: 'server-a');
      final content = CourseContent(
        course: const CourseInfo(id: sampleDesignId, title: 'Course A'),
        sections: [],
      );
      await cache.writeContent('user-1', content, DateTime.utc(2026, 11, 12));
      await cache.write('user-1', [], DateTime.utc(2026, 11, 12, 1));
      expect(await cache.readContent('user-1', sampleDesignId), isNull);
    },
  );
  test(
    'course list survives a new cache instance and stays account scoped',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'poodle-course-cache-',
      );
      addTearDown(() => root.delete(recursive: true));
      final first = AccountCourseCache(root: root, namespace: 'server-a');
      final time = DateTime.utc(2026, 11, 11, 20);
      await first.write('user-1', [
        const CourseInfo(
          id: sampleDesignId,
          title: 'Course A',
          starred: true,
          role: 'student',
        ),
      ], time);
      final reopened = AccountCourseCache(root: root, namespace: 'server-a');
      final saved = await reopened.read('user-1');
      expect(saved?.courses.single.title, 'Course A');
      expect(saved?.courses.single.starred, true);
      expect(saved?.courses.single.role, 'student');
      expect(saved?.refreshedAt, time);
      expect(await reopened.read('user-2'), isNull);
      expect(
        await AccountCourseCache(
          root: root,
          namespace: 'server-b',
        ).read('user-1'),
        isNull,
      );
      await reopened.purge('user-1');
      expect(await first.read('user-1'), isNull);
    },
  );
}
