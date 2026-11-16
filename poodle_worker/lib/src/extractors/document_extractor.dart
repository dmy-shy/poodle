import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'text_extractor.dart';

/// Binary documents are parsed in a resource-limited process without worker
/// credentials. Only original private bytes and fixed tool arguments cross it.
class NotebookDocumentExtractor implements NotebookExtractor {
  const NotebookDocumentExtractor({
    this.pythonExecutable = 'python3',
    this.pdfInfoExecutable = 'pdfinfo',
    this.pdfTextExecutable = 'pdftotext',
    this.pdfRasterExecutable = 'pdftoppm',
    this.tesseractExecutable = 'tesseract',
    this.timeout = const Duration(seconds: 180),
  });

  final String pythonExecutable;
  final String pdfInfoExecutable;
  final String pdfTextExecutable;
  final String pdfRasterExecutable;
  final String tesseractExecutable;
  final Duration timeout;

  @override
  Future<List<ExtractedNotebookBlock>> extract(
    ByteData data, {
    required String format,
    required String checksum,
    required int expectedSize,
  }) async {
    final bytes = NotebookTextExtractor.validatedBytes(
      data,
      checksum: checksum,
      expectedSize: expectedSize,
    );
    if ({'txt', 'md'}.contains(format)) {
      return const NotebookTextExtractor().extract(
        data,
        format: format,
        checksum: checksum,
        expectedSize: expectedSize,
      );
    }
    if (!{'pdf', 'docx'}.contains(format)) {
      throw const NotebookIngestionException('unsupported_format');
    }
    final signature = format == 'pdf' ? [37, 80, 68, 70, 45] : [80, 75, 3, 4];
    if (bytes.length < signature.length ||
        !List.generate(
          signature.length,
          (i) => bytes[i] == signature[i],
        ).every((v) => v)) {
      throw const NotebookIngestionException('signature_mismatch');
    }
    final helper = await Isolate.resolvePackageUri(
      Uri.parse('package:poodle_worker/src/extractors/extract_document.py'),
    );
    if (helper == null) {
      throw const NotebookIngestionException('extractor_not_configured');
    }
    final directory = await Directory.systemTemp.createTemp('poodle-extract-');
    Process? process;
    StreamSubscription<List<int>>? stdoutDrain;
    StreamSubscription<List<int>>? stderrDrain;
    try {
      final input = File('${directory.path}/source.$format');
      final output = File('${directory.path}/result.json');
      await input.writeAsBytes(bytes, flush: true);
      process = await Process.start(
        pythonExecutable,
        [
          '-I',
          helper.toFilePath(),
          input.path,
          output.path,
          format,
          pdfInfoExecutable,
          pdfTextExecutable,
          pdfRasterExecutable,
          tesseractExecutable,
        ],
        includeParentEnvironment: false,
        environment: {
          'PATH': Platform.environment['PATH'] ?? '/usr/bin:/bin',
          'LANG': 'C.UTF-8',
          'LC_ALL': 'C',
        },
        workingDirectory: directory.path,
      );
      stdoutDrain = process.stdout.listen((_) {});
      stderrDrain = process.stderr.listen((_) {});
      await process.exitCode.timeout(timeout);
      if (!await output.exists() || await output.length() > 4 * 1024 * 1024) {
        throw const NotebookIngestionException('extraction_failed');
      }
      final result = jsonDecode(await output.readAsString()) as Map;
      if (result['error'] case final String code) {
        const safeCodes = {
          'invalid_document',
          'encrypted_document',
          'active_content',
          'extraction_limit',
          'empty_source',
          'extractor_not_configured',
          'extraction_timeout',
        };
        throw NotebookIngestionException(
          safeCodes.contains(code) ? code : 'extraction_failed',
        );
      }
      final blocks = <ExtractedNotebookBlock>[];
      var characters = 0;
      for (final raw in result['blocks'] as List) {
        final row = raw as Map;
        final text = (row['text'] as String)
            .replaceAll('\r\n', '\n')
            .replaceAll('\r', '\n')
            .trim();
        characters += text.length;
        if (characters > NotebookTextExtractor.maximumCharacters ||
            blocks.length >= 10000 ||
            RegExp(r'[\x00-\x08\x0b\x0e-\x1f\x7f]').hasMatch(text)) {
          throw const NotebookIngestionException('extraction_limit');
        }
        if (text.isNotEmpty) {
          blocks.add(
            ExtractedNotebookBlock(
              row['id'] as String,
              text,
              page: row['page'] as int?,
            ),
          );
        }
      }
      if (blocks.isEmpty) {
        throw const NotebookIngestionException('empty_source');
      }
      return List.unmodifiable(blocks);
    } on TimeoutException {
      throw const NotebookIngestionException('extraction_timeout');
    } on ProcessException {
      throw const NotebookIngestionException('extractor_not_configured');
    } on FormatException {
      throw const NotebookIngestionException('extraction_failed');
    } finally {
      if (process != null) {
        process.kill();
        try {
          await process.exitCode.timeout(const Duration(seconds: 2));
        } on TimeoutException {
          process.kill(ProcessSignal.sigkill);
          await process.exitCode;
        }
      }
      await stdoutDrain?.cancel();
      await stderrDrain?.cancel();
      await directory.delete(recursive: true);
    }
  }
}
