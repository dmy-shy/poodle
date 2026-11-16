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

/// A course-eligible account that can receive a private message from the authenticated user.
abstract class EligiblePeer
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EligiblePeer._({
    required this.userId,
    required this.email,
  });

  factory EligiblePeer({
    required _isc.UuidValue userId,
    required String email,
  }) = _EligiblePeerImpl;

  factory EligiblePeer.fromJson(Map<String, dynamic> jsonSerialization) {
    return EligiblePeer(
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      email: jsonSerialization['email'] as String,
    );
  }

  _isc.UuidValue userId;

  String email;

  /// Returns a shallow copy of this [EligiblePeer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EligiblePeer copyWith({
    _isc.UuidValue? userId,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EligiblePeer',
      'userId': userId.toJson(),
      'email': email,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EligiblePeer',
      'userId': userId.toJson(),
      'email': email,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _EligiblePeerImpl extends EligiblePeer {
  _EligiblePeerImpl({
    required _isc.UuidValue userId,
    required String email,
  }) : super._(
         userId: userId,
         email: email,
       );

  /// Returns a shallow copy of this [EligiblePeer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EligiblePeer copyWith({
    _isc.UuidValue? userId,
    String? email,
  }) {
    return EligiblePeer(
      userId: userId ?? this.userId,
      email: email ?? this.email,
    );
  }
}
