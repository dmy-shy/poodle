import '../identity/identity_locks.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../courses/course_policy.dart';

/// Inserts missing sample records only. Existing membership decisions and
/// teacher edits survive every restart. Documents are supplied by the user.
abstract final class DevelopmentCourseSeed {
  static const courseIds = [
    '019a0acf-0000-7000-8000-000000000001',
    '019a0acf-0000-7000-8000-000000000002',
  ];
  static UuidValue _uuid(String value) => UuidValue.withValidation(value);

  static Future<void> ensure(
    Session session, {
    bool testFixture = false,
    Map<String, ByteData> documents = const {},
  }) async {
    if (!CoursePolicy.seedAllowed(
      session.serverpod.runMode,
      testFixture: testFixture,
    )) {
      throw StateError(
        'Course samples are restricted to development and explicit tests.',
      );
    }
    await session.db.transaction((tx) async {
      await IdentityLocks.email(session, 'course-samples-v1', tx);
      final bootstrap = await AccountAccess.db.findFirstRow(
        session,
        where: (t) => t.developmentBootstrap.equals(true),
        transaction: tx,
      );
      for (var c = 0; c < courseIds.length; c++) {
        final courseId = _uuid(courseIds[c]);
        final existing = await CourseRecord.db.findById(
          session,
          courseId,
          transaction: tx,
        );
        if (existing != null && !existing.seedOwned) {
          throw StateError(
            'A sample course UUID belongs to a non-sample course.',
          );
        }
        if (existing == null) {
          await CourseRecord.db.insertRow(
            session,
            CourseRecord(
              id: courseId,
              title: c == 0
                  ? 'Creative thinking / Творче мислення'
                  : 'Writing with purpose / Усвідомлене письмо',
              category: c == 0 ? 'Arts / Мистецтво' : 'Language / Мови',
              summary: 'Sample course / Приклад курсу',
              teacherName: 'Poodle sample teacher',
              seedOwned: true,
            ),
            transaction: tx,
          );
        }
        if (bootstrap != null &&
            await CourseMembership.db.findFirstRow(
                  session,
                  where: (t) =>
                      t.courseId.equals(courseId) &
                      t.authUserId.equals(bootstrap.authUserId),
                  transaction: tx,
                ) ==
                null) {
          await CourseMembership.db.insertRow(
            session,
            CourseMembership(
              courseId: courseId,
              authUserId: bootstrap.authUserId,
              role: 'teacher',
              active: true,
            ),
            transaction: tx,
          );
        }
        UuidValue sectionKey(int s) => _uuid(
          '019a0acf-0002-7000-8000-${(c * 100 + s + 1).toString().padLeft(12, '0')}',
        );
        for (var s = 0; s < 3; s++) {
          final sectionId = sectionKey(s);
          final section = await CourseSectionRecord.db.findById(
            session,
            sectionId,
            transaction: tx,
          );
          if (section != null && section.courseId != courseId) {
            throw StateError('Sample section UUID collision.');
          }
          if (section == null) {
            await CourseSectionRecord.db.insertRow(
              session,
              CourseSectionRecord(
                id: sectionId,
                courseId: courseId,
                title: [
                  'Information / Інформація',
                  'Learning materials / Навчальні матеріали',
                  'Modules and labs / Модулі та лабораторні',
                ][s],
                sortOrder: s,
                published: true,
              ),
              transaction: tx,
            );
          }
        }
        for (var i = 0; i < 6; i++) {
          final sectionId = sectionKey(
            i < 2
                ? 1
                : i < 4
                ? 0
                : 2,
          );
          final activityId = _uuid(
            '019a0acf-0001-7000-8000-${(c * 100 + i + 1).toString().padLeft(12, '0')}',
          );
          final row = await CourseActivityRecord.db.findById(
            session,
            activityId,
            transaction: tx,
          );
          if (row != null) {
            if (row.sectionId != sectionId) {
              throw StateError('Sample activity UUID collision.');
            }
            continue;
          }
          final record = CourseActivityRecord(
            id: activityId,
            sectionId: sectionId,
            title: '',
            kind: '',
            sortOrder: i,
            published: true,
          );
          if (i < 2) {
            final name = i == 0
                ? 'Halloween-English.pdf'
                : 'Top countries in Europe.docx';
            final data = documents[name];
            // Missing user files do not create broken material records.
            if (data == null) continue;
            final bytes = data.buffer.asUint8List(
              data.offsetInBytes,
              data.lengthInBytes,
            );
            if (bytes.isEmpty ||
                bytes.length > 25 * 1024 * 1024 ||
                (i == 0
                    ? !(bytes.length >= 5 &&
                          String.fromCharCodes(bytes.take(5)) == '%PDF-')
                    : !(bytes.length >= 4 &&
                          bytes[0] == 0x50 &&
                          bytes[1] == 0x4b))) {
              throw ArgumentError('Invalid sample document: $name');
            }
            final checksum = sha256.convert(bytes).toString();
            final path = 'course-samples/$checksum/$name';
            if (!await session.storage.fileExists(
              storageId: 'private',
              path: path,
            )) {
              await session.storage.storeFile(
                storageId: 'private',
                path: path,
                byteData: data,
                options: StoreFileOptions(preventOverwrite: true),
              );
            }
            final stored = await session.storage.retrieveFile(
              storageId: 'private',
              path: path,
            );
            if (sha256
                    .convert(
                      stored.buffer.asUint8List(
                        stored.offsetInBytes,
                        stored.lengthInBytes,
                      ),
                    )
                    .toString() !=
                checksum) {
              throw StateError('Sample object checksum mismatch.');
            }
            record.kind = 'file';
            record.title = i == 0
                ? 'Halloween English'
                : 'Top countries in Europe';
            record.file = CourseFileInfo(
              fileName: name,
              mimeType: i == 0
                  ? 'application/pdf'
                  : 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
              sizeBytes: bytes.length,
              checksum: checksum,
            );
            record.storageId = 'private';
            record.storagePath = path;
          } else if (i == 2) {
            record.kind = 'link';
            record.title =
                'Flutter learning resources / Навчальні ресурси Flutter';
            record.link = CourseLinkInfo(url: 'https://docs.flutter.dev/learn');
          } else if (i == 3) {
            record.kind = 'announcement';
            record.title = 'Welcome / Вітаємо';
            record.announcement = CourseAnnouncementInfo(
              body:
                  'Explore the materials at your own pace. / Опрацьовуйте матеріали у власному темпі.',
              author: 'Poodle sample teacher',
              publishedAt: DateTime.utc(2026, 10, 1),
            );
          } else {
            record.kind = i == 4 ? 'module' : 'lab';
            record.title = i == 4
                ? 'Module 1 / Модуль 1'
                : 'Lab 1 / Лабораторна 1';
            record.assessment = CourseAssessmentInfo(
              instructions:
                  'Read the notes and prepare a short reflection. / Прочитайте нотатки та підготуйте коротку рефлексію.',
              opensAt: i == 4 ? DateTime.utc(2026, 10, 1) : null,
              closesAt: i == 4 ? DateTime.utc(2026, 12, 1) : null,
              attemptLimit: i == 4 ? 1 : null,
              timeLimitMinutes: i == 4 ? 20 : null,
            );
          }
          await CourseActivityRecord.db.insertRow(
            session,
            record,
            transaction: tx,
          );
        }
      }
    });
  }

  static Future<void> fromLocalConfig(Serverpod pod) async {
    if (pod.runMode != ServerpodRunMode.development) return;
    final documents = <String, ByteData>{};
    for (final name in [
      'Halloween-English.pdf',
      'Top countries in Europe.docx',
    ]) {
      final file = File('../poodle_flutter/assets/course_samples/$name');
      if (await file.exists()) {
        documents[name] = ByteData.sublistView(await file.readAsBytes());
      }
    }
    final session = await pod.createSession();
    try {
      await ensure(session, documents: documents);
    } finally {
      await session.close();
    }
  }
}
