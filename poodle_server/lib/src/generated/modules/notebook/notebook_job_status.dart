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
import 'package:serverpod/serverpod.dart' as _is;

abstract class NotebookJobStatus
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NotebookJobStatus._({
    required this.id,
    required this.status,
    this.failureCode,
    required this.createdAt,
  });

  factory NotebookJobStatus({
    required _is.UuidValue id,
    required String status,
    String? failureCode,
    required DateTime createdAt,
  }) = _NotebookJobStatusImpl;

  factory NotebookJobStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookJobStatus(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      status: jsonSerialization['status'] as String,
      failureCode: jsonSerialization['failureCode'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _is.UuidValue id;

  String status;

  String? failureCode;

  DateTime createdAt;

  /// Returns a shallow copy of this [NotebookJobStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookJobStatus copyWith({
    _is.UuidValue? id,
    String? status,
    String? failureCode,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookJobStatus',
      'id': id.toJson(),
      'status': status,
      if (failureCode != null) 'failureCode': failureCode,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookJobStatus',
      'id': id.toJson(),
      'status': status,
      if (failureCode != null) 'failureCode': failureCode,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookJobStatusImpl extends NotebookJobStatus {
  _NotebookJobStatusImpl({
    required _is.UuidValue id,
    required String status,
    String? failureCode,
    required DateTime createdAt,
  }) : super._(
         id: id,
         status: status,
         failureCode: failureCode,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotebookJobStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookJobStatus copyWith({
    _is.UuidValue? id,
    String? status,
    Object? failureCode = _Undefined,
    DateTime? createdAt,
  }) {
    return NotebookJobStatus(
      id: id ?? this.id,
      status: status ?? this.status,
      failureCode: failureCode is String? ? failureCode : this.failureCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
