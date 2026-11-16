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

abstract class SearchRecent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SearchRecent._({
    required this.id,
    required this.query,
    required this.lastUsed,
  });

  factory SearchRecent({
    required int id,
    required String query,
    required DateTime lastUsed,
  }) = _SearchRecentImpl;

  factory SearchRecent.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchRecent(
      id: jsonSerialization['id'] as int,
      query: jsonSerialization['query'] as String,
      lastUsed: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastUsed'],
      ),
    );
  }

  int id;

  String query;

  DateTime lastUsed;

  /// Returns a shallow copy of this [SearchRecent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SearchRecent copyWith({
    int? id,
    String? query,
    DateTime? lastUsed,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SearchRecent',
      'id': id,
      'query': query,
      'lastUsed': lastUsed.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SearchRecent',
      'id': id,
      'query': query,
      'lastUsed': lastUsed.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SearchRecentImpl extends SearchRecent {
  _SearchRecentImpl({
    required int id,
    required String query,
    required DateTime lastUsed,
  }) : super._(
         id: id,
         query: query,
         lastUsed: lastUsed,
       );

  /// Returns a shallow copy of this [SearchRecent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SearchRecent copyWith({
    int? id,
    String? query,
    DateTime? lastUsed,
  }) {
    return SearchRecent(
      id: id ?? this.id,
      query: query ?? this.query,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }
}
