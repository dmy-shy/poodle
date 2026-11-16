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

abstract class NotebookStudioRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NotebookStudioRequest._({
    required this.notebookId,
    required this.kind,
    required this.language,
    required this.requestKey,
  });

  factory NotebookStudioRequest({
    required _isc.UuidValue notebookId,
    required String kind,
    required String language,
    required String requestKey,
  }) = _NotebookStudioRequestImpl;

  factory NotebookStudioRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookStudioRequest(
      notebookId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['notebookId'],
      ),
      kind: jsonSerialization['kind'] as String,
      language: jsonSerialization['language'] as String,
      requestKey: jsonSerialization['requestKey'] as String,
    );
  }

  _isc.UuidValue notebookId;

  String kind;

  String language;

  String requestKey;

  /// Returns a shallow copy of this [NotebookStudioRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotebookStudioRequest copyWith({
    _isc.UuidValue? notebookId,
    String? kind,
    String? language,
    String? requestKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookStudioRequest',
      'notebookId': notebookId.toJson(),
      'kind': kind,
      'language': language,
      'requestKey': requestKey,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookStudioRequest',
      'notebookId': notebookId.toJson(),
      'kind': kind,
      'language': language,
      'requestKey': requestKey,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _NotebookStudioRequestImpl extends NotebookStudioRequest {
  _NotebookStudioRequestImpl({
    required _isc.UuidValue notebookId,
    required String kind,
    required String language,
    required String requestKey,
  }) : super._(
         notebookId: notebookId,
         kind: kind,
         language: language,
         requestKey: requestKey,
       );

  /// Returns a shallow copy of this [NotebookStudioRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NotebookStudioRequest copyWith({
    _isc.UuidValue? notebookId,
    String? kind,
    String? language,
    String? requestKey,
  }) {
    return NotebookStudioRequest(
      notebookId: notebookId ?? this.notebookId,
      kind: kind ?? this.kind,
      language: language ?? this.language,
      requestKey: requestKey ?? this.requestKey,
    );
  }
}
