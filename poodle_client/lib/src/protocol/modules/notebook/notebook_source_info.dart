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

abstract class NotebookSourceInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NotebookSourceInfo._({
    required this.id,
    required this.title,
    required this.format,
    required this.status,
    required this.selected,
    required this.teacherDefault,
    required this.currentVersion,
    this.failureCode,
    bool? privateUpload,
  }) : privateUpload = privateUpload ?? false;

  factory NotebookSourceInfo({
    required _isc.UuidValue id,
    required String title,
    required String format,
    required String status,
    required bool selected,
    required bool teacherDefault,
    required int currentVersion,
    String? failureCode,
    bool? privateUpload,
  }) = _NotebookSourceInfoImpl;

  factory NotebookSourceInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookSourceInfo(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      title: jsonSerialization['title'] as String,
      format: jsonSerialization['format'] as String,
      status: jsonSerialization['status'] as String,
      selected: _isc.BoolJsonExtension.fromJson(jsonSerialization['selected']),
      teacherDefault: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['teacherDefault'],
      ),
      currentVersion: jsonSerialization['currentVersion'] as int,
      failureCode: jsonSerialization['failureCode'] as String?,
      privateUpload: jsonSerialization['privateUpload'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['privateUpload']),
    );
  }

  _isc.UuidValue id;

  String title;

  String format;

  String status;

  bool selected;

  bool teacherDefault;

  int currentVersion;

  String? failureCode;

  bool privateUpload;

  /// Returns a shallow copy of this [NotebookSourceInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotebookSourceInfo copyWith({
    _isc.UuidValue? id,
    String? title,
    String? format,
    String? status,
    bool? selected,
    bool? teacherDefault,
    int? currentVersion,
    String? failureCode,
    bool? privateUpload,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookSourceInfo',
      'id': id.toJson(),
      'title': title,
      'format': format,
      'status': status,
      'selected': selected,
      'teacherDefault': teacherDefault,
      'currentVersion': currentVersion,
      if (failureCode != null) 'failureCode': failureCode,
      'privateUpload': privateUpload,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookSourceInfo',
      'id': id.toJson(),
      'title': title,
      'format': format,
      'status': status,
      'selected': selected,
      'teacherDefault': teacherDefault,
      'currentVersion': currentVersion,
      if (failureCode != null) 'failureCode': failureCode,
      'privateUpload': privateUpload,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookSourceInfoImpl extends NotebookSourceInfo {
  _NotebookSourceInfoImpl({
    required _isc.UuidValue id,
    required String title,
    required String format,
    required String status,
    required bool selected,
    required bool teacherDefault,
    required int currentVersion,
    String? failureCode,
    bool? privateUpload,
  }) : super._(
         id: id,
         title: title,
         format: format,
         status: status,
         selected: selected,
         teacherDefault: teacherDefault,
         currentVersion: currentVersion,
         failureCode: failureCode,
         privateUpload: privateUpload,
       );

  /// Returns a shallow copy of this [NotebookSourceInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NotebookSourceInfo copyWith({
    _isc.UuidValue? id,
    String? title,
    String? format,
    String? status,
    bool? selected,
    bool? teacherDefault,
    int? currentVersion,
    Object? failureCode = _Undefined,
    bool? privateUpload,
  }) {
    return NotebookSourceInfo(
      id: id ?? this.id,
      title: title ?? this.title,
      format: format ?? this.format,
      status: status ?? this.status,
      selected: selected ?? this.selected,
      teacherDefault: teacherDefault ?? this.teacherDefault,
      currentVersion: currentVersion ?? this.currentVersion,
      failureCode: failureCode is String? ? failureCode : this.failureCode,
      privateUpload: privateUpload ?? this.privateUpload,
    );
  }
}
