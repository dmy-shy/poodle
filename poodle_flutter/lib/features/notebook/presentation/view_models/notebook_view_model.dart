import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../../data/repositories/notebook_repository.dart';

class NotebookViewModel extends ChangeNotifier {
  NotebookViewModel(
    this.repository,
    this.courseId,
    this.assessmentId, {
    this.pollInterval = const Duration(seconds: 2),
  }) {
    repository.addListener(_accountChanged);
  }
  final NotebookRepository repository;
  final String courseId, assessmentId;
  final Duration pollInterval;
  StudyNotebook? notebook;
  List<StudyTurn> history = const [];
  NotebookFailure? error;
  bool busy = false;
  StudyJob? pending;
  bool importing = false;
  bool sending = false;
  bool questionFailed = false;
  bool selectionSaving = false;
  bool removingUpload = false;
  bool needsReconcile = false;
  String? uploadingFileName;
  bool _foreground = true;
  String? submittedQuestion;
  int get readyCount =>
      notebook?.sources
          .where((s) => s.selected && s.status == 'ready')
          .length ??
      0;
  int get excludedCount =>
      notebook?.sources
          .where((s) => s.selected && s.status != 'ready')
          .length ??
      0;
  bool get preparing =>
      notebook?.sources.any(
        (s) => s.status != 'ready' && s.status != 'failed',
      ) ??
      false;
  void setForeground(bool value) {
    _foreground = value;
    _timer?.cancel();
    if (value &&
        !_disposed &&
        !repository.isStale &&
        (pending != null || preparing)) {
      poll();
    }
  }

  String? passage;
  bool passageLoading = false;
  NotebookFailure? passageError;
  int _passageRequest = 0;

  void _clearPassage() {
    _passageRequest++;
    passage = null;
    passageLoading = false;
    passageError = null;
  }

  void closePassage() {
    if (_disposed) return;
    _clearPassage();
    notifyListeners();
  }

  Future<void> openPassage(String turnId, StudyCitation citation) async {
    if (_disposed || notebook?.id == null || citation.chunkId == null) {
      return;
    }
    _clearPassage();
    final request = _passageRequest;
    final epoch = _epoch;
    passageLoading = true;
    notifyListeners();
    try {
      final value = await repository.citationPassage(
        notebook!.id!,
        turnId,
        citation.chunkId!,
      );
      if (_current(epoch) && request == _passageRequest) passage = value;
    } catch (failure) {
      if (_current(epoch) && request == _passageRequest) {
        passageError = failure is NotebookFailure
            ? failure
            : NotebookFailure.unavailable;
      }
    } finally {
      if (_current(epoch) && request == _passageRequest) {
        passageLoading = false;
        notifyListeners();
      }
    }
  }

  String? _retryQuestion, _requestKey;
  Timer? _timer;
  bool _disposed = false;
  int _epoch = 0;
  bool get canAsk =>
      !busy &&
      !repository.isStale &&
      !needsReconcile &&
      pending == null &&
      readyCount > 0;
  void _accountChanged() {
    _clearPassage();
    _epoch++;
    _timer?.cancel();
    notebook = null;
    history = const [];
    pending = null;
    submittedQuestion = null;
    importing = false;
    sending = questionFailed = selectionSaving = removingUpload = false;
    needsReconcile = false;
    uploadingFileName = null;
    _retryQuestion = null;
    _requestKey = null;
    busy = false;
    error = NotebookFailure.cancelled;
    notifyListeners();
  }

  Future<void> _command(Future<void> Function(int epoch) action) async {
    if (_disposed) return;
    if (busy) {
      if (pending != null || preparing) _schedule();
      return;
    }
    final epoch = _epoch;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await action(epoch);
    } catch (failure) {
      if (epoch == _epoch && !_disposed) {
        error = failure is NotebookFailure
            ? failure
            : NotebookFailure.unavailable;
        // Do not keep showing sensitive cached answers after access loss.
        if (error == NotebookFailure.cancelled ||
            error == NotebookFailure.unavailable) {
          history = const [];
          notebook = null;
          submittedQuestion = null;
          _clearPassage();
        }
      }
    } finally {
      if (epoch == _epoch && !_disposed) {
        busy = false;
        uploadingFileName = null;
        notifyListeners();
      }
    }
  }

  bool _current(int epoch) => !_disposed && epoch == _epoch;
  Future<void> _load(int epoch) async {
    final overview = await repository.open(courseId, assessmentId);
    final turns = overview.id == null
        ? <StudyTurn>[]
        : await repository.turns(overview.id!);
    if (!_current(epoch)) return;
    notebook = overview;
    history = List.unmodifiable(turns);
    needsReconcile = false;
  }

  Future<void> load() => _command((epoch) async {
    await _load(epoch);
    if ((pending != null || preparing) &&
        _current(epoch) &&
        !repository.isStale) {
      _schedule();
    }
  });
  Future<void> upload() => _command((epoch) async {
    if (repository.isStale) throw NotebookFailure.network;
    final current = notebook;
    if (current?.id == null || pending != null || needsReconcile) return;
    final random = Random.secure();
    final key = List.generate(
      24,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    final job = await repository.upload(
      current!.id!,
      current.allowedFormats,
      key,
      onPicked: (name) {
        if (_current(epoch)) {
          uploadingFileName = name;
          notifyListeners();
        }
      },
    );
    if (!_current(epoch) || job == null) return;
    uploadingFileName = null;
    importing = true;
    pending = job;
    await _load(epoch);
    if (_current(epoch)) _schedule();
  });
  Future<void> removeUpload(String sourceId) => _command((epoch) async {
    if (repository.isStale) throw NotebookFailure.network;
    final original = notebook;
    final id = original?.id;
    if (id == null || pending != null || needsReconcile) return;
    _clearPassage();
    history = const [];
    removingUpload = true;
    notebook = StudyNotebook(
      id,
      original!.configured,
      original.sources.where((source) => source.id != sourceId),
      allowedFormats: original.allowedFormats,
    );
    notifyListeners();
    try {
      await repository.removeUpload(id, sourceId);
      await _load(epoch);
    } catch (_) {
      try {
        await _load(epoch);
      } catch (_) {
        if (_current(epoch)) needsReconcile = true;
      }
      rethrow;
    } finally {
      if (_current(epoch)) removingUpload = false;
    }
  });
  Future<void> select(String sourceId, bool selected) =>
      _command((epoch) async {
        if (repository.isStale) throw NotebookFailure.network;
        final current = notebook;
        if (current?.id == null || pending != null || needsReconcile) return;
        final ids = {
          for (final source in current!.sources)
            if (source.selected) source.id,
        };
        selected ? ids.add(sourceId) : ids.remove(sourceId);
        // Clear answers before a changed selection can become visible.
        _clearPassage();
        history = const [];
        selectionSaving = true;
        notebook = StudyNotebook(
          current.id,
          current.configured,
          current.sources.map(
            (source) => source.id == sourceId
                ? StudySource(
                    source.id,
                    source.title,
                    source.status,
                    selected,
                    failureCode: source.failureCode,
                    privateUpload: source.privateUpload,
                  )
                : source,
          ),
          allowedFormats: current.allowedFormats,
        );
        notifyListeners();
        try {
          await repository.select(current.id!, ids.toList());
          await _load(epoch);
        } catch (_) {
          try {
            await _load(epoch);
          } catch (_) {
            if (_current(epoch)) needsReconcile = true;
          }
          rethrow;
        } finally {
          if (_current(epoch)) selectionSaving = false;
        }
      });
  Future<void> ask(String question) => _command((epoch) async {
    if (repository.isStale) throw NotebookFailure.network;
    final text = question.trim();
    if (text.isEmpty ||
        text.length > 4000 ||
        pending != null ||
        needsReconcile ||
        notebook?.id == null ||
        readyCount == 0) {
      return;
    }
    if (_retryQuestion != text) {
      _retryQuestion = text;
      final random = Random.secure();
      _requestKey = List.generate(
        24,
        (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
      ).join();
    }
    submittedQuestion = text;
    sending = true;
    questionFailed = false;
    notifyListeners();
    final StudyJob job;
    try {
      job = await repository.ask(notebook!.id!, text, _requestKey!);
    } catch (_) {
      if (_current(epoch)) questionFailed = true;
      rethrow;
    } finally {
      if (_current(epoch)) sending = false;
    }
    if (!_current(epoch)) return;
    importing = false;
    submittedQuestion = text;
    questionFailed = false;
    pending = job;
    _schedule();
  });
  void _schedule() {
    _timer?.cancel();
    if (_foreground && !repository.isStale) {
      _timer = Timer(pollInterval, poll);
    }
  }

  Future<void> poll() => _command((epoch) async {
    final active = pending, id = notebook?.id;
    if (id == null) return;
    if (active == null) {
      await _load(epoch);
      if (_current(epoch) && preparing) _schedule();
      return;
    }
    try {
      final job = await repository.job(id, active.id);
      if (!_current(epoch)) return;
      if (job.status == 'complete') {
        await _load(epoch);
        if (!_current(epoch)) return;
        pending = null;
        submittedQuestion = null;
        questionFailed = false;
        importing = false;
        _retryQuestion = null;
        _requestKey = null;
        if (preparing) _schedule();
      } else {
        pending = job;
        _schedule();
      }
    } catch (failure) {
      if (_current(epoch) && failure != NotebookFailure.network) {
        pending = null;
        questionFailed = true;
        _retryQuestion = null;
        _requestKey = null;
      }
      rethrow;
    }
  });
  @override
  void dispose() {
    _disposed = true;
    _epoch++;
    _timer?.cancel();
    repository.removeListener(_accountChanged);
    super.dispose();
  }
}
