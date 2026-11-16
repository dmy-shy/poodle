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

abstract class NotebookAssessmentConfigView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NotebookAssessmentConfigView._({
    required this.courseId,
    required this.assessmentActivityId,
    required this.revision,
    required this.defaultMaterialActivityIds,
    required this.allowedFormats,
  });

  factory NotebookAssessmentConfigView({
    required _is.UuidValue courseId,
    required _is.UuidValue assessmentActivityId,
    required int revision,
    required List<_is.UuidValue> defaultMaterialActivityIds,
    required List<String> allowedFormats,
  }) = _NotebookAssessmentConfigViewImpl;

  factory NotebookAssessmentConfigView.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookAssessmentConfigView(
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      assessmentActivityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['assessmentActivityId'],
      ),
      revision: jsonSerialization['revision'] as int,
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

  int revision;

  List<_is.UuidValue> defaultMaterialActivityIds;

  List<String> allowedFormats;

  /// Returns a shallow copy of this [NotebookAssessmentConfigView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookAssessmentConfigView copyWith({
    _is.UuidValue? courseId,
    _is.UuidValue? assessmentActivityId,
    int? revision,
    List<_is.UuidValue>? defaultMaterialActivityIds,
    List<String>? allowedFormats,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookAssessmentConfigView',
      'courseId': courseId.toJson(),
      'assessmentActivityId': assessmentActivityId.toJson(),
      'revision': revision,
      'defaultMaterialActivityIds': defaultMaterialActivityIds.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'allowedFormats': allowedFormats.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookAssessmentConfigView',
      'courseId': courseId.toJson(),
      'assessmentActivityId': assessmentActivityId.toJson(),
      'revision': revision,
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

class _NotebookAssessmentConfigViewImpl extends NotebookAssessmentConfigView {
  _NotebookAssessmentConfigViewImpl({
    required _is.UuidValue courseId,
    required _is.UuidValue assessmentActivityId,
    required int revision,
    required List<_is.UuidValue> defaultMaterialActivityIds,
    required List<String> allowedFormats,
  }) : super._(
         courseId: courseId,
         assessmentActivityId: assessmentActivityId,
         revision: revision,
         defaultMaterialActivityIds: defaultMaterialActivityIds,
         allowedFormats: allowedFormats,
       );

  /// Returns a shallow copy of this [NotebookAssessmentConfigView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookAssessmentConfigView copyWith({
    _is.UuidValue? courseId,
    _is.UuidValue? assessmentActivityId,
    int? revision,
    List<_is.UuidValue>? defaultMaterialActivityIds,
    List<String>? allowedFormats,
  }) {
    return NotebookAssessmentConfigView(
      courseId: courseId ?? this.courseId,
      assessmentActivityId: assessmentActivityId ?? this.assessmentActivityId,
      revision: revision ?? this.revision,
      defaultMaterialActivityIds:
          defaultMaterialActivityIds ??
          this.defaultMaterialActivityIds.map((e0) => e0).toList(),
      allowedFormats:
          allowedFormats ?? this.allowedFormats.map((e0) => e0).toList(),
    );
  }
}
