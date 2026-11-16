import 'package:serverpod/serverpod.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';

class NotificationsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<NotificationItem>> list(
    Session session,
    int offset,
    int limit,
    String? category,
    bool unreadOnly,
  ) async {
    final account = await AccountAuthorization.requireAccount(session);
    if (offset < 0 || limit < 1 || limit > 50) {
      throw ArgumentError('Invalid pagination');
    }
    final rows = await NotificationRecord.db.find(
      session,
      where: (t) =>
          t.recipientId.equals(account.authUserId) &
          (category == null
              ? Constant.bool(true)
              : t.category.equals(category)) &
          (unreadOnly ? t.readAt.equals(null) : Constant.bool(true)),
      orderBy: (t) => t.createdAt.desc(),
      limit: limit,
      offset: offset,
    );
    return [for (final row in rows) _item(row)];
  }

  Future<int> unreadCount(Session session) async {
    final account = await AccountAuthorization.requireAccount(session);
    return NotificationRecord.db.count(
      session,
      where: (t) =>
          t.recipientId.equals(account.authUserId) & t.readAt.equals(null),
    );
  }

  Future<NotificationItem?> get(Session session, UuidValue id) async {
    final account = await AccountAuthorization.requireAccount(session);
    final row = await NotificationRecord.db.findById(session, id);
    if (row == null || row.recipientId != account.authUserId) return null;
    return _item(row);
  }

  Future<void> markRead(Session session, UuidValue id) async {
    final account = await AccountAuthorization.requireAccount(session);
    await session.db.transaction((tx) async {
      final row = await NotificationRecord.db.findById(
        session,
        id,
        transaction: tx,
      );
      if (row == null ||
          row.recipientId != account.authUserId ||
          row.readAt != null) {
        return;
      }
      await NotificationRecord.db.updateRow(
        session,
        row.copyWith(readAt: DateTime.now().toUtc()),
        transaction: tx,
      );
    });
  }

  Future<void> markAllRead(Session session) async {
    final account = await AccountAuthorization.requireAccount(session);
    final now = DateTime.now().toUtc();
    final rows = await NotificationRecord.db.find(
      session,
      where: (t) =>
          t.recipientId.equals(account.authUserId) & t.readAt.equals(null),
    );
    await session.db.transaction((tx) async {
      for (final row in rows) {
        if (row.createdAt.isAfter(now)) continue;
        await NotificationRecord.db.updateRow(
          session,
          row.copyWith(readAt: now),
          transaction: tx,
        );
      }
    });
  }

  NotificationItem _item(NotificationRecord row) => NotificationItem(
    id: row.id!,
    category: row.category,
    courseId: row.courseId,
    activityId: row.activityId,
    requestId: row.requestId,
    title: row.title,
    createdAt: row.createdAt,
    readAt: row.readAt,
  );
}
