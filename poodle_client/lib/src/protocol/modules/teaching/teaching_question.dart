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
import 'package:poodle_client/src/protocol/protocol.dart' as _iwqu1w6v;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class TeachingQuestion
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TeachingQuestion._({
    required this.prompt,
    required this.kind,
    required this.options,
    this.correctIndex,
    required this.points,
  });

  factory TeachingQuestion({
    required String prompt,
    required String kind,
    required List<String> options,
    int? correctIndex,
    required double points,
  }) = _TeachingQuestionImpl;

  factory TeachingQuestion.fromJson(Map<String, dynamic> jsonSerialization) {
    return TeachingQuestion(
      prompt: jsonSerialization['prompt'] as String,
      kind: jsonSerialization['kind'] as String,
      options: _iwqu1w6v.Protocol().deserialize<List<String>>(
        jsonSerialization['options'],
      ),
      correctIndex: jsonSerialization['correctIndex'] as int?,
      points: (jsonSerialization['points'] as num).toDouble(),
    );
  }

  String prompt;

  String kind;

  List<String> options;

  int? correctIndex;

  double points;

  /// Returns a shallow copy of this [TeachingQuestion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TeachingQuestion copyWith({
    String? prompt,
    String? kind,
    List<String>? options,
    int? correctIndex,
    double? points,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingQuestion',
      'prompt': prompt,
      'kind': kind,
      'options': options.toJson(),
      if (correctIndex != null) 'correctIndex': correctIndex,
      'points': points,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeachingQuestion',
      'prompt': prompt,
      'kind': kind,
      'options': options.toJson(),
      if (correctIndex != null) 'correctIndex': correctIndex,
      'points': points,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeachingQuestionImpl extends TeachingQuestion {
  _TeachingQuestionImpl({
    required String prompt,
    required String kind,
    required List<String> options,
    int? correctIndex,
    required double points,
  }) : super._(
         prompt: prompt,
         kind: kind,
         options: options,
         correctIndex: correctIndex,
         points: points,
       );

  /// Returns a shallow copy of this [TeachingQuestion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TeachingQuestion copyWith({
    String? prompt,
    String? kind,
    List<String>? options,
    Object? correctIndex = _Undefined,
    double? points,
  }) {
    return TeachingQuestion(
      prompt: prompt ?? this.prompt,
      kind: kind ?? this.kind,
      options: options ?? this.options.map((e0) => e0).toList(),
      correctIndex: correctIndex is int? ? correctIndex : this.correctIndex,
      points: points ?? this.points,
    );
  }
}
