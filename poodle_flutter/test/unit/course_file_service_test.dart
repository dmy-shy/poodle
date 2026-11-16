import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/course_repository.dart';
import 'package:poodle_flutter/data/services/course_file_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'replacement DOCX opens from the exact supplied asset into temporary storage',
    () async {
      final temporary = await Directory.systemTemp.createTemp(
        'poodle-docx-test-',
      );
      addTearDown(() async {
        if (await temporary.exists()) await temporary.delete(recursive: true);
      });
      final service = CourseFileService(
        temporaryDirectory: () async => temporary,
      );
      final repository = PreviewCourseRepository();
      addTearDown(repository.dispose);
      final course = await repository.content(sampleDesignId);
      final item = course.sections
          .expand((s) => s.activities)
          .firstWhere((a) => a.file?.name == 'Top countries in Europe.docx');
      await service.reset('account');
      final path = await service.prepare(
        item.file!,
        await repository.file(sampleDesignId, item.id),
      );
      expect(path.endsWith('.docx'), true);
      expect(await File(path).length(), 7951);
      await service.reset(null);
      expect(await File(path).exists(), false);
    },
  );
  test(
    'supplied PDF is verified, isolated by account and removed on sign out',
    () async {
      final temporary = await Directory.systemTemp.createTemp(
        'poodle-file-test-',
      );
      addTearDown(() async {
        if (await temporary.exists()) await temporary.delete(recursive: true);
      });
      final service = CourseFileService(
        temporaryDirectory: () async => temporary,
      );
      final repository = PreviewCourseRepository();
      addTearDown(repository.dispose);
      final course = await repository.content(sampleDesignId);
      final item = course.sections
          .expand((s) => s.activities)
          .firstWhere((a) => a.file?.mimeType == 'application/pdf');
      await service.reset('account-a');
      final first = await service.prepare(
        item.file!,
        await repository.file(sampleDesignId, item.id),
      );
      expect(await File(first).length(), 88136);
      await service.reset('account-b');
      expect(await File(first).exists(), false);
      final second = await service.prepare(
        item.file!,
        await repository.file(sampleDesignId, item.id),
      );
      expect(second, isNot(first));
      await service.reset(null);
      expect(await File(second).exists(), false);
      await expectLater(
        service.prepare(
          item.file!,
          await repository.file(sampleDesignId, item.id),
        ),
        throwsA(CourseFailure.cancelled),
      );
    },
  );
  test('checksum mismatch prevents persisting a supplied PDF', () async {
    final temporary = await Directory.systemTemp.createTemp(
      'poodle-hash-test-',
    );
    addTearDown(() async {
      if (await temporary.exists()) await temporary.delete(recursive: true);
    });
    final service = CourseFileService(
      temporaryDirectory: () async => temporary,
    );
    await service.reset('account');
    await expectLater(
      service.prepare(
        const CourseFile(
          name: 'Halloween-English.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 88136,
          checksum: 'incorrect',
        ),
        FileAccess(
          '',
          DateTime.now(),
          asset: 'assets/course_samples/Halloween-English.pdf',
        ),
      ),
      throwsA(CourseFailure.file),
    );
    expect(await temporary.list(recursive: true).isEmpty, true);
  });
}
