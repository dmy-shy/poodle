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

abstract class NotebookUploadInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NotebookUploadInput._({
    required this.notebookId,
    required this.fileName,
    required this.sizeBytes,
    required this.checksum,
    required this.requestKey,
  });

  factory NotebookUploadInput({
    required _isc.UuidValue notebookId,
    required String fileName,
    required int sizeBytes,
    required String checksum,
    required String requestKey,
  }) = _NotebookUploadInputImpl;

  factory NotebookUploadInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookUploadInput(
      notebookId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['notebookId'],
      ),
      fileName: jsonSerialization['fileName'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      checksum: jsonSerialization['checksum'] as String,
      requestKey: jsonSerialization['requestKey'] as String,
    );
  }

  _isc.UuidValue notebookId;

  String fileName;

  int sizeBytes;

  String checksum;

  String requestKey;

  /// Returns a shallow copy of this [NotebookUploadInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotebookUploadInput copyWith({
    _isc.UuidValue? notebookId,
    String? fileName,
    int? sizeBytes,
    String? checksum,
    String? requestKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookUploadInput',
      'notebookId': notebookId.toJson(),
      'fileName': fileName,
      'sizeBytes': sizeBytes,
      'checksum': checksum,
      'requestKey': requestKey,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookUploadInput',
      'notebookId': notebookId.toJson(),
      'fileName': fileName,
      'sizeBytes': sizeBytes,
      'checksum': checksum,
      'requestKey': requestKey,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _NotebookUploadInputImpl extends NotebookUploadInput {
  _NotebookUploadInputImpl({
    required _isc.UuidValue notebookId,
    required String fileName,
    required int sizeBytes,
    required String checksum,
    required String requestKey,
  }) : super._(
         notebookId: notebookId,
         fileName: fileName,
         sizeBytes: sizeBytes,
         checksum: checksum,
         requestKey: requestKey,
       );

  /// Returns a shallow copy of this [NotebookUploadInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NotebookUploadInput copyWith({
    _isc.UuidValue? notebookId,
    String? fileName,
    int? sizeBytes,
    String? checksum,
    String? requestKey,
  }) {
    return NotebookUploadInput(
      notebookId: notebookId ?? this.notebookId,
      fileName: fileName ?? this.fileName,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      checksum: checksum ?? this.checksum,
      requestKey: requestKey ?? this.requestKey,
    );
  }
}
