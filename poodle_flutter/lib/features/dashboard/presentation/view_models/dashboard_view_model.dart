import 'package:flutter/foundation.dart';

import '../../../../data/repositories/dashboard_repository.dart';

@immutable
class DashboardState {
  const DashboardState({
    this.snapshot,
    this.busy = false,
    this.refreshing = false,
    this.loadError = false,
    this.refreshError = false,
    this.offlineError = false,
  });

  final DashboardSnapshot? snapshot;
  final bool busy;
  final bool refreshing;
  final bool loadError;
  final bool refreshError;
  final bool offlineError;
}

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel(this._repository);
  final DashboardRepository _repository;
  DashboardState _state = const DashboardState();
  DashboardState get state => _state;
  Future<void>? _inFlight;
  bool _disposed = false;

  void _emit(DashboardState state) {
    if (_disposed) return;
    _state = state;
    notifyListeners();
  }

  Future<void> load() => _inFlight ??= _run(refresh: false);
  Future<void> refresh() =>
      _inFlight ??= _run(refresh: _state.snapshot != null);

  Future<void> _run({required bool refresh}) async {
    _emit(
      DashboardState(
        snapshot: _state.snapshot,
        busy: true,
        refreshing: refresh,
      ),
    );
    try {
      final snapshot = refresh
          ? await _repository.refresh()
          : await _repository.load();
      _emit(DashboardState(snapshot: snapshot));
    } on DashboardOfflineException {
      _emit(
        DashboardState(
          snapshot: _state.snapshot,
          refreshError: refresh,
          loadError: !refresh,
          offlineError: true,
        ),
      );
    } catch (_) {
      _emit(
        DashboardState(
          snapshot: _state.snapshot,
          refreshError: refresh,
          loadError: !refresh,
        ),
      );
    } finally {
      _inFlight = null;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
