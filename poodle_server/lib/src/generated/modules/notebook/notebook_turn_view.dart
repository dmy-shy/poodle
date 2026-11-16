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
import 'package:poodle_server/src/generated/protocol.dart' as _ikm1kaos;
import 'package:serverpod/serverpod.dart' as _is;
import '../../modules/notebook/notebook_citation.dart' as _imuczup9;

abstract class NotebookTurnView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NotebookTurnView._({
    required this.id,
    required this.role,
    required this.content,
    required this.citations,
    required this.insufficientEvidence,
    required this.stale,
    required this.createdAt,
  });

  factory NotebookTurnView({
    required _is.UuidValue id,
    required String role,
    required String content,
    required List<_imuczup9.NotebookCitation> citations,
    required bool insufficientEvidence,
    required bool stale,
    required DateTime createdAt,
  }) = _NotebookTurnViewImpl;

  factory NotebookTurnView.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookTurnView(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      role: jsonSerialization['role'] as String,
      content: jsonSerialization['content'] as String,
      citations: _ikm1kaos.Protocol()
          .deserialize<List<_imuczup9.NotebookCitation>>(
            jsonSerialization['citations'],
          ),
      insufficientEvidence: _is.BoolJsonExtension.fromJson(
        jsonSerialization['insufficientEvidence'],
      ),
      stale: _is.BoolJsonExtension.fromJson(jsonSerialization['stale']),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _is.UuidValue id;

  String role;

  String content;

  List<_imuczup9.NotebookCitation> citations;

  bool insufficientEvidence;

  bool stale;

  DateTime createdAt;

  /// Returns a shallow copy of this [NotebookTurnView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookTurnView copyWith({
    _is.UuidValue? id,
    String? role,
    String? content,
    List<_imuczup9.NotebookCitation>? citations,
    bool? insufficientEvidence,
    bool? stale,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookTurnView',
      'id': id.toJson(),
      'role': role,
      'content': content,
      'citations': citations.toJson(valueToJson: (v) => v.toJson()),
      'insufficientEvidence': insufficientEvidence,
      'stale': stale,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookTurnView',
      'id': id.toJson(),
      'role': role,
      'content': content,
      'citations': citations.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'insufficientEvidence': insufficientEvidence,
      'stale': stale,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _NotebookTurnViewImpl extends NotebookTurnView {
  _NotebookTurnViewImpl({
    required _is.UuidValue id,
    required String role,
    required String content,
    required List<_imuczup9.NotebookCitation> citations,
    required bool insufficientEvidence,
    required bool stale,
    required DateTime createdAt,
  }) : super._(
         id: id,
         role: role,
         content: content,
         citations: citations,
         insufficientEvidence: insufficientEvidence,
         stale: stale,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotebookTurnView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookTurnView copyWith({
    _is.UuidValue? id,
    String? role,
    String? content,
    List<_imuczup9.NotebookCitation>? citations,
    bool? insufficientEvidence,
    bool? stale,
    DateTime? createdAt,
  }) {
    return NotebookTurnView(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      citations:
          citations ?? this.citations.map((e0) => e0.copyWith()).toList(),
      insufficientEvidence: insufficientEvidence ?? this.insufficientEvidence,
      stale: stale ?? this.stale,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
