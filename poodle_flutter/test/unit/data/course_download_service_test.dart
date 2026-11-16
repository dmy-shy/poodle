import 'dart:io';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/course_repository.dart';
import 'package:poodle_flutter/data/services/course_download_service.dart';
import 'package:poodle_flutter/data/services/course_file_service.dart';

class _FailingFiles extends CourseFileService {
  _FailingFiles(Directory root) : super(temporaryDirectory: () async => root);
  bool fail = false;
  @override
  Future<String> prepare(CourseFile file, FileAccess access) {
    if (fail) throw CourseFailure.network;
    return super.prepare(file, access);
  }
}

class _GatedFiles extends CourseFileService {
  _GatedFiles(Directory root) : super(temporaryDirectory: () async => root);
  final entered = Completer<void>();
  final release = Completer<void>();
  @override
  Future<String> prepare(CourseFile file, FileAccess access) async {
    if (!entered.isCompleted) entered.complete();
    await release.future;
    return super.prepare(file, access);
  }
}

class _RefreshGateFiles extends CourseFileService {
  _RefreshGateFiles(Directory root)
    : super(temporaryDirectory: () async => root);
  bool gate = false;
  final entered = Completer<void>();
  final release = Completer<void>();
  @override
  Future<String> prepare(CourseFile file, FileAccess access) async {
    if (gate) {
      if (!entered.isCompleted) entered.complete();
      await release.future;
    }
    return super.prepare(file, access);
  }
}

class _VersionedCourses extends PreviewCourseRepository {
  bool changed = false;
  @override
  Future<CourseContent> content(String id) async {
    final source = await super.content(id);
    if (!changed) return source;
    return CourseContent(
      course: source.course,
      sections: [
        for (final section in source.sections)
          ContentSection(
            id: section.id,
            title: section.title,
            activities: [
              for (final activity in section.activities)
                if (activity.file == null)
                  activity
                else
                  CourseActivity(
                    id: activity.id,
                    courseId: activity.courseId,
                    title: activity.title,
                    kind: activity.kind,
                    file: CourseFile(
                      name: activity.file!.name,
                      mimeType: activity.file!.mimeType,
                      sizeBytes: activity.file!.sizeBytes,
                      checksum: 'new-version',
                    ),
                  ),
            ],
          ),
      ],
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('offline copies support only PDF and DOCX', () {
    for (final mime in ['image/png', 'image/jpeg', 'application/zip']) {
      expect(
        CourseFile(
          name: 'file',
          mimeType: mime,
          sizeBytes: 1,
          checksum: '',
        ).supportsOfflineCopy,
        false,
      );
    }
    expect(
      const CourseFile(
        name: 'file.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 1,
        checksum: '',
      ).supportsOfflineCopy,
      true,
    );
  });
  test('offline open checks the current account and manifest', () async {
    final root = await Directory.systemTemp.createTemp('poodle-open-root-');
    final temp = await Directory.systemTemp.createTemp('poodle-open-temp-');
    addTearDown(() async {
      await root.delete(recursive: true);
      await temp.delete(recursive: true);
    });
    final courses = PreviewCourseRepository();
    final files = _FailingFiles(temp);
    await files.reset('account-a');
    final downloads = CourseDownloadService(
      courses: courses,
      files: files,
      root: root,
      namespace: 'test',
    )..bindAccount('account-a');
    final saved = (await downloads.downloadCourse(sampleDesignId)).first;
    files.fail = true;
    expect(await downloads.validatedPath(saved), saved.path);
    final forged = DownloadedCourseFile(
      courseId: saved.courseId,
      activityId: saved.activityId,
      title: saved.title,
      path: '${temp.path}/other.pdf',
      sizeBytes: saved.sizeBytes,
      checksum: saved.checksum,
    );
    expect(await downloads.validatedPath(forged), isNull);
    downloads.bindAccount('account-b');
    expect(await downloads.validatedPath(saved), isNull);
    expect(await downloads.list(), isEmpty);
    courses.dispose();
  });

  test('refresh failure keeps the previous usable copy', () async {
    final root = await Directory.systemTemp.createTemp('poodle-refresh-root-');
    final temp = await Directory.systemTemp.createTemp('poodle-refresh-temp-');
    addTearDown(() async {
      await root.delete(recursive: true);
      await temp.delete(recursive: true);
    });
    final courses = _VersionedCourses();
    final files = _FailingFiles(temp);
    await files.reset('student');
    final downloads = CourseDownloadService(
      courses: courses,
      files: files,
      root: root,
      namespace: 'test',
    )..bindAccount('student');
    final original = (await downloads.downloadCourse(sampleDesignId)).first;
    courses.changed = true;
    files.fail = true;
    await expectLater(
      downloads.refreshDownloadedFiles(sampleDesignId),
      throwsA(CourseFailure.network),
    );
    expect(await downloads.validatedPath(original), original.path);
    courses.dispose();
  });

  test('refresh progress and account switch never expose old files', () async {
    final root = await Directory.systemTemp.createTemp('poodle-switch-root-');
    final temp = await Directory.systemTemp.createTemp('poodle-switch-temp-');
    addTearDown(() async {
      await root.delete(recursive: true);
      await temp.delete(recursive: true);
    });
    final courses = _VersionedCourses();
    final files = _RefreshGateFiles(temp);
    await files.reset('first');
    final downloads = CourseDownloadService(
      courses: courses,
      files: files,
      root: root,
      namespace: 'test',
    )..bindAccount('first');
    final original = (await downloads.downloadCourse(sampleDesignId)).first;
    courses.changed = true;
    files.gate = true;
    final progress = <int>[];
    final refreshing = downloads.refreshDownloadedFiles(
      sampleDesignId,
      onProgress: (done, _) => progress.add(done),
    );
    await files.entered.future;
    downloads.bindAccount('second');
    files.release.complete();
    await expectLater(refreshing, throwsA(CourseFailure.cancelled));
    expect(progress, isEmpty);
    expect(await downloads.list(), isEmpty);
    expect(await downloads.validatedPath(original), isNull);
    courses.dispose();
  });

  test(
    'missing file remains visible and refresh restores it with progress',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'poodle-missing-root-',
      );
      final temp = await Directory.systemTemp.createTemp(
        'poodle-missing-temp-',
      );
      addTearDown(() async {
        await root.delete(recursive: true);
        await temp.delete(recursive: true);
      });
      final courses = PreviewCourseRepository();
      final files = CourseFileService(temporaryDirectory: () async => temp);
      await files.reset('student');
      final downloads = CourseDownloadService(
        courses: courses,
        files: files,
        root: root,
        namespace: 'test',
      )..bindAccount('student');
      final saved = (await downloads.downloadCourse(sampleDesignId)).first;
      await File(saved.path).delete();
      expect(await downloads.pathFor(saved.activityId), isNull);
      expect(
        (await downloads.list()).map((item) => item.activityId),
        contains(saved.activityId),
      );
      final progress = <int>[];
      await downloads.refreshDownloadedFiles(
        sampleDesignId,
        onProgress: (done, _) => progress.add(done),
      );
      expect(progress, [1]);
      expect(await downloads.validatedPath(saved), saved.path);
      courses.dispose();
    },
  );
  test(
    'metadata sync reports changed saved files without replacing bytes',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'poodle-version-root-',
      );
      final temp = await Directory.systemTemp.createTemp(
        'poodle-version-temp-',
      );
      addTearDown(() async {
        await root.delete(recursive: true);
        await temp.delete(recursive: true);
      });
      final courses = _VersionedCourses();
      final files = CourseFileService(temporaryDirectory: () async => temp);
      await files.reset('student');
      final downloads = CourseDownloadService(
        courses: courses,
        files: files,
        root: root,
        namespace: 'test',
      );
      downloads.bindAccount('student');
      final saved = await downloads.downloadCourse(sampleDesignId);
      courses.changed = true;
      final changed = await downloads.changedFiles(sampleDesignId);
      expect(changed, containsAll(saved.map((file) => file.activityId)));
      expect(await downloads.list(), hasLength(saved.length));
      courses.dispose();
    },
  );
  test(
    'completed course files survive relaunch and remove locally offline',
    () async {
      final root = await Directory.systemTemp.createTemp('poodle-downloads-');
      final temp = await Directory.systemTemp.createTemp(
        'poodle-download-temp-',
      );
      addTearDown(() async {
        await root.delete(recursive: true);
        await temp.delete(recursive: true);
      });
      final courses = PreviewCourseRepository();
      final files = _FailingFiles(temp);
      await files.reset('account-a');
      final service = CourseDownloadService(
        courses: courses,
        files: files,
        root: root,
        namespace: 'server-a',
      );
      service.bindAccount('account-a');
      final saved = await service.downloadCourse(sampleDesignId);
      expect(saved, hasLength(2));
      expect(await File(saved.first.path).exists(), true);
      final reopened = CourseDownloadService(
        courses: courses,
        files: files,
        root: root,
        namespace: 'server-a',
      );
      reopened.bindAccount('account-a');
      expect(await reopened.list(), hasLength(2));
      files.fail = true;
      await expectLater(
        reopened.downloadCourse(sampleDesignId),
        throwsA(CourseFailure.network),
      );
      expect(await reopened.list(), hasLength(2));
      files.fail = false;
      await File(saved.first.path).writeAsBytes([1, 2, 3]);
      expect(await reopened.pathFor(saved.first.activityId), isNull);
      reopened.bindAccount('account-b');
      expect(await reopened.list(), isEmpty);
      reopened.bindAccount('account-a');
      await reopened.removeCourse(sampleDesignId);
      expect(await reopened.list(), isEmpty);
      expect(await File(saved.first.path).exists(), false);
      courses.dispose();
    },
  );
  test(
    'sign out cancels an in-flight download and purges its account files',
    () async {
      final root = await Directory.systemTemp.createTemp('poodle-cancel-root-');
      final temp = await Directory.systemTemp.createTemp('poodle-cancel-temp-');
      addTearDown(() async {
        await root.delete(recursive: true);
        await temp.delete(recursive: true);
      });
      final courses = PreviewCourseRepository();
      final files = _GatedFiles(temp);
      await files.reset('student');
      final downloads = CourseDownloadService(
        courses: courses,
        files: files,
        root: root,
        namespace: 'test',
      );
      downloads.bindAccount('student');
      final pending = downloads.downloadCourse(sampleDesignId);
      await files.entered.future;
      final cleanup = downloads.purge('student');
      files.release.complete();
      await expectLater(pending, throwsA(CourseFailure.cancelled));
      await cleanup;
      expect(await downloads.list(), isEmpty);
      expect(await root.list().isEmpty, true);
      courses.dispose();
    },
  );
  test('authorized refresh removes revoked course and file copies', () async {
    final root = await Directory.systemTemp.createTemp(
      'poodle-reconcile-root-',
    );
    final temp = await Directory.systemTemp.createTemp(
      'poodle-reconcile-temp-',
    );
    addTearDown(() async {
      await root.delete(recursive: true);
      await temp.delete(recursive: true);
    });
    final courses = PreviewCourseRepository();
    final files = CourseFileService(temporaryDirectory: () async => temp);
    await files.reset('student');
    final downloads = CourseDownloadService(
      courses: courses,
      files: files,
      root: root,
      namespace: 'test',
    );
    downloads.bindAccount('student');
    await downloads.downloadCourse(sampleDesignId);
    await downloads.reconcileContent(
      CourseContent(
        course: const CourseInfo(id: sampleDesignId, title: 'Course'),
        sections: [],
      ),
    );
    expect(await downloads.list(), isEmpty);
    await downloads.downloadCourse(sampleDesignId);
    await downloads.reconcileInventory([]);
    expect(await downloads.list(), isEmpty);
    courses.dispose();
  });
}
