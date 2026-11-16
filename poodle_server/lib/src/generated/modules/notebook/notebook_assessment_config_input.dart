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

abstract class NotebookAssessmentConfigInput
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NotebookAssessmentConfigInput._({
    required this.courseId,
    required this.assessmentActivityId,
    required this.expectedRevision,
    required this.defaultMaterialActivityIds,
    required this.allowedFormats,
  });

  factory NotebookAssessmentConfigInput({
    required _is.UuidValue courseId,
    required _is.UuidValue assessmentActivityId,
    required int expectedRevision,
    required List<_is.UuidValue> defaultMaterialActivityIds,
    required List<String> allowedFormats,
  }) = _NotebookAssessmentConfigInputImpl;

  factory NotebookAssessmentConfigInput.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookAssessmentConfigInput(
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      assessmentActivityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['assessmentActivityId'],
      ),
      expectedRevision: jsonSerialization['expectedRevision'] as int,
      defaultMaterialActivityIds: _ikm1kaos.Protocol()
          .deserialize<List<_is.UuidValue>>(
            jsonSerialization['defaultMaterialActivityIds'],
          ),
      allowedFormats: _ikm1kaos.Protocol().deserialize<List<String>>(
        jsonSerialization['allowedFormats'],
      ),
    );
  }

  _is.UuidValue courseId;

  _is.UuidValue assessmentActivityId;

  int expectedRevision;

  List<_is.UuidValue> defaultMaterialActivityIds;

  List<String> allowedFormats;

  /// Returns a shallow copy of this [NotebookAssessmentConfigInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookAssessmentConfigInput copyWith({
    _is.UuidValue? courseId,
    _is.UuidValue? assessmentActivityId,
    int? expectedRevision,
    List<_is.UuidValue>? defaultMaterialActivityIds,
    List<String>? allowedFormats,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookAssessmentConfigInput',
      'courseId': courseId.toJson(),
      'assessmentActivityId': assessmentActivityId.toJson(),
      'expectedRevision': expectedRevision,
      'defaultMaterialActivityIds': defaultMaterialActivityIds.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'allowedFormats': allowedFormats.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookAssessmentConfigInput',
      'courseId': courseId.toJson(),
      'assessmentActivityId': assessmentActivityId.toJson(),
      'expectedRevision': expectedRevision,
      'defaultMaterialActivityIds': defaultMaterialActivityIds.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'allowedFormats': allowedFormats.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _NotebookAssessmentConfigInputImpl extends NotebookAssessmentConfigInput {
  _NotebookAssessmentConfigInputImpl({
    required _is.UuidValue courseId,
    required _is.UuidValue assessmentActivityId,
    required int expectedRevision,
    required List<_is.UuidValue> defaultMaterialActivityIds,
    required List<String> allowedFormats,
  }) : super._(
         courseId: courseId,
         assessmentActivityId: assessmentActivityId,
         expectedRevision: expectedRevision,
         defaultMaterialActivityIds: defaultMaterialActivityIds,
         allowedFormats: allowedFormats,
       );

  /// Returns a shallow copy of this [NotebookAssessmentConfigInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookAssessmentConfigInput copyWith({
    _is.UuidValue? courseId,
    _is.UuidValue? assessmentActivityId,
    int? expectedRevision,
    List<_is.UuidValue>? defaultMaterialActivityIds,
    List<String>? allowedFormats,
  }) {
    return NotebookAssessmentConfigInput(
      courseId: courseId ?? this.courseId,
      assessmentActivityId: assessmentActivityId ?? this.assessmentActivityId,
      expectedRevision: expectedRevision ?? this.expectedRevision,
      defaultMaterialActivityIds:
          defaultMaterialActivityIds ??
          this.defaultMaterialActivityIds.map((e0) => e0).toList(),
      allowedFormats:
          allowedFormats ?? this.allowedFormats.map((e0) => e0).toList(),
    );
  }
}
