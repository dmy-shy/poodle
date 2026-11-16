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

/// Safe admin-facing invitation projection.
abstract class InvitationSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  InvitationSummary._({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.expiresAt,
    this.acceptedAt,
    this.revokedAt,
    String? purpose,
    this.courseId,
  }) : purpose = purpose ?? 'teacherCandidate';

  factory InvitationSummary({
    required _is.UuidValue id,
    required String email,
    required DateTime createdAt,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    String? purpose,
    _is.UuidValue? courseId,
  }) = _InvitationSummaryImpl;

  factory InvitationSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return InvitationSummary(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      email: jsonSerialization['email'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
      purpose: jsonSerialization['purpose'] as String?,
      courseId: jsonSerialization['courseId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['courseId']),
    );
  }

  _is.UuidValue id;

  String email;

  DateTime createdAt;

  DateTime expiresAt;

  DateTime? acceptedAt;

  DateTime? revokedAt;

  String purpose;

  _is.UuidValue? courseId;

  /// Returns a shallow copy of this [InvitationSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InvitationSummary copyWith({
    _is.UuidValue? id,
    String? email,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    String? purpose,
    _is.UuidValue? courseId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InvitationSummary',
      'id': id.toJson(),
      'email': email,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
      'purpose': purpose,
      if (courseId != null) 'courseId': courseId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InvitationSummary',
      'id': id.toJson(),
      'email': email,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
      'purpose': purpose,
      if (courseId != null) 'courseId': courseId?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InvitationSummaryImpl extends InvitationSummary {
  _InvitationSummaryImpl({
    required _is.UuidValue id,
    required String email,
    required DateTime createdAt,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    String? purpose,
    _is.UuidValue? courseId,
  }) : super._(
         id: id,
         email: email,
         createdAt: createdAt,
         expiresAt: expiresAt,
         acceptedAt: acceptedAt,
         revokedAt: revokedAt,
         purpose: purpose,
         courseId: courseId,
       );

  /// Returns a shallow copy of this [InvitationSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  InvitationSummary copyWith({
    _is.UuidValue? id,
    String? email,
    DateTime? createdAt,
    DateTime? expiresAt,
    Object? acceptedAt = _Undefined,
    Object? revokedAt = _Undefined,
    String? purpose,
    Object? courseId = _Undefined,
  }) {
    return InvitationSummary(
      id: id ?? this.id,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
      purpose: purpose ?? this.purpose,
      courseId: courseId is _is.UuidValue? ? courseId : this.courseId,
    );
  }
}
