import '../../core/course_tenancy.dart';
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

/// Persists a recipient event inside the transaction that caused it.
class NotificationService {
  Future<void> forCourseStudents(
    Session session,
    Transaction tx, {
    required UuidValue courseId,
    required UuidValue activityId,
    required String eventKey,
    required String category,
    required String title,
  }) async {
    final members = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) =>
            t.courseId.equals(courseId) &
            t.role.equals('student') &
            t.active.equals(true),
        transaction: tx,
      ),
      transaction: tx,
    );
    for (final member in members) {
      await forUser(
        session,
        tx,
        recipientId: member.authUserId,
        courseId: courseId,
        activityId: activityId,
        eventKey: eventKey,
        category: category,
        title: title,
      );
    }
  }

  Future<void> forUser(
    Session session,
    Transaction tx, {
    required UuidValue recipientId,
    required String eventKey,
    required String category,
    required String title,
    UuidValue? courseId,
    UuidValue? activityId,
    UuidValue? requestId,
  }) async {
    final existing = await NotificationRecord.db.findFirstRow(
      session,
      where: (t) =>
          t.recipientId.equals(recipientId) & t.eventKey.equals(eventKey),
      transaction: tx,
    );
    if (existing != null) return;
    await NotificationRecord.db.insertRow(
      session,
      NotificationRecord(
        recipientId: recipientId,
        eventKey: eventKey,
        category: category,
        courseId: courseId,
        activityId: activityId,
        requestId: requestId,
        title: title,
        createdAt: DateTime.now().toUtc(),
      ),
      transaction: tx,
    );
  }
}
