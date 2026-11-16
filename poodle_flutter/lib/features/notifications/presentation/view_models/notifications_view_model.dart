import 'package:flutter/foundation.dart';

import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/notifications_repository.dart';

class NotificationsViewModel extends ChangeNotifier {
  NotificationsViewModel(this._repository, this._auth) {
    _accountId = _auth.session?.userId;
    _repository.bindAccount(_accountId);
    _auth.addListener(_accountChanged);
  }

  final NotificationsRepository _repository;
  final AuthRepository _auth;
  static const pageSize = 20;
  String? _accountId;
  int _generation = 0;
  final List<PoodleNotification> items = [];
  String? category;
  bool unreadOnly = false;
  int unreadCount = 0;
  bool loading = false;
  bool loadingMore = false;
  bool hasMore = true;
  Object? error;
  bool get isStale => _repository.isStale;
  DateTime? get lastRefreshedAt => _repository.lastRefreshedAt;

  void _accountChanged() {
    final next = _auth.session?.userId;
    if (next == _accountId) return;
    _accountId = next;
    _repository.bindAccount(next);
    _generation++;
    items.clear();
    unreadCount = 0;
    hasMore = true;
    loading = false;
    loadingMore = false;
    error = null;
    notifyListeners();
    if (next != null) refresh();
  }

  Future<void> filter(String? nextCategory, {bool? onlyUnread}) async {
    category = nextCategory;
    if (onlyUnread != null) unreadOnly = onlyUnread;
    notifyListeners();
    await refresh();
  }

  Future<void> refresh() async {
    final generation = ++_generation;
    items.clear();
    hasMore = true;
    loading = true;
    error = null;
    notifyListeners();
    if (_accountId == null) {
      loading = false;
      notifyListeners();
      return;
    }
    try {
      final values = await _repository.list(
        offset: 0,
        limit: pageSize,
        category: category,
        unreadOnly: unreadOnly,
      );
      final count = await _repository.unreadCount();
      if (generation != _generation) return;
      items.addAll(values);
      unreadCount = count;
      hasMore = values.length == pageSize;
    } catch (failure) {
      if (generation == _generation) error = failure;
    } finally {
      if (generation == _generation) {
        loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadMore() async {
    if (loading || loadingMore || !hasMore || _accountId == null) return;
    final generation = _generation;
    loadingMore = true;
    notifyListeners();
    try {
      final values = await _repository.list(
        offset: items.length,
        limit: pageSize,
        category: category,
        unreadOnly: unreadOnly,
      );
      if (generation != _generation) return;
      items.addAll(values);
      hasMore = values.length == pageSize;
      error = null;
    } catch (failure) {
      if (generation == _generation) error = failure;
    } finally {
      if (generation == _generation) {
        loadingMore = false;
        notifyListeners();
      }
    }
  }

  Future<void> markRead(PoodleNotification item) async {
    if (!item.unread || isStale) return;
    final generation = _generation;
    try {
      await _repository.markRead(item.id);
      if (generation == _generation) await refresh();
    } catch (failure) {
      if (generation == _generation) {
        error = failure;
        notifyListeners();
      }
    }
  }

  Future<void> markAllRead() async {
    if (isStale) return;
    final generation = _generation;
    try {
      await _repository.markAllRead();
      if (generation == _generation) await refresh();
    } catch (failure) {
      if (generation == _generation) {
        error = failure;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _generation++;
    _auth.removeListener(_accountChanged);
    super.dispose();
  }
}
