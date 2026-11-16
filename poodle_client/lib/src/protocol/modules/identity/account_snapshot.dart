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

/// Current server-confirmed authority. Contains no credentials or global course roles.
abstract class AccountSnapshot
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AccountSnapshot._({
    required this.authUserId,
    required this.email,
    required this.isAdmin,
    this.universityId,
    bool? isUniversityAdmin,
    required this.teacherApproved,
    bool? googleLinked,
    bool? hasPassword,
  }) : isUniversityAdmin = isUniversityAdmin ?? false,
       googleLinked = googleLinked ?? false,
       hasPassword = hasPassword ?? false;

  factory AccountSnapshot({
    required _isc.UuidValue authUserId,
    required String email,
    required bool isAdmin,
    _isc.UuidValue? universityId,
    bool? isUniversityAdmin,
    required bool teacherApproved,
    bool? googleLinked,
    bool? hasPassword,
  }) = _AccountSnapshotImpl;

  factory AccountSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountSnapshot(
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      email: jsonSerialization['email'] as String,
      isAdmin: _isc.BoolJsonExtension.fromJson(jsonSerialization['isAdmin']),
      universityId: jsonSerialization['universityId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['universityId'],
            ),
      isUniversityAdmin: jsonSerialization['isUniversityAdmin'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['isUniversityAdmin'],
            ),
      teacherApproved: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['teacherApproved'],
      ),
      googleLinked: jsonSerialization['googleLinked'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['googleLinked']),
      hasPassword: jsonSerialization['hasPassword'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['hasPassword']),
    );
  }

  _isc.UuidValue authUserId;

  String email;

  bool isAdmin;

  _isc.UuidValue? universityId;

  bool isUniversityAdmin;

  bool teacherApproved;

  bool googleLinked;

  bool hasPassword;

  /// Returns a shallow copy of this [AccountSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccountSnapshot copyWith({
    _isc.UuidValue? authUserId,
    String? email,
    bool? isAdmin,
    _isc.UuidValue? universityId,
    bool? isUniversityAdmin,
    bool? teacherApproved,
    bool? googleLinked,
    bool? hasPassword,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountSnapshot',
      'authUserId': authUserId.toJson(),
      'email': email,
      'isAdmin': isAdmin,
      if (universityId != null) 'universityId': universityId?.toJson(),
      'isUniversityAdmin': isUniversityAdmin,
      'teacherApproved': teacherApproved,
      'googleLinked': googleLinked,
      'hasPassword': hasPassword,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountSnapshot',
      'authUserId': authUserId.toJson(),
      'email': email,
      'isAdmin': isAdmin,
      if (universityId != null) 'universityId': universityId?.toJson(),
      'isUniversityAdmin': isUniversityAdmin,
      'teacherApproved': teacherApproved,
      'googleLinked': googleLinked,
      'hasPassword': hasPassword,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountSnapshotImpl extends AccountSnapshot {
  _AccountSnapshotImpl({
    required _isc.UuidValue authUserId,
    required String email,
    required bool isAdmin,
    _isc.UuidValue? universityId,
    bool? isUniversityAdmin,
    required bool teacherApproved,
    bool? googleLinked,
    bool? hasPassword,
  }) : super._(
         authUserId: authUserId,
         email: email,
         isAdmin: isAdmin,
         universityId: universityId,
         isUniversityAdmin: isUniversityAdmin,
         teacherApproved: teacherApproved,
         googleLinked: googleLinked,
         hasPassword: hasPassword,
       );

  /// Returns a shallow copy of this [AccountSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AccountSnapshot copyWith({
    _isc.UuidValue? authUserId,
    String? email,
    bool? isAdmin,
    Object? universityId = _Undefined,
    bool? isUniversityAdmin,
    bool? teacherApproved,
    bool? googleLinked,
    bool? hasPassword,
  }) {
    return AccountSnapshot(
      authUserId: authUserId ?? this.authUserId,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      universityId: universityId is _isc.UuidValue?
          ? universityId
          : this.universityId,
      isUniversityAdmin: isUniversityAdmin ?? this.isUniversityAdmin,
      teacherApproved: teacherApproved ?? this.teacherApproved,
      googleLinked: googleLinked ?? this.googleLinked,
      hasPassword: hasPassword ?? this.hasPassword,
    );
  }
}
