import '../../core/course_tenancy.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import 'messaging_service.dart';

class MessagingEndpoint extends Endpoint {
  MessagingEndpoint({MessagingService? service})
    : _service = service ?? MessagingService();

  final MessagingService _service;

  @override
  bool get requireLogin => true;

  Future<ConversationItem> openSelf(Session session) =>
      _service.openSelf(session);

  Future<ConversationItem> openPeer(Session session, UuidValue peerId) async {
    final account = await AccountAuthorization.requireAccount(session);
    if (peerId == account.authUserId) return _service.openSelf(session);
    final mine = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) =>
            t.authUserId.equals(account.authUserId) & t.active.equals(true),
      ),
    );
    final courseIds = mine.map((row) => row.courseId).toSet();
    final theirs = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) => t.authUserId.equals(peerId) & t.active.equals(true),
      ),
    );
    if (!theirs.any((row) => courseIds.contains(row.courseId))) {
      throw StateError('Peer is not eligible for private messaging.');
    }
    final pair = [account.authUserId, peerId]
      ..sort((a, b) => a.toString().compareTo(b.toString()));
    return session.db.transaction((tx) async {
      var conversation = await ConversationRecord.db.findFirstRow(
        session,
        where: (t) =>
            t.firstParticipantId.equals(pair[0]) &
            t.secondParticipantId.equals(pair[1]),
        transaction: tx,
      );
      conversation ??= await ConversationRecord.db.insertRow(
        session,
        ConversationRecord(
          firstParticipantId: pair[0],
          secondParticipantId: pair[1],
        ),
        transaction: tx,
      );
      final peerAccess = await AccountAccess.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(peerId),
        transaction: tx,
      );
      final peerEmail =
          peerAccess?.verifiedEmail ??
          (await EmailAccount.db.findFirstRow(
            session,
            where: (t) => t.authUserId.equals(peerId),
            transaction: tx,
          ))?.email ??
          peerId.toString();
      return ConversationItem(
        id: conversation.id!,
        peerId: peerId,
        peerEmail: peerEmail,
        isSelf: false,
        canSend: true,
        unreadCount: 0,
      );
    });
  }

  Future<MessageItem> send(
    Session session,
    UuidValue conversationId,
    UuidValue clientSendId,
    String text,
  ) async {
    final account = await AccountAuthorization.requireAccount(session);
    final normalized = text.trim();
    if (normalized.isEmpty || normalized.runes.length > 4000) {
      throw ArgumentError(
        'Message text must contain at most 4,000 characters.',
      );
    }
    return session.db.transaction((tx) async {
      final conversation = await _conversationForParticipant(
        session,
        tx,
        conversationId,
        account.authUserId,
      );
      final existing = await MessageRecord.db.findFirstRow(
        session,
        where: (t) =>
            t.conversationId.equals(conversationId) &
            t.senderId.equals(account.authUserId) &
            t.clientSendId.equals(clientSendId),
        transaction: tx,
      );
      if (existing != null) return _message(existing);
      if (conversation.firstParticipantId != conversation.secondParticipantId) {
        final peer = conversation.firstParticipantId == account.authUserId
            ? conversation.secondParticipantId
            : conversation.firstParticipantId;
        final mine = await CourseTenancy.filter(
          session,
          await CourseMembership.db.find(
            session,
            where: (t) =>
                t.authUserId.equals(account.authUserId) & t.active.equals(true),
            transaction: tx,
          ),
          transaction: tx,
        );
        final courseIds = mine.map((row) => row.courseId).toSet();
        final theirs = await CourseTenancy.filter(
          session,
          await CourseMembership.db.find(
            session,
            where: (t) => t.authUserId.equals(peer) & t.active.equals(true),
            transaction: tx,
          ),
          transaction: tx,
        );
        if (!theirs.any((row) => courseIds.contains(row.courseId))) {
          throw StateError('Messaging eligibility has ended.');
        }
      }
      final message = await MessageRecord.db.insertRow(
        session,
        MessageRecord(
          conversationId: conversationId,
          senderId: account.authUserId,
          clientSendId: clientSendId,
          text: normalized,
        ),
        transaction: tx,
      );
      await ConversationRecord.db.updateRow(
        session,
        conversation.copyWith(updatedAt: DateTime.now().toUtc()),
        transaction: tx,
      );
      return _message(message);
    });
  }

  Future<List<ConversationItem>> listConversations(Session session) async {
    final account = await AccountAuthorization.requireAccount(session);
    final all = await ConversationRecord.db.find(session);
    final mine = all.where(
      (row) =>
          row.firstParticipantId == account.authUserId ||
          row.secondParticipantId == account.authUserId,
    );
    final items = <ConversationItem>[];
    for (final conversation in mine) {
      final self =
          conversation.firstParticipantId == conversation.secondParticipantId;
      final peerId = self
          ? account.authUserId
          : conversation.firstParticipantId == account.authUserId
          ? conversation.secondParticipantId
          : conversation.firstParticipantId;
      final latest = (await MessageRecord.db.find(
        session,
        where: (t) => t.conversationId.equals(conversation.id!),
        orderBy: (t) => t.id.desc(),
        limit: 1,
      )).firstOrNull;
      final cursor = await ReadCursorRecord.db.findFirstRow(
        session,
        where: (t) =>
            t.conversationId.equals(conversation.id!) &
            t.participantId.equals(account.authUserId),
      );
      final messages = self
          ? const <MessageRecord>[]
          : await MessageRecord.db.find(
              session,
              where: (t) => t.conversationId.equals(conversation.id!),
            );
      final unread = messages
          .where(
            (message) =>
                message.senderId != account.authUserId &&
                message.id! > (cursor?.readThroughId ?? 0),
          )
          .length;
      items.add(
        ConversationItem(
          id: conversation.id!,
          peerId: peerId,
          peerEmail: self ? account.email : await _emailFor(session, peerId),
          isSelf: self,
          canSend:
              self ||
              await _shareActiveCourse(session, account.authUserId, peerId),
          unreadCount: unread,
          lastText: latest?.text,
          lastMessageAt: latest?.createdAt,
        ),
      );
    }
    items.sort((a, b) {
      if (a.isSelf != b.isSelf) return a.isSelf ? -1 : 1;
      return (b.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(
            a.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0),
          );
    });
    return items;
  }

  Future<List<EligiblePeer>> eligiblePeers(
    Session session,
    String query,
  ) async {
    final account = await AccountAuthorization.requireAccount(session);
    final memberships = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) =>
            t.authUserId.equals(account.authUserId) & t.active.equals(true),
      ),
    );
    final courseIds = memberships.map((row) => row.courseId).toSet();
    if (courseIds.isEmpty) return [];
    final candidates = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) => t.active.equals(true) & t.courseId.inSet(courseIds),
      ),
    );
    final ids = candidates
        .where(
          (row) =>
              row.authUserId != account.authUserId &&
              courseIds.contains(row.courseId),
        )
        .map((row) => row.authUserId)
        .toSet();
    final normalized = query.trim().toLowerCase();
    final peers = <EligiblePeer>[];
    for (final id in ids) {
      final email = await _emailFor(session, id);
      if (normalized.isEmpty || email.toLowerCase().contains(normalized)) {
        peers.add(EligiblePeer(userId: id, email: email));
      }
    }
    peers.sort((a, b) => a.email.compareTo(b.email));
    return peers;
  }

  Future<List<MessageItem>> listMessages(
    Session session,
    UuidValue conversationId,
    int? beforeId,
    int limit,
  ) async {
    final account = await AccountAuthorization.requireAccount(session);
    if (limit < 1 || limit > 50 || (beforeId != null && beforeId < 1)) {
      throw ArgumentError('Invalid pagination.');
    }
    await _conversationForParticipant(
      session,
      null,
      conversationId,
      account.authUserId,
    );
    final rows = await MessageRecord.db.find(
      session,
      where: (t) => t.conversationId.equals(conversationId),
      orderBy: (t) => t.id.desc(),
    );
    return [
      for (final row
          in rows
              .where((row) => beforeId == null || row.id! < beforeId)
              .take(limit)
              .toList()
              .reversed)
        _message(row),
    ];
  }

  Future<void> markRead(
    Session session,
    UuidValue conversationId,
    int throughMessageId,
  ) async {
    if (throughMessageId < 1) {
      throw ArgumentError('Invalid message cursor.');
    }
    final account = await AccountAuthorization.requireAccount(session);
    await session.db.transaction((tx) async {
      await _conversationForParticipant(
        session,
        tx,
        conversationId,
        account.authUserId,
      );
      final message = await MessageRecord.db.findFirstRow(
        session,
        where: (t) =>
            t.conversationId.equals(conversationId) &
            t.id.equals(throughMessageId),
        transaction: tx,
      );
      if (message == null) {
        throw StateError('Message is unavailable.');
      }
      final cursor = await ReadCursorRecord.db.findFirstRow(
        session,
        where: (t) =>
            t.conversationId.equals(conversationId) &
            t.participantId.equals(account.authUserId),
        transaction: tx,
      );
      if (cursor == null) {
        await ReadCursorRecord.db.insertRow(
          session,
          ReadCursorRecord(
            conversationId: conversationId,
            participantId: account.authUserId,
            readThroughId: throughMessageId,
          ),
          transaction: tx,
        );
      } else if (throughMessageId > cursor.readThroughId) {
        await ReadCursorRecord.db.updateRow(
          session,
          cursor.copyWith(
            readThroughId: throughMessageId,
            updatedAt: DateTime.now().toUtc(),
          ),
          transaction: tx,
        );
      }
    });
  }

  Future<ConversationRecord> _conversationForParticipant(
    Session session,
    Transaction? tx,
    UuidValue conversationId,
    UuidValue userId,
  ) async {
    final conversation = await ConversationRecord.db.findById(
      session,
      conversationId,
      transaction: tx,
    );
    if (conversation == null ||
        (conversation.firstParticipantId != userId &&
            conversation.secondParticipantId != userId)) {
      throw StateError('Conversation is unavailable.');
    }
    return conversation;
  }

  MessageItem _message(MessageRecord row) => MessageItem(
    id: row.id!,
    senderId: row.senderId,
    text: row.text,
    createdAt: row.createdAt,
  );

  Future<bool> _shareActiveCourse(
    Session session,
    UuidValue first,
    UuidValue second,
  ) async {
    final firstRows = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) => t.authUserId.equals(first) & t.active.equals(true),
      ),
    );
    final courseIds = firstRows.map((row) => row.courseId).toSet();
    if (courseIds.isEmpty) return false;
    final secondRows = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) => t.authUserId.equals(second) & t.active.equals(true),
      ),
    );
    return secondRows.any((row) => courseIds.contains(row.courseId));
  }

  Future<String> _emailFor(Session session, UuidValue id) async {
    final access = await AccountAccess.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(id),
    );
    return access?.verifiedEmail ??
        (await EmailAccount.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(id),
        ))?.email ??
        id.toString();
  }
}
