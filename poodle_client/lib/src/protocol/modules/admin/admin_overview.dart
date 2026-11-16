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

abstract class AdminOverview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminOverview._({
    required this.accounts,
    required this.students,
    required this.teachers,
    required this.admins,
    required this.courses,
    required this.pendingInvitations,
  });

  factory AdminOverview({
    required int accounts,
    required int students,
    required int teachers,
    required int admins,
    required int courses,
    required int pendingInvitations,
  }) = _AdminOverviewImpl;

  factory AdminOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminOverview(
      accounts: jsonSerialization['accounts'] as int,
      students: jsonSerialization['students'] as int,
      teachers: jsonSerialization['teachers'] as int,
      admins: jsonSerialization['admins'] as int,
      courses: jsonSerialization['courses'] as int,
      pendingInvitations: jsonSerialization['pendingInvitations'] as int,
    );
  }

  int accounts;

  int students;

  int teachers;

  int admins;

  int courses;

  int pendingInvitations;

  /// Returns a shallow copy of this [AdminOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminOverview copyWith({
    int? accounts,
    int? students,
    int? teachers,
    int? admins,
    int? courses,
    int? pendingInvitations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminOverview',
      'accounts': accounts,
      'students': students,
      'teachers': teachers,
      'admins': admins,
      'courses': courses,
      'pendingInvitations': pendingInvitations,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminOverview',
      'accounts': accounts,
      'students': students,
      'teachers': teachers,
      'admins': admins,
      'courses': courses,
      'pendingInvitations': pendingInvitations,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AdminOverviewImpl extends AdminOverview {
  _AdminOverviewImpl({
    required int accounts,
    required int students,
    required int teachers,
    required int admins,
    required int courses,
    required int pendingInvitations,
  }) : super._(
         accounts: accounts,
         students: students,
         teachers: teachers,
         admins: admins,
         courses: courses,
         pendingInvitations: pendingInvitations,
       );

  /// Returns a shallow copy of this [AdminOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminOverview copyWith({
    int? accounts,
    int? students,
    int? teachers,
    int? admins,
    int? courses,
    int? pendingInvitations,
  }) {
    return AdminOverview(
      accounts: accounts ?? this.accounts,
      students: students ?? this.students,
      teachers: teachers ?? this.teachers,
      admins: admins ?? this.admins,
      courses: courses ?? this.courses,
      pendingInvitations: pendingInvitations ?? this.pendingInvitations,
    );
  }
}
