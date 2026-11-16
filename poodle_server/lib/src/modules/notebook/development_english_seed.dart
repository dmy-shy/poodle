import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'notebook_repository.dart';

/// Opt-in local course seed. Input documents stay out of version control.
abstract final class DevelopmentEnglishSeed {
  static const _directory = 'local_samples/english_everyday';
  static const _markdown = 'English-Grammar-Mental-Map.md';
  static const _documents = [
    (_markdown, 'English Grammar Mental Map', 'md', 'text/markdown'),
    (
      'Oxford-Guide-to-English-Grammar-pages-001-115.pdf',
      'Oxford Guide to English Grammar (PDF pages 1–115)',
      'pdf',
      'application/pdf',
    ),
    (
      'Oxford-Guide-to-English-Grammar-pages-116-230.pdf',
      'Oxford Guide to English Grammar (PDF pages 116–230)',
      'pdf',
      'application/pdf',
    ),
    (
      'Oxford-Guide-to-English-Grammar-pages-231-345.pdf',
      'Oxford Guide to English Grammar (PDF pages 231–345)',
      'pdf',
      'application/pdf',
    ),
    (
      'Oxford-Guide-to-English-Grammar-pages-346-453.pdf',
      'Oxford Guide to English Grammar (PDF pages 346–453)',
      'pdf',
      'application/pdf',
    ),
  ];

  static UuidValue _id(int suffix) => UuidValue.withValidation(
    '019a0acf-0040-7000-8000-${suffix.toString().padLeft(12, '0')}',
  );

  static Future<void> fromLocalConfig(
    Serverpod pod, {
    required UuidValue teacher,
    required UuidValue student,
  }) async {
    if (pod.runMode != ServerpodRunMode.development ||
        !await Directory(_directory).exists()) {
      return;
    }
    final session = await pod.createSession(enableLogging: false);
    try {
      final outcome = await session.db.transaction((tx) async {
        final courseId = _id(1);
        final repository = NotebookRepository();
        await repository.lock(session, 'course:$courseId', tx);
        // This seed runs once. Reruns preserve membership and teacher edits.
        if (await CourseRecord.db.findById(
              session,
              courseId,
              transaction: tx,
            ) !=
            null) {
          return null;
        }

        final materials = <CourseActivityRecord>[];
        for (final (index, (name, title, format, mime)) in _documents.indexed) {
          final localName = format == 'md' ? '$name.fixture' : name;
          final file = File('$_directory/$localName');
          if (!await file.exists()) {
            return 'English: everyday seed skipped: missing $localName.';
          }
          final size = await file.length();
          if (size == 0 || size > 25 * 1024 * 1024) {
            return 'English: everyday seed skipped: invalid file size for $name.';
          }
          final bytes = await file.readAsBytes();
          if (format == 'pdf' &&
              String.fromCharCodes(bytes.take(5)) != '%PDF-') {
            return 'English: everyday seed skipped: invalid PDF signature for $name.';
          }
          final checksum = sha256.convert(bytes).toString();
          final path = 'notebook-samples/english-everyday/$checksum/$name';
          if (!await session.storage.fileExists(
            storageId: 'private',
            path: path,
          )) {
            await session.storage.storeFile(
              storageId: 'private',
              path: path,
              byteData: ByteData.sublistView(bytes),
              options: StoreFileOptions(preventOverwrite: true),
            );
          }
          materials.add(
            CourseActivityRecord(
              id: _id(10 + index),
              sectionId: _id(2),
              title: title,
              kind: 'file',
              sortOrder: index,
              published: true,
              storageId: 'private',
              storagePath: path,
              file: CourseFileInfo(
                fileName: name,
                mimeType: mime,
                sizeBytes: bytes.length,
                checksum: checksum,
              ),
            ),
          );
        }

        await CourseRecord.db.insertRow(
          session,
          CourseRecord(
            id: courseId,
            title: 'English: everyday',
            category: 'Language / Мови',
            summary:
                'Practice everyday English grammar with study notes and a reference guide.',
            seedOwned: true,
          ),
          transaction: tx,
        );
        await CourseMembership.db.insert(session, [
          CourseMembership(
            courseId: courseId,
            authUserId: student,
            role: 'student',
            active: true,
          ),
          CourseMembership(
            courseId: courseId,
            authUserId: teacher,
            role: 'teacher',
            active: true,
          ),
        ], transaction: tx);
        await CourseSectionRecord.db.insertRow(
          session,
          CourseSectionRecord(
            id: _id(2),
            courseId: courseId,
            title: 'Everyday grammar',
            sortOrder: 0,
            published: true,
          ),
          transaction: tx,
        );
        await CourseActivityRecord.db.insert(session, [
          ...materials,
          CourseActivityRecord(
            id: _id(3),
            sectionId: _id(2),
            title: 'Grammar practice',
            kind: 'test',
            sortOrder: materials.length,
            published: true,
            assessment: CourseAssessmentInfo(
              instructions:
                  'Open Notebook and compare how the two references explain a grammar topic.',
            ),
          ),
        ], transaction: tx);
        final config = await NotebookAssessmentConfigRecord.db.insertRow(
          session,
          NotebookAssessmentConfigRecord(
            courseId: courseId,
            assessmentActivityId: _id(3),
            teacherUserId: teacher,
            allowedFormats: ['txt', 'md', 'pdf'],
          ),
          transaction: tx,
        );
        for (final (index, material) in materials.indexed) {
          final file = material.file!;
          final format = _documents[index].$3;
          await NotebookAssessmentMaterialRecord.db.insertRow(
            session,
            NotebookAssessmentMaterialRecord(
              configId: config.id!,
              activityId: material.id!,
              sortOrder: index,
            ),
            transaction: tx,
          );
          final source = await NotebookSourceRecord.db.insertRow(
            session,
            NotebookSourceRecord(
              courseId: courseId,
              activityId: material.id!,
              fileName: file.fileName,
              format: format,
              storageId: 'private',
              storagePath: material.storagePath!,
            ),
            transaction: tx,
          );
          await NotebookJobRecord.db.insertRow(
            session,
            NotebookJobRecord(
              ownerUserId: teacher,
              sourceId: source.id!,
              jobType: 'ingest',
              requestKey: 'ingest:${source.id}:${file.checksum}',
              privatePayload: jsonEncode({
                'checksum': file.checksum,
                'format': format,
                'storageId': 'private',
                'storagePath': material.storagePath,
                'sizeBytes': file.sizeBytes,
              }),
            ),
            transaction: tx,
          );
        }
        return 'Seeded English: everyday with student and teacher memberships '
            'and ${materials.length} queued Notebook sources.';
      });
      if (outcome != null) {
        final logSession = await pod.createSession();
        try {
          logSession.log(outcome);
        } finally {
          await logSession.close();
        }
      }
    } finally {
      await session.close();
    }
  }
}
