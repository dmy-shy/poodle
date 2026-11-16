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
import '../../modules/teaching/teaching_attempt_view.dart' as _io973fkd;
import '../../modules/teaching/teaching_question.dart' as _i3iex35i;
import '../../modules/teaching/teaching_settings.dart' as _i9l8jupr;
import '../../modules/teaching/teaching_submission_view.dart' as _iio2boad;

abstract class TeachingActivityView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TeachingActivityView._({
    required this.activityId,
    required this.courseId,
    required this.sectionId,
    required this.kind,
    required this.revision,
    required this.published,
    required this.released,
    required this.teacher,
    required this.settings,
    required this.questions,
    required this.submissions,
    required this.attempts,
    required this.serverTime,
  });

  factory TeachingActivityView({
    required _isc.UuidValue activityId,
    required _isc.UuidValue courseId,
    required _isc.UuidValue sectionId,
    required String kind,
    required int revision,
    required bool published,
    required bool released,
    required bool teacher,
    required _i9l8jupr.TeachingSettings settings,
    required List<_i3iex35i.TeachingQuestion> questions,
    required List<_iio2boad.TeachingSubmissionView> submissions,
    required List<_io973fkd.TeachingAttemptView> attempts,
    required DateTime serverTime,
  }) = _TeachingActivityViewImpl;

  factory TeachingActivityView.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeachingActivityView(
      activityId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['activityId'],
      ),
      courseId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      sectionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['sectionId'],
      ),
      kind: jsonSerialization['kind'] as String,
      revision: jsonSerialization['revision'] as int,
      published: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['published'],
      ),
      released: _isc.BoolJsonExtension.fromJson(jsonSerialization['released']),
      teacher: _isc.BoolJsonExtension.fromJson(jsonSerialization['teacher']),
      settings: _iwqu1w6v.Protocol().deserialize<_i9l8jupr.TeachingSettings>(
        jsonSerialization['settings'],
      ),
      questions: _iwqu1w6v.Protocol()
          .deserialize<List<_i3iex35i.TeachingQuestion>>(
            jsonSerialization['questions'],
          ),
      submissions: _iwqu1w6v.Protocol()
          .deserialize<List<_iio2boad.TeachingSubmissionView>>(
            jsonSerialization['submissions'],
          ),
      attempts: _iwqu1w6v.Protocol()
          .deserialize<List<_io973fkd.TeachingAttemptView>>(
            jsonSerialization['attempts'],
          ),
      serverTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
    );
  }

  _isc.UuidValue activityId;

  _isc.UuidValue courseId;

  _isc.UuidValue sectionId;

  String kind;

  int revision;

  bool published;

  bool released;

  bool teacher;

  _i9l8jupr.TeachingSettings settings;

  List<_i3iex35i.TeachingQuestion> questions;

  List<_iio2boad.TeachingSubmissionView> submissions;

  List<_io973fkd.TeachingAttemptView> attempts;

  DateTime serverTime;

  /// Returns a shallow copy of this [TeachingActivityView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TeachingActivityView copyWith({
    _isc.UuidValue? activityId,
    _isc.UuidValue? courseId,
    _isc.UuidValue? sectionId,
    String? kind,
    int? revision,
    bool? published,
    bool? released,
    bool? teacher,
    _i9l8jupr.TeachingSettings? settings,
    List<_i3iex35i.TeachingQuestion>? questions,
    List<_iio2boad.TeachingSubmissionView>? submissions,
    List<_io973fkd.TeachingAttemptView>? attempts,
    DateTime? serverTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingActivityView',
      'activityId': activityId.toJson(),
      'courseId': courseId.toJson(),
      'sectionId': sectionId.toJson(),
      'kind': kind,
      'revision': revision,
      'published': published,
      'released': released,
      'teacher': teacher,
      'settings': settings.toJson(),
      'questions': questions.toJson(valueToJson: (v) => v.toJson()),
      'submissions': submissions.toJson(valueToJson: (v) => v.toJson()),
      'attempts': attempts.toJson(valueToJson: (v) => v.toJson()),
      'serverTime': serverTime.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeachingActivityView',
      'activityId': activityId.toJson(),
      'courseId': courseId.toJson(),
      'sectionId': sectionId.toJson(),
      'kind': kind,
      'revision': revision,
      'published': published,
      'released': released,
      'teacher': teacher,
      'settings': settings.toJsonForProtocol(),
      'questions': questions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'submissions': submissions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'attempts': attempts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'serverTime': serverTime.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TeachingActivityViewImpl extends TeachingActivityView {
  _TeachingActivityViewImpl({
    required _isc.UuidValue activityId,
    required _isc.UuidValue courseId,
    required _isc.UuidValue sectionId,
    required String kind,
    required int revision,
    required bool published,
    required bool released,
    required bool teacher,
    required _i9l8jupr.TeachingSettings settings,
    required List<_i3iex35i.TeachingQuestion> questions,
    required List<_iio2boad.TeachingSubmissionView> submissions,
    required List<_io973fkd.TeachingAttemptView> attempts,
    required DateTime serverTime,
  }) : super._(
         activityId: activityId,
         courseId: courseId,
         sectionId: sectionId,
         kind: kind,
         revision: revision,
         published: published,
         released: released,
         teacher: teacher,
         settings: settings,
         questions: questions,
         submissions: submissions,
         attempts: attempts,
         serverTime: serverTime,
       );

  /// Returns a shallow copy of this [TeachingActivityView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TeachingActivityView copyWith({
    _isc.UuidValue? activityId,
    _isc.UuidValue? courseId,
    _isc.UuidValue? sectionId,
    String? kind,
    int? revision,
    bool? published,
    bool? released,
    bool? teacher,
    _i9l8jupr.TeachingSettings? settings,
    List<_i3iex35i.TeachingQuestion>? questions,
    List<_iio2boad.TeachingSubmissionView>? submissions,
    List<_io973fkd.TeachingAttemptView>? attempts,
    DateTime? serverTime,
  }) {
    return TeachingActivityView(
      activityId: activityId ?? this.activityId,
      courseId: courseId ?? this.courseId,
      sectionId: sectionId ?? this.sectionId,
      kind: kind ?? this.kind,
      revision: revision ?? this.revision,
      published: published ?? this.published,
      released: released ?? this.released,
      teacher: teacher ?? this.teacher,
      settings: settings ?? this.settings.copyWith(),
      questions:
          questions ?? this.questions.map((e0) => e0.copyWith()).toList(),
      submissions:
          submissions ?? this.submissions.map((e0) => e0.copyWith()).toList(),
      attempts: attempts ?? this.attempts.map((e0) => e0.copyWith()).toList(),
      serverTime: serverTime ?? this.serverTime,
    );
  }
}
