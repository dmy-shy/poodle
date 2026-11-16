import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../courses/course_policy.dart';
import '../course_content/development_course_seed.dart';
import 'notebook_repository.dart';

/// Original bilingual fixture; inserts missing sample data without replacing
/// teacher configuration or restoring removed memberships.
abstract final class DevelopmentNotebookSeed {
  static const notes = '''# Retrieval and evidence / Пошук і докази

Retrieval selects relevant passages from the chosen sources before an answer is generated.
Пошук відбирає доречні уривки з вибраних джерел перед створенням відповіді.

A citation identifies the source version and passage supporting an answer.
Посилання вказує на версію джерела та уривок, що підтверджує відповідь.

If the selected sources lack evidence, the assistant should say that information is insufficient.
Якщо у вибраних джерелах немає доказів, помічник має повідомити, що інформації недостатньо.
''';
  static const _linearAlgebraNotes =
      '''# Solving linear systems / Розв’язування систем лінійних рівнянь

## Elimination / Метод виключення

To eliminate a variable, add or subtract equations so that its coefficients cancel.
Щоб виключити змінну, додайте або відніміть рівняння так, щоб її коефіцієнти скоротилися.

## Worked example / Приклад розв’язання

Solve x + y = 5 and 2x − y = 1. Add the equations to obtain 3x = 6, so x = 2.
Substitute x = 2 into the first equation to get y = 3. Both original equations hold.
Додайте рівняння x + y = 5 та 2x − y = 1: маємо 3x = 6, звідси x = 2.
Підставте x = 2 у перше рівняння: y = 3. Обидва початкові рівняння виконуються.

## Checking a solution / Перевірка розв’язку

Substitute both values into every original equation; checking only one equation is not enough.
Підставте обидва значення в кожне початкове рівняння; перевірки лише одного недостатньо.
''';

  static UuidValue _id(String tail) =>
      UuidValue.withValidation('019a0acf-0030-7000-8000-$tail');
  static Future<void> ensure(
    Session session, {
    bool testFixture = false,
  }) => _ensure(
    session,
    testFixture: testFixture,
    courseId: UuidValue.withValidation(DevelopmentCourseSeed.courseIds.first),
    sectionId: UuidValue.withValidation(
      '019a0acf-0002-7000-8000-000000000003',
    ),
    materialId: _id('000000000001'),
    assessmentId: _id('000000000002'),
    kind: 'test',
    title: 'Test data / Тестові дані',
    materialTitle: 'Test data: study notes / Навчальні нотатки',
    fileName: 'test-data.md',
    content: notes,
    instructions:
        'Ask: What does a citation identify? / Запитайте: Що визначає посилання?',
  );

  /// Backfills the module for already-installed academic fixtures as well.
  static Future<void> ensureLinearAlgebra(
    Session session, {
    required UuidValue courseId,
    required UuidValue sectionId,
  }) => _ensure(
    session,
    courseId: courseId,
    sectionId: sectionId,
    materialId: _id('000000000011'),
    assessmentId: _id('000000000012'),
    kind: 'module',
    title: 'Module: Solving linear systems / Модуль: Системи лінійних рівнянь',
    materialTitle: 'Linear systems study notes / Нотатки про системи рівнянь',
    fileName: 'linear-systems-study-notes.md',
    content: _linearAlgebraNotes,
    instructions:
        'Open Study notebook and ask: How do we solve the example by elimination? '
        '/ Відкрийте навчальний блокнот і запитайте, як розв’язати приклад методом виключення.',
    academic: true,
  );

  static Future<void> _ensure(
    Session session, {
    required UuidValue courseId,
    required UuidValue sectionId,
    required UuidValue materialId,
    required UuidValue assessmentId,
    required String kind,
    required String title,
    required String materialTitle,
    required String fileName,
    required String content,
    required String instructions,
    bool testFixture = false,
    bool academic = false,
  }) async {
    if (!CoursePolicy.seedAllowed(
      session.serverpod.runMode,
      testFixture: testFixture,
    )) {
      throw StateError(
        'Notebook samples are restricted to development and explicit tests.',
      );
    }
    await session.db.transaction((tx) async {
      final repository = NotebookRepository();
      await repository.lock(session, 'course:$courseId', tx);
      final course = await CourseRecord.db.findById(
        session,
        courseId,
        transaction: tx,
      );
      final section = await CourseSectionRecord.db.findById(
        session,
        sectionId,
        transaction: tx,
      );
      final bootstrap = await AccountAccess.db.findFirstRow(
        session,
        where: (t) => academic
            ? t.developmentPersona.equals('teacher')
            : t.developmentBootstrap.equals(true),
        transaction: tx,
      );
      if (course == null ||
          !course.seedOwned ||
          section?.courseId != courseId ||
          (academic && section?.published != true) ||
          bootstrap == null) {
        return;
      }
      final teacher = await CourseMembership.db.findFirstRow(
        session,
        where: (t) =>
            t.courseId.equals(courseId) &
            t.authUserId.equals(bootstrap.authUserId) &
            t.role.equals('teacher') &
            t.active.equals(true),
        transaction: tx,
      );
      if (teacher == null ||
          await repository.config(
                session,
                courseId,
                assessmentId,
                transaction: tx,
              ) !=
              null) {
        return;
      }
      final existingMaterial = await CourseActivityRecord.db.findById(
        session,
        materialId,
        transaction: tx,
      );
      final existingAssessment = await CourseActivityRecord.db.findById(
        session,
        assessmentId,
        transaction: tx,
      );
      // Existing fixture records may have teacher edits: never take ownership.
      if (existingMaterial != null || existingAssessment != null) return;
      final bytes = utf8.encode(content);
      final checksum = sha256.convert(bytes).toString();
      final path = 'notebook-samples/$checksum/$fileName';
      if (!await session.storage.fileExists(storageId: 'private', path: path)) {
        await session.storage.storeFile(
          storageId: 'private',
          path: path,
          byteData: ByteData.sublistView(bytes),
          options: StoreFileOptions(preventOverwrite: true),
        );
      }
      await CourseActivityRecord.db.insertRow(
        session,
        CourseActivityRecord(
          id: materialId,
          sectionId: sectionId,
          title: materialTitle,
          kind: 'file',
          sortOrder: 20,
          published: true,
          storageId: 'private',
          storagePath: path,
          file: CourseFileInfo(
            fileName: fileName,
            mimeType: 'text/markdown',
            sizeBytes: bytes.length,
            checksum: checksum,
          ),
        ),
        transaction: tx,
      );
      await CourseActivityRecord.db.insertRow(
        session,
        CourseActivityRecord(
          id: assessmentId,
          sectionId: sectionId,
          title: title,
          kind: kind,
          sortOrder: 21,
          published: true,
          assessment: CourseAssessmentInfo(instructions: instructions),
        ),
        transaction: tx,
      );
      final config = await NotebookAssessmentConfigRecord.db.insertRow(
        session,
        NotebookAssessmentConfigRecord(
          courseId: courseId,
          assessmentActivityId: assessmentId,
          teacherUserId: teacher.authUserId,
          allowedFormats: ['txt', 'md'],
        ),
        transaction: tx,
      );
      await NotebookAssessmentMaterialRecord.db.insertRow(
        session,
        NotebookAssessmentMaterialRecord(
          configId: config.id!,
          activityId: materialId,
          sortOrder: 0,
        ),
        transaction: tx,
      );
      final source = await NotebookSourceRecord.db.insertRow(
        session,
        NotebookSourceRecord(
          courseId: courseId,
          activityId: materialId,
          fileName: fileName,
          format: 'md',
          storageId: 'private',
          storagePath: path,
        ),
        transaction: tx,
      );
      await NotebookJobRecord.db.insertRow(
        session,
        NotebookJobRecord(
          ownerUserId: teacher.authUserId,
          sourceId: source.id!,
          jobType: 'ingest',
          requestKey: 'ingest:${source.id}:$checksum',
          privatePayload: jsonEncode({
            'checksum': checksum,
            'format': 'md',
            'storageId': 'private',
            'storagePath': path,
            'sizeBytes': bytes.length,
          }),
        ),
        transaction: tx,
      );
    });
  }

  static Future<void> fromLocalConfig(Serverpod pod) async {
    if (pod.runMode != ServerpodRunMode.development) return;
    final session = await pod.createSession(enableLogging: false);
    try {
      await ensure(session);
    } finally {
      await session.close();
    }
  }
}
