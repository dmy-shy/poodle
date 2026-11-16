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
import '../../modules/student_learning/student_grade_row.dart' as _i9ysym1p;

abstract class StudentGradeCourse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StudentGradeCourse._({
    required this.courseId,
    required this.courseTitle,
    required this.grades,
  });

  factory StudentGradeCourse({
    required _isc.UuidValue courseId,
    required String courseTitle,
    required List<_i9ysym1p.StudentGradeRow> grades,
  }) = _StudentGradeCourseImpl;

  factory StudentGradeCourse.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentGradeCourse(
      courseId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      courseTitle: jsonSerialization['courseTitle'] as String,
      grades: _iwqu1w6v.Protocol().deserialize<List<_i9ysym1p.StudentGradeRow>>(
        jsonSerialization['grades'],
      ),
    );
  }

  _isc.UuidValue courseId;

  String courseTitle;

  List<_i9ysym1p.StudentGradeRow> grades;

  /// Returns a shallow copy of this [StudentGradeCourse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StudentGradeCourse copyWith({
    _isc.UuidValue? courseId,
    String? courseTitle,
    List<_i9ysym1p.StudentGradeRow>? grades,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentGradeCourse',
      'courseId': courseId.toJson(),
      'courseTitle': courseTitle,
      'grades': grades.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentGradeCourse',
      'courseId': courseId.toJson(),
      'courseTitle': courseTitle,
      'grades': grades.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _StudentGradeCourseImpl extends StudentGradeCourse {
  _StudentGradeCourseImpl({
    required _isc.UuidValue courseId,
    required String courseTitle,
    required List<_i9ysym1p.StudentGradeRow> grades,
  }) : super._(
         courseId: courseId,
         courseTitle: courseTitle,
         grades: grades,
       );

  /// Returns a shallow copy of this [StudentGradeCourse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StudentGradeCourse copyWith({
    _isc.UuidValue? courseId,
    String? courseTitle,
    List<_i9ysym1p.StudentGradeRow>? grades,
  }) {
    return StudentGradeCourse(
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      grades: grades ?? this.grades.map((e0) => e0.copyWith()).toList(),
    );
  }
}
