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

abstract class TeachingError
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  TeachingError._({required this.code});

  factory TeachingError({required String code}) = _TeachingErrorImpl;

  factory TeachingError.fromJson(Map<String, dynamic> jsonSerialization) {
    return TeachingError(code: jsonSerialization['code'] as String);
  }

  String code;

  /// Returns a shallow copy of this [TeachingError]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeachingError copyWith({String? code});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingError',
      'code': code,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeachingError',
      'code': code,
    };
  }

  @override
  String toString() {
    return 'TeachingError(code: $code)';
  }
}

class _TeachingErrorImpl extends TeachingError {
  _TeachingErrorImpl({required String code}) : super._(code: code);

  /// Returns a shallow copy of this [TeachingError]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeachingError copyWith({String? code}) {
    return TeachingError(code: code ?? this.code);
  }
}
