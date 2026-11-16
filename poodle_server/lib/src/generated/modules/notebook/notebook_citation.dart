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

abstract class NotebookCitation
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NotebookCitation._({
    required this.chunkId,
    required this.sourceId,
    required this.sourceVersionId,
    required this.sourceVersion,
    required this.title,
    this.locationLabel,
    this.pageNumber,
  });

  factory NotebookCitation({
    required _is.UuidValue chunkId,
    required _is.UuidValue sourceId,
    required _is.UuidValue sourceVersionId,
    required int sourceVersion,
    required String title,
    String? locationLabel,
    int? pageNumber,
  }) = _NotebookCitationImpl;

  factory NotebookCitation.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookCitation(
      chunkId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['chunkId'],
      ),
      sourceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sourceId'],
      ),
      sourceVersionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sourceVersionId'],
      ),
      sourceVersion: jsonSerialization['sourceVersion'] as int,
      title: jsonSerialization['title'] as String,
      locationLabel: jsonSerialization['locationLabel'] as String?,
      pageNumber: jsonSerialization['pageNumber'] as int?,
    );
  }

  _is.UuidValue chunkId;

  _is.UuidValue sourceId;

  _is.UuidValue sourceVersionId;

  int sourceVersion;

  String title;

  String? locationLabel;

  int? pageNumber;

  /// Returns a shallow copy of this [NotebookCitation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookCitation copyWith({
    _is.UuidValue? chunkId,
    _is.UuidValue? sourceId,
    _is.UuidValue? sourceVersionId,
    int? sourceVersion,
    String? title,
    String? locationLabel,
    int? pageNumber,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookCitation',
      'chunkId': chunkId.toJson(),
      'sourceId': sourceId.toJson(),
      'sourceVersionId': sourceVersionId.toJson(),
      'sourceVersion': sourceVersion,
      'title': title,
      if (locationLabel != null) 'locationLabel': locationLabel,
      if (pageNumber != null) 'pageNumber': pageNumber,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotebookCitation',
      'chunkId': chunkId.toJson(),
      'sourceId': sourceId.toJson(),
      'sourceVersionId': sourceVersionId.toJson(),
      'sourceVersion': sourceVersion,
      'title': title,
      if (locationLabel != null) 'locationLabel': locationLabel,
      if (pageNumber != null) 'pageNumber': pageNumber,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookCitationImpl extends NotebookCitation {
  _NotebookCitationImpl({
    required _is.UuidValue chunkId,
    required _is.UuidValue sourceId,
    required _is.UuidValue sourceVersionId,
    required int sourceVersion,
    required String title,
    String? locationLabel,
    int? pageNumber,
  }) : super._(
         chunkId: chunkId,
         sourceId: sourceId,
         sourceVersionId: sourceVersionId,
         sourceVersion: sourceVersion,
         title: title,
         locationLabel: locationLabel,
         pageNumber: pageNumber,
       );

  /// Returns a shallow copy of this [NotebookCitation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookCitation copyWith({
    _is.UuidValue? chunkId,
    _is.UuidValue? sourceId,
    _is.UuidValue? sourceVersionId,
    int? sourceVersion,
    String? title,
    Object? locationLabel = _Undefined,
    Object? pageNumber = _Undefined,
  }) {
    return NotebookCitation(
      chunkId: chunkId ?? this.chunkId,
      sourceId: sourceId ?? this.sourceId,
      sourceVersionId: sourceVersionId ?? this.sourceVersionId,
      sourceVersion: sourceVersion ?? this.sourceVersion,
      title: title ?? this.title,
      locationLabel: locationLabel is String?
          ? locationLabel
          : this.locationLabel,
      pageNumber: pageNumber is int? ? pageNumber : this.pageNumber,
    );
  }
}
