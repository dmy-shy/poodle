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

abstract class CourseAssessmentInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CourseAssessmentInfo._({
    required this.instructions,
    this.opensAt,
    this.closesAt,
    this.attemptLimit,
    this.timeLimitMinutes,
  });

  factory CourseAssessmentInfo({
    required String instructions,
    DateTime? opensAt,
    DateTime? closesAt,
    int? attemptLimit,
    int? timeLimitMinutes,
  }) = _CourseAssessmentInfoImpl;

  factory CourseAssessmentInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CourseAssessmentInfo(
      instructions: jsonSerialization['instructions'] as String,
      opensAt: jsonSerialization['opensAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['opensAt']),
      closesAt: jsonSerialization['closesAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['closesAt']),
      attemptLimit: jsonSerialization['attemptLimit'] as int?,
      timeLimitMinutes: jsonSerialization['timeLimitMinutes'] as int?,
    );
  }

  String instructions;

  DateTime? opensAt;

  DateTime? closesAt;

  int? attemptLimit;

  int? timeLimitMinutes;

  /// Returns a shallow copy of this [CourseAssessmentInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CourseAssessmentInfo copyWith({
    String? instructions,
    DateTime? opensAt,
    DateTime? closesAt,
    int? attemptLimit,
    int? timeLimitMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseAssessmentInfo',
      'instructions': instructions,
      if (opensAt != null) 'opensAt': opensAt?.toJson(),
      if (closesAt != null) 'closesAt': closesAt?.toJson(),
      if (attemptLimit != null) 'attemptLimit': attemptLimit,
      if (timeLimitMinutes != null) 'timeLimitMinutes': timeLimitMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CourseAssessmentInfo',
      'instructions': instructions,
      if (opensAt != null) 'opensAt': opensAt?.toJson(),
      if (closesAt != null) 'closesAt': closesAt?.toJson(),
      if (attemptLimit != null) 'attemptLimit': attemptLimit,
      if (timeLimitMinutes != null) 'timeLimitMinutes': timeLimitMinutes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseAssessmentInfoImpl extends CourseAssessmentInfo {
  _CourseAssessmentInfoImpl({
    required String instructions,
    DateTime? opensAt,
    DateTime? closesAt,
    int? attemptLimit,
    int? timeLimitMinutes,
  }) : super._(
         instructions: instructions,
         opensAt: opensAt,
         closesAt: closesAt,
         attemptLimit: attemptLimit,
         timeLimitMinutes: timeLimitMinutes,
       );

  /// Returns a shallow copy of this [CourseAssessmentInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CourseAssessmentInfo copyWith({
    String? instructions,
    Object? opensAt = _Undefined,
    Object? closesAt = _Undefined,
    Object? attemptLimit = _Undefined,
    Object? timeLimitMinutes = _Undefined,
  }) {
    return CourseAssessmentInfo(
      instructions: instructions ?? this.instructions,
      opensAt: opensAt is DateTime? ? opensAt : this.opensAt,
      closesAt: closesAt is DateTime? ? closesAt : this.closesAt,
      attemptLimit: attemptLimit is int? ? attemptLimit : this.attemptLimit,
      timeLimitMinutes: timeLimitMinutes is int?
          ? timeLimitMinutes
          : this.timeLimitMinutes,
    );
  }
}
