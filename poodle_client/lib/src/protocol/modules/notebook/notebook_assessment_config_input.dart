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

abstract class NotebookAssessmentConfigInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NotebookAssessmentConfigInput._({
    required this.courseId,
    required this.assessmentActivityId,
    required this.expectedRevision,
    required this.defaultMaterialActivityIds,
    required this.allowedFormats,
  });

  factory NotebookAssessmentConfigInput({
    required _isc.UuidValue courseId,
    required _isc.UuidValue assessmentActivityId,
    required int expectedRevision,
    required List<_isc.UuidValue> defaultMaterialActivityIds,
    required List<String> allowedFormats,
  }) = _NotebookAssessmentConfigInputImpl;

  factory NotebookAssessmentConfigInput.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookAssessmentConfigInput(
      courseId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      assessmentActivityId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['assessmentActivityId'],
      ),
      expectedRevision: jsonSerialization['expectedRevision'] as int,
      defaultMaterialActivityIds: _iwqu1w6v.Protocol()
          .deserialize<List<_isc.UuidValue>>(
            jsonSerialization['defaultMaterialActivityIds'],
          ),
      allowedFormats: _iwqu1w6v.Protocol().deserialize<List<String>>(
        jsonSerialization['allowedFormats'],
      ),
    );
  }

  _isc.UuidValue courseId;

  _isc.UuidValue assessmentActivityId;

  int expectedRevision;

  List<_isc.UuidValue> defaultMaterialActivityIds;

  List<String> allowedFormats;

  /// Returns a shallow copy of this [NotebookAssessmentConfigInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotebookAssessmentConfigInput copyWith({
    _isc.UuidValue? courseId,
    _isc.UuidValue? assessmentActivityId,
    int? expectedRevision,
    List<_isc.UuidValue>? defaultMaterialActivityIds,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _NotebookAssessmentConfigInputImpl extends NotebookAssessmentConfigInput {
  _NotebookAssessmentConfigInputImpl({
    required _isc.UuidValue courseId,
    required _isc.UuidValue assessmentActivityId,
    required int expectedRevision,
    required List<_isc.UuidValue> defaultMaterialActivityIds,
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
  @_isc.useResult
  @override
  NotebookAssessmentConfigInput copyWith({
    _isc.UuidValue? courseId,
    _isc.UuidValue? assessmentActivityId,
    int? expectedRevision,
    List<_isc.UuidValue>? defaultMaterialActivityIds,
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
