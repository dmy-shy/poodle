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

/// A persisted private-message row returned to an authorized participant.
abstract class MessageItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MessageItem._({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory MessageItem({
    required int id,
    required _isc.UuidValue senderId,
    required String text,
    required DateTime createdAt,
  }) = _MessageItemImpl;

  factory MessageItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return MessageItem(
      id: jsonSerialization['id'] as int,
      senderId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['senderId'],
      ),
      text: jsonSerialization['text'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  _isc.UuidValue senderId;

  String text;

  DateTime createdAt;

  /// Returns a shallow copy of this [MessageItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MessageItem copyWith({
    int? id,
    _isc.UuidValue? senderId,
    String? text,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MessageItem',
      'id': id,
      'senderId': senderId.toJson(),
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MessageItem',
      'id': id,
      'senderId': senderId.toJson(),
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _MessageItemImpl extends MessageItem {
  _MessageItemImpl({
    required int id,
    required _isc.UuidValue senderId,
    required String text,
    required DateTime createdAt,
  }) : super._(
         id: id,
         senderId: senderId,
         text: text,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MessageItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MessageItem copyWith({
    int? id,
    _isc.UuidValue? senderId,
    String? text,
    DateTime? createdAt,
  }) {
    return MessageItem(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
