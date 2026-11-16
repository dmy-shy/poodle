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

abstract class NotebookAssessmentConfigView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NotebookAssessmentConfigView._({
    required this.courseId,
    required this.assessmentActivityId,
    required this.revision,
    required this.defaultMaterialActivityIds,
    required this.allowedFormats,
  });

  factory NotebookAssessmentConfigView({
    required _isc.UuidValue courseId,
    required _isc.UuidValue assessmentActivityId,
    required int revision,
    required List<_isc.UuidValue> defaultMaterialActivityIds,
    required List<String> allowedFormats,
  }) = _NotebookAssessmentConfigViewImpl;

  factory NotebookAssessmentConfigView.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookAssessmentConfigView(
      courseId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      assessmentActivityId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['assessmentActivityId'],
      ),
      revision: jsonSerialization['revision'] as int,
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

  int revision;

  List<_isc.UuidValue> defaultMaterialActivityIds;

  List<String> allowedFormats;

  /// Returns a shallow copy of this [NotebookAssessmentConfigView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotebookAssessmentConfigView copyWith({
    _isc.UuidValue? courseId,
    _isc.UuidValue? assessmentActivityId,
    int? revision,
    List<_isc.UuidValue>? defaultMaterialActivityIds,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _NotebookAssessmentConfigViewImpl extends NotebookAssessmentConfigView {
  _NotebookAssessmentConfigViewImpl({
    required _isc.UuidValue courseId,
    required _isc.UuidValue assessmentActivityId,
    required int revision,
    required List<_isc.UuidValue> defaultMaterialActivityIds,
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
  @_isc.useResult
  @override
  NotebookAssessmentConfigView copyWith({
    _isc.UuidValue? courseId,
    _isc.UuidValue? assessmentActivityId,
    int? revision,
    List<_isc.UuidValue>? defaultMaterialActivityIds,
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
