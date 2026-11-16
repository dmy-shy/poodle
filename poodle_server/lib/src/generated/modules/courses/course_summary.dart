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

abstract class CourseSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CourseSummary._({
    required this.id,
    required this.title,
    this.category,
    this.summary,
    this.teacherName,
    required this.sample,
    required this.starred,
    required this.hidden,
    this.role,
    bool? published,
  }) : published = published ?? true;

  factory CourseSummary({
    required _is.UuidValue id,
    required String title,
    String? category,
    String? summary,
    String? teacherName,
    required bool sample,
    required bool starred,
    required bool hidden,
    String? role,
    bool? published,
  }) = _CourseSummaryImpl;

  factory CourseSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return CourseSummary(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      title: jsonSerialization['title'] as String,
      category: jsonSerialization['category'] as String?,
      summary: jsonSerialization['summary'] as String?,
      teacherName: jsonSerialization['teacherName'] as String?,
      sample: _is.BoolJsonExtension.fromJson(jsonSerialization['sample']),
      starred: _is.BoolJsonExtension.fromJson(jsonSerialization['starred']),
      hidden: _is.BoolJsonExtension.fromJson(jsonSerialization['hidden']),
      role: jsonSerialization['role'] as String?,
      published: jsonSerialization['published'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['published']),
    );
  }

  _is.UuidValue id;

  String title;

  String? category;

  String? summary;

  String? teacherName;

  bool sample;

  bool starred;

  bool hidden;

  String? role;

  bool published;

  /// Returns a shallow copy of this [CourseSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CourseSummary copyWith({
    _is.UuidValue? id,
    String? title,
    String? category,
    String? summary,
    String? teacherName,
    bool? sample,
    bool? starred,
    bool? hidden,
    String? role,
    bool? published,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseSummary',
      'id': id.toJson(),
      'title': title,
      if (category != null) 'category': category,
      if (summary != null) 'summary': summary,
      if (teacherName != null) 'teacherName': teacherName,
      'sample': sample,
      'starred': starred,
      'hidden': hidden,
      if (role != null) 'role': role,
      'published': published,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CourseSummary',
      'id': id.toJson(),
      'title': title,
      if (category != null) 'category': category,
      if (summary != null) 'summary': summary,
      if (teacherName != null) 'teacherName': teacherName,
      'sample': sample,
      'starred': starred,
      'hidden': hidden,
      if (role != null) 'role': role,
      'published': published,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseSummaryImpl extends CourseSummary {
  _CourseSummaryImpl({
    required _is.UuidValue id,
    required String title,
    String? category,
    String? summary,
    String? teacherName,
    required bool sample,
    required bool starred,
    required bool hidden,
    String? role,
    bool? published,
  }) : super._(
         id: id,
         title: title,
         category: category,
         summary: summary,
         teacherName: teacherName,
         sample: sample,
         starred: starred,
         hidden: hidden,
         role: role,
         published: published,
       );

  /// Returns a shallow copy of this [CourseSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CourseSummary copyWith({
    _is.UuidValue? id,
    String? title,
    Object? category = _Undefined,
    Object? summary = _Undefined,
    Object? teacherName = _Undefined,
    bool? sample,
    bool? starred,
    bool? hidden,
    Object? role = _Undefined,
    bool? published,
  }) {
    return CourseSummary(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category is String? ? category : this.category,
      summary: summary is String? ? summary : this.summary,
      teacherName: teacherName is String? ? teacherName : this.teacherName,
      sample: sample ?? this.sample,
      starred: starred ?? this.starred,
      hidden: hidden ?? this.hidden,
      role: role is String? ? role : this.role,
      published: published ?? this.published,
    );
  }
}
