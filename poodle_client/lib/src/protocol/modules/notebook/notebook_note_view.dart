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

abstract class NotebookNoteView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NotebookNoteView._({
    required this.id,
    required this.turnId,
    required this.content,
    required this.stale,
    required this.createdAt,
  });

  factory NotebookNoteView({
    required _isc.UuidValue id,
    required _isc.UuidValue turnId,
    required String content,
    required bool stale,
    required DateTime createdAt,
  }) = _NotebookNoteViewImpl;

  factory NotebookNoteView.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookNoteView(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      turnId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['turnId']),
      content: jsonSerialization['content'] as String,
      stale: _isc.BoolJsonExtension.fromJson(jsonSerialization['stale']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _isc.UuidValue id;

  _isc.UuidValue turnId;

  String content;

  bool stale;

  DateTime createdAt;

  /// Returns a shallow copy of this [NotebookNoteView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotebookNoteView copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? turnId,
    String? content,
    bool? stale,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookNoteView',
      'id': id.toJson(),
      'turnId': turnId.toJson(),
      'content': content,
      'stale': stale,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookNoteView',
      'id': id.toJson(),
      'turnId': turnId.toJson(),
      'content': content,
      'stale': stale,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _NotebookNoteViewImpl extends NotebookNoteView {
  _NotebookNoteViewImpl({
    required _isc.UuidValue id,
    required _isc.UuidValue turnId,
    required String content,
    required bool stale,
    required DateTime createdAt,
  }) : super._(
         id: id,
         turnId: turnId,
         content: content,
         stale: stale,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotebookNoteView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NotebookNoteView copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? turnId,
    String? content,
    bool? stale,
    DateTime? createdAt,
  }) {
    return NotebookNoteView(
      id: id ?? this.id,
      turnId: turnId ?? this.turnId,
      content: content ?? this.content,
      stale: stale ?? this.stale,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
