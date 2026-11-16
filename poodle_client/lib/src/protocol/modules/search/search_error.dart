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

abstract class SearchError
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  SearchError._({required this.code});

  factory SearchError({required String code}) = _SearchErrorImpl;

  factory SearchError.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchError(code: jsonSerialization['code'] as String);
  }

  String code;

  /// Returns a shallow copy of this [SearchError]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SearchError copyWith({String? code});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SearchError',
      'code': code,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SearchError',
      'code': code,
    };
  }

  @override
  String toString() {
    return 'SearchError(code: $code)';
  }
}

class _SearchErrorImpl extends SearchError {
  _SearchErrorImpl({required String code}) : super._(code: code);

  /// Returns a shallow copy of this [SearchError]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SearchError copyWith({String? code}) {
    return SearchError(code: code ?? this.code);
  }
}
