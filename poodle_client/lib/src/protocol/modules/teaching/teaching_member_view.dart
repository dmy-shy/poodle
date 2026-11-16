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

abstract class TeachingMemberView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TeachingMemberView._({
    required this.id,
    required this.label,
    required this.role,
  });

  factory TeachingMemberView({
    required _isc.UuidValue id,
    required String label,
    required String role,
  }) = _TeachingMemberViewImpl;

  factory TeachingMemberView.fromJson(Map<String, dynamic> jsonSerialization) {
    return TeachingMemberView(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      label: jsonSerialization['label'] as String,
      role: jsonSerialization['role'] as String,
    );
  }

  _isc.UuidValue id;

  String label;

  String role;

  /// Returns a shallow copy of this [TeachingMemberView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TeachingMemberView copyWith({
    _isc.UuidValue? id,
    String? label,
    String? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingMemberView',
      'id': id.toJson(),
      'label': label,
      'role': role,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeachingMemberView',
      'id': id.toJson(),
      'label': label,
      'role': role,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TeachingMemberViewImpl extends TeachingMemberView {
  _TeachingMemberViewImpl({
    required _isc.UuidValue id,
    required String label,
    required String role,
  }) : super._(
         id: id,
         label: label,
         role: role,
       );

  /// Returns a shallow copy of this [TeachingMemberView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TeachingMemberView copyWith({
    _isc.UuidValue? id,
    String? label,
    String? role,
  }) {
    return TeachingMemberView(
      id: id ?? this.id,
      label: label ?? this.label,
      role: role ?? this.role,
    );
  }
}
