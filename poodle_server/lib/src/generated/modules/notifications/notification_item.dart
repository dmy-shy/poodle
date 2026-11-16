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

abstract class NotificationItem
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NotificationItem._({
    required this.id,
    required this.category,
    this.courseId,
    this.activityId,
    this.requestId,
    required this.title,
    required this.createdAt,
    this.readAt,
  });

  factory NotificationItem({
    required _is.UuidValue id,
    required String category,
    _is.UuidValue? courseId,
    _is.UuidValue? activityId,
    _is.UuidValue? requestId,
    required String title,
    required DateTime createdAt,
    DateTime? readAt,
  }) = _NotificationItemImpl;

  factory NotificationItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotificationItem(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      category: jsonSerialization['category'] as String,
      courseId: jsonSerialization['courseId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['courseId']),
      activityId: jsonSerialization['activityId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['activityId'],
            ),
      requestId: jsonSerialization['requestId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['requestId']),
      title: jsonSerialization['title'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
    );
  }

  _is.UuidValue id;

  String category;

  _is.UuidValue? courseId;

  _is.UuidValue? activityId;

  _is.UuidValue? requestId;

  String title;

  DateTime createdAt;

  DateTime? readAt;

  /// Returns a shallow copy of this [NotificationItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotificationItem copyWith({
    _is.UuidValue? id,
    String? category,
    _is.UuidValue? courseId,
    _is.UuidValue? activityId,
    _is.UuidValue? requestId,
    String? title,
    DateTime? createdAt,
    DateTime? readAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationItem',
      'id': id.toJson(),
      'category': category,
      if (courseId != null) 'courseId': courseId?.toJson(),
      if (activityId != null) 'activityId': activityId?.toJson(),
      if (requestId != null) 'requestId': requestId?.toJson(),
      'title': title,
      'createdAt': createdAt.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationItem',
      'id': id.toJson(),
      'category': category,
      if (courseId != null) 'courseId': courseId?.toJson(),
      if (activityId != null) 'activityId': activityId?.toJson(),
      if (requestId != null) 'requestId': requestId?.toJson(),
      'title': title,
      'createdAt': createdAt.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationItemImpl extends NotificationItem {
  _NotificationItemImpl({
    required _is.UuidValue id,
    required String category,
    _is.UuidValue? courseId,
    _is.UuidValue? activityId,
    _is.UuidValue? requestId,
    required String title,
    required DateTime createdAt,
    DateTime? readAt,
  }) : super._(
         id: id,
         category: category,
         courseId: courseId,
         activityId: activityId,
         requestId: requestId,
         title: title,
         createdAt: createdAt,
         readAt: readAt,
       );

  /// Returns a shallow copy of this [NotificationItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotificationItem copyWith({
    _is.UuidValue? id,
    String? category,
    Object? courseId = _Undefined,
    Object? activityId = _Undefined,
    Object? requestId = _Undefined,
    String? title,
    DateTime? createdAt,
    Object? readAt = _Undefined,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      category: category ?? this.category,
      courseId: courseId is _is.UuidValue? ? courseId : this.courseId,
      activityId: activityId is _is.UuidValue? ? activityId : this.activityId,
      requestId: requestId is _is.UuidValue? ? requestId : this.requestId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt is DateTime? ? readAt : this.readAt,
    );
  }
}
