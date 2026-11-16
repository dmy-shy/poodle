import 'package:poodle_client/poodle_client.dart' as api;

import '../services/serverpod_auth_gateway.dart';
import 'auth_repository.dart';

class PoodleConversation {
  const PoodleConversation({
    required this.id,
    required this.peerId,
    required this.peerEmail,
    required this.isSelf,
    required this.canSend,
    required this.unreadCount,
    this.lastText,
    this.lastMessageAt,
  });

  final String id;
  final String peerId;
  final String peerEmail;
  final bool isSelf;
  final bool canSend;
  final int unreadCount;
  final String? lastText;
  final DateTime? lastMessageAt;
}

class PoodleMessage {
  const PoodleMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  final int id;
  final String senderId;
  final String text;
  final DateTime createdAt;
}

class PoodlePeer {
  const PoodlePeer({required this.id, required this.email});
  final String id;
  final String email;
}

abstract class MessagingRepository {
  Future<List<PoodleConversation>> listConversations();
  Future<List<PoodlePeer>> eligiblePeers(String query);
  Future<PoodleConversation> openSelf();
  Future<PoodleConversation> openPeer(String peerId);
  Future<List<PoodleMessage>> listMessages(
    String conversationId, {
    int? beforeId,
  });
  Future<PoodleMessage> send(
    String conversationId,
    String clientSendId,
    String text,
  );
  Future<void> markRead(String conversationId, int throughMessageId);
}

class ServerpodMessagingRepository implements MessagingRepository {
  ServerpodMessagingRepository(this._gateway);
  final ServerpodAuthGateway _gateway;

  api.UuidValue _id(String value) => api.UuidValue.withValidation(value);

  Future<T> _call<T>(Future<T> Function(api.Client) operation) async {
    try {
      return await _gateway.withClient(operation);
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw AuthFailure.unavailable;
    }
  }

  PoodleConversation _conversation(api.ConversationItem value) =>
      PoodleConversation(
        id: value.id.toString(),
        peerId: value.peerId.toString(),
        peerEmail: value.peerEmail,
        isSelf: value.isSelf,
        canSend: value.canSend,
        unreadCount: value.unreadCount,
        lastText: value.lastText,
        lastMessageAt: value.lastMessageAt,
      );

  PoodleMessage _message(api.MessageItem value) => PoodleMessage(
    id: value.id,
    senderId: value.senderId.toString(),
    text: value.text,
    createdAt: value.createdAt,
  );

  @override
  Future<List<PoodleConversation>> listConversations() => _call(
    (client) async => (await client.messaging.listConversations())
        .map(_conversation)
        .toList(growable: false),
  );

  @override
  Future<List<PoodlePeer>> eligiblePeers(String query) => _call(
    (client) async => (await client.messaging.eligiblePeers(query))
        .map(
          (peer) => PoodlePeer(id: peer.userId.toString(), email: peer.email),
        )
        .toList(growable: false),
  );

  @override
  Future<PoodleConversation> openSelf() =>
      _call((client) async => _conversation(await client.messaging.openSelf()));

  @override
  Future<PoodleConversation> openPeer(String peerId) => _call(
    (client) async =>
        _conversation(await client.messaging.openPeer(_id(peerId))),
  );

  @override
  Future<List<PoodleMessage>> listMessages(
    String conversationId, {
    int? beforeId,
  }) => _call(
    (client) async => (await client.messaging.listMessages(
      _id(conversationId),
      beforeId,
      50,
    )).map(_message).toList(growable: false),
  );

  @override
  Future<PoodleMessage> send(
    String conversationId,
    String clientSendId,
    String text,
  ) => _call(
    (client) async => _message(
      await client.messaging.send(
        _id(conversationId),
        _id(clientSendId),
        text,
      ),
    ),
  );

  @override
  Future<void> markRead(String conversationId, int throughMessageId) => _call(
    (client) =>
        client.messaging.markRead(_id(conversationId), throughMessageId),
  );
}
