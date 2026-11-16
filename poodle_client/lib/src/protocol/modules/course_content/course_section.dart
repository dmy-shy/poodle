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
import '../../modules/course_content/course_activity.dart' as _iynq3g52;

abstract class CourseSection
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CourseSection._({
    required this.id,
    required this.title,
    this.description,
    required this.draft,
    required this.activities,
  });

  factory CourseSection({
    required _isc.UuidValue id,
    required String title,
    String? description,
    required bool draft,
    required List<_iynq3g52.CourseActivity> activities,
  }) = _CourseSectionImpl;

  factory CourseSection.fromJson(Map<String, dynamic> jsonSerialization) {
    return CourseSection(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      draft: _isc.BoolJsonExtension.fromJson(jsonSerialization['draft']),
      activities: _iwqu1w6v.Protocol()
          .deserialize<List<_iynq3g52.CourseActivity>>(
            jsonSerialization['activities'],
          ),
    );
  }

  _isc.UuidValue id;

  String title;

  String? description;

  bool draft;

  List<_iynq3g52.CourseActivity> activities;

  /// Returns a shallow copy of this [CourseSection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CourseSection copyWith({
    _isc.UuidValue? id,
    String? title,
    String? description,
    bool? draft,
    List<_iynq3g52.CourseActivity>? activities,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseSection',
      'id': id.toJson(),
      'title': title,
      if (description != null) 'description': description,
      'draft': draft,
      'activities': activities.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CourseSection',
      'id': id.toJson(),
      'title': title,
      if (description != null) 'description': description,
      'draft': draft,
      'activities': activities.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseSectionImpl extends CourseSection {
  _CourseSectionImpl({
    required _isc.UuidValue id,
    required String title,
    String? description,
    required bool draft,
    required List<_iynq3g52.CourseActivity> activities,
  }) : super._(
         id: id,
         title: title,
         description: description,
         draft: draft,
         activities: activities,
       );

  /// Returns a shallow copy of this [CourseSection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CourseSection copyWith({
    _isc.UuidValue? id,
    String? title,
    Object? description = _Undefined,
    bool? draft,
    List<_iynq3g52.CourseActivity>? activities,
  }) {
    return CourseSection(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      draft: draft ?? this.draft,
      activities:
          activities ?? this.activities.map((e0) => e0.copyWith()).toList(),
    );
  }
}
