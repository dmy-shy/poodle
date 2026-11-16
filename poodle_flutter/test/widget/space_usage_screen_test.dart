import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/course_repository.dart';
import 'package:poodle_flutter/data/services/course_download_service.dart';
import 'package:poodle_flutter/data/services/course_file_service.dart';
import 'package:poodle_flutter/features/settings/presentation/views/space_usage_screen.dart';

class _Downloads extends CourseDownloadService {
  _Downloads(CourseRepository courses, CourseFileService files)
    : super(courses: courses, files: files, namespace: 'test');
  bool removed = false;
  @override
  Future<List<DownloadedCourseFile>> list() async => removed
      ? []
      : [
          const DownloadedCourseFile(
            courseId: sampleDesignId,
            activityId: 'file-1',
            title: 'Halloween English',
            path: '/tmp/sample.pdf',
            sizeBytes: 88136,
          ),
        ];
  @override
  Future<void> removeCourse(String courseId) async {
    removed = true;
  }
}

void main() {
  testWidgets('stored course files can be removed from Space usage', (
    tester,
  ) async {
    final courses = PreviewCourseRepository();
    final files = CourseFileService();
    final downloads = _Downloads(courses, files);
    await tester.pumpWidget(
      MaterialApp(
        home: SpaceUsageScreen(downloads: downloads, files: files),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Halloween English'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove local download'));
    await tester.pumpAndSettle();
    expect(downloads.removed, false);
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();
    expect(downloads.removed, true);
    expect(find.text('No downloaded files.'), findsOneWidget);
    expect(downloads.removed, true);
    courses.dispose();
  });
}
