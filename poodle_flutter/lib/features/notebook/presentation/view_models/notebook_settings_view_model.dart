import 'package:flutter/foundation.dart';
import '../../../../data/repositories/notebook_repository.dart';

class NotebookSettingsViewModel extends ChangeNotifier {
  NotebookSettingsViewModel(this.repository, this.courseId, this.assessmentId) {
    repository.addListener(_accountChanged);
  }
  final NotebookRepository repository;
  final String courseId, assessmentId;
  StudyNotebookSetup? setup;
  Set<String> _materials = {}, _formats = {};
  Set<String> get materials => Set.unmodifiable(_materials);
  Set<String> get formats => Set.unmodifiable(_formats);
  bool busy = false, saved = false, needsReload = false;
  NotebookFailure? error;
  bool _disposed = false;
  int _epoch = 0;
  bool get dirty =>
      setup != null &&
      (!setEquals(_materials, setup!.materialIds.toSet()) ||
          !setEquals(_formats, setup!.formats.toSet()));
  bool get canSave =>
      dirty &&
      !busy &&
      !needsReload &&
      setup != null &&
      _materials.isNotEmpty &&
      _materials.every((id) => setup!.materials.any((m) => m.id == id));

  void _accountChanged() {
    _epoch++;
    setup = null;
    _materials = {};
    _formats = {};
    busy = saved = needsReload = false;
    error = NotebookFailure.cancelled;
    if (!_disposed) notifyListeners();
  }

  bool _current(int epoch) => !_disposed && epoch == _epoch;
  void material(String id, bool selected) {
    if (busy || needsReload || setup == null) return;
    if (selected && !setup!.materials.any((m) => m.id == id)) return;
    selected ? _materials.add(id) : _materials.remove(id);
    saved = false;
    notifyListeners();
  }

  void format(String format, bool selected) {
    if (busy ||
        needsReload ||
        setup == null ||
        !{'pdf', 'docx', 'txt', 'md'}.contains(format)) {
      return;
    }
    selected ? _formats.add(format) : _formats.remove(format);
    saved = false;
    notifyListeners();
  }

  void _apply(StudyNotebookSetup value) {
    setup = value;
    _materials = value.materialIds.toSet();
    _formats = value.formats.toSet();
    needsReload = false;
  }

  Future<void> load() async {
    if (_disposed || busy) return;
    final epoch = _epoch;
    busy = true;
    saved = false;
    error = null;
    notifyListeners();
    try {
      final value = await repository.assessmentSetup(courseId, assessmentId);
      if (_current(epoch)) _apply(value);
    } catch (failure) {
      if (_current(epoch)) {
        setup = null;
        _materials = {};
        _formats = {};
        error = failure is NotebookFailure
            ? failure
            : NotebookFailure.unavailable;
      }
    } finally {
      if (_current(epoch)) {
        busy = false;
        notifyListeners();
      }
    }
  }

  Future<void> save() async {
    if (_disposed || !canSave) return;
    final epoch = _epoch;
    final revision = setup!.revision;
    busy = true;
    error = null;
    saved = false;
    notifyListeners();
    try {
      await repository.configure(
        courseId,
        assessmentId,
        revision,
        _materials.toList(),
        _formats.toList(),
      );
      if (!_current(epoch)) return;
      final value = await repository.assessmentSetup(courseId, assessmentId);
      if (_current(epoch)) {
        _apply(value);
        saved = true;
      }
    } catch (failure) {
      if (_current(epoch)) {
        // A timed-out save may have committed; reread its revision before retrying.
        needsReload = true;
        error = failure is NotebookFailure
            ? failure
            : NotebookFailure.unavailable;
      }
    } finally {
      if (_current(epoch)) {
        busy = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _epoch++;
    repository.removeListener(_accountChanged);
    super.dispose();
  }
}
