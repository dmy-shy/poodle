import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_client/poodle_client.dart'
    show StudentTaskRow, StudentTasksResponse;
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/course_repository.dart';
import 'package:poodle_flutter/data/repositories/teaching_repository.dart';
import 'package:poodle_flutter/data/repositories/student_tasks_repository.dart';
import 'package:poodle_flutter/data/repositories/admin_overview_repository.dart';
import 'package:poodle_flutter/features/dashboard/presentation/views/live_home_screen.dart';
import 'package:poodle_flutter/features/dashboard/presentation/view_models/live_home_view_model.dart';
import 'package:poodle_flutter/features/dashboard/presentation/view_models/admin_directory_view_model.dart';

class Courses extends PreviewCourseRepository {
  @override
  Future<List<CourseInfo>> list() async => const [
    CourseInfo(id: sampleDesignId, title: 'Studying biology', role: 'student'),
  ];
}

class Tasks implements StudentTasksRepository {
  @override
  Future<StudentTasksResponse> listTasks() async => StudentTasksResponse(
    serverTime: DateTime.utc(2026),
    tasks: [
      StudentTaskRow(
        courseId: UuidValue.withValidation(sampleDesignId),
        courseTitle: 'Studying biology',
        activityId: UuidValue.withValidation(sampleWritingId),
        activityTitle: 'Read chapter',
        kind: 'assignment',
        deadline: DateTime.utc(2026, 12),
      ),
    ],
  );
}

class Teaching extends ChangeNotifier implements TeachingRepository {
  @override
  Future<List<TeachingCourseView>> dashboard() async => [
    TeachingCourseView(
      courseId: UuidValue.withValidation(sampleWritingId),
      title: 'Teaching writing',
      pendingGrades: 2,
      drafts: 1,
      unreleasedTests: 0,
      upcomingDeadlines: [],
    ),
  ];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class Admin implements AdminOverviewRepository {
  int calls = 0;
  bool fail = false;
  @override
  Future<AdminOverview> summary() async => AdminOverview(
    accounts: 3,
    students: 2,
    teachers: 1,
    admins: 1,
    courses: 2,
    pendingInvitations: 0,
  );
  @override
  Future<List<AdminDirectoryRow>> list(String category, int offset) async {
    calls++;
    if (fail) throw Exception('offline');
    return [AdminDirectoryRow(id: '1', label: 'person')];
  }
}

void main() {
  testWidgets('administrator metrics fill a phone row', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final auth = FakeAuthRepository(
      restoredSession: const AuthSession('admin@example.test', isAdmin: true),
    );
    final courses = Courses();
    final model = LiveHomeViewModel(courses, null, null, Admin());
    await model.refresh();
    addTearDown(model.dispose);
    addTearDown(auth.dispose);
    addTearDown(courses.dispose);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthRepository>.value(value: auth),
          ChangeNotifierProvider.value(value: model),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LiveHomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(Card).first).width, greaterThan(300));
  });

  for (final locale in ['en', 'uk']) {
    testWidgets('mixed course roles and contextual creation $locale', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(
        locale == 'uk' ? const Size(320, 568) : const Size(900, 1200),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final auth = FakeAuthRepository(
        restoredSession: const AuthSession('mixed@example.test'),
      );
      final courses = Courses();
      final teaching = Teaching();
      final model = LiveHomeViewModel(courses, Tasks(), teaching, null);
      await model.refresh();
      addTearDown(model.dispose);
      addTearDown(auth.dispose);
      addTearDown(courses.dispose);
      addTearDown(teaching.dispose);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: auth),
            ChangeNotifierProvider.value(value: model),
          ],
          child: MaterialApp(
            locale: Locale(locale),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(locale == 'uk' ? 2 : 1)),
              child: child!,
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const LiveHomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Read chapter'), findsOneWidget);
      expect(find.text('Studying biology'), findsOneWidget);
      expect(find.text('Teaching writing'), findsOneWidget);
      expect(find.text('Quick links'), findsNothing);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('Teaching writing'), findsNWidgets(2));
      expect(find.text('Studying biology'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  test(
    'directory retries failed pages without duplicating existing rows',
    () async {
      final repository = Admin();
      final model = AdminDirectoryViewModel(repository, 'accounts');
      await model.load();
      expect(model.rows.length, 1);
      repository.fail = true;
      await model.load();
      expect(model.failed, isTrue);
      expect(model.rows.length, 1);
      model.dispose();
      await model.load();
      expect(repository.calls, 2);
    },
  );
}
