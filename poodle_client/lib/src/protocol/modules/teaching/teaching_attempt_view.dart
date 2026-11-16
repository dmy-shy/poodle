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
import '../../modules/teaching/teaching_question.dart' as _i3iex35i;

abstract class TeachingAttemptView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TeachingAttemptView._({
    required this.id,
    required this.ownerId,
    required this.ownerLabel,
    required this.revision,
    required this.questions,
    required this.answers,
    required this.expiresAt,
    this.submittedAt,
    this.score,
    required this.maxPoints,
  });

  factory TeachingAttemptView({
    required _isc.UuidValue id,
    required _isc.UuidValue ownerId,
    required String ownerLabel,
    required int revision,
    required List<_i3iex35i.TeachingQuestion> questions,
    required List<int> answers,
    required DateTime expiresAt,
    DateTime? submittedAt,
    double? score,
    required double maxPoints,
  }) = _TeachingAttemptViewImpl;

  factory TeachingAttemptView.fromJson(Map<String, dynamic> jsonSerialization) {
    return TeachingAttemptView(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      ownerLabel: jsonSerialization['ownerLabel'] as String,
      revision: jsonSerialization['revision'] as int,
      questions: _iwqu1w6v.Protocol()
          .deserialize<List<_i3iex35i.TeachingQuestion>>(
            jsonSerialization['questions'],
          ),
      answers: _iwqu1w6v.Protocol().deserialize<List<int>>(
        jsonSerialization['answers'],
      ),
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      submittedAt: jsonSerialization['submittedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['submittedAt'],
            ),
      score: (jsonSerialization['score'] as num?)?.toDouble(),
      maxPoints: (jsonSerialization['maxPoints'] as num).toDouble(),
    );
  }

  _isc.UuidValue id;

  _isc.UuidValue ownerId;

  String ownerLabel;

  int revision;

  List<_i3iex35i.TeachingQuestion> questions;

  List<int> answers;

  DateTime expiresAt;

  DateTime? submittedAt;

  double? score;

  double maxPoints;

  /// Returns a shallow copy of this [TeachingAttemptView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TeachingAttemptView copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    String? ownerLabel,
    int? revision,
    List<_i3iex35i.TeachingQuestion>? questions,
    List<int>? answers,
    DateTime? expiresAt,
    DateTime? submittedAt,
    double? score,
    double? maxPoints,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingAttemptView',
      'id': id.toJson(),
      'ownerId': ownerId.toJson(),
      'ownerLabel': ownerLabel,
      'revision': revision,
      'questions': questions.toJson(valueToJson: (v) => v.toJson()),
      'answers': answers.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (submittedAt != null) 'submittedAt': submittedAt?.toJson(),
      if (score != null) 'score': score,
      'maxPoints': maxPoints,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeachingAttemptView',
      'id': id.toJson(),
      'ownerId': ownerId.toJson(),
      'ownerLabel': ownerLabel,
      'revision': revision,
      'questions': questions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'answers': answers.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (submittedAt != null) 'submittedAt': submittedAt?.toJson(),
      if (score != null) 'score': score,
      'maxPoints': maxPoints,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeachingAttemptViewImpl extends TeachingAttemptView {
  _TeachingAttemptViewImpl({
    required _isc.UuidValue id,
    required _isc.UuidValue ownerId,
    required String ownerLabel,
    required int revision,
    required List<_i3iex35i.TeachingQuestion> questions,
    required List<int> answers,
    required DateTime expiresAt,
    DateTime? submittedAt,
    double? score,
    required double maxPoints,
  }) : super._(
         id: id,
         ownerId: ownerId,
         ownerLabel: ownerLabel,
         revision: revision,
         questions: questions,
         answers: answers,
         expiresAt: expiresAt,
         submittedAt: submittedAt,
         score: score,
         maxPoints: maxPoints,
       );

  /// Returns a shallow copy of this [TeachingAttemptView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TeachingAttemptView copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ownerId,
    String? ownerLabel,
    int? revision,
    List<_i3iex35i.TeachingQuestion>? questions,
    List<int>? answers,
    DateTime? expiresAt,
    Object? submittedAt = _Undefined,
    Object? score = _Undefined,
    double? maxPoints,
  }) {
    return TeachingAttemptView(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerLabel: ownerLabel ?? this.ownerLabel,
      revision: revision ?? this.revision,
      questions:
          questions ?? this.questions.map((e0) => e0.copyWith()).toList(),
      answers: answers ?? this.answers.map((e0) => e0).toList(),
      expiresAt: expiresAt ?? this.expiresAt,
      submittedAt: submittedAt is DateTime? ? submittedAt : this.submittedAt,
      score: score is double? ? score : this.score,
      maxPoints: maxPoints ?? this.maxPoints,
    );
  }
}
