import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/course_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';
import 'package:poodle_flutter/data/repositories/teaching_repository.dart';

class _TeacherCourses extends PreviewCourseRepository {
  @override
  Future<CourseContent> content(String id) async {
    final content = await super.content(id);
    return CourseContent(
      course: content.course,
      teacherView: true,
      sections: content.sections,
    );
  }
}

class _Teaching extends TeachingRepository {
  _Teaching(this.availableSections);
  final List<ContentSection> availableSections;
  TeachingSaveInput? saved;

  @override
  Future<TeachingSettings> defaults([TeachingSettings? value]) async =>
      TeachingSettings(title: '', instructions: '');

  @override
  Future<List<({String id, String title})>> sections(String course) async => [
    for (final section in availableSections)
      (id: section.id, title: section.title),
  ];

  @override
  Future<TeachingActivityView> save(TeachingSaveInput input) async {
    saved = input;
    return TeachingActivityView(
      activityId: input.activityId,
      courseId: input.courseId,
      sectionId: input.sectionId,
      kind: input.kind,
      revision: 1,
      published: false,
      released: false,
      teacher: true,
      settings: input.settings,
      questions: input.questions,
      submissions: [],
      attempts: [],
      serverTime: DateTime.utc(2026),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ObservedCourses extends PreviewCourseRepository {
  int reads = 0;
  @override
  Future<CourseContent> content(String id) {
    reads++;
    return super.content(id);
  }
}

class _PersonalCourses extends PreviewCourseRepository {
  bool starred = false, hidden = false;
  @override
  bool get supportsPreferences => true;
  CourseInfo get current => CourseInfo(
    id: sampleDesignId,
    title: 'Creative thinking / Творче мислення',
    starred: starred,
    hidden: hidden,
  );
  @override
  Future<List<CourseInfo>> list() async => [current];
  @override
  Future<CourseInfo> setStarred(String id, bool value) async {
    starred = value;
    return current;
  }

  @override
  Future<CourseInfo> setHidden(String id, bool value) async {
    hidden = value;
    return current;
  }
}

Future<GoRouter> start(
  WidgetTester tester,
  CourseRepository courses, {
  bool signedIn = true,
  TeachingRepository? teaching,
}) async {
  final auth = FakeAuthRepository(
    latency: Duration.zero,
    restoredSession: signedIn
        ? const AuthSession('student@example.test')
        : null,
  );
  final onboarding = OnboardingRepository(
    MemoryOnboardingStore(completed: true),
  );
  await tester.pumpWidget(
    PoodleApp(
      repository: auth,
      courseRepository: courses,
      teachingRepository: teaching,
      onboardingRepository: onboarding,
      minimumSplashDuration: Duration.zero,
      dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
    ),
  );
  await tester.pumpAndSettle();
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    auth.dispose();
    onboarding.dispose();
    courses.dispose();
  });
  return GoRouter.of(
    tester.element(find.text(signedIn ? 'Upcoming tasks' : 'Welcome back')),
  );
}

void main() {
  testWidgets('star and hide work from the course menu with recovery filters', (
    tester,
  ) async {
    final courses = _PersonalCourses();
    final router = await start(tester, courses);
    router.go('/courses');
    await tester.pumpAndSettle();
    final initialCardHeight = tester
        .getSize(
          find
              .ancestor(
                of: find.text(courses.current.title),
                matching: find.byType(Card),
              )
              .last,
        )
        .height;
    expect(find.bySemanticsLabel('Favorite course'), findsNothing);
    await tester.tap(find.byTooltip('Course actions').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Star this course'));
    await tester.pumpAndSettle();
    expect(courses.starred, true);
    expect(
      tester
          .getSize(
            find
                .ancestor(
                  of: find.text(courses.current.title),
                  matching: find.byType(Card),
                )
                .last,
          )
          .height,
      initialCardHeight,
    );
    expect(find.bySemanticsLabel('Favorite course'), findsOneWidget);
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text(courses.current.title), findsOneWidget);
    await tester.tap(find.byTooltip('Course actions').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove from view'));
    await tester.pumpAndSettle();
    expect(courses.hidden, true);
    expect(find.text(courses.current.title), findsNothing);
    await tester.tap(find.text('Hidden'));
    await tester.pumpAndSettle();
    expect(find.text(courses.current.title), findsOneWidget);
    await tester.tap(find.byTooltip('Course actions').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show in view'));
    await tester.pumpAndSettle();
    expect(courses.hidden, false);
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Course actions').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Unstar this course'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Favorite course'), findsNothing);
    expect(find.text(courses.current.title), findsOneWidget);
  });
  for (final locale in ['en', 'uk']) {
    testWidgets('favorite marker fits narrow $locale cards with large text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final courses = _PersonalCourses()..starred = true;
      final router = await start(tester, courses);
      tester.platformDispatcher.localesTestValue = [Locale(locale)];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      router.go('/courses');
      await tester.pumpAndSettle();
      final star = find.bySemanticsLabel(
        locale == 'uk' ? 'Обраний курс' : 'Favorite course',
      );
      expect(star, findsOneWidget);
      final menu = find.byTooltip('Course actions').last;
      expect(
        tester.getRect(star).bottom,
        lessThanOrEqualTo(tester.getRect(menu).top),
      );
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(menu);
      await tester.pumpAndSettle();
      await tester.tap(menu);
      await tester.pumpAndSettle();
      expect(
        find.text(locale == 'uk' ? 'Прибрати зірку' : 'Unstar this course'),
        findsOneWidget,
      );
    });
  }
  testWidgets('teacher creates a Test from its course section', (tester) async {
    final courses = _TeacherCourses();
    final sections = (await courses.content(sampleDesignId)).sections;
    final teaching = _Teaching(sections);
    final router = await start(tester, courses, teaching: teaching);
    router.go('/courses/$sampleDesignId');
    await tester.pumpAndSettle();
    final action = find.widgetWithText(ExpansionTile, sections.last.title);
    final create = find.descendant(
      of: action,
      matching: find.text('Create test'),
    );
    await tester.ensureVisible(create);
    await tester.pumpAndSettle();
    await tester.tap(create);
    await tester.pumpAndSettle();
    expect(find.text(sections.last.title).hitTestable(), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Final exam',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Instructions'),
      'Review the notes.',
    );
    final save = find.text('Save draft');
    await tester.scrollUntilVisible(
      save,
      250,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(teaching.saved?.kind, 'test');
    expect(teaching.saved?.sectionId.toString(), sections.last.id);
    expect(teaching.saved?.settings.title, 'Final exam');
  });

  testWidgets(
    'UUID course shows section index and read-only assessment navigation',
    (tester) async {
      final repository = PreviewCourseRepository();
      final router = await start(tester, repository);
      router.go('/courses/$sampleDesignId');
      await tester.pumpAndSettle();
      expect(find.text('Sample course'), findsNothing);
      expect(find.text('Create test'), findsNothing);
      expect(find.byTooltip('Sections'), findsOneWidget);
      await tester.ensureVisible(find.text('Module 1 / Модуль 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Module 1 / Модуль 1'));
      await tester.pumpAndSettle();
      expect(find.text('Available'), findsOneWidget);
      expect(
        find.textContaining('Attempts and submissions are not available'),
        findsOneWidget,
      );
      expect(find.text('Allowed attempts: 1'), findsOneWidget);
      expect(find.text('Start attempt'), findsNothing);
      await tester.tap(find.text('Next activity'));
      await tester.pumpAndSettle();
      expect(find.text('Lab 1 / Лабораторна 1'), findsOneWidget);
      expect(find.text('No availability dates'), findsOneWidget);
      expect(find.text('Next activity'), findsNothing);
    },
  );
  testWidgets(
    'numeric and slug routes are unavailable without reading repository',
    (tester) async {
      final repository = ObservedCourses();
      final router = await start(tester, repository);
      for (final id in ['1', 'course-design']) {
        router.go('/courses/$id');
        await tester.pumpAndSettle();
        expect(
          find.text('This course or activity is unavailable.'),
          findsOneWidget,
        );
      }
      expect(repository.reads, 0);
    },
  );
  testWidgets('signed-out UUID deep link stays behind authentication', (
    tester,
  ) async {
    final repository = ObservedCourses();
    final router = await start(tester, repository, signedIn: false);
    router.go('/courses/$sampleDesignId');
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(repository.reads, 0);
  });
  testWidgets('Ukrainian course controls fit a small screen with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    tester.platformDispatcher.localesTestValue = [const Locale('uk')];
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('student@example.test'),
    );
    final onboarding = OnboardingRepository(
      MemoryOnboardingStore(completed: true),
    );
    final repository = PreviewCourseRepository();
    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        courseRepository: repository,
        onboardingRepository: onboarding,
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    final router = GoRouter.of(tester.element(find.text('Найближчі завдання')));
    router.go('/courses/$sampleDesignId');
    await tester.pumpAndSettle();
    expect(find.byTooltip('Розділи'), findsOneWidget);
    expect(find.text('Приклад курсу'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    auth.dispose();
    onboarding.dispose();
    repository.dispose();
  });
}
