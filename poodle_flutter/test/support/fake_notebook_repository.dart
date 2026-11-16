import 'dart:async';
import 'package:poodle_flutter/data/repositories/notebook_repository.dart';

class FakeNotebookRepository extends NotebookRepository {
  bool stale = false;
  @override
  bool get isStale => stale;
  StudyNotebook value = StudyNotebook('notebook', true, [
    const StudySource('source', 'Study notes', 'ready', true),
  ]);
  List<StudyTurn> history = [];
  StudyJob status = const StudyJob('job', 'complete');
  NotebookFailure? failure;
  Completer<StudyNotebook>? hold;
  Completer<void>? selectHold;
  Completer<StudyJob>? askHold;
  StudyNotebookSetup settings = StudyNotebookSetup(1, ['source'], ['txt'], [
    const StudyMaterialOption('source', 'Study notes', 'txt'),
    const StudyMaterialOption('other', 'Extra notes', 'pdf'),
  ]);
  Completer<StudyNotebookSetup>? settingsHold;
  Completer<void>? configureHold;
  final revisions = <int>[];
  @override
  Future<StudyNotebookSetup> assessmentSetup(
    String courseId,
    String assessmentId,
  ) async {
    if (failure != null) throw failure!;
    return settingsHold == null ? settings : settingsHold!.future;
  }

  @override
  Future<void> configure(
    String courseId,
    String assessmentId,
    int revision,
    List<String> materialIds,
    List<String> formats,
  ) async {
    revisions.add(revision);
    if (failure != null) throw failure!;
    await configureHold?.future;
    settings = StudyNotebookSetup(
      revision + 1,
      materialIds,
      formats,
      settings.materials,
    );
  }

  final keys = <String>[];
  Completer<String>? passageHold;
  @override
  Future<String> citationPassage(
    String notebookId,
    String turnId,
    String chunkId,
  ) async {
    if (failure != null) throw failure!;
    return passageHold == null
        ? 'Stored supporting passage'
        : passageHold!.future;
  }

  @override
  Future<StudyNotebook> open(String courseId, String assessmentId) async {
    if (failure != null) throw failure!;
    return hold == null ? value : hold!.future;
  }

  @override
  Future<List<StudyTurn>> turns(String notebookId) async => history;
  @override
  Future<void> select(String notebookId, List<String> ids) async {
    await selectHold?.future;
    value = StudyNotebook(
      value.id,
      value.configured,
      value.sources.map(
        (s) => StudySource(s.id, s.title, s.status, ids.contains(s.id)),
      ),
    );
  }

  @override
  Future<StudyJob> ask(
    String notebookId,
    String question,
    String requestKey,
  ) async {
    keys.add(requestKey);
    if (failure != null) throw failure!;
    if (askHold != null) return askHold!.future;
    return const StudyJob('job', 'queued');
  }

  @override
  Future<StudyJob> job(String notebookId, String jobId) async {
    if (failure != null) throw failure!;
    return status;
  }
}
