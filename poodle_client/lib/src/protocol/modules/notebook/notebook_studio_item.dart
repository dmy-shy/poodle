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
import 'package:poodle_client/src/protocol/protocol.dart' as _iwqu1w6v;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../modules/notebook/notebook_citation.dart' as _imuczup9;

abstract class NotebookStudioItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NotebookStudioItem._({
    required this.id,
    String? status,
    this.failureCode,
    required this.kind,
    required this.language,
    required this.title,
    required this.contentJson,
    required this.citations,
    required this.stale,
    required this.createdAt,
  }) : status = status ?? 'ready';

  factory NotebookStudioItem({
    required _isc.UuidValue id,
    String? status,
    String? failureCode,
    required String kind,
    required String language,
    required String title,
    required String contentJson,
    required List<_imuczup9.NotebookCitation> citations,
    required bool stale,
    required DateTime createdAt,
  }) = _NotebookStudioItemImpl;

  factory NotebookStudioItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookStudioItem(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      status: jsonSerialization['status'] as String?,
      failureCode: jsonSerialization['failureCode'] as String?,
      kind: jsonSerialization['kind'] as String,
      language: jsonSerialization['language'] as String,
      title: jsonSerialization['title'] as String,
      contentJson: jsonSerialization['contentJson'] as String,
      citations: _iwqu1w6v.Protocol()
          .deserialize<List<_imuczup9.NotebookCitation>>(
            jsonSerialization['citations'],
          ),
      stale: _isc.BoolJsonExtension.fromJson(jsonSerialization['stale']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _isc.UuidValue id;

  String status;

  String? failureCode;

  String kind;

  String language;

  String title;

  String contentJson;

  List<_imuczup9.NotebookCitation> citations;

  bool stale;

  DateTime createdAt;

  /// Returns a shallow copy of this [NotebookStudioItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotebookStudioItem copyWith({
    _isc.UuidValue? id,
    String? status,
    String? failureCode,
    String? kind,
    String? language,
    String? title,
    String? contentJson,
    List<_imuczup9.NotebookCitation>? citations,
    bool? stale,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookStudioItem',
      'id': id.toJson(),
      'status': status,
      if (failureCode != null) 'failureCode': failureCode,
      'kind': kind,
      'language': language,
      'title': title,
      'contentJson': contentJson,
      'citations': citations.toJson(valueToJson: (v) => v.toJson()),
      'stale': stale,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookStudioItem',
      'id': id.toJson(),
      'status': status,
      if (failureCode != null) 'failureCode': failureCode,
      'kind': kind,
      'language': language,
      'title': title,
      'contentJson': contentJson,
      'citations': citations.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'stale': stale,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookStudioItemImpl extends NotebookStudioItem {
  _NotebookStudioItemImpl({
    required _isc.UuidValue id,
    String? status,
    String? failureCode,
    required String kind,
    required String language,
    required String title,
    required String contentJson,
    required List<_imuczup9.NotebookCitation> citations,
    required bool stale,
    required DateTime createdAt,
  }) : super._(
         id: id,
         status: status,
         failureCode: failureCode,
         kind: kind,
         language: language,
         title: title,
         contentJson: contentJson,
         citations: citations,
         stale: stale,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotebookStudioItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NotebookStudioItem copyWith({
    _isc.UuidValue? id,
    String? status,
    Object? failureCode = _Undefined,
    String? kind,
    String? language,
    String? title,
    String? contentJson,
    List<_imuczup9.NotebookCitation>? citations,
    bool? stale,
    DateTime? createdAt,
  }) {
    return NotebookStudioItem(
      id: id ?? this.id,
      status: status ?? this.status,
      failureCode: failureCode is String? ? failureCode : this.failureCode,
      kind: kind ?? this.kind,
      language: language ?? this.language,
      title: title ?? this.title,
      contentJson: contentJson ?? this.contentJson,
      citations:
          citations ?? this.citations.map((e0) => e0.copyWith()).toList(),
      stale: stale ?? this.stale,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
