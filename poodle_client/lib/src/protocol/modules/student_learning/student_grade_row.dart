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

abstract class StudentGradeRow
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StudentGradeRow._({
    required this.courseId,
    required this.courseTitle,
    required this.activityId,
    required this.activityTitle,
    required this.kind,
    required this.status,
    this.points,
    this.maximum,
    this.feedback,
  });

  factory StudentGradeRow({
    required _isc.UuidValue courseId,
    required String courseTitle,
    required _isc.UuidValue activityId,
    required String activityTitle,
    required String kind,
    required String status,
    double? points,
    double? maximum,
    String? feedback,
  }) = _StudentGradeRowImpl;

  factory StudentGradeRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentGradeRow(
      courseId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      courseTitle: jsonSerialization['courseTitle'] as String,
      activityId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['activityId'],
      ),
      activityTitle: jsonSerialization['activityTitle'] as String,
      kind: jsonSerialization['kind'] as String,
      status: jsonSerialization['status'] as String,
      points: (jsonSerialization['points'] as num?)?.toDouble(),
      maximum: (jsonSerialization['maximum'] as num?)?.toDouble(),
      feedback: jsonSerialization['feedback'] as String?,
    );
  }

  _isc.UuidValue courseId;

  String courseTitle;

  _isc.UuidValue activityId;

  String activityTitle;

  String kind;

  String status;

  double? points;

  double? maximum;

  String? feedback;

  /// Returns a shallow copy of this [StudentGradeRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StudentGradeRow copyWith({
    _isc.UuidValue? courseId,
    String? courseTitle,
    _isc.UuidValue? activityId,
    String? activityTitle,
    String? kind,
    String? status,
    double? points,
    double? maximum,
    String? feedback,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentGradeRow',
      'courseId': courseId.toJson(),
      'courseTitle': courseTitle,
      'activityId': activityId.toJson(),
      'activityTitle': activityTitle,
      'kind': kind,
      'status': status,
      if (points != null) 'points': points,
      if (maximum != null) 'maximum': maximum,
      if (feedback != null) 'feedback': feedback,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentGradeRow',
      'courseId': courseId.toJson(),
      'courseTitle': courseTitle,
      'activityId': activityId.toJson(),
      'activityTitle': activityTitle,
      'kind': kind,
      'status': status,
      if (points != null) 'points': points,
      if (maximum != null) 'maximum': maximum,
      if (feedback != null) 'feedback': feedback,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentGradeRowImpl extends StudentGradeRow {
  _StudentGradeRowImpl({
    required _isc.UuidValue courseId,
    required String courseTitle,
    required _isc.UuidValue activityId,
    required String activityTitle,
    required String kind,
    required String status,
    double? points,
    double? maximum,
    String? feedback,
  }) : super._(
         courseId: courseId,
         courseTitle: courseTitle,
         activityId: activityId,
         activityTitle: activityTitle,
         kind: kind,
         status: status,
         points: points,
         maximum: maximum,
         feedback: feedback,
       );

  /// Returns a shallow copy of this [StudentGradeRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StudentGradeRow copyWith({
    _isc.UuidValue? courseId,
    String? courseTitle,
    _isc.UuidValue? activityId,
    String? activityTitle,
    String? kind,
    String? status,
    Object? points = _Undefined,
    Object? maximum = _Undefined,
    Object? feedback = _Undefined,
  }) {
    return StudentGradeRow(
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      activityId: activityId ?? this.activityId,
      activityTitle: activityTitle ?? this.activityTitle,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      points: points is double? ? points : this.points,
      maximum: maximum is double? ? maximum : this.maximum,
      feedback: feedback is String? ? feedback : this.feedback,
    );
  }
}
