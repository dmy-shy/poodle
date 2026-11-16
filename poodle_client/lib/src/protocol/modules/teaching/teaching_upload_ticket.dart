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

abstract class TeachingUploadTicket
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TeachingUploadTicket._({
    required this.id,
    required this.description,
  });

  factory TeachingUploadTicket({
    required _isc.UuidValue id,
    required String description,
  }) = _TeachingUploadTicketImpl;

  factory TeachingUploadTicket.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeachingUploadTicket(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      description: jsonSerialization['description'] as String,
    );
  }

  _isc.UuidValue id;

  String description;

  /// Returns a shallow copy of this [TeachingUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TeachingUploadTicket copyWith({
    _isc.UuidValue? id,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingUploadTicket',
      'id': id.toJson(),
      'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeachingUploadTicket',
      'id': id.toJson(),
      'description': description,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TeachingUploadTicketImpl extends TeachingUploadTicket {
  _TeachingUploadTicketImpl({
    required _isc.UuidValue id,
    required String description,
  }) : super._(
         id: id,
         description: description,
       );

  /// Returns a shallow copy of this [TeachingUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TeachingUploadTicket copyWith({
    _isc.UuidValue? id,
    String? description,
  }) {
    return TeachingUploadTicket(
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }
}
