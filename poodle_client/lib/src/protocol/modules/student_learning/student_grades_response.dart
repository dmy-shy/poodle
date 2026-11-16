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
import 'package:poodle_client/src/protocol/protocol.dart' as _iwqu1w6v;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../modules/student_learning/student_grade_course.dart' as _iiogffvl;

abstract class StudentGradesResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StudentGradesResponse._({required this.courses});

  factory StudentGradesResponse({
    required List<_iiogffvl.StudentGradeCourse> courses,
  }) = _StudentGradesResponseImpl;

  factory StudentGradesResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return StudentGradesResponse(
      courses: _iwqu1w6v.Protocol()
          .deserialize<List<_iiogffvl.StudentGradeCourse>>(
            jsonSerialization['courses'],
          ),
    );
  }

  List<_iiogffvl.StudentGradeCourse> courses;

  /// Returns a shallow copy of this [StudentGradesResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StudentGradesResponse copyWith({List<_iiogffvl.StudentGradeCourse>? courses});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentGradesResponse',
      'courses': courses.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentGradesResponse',
      'courses': courses.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _StudentGradesResponseImpl extends StudentGradesResponse {
  _StudentGradesResponseImpl({
    required List<_iiogffvl.StudentGradeCourse> courses,
  }) : super._(courses: courses);

  /// Returns a shallow copy of this [StudentGradesResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StudentGradesResponse copyWith({
    List<_iiogffvl.StudentGradeCourse>? courses,
  }) {
    return StudentGradesResponse(
      courses: courses ?? this.courses.map((e0) => e0.copyWith()).toList(),
    );
  }
}
