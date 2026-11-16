import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:poodle_worker/poodle_worker.dart';
import 'package:test/test.dart';

void main() {
  const extractor = NotebookTextExtractor();
  List<ExtractedNotebookBlock> extract(
    List<int> bytes, {
    String format = 'txt',
    String? checksum,
    int? size,
  }) => extractor.extract(
    ByteData.sublistView(Uint8List.fromList(bytes)),
    format: format,
    checksum: checksum ?? sha256.convert(bytes).toString(),
    expectedSize: size ?? bytes.length,
  );
  Matcher code(String value) => throwsA(
    isA<NotebookIngestionException>().having((e) => e.code, 'code', value),
  );

  test(
    'normalizes English/Ukrainian paragraphs and keeps stable block locations',
    () {
      final result = extract(
        utf8.encode('\uFEFFEnglish\r\n\r\nУкраїнська\r\ntext\r'),
      );
      expect(result.map((b) => b.text), ['English', 'Українська\ntext']);
      expect(result.map((b) => b.id), ['block-1', 'block-2']);
    },
  );
  test('honors ByteData offset and keeps Markdown/HTML inert', () {
    final bytes = utf8.encode('# Notes\n\n<script>untrusted()</script>');
    final padded = Uint8List.fromList([0, ...bytes, 0]);
    final result = extractor.extract(
      ByteData.sublistView(padded, 1, padded.length - 1),
      format: 'md',
      checksum: sha256.convert(bytes).toString(),
      expectedSize: bytes.length,
    );
    expect(result.last.text, '<script>untrusted()</script>');
  });
  test('rejects checksum and declared size mismatches', () {
    expect(() => extract([65], checksum: 'wrong'), code('checksum_mismatch'));
    expect(() => extract([65], size: 2), code('invalid_size'));
    expect(() => extract([]), code('invalid_size'));
  });
  test(
    'rejects malformed UTF-8, binary controls and disguised binary signatures',
    () {
      expect(() => extract([0xff]), code('invalid_encoding'));
      for (final value in [
        'a\u0000b',
        '%PDF-file',
        'PK\u0003\u0004data',
        'MZbinary',
      ]) {
        expect(() => extract(utf8.encode(value)), code('invalid_text'));
      }
    },
  );
  test('enforces text expansion and empty text limits', () {
    expect(() => extract(utf8.encode('a' * 500001)), code('invalid_text'));
    expect(() => extract(utf8.encode('  \n\t')), code('empty_source'));
  });
  test('does not claim PDF or DOCX extraction support', () {
    for (final format in ['pdf', 'docx', 'exe']) {
      expect(() => extract([65], format: format), code('unsupported_format'));
    }
  });
}
