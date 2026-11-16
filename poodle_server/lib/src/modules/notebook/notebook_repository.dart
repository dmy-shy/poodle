import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

class NotebookRepository {
  Future<NotebookAssessmentConfigRecord?> config(
    Session session,
    UuidValue courseId,
    UuidValue assessmentActivityId, {
    Transaction? transaction,
  }) => NotebookAssessmentConfigRecord.db.findFirstRow(
    session,
    where: (t) =>
        t.courseId.equals(courseId) &
        t.assessmentActivityId.equals(assessmentActivityId),
    transaction: transaction,
  );

  Future<List<NotebookAssessmentMaterialRecord>> materials(
    Session session,
    UuidValue configId, {
    Transaction? transaction,
  }) => NotebookAssessmentMaterialRecord.db.find(
    session,
    where: (t) => t.configId.equals(configId),
    orderBy: (t) => t.sortOrder,
    transaction: transaction,
  );

  Future<NotebookRecord?> notebook(
    Session session,
    UuidValue ownerUserId,
    UuidValue assessmentActivityId,
  ) => NotebookRecord.db.findFirstRow(
    session,
    where: (t) =>
        t.ownerUserId.equals(ownerUserId) &
        t.assessmentActivityId.equals(assessmentActivityId),
  );

  Future<NotebookSourceRecord?> sourceForActivity(
    Session session,
    UuidValue courseId,
    UuidValue activityId, {
    Transaction? transaction,
  }) => NotebookSourceRecord.db.findFirstRow(
    session,
    where: (t) =>
        t.courseId.equals(courseId) &
        t.activityId.equals(activityId) &
        t.ownerUserId.equals(null) &
        t.notebookId.equals(null),
    transaction: transaction,
  );

  /// Serialize writes to a notebook/course without locking unrelated courses.
  Future<void> lock(
    Session session,
    String resource,
    Transaction transaction,
  ) async {
    await session.db.unsafeQuery(
      'SELECT pg_advisory_xact_lock(hashtextextended(@resource, 0))',
      parameters: QueryParameters.named({
        'resource': 'poodle.notebook:$resource',
      }),
      transaction: transaction,
    );
  }

  Future<List<NotebookSourceRecord>> notebookSources(
    Session session,
    UuidValue courseId,
    UuidValue ownerUserId,
    Iterable<UuidValue> activityIds,
  ) async {
    final activitySet = activityIds.toSet();
    if (activitySet.isEmpty) return const [];
    final courseSources = await NotebookSourceRecord.db.find(
      session,
      where: (t) => t.courseId.equals(courseId) & t.ownerUserId.equals(null),
    );
    final shared = courseSources
        .where((source) => activitySet.contains(source.activityId))
        .toList();
    final owned = await NotebookSourceRecord.db.find(
      session,
      where: (t) =>
          t.courseId.equals(courseId) &
          t.ownerUserId.equals(ownerUserId) &
          t.notebookId.equals(null),
    );
    return [...shared, ...owned];
  }

  Future<List<NotebookSourceSelectionRecord>> selections(
    Session session,
    UuidValue notebookId,
  ) => NotebookSourceSelectionRecord.db.find(
    session,
    where: (t) => t.notebookId.equals(notebookId),
  );

  Future<List<NotebookSourceRecord>> privateSources(
    Session session,
    UuidValue notebookId,
    UuidValue ownerUserId,
  ) => NotebookSourceRecord.db.find(
    session,
    where: (t) =>
        t.notebookId.equals(notebookId) &
        t.ownerUserId.equals(ownerUserId) &
        t.status.notEquals('deleted') &
        t.status.notEquals('uploading'),
  );

  Future<NotebookSourceSelectionRecord?> selection(
    Session session,
    UuidValue notebookId,
    UuidValue sourceId,
  ) => NotebookSourceSelectionRecord.db.findFirstRow(
    session,
    where: (t) => t.notebookId.equals(notebookId) & t.sourceId.equals(sourceId),
  );

  Future<NotebookJobRecord?> jobByRequest(
    Session session,
    UuidValue ownerUserId,
    String requestKey,
  ) => NotebookJobRecord.db.findFirstRow(
    session,
    where: (t) =>
        t.ownerUserId.equals(ownerUserId) & t.requestKey.equals(requestKey),
  );

  Future<NotebookJobRecord?> job(
    Session session,
    UuidValue id,
    UuidValue ownerUserId,
  ) => NotebookJobRecord.db.findFirstRow(
    session,
    where: (t) => t.id.equals(id) & t.ownerUserId.equals(ownerUserId),
  );
}
