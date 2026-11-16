import 'package:serverpod/serverpod.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import 'course_service.dart';
import 'course_repository.dart';

class CoursePreferenceService {
  Future<CourseSummary> set(
    Session session,
    UuidValue courseId, {
    bool? starred,
    bool? hidden,
  }) async {
    final account = await AccountAuthorization.requireAccount(session);
    await CourseService().requireMember(
      session,
      courseId,
    );
    final repository = CourseRepository();
    final existing = await repository.preference(
      session,
      account.authUserId,
      courseId,
    );
    final updated = existing == null
        ? CoursePreference(
            authUserId: account.authUserId,
            courseId: courseId,
            starred: starred ?? false,
            hidden: hidden ?? false,
          )
        : existing.copyWith(
            starred: starred ?? existing.starred,
            hidden: hidden ?? existing.hidden,
          );
    if (existing == null) {
      await CoursePreference.db.insertRow(session, updated);
    } else {
      await CoursePreference.db.updateRow(session, updated);
    }
    return CourseService().get(session, courseId);
  }
}
