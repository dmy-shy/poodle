import 'dart:async';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Stores SDK credential envelopes. A retired manager cannot persist late refreshes.
class SessionCredentialStore {
  SessionCredentialStore(this._durable);
  final ClientAuthSuccessStorage _durable;
  Future<void> _tail = Future<void>.value();
  int _generation = 0;
  bool _remember = true;
  bool _loaded = false;
  AuthSuccess? _memory;

  Future<T> _serialize<T>(Future<T> Function() action) {
    final result = _tail.then((_) => action());
    _tail = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  ClientAuthSuccessStorage lease() => _CredentialLease(this, _generation);

  Future<ClientAuthSuccessStorage> beginSession({required bool rememberMe}) {
    final generation = ++_generation;
    _memory = null;
    _loaded = true;
    _remember = false;
    return _serialize(() async {
      // Deletion failure must prevent login from claiming a memory-only session.
      await _durable.set(null);
      if (generation != _generation) return _CredentialLease(this, generation);
      _remember = rememberMe;
      _memory = null;
      _loaded = true;
      return _CredentialLease(this, generation);
    });
  }

  Future<void> clear() {
    ++_generation;
    // Invalidate in memory immediately, even when secure deletion fails.
    _memory = null;
    _loaded = true;
    _remember = false;
    return _serialize(() async {
      await _durable.set(null);
      _memory = null;
      _loaded = true;
      _remember = false;
    });
  }

  /// Retire this process' managers without deleting a remembered session.
  void retire() {
    ++_generation;
  }

  Future<void> _reload(int generation) => _serialize(() async {
    if (generation != _generation || !_remember) return;
    final durable = _durable;
    if (durable is CachedClientAuthSuccessStorage) await durable.clearCache();
    if (generation == _generation) {
      _memory = null;
      _loaded = false;
    }
  });

  Future<AuthSuccess?> _read(int generation) => _serialize(() async {
    if (generation != _generation) return null;
    if (!_loaded) {
      final value = await _durable.get();
      if (generation != _generation) return null;
      _memory = value;
      _loaded = true;
    }
    return _memory;
  });

  Future<void> _write(int generation, AuthSuccess? value) =>
      _serialize(() async {
        if (generation != _generation) return;
        if (_remember) await _durable.set(value);
        if (generation != _generation) return;
        _memory = value;
        _loaded = true;
      });
}

class _CredentialLease extends CachedClientAuthSuccessStorage {
  _CredentialLease(this.store, this.generation)
    : super(delegate: _LeaseDelegate(store, generation));
  final SessionCredentialStore store;
  final int generation;
  @override
  Future<void> clearCache() async {
    await store._reload(generation);
    await super.clearCache();
  }
}

class _LeaseDelegate implements ClientAuthSuccessStorage {
  const _LeaseDelegate(this.store, this.generation);
  final SessionCredentialStore store;
  final int generation;
  @override
  Future<AuthSuccess?> get() => store._read(generation);
  @override
  Future<void> set(AuthSuccess? data) => store._write(generation, data);
}
