part of 'teaching_service.dart';

extension _TeachingProjection on TeachingService {
  Future<String> _label(Session s, UuidValue owner, Transaction tx) async =>
      (await EmailAccount.db.findFirstRow(
        s,
        where: (t) => t.authUserId.equals(owner),
        transaction: tx,
      ))?.email ??
      owner.toString();
  Future<TeachingActivityView> _view(
    Session s,
    TeachingActivityRecord row,
    Transaction tx,
    CourseMembership member,
  ) async {
    final teacher = member.role == 'teacher';
    final activity = (await CourseActivityRecord.db.findById(
      s,
      row.activityId,
      transaction: tx,
    ))!;
    final submissions = <TeachingSubmissionView>[];
    for (final v in await _submissions(s, row.activityId, tx)) {
      if (!teacher && v.ownerId != member.authUserId) continue;
      final file = v.uploadId == null
          ? null
          : await TeachingUploadRecord.db.findById(
              s,
              v.uploadId!,
              transaction: tx,
            );
      submissions.add(
        TeachingSubmissionView(
          id: v.id!,
          ownerId: v.ownerId,
          ownerLabel: await _label(s, v.ownerId, tx),
          text: v.text,
          fileName: file?.fileName,
          submittedAt: v.submittedAt,
          underReview: v.grade != null,
          grade: teacher || v.published ? v.grade : null,
          feedback: teacher || v.published ? v.feedback : null,
          published: v.published,
          reopenUntil: v.reopenUntil,
        ),
      );
    }
    final attempts = <TeachingAttemptView>[];
    for (final v in await _attempts(s, row.activityId, tx)) {
      if (!teacher && v.ownerId != member.authUserId) continue;
      final version = (await TeachingVersionRecord.db.findById(
        s,
        v.versionId,
        transaction: tx,
      ))!;
      final review = teacher || row.released;
      attempts.add(
        TeachingAttemptView(
          id: v.id!,
          ownerId: v.ownerId,
          ownerLabel: await _label(s, v.ownerId, tx),
          revision: version.revision,
          questions: v.questions
              .map(
                (q) => q.copyWith(correctIndex: review ? q.correctIndex : null),
              )
              .toList(),
          answers: v.answers,
          expiresAt: v.expiresAt,
          submittedAt: v.submittedAt,
          score: review ? v.score : null,
          maxPoints: v.maxPoints,
        ),
      );
    }
    return TeachingActivityView(
      activityId: row.activityId,
      courseId: row.courseId,
      sectionId: activity.sectionId,
      kind: row.kind,
      revision: row.revision,
      published: row.published,
      released: row.released,
      teacher: teacher,
      settings:
          !teacher &&
              submissions.isNotEmpty &&
              submissions.first.reopenUntil != null
          ? row.settings.copyWith(closesAt: submissions.first.reopenUntil)
          : row.settings,
      questions: teacher ? row.questions : [],
      submissions: submissions,
      attempts: attempts,
      serverTime: DateTime.now().toUtc(),
    );
  }
}
