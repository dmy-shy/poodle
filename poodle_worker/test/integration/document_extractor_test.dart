import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:poodle_worker/poodle_worker.dart';
import 'package:test/test.dart';

void main() {
  final extractor = NotebookDocumentExtractor(
    pdfInfoExecutable:
        Platform.environment['NOTEBOOK_PDFINFO_EXECUTABLE'] ?? 'pdfinfo',
    pdfTextExecutable:
        Platform.environment['NOTEBOOK_PDFTOTEXT_EXECUTABLE'] ?? 'pdftotext',
  );
  Future<List<ExtractedNotebookBlock>> extract(
    String name, {
    NotebookExtractor? using,
  }) async {
    final bytes = await File('test/fixtures/$name').readAsBytes();
    return await (using ?? extractor).extract(
      ByteData.sublistView(bytes),
      format: name.split('.').last,
      checksum: sha256.convert(bytes).toString(),
      expectedSize: bytes.length,
    );
  }

  Matcher code(String value) => throwsA(
    isA<NotebookIngestionException>().having((e) => e.code, 'code', value),
  );

  test('real Poppler extracts bilingual text with page citations', () async {
    final blocks = await extract('study.pdf');
    expect(blocks.map((b) => b.page), [1, 2]);
    expect(blocks.first.text, contains('source version'));
    expect(blocks.last.text, contains('Посилання визначає версію'));
  });
  test('scanned PDF is OCRed and keeps its page citation', () async {
    final blocks = await extract('scanned_study.pdf');
    expect(blocks.map((b) => b.page), [1]);
    expect(blocks.single.text.toLowerCase(), contains('citation identifies'));
  });
  test('Ukrainian scanned PDF is OCRed', () async {
    final blocks = await extract('scanned_study_uk.pdf');
    expect(blocks.map((b) => b.page), [1]);
    expect(blocks.single.text.toLowerCase(), contains('посилання'));
  });
  test('mixed PDF preserves text pages and OCR page locations', () async {
    final blocks = await extract('mixed_study.pdf');
    expect(blocks.map((b) => b.page), [1, 2, 3]);
    expect(blocks.last.text.toLowerCase(), contains('citation identifies'));
  });
  test(
    'DOCX extracts bilingual paragraphs and table cells in document order',
    () async {
      final blocks = await extract('study.docx');
      expect(blocks.map((b) => b.id), [
        'paragraph-1',
        'paragraph-2',
        'paragraph-3',
      ]);
      expect(blocks[1].text, 'Посилання визначає версію джерела.');
      expect(blocks.last.text, 'Table evidence');
    },
  );
  test('encrypted and empty PDFs fail explicitly', () async {
    await expectLater(extract('encrypted.pdf'), code('encrypted_document'));
    await expectLater(extract('empty.pdf'), code('empty_source'));
  });
  test(
    'DOCX rejects macros, external relationships, traversal, entities and expansion bombs',
    () async {
      for (final entry in {
        'macro.docx': 'active_content',
        'external.docx': 'active_content',
        'traversal.docx': 'invalid_document',
        'entity.docx': 'active_content',
        'bomb.docx': 'extraction_limit',
      }.entries) {
        await expectLater(extract(entry.key), code(entry.value));
      }
    },
  );
  test(
    'missing native tool and process timeout produce safe failure codes',
    () async {
      await expectLater(
        extract(
          'study.pdf',
          using: const NotebookDocumentExtractor(
            pdfInfoExecutable: '/nonexistent/poodle-pdfinfo',
          ),
        ),
        code('extractor_not_configured'),
      );
      await expectLater(
        extract(
          'scanned_study.pdf',
          using: const NotebookDocumentExtractor(
            tesseractExecutable: '/nonexistent/poodle-tesseract',
          ),
        ),
        code('extractor_not_configured'),
      );
      await expectLater(
        extract(
          'study.docx',
          using: const NotebookDocumentExtractor(
            timeout: Duration(microseconds: 1),
          ),
        ),
        code('extraction_timeout'),
      );
    },
  );
}
