import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/notebook_repository.dart';
import 'package:poodle_flutter/features/notebook/presentation/view_models/notebook_view_model.dart';
import '../../../support/fake_notebook_repository.dart';

void main() {
  late FakeNotebookRepository repository;
  late NotebookViewModel model;
  setUp(() {
    repository = FakeNotebookRepository()..bindAccount('alice');
    model = NotebookViewModel(
      repository,
      'course',
      'assessment',
      pollInterval: const Duration(days: 1),
    );
    addTearDown(model.dispose);
    addTearDown(repository.dispose);
  });
  test(
    'passage failures clear evidence and account changes fence late reads',
    () async {
      await model.load();
      const citation = StudyCitation('Notes', 'block-1', 1, chunkId: 'chunk');
      await model.openPassage('turn', citation);
      expect(model.passage, 'Stored supporting passage');
      model.closePassage();
      expect(model.passage, isNull);
      repository.failure = NotebookFailure.network;
      await model.openPassage('turn', citation);
      expect(model.passageError, NotebookFailure.network);
      expect(model.passage, isNull);
      repository.failure = null;
      repository.passageHold = Completer<String>();
      final loading = model.openPassage('turn', citation);
      repository.bindAccount('bob');
      repository.passageHold!.complete('Must stay private');
      await loading;
      expect(model.passage, isNull);
      expect(model.passageLoading, false);
    },
  );
  test('closing or changing sources fences an in-flight passage', () async {
    await model.load();
    const citation = StudyCitation('Notes', 'block-1', 1, chunkId: 'chunk');
    for (final close in [true, false]) {
      repository.passageHold = Completer<String>();
      final loading = model.openPassage('turn', citation);
      if (close) {
        model.closePassage();
      } else {
        await model.select('source', false);
      }
      repository.passageHold!.complete('Must stay private');
      await loading;
      expect(model.passage, isNull);
    }
  });
  test(
    'loads sources and history, then persists selection through repository',
    () async {
      repository.history = [
        StudyTurn('turn', 'assistant', 'Answer', false, []),
      ];
      await model.load();
      expect(model.history.single.content, 'Answer');
      expect(model.canAsk, true);
      await model.select('source', false);
      expect(model.notebook!.sources.single.selected, false);
      expect(model.canAsk, false);
    },
  );
  test('cached notebook remains readable without allowing writes', () async {
    repository.history = [
      StudyTurn('turn', 'assistant', 'Saved answer', false, []),
    ];
    await model.load();
    repository.stale = true;
    expect(model.history.single.content, 'Saved answer');
    expect(model.canAsk, isFalse);
    await model.select('source', false);
    expect(model.notebook!.sources.single.selected, isTrue);
    await model.ask('Question');
    expect(repository.keys, isEmpty);
  });
  test(
    'ambiguous submission retries reuse request key and completed job loads history',
    () async {
      await model.load();
      repository.failure = NotebookFailure.network;
      await model.ask('Question');
      expect(model.error, NotebookFailure.network);
      repository.failure = null;
      await model.ask('Question');
      expect(repository.keys.toSet(), hasLength(1));
      expect(model.pending!.status, 'queued');
      repository.history = [
        StudyTurn('turn', 'assistant', 'Grounded answer', false, []),
      ];
      await model.poll();
      expect(model.pending, isNull);
      expect(model.history.single.content, 'Grounded answer');
    },
  );
  test('changing question uses a new key after failed submission', () async {
    await model.load();
    repository.failure = NotebookFailure.network;
    await model.ask('Question one');
    await model.ask('Question two');
    expect(repository.keys.toSet(), hasLength(2));
  });
  test('failed answer keeps the workspace and can be retried', () async {
    repository.history = [
      StudyTurn('old', 'assistant', 'Earlier answer', false, []),
    ];
    await model.load();
    await model.ask('Compare noun plurals');

    repository.failure = NotebookFailure.processing;
    await model.poll();
    expect(model.readyCount, 1);
    expect(model.history.single.content, 'Earlier answer');
    expect(model.submittedQuestion, 'Compare noun plurals');
    expect(model.error, NotebookFailure.processing);
    expect(model.pending, isNull);
    expect(model.questionFailed, isTrue);

    repository.failure = null;
    await model.ask(model.submittedQuestion!);
    expect(repository.keys.toSet(), hasLength(2));
    expect(model.pending, isNotNull);
  });
  test(
    'account switch clears private state and ignores late responses',
    () async {
      repository.hold = Completer<StudyNotebook>();
      final loading = model.load();
      repository.bindAccount('bob');
      repository.hold!.complete(repository.value);
      await loading;
      expect(model.notebook, isNull);
      expect(model.history, isEmpty);
      expect(model.pending, isNull);
    },
  );
  test(
    'network polling keeps pending job for explicit refresh; access failure clears it',
    () async {
      await model.load();
      await model.ask('Question');
      repository.failure = NotebookFailure.network;
      await model.poll();
      expect(model.pending, isNotNull);
      expect(model.error, NotebookFailure.network);
      repository.failure = NotebookFailure.unavailable;
      await model.poll();
      expect(model.pending, isNull);
      expect(model.history, isEmpty);
    },
  );
  test(
    'network refresh preserves answers and pending question until result reload',
    () async {
      repository.history = [
        StudyTurn('old', 'assistant', 'Existing answer', false, []),
      ];
      await model.load();
      await model.ask('New question');
      expect(model.submittedQuestion, 'New question');
      repository.failure = NotebookFailure.network;
      await model.poll();
      expect(model.history.single.content, 'Existing answer');
      expect(model.submittedQuestion, 'New question');
      expect(model.pending, isNotNull);
      repository.failure = null;
      await model.poll();
      expect(model.submittedQuestion, isNull);
    },
  );
  test('readiness excludes failed and preparing selections', () async {
    repository.value = StudyNotebook('notebook', true, [
      const StudySource('ready', 'Ready', 'ready', true),
      const StudySource('queued', 'Queued', 'queued', true),
      const StudySource('failed', 'Failed', 'failed', true),
    ]);
    await model.load();
    expect(model.readyCount, 1);
    expect(model.excludedCount, 2);
    expect(model.preparing, true);
    model.setForeground(false);
    repository.bindAccount('bob');
    expect(model.readyCount, 0);
    expect(model.submittedQuestion, isNull);
  });
  test('disposal suppresses a late load', () async {
    final extra = NotebookViewModel(repository, 'course', 'assessment');
    repository.hold = Completer<StudyNotebook>();
    final loading = extra.load();
    extra.dispose();
    repository.hold!.complete(repository.value);
    await loading;
    expect(extra.notebook, isNull);
  });
  test(
    'source checkbox changes before the server confirms selection',
    () async {
      await model.load();
      repository.selectHold = Completer<void>();
      final selection = model.select('source', false);
      expect(model.notebook!.sources.single.selected, false);
      expect(model.selectionSaving, true);
      expect(model.canAsk, false);
      repository.selectHold!.complete();
      await selection;
      expect(model.selectionSaving, false);
    },
  );

  test(
    'question appears before enqueue responds and is retained on failure',
    () async {
      await model.load();
      repository.askHold = Completer<StudyJob>();
      final sending = model.ask('Question');
      expect(model.submittedQuestion, 'Question');
      expect(model.sending, true);
      repository.askHold!.completeError(NotebookFailure.network);
      await sending;
      expect(model.submittedQuestion, 'Question');
      expect(model.questionFailed, true);
      expect(model.sending, false);
    },
  );
}
