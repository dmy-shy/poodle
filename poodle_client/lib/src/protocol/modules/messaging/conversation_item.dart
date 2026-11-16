/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// The authenticated participant's inbox representation, returned by messaging endpoints.
abstract class ConversationItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ConversationItem._({
    required this.id,
    required this.peerId,
    required this.peerEmail,
    required this.isSelf,
    required this.canSend,
    required this.unreadCount,
    this.lastText,
    this.lastMessageAt,
  });

  factory ConversationItem({
    required _isc.UuidValue id,
    required _isc.UuidValue peerId,
    required String peerEmail,
    required bool isSelf,
    required bool canSend,
    required int unreadCount,
    String? lastText,
    DateTime? lastMessageAt,
  }) = _ConversationItemImpl;

  factory ConversationItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConversationItem(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      peerId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['peerId']),
      peerEmail: jsonSerialization['peerEmail'] as String,
      isSelf: _isc.BoolJsonExtension.fromJson(jsonSerialization['isSelf']),
      canSend: _isc.BoolJsonExtension.fromJson(jsonSerialization['canSend']),
      unreadCount: jsonSerialization['unreadCount'] as int,
      lastText: jsonSerialization['lastText'] as String?,
      lastMessageAt: jsonSerialization['lastMessageAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastMessageAt'],
            ),
    );
  }

  _isc.UuidValue id;

  _isc.UuidValue peerId;

  String peerEmail;

  bool isSelf;

  bool canSend;

  int unreadCount;

  String? lastText;

  DateTime? lastMessageAt;

  /// Returns a shallow copy of this [ConversationItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ConversationItem copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? peerId,
    String? peerEmail,
    bool? isSelf,
    bool? canSend,
    int? unreadCount,
    String? lastText,
    DateTime? lastMessageAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConversationItem',
      'id': id.toJson(),
      'peerId': peerId.toJson(),
      'peerEmail': peerEmail,
      'isSelf': isSelf,
      'canSend': canSend,
      'unreadCount': unreadCount,
      if (lastText != null) 'lastText': lastText,
      if (lastMessageAt != null) 'lastMessageAt': lastMessageAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ConversationItem',
      'id': id.toJson(),
      'peerId': peerId.toJson(),
      'peerEmail': peerEmail,
      'isSelf': isSelf,
      'canSend': canSend,
      'unreadCount': unreadCount,
      if (lastText != null) 'lastText': lastText,
      if (lastMessageAt != null) 'lastMessageAt': lastMessageAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConversationItemImpl extends ConversationItem {
  _ConversationItemImpl({
    required _isc.UuidValue id,
    required _isc.UuidValue peerId,
    required String peerEmail,
    required bool isSelf,
    required bool canSend,
    required int unreadCount,
    String? lastText,
    DateTime? lastMessageAt,
  }) : super._(
         id: id,
         peerId: peerId,
         peerEmail: peerEmail,
         isSelf: isSelf,
         canSend: canSend,
         unreadCount: unreadCount,
         lastText: lastText,
         lastMessageAt: lastMessageAt,
       );

  /// Returns a shallow copy of this [ConversationItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ConversationItem copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? peerId,
    String? peerEmail,
    bool? isSelf,
    bool? canSend,
    int? unreadCount,
    Object? lastText = _Undefined,
    Object? lastMessageAt = _Undefined,
  }) {
    return ConversationItem(
      id: id ?? this.id,
      peerId: peerId ?? this.peerId,
      peerEmail: peerEmail ?? this.peerEmail,
      isSelf: isSelf ?? this.isSelf,
      canSend: canSend ?? this.canSend,
      unreadCount: unreadCount ?? this.unreadCount,
      lastText: lastText is String? ? lastText : this.lastText,
      lastMessageAt: lastMessageAt is DateTime?
          ? lastMessageAt
          : this.lastMessageAt,
    );
  }
}
