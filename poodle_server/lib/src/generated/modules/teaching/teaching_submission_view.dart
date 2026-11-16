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

abstract class TeachingSubmissionView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TeachingSubmissionView._({
    required this.id,
    required this.ownerId,
    required this.ownerLabel,
    required this.text,
    this.fileName,
    required this.submittedAt,
    this.reopenUntil,
    required this.underReview,
    this.grade,
    this.feedback,
    required this.published,
  });

  factory TeachingSubmissionView({
    required _is.UuidValue id,
    required _is.UuidValue ownerId,
    required String ownerLabel,
    required String text,
    String? fileName,
    required DateTime submittedAt,
    DateTime? reopenUntil,
    required bool underReview,
    double? grade,
    String? feedback,
    required bool published,
  }) = _TeachingSubmissionViewImpl;

  factory TeachingSubmissionView.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeachingSubmissionView(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      ownerLabel: jsonSerialization['ownerLabel'] as String,
      text: jsonSerialization['text'] as String,
      fileName: jsonSerialization['fileName'] as String?,
      submittedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['submittedAt'],
      ),
      reopenUntil: jsonSerialization['reopenUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['reopenUntil'],
            ),
      underReview: _is.BoolJsonExtension.fromJson(
        jsonSerialization['underReview'],
      ),
      grade: (jsonSerialization['grade'] as num?)?.toDouble(),
      feedback: jsonSerialization['feedback'] as String?,
      published: _is.BoolJsonExtension.fromJson(jsonSerialization['published']),
    );
  }

  _is.UuidValue id;

  _is.UuidValue ownerId;

  String ownerLabel;

  String text;

  String? fileName;

  DateTime submittedAt;

  DateTime? reopenUntil;

  bool underReview;

  double? grade;

  String? feedback;

  bool published;

  /// Returns a shallow copy of this [TeachingSubmissionView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeachingSubmissionView copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    String? ownerLabel,
    String? text,
    String? fileName,
    DateTime? submittedAt,
    DateTime? reopenUntil,
    bool? underReview,
    double? grade,
    String? feedback,
    bool? published,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingSubmissionView',
      'id': id.toJson(),
      'ownerId': ownerId.toJson(),
      'ownerLabel': ownerLabel,
      'text': text,
      if (fileName != null) 'fileName': fileName,
      'submittedAt': submittedAt.toJson(),
      if (reopenUntil != null) 'reopenUntil': reopenUntil?.toJson(),
      'underReview': underReview,
      if (grade != null) 'grade': grade,
      if (feedback != null) 'feedback': feedback,
      'published': published,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeachingSubmissionView',
      'id': id.toJson(),
      'ownerId': ownerId.toJson(),
      'ownerLabel': ownerLabel,
      'text': text,
      if (fileName != null) 'fileName': fileName,
      'submittedAt': submittedAt.toJson(),
      if (reopenUntil != null) 'reopenUntil': reopenUntil?.toJson(),
      'underReview': underReview,
      if (grade != null) 'grade': grade,
      if (feedback != null) 'feedback': feedback,
      'published': published,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeachingSubmissionViewImpl extends TeachingSubmissionView {
  _TeachingSubmissionViewImpl({
    required _is.UuidValue id,
    required _is.UuidValue ownerId,
    required String ownerLabel,
    required String text,
    String? fileName,
    required DateTime submittedAt,
    DateTime? reopenUntil,
    required bool underReview,
    double? grade,
    String? feedback,
    required bool published,
  }) : super._(
         id: id,
         ownerId: ownerId,
         ownerLabel: ownerLabel,
         text: text,
         fileName: fileName,
         submittedAt: submittedAt,
         reopenUntil: reopenUntil,
         underReview: underReview,
         grade: grade,
         feedback: feedback,
         published: published,
       );

  /// Returns a shallow copy of this [TeachingSubmissionView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeachingSubmissionView copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    String? ownerLabel,
    String? text,
    Object? fileName = _Undefined,
    DateTime? submittedAt,
    Object? reopenUntil = _Undefined,
    bool? underReview,
    Object? grade = _Undefined,
    Object? feedback = _Undefined,
    bool? published,
  }) {
    return TeachingSubmissionView(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerLabel: ownerLabel ?? this.ownerLabel,
      text: text ?? this.text,
      fileName: fileName is String? ? fileName : this.fileName,
      submittedAt: submittedAt ?? this.submittedAt,
      reopenUntil: reopenUntil is DateTime? ? reopenUntil : this.reopenUntil,
      underReview: underReview ?? this.underReview,
      grade: grade is double? ? grade : this.grade,
      feedback: feedback is String? ? feedback : this.feedback,
      published: published ?? this.published,
    );
  }
}
