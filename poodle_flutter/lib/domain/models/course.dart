import 'package:flutter/foundation.dart';

const sampleDesignId = '019a0acf-0000-7000-8000-000000000001';
const sampleWritingId = '019a0acf-0000-7000-8000-000000000002';

bool validCourseId(String value) => RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
).hasMatch(value);

enum CourseFailure {
  unavailable,
  network,
  wifiRequired,
  cancelled,
  file,
  noHandler,
}

enum ActivityKind { file, link, announcement, module, lab, assignment, test }

@immutable
class CourseInfo {
  const CourseInfo({
    required this.id,
    required this.title,
    this.category,
    this.summary,
    this.teacherName,
    this.sample = false,
    this.starred = false,
    this.hidden = false,
    this.role,
  });
  final String id, title;
  final String? role;
  final String? category, summary, teacherName;
  final bool sample;
  final bool starred, hidden;
}

@immutable
class CourseFile {
  const CourseFile({
    required this.name,
    required this.mimeType,
    required this.sizeBytes,
    required this.checksum,
  });
  final String name, mimeType, checksum;
  final int sizeBytes;
  bool get supportsOfflineCopy =>
      mimeType == 'text/markdown' ||
      mimeType == 'application/pdf' ||
      mimeType ==
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
}

@immutable
class CourseActivity {
  const CourseActivity({
    required this.id,
    required this.courseId,
    required this.title,
    required this.kind,
    this.description,
    this.draft = false,
    this.managedAssessment = false,
    this.file,
    this.url,
    this.body,
    this.author,
    this.publishedAt,
    this.instructions,
    this.opensAt,
    this.closesAt,
    this.attemptLimit,
    this.timeLimitMinutes,
    this.availability,
    this.previousId,
    this.nextId,
  });
  final bool managedAssessment;
  final String id, courseId, title;
  final ActivityKind kind;
  final bool draft;
  final String? description,
      url,
      body,
      author,
      instructions,
      availability,
      previousId,
      nextId;
  final DateTime? publishedAt, opensAt, closesAt;
  final int? attemptLimit, timeLimitMinutes;
  final CourseFile? file;
}

@immutable
class ContentSection {
  ContentSection({
    required this.id,
    required this.title,
    this.description,
    this.draft = false,
    required List<CourseActivity> activities,
  }) : activities = List.unmodifiable(activities);
  final String id, title;
  final String? description;
  final bool draft;
  final List<CourseActivity> activities;
}

@immutable
class CourseContent {
  CourseContent({
    required this.course,
    required List<ContentSection> sections,
    this.teacherView = false,
    this.serverTime,
  }) : sections = List.unmodifiable(sections);
  final CourseInfo course;
  final List<ContentSection> sections;
  final bool teacherView;
  final DateTime? serverTime;
}

class FileAccess {
  const FileAccess(this.url, this.expiresAt, {this.asset});
  final String url;
  final DateTime expiresAt;
  final String? asset;
}
