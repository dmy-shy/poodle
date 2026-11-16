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

abstract class CourseAnnouncementInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CourseAnnouncementInfo._({
    required this.body,
    this.author,
    this.publishedAt,
  });

  factory CourseAnnouncementInfo({
    required String body,
    String? author,
    DateTime? publishedAt,
  }) = _CourseAnnouncementInfoImpl;

  factory CourseAnnouncementInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CourseAnnouncementInfo(
      body: jsonSerialization['body'] as String,
      author: jsonSerialization['author'] as String?,
      publishedAt: jsonSerialization['publishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['publishedAt'],
            ),
    );
  }

  String body;

  String? author;

  DateTime? publishedAt;

  /// Returns a shallow copy of this [CourseAnnouncementInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CourseAnnouncementInfo copyWith({
    String? body,
    String? author,
    DateTime? publishedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseAnnouncementInfo',
      'body': body,
      if (author != null) 'author': author,
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CourseAnnouncementInfo',
      'body': body,
      if (author != null) 'author': author,
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseAnnouncementInfoImpl extends CourseAnnouncementInfo {
  _CourseAnnouncementInfoImpl({
    required String body,
    String? author,
    DateTime? publishedAt,
  }) : super._(
         body: body,
         author: author,
         publishedAt: publishedAt,
       );

  /// Returns a shallow copy of this [CourseAnnouncementInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CourseAnnouncementInfo copyWith({
    String? body,
    Object? author = _Undefined,
    Object? publishedAt = _Undefined,
  }) {
    return CourseAnnouncementInfo(
      body: body ?? this.body,
      author: author is String? ? author : this.author,
      publishedAt: publishedAt is DateTime? ? publishedAt : this.publishedAt,
    );
  }
}
