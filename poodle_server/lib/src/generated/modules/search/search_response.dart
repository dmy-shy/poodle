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
import 'package:poodle_server/src/generated/protocol.dart' as _ikm1kaos;
import 'package:serverpod/serverpod.dart' as _is;
import '../../modules/search/search_hit.dart' as _ib3s72gd;

abstract class SearchResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SearchResponse._({
    required this.results,
    required this.keywordOnly,
    required this.incomplete,
    required this.capped,
  });

  factory SearchResponse({
    required List<_ib3s72gd.SearchHit> results,
    required bool keywordOnly,
    required bool incomplete,
    required bool capped,
  }) = _SearchResponseImpl;

  factory SearchResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchResponse(
      results: _ikm1kaos.Protocol().deserialize<List<_ib3s72gd.SearchHit>>(
        jsonSerialization['results'],
      ),
      keywordOnly: _is.BoolJsonExtension.fromJson(
        jsonSerialization['keywordOnly'],
      ),
      incomplete: _is.BoolJsonExtension.fromJson(
        jsonSerialization['incomplete'],
      ),
      capped: _is.BoolJsonExtension.fromJson(jsonSerialization['capped']),
    );
  }

  List<_ib3s72gd.SearchHit> results;

  bool keywordOnly;

  bool incomplete;

  bool capped;

  /// Returns a shallow copy of this [SearchResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SearchResponse copyWith({
    List<_ib3s72gd.SearchHit>? results,
    bool? keywordOnly,
    bool? incomplete,
    bool? capped,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SearchResponse',
      'results': results.toJson(valueToJson: (v) => v.toJson()),
      'keywordOnly': keywordOnly,
      'incomplete': incomplete,
      'capped': capped,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SearchResponse',
      'results': results.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'keywordOnly': keywordOnly,
      'incomplete': incomplete,
      'capped': capped,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SearchResponseImpl extends SearchResponse {
  _SearchResponseImpl({
    required List<_ib3s72gd.SearchHit> results,
    required bool keywordOnly,
    required bool incomplete,
    required bool capped,
  }) : super._(
         results: results,
         keywordOnly: keywordOnly,
         incomplete: incomplete,
         capped: capped,
       );

  /// Returns a shallow copy of this [SearchResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SearchResponse copyWith({
    List<_ib3s72gd.SearchHit>? results,
    bool? keywordOnly,
    bool? incomplete,
    bool? capped,
  }) {
    return SearchResponse(
      results: results ?? this.results.map((e0) => e0.copyWith()).toList(),
      keywordOnly: keywordOnly ?? this.keywordOnly,
      incomplete: incomplete ?? this.incomplete,
      capped: capped ?? this.capped,
    );
  }
}
