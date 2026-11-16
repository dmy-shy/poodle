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

/// Safe admin-facing invitation projection.
abstract class InvitationSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    required _isc.UuidValue id,
    required String email,
    required DateTime createdAt,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    String? purpose,
    _isc.UuidValue? courseId,
  }) = _InvitationSummaryImpl;

  factory InvitationSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return InvitationSummary(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      email: jsonSerialization['email'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['acceptedAt'],
            ),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
      purpose: jsonSerialization['purpose'] as String?,
      courseId: jsonSerialization['courseId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['courseId']),
    );
  }

  _isc.UuidValue id;

  String email;

  DateTime createdAt;

  DateTime expiresAt;

  DateTime? acceptedAt;

  DateTime? revokedAt;

  String purpose;

  _isc.UuidValue? courseId;

  /// Returns a shallow copy of this [InvitationSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  InvitationSummary copyWith({
    _isc.UuidValue? id,
    String? email,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    String? purpose,
    _isc.UuidValue? courseId,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InvitationSummaryImpl extends InvitationSummary {
  _InvitationSummaryImpl({
    required _isc.UuidValue id,
    required String email,
    required DateTime createdAt,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    String? purpose,
    _isc.UuidValue? courseId,
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
  @_isc.useResult
  @override
  InvitationSummary copyWith({
    _isc.UuidValue? id,
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
      courseId: courseId is _isc.UuidValue? ? courseId : this.courseId,
    );
  }
}
