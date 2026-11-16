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
import '../../modules/notebook/notebook_source_info.dart' as _i454qtqu;

abstract class NotebookOverview
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NotebookOverview._({
    this.notebookId,
    required this.courseId,
    required this.assessmentActivityId,
    required this.configured,
    required this.configRevision,
    required this.allowedFormats,
    required this.sources,
  });

  factory NotebookOverview({
    _is.UuidValue? notebookId,
    required _is.UuidValue courseId,
    required _is.UuidValue assessmentActivityId,
    required bool configured,
    required int configRevision,
    required List<String> allowedFormats,
    required List<_i454qtqu.NotebookSourceInfo> sources,
  }) = _NotebookOverviewImpl;

  factory NotebookOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookOverview(
      notebookId: jsonSerialization['notebookId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['notebookId'],
            ),
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      assessmentActivityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['assessmentActivityId'],
      ),
      configured: _is.BoolJsonExtension.fromJson(
        jsonSerialization['configured'],
      ),
      configRevision: jsonSerialization['configRevision'] as int,
      allowedFormats: _ikm1kaos.Protocol().deserialize<List<String>>(
        jsonSerialization['allowedFormats'],
      ),
      sources: _ikm1kaos.Protocol()
          .deserialize<List<_i454qtqu.NotebookSourceInfo>>(
            jsonSerialization['sources'],
          ),
    );
  }

  _is.UuidValue? notebookId;

  _is.UuidValue courseId;

  _is.UuidValue assessmentActivityId;

  bool configured;

  int configRevision;

  List<String> allowedFormats;

  List<_i454qtqu.NotebookSourceInfo> sources;

  /// Returns a shallow copy of this [NotebookOverview]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookOverview copyWith({
    _is.UuidValue? notebookId,
    _is.UuidValue? courseId,
    _is.UuidValue? assessmentActivityId,
    bool? configured,
    int? configRevision,
    List<String>? allowedFormats,
    List<_i454qtqu.NotebookSourceInfo>? sources,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookOverview',
      if (notebookId != null) 'notebookId': notebookId?.toJson(),
      'courseId': courseId.toJson(),
      'assessmentActivityId': assessmentActivityId.toJson(),
      'configured': configured,
      'configRevision': configRevision,
      'allowedFormats': allowedFormats.toJson(),
      'sources': sources.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookOverview',
      if (notebookId != null) 'notebookId': notebookId?.toJson(),
      'courseId': courseId.toJson(),
      'assessmentActivityId': assessmentActivityId.toJson(),
      'configured': configured,
      'configRevision': configRevision,
      'allowedFormats': allowedFormats.toJson(),
      'sources': sources.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookOverviewImpl extends NotebookOverview {
  _NotebookOverviewImpl({
    _is.UuidValue? notebookId,
    required _is.UuidValue courseId,
    required _is.UuidValue assessmentActivityId,
    required bool configured,
    required int configRevision,
    required List<String> allowedFormats,
    required List<_i454qtqu.NotebookSourceInfo> sources,
  }) : super._(
         notebookId: notebookId,
         courseId: courseId,
         assessmentActivityId: assessmentActivityId,
         configured: configured,
         configRevision: configRevision,
         allowedFormats: allowedFormats,
         sources: sources,
       );

  /// Returns a shallow copy of this [NotebookOverview]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookOverview copyWith({
    Object? notebookId = _Undefined,
    _is.UuidValue? courseId,
    _is.UuidValue? assessmentActivityId,
    bool? configured,
    int? configRevision,
    List<String>? allowedFormats,
    List<_i454qtqu.NotebookSourceInfo>? sources,
  }) {
    return NotebookOverview(
      notebookId: notebookId is _is.UuidValue? ? notebookId : this.notebookId,
      courseId: courseId ?? this.courseId,
      assessmentActivityId: assessmentActivityId ?? this.assessmentActivityId,
      configured: configured ?? this.configured,
      configRevision: configRevision ?? this.configRevision,
      allowedFormats:
          allowedFormats ?? this.allowedFormats.map((e0) => e0).toList(),
      sources: sources ?? this.sources.map((e0) => e0.copyWith()).toList(),
    );
  }
}
