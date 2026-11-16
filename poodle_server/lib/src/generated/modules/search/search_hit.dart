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

abstract class SearchHit
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SearchHit._({
    required this.targetId,
    required this.courseId,
    this.sectionId,
    this.activityId,
    required this.kind,
    required this.title,
    required this.breadcrumb,
    required this.excerpt,
    required this.draft,
    this.page,
    this.location,
  });

  factory SearchHit({
    required _is.UuidValue targetId,
    required _is.UuidValue courseId,
    _is.UuidValue? sectionId,
    _is.UuidValue? activityId,
    required String kind,
    required String title,
    required String breadcrumb,
    required String excerpt,
    required bool draft,
    int? page,
    String? location,
  }) = _SearchHitImpl;

  factory SearchHit.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchHit(
      targetId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['targetId'],
      ),
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      sectionId: jsonSerialization['sectionId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['sectionId']),
      activityId: jsonSerialization['activityId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['activityId'],
            ),
      kind: jsonSerialization['kind'] as String,
      title: jsonSerialization['title'] as String,
      breadcrumb: jsonSerialization['breadcrumb'] as String,
      excerpt: jsonSerialization['excerpt'] as String,
      draft: _is.BoolJsonExtension.fromJson(jsonSerialization['draft']),
      page: jsonSerialization['page'] as int?,
      location: jsonSerialization['location'] as String?,
    );
  }

  _is.UuidValue targetId;

  _is.UuidValue courseId;

  _is.UuidValue? sectionId;

  _is.UuidValue? activityId;

  String kind;

  String title;

  String breadcrumb;

  String excerpt;

  bool draft;

  int? page;

  String? location;

  /// Returns a shallow copy of this [SearchHit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SearchHit copyWith({
    _is.UuidValue? targetId,
    _is.UuidValue? courseId,
    _is.UuidValue? sectionId,
    _is.UuidValue? activityId,
    String? kind,
    String? title,
    String? breadcrumb,
    String? excerpt,
    bool? draft,
    int? page,
    String? location,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SearchHit',
      'targetId': targetId.toJson(),
      'courseId': courseId.toJson(),
      if (sectionId != null) 'sectionId': sectionId?.toJson(),
      if (activityId != null) 'activityId': activityId?.toJson(),
      'kind': kind,
      'title': title,
      'breadcrumb': breadcrumb,
      'excerpt': excerpt,
      'draft': draft,
      if (page != null) 'page': page,
      if (location != null) 'location': location,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SearchHit',
      'targetId': targetId.toJson(),
      'courseId': courseId.toJson(),
      if (sectionId != null) 'sectionId': sectionId?.toJson(),
      if (activityId != null) 'activityId': activityId?.toJson(),
      'kind': kind,
      'title': title,
      'breadcrumb': breadcrumb,
      'excerpt': excerpt,
      'draft': draft,
      if (page != null) 'page': page,
      if (location != null) 'location': location,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SearchHitImpl extends SearchHit {
  _SearchHitImpl({
    required _is.UuidValue targetId,
    required _is.UuidValue courseId,
    _is.UuidValue? sectionId,
    _is.UuidValue? activityId,
    required String kind,
    required String title,
    required String breadcrumb,
    required String excerpt,
    required bool draft,
    int? page,
    String? location,
  }) : super._(
         targetId: targetId,
         courseId: courseId,
         sectionId: sectionId,
         activityId: activityId,
         kind: kind,
         title: title,
         breadcrumb: breadcrumb,
         excerpt: excerpt,
         draft: draft,
         page: page,
         location: location,
       );

  /// Returns a shallow copy of this [SearchHit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SearchHit copyWith({
    _is.UuidValue? targetId,
    _is.UuidValue? courseId,
    Object? sectionId = _Undefined,
    Object? activityId = _Undefined,
    String? kind,
    String? title,
    String? breadcrumb,
    String? excerpt,
    bool? draft,
    Object? page = _Undefined,
    Object? location = _Undefined,
  }) {
    return SearchHit(
      targetId: targetId ?? this.targetId,
      courseId: courseId ?? this.courseId,
      sectionId: sectionId is _is.UuidValue? ? sectionId : this.sectionId,
      activityId: activityId is _is.UuidValue? ? activityId : this.activityId,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      breadcrumb: breadcrumb ?? this.breadcrumb,
      excerpt: excerpt ?? this.excerpt,
      draft: draft ?? this.draft,
      page: page is int? ? page : this.page,
      location: location is String? ? location : this.location,
    );
  }
}
