import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'notebook_service.dart';
import 'notebook_note_service.dart';
import 'notebook_citation_service.dart';
import 'notebook_settings_service.dart';
import 'notebook_history_service.dart';
import 'notebook_private_upload_service.dart';
import 'notebook_studio_service.dart';

class NotebookEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<NotebookNoteView> saveNote(
    Session session,
    UuidValue notebookId,
    UuidValue turnId,
  ) => NotebookNoteService().save(session, notebookId, turnId);

  Future<List<NotebookNoteView>> getNotes(
    Session session,
    UuidValue notebookId,
  ) => NotebookNoteService().list(session, notebookId);

  Future<void> deleteNote(
    Session session,
    UuidValue notebookId,
    UuidValue noteId,
  ) => NotebookNoteService().delete(session, notebookId, noteId);

  Future<NotebookAssessmentSetup> getAssessmentSetup(
    Session session,
    UuidValue courseId,
    UuidValue assessmentActivityId,
  ) => NotebookSettingsService().read(session, courseId, assessmentActivityId);

  /// Returns the stored supporting passage after current access checks.
  Future<String> getCitationPassage(
    Session session,
    UuidValue notebookId,
    UuidValue turnId,
    UuidValue chunkId,
  ) => NotebookCitationService().passage(session, notebookId, turnId, chunkId);

  /// Begins a bounded, owner-only upload into private storage.
  Future<NotebookUploadTicket> beginUpload(
    Session session,
    NotebookUploadInput input,
  ) => NotebookUploadService().beginUpload(session, input);

  Future<NotebookJobStatus> finishUpload(
    Session session,
    UuidValue notebookId,
    UuidValue jobId,
  ) => NotebookUploadService().finishUpload(session, notebookId, jobId);

  Future<void> removeUpload(
    Session session,
    UuidValue notebookId,
    UuidValue sourceId,
  ) => NotebookUploadService().removeUpload(session, notebookId, sourceId);

  /// Returns private history after rechecking current source access.
  Future<List<NotebookTurnView>> getTurns(
    Session session,
    UuidValue notebookId,
  ) => NotebookHistoryService().turns(session, notebookId);

  Future<NotebookOverview> openNotebook(
    Session session,
    UuidValue courseId,
    UuidValue assessmentActivityId,
  ) => NotebookService().open(
    session,
    courseId: courseId,
    assessmentActivityId: assessmentActivityId,
  );

  Future<NotebookAssessmentConfigView> configureAssessment(
    Session session,
    NotebookAssessmentConfigInput input,
  ) => NotebookService().configure(session, input);

  Future<void> setSelectedSources(
    Session session,
    UuidValue notebookId,
    List<UuidValue> sourceIds,
  ) => NotebookService().setSelectedSources(
    session,
    notebookId: notebookId,
    sourceIds: sourceIds,
  );

  Future<NotebookJobStatus> ask(
    Session session,
    NotebookChatInput input,
  ) => NotebookService().enqueueChat(session, input);

  Future<NotebookJobStatus> getJobStatus(
    Session session,
    UuidValue notebookId,
    UuidValue jobId,
  ) => NotebookService().jobStatus(
    session,
    notebookId: notebookId,
    jobId: jobId,
  );

  Future<NotebookJobStatus> generateStudioItem(
    Session session,
    NotebookStudioRequest input,
  ) => NotebookStudioService().generate(session, input);

  Future<List<NotebookJobStatus>> getStudioJobs(
    Session session,
    UuidValue notebookId,
  ) => NotebookStudioService().jobs(session, notebookId);

  Future<List<NotebookStudioItem>> getStudioItems(
    Session session,
    UuidValue notebookId,
  ) => NotebookStudioService().items(session, notebookId);

  Future<NotebookStudioItem> getStudioItem(
    Session session,
    UuidValue notebookId,
    UuidValue artifactId,
  ) => NotebookStudioService().item(session, notebookId, artifactId);

  Future<String> getStudioCitationPassage(
    Session session,
    UuidValue notebookId,
    UuidValue artifactId,
    UuidValue chunkId,
  ) => NotebookStudioService().passage(
    session,
    notebookId,
    artifactId,
    chunkId,
  );

  Future<NotebookAudioAccess> getStudioAudioAccess(
    Session session,
    UuidValue notebookId,
    UuidValue artifactId,
  ) => NotebookStudioService().audio(session, notebookId, artifactId);
}
