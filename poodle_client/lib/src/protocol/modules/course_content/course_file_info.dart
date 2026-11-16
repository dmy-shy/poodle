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

abstract class CourseFileInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CourseFileInfo._({
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    required this.checksum,
  });

  factory CourseFileInfo({
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    required String checksum,
  }) = _CourseFileInfoImpl;

  factory CourseFileInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return CourseFileInfo(
      fileName: jsonSerialization['fileName'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      checksum: jsonSerialization['checksum'] as String,
    );
  }

  String fileName;

  String mimeType;

  int sizeBytes;

  String checksum;

  /// Returns a shallow copy of this [CourseFileInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CourseFileInfo copyWith({
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    String? checksum,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseFileInfo',
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'checksum': checksum,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CourseFileInfo',
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'checksum': checksum,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CourseFileInfoImpl extends CourseFileInfo {
  _CourseFileInfoImpl({
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    required String checksum,
  }) : super._(
         fileName: fileName,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         checksum: checksum,
       );

  /// Returns a shallow copy of this [CourseFileInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CourseFileInfo copyWith({
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    String? checksum,
  }) {
    return CourseFileInfo(
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      checksum: checksum ?? this.checksum,
    );
  }
}
