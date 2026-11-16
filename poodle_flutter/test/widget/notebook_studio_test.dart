import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/notebook_repository.dart';
import 'package:poodle_flutter/features/notebook/presentation/views/notebook_studio_panel.dart';

import 'package:poodle_flutter/ui/theme/poodle_theme.dart';

import '../support/fake_notebook_repository.dart';

class _StudioRepository extends FakeNotebookRepository {
  final requests = <(StudioKind, String, String)>[];
  List<StudyStudioItem> rows = [];
  @override
  Future<List<StudyStudioItem>> studioItems(String notebookId) async => rows;
  @override
  Future<void> generateStudio(
    String notebookId,
    StudioKind kind,
    String language,
    String requestKey,
  ) async {
    requests.add((kind, language, requestKey));
    rows = [_item(kind, status: 'queued', language: language)];
  }

  @override
  Future<StudyStudioItem> studioItem(
    String notebookId,
    String artifactId,
  ) async => rows.single;
}

StudyStudioItem _item(
  StudioKind kind, {
  String status = 'ready',
  String language = 'en',
}) => StudyStudioItem(
  id: kind.name,
  kind: kind,
  title: 'Practice artifact',
  status: status,
  language: language,
  createdAt: DateTime.utc(2026),
  citations: const [],
  contentJson: jsonEncode({
    'schemaVersion': 1,
    if (kind == StudioKind.quiz)
      'items': [
        {
          'type': 'multipleChoice',
          'prompt': 'Pick evidence.',
          'options': ['Evidence', 'Guess', 'Unrelated', 'Unclear'],
          'correctIndex': 0,
          'answer': 'Evidence',
          'explanation': 'Check the source.',
          'citationIds': [],
        },
        {
          'type': 'shortAnswer',
          'prompt': 'Why cite a source?',
          'answer': 'To verify the claim.',
          'explanation': 'Check the evidence.',
          'citationIds': [],
        },
      ],
    if (kind == StudioKind.flashcards)
      'cards': [
        {'front': 'Card front', 'back': 'Card back', 'citationIds': []},
      ],
    if (kind == StudioKind.audio)
      'sections': [
        {'text': 'Narrated evidence', 'citationIds': []},
      ],
  }),
);

Widget _view(_StudioRepository repo, String language, {int ready = 1}) =>
    MaterialApp(
      theme: PoodleTheme.build(),
      locale: Locale(language),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: NotebookStudioPanel(
          repository: repo,
          notebookId: 'notebook',
          active: true,
          readyCount: ready,
          sources: ready,
        ),
      ),
    );

void main() {
  testWidgets(
    'English Studio can queue Ukrainian audio and shows durable status',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = _StudioRepository();
      addTearDown(repo.dispose);
      await tester.pumpWidget(_view(repo, 'en'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Audio Overview'));
      await tester.pumpAndSettle();
      final cancel = tester.getRect(
        find.widgetWithText(OutlinedButton, 'Cancel'),
      );
      final generate = tester.getRect(
        find.widgetWithText(FilledButton, 'Generate'),
      );
      expect(cancel.top, generate.top);
      expect(cancel.height, generate.height);
      expect(cancel.width, closeTo(generate.width, 0.5));
      expect(generate.left - cancel.right, closeTo(12, 0.5));
      await tester.tap(find.byType(DropdownMenu<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Українська').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(repo.requests.single.$1, StudioKind.audio);
      expect(repo.requests.single.$2, 'uk');
      expect(find.text('Українська · Queued'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'quiz combines an automatic score and a short-answer self-check',
    (tester) async {
      final repo = _StudioRepository()..rows = [_item(StudioKind.quiz)];
      addTearDown(repo.dispose);
      await tester.pumpWidget(_view(repo, 'en'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Practice artifact'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, 'Evidence'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Show answer'));
      await tester.pumpAndSettle();
      expect(find.text('Check the source.'), findsOneWidget);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'To verify it.');
      await tester.tap(find.text('Show answer'));
      await tester.pumpAndSettle();
      expect(find.text('To verify the claim.'), findsOneWidget);
      await tester.tap(find.text('Incorrect'));
      await tester.pumpAndSettle();
      expect(find.text('Score: 1 / 2'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'Ukrainian flashcards flip and audio exposes transcript and playback',
    (tester) async {
      final repo = _StudioRepository()
        ..rows = [_item(StudioKind.flashcards, language: 'uk')];
      addTearDown(repo.dispose);
      await tester.pumpWidget(_view(repo, 'uk'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Practice artifact'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Показати відповідь'));
      await tester.pumpAndSettle();
      expect(find.text('Card back'), findsOneWidget);
      await tester.tap(find.text('Студія').first);
      await tester.pumpAndSettle();
      repo.rows = [_item(StudioKind.audio, language: 'uk')];
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Practice artifact'));
      await tester.pumpAndSettle();
      expect(find.text('Стенограма'), findsOneWidget);
      expect(find.text('Narrated evidence'), findsOneWidget);
      expect(find.byTooltip('Відтворити'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
