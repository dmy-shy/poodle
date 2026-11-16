import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

class StudentTasksRepository {
  Future<List<StudentTaskRow>> list(
    Session session,
    UuidValue studentId,
    DateTime now,
  ) async {
    // A teacher reopen introduces a new deadline; student replacements
    // inherit that deadline. Compare the latest two revisions to distinguish
    // the reopen marker from a subsequent submission without reading the work.
    final rows = await session.db.unsafeQuery(
      r'''
      WITH tasks AS (
        SELECT c.id AS course_id, c.title AS course_title,
               a.id AS activity_id, a.title AS activity_title, t.kind,
          CASE
            WHEN t.kind = 'assignment' AND latest.id IS NULL
              THEN CAST(t.settings->>'closesAt' AS timestamp)
            WHEN t.kind = 'assignment' AND latest.grade IS NULL
              AND latest."reopenUntil" IS DISTINCT FROM prior."reopenUntil"
              THEN latest."reopenUntil"
            WHEN t.kind = 'test' AND NOT t.released THEN
              COALESCE(attempts.running_until,
                CASE WHEN attempts.used < CAST(t.settings->>'attemptLimit' AS int)
                  THEN CAST(t.settings->>'closesAt' AS timestamp) END)
          END AS deadline
        FROM poodle_course_membership m
        JOIN poodle_course c ON c.id = m."courseId"
        JOIN poodle_teaching_activity t ON t."courseId" = c.id AND t.published
        JOIN poodle_course_activity a ON a.id = t."activityId" AND a.published
        JOIN poodle_course_section s ON s.id = a."sectionId"
          AND s."courseId" = c.id AND s.published
        LEFT JOIN LATERAL (
          SELECT r.id, r."reopenUntil", r.grade
          FROM poodle_teaching_submission r
          WHERE t.kind = 'assignment' AND r."activityId" = a.id
            AND r."ownerId" = m."authUserId"
          ORDER BY r."submittedAt" DESC, r.id DESC LIMIT 1
        ) latest ON true
        LEFT JOIN LATERAL (
          SELECT r."reopenUntil"
          FROM poodle_teaching_submission r
          WHERE latest."reopenUntil" IS NOT NULL AND r."activityId" = a.id
            AND r."ownerId" = m."authUserId"
          ORDER BY r."submittedAt" DESC, r.id DESC LIMIT 1 OFFSET 1
        ) prior ON true
        LEFT JOIN LATERAL (
          SELECT count(*) AS used,
            min(r."expiresAt") FILTER (
              WHERE r."submittedAt" IS NULL AND r."expiresAt" > CAST(@now AS timestamp)
            ) AS running_until
          FROM poodle_teaching_attempt r
          WHERE t.kind = 'test' AND NOT t.released AND r."activityId" = a.id
            AND r."ownerId" = m."authUserId"
        ) attempts ON true
        WHERE m."authUserId" = CAST(@studentId AS uuid) AND m.active
          AND m.role = 'student' AND t.kind IN ('assignment', 'test')
      )
      SELECT course_id, course_title, activity_id, activity_title, kind, deadline
      FROM tasks WHERE deadline IS NOT NULL
      ORDER BY CASE WHEN deadline <= CAST(@now AS timestamp) THEN deadline END DESC NULLS LAST,
               CASE WHEN deadline > CAST(@now AS timestamp) THEN deadline END ASC,
               activity_id
      ''',
      parameters: QueryParameters.named({
        'studentId': studentId.toString(),
        'now': now.toIso8601String(),
      }),
    );
    return [
      for (final row in rows)
        StudentTaskRow(
          courseId: UuidValue.withValidation(row[0].toString()),
          courseTitle: row[1] as String,
          activityId: UuidValue.withValidation(row[2].toString()),
          activityTitle: row[3] as String,
          kind: row[4] as String,
          deadline: (row[5] as DateTime).toUtc(),
        ),
    ];
  }
}
