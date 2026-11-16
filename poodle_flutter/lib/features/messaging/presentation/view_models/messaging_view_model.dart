import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/messaging_repository.dart';

class MessagingViewModel extends ChangeNotifier {
  MessagingViewModel(this._repository, this._auth);

  final MessagingRepository _repository;
  final AuthRepository _auth;
  final conversations = <PoodleConversation>[];
  final peers = <PoodlePeer>[];
  bool loading = false;
  bool acting = false;
  bool _disposed = false;
  Object? actionError;
  Object? error;

  String? get accountId => _auth.session?.userId;

  Future<void> load() async {
    if (_disposed || loading) return;
    loading = true;
    actionError = null;
    error = null;
    notifyListeners();
    try {
      final result = await _repository.listConversations();
      if (!_disposed) {
        conversations
          ..clear()
          ..addAll(result);
      }
    } catch (value) {
      if (!_disposed) error = value;
    } finally {
      loading = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<bool> searchPeers(String query) async =>
      await _action(() async {
        final result = await _repository.eligiblePeers(query);
        if (_disposed) return false;
        peers
          ..clear()
          ..addAll(result);
        return true;
      }) ??
      false;

  Future<PoodleConversation?> openSelf() => _action(_repository.openSelf);
  Future<PoodleConversation?> openPeer(String peerId) =>
      _action(() => _repository.openPeer(peerId));

  Future<T?> _action<T>(Future<T> Function() operation) async {
    if (acting || _disposed) return null;
    acting = true;
    actionError = null;
    notifyListeners();
    try {
      final result = await operation();
      return _disposed ? null : result;
    } catch (value) {
      if (!_disposed) actionError = value;
      return null;
    } finally {
      acting = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class ConversationViewModel extends ChangeNotifier {
  ConversationViewModel(this._repository, this.conversation, this._auth);

  final MessagingRepository _repository;
  final PoodleConversation conversation;
  final AuthRepository _auth;
  final messages = <PoodleMessage>[];
  bool loading = false;
  bool sending = false;
  Object? error;

  String? get accountId => _auth.session?.userId;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      messages
        ..clear()
        ..addAll(await _repository.listMessages(conversation.id));
      final newest = messages.lastOrNull;
      if (newest != null) {
        await _repository.markRead(conversation.id, newest.id);
      }
    } catch (value) {
      error = value;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> send(String text) async {
    if (sending || !conversation.canSend || text.trim().isEmpty) return false;
    sending = true;
    error = null;
    notifyListeners();
    try {
      final result = await _repository.send(
        conversation.id,
        const Uuid().v4(),
        text,
      );
      if (!messages.any((message) => message.id == result.id)) {
        messages.add(result);
      }
      return true;
    } catch (value) {
      error = value;
      return false;
    } finally {
      sending = false;
      notifyListeners();
    }
  }
}
