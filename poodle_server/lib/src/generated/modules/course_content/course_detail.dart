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
import 'package:poodle_server/src/generated/protocol.dart' as _ikm1kaos;
import 'package:serverpod/serverpod.dart' as _is;
import '../../modules/course_content/course_section.dart' as _i6cl70aw;
import '../../modules/courses/course_summary.dart' as _ieu8tik8;

abstract class CourseDetail
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CourseDetail._({
    required this.course,
    required this.sections,
    required this.teacherView,
    required this.serverTime,
  });

  factory CourseDetail({
    required _ieu8tik8.CourseSummary course,
    required List<_i6cl70aw.CourseSection> sections,
    required bool teacherView,
    required DateTime serverTime,
  }) = _CourseDetailImpl;

  factory CourseDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return CourseDetail(
      course: _ikm1kaos.Protocol().deserialize<_ieu8tik8.CourseSummary>(
        jsonSerialization['course'],
      ),
      sections: _ikm1kaos.Protocol().deserialize<List<_i6cl70aw.CourseSection>>(
        jsonSerialization['sections'],
      ),
      teacherView: _is.BoolJsonExtension.fromJson(
        jsonSerialization['teacherView'],
      ),
      serverTime: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
    );
  }

  _ieu8tik8.CourseSummary course;

  List<_i6cl70aw.CourseSection> sections;

  bool teacherView;

  DateTime serverTime;

  /// Returns a shallow copy of this [CourseDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CourseDetail copyWith({
    _ieu8tik8.CourseSummary? course,
    List<_i6cl70aw.CourseSection>? sections,
    bool? teacherView,
    DateTime? serverTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseDetail',
      'course': course.toJson(),
      'sections': sections.toJson(valueToJson: (v) => v.toJson()),
      'teacherView': teacherView,
      'serverTime': serverTime.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CourseDetail',
      'course': course.toJsonForProtocol(),
      'sections': sections.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'teacherView': teacherView,
      'serverTime': serverTime.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CourseDetailImpl extends CourseDetail {
  _CourseDetailImpl({
    required _ieu8tik8.CourseSummary course,
    required List<_i6cl70aw.CourseSection> sections,
    required bool teacherView,
    required DateTime serverTime,
  }) : super._(
         course: course,
         sections: sections,
         teacherView: teacherView,
         serverTime: serverTime,
       );

  /// Returns a shallow copy of this [CourseDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CourseDetail copyWith({
    _ieu8tik8.CourseSummary? course,
    List<_i6cl70aw.CourseSection>? sections,
    bool? teacherView,
    DateTime? serverTime,
  }) {
    return CourseDetail(
      course: course ?? this.course.copyWith(),
      sections: sections ?? this.sections.map((e0) => e0.copyWith()).toList(),
      teacherView: teacherView ?? this.teacherView,
      serverTime: serverTime ?? this.serverTime,
    );
  }
}
