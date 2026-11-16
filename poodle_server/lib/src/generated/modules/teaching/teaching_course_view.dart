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

abstract class TeachingCourseView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TeachingCourseView._({
    required this.courseId,
    required this.title,
    required this.pendingGrades,
    required this.drafts,
    required this.unreleasedTests,
    required this.upcomingDeadlines,
  });

  factory TeachingCourseView({
    required _is.UuidValue courseId,
    required String title,
    required int pendingGrades,
    required int drafts,
    required int unreleasedTests,
    required List<DateTime> upcomingDeadlines,
  }) = _TeachingCourseViewImpl;

  factory TeachingCourseView.fromJson(Map<String, dynamic> jsonSerialization) {
    return TeachingCourseView(
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      title: jsonSerialization['title'] as String,
      pendingGrades: jsonSerialization['pendingGrades'] as int,
      drafts: jsonSerialization['drafts'] as int,
      unreleasedTests: jsonSerialization['unreleasedTests'] as int,
      upcomingDeadlines: _ikm1kaos.Protocol().deserialize<List<DateTime>>(
        jsonSerialization['upcomingDeadlines'],
      ),
    );
  }

  _is.UuidValue courseId;

  String title;

  int pendingGrades;

  int drafts;

  int unreleasedTests;

  List<DateTime> upcomingDeadlines;

  /// Returns a shallow copy of this [TeachingCourseView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeachingCourseView copyWith({
    _is.UuidValue? courseId,
    String? title,
    int? pendingGrades,
    int? drafts,
    int? unreleasedTests,
    List<DateTime>? upcomingDeadlines,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingCourseView',
      'courseId': courseId.toJson(),
      'title': title,
      'pendingGrades': pendingGrades,
      'drafts': drafts,
      'unreleasedTests': unreleasedTests,
      'upcomingDeadlines': upcomingDeadlines.toJson(
        valueToJson: (v) => v.toJson(),
      ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeachingCourseView',
      'courseId': courseId.toJson(),
      'title': title,
      'pendingGrades': pendingGrades,
      'drafts': drafts,
      'unreleasedTests': unreleasedTests,
      'upcomingDeadlines': upcomingDeadlines.toJson(
        valueToJson: (v) => v.toJson(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TeachingCourseViewImpl extends TeachingCourseView {
  _TeachingCourseViewImpl({
    required _is.UuidValue courseId,
    required String title,
    required int pendingGrades,
    required int drafts,
    required int unreleasedTests,
    required List<DateTime> upcomingDeadlines,
  }) : super._(
         courseId: courseId,
         title: title,
         pendingGrades: pendingGrades,
         drafts: drafts,
         unreleasedTests: unreleasedTests,
         upcomingDeadlines: upcomingDeadlines,
       );

  /// Returns a shallow copy of this [TeachingCourseView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeachingCourseView copyWith({
    _is.UuidValue? courseId,
    String? title,
    int? pendingGrades,
    int? drafts,
    int? unreleasedTests,
    List<DateTime>? upcomingDeadlines,
  }) {
    return TeachingCourseView(
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      pendingGrades: pendingGrades ?? this.pendingGrades,
      drafts: drafts ?? this.drafts,
      unreleasedTests: unreleasedTests ?? this.unreleasedTests,
      upcomingDeadlines:
          upcomingDeadlines ?? this.upcomingDeadlines.map((e0) => e0).toList(),
    );
  }
}
