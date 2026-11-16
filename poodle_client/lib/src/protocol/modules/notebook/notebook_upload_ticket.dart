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

abstract class NotebookUploadTicket
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NotebookUploadTicket._({
    required this.sourceId,
    required this.jobId,
    this.uploadDescription,
  });

  factory NotebookUploadTicket({
    required _isc.UuidValue sourceId,
    required _isc.UuidValue jobId,
    String? uploadDescription,
  }) = _NotebookUploadTicketImpl;

  factory NotebookUploadTicket.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookUploadTicket(
      sourceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['sourceId'],
      ),
      jobId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['jobId']),
      uploadDescription: jsonSerialization['uploadDescription'] as String?,
    );
  }

  _isc.UuidValue sourceId;

  _isc.UuidValue jobId;

  String? uploadDescription;

  /// Returns a shallow copy of this [NotebookUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotebookUploadTicket copyWith({
    _isc.UuidValue? sourceId,
    _isc.UuidValue? jobId,
    String? uploadDescription,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookUploadTicket',
      'sourceId': sourceId.toJson(),
      'jobId': jobId.toJson(),
      if (uploadDescription != null) 'uploadDescription': uploadDescription,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookUploadTicket',
      'sourceId': sourceId.toJson(),
      'jobId': jobId.toJson(),
      if (uploadDescription != null) 'uploadDescription': uploadDescription,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookUploadTicketImpl extends NotebookUploadTicket {
  _NotebookUploadTicketImpl({
    required _isc.UuidValue sourceId,
    required _isc.UuidValue jobId,
    String? uploadDescription,
  }) : super._(
         sourceId: sourceId,
         jobId: jobId,
         uploadDescription: uploadDescription,
       );

  /// Returns a shallow copy of this [NotebookUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NotebookUploadTicket copyWith({
    _isc.UuidValue? sourceId,
    _isc.UuidValue? jobId,
    Object? uploadDescription = _Undefined,
  }) {
    return NotebookUploadTicket(
      sourceId: sourceId ?? this.sourceId,
      jobId: jobId ?? this.jobId,
      uploadDescription: uploadDescription is String?
          ? uploadDescription
          : this.uploadDescription,
    );
  }
}
