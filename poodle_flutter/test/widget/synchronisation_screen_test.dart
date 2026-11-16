import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/course_repository.dart';
import 'package:poodle_flutter/features/settings/presentation/views/synchronisation_screen.dart';
import 'package:poodle_flutter/data/services/sync_coordinator.dart';

class _Courses extends PreviewCourseRepository {
  int reads = 0;
  bool fail = true;
  @override
  Future<List<CourseInfo>> list() async {
    reads++;
    if (fail) throw CourseFailure.network;
    return super.list();
  }
}

void main() {
  testWidgets('partial sync shows failed area and retry', (tester) async {
    final sync = SyncCoordinator({
      SyncArea.courses: () async => true,
      SyncArea.calendar: () async => false,
    })..bindAccount('alice');
    await tester.pumpWidget(
      MaterialApp(
        home: SynchronisationScreen(
          repository: PreviewCourseRepository(),
          sync: sync,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Partial sync'), findsOneWidget);
    expect(find.text('Cached'), findsOneWidget);
    sync.dispose();
  });
  testWidgets('failed sync offers Retry and clears error after success', (
    tester,
  ) async {
    final courses = _Courses();
    await tester.pumpWidget(
      MaterialApp(home: SynchronisationScreen(repository: courses)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Could not refresh courses'), findsOneWidget);
    courses.fail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Up to date'), findsOneWidget);
    expect(courses.reads, 2);
  });
}
