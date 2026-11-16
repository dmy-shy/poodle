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

abstract class UniversitySummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  UniversitySummary._({
    required this.id,
    required this.name,
  });

  factory UniversitySummary({
    required _is.UuidValue id,
    required String name,
  }) = _UniversitySummaryImpl;

  factory UniversitySummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return UniversitySummary(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
    );
  }

  _is.UuidValue id;

  String name;

  /// Returns a shallow copy of this [UniversitySummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UniversitySummary copyWith({
    _is.UuidValue? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UniversitySummary',
      'id': id.toJson(),
      'name': name,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UniversitySummary',
      'id': id.toJson(),
      'name': name,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UniversitySummaryImpl extends UniversitySummary {
  _UniversitySummaryImpl({
    required _is.UuidValue id,
    required String name,
  }) : super._(
         id: id,
         name: name,
       );

  /// Returns a shallow copy of this [UniversitySummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UniversitySummary copyWith({
    _is.UuidValue? id,
    String? name,
  }) {
    return UniversitySummary(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
