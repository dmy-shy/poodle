import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_client/poodle_client.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/student_grades_repository.dart';
import 'package:poodle_flutter/features/grades/presentation/views/student_grades_screen.dart';

void main() {
  testWidgets('shows published points and feedback and opens activity work', (
    tester,
  ) async {
    final courseId = const Uuid().v4obj();
    final activityId = const Uuid().v4obj();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => StudentGradesScreen(
            repository: _Grades(courseId, activityId),
          ),
        ),
        GoRoute(
          path: '/courses/:courseId/activity/:activityId/work',
          builder: (_, state) => Text(state.uri.path),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('0 / 50'), findsOneWidget);
    expect(find.text('Revise the conclusion'), findsOneWidget);
    await tester.tap(find.text('Essay'));
    await tester.pumpAndSettle();
    expect(
      find.text('/courses/$courseId/activity/$activityId/work'),
      findsOneWidget,
    );
  });
}

class _Grades implements StudentGradesRepository {
  _Grades(this.courseId, this.activityId);
  final UuidValue courseId;
  final UuidValue activityId;

  @override
  Future<StudentGradesResponse> listGrades() async => StudentGradesResponse(
    courses: [
      StudentGradeCourse(
        courseId: courseId,
        courseTitle: 'History',
        grades: [
          StudentGradeRow(
            courseId: courseId,
            courseTitle: 'History',
            activityId: activityId,
            activityTitle: 'Essay',
            kind: 'assignment',
            status: 'graded',
            points: 0,
            maximum: 50,
            feedback: 'Revise the conclusion',
          ),
        ],
      ),
    ],
  );
}
