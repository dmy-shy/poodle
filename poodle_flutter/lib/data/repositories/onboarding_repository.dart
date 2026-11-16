import 'package:flutter/foundation.dart';
import '../services/onboarding_store.dart';

class OnboardingRepository extends ChangeNotifier {
  OnboardingRepository(this._store);
  final OnboardingStore _store;
  Future<void>? _loading;
  Future<void>? _saving;
  bool _ready = false;
  bool _completed = false;
  bool _disposed = false;
  bool get ready => _ready;
  bool get completed => _completed;

  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    try {
      _completed = await _store.readCompleted() || _completed;
    } catch (_) {
      // A broken preference must never block access to the app.
    }
    _ready = true;
    if (!_disposed) notifyListeners();
  }

  Future<void> complete() {
    if (_saving != null) return _saving!;
    _completed = true;
    if (!_disposed) notifyListeners();
    return _saving = _save();
  }

  Future<void> _save() async {
    try {
      await _store.writeCompleted();
    } catch (_) {
      // Keep this process completed; a later launch can offer the tour again.
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
