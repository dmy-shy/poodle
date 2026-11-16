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

abstract class AdministratorRequestSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdministratorRequestSummary._({
    required this.id,
    required this.name,
    required this.email,
    required this.university,
    required this.position,
    required this.note,
    required this.status,
    required this.createdAt,
    this.reviewNote,
  });

  factory AdministratorRequestSummary({
    required _is.UuidValue id,
    required String name,
    required String email,
    required String university,
    required String position,
    required String note,
    required String status,
    required DateTime createdAt,
    String? reviewNote,
  }) = _AdministratorRequestSummaryImpl;

  factory AdministratorRequestSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdministratorRequestSummary(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String,
      university: jsonSerialization['university'] as String,
      position: jsonSerialization['position'] as String,
      note: jsonSerialization['note'] as String,
      status: jsonSerialization['status'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      reviewNote: jsonSerialization['reviewNote'] as String?,
    );
  }

  _is.UuidValue id;

  String name;

  String email;

  String university;

  String position;

  String note;

  String status;

  DateTime createdAt;

  String? reviewNote;

  /// Returns a shallow copy of this [AdministratorRequestSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdministratorRequestSummary copyWith({
    _is.UuidValue? id,
    String? name,
    String? email,
    String? university,
    String? position,
    String? note,
    String? status,
    DateTime? createdAt,
    String? reviewNote,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdministratorRequestSummary',
      'id': id.toJson(),
      'name': name,
      'email': email,
      'university': university,
      'position': position,
      'note': note,
      'status': status,
      'createdAt': createdAt.toJson(),
      if (reviewNote != null) 'reviewNote': reviewNote,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdministratorRequestSummary',
      'id': id.toJson(),
      'name': name,
      'email': email,
      'university': university,
      'position': position,
      'note': note,
      'status': status,
      'createdAt': createdAt.toJson(),
      if (reviewNote != null) 'reviewNote': reviewNote,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdministratorRequestSummaryImpl extends AdministratorRequestSummary {
  _AdministratorRequestSummaryImpl({
    required _is.UuidValue id,
    required String name,
    required String email,
    required String university,
    required String position,
    required String note,
    required String status,
    required DateTime createdAt,
    String? reviewNote,
  }) : super._(
         id: id,
         name: name,
         email: email,
         university: university,
         position: position,
         note: note,
         status: status,
         createdAt: createdAt,
         reviewNote: reviewNote,
       );

  /// Returns a shallow copy of this [AdministratorRequestSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdministratorRequestSummary copyWith({
    _is.UuidValue? id,
    String? name,
    String? email,
    String? university,
    String? position,
    String? note,
    String? status,
    DateTime? createdAt,
    Object? reviewNote = _Undefined,
  }) {
    return AdministratorRequestSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      university: university ?? this.university,
      position: position ?? this.position,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      reviewNote: reviewNote is String? ? reviewNote : this.reviewNote,
    );
  }
}
