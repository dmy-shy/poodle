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

abstract class UniversityMemberSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UniversityMemberSummary._({
    required this.userId,
    required this.email,
    required this.administrator,
    required this.teacherApproved,
  });

  factory UniversityMemberSummary({
    required _isc.UuidValue userId,
    required String email,
    required bool administrator,
    required bool teacherApproved,
  }) = _UniversityMemberSummaryImpl;

  factory UniversityMemberSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UniversityMemberSummary(
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      email: jsonSerialization['email'] as String,
      administrator: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['administrator'],
      ),
      teacherApproved: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['teacherApproved'],
      ),
    );
  }

  _isc.UuidValue userId;

  String email;

  bool administrator;

  bool teacherApproved;

  /// Returns a shallow copy of this [UniversityMemberSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UniversityMemberSummary copyWith({
    _isc.UuidValue? userId,
    String? email,
    bool? administrator,
    bool? teacherApproved,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UniversityMemberSummary',
      'userId': userId.toJson(),
      'email': email,
      'administrator': administrator,
      'teacherApproved': teacherApproved,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UniversityMemberSummary',
      'userId': userId.toJson(),
      'email': email,
      'administrator': administrator,
      'teacherApproved': teacherApproved,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _UniversityMemberSummaryImpl extends UniversityMemberSummary {
  _UniversityMemberSummaryImpl({
    required _isc.UuidValue userId,
    required String email,
    required bool administrator,
    required bool teacherApproved,
  }) : super._(
         userId: userId,
         email: email,
         administrator: administrator,
         teacherApproved: teacherApproved,
       );

  /// Returns a shallow copy of this [UniversityMemberSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UniversityMemberSummary copyWith({
    _isc.UuidValue? userId,
    String? email,
    bool? administrator,
    bool? teacherApproved,
  }) {
    return UniversityMemberSummary(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      administrator: administrator ?? this.administrator,
      teacherApproved: teacherApproved ?? this.teacherApproved,
    );
  }
}
