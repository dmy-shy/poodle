import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_client/poodle_client.dart';
import 'package:poodle_flutter/data/repositories/my_files_repository.dart';
import 'package:poodle_flutter/features/my_files/presentation/views/my_files_screen.dart';

class _FakeFiles implements MyFilesRepository {
  int calls = 0;
  bool fail = false;
  final rows = [
    MyUpload(
      id: const Uuid().v4obj(),
      fileName: 'notes.pdf',
      kind: 'notebook',
      uploadedAt: DateTime.utc(2025, 2),
      courseId: const Uuid().v4obj(),
      courseTitle: 'Biology',
      activityId: const Uuid().v4obj(),
      activityTitle: 'Study',
      processingStatus: 'ready',
    ),
    MyUpload(
      id: const Uuid().v4obj(),
      fileName: 'essay.pdf',
      kind: 'assignment',
      uploadedAt: DateTime.utc(2025, 1),
      courseId: const Uuid().v4obj(),
      courseTitle: 'Biology',
      activityId: const Uuid().v4obj(),
      activityTitle: 'Essay',
    ),
  ];
  @override
  Future<List<MyUpload>> listUploads() async {
    calls++;
    if (fail) throw StateError('offline');
    return rows;
  }
}

void main() {
  testWidgets('filters both kinds and opens their existing contexts', (
    tester,
  ) async {
    final fake = _FakeFiles();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => MyFilesScreen(repository: fake),
        ),
        GoRoute(
          path: '/courses/:course/activity/:activity/notebook',
          builder: (_, _) => const Scaffold(body: Text('Notebook destination')),
        ),
        GoRoute(
          path: '/courses/:course/activity/:activity/work',
          builder: (_, _) => const Scaffold(body: Text('Work destination')),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    expect(find.text('notes.pdf'), findsOneWidget);
    expect(find.text('essay.pdf'), findsOneWidget);
    await tester.tap(find.text('Notebook').first);
    await tester.pumpAndSettle();
    expect(find.text('notes.pdf'), findsOneWidget);
    expect(find.text('essay.pdf'), findsNothing);
    await tester.tap(find.text('notes.pdf'));
    await tester.pumpAndSettle();
    expect(find.text('Notebook destination'), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Assignments').first);
    await tester.pumpAndSettle();
    expect(find.text('notes.pdf'), findsNothing);
    expect(find.text('essay.pdf'), findsOneWidget);
    await tester.tap(find.text('essay.pdf'));
    await tester.pumpAndSettle();
    expect(find.text('Work destination'), findsOneWidget);
  });

  testWidgets('retries a failed list request', (tester) async {
    final fake = _FakeFiles()..fail = true;
    await tester.pumpWidget(MaterialApp(home: MyFilesScreen(repository: fake)));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
    fake.fail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(fake.calls, 2);
    expect(find.text('notes.pdf'), findsOneWidget);
  });
}
