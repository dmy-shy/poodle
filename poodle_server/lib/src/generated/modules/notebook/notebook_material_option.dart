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
import 'package:serverpod/serverpod.dart' as _is;

abstract class NotebookMaterialOption
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NotebookMaterialOption._({
    required this.id,
    required this.title,
    required this.format,
  });

  factory NotebookMaterialOption({
    required _is.UuidValue id,
    required String title,
    required String format,
  }) = _NotebookMaterialOptionImpl;

  factory NotebookMaterialOption.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookMaterialOption(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      title: jsonSerialization['title'] as String,
      format: jsonSerialization['format'] as String,
    );
  }

  _is.UuidValue id;

  String title;

  String format;

  /// Returns a shallow copy of this [NotebookMaterialOption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookMaterialOption copyWith({
    _is.UuidValue? id,
    String? title,
    String? format,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookMaterialOption',
      'id': id.toJson(),
      'title': title,
      'format': format,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookMaterialOption',
      'id': id.toJson(),
      'title': title,
      'format': format,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _NotebookMaterialOptionImpl extends NotebookMaterialOption {
  _NotebookMaterialOptionImpl({
    required _is.UuidValue id,
    required String title,
    required String format,
  }) : super._(
         id: id,
         title: title,
         format: format,
       );

  /// Returns a shallow copy of this [NotebookMaterialOption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookMaterialOption copyWith({
    _is.UuidValue? id,
    String? title,
    String? format,
  }) {
    return NotebookMaterialOption(
      id: id ?? this.id,
      title: title ?? this.title,
      format: format ?? this.format,
    );
  }
}
