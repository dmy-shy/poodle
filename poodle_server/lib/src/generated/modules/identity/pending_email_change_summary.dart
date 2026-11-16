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

/// Safe pending-email state returned to the signed-in owner.
abstract class PendingEmailChangeSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PendingEmailChangeSummary._({
    required this.id,
    required this.requestedEmail,
    required this.expiresAt,
    required this.resendAvailableAt,
  });

  factory PendingEmailChangeSummary({
    required _is.UuidValue id,
    required String requestedEmail,
    required DateTime expiresAt,
    required DateTime resendAvailableAt,
  }) = _PendingEmailChangeSummaryImpl;

  factory PendingEmailChangeSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PendingEmailChangeSummary(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      requestedEmail: jsonSerialization['requestedEmail'] as String,
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      resendAvailableAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['resendAvailableAt'],
      ),
    );
  }

  _is.UuidValue id;

  String requestedEmail;

  DateTime expiresAt;

  DateTime resendAvailableAt;

  /// Returns a shallow copy of this [PendingEmailChangeSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PendingEmailChangeSummary copyWith({
    _is.UuidValue? id,
    String? requestedEmail,
    DateTime? expiresAt,
    DateTime? resendAvailableAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PendingEmailChangeSummary',
      'id': id.toJson(),
      'requestedEmail': requestedEmail,
      'expiresAt': expiresAt.toJson(),
      'resendAvailableAt': resendAvailableAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PendingEmailChangeSummary',
      'id': id.toJson(),
      'requestedEmail': requestedEmail,
      'expiresAt': expiresAt.toJson(),
      'resendAvailableAt': resendAvailableAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PendingEmailChangeSummaryImpl extends PendingEmailChangeSummary {
  _PendingEmailChangeSummaryImpl({
    required _is.UuidValue id,
    required String requestedEmail,
    required DateTime expiresAt,
    required DateTime resendAvailableAt,
  }) : super._(
         id: id,
         requestedEmail: requestedEmail,
         expiresAt: expiresAt,
         resendAvailableAt: resendAvailableAt,
       );

  /// Returns a shallow copy of this [PendingEmailChangeSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PendingEmailChangeSummary copyWith({
    _is.UuidValue? id,
    String? requestedEmail,
    DateTime? expiresAt,
    DateTime? resendAvailableAt,
  }) {
    return PendingEmailChangeSummary(
      id: id ?? this.id,
      requestedEmail: requestedEmail ?? this.requestedEmail,
      expiresAt: expiresAt ?? this.expiresAt,
      resendAvailableAt: resendAvailableAt ?? this.resendAvailableAt,
    );
  }
}
