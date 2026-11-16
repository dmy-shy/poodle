import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'search_document.dart';

Future<void> enqueueSearchIndex(
  Session session,
  SearchDocument document, {
  Transaction? transaction,
}) => session.db
    .unsafeExecute(
      r'''
  INSERT INTO poodle_search_index_job (fingerprint, "targetId")
  VALUES (@fingerprint, CAST(@target AS uuid))
  ON CONFLICT (fingerprint) DO NOTHING
''',
      parameters: QueryParameters.named({
        'fingerprint': document.fingerprint,
        'target': document.hit.targetId.toString(),
      }),
      transaction: transaction,
    )
    .then((_) {});

Future<void> enqueueSearchActivity(
  Session session,
  CourseActivityRecord activity,
  Transaction transaction,
) async {
  final section = await CourseSectionRecord.db.findById(
    session,
    activity.sectionId,
    transaction: transaction,
  );
  if (section == null) return;
  final course = await CourseRecord.db.findById(
    session,
    section.courseId,
    transaction: transaction,
  );
  if (course == null) return;
  await enqueueSearchIndex(
    session,
    SearchDocument.activity(course, section, activity),
    transaction: transaction,
  );
}
