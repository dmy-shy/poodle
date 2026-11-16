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

abstract class AdminDirectoryRow
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminDirectoryRow._({
    required this.id,
    required this.label,
    bool? student,
    bool? teacher,
    bool? admin,
    int? students,
    int? teachers,
  }) : student = student ?? false,
       teacher = teacher ?? false,
       admin = admin ?? false,
       students = students ?? 0,
       teachers = teachers ?? 0;

  factory AdminDirectoryRow({
    required String id,
    required String label,
    bool? student,
    bool? teacher,
    bool? admin,
    int? students,
    int? teachers,
  }) = _AdminDirectoryRowImpl;

  factory AdminDirectoryRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminDirectoryRow(
      id: jsonSerialization['id'] as String,
      label: jsonSerialization['label'] as String,
      student: jsonSerialization['student'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['student']),
      teacher: jsonSerialization['teacher'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['teacher']),
      admin: jsonSerialization['admin'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['admin']),
      students: jsonSerialization['students'] as int?,
      teachers: jsonSerialization['teachers'] as int?,
    );
  }

  String id;

  String label;

  bool student;

  bool teacher;

  bool admin;

  int students;

  int teachers;

  /// Returns a shallow copy of this [AdminDirectoryRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminDirectoryRow copyWith({
    String? id,
    String? label,
    bool? student,
    bool? teacher,
    bool? admin,
    int? students,
    int? teachers,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminDirectoryRow',
      'id': id,
      'label': label,
      'student': student,
      'teacher': teacher,
      'admin': admin,
      'students': students,
      'teachers': teachers,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminDirectoryRow',
      'id': id,
      'label': label,
      'student': student,
      'teacher': teacher,
      'admin': admin,
      'students': students,
      'teachers': teachers,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AdminDirectoryRowImpl extends AdminDirectoryRow {
  _AdminDirectoryRowImpl({
    required String id,
    required String label,
    bool? student,
    bool? teacher,
    bool? admin,
    int? students,
    int? teachers,
  }) : super._(
         id: id,
         label: label,
         student: student,
         teacher: teacher,
         admin: admin,
         students: students,
         teachers: teachers,
       );

  /// Returns a shallow copy of this [AdminDirectoryRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminDirectoryRow copyWith({
    String? id,
    String? label,
    bool? student,
    bool? teacher,
    bool? admin,
    int? students,
    int? teachers,
  }) {
    return AdminDirectoryRow(
      id: id ?? this.id,
      label: label ?? this.label,
      student: student ?? this.student,
      teacher: teacher ?? this.teacher,
      admin: admin ?? this.admin,
      students: students ?? this.students,
      teachers: teachers ?? this.teachers,
    );
  }
}
