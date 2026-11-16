import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';
import 'package:poodle_flutter/data/repositories/course_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/notebook_repository.dart';
import 'package:poodle_flutter/features/notebook/presentation/view_models/notebook_view_model.dart';
import 'package:poodle_flutter/features/notebook/presentation/views/notebook_screen.dart';
import '../support/fake_notebook_repository.dart';

void main() {
  testWidgets('module route opens the injected private notebook', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final courses = PreviewCourseRepository();
    final course = (await courses.list()).first;
    final content = await courses.content(course.id);
    final module = content.sections
        .expand((s) => s.activities)
        .firstWhere((a) => a.kind == ActivityKind.module);
    final auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('student@example.test'),
    );
    final notebook = FakeNotebookRepository();
    final onboarding = OnboardingRepository(
      MemoryOnboardingStore(completed: true),
    );
    final dashboard = FakeDashboardRepository(latency: Duration.zero);
    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        courseRepository: courses,
        notebookRepository: notebook,
        onboardingRepository: onboarding,
        dashboardRepository: dashboard,
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    GoRouter.of(
      tester.element(find.byType(Scaffold).first),
    ).go('/courses/${course.id}/activity/${module.id}');
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Test'), findsOneWidget);
    final notebookAction = find.byType(FloatingActionButton);
    expect(notebookAction, findsOneWidget);
    expect(find.byTooltip('Study notebook'), findsOneWidget);
    expect(find.text('Study notebook'), findsNothing);
    expect(
      find.byKey(const ValueKey('study-notebook-indicator')),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text('Next activity'));
    await tester.pumpAndSettle();
    expect(
      tester
          .getRect(notebookAction)
          .overlaps(
            tester.getRect(
              find.widgetWithText(OutlinedButton, 'Next activity'),
            ),
          ),
      isFalse,
    );
    expect(
      tester.getRect(notebookAction).bottom,
      lessThan(tester.getRect(find.byType(NavigationBar)).top),
    );
    await tester.tap(notebookAction);
    await tester.pumpAndSettle();
    expect(find.byType(NotebookScreen), findsOneWidget);
    await tester.tap(find.widgetWithText(Tab, 'Sources'));
    await tester.pumpAndSettle();
    expect(find.text('Study notes'), findsOneWidget);
    expect(notebook.account, 'student@example.test');
    await tester.pumpWidget(const SizedBox());
    notebook.dispose();
    courses.dispose();
    auth.dispose();
    onboarding.dispose();
  });

  for (final locale in ['en', 'uk']) {
    testWidgets(
      'document failures explain recovery without leaking codes: $locale',
      (tester) async {
        final repository = FakeNotebookRepository()..bindAccount('alice');
        repository.value = StudyNotebook('notebook', true, [
          for (final code in [
            'encrypted_document',
            'empty_source',
            'extraction_limit',
            'active_content',
          ])
            StudySource(code, '$code.pdf', 'failed', true, failureCode: code),
        ]);
        final model = NotebookViewModel(repository, 'course', 'assessment');
        await model.load();
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: model,
            child: MaterialApp(
              locale: Locale(locale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const NotebookScreen(),
            ),
          ),
        );
        expect(
          find.textContaining(
            locale == 'uk' ? 'Захищені паролем' : 'Password-protected',
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining(
            locale == 'uk' ? 'Не знайдено тексту' : 'No readable text',
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining(
            locale == 'uk' ? 'надто складний' : 'too large or complex',
          ),
          findsOneWidget,
        );
        await tester.ensureVisible(
          find.textContaining(
            locale == 'uk' ? 'непідтримуваний вміст' : 'unsupported content',
          ),
        );
        expect(
          find.textContaining(
            locale == 'uk' ? 'непідтримуваний вміст' : 'unsupported content',
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        model.dispose();
        repository.dispose();
      },
    );
    testWidgets(
      'localized notebook sources, chat and citations at large text: $locale',
      (tester) async {
        final repository = FakeNotebookRepository()..bindAccount('alice');
        repository.value = StudyNotebook(
          'notebook',
          true,
          [
            const StudySource('source', 'Study notes', 'ready', true),
            const StudySource(
              'private',
              'My private notes',
              'ready',
              true,
              privateUpload: true,
            ),
          ],
          allowedFormats: ['txt'],
        );
        repository.history = [
          StudyTurn('turn', 'assistant', 'Grounded answer', false, [
            const StudyCitation('Study notes', 'block-1', 1, chunkId: 'chunk'),
          ]),
        ];
        final model = NotebookViewModel(repository, 'course', 'assessment');
        await model.load();
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: model,
            child: MaterialApp(
              locale: Locale(locale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.5)),
                child: child!,
              ),
              home: const NotebookScreen(),
            ),
          ),
        );
        expect(
          find.text(locale == 'uk' ? 'Навчальний блокнот' : 'Study notebook'),
          findsOneWidget,
        );
        await tester.tap(
          find.widgetWithText(Tab, locale == 'uk' ? 'Джерела' : 'Sources'),
        );
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.byTooltip(
            locale == 'uk' ? 'Видалити приватний файл' : 'Remove private file',
          ),
          150,
          scrollable: find.descendant(
            of: find.byKey(const PageStorageKey('notebook-sources')),
            matching: find.byType(Scrollable),
          ),
        );
        expect(
          find.byTooltip(
            locale == 'uk' ? 'Видалити приватний файл' : 'Remove private file',
          ),
          findsOneWidget,
        );
        await tester.scrollUntilVisible(
          find.text(
            locale == 'uk' ? 'Додати приватний файл' : 'Add private file',
          ),
          150,
          scrollable: find.descendant(
            of: find.byKey(const PageStorageKey('notebook-sources')),
            matching: find.byType(Scrollable),
          ),
        );
        expect(
          find.text(
            locale == 'uk' ? 'Додати приватний файл' : 'Add private file',
          ),
          findsOneWidget,
        );
        await tester.tap(
          find.widgetWithText(Tab, locale == 'uk' ? 'Чат' : 'Chat'),
        );
        await tester.pumpAndSettle();
        expect(find.text('Grounded answer'), findsOneWidget);
        final citation = find.widgetWithText(ActionChip, '1. Study notes');
        expect(citation, findsOneWidget);
        await tester.ensureVisible(citation);
        await tester.tap(citation);
        await tester.pumpAndSettle();
        expect(
          find.text(locale == 'uk' ? 'Уривок джерела' : 'Source passage'),
          findsOneWidget,
        );
        expect(find.text('Stored supporting passage'), findsOneWidget);
        repository.bindAccount('temporary');
        await tester.pump();
        expect(find.text('Stored supporting passage'), findsNothing);
        await tester.tap(find.byTooltip(locale == 'uk' ? 'Закрити' : 'Close'));
        await tester.pumpAndSettle();
        await model.load();
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Private question');
        await tester.pump();
        final send = find.byTooltip(locale == 'uk' ? 'Запитати' : 'Ask');
        expect(
          tester.getCenter(send).dy,
          closeTo(tester.getCenter(find.byType(TextField)).dy, 1),
        );
        expect(
          tester.getCenter(send).dx,
          greaterThan(tester.getCenter(find.byType(TextField)).dx),
        );
        await tester.tap(send);
        await tester.pump();
        expect(model.pending, isNotNull);
        repository.bindAccount('bob');
        await tester.pump();
        expect(find.text('Private question'), findsNothing);
        expect(find.text('Grounded answer'), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        model.dispose();
        repository.dispose();
      },
    );
  }
}
