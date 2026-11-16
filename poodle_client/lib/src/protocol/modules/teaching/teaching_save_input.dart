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
import '../../modules/teaching/teaching_settings.dart' as _i9l8jupr;

abstract class TeachingSaveInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TeachingSaveInput._({
    required this.courseId,
    required this.sectionId,
    required this.activityId,
    required this.kind,
    required this.expectedRevision,
    required this.publish,
    required this.settings,
    required this.questions,
  });

  factory TeachingSaveInput({
    required _isc.UuidValue courseId,
    required _isc.UuidValue sectionId,
    required _isc.UuidValue activityId,
    required String kind,
    required int expectedRevision,
    required bool publish,
    required _i9l8jupr.TeachingSettings settings,
    required List<_i3iex35i.TeachingQuestion> questions,
  }) = _TeachingSaveInputImpl;

  factory TeachingSaveInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return TeachingSaveInput(
      courseId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      sectionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['sectionId'],
      ),
      activityId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['activityId'],
      ),
      kind: jsonSerialization['kind'] as String,
      expectedRevision: jsonSerialization['expectedRevision'] as int,
      publish: _isc.BoolJsonExtension.fromJson(jsonSerialization['publish']),
      settings: _iwqu1w6v.Protocol().deserialize<_i9l8jupr.TeachingSettings>(
        jsonSerialization['settings'],
      ),
      questions: _iwqu1w6v.Protocol()
          .deserialize<List<_i3iex35i.TeachingQuestion>>(
            jsonSerialization['questions'],
          ),
    );
  }

  _isc.UuidValue courseId;

  _isc.UuidValue sectionId;

  _isc.UuidValue activityId;

  String kind;

  int expectedRevision;

  bool publish;

  _i9l8jupr.TeachingSettings settings;

  List<_i3iex35i.TeachingQuestion> questions;

  /// Returns a shallow copy of this [TeachingSaveInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TeachingSaveInput copyWith({
    _isc.UuidValue? courseId,
    _isc.UuidValue? sectionId,
    _isc.UuidValue? activityId,
    String? kind,
    int? expectedRevision,
    bool? publish,
    _i9l8jupr.TeachingSettings? settings,
    List<_i3iex35i.TeachingQuestion>? questions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingSaveInput',
      'courseId': courseId.toJson(),
      'sectionId': sectionId.toJson(),
      'activityId': activityId.toJson(),
      'kind': kind,
      'expectedRevision': expectedRevision,
      'publish': publish,
      'settings': settings.toJson(),
      'questions': questions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeachingSaveInput',
      'courseId': courseId.toJson(),
      'sectionId': sectionId.toJson(),
      'activityId': activityId.toJson(),
      'kind': kind,
      'expectedRevision': expectedRevision,
      'publish': publish,
      'settings': settings.toJsonForProtocol(),
      'questions': questions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TeachingSaveInputImpl extends TeachingSaveInput {
  _TeachingSaveInputImpl({
    required _isc.UuidValue courseId,
    required _isc.UuidValue sectionId,
    required _isc.UuidValue activityId,
    required String kind,
    required int expectedRevision,
    required bool publish,
    required _i9l8jupr.TeachingSettings settings,
    required List<_i3iex35i.TeachingQuestion> questions,
  }) : super._(
         courseId: courseId,
         sectionId: sectionId,
         activityId: activityId,
         kind: kind,
         expectedRevision: expectedRevision,
         publish: publish,
         settings: settings,
         questions: questions,
       );

  /// Returns a shallow copy of this [TeachingSaveInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TeachingSaveInput copyWith({
    _isc.UuidValue? courseId,
    _isc.UuidValue? sectionId,
    _isc.UuidValue? activityId,
    String? kind,
    int? expectedRevision,
    bool? publish,
    _i9l8jupr.TeachingSettings? settings,
    List<_i3iex35i.TeachingQuestion>? questions,
  }) {
    return TeachingSaveInput(
      courseId: courseId ?? this.courseId,
      sectionId: sectionId ?? this.sectionId,
      activityId: activityId ?? this.activityId,
      kind: kind ?? this.kind,
      expectedRevision: expectedRevision ?? this.expectedRevision,
      publish: publish ?? this.publish,
      settings: settings ?? this.settings.copyWith(),
      questions:
          questions ?? this.questions.map((e0) => e0.copyWith()).toList(),
    );
  }
}
