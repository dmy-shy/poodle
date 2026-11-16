import 'dart:async';
import 'package:flutter/foundation.dart';

enum SyncArea { courses, calendar, notebook, notifications, downloads }

enum SyncState { never, refreshing, current, cached, failed }

@immutable
class SyncStatus {
  const SyncStatus(this.state, this.refreshedAt);
  final SyncState state;
  final DateTime? refreshedAt;
}

/// Coordinates independent account-scoped read refreshes.
class SyncCoordinator extends ChangeNotifier {
  SyncCoordinator(this._readers);
  final Map<SyncArea, Future<bool> Function()> _readers;
  final Map<SyncArea, SyncStatus> _statuses = {};
  String? _account;
  int _generation = 0;
  Future<void>? _active;

  SyncStatus status(SyncArea area) =>
      _statuses[area] ?? const SyncStatus(SyncState.never, null);

  void bindAccount(String? account) {
    if (_account == account) return;
    _account = account;
    _generation++;
    _active = null;
    _statuses.clear();
    notifyListeners();
  }

  Future<void> refresh({SyncArea? only}) {
    if (_account == null) return Future.value();
    if (_active case final pending?) return pending;
    final epoch = _generation;
    final selected = only == null ? _readers.keys.toList() : [only];
    final pending = _run(selected, epoch);
    _active = pending;
    pending.whenComplete(() {
      if (identical(_active, pending)) _active = null;
    });
    return pending;
  }

  Future<void> _run(List<SyncArea> selected, int epoch) async {
    for (final area in selected) {
      if (!_readers.containsKey(area)) continue;
      _statuses[area] = SyncStatus(
        SyncState.refreshing,
        status(area).refreshedAt,
      );
    }
    notifyListeners();
    await Future.wait(
      selected.where(_readers.containsKey).map((area) async {
        try {
          final fresh = await _readers[area]!();
          if (epoch != _generation) return;
          _statuses[area] = SyncStatus(
            fresh ? SyncState.current : SyncState.cached,
            fresh ? DateTime.now().toUtc() : status(area).refreshedAt,
          );
        } catch (_) {
          if (epoch != _generation) return;
          _statuses[area] = SyncStatus(
            SyncState.failed,
            status(area).refreshedAt,
          );
        }
        if (epoch == _generation) notifyListeners();
      }),
    );
  }

  @override
  void dispose() {
    _generation++;
    super.dispose();
  }
}
