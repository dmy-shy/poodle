import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/institution_repository.dart';
import 'package:poodle_flutter/features/university/presentation/views/teacher_courses_screen.dart';
import 'package:poodle_flutter/features/university/presentation/view_models/teacher_courses_view_model.dart';

class Teaching extends InstitutionRepository {
  final rows = <ManagedCourse>[];
  String? invited, scope;
  @override
  Future<List<ManagedCourse>> courses() async => List.of(rows);
  @override
  Future<String> createCourse(String title) async {
    rows.add(ManagedCourse('one', title, false));
    return 'one';
  }

  @override
  Future<void> publish(String id, bool published) async {
    rows[0] = ManagedCourse(id, rows[0].title, published);
  }

  @override
  Future<void> invite(String email, String purpose, {String? courseId}) async {
    expect(purpose, 'student');
    invited = email;
    scope = courseId;
  }
}

void main() {
  testWidgets(
    'teacher creates a draft, publishes and invites into that course',
    (tester) async {
      final repository = Teaching();
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TeacherCoursesViewModel(repository)..load(),
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const TeacherCoursesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('course-title')),
        'New mathematics course',
      );
      await tester.tap(find.text('Create course'));
      await tester.pumpAndSettle();
      expect(find.text('Draft — visible only to teachers'), findsOneWidget);
      await tester.ensureVisible(find.text('Publish course'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Publish course'));
      await tester.pumpAndSettle();
      expect(find.text('Published'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('student-email-one')),
        'student@example.test',
      );
      await tester.ensureVisible(find.text('Invite student'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invite student'));
      await tester.pumpAndSettle();
      expect(repository.invited, 'student@example.test');
      expect(repository.scope, 'one');
    },
  );
}
