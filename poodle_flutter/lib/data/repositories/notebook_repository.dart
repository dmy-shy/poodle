import 'package:flutter/foundation.dart';

@immutable
class StudyMaterialOption {
  const StudyMaterialOption(this.id, this.title, this.format);
  final String id, title, format;
}

@immutable
class StudyNotebookSetup {
  StudyNotebookSetup(
    this.revision,
    Iterable<String> materialIds,
    Iterable<String> formats,
    Iterable<StudyMaterialOption> materials,
  ) : materialIds = List.unmodifiable(materialIds),
      formats = List.unmodifiable(formats),
      materials = List.unmodifiable(materials);
  final int revision;
  final List<String> materialIds, formats;
  final List<StudyMaterialOption> materials;
}

@immutable
class StudySource {
  const StudySource(
    this.id,
    this.title,
    this.status,
    this.selected, {
    this.failureCode,
    this.privateUpload = false,
  });
  final String id, title, status;
  final bool selected;
  final String? failureCode;
  final bool privateUpload;
}

@immutable
class StudyNotebook {
  StudyNotebook(
    this.id,
    this.configured,
    Iterable<StudySource> sources, {
    Iterable<String> allowedFormats = const [],
  }) : sources = List.unmodifiable(sources),
       allowedFormats = List.unmodifiable(allowedFormats);
  final List<String> allowedFormats;
  final String? id;
  final bool configured;
  final List<StudySource> sources;
}

@immutable
class StudyCitation {
  const StudyCitation(this.title, this.location, this.version, {this.chunkId});
  final String title;
  final String? location;
  final int version;
  final String? chunkId;
}

@immutable
class StudyTurn {
  StudyTurn(
    this.id,
    this.role,
    this.content,
    this.stale,
    Iterable<StudyCitation> citations,
  ) : citations = List.unmodifiable(citations);
  final String id, role, content;
  final bool stale;
  final List<StudyCitation> citations;
}

@immutable
class StudyJob {
  const StudyJob(this.id, this.status);
  final String id, status;
}

enum NotebookFailure {
  unavailable,
  processing,
  network,
  noSources,
  budget,
  changed,
  cancelled,
  invalidUpload,
  uploadLimit,
}

enum StudioKind { quiz, audio, flashcards }

class StudyStudioItem {
  const StudyStudioItem({
    required this.id,
    required this.kind,
    required this.language,
    required this.title,
    required this.status,
    required this.contentJson,
    required this.citations,
    required this.createdAt,
    this.failureCode,
  });

  final StudioKind kind;
  final String id, language, title, status, contentJson;
  final String? failureCode;
  final List<StudyCitation> citations;
  final DateTime createdAt;
  bool get pending => status == 'queued' || status == 'processing';
}

typedef StudyAudioAccess = ({String url, DateTime expiresAt});

typedef StudyNote = ({
  String id,
  String turnId,
  String content,
  bool stale,
  DateTime createdAt,
});

/// Account-scoped notebook reads may be cached; mutations always use Serverpod.
abstract class NotebookRepository extends ChangeNotifier {
  String? account;
  int generation = 0;
  bool get isStale => false;
  DateTime? get lastRefreshedAt => null;
  void bindAccount(String? value) {
    if (account == value) return;
    account = value;
    generation++;
    notifyListeners();
  }

  Future<StudyNotebook> open(String courseId, String assessmentId);
  Future<StudyNotebookSetup> assessmentSetup(
    String courseId,
    String assessmentId,
  ) => throw NotebookFailure.unavailable;
  Future<void> configure(
    String courseId,
    String assessmentId,
    int revision,
    List<String> materialIds,
    List<String> formats,
  ) => throw NotebookFailure.unavailable;
  Future<StudyNote> saveNote(String notebookId, String turnId) async =>
      throw NotebookFailure.unavailable;
  Future<List<StudyNote>> notes(String notebookId) async =>
      throw NotebookFailure.unavailable;
  Future<void> deleteNote(String notebookId, String noteId) async =>
      throw NotebookFailure.unavailable;
  Future<List<StudyTurn>> turns(String notebookId);
  Future<String> citationPassage(
    String notebookId,
    String turnId,
    String chunkId,
  ) => throw NotebookFailure.unavailable;
  Future<void> select(String notebookId, List<String> sourceIds);
  Future<StudyJob> ask(String notebookId, String question, String requestKey);
  Future<StudyJob> job(String notebookId, String jobId);
  Future<StudyJob?> upload(
    String notebookId,
    List<String> formats,
    String requestKey, {
    void Function(String name)? onPicked,
  }) => throw NotebookFailure.unavailable;
  Future<void> removeUpload(String notebookId, String sourceId) =>
      throw NotebookFailure.unavailable;

  Future<List<StudyStudioItem>> studioItems(String notebookId) async =>
      const [];
  Future<void> generateStudio(
    String notebookId,
    StudioKind kind,
    String language,
    String requestKey,
  ) async => throw NotebookFailure.unavailable;
  Future<StudyStudioItem> studioItem(
    String notebookId,
    String artifactId,
  ) async => throw NotebookFailure.unavailable;
  Future<String> studioPassage(
    String notebookId,
    String artifactId,
    String chunkId,
  ) async => throw NotebookFailure.unavailable;
  Future<StudyAudioAccess> studioAudio(
    String notebookId,
    String artifactId,
  ) async => throw NotebookFailure.unavailable;
}
