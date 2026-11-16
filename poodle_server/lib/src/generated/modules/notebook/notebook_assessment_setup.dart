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
import '../../modules/notebook/notebook_assessment_config_view.dart'
    as _ia72cwt6;
import '../../modules/notebook/notebook_material_option.dart' as _i4fc0ib9;

abstract class NotebookAssessmentSetup
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NotebookAssessmentSetup._({
    required this.configuration,
    required this.materials,
  });

  factory NotebookAssessmentSetup({
    required _ia72cwt6.NotebookAssessmentConfigView configuration,
    required List<_i4fc0ib9.NotebookMaterialOption> materials,
  }) = _NotebookAssessmentSetupImpl;

  factory NotebookAssessmentSetup.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookAssessmentSetup(
      configuration: _ikm1kaos.Protocol()
          .deserialize<_ia72cwt6.NotebookAssessmentConfigView>(
            jsonSerialization['configuration'],
          ),
      materials: _ikm1kaos.Protocol()
          .deserialize<List<_i4fc0ib9.NotebookMaterialOption>>(
            jsonSerialization['materials'],
          ),
    );
  }

  _ia72cwt6.NotebookAssessmentConfigView configuration;

  List<_i4fc0ib9.NotebookMaterialOption> materials;

  /// Returns a shallow copy of this [NotebookAssessmentSetup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookAssessmentSetup copyWith({
    _ia72cwt6.NotebookAssessmentConfigView? configuration,
    List<_i4fc0ib9.NotebookMaterialOption>? materials,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookAssessmentSetup',
      'configuration': configuration.toJson(),
      'materials': materials.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookAssessmentSetup',
      'configuration': configuration.toJsonForProtocol(),
      'materials': materials.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _NotebookAssessmentSetupImpl extends NotebookAssessmentSetup {
  _NotebookAssessmentSetupImpl({
    required _ia72cwt6.NotebookAssessmentConfigView configuration,
    required List<_i4fc0ib9.NotebookMaterialOption> materials,
  }) : super._(
         configuration: configuration,
         materials: materials,
       );

  /// Returns a shallow copy of this [NotebookAssessmentSetup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookAssessmentSetup copyWith({
    _ia72cwt6.NotebookAssessmentConfigView? configuration,
    List<_i4fc0ib9.NotebookMaterialOption>? materials,
  }) {
    return NotebookAssessmentSetup(
      configuration: configuration ?? this.configuration.copyWith(),
      materials:
          materials ?? this.materials.map((e0) => e0.copyWith()).toList(),
    );
  }
}
