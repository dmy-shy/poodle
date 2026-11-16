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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class NotebookCitation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    required _isc.UuidValue chunkId,
    required _isc.UuidValue sourceId,
    required _isc.UuidValue sourceVersionId,
    required int sourceVersion,
    required String title,
    String? locationLabel,
    int? pageNumber,
  }) = _NotebookCitationImpl;

  factory NotebookCitation.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookCitation(
      chunkId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['chunkId'],
      ),
      sourceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['sourceId'],
      ),
      sourceVersionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['sourceVersionId'],
      ),
      sourceVersion: jsonSerialization['sourceVersion'] as int,
      title: jsonSerialization['title'] as String,
      locationLabel: jsonSerialization['locationLabel'] as String?,
      pageNumber: jsonSerialization['pageNumber'] as int?,
    );
  }

  _isc.UuidValue chunkId;

  _isc.UuidValue sourceId;

  _isc.UuidValue sourceVersionId;

  int sourceVersion;

  String title;

  String? locationLabel;

  int? pageNumber;

  /// Returns a shallow copy of this [NotebookCitation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotebookCitation copyWith({
    _isc.UuidValue? chunkId,
    _isc.UuidValue? sourceId,
    _isc.UuidValue? sourceVersionId,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookCitationImpl extends NotebookCitation {
  _NotebookCitationImpl({
    required _isc.UuidValue chunkId,
    required _isc.UuidValue sourceId,
    required _isc.UuidValue sourceVersionId,
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
  @_isc.useResult
  @override
  NotebookCitation copyWith({
    _isc.UuidValue? chunkId,
    _isc.UuidValue? sourceId,
    _isc.UuidValue? sourceVersionId,
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
