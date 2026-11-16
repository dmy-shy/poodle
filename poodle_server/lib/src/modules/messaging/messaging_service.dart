import '../../core/course_tenancy.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';

class MessagingService {
  Future<ConversationItem> openSelf(Session session) async {
    final account = await AccountAuthorization.requireAccount(session);
    return session.db.transaction((tx) async {
      var conversation = await ConversationRecord.db.findFirstRow(
        session,
        where: (t) =>
            t.firstParticipantId.equals(account.authUserId) &
            t.secondParticipantId.equals(account.authUserId),
        transaction: tx,
      );
      conversation ??= await ConversationRecord.db.insertRow(
        session,
        ConversationRecord(
          firstParticipantId: account.authUserId,
          secondParticipantId: account.authUserId,
        ),
        transaction: tx,
      );
      await _cursor(session, tx, conversation.id!, account.authUserId);
      return ConversationItem(
        id: conversation.id!,
        peerId: account.authUserId,
        peerEmail: account.email,
        isSelf: true,
        canSend: true,
        unreadCount: 0,
      );
    });
  }

  Future<ConversationItem> openPeer(Session session, UuidValue peerId) async {
    final account = await AccountAuthorization.requireAccount(session);
    if (peerId == account.authUserId) return openSelf(session);
    if (!await _shareActiveCourse(session, account.authUserId, peerId)) {
      throw StateError('Peer is not eligible for private messaging.');
    }
    final pair = [account.authUserId, peerId]
      ..sort(
        (a, b) => a.toString().compareTo(b.toString()),
      );
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
      await _cursor(session, tx, conversation.id!, account.authUserId);
      await _cursor(session, tx, conversation.id!, peerId);
      return ConversationItem(
        id: conversation.id!,
        peerId: peerId,
        peerEmail: await _email(session, peerId),
        isSelf: false,
        canSend: true,
        unreadCount: 0,
      );
    });
  }

  Future<bool> _shareActiveCourse(
    Session session,
    UuidValue first,
    UuidValue second,
  ) async {
    final firstMemberships = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) => t.authUserId.equals(first) & t.active.equals(true),
      ),
    );
    if (firstMemberships.isEmpty) return false;
    final courseIds = firstMemberships.map((row) => row.courseId).toSet();
    final secondMemberships = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) => t.authUserId.equals(second) & t.active.equals(true),
      ),
    );
    return secondMemberships.any((row) => courseIds.contains(row.courseId));
  }

  Future<String> _email(Session session, UuidValue userId) async {
    final access = await AccountAccess.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    if (access?.verifiedEmail case final email?) return email;
    final email = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    return email?.email ?? userId.toString();
  }

  Future<ReadCursorRecord> _cursor(
    Session session,
    Transaction tx,
    UuidValue conversationId,
    UuidValue participantId,
  ) async {
    final existing = await ReadCursorRecord.db.findFirstRow(
      session,
      where: (t) =>
          t.conversationId.equals(conversationId) &
          t.participantId.equals(participantId),
      transaction: tx,
    );
    if (existing != null) return existing;
    return ReadCursorRecord.db.insertRow(
      session,
      ReadCursorRecord(
        conversationId: conversationId,
        participantId: participantId,
      ),
      transaction: tx,
    );
  }
}
