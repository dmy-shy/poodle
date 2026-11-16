import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:poodle_client/poodle_client.dart' as api;

import 'auth_repository.dart';
import 'account_notebook_cache.dart';
import '../services/serverpod_auth_gateway.dart';

class PoodleNotification {
  const PoodleNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.createdAt,
    required this.readAt,
    this.courseId,
    this.activityId,
    this.requestId,
  });

  final String id;
  final String category;
  final String title;
  final DateTime createdAt;
  final DateTime? readAt;
  final String? courseId;
  final String? activityId;
  final String? requestId;
  bool get unread => readAt == null;
}

abstract class NotificationsRepository {
  void bindAccount(String? account) {}
  bool get isStale => false;
  DateTime? get lastRefreshedAt => null;
  Future<List<PoodleNotification>> list({
    required int offset,
    required int limit,
    String? category,
    bool unreadOnly = false,
  });
  Future<int> unreadCount();
  Future<void> markRead(String id);
  Future<void> markAllRead();
}

class ServerpodNotificationsRepository implements NotificationsRepository {
  ServerpodNotificationsRepository(
    this._gateway, {
    AccountNotebookCache? cache,
  }) {
    _cache =
        cache ??
        AccountNotebookCache(
          namespace: '${_gateway.serverIdentity}:notifications',
        );
  }
  final ServerpodAuthGateway _gateway;
  late final AccountNotebookCache _cache;
  String? _account;
  int _generation = 0;
  Future<void> _cacheTail = Future.value();
  final Set<String> _staleKeys = {};
  DateTime? _refreshedAt;
  @override
  bool get isStale => _staleKeys.isNotEmpty;
  @override
  DateTime? get lastRefreshedAt => _refreshedAt;
  @override
  void bindAccount(String? value) {
    if (_account == value) return;
    final old = _account;
    _account = value;
    _generation++;
    _staleKeys.clear();
    _refreshedAt = null;
    if (old != null && !kIsWeb) {
      _cacheTail = _cacheTail.catchError((_) {}).then((_) => _cache.purge(old));
      unawaited(_cacheTail.catchError((_) {}));
    }
  }

  Future<T> _cached<T>(
    String key,
    Future<T> Function() fetch,
    Map<String, dynamic> Function(T) encode,
    T Function(Map<String, dynamic>) decode,
  ) async {
    final owner = _account;
    final epoch = _generation;
    if (owner == null) throw AuthFailure.cancelled;
    try {
      final value = await fetch();
      if (epoch != _generation) throw AuthFailure.cancelled;
      final now = DateTime.now().toUtc();
      if (!kIsWeb) {
        try {
          final write = _cacheTail.catchError((_) {}).then((_) async {
            if (epoch == _generation) {
              await _cache.write(owner, key, encode(value), now);
            }
          });
          _cacheTail = write.catchError((_) {});
          await write;
        } catch (_) {}
      }
      if (epoch != _generation) throw AuthFailure.cancelled;
      _staleKeys.remove(key);
      _refreshedAt = now;
      return value;
    } on AuthFailure catch (error) {
      if (error != AuthFailure.network || epoch != _generation || kIsWeb) {
        rethrow;
      }
      await _cacheTail.catchError((_) {});
      if (epoch != _generation) throw AuthFailure.cancelled;
      final saved = await _cache.read(owner, key);
      if (saved == null) rethrow;
      _staleKeys.add(key);
      _refreshedAt = saved.refreshedAt;
      return decode(saved.value);
    }
  }

  Future<T> _call<T>(Future<T> Function(api.Client) operation) async {
    try {
      return await _gateway.withClient(operation);
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthFailure.unavailable;
    }
  }

  @override
  Future<List<PoodleNotification>> list({
    required int offset,
    required int limit,
    String? category,
    bool unreadOnly = false,
  }) => _cached(
    'list:$offset:$limit:${category ?? ''}:$unreadOnly',
    () => _call(
      (client) async =>
          (await client.notifications.list(
                offset,
                limit,
                category,
                unreadOnly,
              ))
              .map(
                (item) => PoodleNotification(
                  id: item.id.toString(),
                  category: item.category,
                  title: item.title,
                  createdAt: item.createdAt,
                  readAt: item.readAt,
                  courseId: item.courseId?.toString(),
                  activityId: item.activityId?.toString(),
                  requestId: item.requestId?.toString(),
                ),
              )
              .toList(growable: false),
    ),
    (items) => {
      'items': [
        for (final item in items)
          {
            'id': item.id,
            'category': item.category,
            'title': item.title,
            'createdAt': item.createdAt.toIso8601String(),
            'readAt': item.readAt?.toIso8601String(),
            'courseId': item.courseId,
            'activityId': item.activityId,
            'requestId': item.requestId,
          },
      ],
    },
    (value) => List<PoodleNotification>.unmodifiable([
      for (final row in value['items'] as List<dynamic>)
        PoodleNotification(
          id: row['id'] as String,
          category: row['category'] as String,
          title: row['title'] as String,
          createdAt: DateTime.parse(row['createdAt'] as String),
          readAt: DateTime.tryParse(row['readAt'] as String? ?? ''),
          courseId: row['courseId'] as String?,
          activityId: row['activityId'] as String?,
          requestId: row['requestId'] as String?,
        ),
    ]),
  );

  @override
  Future<int> unreadCount() => _cached(
    'unread-count',
    () => _call((client) => client.notifications.unreadCount()),
    (count) => {'count': count},
    (value) => value['count'] as int,
  );

  @override
  Future<void> markRead(String id) async {
    if (isStale) throw AuthFailure.network;
    await _call(
      (client) =>
          client.notifications.markRead(api.UuidValue.withValidation(id)),
    );
    await _invalidate();
  }

  @override
  Future<void> markAllRead() async {
    if (isStale) throw AuthFailure.network;
    await _call((client) => client.notifications.markAllRead());
    await _invalidate();
  }

  Future<void> _invalidate() async {
    final owner = _account;
    final epoch = _generation;
    if (owner == null || kIsWeb) return;
    final purge = _cacheTail.catchError((_) {}).then((_) async {
      if (epoch == _generation) await _cache.purge(owner);
    });
    _cacheTail = purge.catchError((_) {});
    await purge;
  }
}
