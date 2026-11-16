import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_client/poodle_client.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';
import 'package:poodle_flutter/data/repositories/student_tasks_repository.dart';
import 'package:poodle_flutter/features/tasks/presentation/views/student_tasks_screen.dart';

void main() {
  testWidgets('Tasks in More opens the student deadline list', (tester) async {
    final auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('student@example.com'),
    );
    final onboarding = OnboardingRepository(
      MemoryOnboardingStore(completed: true),
    );
    addTearDown(auth.dispose);
    addTearDown(onboarding.dispose);
    final repo = _Tasks()..calls = 1;

    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        onboardingRepository: onboarding,
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        studentTasksRepository: repo,
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tasks').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tasks').last);
    await tester.pumpAndSettle();
    expect(find.text('Due exactly now'), findsOneWidget);
  });

  testWidgets('retries, groups by server time, filters and opens work', (
    tester,
  ) async {
    final repo = _Tasks();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => StudentTasksScreen(repository: repo),
        ),
        GoRoute(
          path: '/courses/:courseId/activity/:activityId/work',
          builder: (_, state) => Scaffold(body: Text(state.uri.path)),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(repo.calls, 2);
    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Due exactly now')).dy,
      lessThan(tester.getTopLeft(find.text('Upcoming')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Future test')).dy,
      greaterThan(tester.getTopLeft(find.text('Upcoming')).dy),
    );

    await tester.tap(find.text('All courses'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Biology').last);
    await tester.pumpAndSettle();
    expect(find.text('Due exactly now'), findsNothing);
    expect(find.text('Future test'), findsOneWidget);

    await tester.tap(find.text('Future test'));
    await tester.pumpAndSettle();
    expect(
      find.text('/courses/${repo.biology}/activity/${repo.testId}/work'),
      findsOneWidget,
    );
  });
}

class _Tasks implements StudentTasksRepository {
  int calls = 0;
  final biology = const Uuid().v4obj();
  final testId = const Uuid().v4obj();

  @override
  Future<StudentTasksResponse> listTasks() async {
    if (++calls == 1) throw StateError('offline');
    final now = DateTime.utc(2040, 1, 1, 12);
    return StudentTasksResponse(
      serverTime: now,
      tasks: [
        StudentTaskRow(
          courseId: const Uuid().v4obj(),
          courseTitle: 'History',
          activityId: const Uuid().v4obj(),
          activityTitle: 'Due exactly now',
          deadline: now,
          kind: 'assignment',
        ),
        StudentTaskRow(
          courseId: biology,
          courseTitle: 'Biology',
          activityId: testId,
          activityTitle: 'Future test',
          deadline: now.add(const Duration(minutes: 1)),
          kind: 'test',
        ),
      ],
    );
  }
}
