import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/course_repository.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';
import 'package:poodle_flutter/features/notebook/presentation/view_models/notebook_settings_view_model.dart';
import 'package:poodle_flutter/features/notebook/presentation/views/notebook_settings_screen.dart';
import '../support/fake_notebook_repository.dart';

class _TeacherCourses extends PreviewCourseRepository {
  @override
  Future<CourseContent> content(String id) async {
    final value = await super.content(id);
    return CourseContent(
      course: value.course,
      sections: value.sections,
      teacherView: true,
    );
  }
}

void main() {
  for (final locale in ['en', 'uk']) {
    testWidgets(
      'teacher chooses materials and saves policy at large text: $locale',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repository = FakeNotebookRepository()..bindAccount('teacher');
        final model = NotebookSettingsViewModel(
          repository,
          'course',
          'assessment',
        );
        await model.load();
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: model,
            child: MaterialApp(
              locale: Locale(locale),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.5)),
                child: child!,
              ),
              home: const NotebookSettingsScreen(),
            ),
          ),
        );
        expect(find.text('Study notes'), findsOneWidget);
        await tester.ensureVisible(find.text('Extra notes'));
        await tester.tap(find.text('Extra notes'));
        final save = find.text(
          locale == 'uk'
              ? 'Зберегти налаштування блокнота'
              : 'Save notebook settings',
        );
        await tester.scrollUntilVisible(
          save,
          150,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.ensureVisible(save);
        await tester.pumpAndSettle();
        await tester.tap(save);
        await tester.pumpAndSettle();
        expect(repository.revisions, [1]);
        expect(model.materials, {'source', 'other'});
        expect(
          find.text(
            locale == 'uk'
                ? 'Налаштування блокнота збережено.'
                : 'Notebook settings saved.',
          ),
          findsOneWidget,
        );
        repository.bindAccount('student');
        await tester.pump();
        expect(find.text('Study notes'), findsNothing);
        expect(find.text('Extra notes'), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        model.dispose();
        repository.dispose();
      },
    );
  }
  testWidgets('course teacher settings button opens the injected setup route', (
    tester,
  ) async {
    final repository = FakeNotebookRepository();
    final courses = _TeacherCourses();
    final auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('teacher@example.test'),
    );
    final onboarding = OnboardingRepository(
      MemoryOnboardingStore(completed: true),
    );
    final dashboard = FakeDashboardRepository(latency: Duration.zero);
    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        courseRepository: courses,
        notebookRepository: repository,
        onboardingRepository: onboarding,
        dashboardRepository: dashboard,
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    GoRouter.of(
      tester.element(find.byType(Scaffold).first),
    ).go('/courses/$sampleDesignId');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byTooltip('Notebook settings').first,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byTooltip('Notebook settings').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Notebook settings').first);
    await tester.pumpAndSettle();
    expect(find.byType(NotebookSettingsScreen), findsOneWidget);
    expect(find.text('Study notes'), findsOneWidget);
    expect(repository.account, 'teacher@example.test');
    await tester.pumpWidget(const SizedBox());
    repository.dispose();
    courses.dispose();
    auth.dispose();
    onboarding.dispose();
  });
}
