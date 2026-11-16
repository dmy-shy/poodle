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
import '../../modules/course_content/course_announcement_info.dart'
    as _inglaeaf;
import '../../modules/course_content/course_assessment_info.dart' as _ivadimum;
import '../../modules/course_content/course_file_info.dart' as _ithyh9y5;
import '../../modules/course_content/course_link_info.dart' as _iwi7no9w;

abstract class CourseActivity
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CourseActivity._({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.kind,
    required this.draft,
    this.file,
    this.link,
    this.announcement,
    this.assessment,
    this.availability,
    this.previousId,
    this.nextId,
    bool? managedAssessment,
  }) : managedAssessment = managedAssessment ?? false;

  factory CourseActivity({
    required _is.UuidValue id,
    required _is.UuidValue courseId,
    required String title,
    String? description,
    required String kind,
    required bool draft,
    _ithyh9y5.CourseFileInfo? file,
    _iwi7no9w.CourseLinkInfo? link,
    _inglaeaf.CourseAnnouncementInfo? announcement,
    _ivadimum.CourseAssessmentInfo? assessment,
    String? availability,
    _is.UuidValue? previousId,
    _is.UuidValue? nextId,
    bool? managedAssessment,
  }) = _CourseActivityImpl;

  factory CourseActivity.fromJson(Map<String, dynamic> jsonSerialization) {
    return CourseActivity(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      kind: jsonSerialization['kind'] as String,
      draft: _is.BoolJsonExtension.fromJson(jsonSerialization['draft']),
      file: jsonSerialization['file'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_ithyh9y5.CourseFileInfo>(
              jsonSerialization['file'],
            ),
      link: jsonSerialization['link'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_iwi7no9w.CourseLinkInfo>(
              jsonSerialization['link'],
            ),
      announcement: jsonSerialization['announcement'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_inglaeaf.CourseAnnouncementInfo>(
              jsonSerialization['announcement'],
            ),
      assessment: jsonSerialization['assessment'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_ivadimum.CourseAssessmentInfo>(
              jsonSerialization['assessment'],
            ),
      availability: jsonSerialization['availability'] as String?,
      previousId: jsonSerialization['previousId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['previousId'],
            ),
      nextId: jsonSerialization['nextId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['nextId']),
      managedAssessment: jsonSerialization['managedAssessment'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['managedAssessment'],
            ),
    );
  }

  _is.UuidValue id;

  _is.UuidValue courseId;

  String title;

  String? description;

  String kind;

  bool draft;

  _ithyh9y5.CourseFileInfo? file;

  _iwi7no9w.CourseLinkInfo? link;

  _inglaeaf.CourseAnnouncementInfo? announcement;

  _ivadimum.CourseAssessmentInfo? assessment;

  String? availability;

  _is.UuidValue? previousId;

  _is.UuidValue? nextId;

  bool managedAssessment;

  /// Returns a shallow copy of this [CourseActivity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CourseActivity copyWith({
    _is.UuidValue? id,
    _is.UuidValue? courseId,
    String? title,
    String? description,
    String? kind,
    bool? draft,
    _ithyh9y5.CourseFileInfo? file,
    _iwi7no9w.CourseLinkInfo? link,
    _inglaeaf.CourseAnnouncementInfo? announcement,
    _ivadimum.CourseAssessmentInfo? assessment,
    String? availability,
    _is.UuidValue? previousId,
    _is.UuidValue? nextId,
    bool? managedAssessment,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseActivity',
      'id': id.toJson(),
      'courseId': courseId.toJson(),
      'title': title,
      if (description != null) 'description': description,
      'kind': kind,
      'draft': draft,
      if (file != null) 'file': file?.toJson(),
      if (link != null) 'link': link?.toJson(),
      if (announcement != null) 'announcement': announcement?.toJson(),
      if (assessment != null) 'assessment': assessment?.toJson(),
      if (availability != null) 'availability': availability,
      if (previousId != null) 'previousId': previousId?.toJson(),
      if (nextId != null) 'nextId': nextId?.toJson(),
      'managedAssessment': managedAssessment,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CourseActivity',
      'id': id.toJson(),
      'courseId': courseId.toJson(),
      'title': title,
      if (description != null) 'description': description,
      'kind': kind,
      'draft': draft,
      if (file != null) 'file': file?.toJsonForProtocol(),
      if (link != null) 'link': link?.toJsonForProtocol(),
      if (announcement != null)
        'announcement': announcement?.toJsonForProtocol(),
      if (assessment != null) 'assessment': assessment?.toJsonForProtocol(),
      if (availability != null) 'availability': availability,
      if (previousId != null) 'previousId': previousId?.toJson(),
      if (nextId != null) 'nextId': nextId?.toJson(),
      'managedAssessment': managedAssessment,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseActivityImpl extends CourseActivity {
  _CourseActivityImpl({
    required _is.UuidValue id,
    required _is.UuidValue courseId,
    required String title,
    String? description,
    required String kind,
    required bool draft,
    _ithyh9y5.CourseFileInfo? file,
    _iwi7no9w.CourseLinkInfo? link,
    _inglaeaf.CourseAnnouncementInfo? announcement,
    _ivadimum.CourseAssessmentInfo? assessment,
    String? availability,
    _is.UuidValue? previousId,
    _is.UuidValue? nextId,
    bool? managedAssessment,
  }) : super._(
         id: id,
         courseId: courseId,
         title: title,
         description: description,
         kind: kind,
         draft: draft,
         file: file,
         link: link,
         announcement: announcement,
         assessment: assessment,
         availability: availability,
         previousId: previousId,
         nextId: nextId,
         managedAssessment: managedAssessment,
       );

  /// Returns a shallow copy of this [CourseActivity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CourseActivity copyWith({
    _is.UuidValue? id,
    _is.UuidValue? courseId,
    String? title,
    Object? description = _Undefined,
    String? kind,
    bool? draft,
    Object? file = _Undefined,
    Object? link = _Undefined,
    Object? announcement = _Undefined,
    Object? assessment = _Undefined,
    Object? availability = _Undefined,
    Object? previousId = _Undefined,
    Object? nextId = _Undefined,
    bool? managedAssessment,
  }) {
    return CourseActivity(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      kind: kind ?? this.kind,
      draft: draft ?? this.draft,
      file: file is _ithyh9y5.CourseFileInfo? ? file : this.file?.copyWith(),
      link: link is _iwi7no9w.CourseLinkInfo? ? link : this.link?.copyWith(),
      announcement: announcement is _inglaeaf.CourseAnnouncementInfo?
          ? announcement
          : this.announcement?.copyWith(),
      assessment: assessment is _ivadimum.CourseAssessmentInfo?
          ? assessment
          : this.assessment?.copyWith(),
      availability: availability is String? ? availability : this.availability,
      previousId: previousId is _is.UuidValue? ? previousId : this.previousId,
      nextId: nextId is _is.UuidValue? ? nextId : this.nextId,
      managedAssessment: managedAssessment ?? this.managedAssessment,
    );
  }
}
