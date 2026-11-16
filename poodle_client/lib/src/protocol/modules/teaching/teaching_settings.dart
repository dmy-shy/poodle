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

abstract class TeachingSettings
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TeachingSettings._({
    required this.title,
    required this.instructions,
    this.opensAt,
    this.closesAt,
    double? maxPoints,
    bool? required,
    bool? allowText,
    bool? allowFile,
    int? attemptLimit,
    int? timeLimitMinutes,
    bool? shuffle,
  }) : maxPoints = maxPoints ?? 100.0,
       required = required ?? false,
       allowText = allowText ?? true,
       allowFile = allowFile ?? true,
       attemptLimit = attemptLimit ?? 1,
       timeLimitMinutes = timeLimitMinutes ?? 30,
       shuffle = shuffle ?? false;

  factory TeachingSettings({
    required String title,
    required String instructions,
    DateTime? opensAt,
    DateTime? closesAt,
    double? maxPoints,
    bool? required,
    bool? allowText,
    bool? allowFile,
    int? attemptLimit,
    int? timeLimitMinutes,
    bool? shuffle,
  }) = _TeachingSettingsImpl;

  factory TeachingSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return TeachingSettings(
      title: jsonSerialization['title'] as String,
      instructions: jsonSerialization['instructions'] as String,
      opensAt: jsonSerialization['opensAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['opensAt']),
      closesAt: jsonSerialization['closesAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['closesAt']),
      maxPoints: (jsonSerialization['maxPoints'] as num?)?.toDouble(),
      required: jsonSerialization['required'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['required']),
      allowText: jsonSerialization['allowText'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['allowText']),
      allowFile: jsonSerialization['allowFile'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['allowFile']),
      attemptLimit: jsonSerialization['attemptLimit'] as int?,
      timeLimitMinutes: jsonSerialization['timeLimitMinutes'] as int?,
      shuffle: jsonSerialization['shuffle'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['shuffle']),
    );
  }

  String title;

  String instructions;

  DateTime? opensAt;

  DateTime? closesAt;

  double maxPoints;

  bool required;

  bool allowText;

  bool allowFile;

  int attemptLimit;

  int timeLimitMinutes;

  bool shuffle;

  /// Returns a shallow copy of this [TeachingSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TeachingSettings copyWith({
    String? title,
    String? instructions,
    DateTime? opensAt,
    DateTime? closesAt,
    double? maxPoints,
    bool? required,
    bool? allowText,
    bool? allowFile,
    int? attemptLimit,
    int? timeLimitMinutes,
    bool? shuffle,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingSettings',
      'title': title,
      'instructions': instructions,
      if (opensAt != null) 'opensAt': opensAt?.toJson(),
      if (closesAt != null) 'closesAt': closesAt?.toJson(),
      'maxPoints': maxPoints,
      'required': required,
      'allowText': allowText,
      'allowFile': allowFile,
      'attemptLimit': attemptLimit,
      'timeLimitMinutes': timeLimitMinutes,
      'shuffle': shuffle,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeachingSettings',
      'title': title,
      'instructions': instructions,
      if (opensAt != null) 'opensAt': opensAt?.toJson(),
      if (closesAt != null) 'closesAt': closesAt?.toJson(),
      'maxPoints': maxPoints,
      'required': required,
      'allowText': allowText,
      'allowFile': allowFile,
      'attemptLimit': attemptLimit,
      'timeLimitMinutes': timeLimitMinutes,
      'shuffle': shuffle,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeachingSettingsImpl extends TeachingSettings {
  _TeachingSettingsImpl({
    required String title,
    required String instructions,
    DateTime? opensAt,
    DateTime? closesAt,
    double? maxPoints,
    bool? required,
    bool? allowText,
    bool? allowFile,
    int? attemptLimit,
    int? timeLimitMinutes,
    bool? shuffle,
  }) : super._(
         title: title,
         instructions: instructions,
         opensAt: opensAt,
         closesAt: closesAt,
         maxPoints: maxPoints,
         required: required,
         allowText: allowText,
         allowFile: allowFile,
         attemptLimit: attemptLimit,
         timeLimitMinutes: timeLimitMinutes,
         shuffle: shuffle,
       );

  /// Returns a shallow copy of this [TeachingSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TeachingSettings copyWith({
    String? title,
    String? instructions,
    Object? opensAt = _Undefined,
    Object? closesAt = _Undefined,
    double? maxPoints,
    bool? required,
    bool? allowText,
    bool? allowFile,
    int? attemptLimit,
    int? timeLimitMinutes,
    bool? shuffle,
  }) {
    return TeachingSettings(
      title: title ?? this.title,
      instructions: instructions ?? this.instructions,
      opensAt: opensAt is DateTime? ? opensAt : this.opensAt,
      closesAt: closesAt is DateTime? ? closesAt : this.closesAt,
      maxPoints: maxPoints ?? this.maxPoints,
      required: required ?? this.required,
      allowText: allowText ?? this.allowText,
      allowFile: allowFile ?? this.allowFile,
      attemptLimit: attemptLimit ?? this.attemptLimit,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      shuffle: shuffle ?? this.shuffle,
    );
  }
}
