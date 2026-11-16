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

abstract class StudentTaskRow
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StudentTaskRow._({
    required this.courseId,
    required this.courseTitle,
    required this.activityId,
    required this.activityTitle,
    required this.kind,
    required this.deadline,
  });

  factory StudentTaskRow({
    required _is.UuidValue courseId,
    required String courseTitle,
    required _is.UuidValue activityId,
    required String activityTitle,
    required String kind,
    required DateTime deadline,
  }) = _StudentTaskRowImpl;

  factory StudentTaskRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentTaskRow(
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      courseTitle: jsonSerialization['courseTitle'] as String,
      activityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['activityId'],
      ),
      activityTitle: jsonSerialization['activityTitle'] as String,
      kind: jsonSerialization['kind'] as String,
      deadline: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['deadline'],
      ),
    );
  }

  _is.UuidValue courseId;

  String courseTitle;

  _is.UuidValue activityId;

  String activityTitle;

  String kind;

  DateTime deadline;

  /// Returns a shallow copy of this [StudentTaskRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StudentTaskRow copyWith({
    _is.UuidValue? courseId,
    String? courseTitle,
    _is.UuidValue? activityId,
    String? activityTitle,
    String? kind,
    DateTime? deadline,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentTaskRow',
      'courseId': courseId.toJson(),
      'courseTitle': courseTitle,
      'activityId': activityId.toJson(),
      'activityTitle': activityTitle,
      'kind': kind,
      'deadline': deadline.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentTaskRow',
      'courseId': courseId.toJson(),
      'courseTitle': courseTitle,
      'activityId': activityId.toJson(),
      'activityTitle': activityTitle,
      'kind': kind,
      'deadline': deadline.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _StudentTaskRowImpl extends StudentTaskRow {
  _StudentTaskRowImpl({
    required _is.UuidValue courseId,
    required String courseTitle,
    required _is.UuidValue activityId,
    required String activityTitle,
    required String kind,
    required DateTime deadline,
  }) : super._(
         courseId: courseId,
         courseTitle: courseTitle,
         activityId: activityId,
         activityTitle: activityTitle,
         kind: kind,
         deadline: deadline,
       );

  /// Returns a shallow copy of this [StudentTaskRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StudentTaskRow copyWith({
    _is.UuidValue? courseId,
    String? courseTitle,
    _is.UuidValue? activityId,
    String? activityTitle,
    String? kind,
    DateTime? deadline,
  }) {
    return StudentTaskRow(
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      activityId: activityId ?? this.activityId,
      activityTitle: activityTitle ?? this.activityTitle,
      kind: kind ?? this.kind,
      deadline: deadline ?? this.deadline,
    );
  }
}
