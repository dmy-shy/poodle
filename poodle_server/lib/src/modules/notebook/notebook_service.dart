import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../course_content/course_content_repository.dart';
import '../course_content/course_content_service.dart';
import '../courses/course_service.dart';
import 'notebook_policy.dart';
import 'notebook_material_policy.dart';
import 'notebook_repository.dart';

class NotebookService {
  NotebookService({
    CourseService? courses,
    CourseContentService? content,
    CourseContentRepository? courseContentRepository,
    NotebookRepository? repository,
  }) : _courses = courses ?? CourseService(),
       _contentRepository =
           courseContentRepository ?? CourseContentRepository(),
       _content =
           content ?? CourseContentService(repository: courseContentRepository),
       _repository = repository ?? NotebookRepository();

  final CourseService _courses;
  final CourseContentRepository _contentRepository;
  final CourseContentService _content;
  final NotebookRepository _repository;

  Future<NotebookOverview> open(
    Session session, {
    required UuidValue courseId,
    required UuidValue assessmentActivityId,
  }) async {
    final access = await _courses.requireMember(session, courseId);
    if (access.membership.role != 'student') {
      throw NotebookError(code: 'unavailable');
    }
    final assessment = await _content.getActivity(
      session,
      courseId,
      assessmentActivityId,
    );
    if (assessment.draft || !{'module', 'test'}.contains(assessment.kind)) {
      throw NotebookError(code: 'unavailable');
    }
    final config = await _repository.config(
      session,
      courseId,
      assessmentActivityId,
    );
    if (config == null) {
      return NotebookOverview(
        courseId: courseId,
        assessmentActivityId: assessmentActivityId,
        configured: false,
        configRevision: 0,
        allowedFormats: const [],
        sources: const [],
      );
    }
    final defaults = await _repository.materials(session, config.id!);
    // Material publication and storage can change after configuration. Recheck
    // the current course content before exposing a previously indexed source.
    final visibleContent = await _content.getContent(session, courseId);
    final visibleMaterials = {
      for (final section in visibleContent.sections)
        for (final activity in section.activities)
          if (activity.kind == 'file' && activity.file != null) activity.id,
    };
    final activityIds = defaults
        .map((item) => item.activityId)
        .where(visibleMaterials.contains)
        .toSet();
    final notebook = await _getOrCreateNotebook(
      session,
      ownerUserId: access.membership.authUserId,
      courseId: courseId,
      assessmentActivityId: assessmentActivityId,
      configRevision: config.revision,
    );
    final sources = await _repository.notebookSources(
      session,
      courseId,
      access.membership.authUserId,
      activityIds,
    );
    final privateSources = await _repository.privateSources(
      session,
      notebook.id!,
      access.membership.authUserId,
    );
    final selections = await _repository.selections(session, notebook.id!);
    final selectedBySource = {
      for (final item in selections) item.sourceId: item.selected,
    };
    final sourceInfos = <NotebookSourceInfo>[];
    for (final source in [...sources, ...privateSources]) {
      if (source.ownerUserId == null) {
        final material = source.activityId == null
            ? null
            : await _contentRepository.activity(session, source.activityId!);
        if (material == null ||
            material.storageId != 'private' ||
            material.storageId != source.storageId ||
            material.storagePath != source.storagePath) {
          continue;
        }
      }
      final isDefault =
          source.activityId != null && activityIds.contains(source.activityId);
      sourceInfos.add(
        NotebookSourceInfo(
          privateUpload: source.ownerUserId != null,
          id: source.id!,
          title: source.fileName,
          format: source.format,
          status: source.status,
          selected: selectedBySource[source.id] ?? isDefault,
          teacherDefault: isDefault,
          currentVersion: source.currentVersion,
          failureCode: source.failureCode,
        ),
      );
    }
    sourceInfos.sort((a, b) => a.title.compareTo(b.title));
    return NotebookOverview(
      notebookId: notebook.id,
      courseId: courseId,
      assessmentActivityId: assessmentActivityId,
      configured: true,
      configRevision: config.revision,
      allowedFormats: config.allowedFormats,
      sources: sourceInfos,
    );
  }

  Future<NotebookAssessmentConfigView> configure(
    Session session,
    NotebookAssessmentConfigInput input,
  ) async {
    final access = await _courses.requireMember(session, input.courseId);
    if (access.membership.role != 'teacher') {
      throw NotebookError(code: 'unavailable');
    }
    await _requireAssessment(
      session,
      input.courseId,
      input.assessmentActivityId,
    );
    final List<String> formats;
    try {
      formats = NotebookPolicy.normalizeFormats(input.allowedFormats);
    } on ArgumentError {
      throw NotebookError(code: 'invalid_configuration');
    }
    final ids = input.defaultMaterialActivityIds;
    if (ids.isEmpty || ids.toSet().length != ids.length) {
      throw NotebookError(code: 'invalid_configuration');
    }
    final policyInputs = <NotebookMaterialPolicyInput>[];
    final materialRecords = <CourseActivityRecord>[];
    for (final id in ids) {
      final activity = await _contentRepository.activity(session, id);
      if (activity == null) throw NotebookError(code: 'invalid_configuration');
      NotebookMaterialPolicy.format(activity);
      materialRecords.add(activity);
      final section = await CourseSectionRecord.db.findById(
        session,
        activity.sectionId,
      );
      policyInputs.add(
        NotebookMaterialPolicyInput(
          id: id.toString(),
          courseId: section?.courseId.toString() ?? '',
          published: activity.published && section?.published == true,
          isFile: activity.kind == 'file' && activity.file != null,
        ),
      );
    }
    if (!NotebookPolicy.validDefaultMaterials(
      targetCourseId: input.courseId.toString(),
      materials: policyInputs,
    )) {
      throw NotebookError(code: 'invalid_configuration');
    }

    final saved = await session.db.transaction((transaction) async {
      await _repository.lock(session, 'course:${input.courseId}', transaction);
      final current = await _repository.config(
        session,
        input.courseId,
        input.assessmentActivityId,
        transaction: transaction,
      );
      if ((current?.revision ?? 0) != input.expectedRevision) {
        throw NotebookError(code: 'configuration_conflict');
      }
      final revision = (current?.revision ?? 0) + 1;
      final record = current == null
          ? NotebookAssessmentConfigRecord(
              courseId: input.courseId,
              assessmentActivityId: input.assessmentActivityId,
              teacherUserId: access.membership.authUserId,
              revision: revision,
              allowedFormats: formats,
            )
          : current.copyWith(
              teacherUserId: access.membership.authUserId,
              revision: revision,
              allowedFormats: formats,
              updatedAt: DateTime.now().toUtc(),
            );
      final stored = current == null
          ? await NotebookAssessmentConfigRecord.db.insertRow(
              session,
              record,
              transaction: transaction,
            )
          : await NotebookAssessmentConfigRecord.db.updateRow(
              session,
              record,
              transaction: transaction,
            );
      for (final previous in await _repository.materials(
        session,
        stored.id!,
        transaction: transaction,
      )) {
        await NotebookAssessmentMaterialRecord.db.deleteRow(
          session,
          previous,
          transaction: transaction,
        );
      }
      for (var index = 0; index < ids.length; index++) {
        await _registerMaterial(
          session,
          materialRecords[index],
          courseId: input.courseId,
          teacherId: access.membership.authUserId,
          transaction: transaction,
        );
        await NotebookAssessmentMaterialRecord.db.insertRow(
          session,
          NotebookAssessmentMaterialRecord(
            configId: stored.id!,
            activityId: ids[index],
            sortOrder: index,
          ),
          transaction: transaction,
        );
      }
      return stored;
    });
    return NotebookAssessmentConfigView(
      courseId: input.courseId,
      assessmentActivityId: input.assessmentActivityId,
      revision: saved.revision,
      defaultMaterialActivityIds: List.unmodifiable(ids),
      allowedFormats: saved.allowedFormats,
    );
  }

  Future<void> _registerMaterial(
    Session session,
    CourseActivityRecord activity, {
    required UuidValue courseId,
    required UuidValue teacherId,
    required Transaction transaction,
  }) async {
    final format = NotebookMaterialPolicy.format(activity);
    var source = await _repository.sourceForActivity(
      session,
      courseId,
      activity.id!,
      transaction: transaction,
    );
    source ??= await NotebookSourceRecord.db.insertRow(
      session,
      NotebookSourceRecord(
        courseId: courseId,
        activityId: activity.id!,
        fileName: activity.file!.fileName,
        format: format,
        storageId: 'private',
        storagePath: activity.storagePath!,
      ),
      transaction: transaction,
    );
    final requestKey = 'ingest:${source.id}:${activity.file!.checksum}';
    final existingJob = await NotebookJobRecord.db.findFirstRow(
      session,
      where: (t) =>
          t.sourceId.equals(source!.id) & t.requestKey.equals(requestKey),
      transaction: transaction,
    );
    if (existingJob != null) return;
    await NotebookSourceRecord.db.updateRow(
      session,
      source.copyWith(
        fileName: activity.file!.fileName,
        format: format,
        storagePath: activity.storagePath!,
        status: 'queued',
        failureCode: null,
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
    await NotebookJobRecord.db.insertRow(
      session,
      NotebookJobRecord(
        ownerUserId: teacherId,
        sourceId: source.id!,
        jobType: 'ingest',
        requestKey: requestKey,
        privatePayload: jsonEncode({
          'checksum': activity.file!.checksum,
          'storageId': 'private',
          'storagePath': activity.storagePath,
          'sizeBytes': activity.file!.sizeBytes,
          'format': format,
        }),
      ),
      transaction: transaction,
    );
  }

  Future<void> setSelectedSources(
    Session session, {
    required UuidValue notebookId,
    required List<UuidValue> sourceIds,
  }) async {
    if (sourceIds.toSet().length != sourceIds.length) {
      throw NotebookError(code: 'invalid_sources');
    }
    final user = await _requireNotebookOwner(session, notebookId);
    final notebook = user.notebook;
    final overview = await open(
      session,
      courseId: notebook.courseId,
      assessmentActivityId: notebook.assessmentActivityId,
    );
    final available = overview.sources.map((source) => source.id).toSet();
    if (sourceIds.any((id) => !available.contains(id))) {
      throw NotebookError(code: 'invalid_sources');
    }
    await session.db.transaction((transaction) async {
      await _repository.lock(
        session,
        'course:${notebook.courseId}',
        transaction,
      );
      await _repository.lock(session, 'notebook:$notebookId', transaction);
      for (final old in await NotebookSourceSelectionRecord.db.find(
        session,
        where: (t) => t.notebookId.equals(notebookId),
        transaction: transaction,
      )) {
        await NotebookSourceSelectionRecord.db.deleteRow(
          session,
          old,
          transaction: transaction,
        );
      }
      for (final sourceId in available) {
        await NotebookSourceSelectionRecord.db.insertRow(
          session,
          NotebookSourceSelectionRecord(
            notebookId: notebookId,
            sourceId: sourceId,
            selected: sourceIds.contains(sourceId),
            selectedVersion: overview.sources
                .firstWhere((source) => source.id == sourceId)
                .currentVersion,
          ),
          transaction: transaction,
        );
      }
    });
  }

  Future<NotebookJobStatus> enqueueChat(
    Session session,
    NotebookChatInput input,
  ) async {
    final requestKey = input.requestKey.trim();
    final question = input.question.trim();
    if (requestKey.isEmpty ||
        requestKey.length > 100 ||
        question.isEmpty ||
        question.length > 4000) {
      throw NotebookError(code: 'invalid_request');
    }
    final owner = await _requireNotebookOwner(session, input.notebookId);
    final overview = await open(
      session,
      courseId: owner.notebook.courseId,
      assessmentActivityId: owner.notebook.assessmentActivityId,
    );
    final selected = overview.sources
        .where((source) => source.selected)
        .toList();
    final ready = selected.where((source) => source.status == 'ready').toList();
    final requestPayload = jsonEncode({
      'question': question,
      'sourceIds': ready.map((source) => source.id.toString()).toList(),
      'sourceVersions': {
        for (final source in ready) source.id.toString(): source.currentVersion,
      },
      'configRevision': overview.configRevision,
    });
    final privateSession = await session.serverpod.createSession(
      enableLogging: false,
    );
    try {
      return await privateSession.db.transaction((tx) async {
        await _repository.lock(
          privateSession,
          'course:${owner.notebook.courseId}',
          tx,
        );
        await _repository.lock(
          privateSession,
          'notebook:${input.notebookId}',
          tx,
        );
        await _repository.lock(
          privateSession,
          'request:${owner.userId}:$requestKey',
          tx,
        );
        final existing = await NotebookJobRecord.db.findFirstRow(
          privateSession,
          where: (t) =>
              t.ownerUserId.equals(owner.userId) &
              t.requestKey.equals(requestKey),
          transaction: tx,
        );
        if (existing != null) {
          final previous = jsonDecode(existing.privatePayload ?? '{}') as Map;
          if (existing.notebookId != input.notebookId ||
              existing.jobType != 'chat' ||
              previous['question'] != question) {
            throw NotebookError(code: 'request_key_conflict');
          }
          return _projectJob(existing);
        }
        if (ready.isEmpty) throw NotebookError(code: 'no_ready_sources');
        final job = await NotebookJobRecord.db.insertRow(
          privateSession,
          NotebookJobRecord(
            ownerUserId: owner.userId,
            notebookId: input.notebookId,
            jobType: 'chat',
            status: 'queued',
            requestKey: requestKey,
            privatePayload: requestPayload,
          ),
          transaction: tx,
        );
        return _projectJob(job);
      });
    } finally {
      await privateSession.close();
    }
  }

  Future<NotebookJobStatus> jobStatus(
    Session session, {
    required UuidValue notebookId,
    required UuidValue jobId,
  }) async {
    final owner = await _requireNotebookOwner(session, notebookId);
    final job = await _repository.job(session, jobId, owner.userId);
    if (job == null || job.notebookId != notebookId) {
      throw NotebookError(code: 'unavailable');
    }
    return _projectJob(job);
  }

  NotebookJobStatus _projectJob(NotebookJobRecord job) => NotebookJobStatus(
    id: job.id!,
    status: job.status,
    failureCode: job.failureCode,
    createdAt: job.createdAt,
  );

  Future<({UuidValue userId, NotebookRecord notebook})> _requireNotebookOwner(
    Session session,
    UuidValue notebookId,
  ) async {
    final rows = await NotebookRecord.db.find(
      session,
      where: (t) => t.id.equals(notebookId),
      limit: 1,
    );
    if (rows.isEmpty) throw NotebookError(code: 'unavailable');
    final notebook = rows.single;
    final access = await _courses.requireMember(session, notebook.courseId);
    if (access.membership.role != 'student' ||
        access.membership.authUserId != notebook.ownerUserId) {
      throw NotebookError(code: 'unavailable');
    }
    final assessment = await _content.getActivity(
      session,
      notebook.courseId,
      notebook.assessmentActivityId,
    );
    if (assessment.draft || !{'module', 'test'}.contains(assessment.kind)) {
      throw NotebookError(code: 'unavailable');
    }
    return (userId: notebook.ownerUserId, notebook: notebook);
  }

  Future<NotebookRecord> _getOrCreateNotebook(
    Session session, {
    required UuidValue ownerUserId,
    required UuidValue courseId,
    required UuidValue assessmentActivityId,
    required int configRevision,
  }) async {
    return session.db.transaction((tx) async {
      await _repository.lock(session, 'course:$courseId', tx);
      await _repository.lock(
        session,
        'open:$ownerUserId:$assessmentActivityId',
        tx,
      );
      final existing = await NotebookRecord.db.findFirstRow(
        session,
        where: (t) =>
            t.ownerUserId.equals(ownerUserId) &
            t.assessmentActivityId.equals(assessmentActivityId),
        transaction: tx,
      );
      if (existing != null) {
        if (existing.courseId != courseId) {
          throw NotebookError(code: 'unavailable');
        }
        if (existing.configRevision != configRevision) {
          final updated = existing.copyWith(
            configRevision: configRevision,
            updatedAt: DateTime.now().toUtc(),
          );
          return NotebookRecord.db.updateRow(session, updated, transaction: tx);
        }
        return existing;
      }
      return NotebookRecord.db.insertRow(
        session,
        NotebookRecord(
          courseId: courseId,
          assessmentActivityId: assessmentActivityId,
          ownerUserId: ownerUserId,
          configRevision: configRevision,
        ),
        transaction: tx,
      );
    });
  }

  Future<void> _requireAssessment(
    Session session,
    UuidValue courseId,
    UuidValue assessmentActivityId,
  ) async {
    final activity = await _contentRepository.activity(
      session,
      assessmentActivityId,
    );
    if (activity == null ||
        !activity.published ||
        !{'module', 'test'}.contains(activity.kind)) {
      throw NotebookError(code: 'unavailable');
    }
    final section = await CourseSectionRecord.db.findById(
      session,
      activity.sectionId,
    );
    if (section == null ||
        section.courseId != courseId ||
        !section.published ||
        activity.assessment == null) {
      throw NotebookError(code: 'unavailable');
    }
  }
}
