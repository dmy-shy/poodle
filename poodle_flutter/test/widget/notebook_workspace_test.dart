import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/notebook_repository.dart';
import 'package:poodle_flutter/features/notebook/presentation/view_models/notebook_view_model.dart';
import 'package:poodle_flutter/features/notebook/presentation/views/notebook_screen.dart';
import 'package:poodle_flutter/ui/theme/poodle_theme.dart';
import '../support/fake_notebook_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final family in ['Roboto', 'MontserratAlternates']) {
      await (FontLoader(family)..addFont(
            rootBundle.load('assets/fonts/MontserratAlternates-Regular.ttf'),
          ))
          .load();
    }
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  for (final scenario in ['sources', 'empty', 'processing', 'answer', 'wide']) {
    for (final locale in ['en', 'uk']) {
      testWidgets('$scenario workspace visual and draft continuity: $locale', (
        tester,
      ) async {
        tester.view.physicalSize = Size(scenario == 'wide' ? 1200 : 430, 932);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repository = FakeNotebookRepository()..bindAccount('alice');
        repository.value = StudyNotebook(
          'notebook',
          true,
          [
            StudySource(
              'source',
              'Lecture notes / Конспект лекції',
              'ready',
              scenario != 'sources',
            ),
            const StudySource(
              'waiting',
              'Preparing document',
              'processing',
              false,
              privateUpload: true,
            ),
            const StudySource(
              'failed',
              'Protected document',
              'failed',
              false,
              privateUpload: true,
              failureCode: 'encrypted_document',
            ),
          ],
          allowedFormats: ['pdf', 'docx', 'txt', 'md'],
        );
        if (scenario == 'answer' || scenario == 'wide') {
          repository.history = [
            StudyTurn('user', 'user', 'Explain the key concept', false, []),
            StudyTurn(
              'answer',
              'assistant',
              '## Key concept\n\nLearning connects **evidence** with practice.\n\n- Read the source\n- Check the explanation',
              false,
              [
                const StudyCitation(
                  'Lecture notes',
                  'page 2',
                  1,
                  chunkId: 'chunk',
                ),
              ],
            ),
          ];
        }
        final model = NotebookViewModel(
          repository,
          'course',
          'assessment',
          pollInterval: const Duration(days: 1),
        );
        await model.load();
        if (scenario == 'processing') {
          await model.ask('Explain the key concept');
        }
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: model,
            child: MaterialApp(
              theme: PoodleTheme.build(),
              locale: Locale(locale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const RepaintBoundary(
                key: ValueKey('workspace'),
                child: NotebookScreen(),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 200));
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byKey(const ValueKey('workspace')),
          matchesGoldenFile('goldens/notebook_${scenario}_$locale.png'),
        );
        if (scenario == 'empty') {
          await tester.enterText(find.byType(TextField), 'My local draft');
          await tester.tap(
            find.widgetWithText(Tab, locale == 'uk' ? 'Джерела' : 'Sources'),
          );
          await tester.pump();
          await tester.tap(
            find.widgetWithText(Tab, locale == 'uk' ? 'Чат' : 'Chat'),
          );
          await tester.pump();
          expect(find.text('My local draft'), findsOneWidget);
          repository.bindAccount('bob');
          await tester.pump();
          expect(find.text('My local draft'), findsNothing);
        }
        await tester.pumpWidget(const SizedBox());
        model.dispose();
        repository.dispose();
      });
    }
  }
}
