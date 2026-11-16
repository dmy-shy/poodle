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

abstract class MyUpload
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MyUpload._({
    required this.id,
    required this.fileName,
    required this.kind,
    required this.uploadedAt,
    required this.courseId,
    required this.courseTitle,
    required this.activityId,
    required this.activityTitle,
    this.processingStatus,
  });

  factory MyUpload({
    required _isc.UuidValue id,
    required String fileName,
    required String kind,
    required DateTime uploadedAt,
    required _isc.UuidValue courseId,
    required String courseTitle,
    required _isc.UuidValue activityId,
    required String activityTitle,
    String? processingStatus,
  }) = _MyUploadImpl;

  factory MyUpload.fromJson(Map<String, dynamic> jsonSerialization) {
    return MyUpload(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      fileName: jsonSerialization['fileName'] as String,
      kind: jsonSerialization['kind'] as String,
      uploadedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['uploadedAt'],
      ),
      courseId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      courseTitle: jsonSerialization['courseTitle'] as String,
      activityId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['activityId'],
      ),
      activityTitle: jsonSerialization['activityTitle'] as String,
      processingStatus: jsonSerialization['processingStatus'] as String?,
    );
  }

  _isc.UuidValue id;

  String fileName;

  String kind;

  DateTime uploadedAt;

  _isc.UuidValue courseId;

  String courseTitle;

  _isc.UuidValue activityId;

  String activityTitle;

  String? processingStatus;

  /// Returns a shallow copy of this [MyUpload]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MyUpload copyWith({
    _isc.UuidValue? id,
    String? fileName,
    String? kind,
    DateTime? uploadedAt,
    _isc.UuidValue? courseId,
    String? courseTitle,
    _isc.UuidValue? activityId,
    String? activityTitle,
    String? processingStatus,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MyUpload',
      'id': id.toJson(),
      'fileName': fileName,
      'kind': kind,
      'uploadedAt': uploadedAt.toJson(),
      'courseId': courseId.toJson(),
      'courseTitle': courseTitle,
      'activityId': activityId.toJson(),
      'activityTitle': activityTitle,
      if (processingStatus != null) 'processingStatus': processingStatus,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MyUpload',
      'id': id.toJson(),
      'fileName': fileName,
      'kind': kind,
      'uploadedAt': uploadedAt.toJson(),
      'courseId': courseId.toJson(),
      'courseTitle': courseTitle,
      'activityId': activityId.toJson(),
      'activityTitle': activityTitle,
      if (processingStatus != null) 'processingStatus': processingStatus,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MyUploadImpl extends MyUpload {
  _MyUploadImpl({
    required _isc.UuidValue id,
    required String fileName,
    required String kind,
    required DateTime uploadedAt,
    required _isc.UuidValue courseId,
    required String courseTitle,
    required _isc.UuidValue activityId,
    required String activityTitle,
    String? processingStatus,
  }) : super._(
         id: id,
         fileName: fileName,
         kind: kind,
         uploadedAt: uploadedAt,
         courseId: courseId,
         courseTitle: courseTitle,
         activityId: activityId,
         activityTitle: activityTitle,
         processingStatus: processingStatus,
       );

  /// Returns a shallow copy of this [MyUpload]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MyUpload copyWith({
    _isc.UuidValue? id,
    String? fileName,
    String? kind,
    DateTime? uploadedAt,
    _isc.UuidValue? courseId,
    String? courseTitle,
    _isc.UuidValue? activityId,
    String? activityTitle,
    Object? processingStatus = _Undefined,
  }) {
    return MyUpload(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      kind: kind ?? this.kind,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      activityId: activityId ?? this.activityId,
      activityTitle: activityTitle ?? this.activityTitle,
      processingStatus: processingStatus is String?
          ? processingStatus
          : this.processingStatus,
    );
  }
}
