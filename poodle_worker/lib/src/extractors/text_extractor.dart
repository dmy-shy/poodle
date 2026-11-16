import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class NotebookIngestionException implements Exception {
  const NotebookIngestionException(this.code, {this.retryable = false});
  final String code;
  final bool retryable;

  @override
  String toString() => 'NotebookIngestionException($code)';
}

class ExtractedNotebookBlock {
  const ExtractedNotebookBlock(this.id, this.text, {this.page});
  final String id;
  final String text;
  final int? page;
}

abstract interface class NotebookExtractor {
  FutureOr<List<ExtractedNotebookBlock>> extract(
    ByteData data, {
    required String format,
    required String checksum,
    required int expectedSize,
  });
}

/// Strict UTF-8 only. Markdown stays inert text; imported HTML is never run.
/// Binary/office/PDF extraction requires a separate bounded native adapter.
class NotebookTextExtractor implements NotebookExtractor {
  const NotebookTextExtractor();
  static const maximumBytes = 25 * 1024 * 1024;
  static const maximumCharacters = 500000;

  static Uint8List validatedBytes(
    ByteData data, {
    required String checksum,
    required int expectedSize,
  }) {
    if (data.lengthInBytes == 0 ||
        data.lengthInBytes > maximumBytes ||
        data.lengthInBytes != expectedSize) {
      throw const NotebookIngestionException('invalid_size');
    }
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    if (sha256.convert(bytes).toString() != checksum) {
      throw const NotebookIngestionException('checksum_mismatch');
    }
    return bytes;
  }

  @override
  List<ExtractedNotebookBlock> extract(
    ByteData data, {
    required String format,
    required String checksum,
    required int expectedSize,
  }) {
    final bytes = validatedBytes(
      data,
      checksum: checksum,
      expectedSize: expectedSize,
    );
    if (!{'txt', 'md'}.contains(format)) {
      throw const NotebookIngestionException('unsupported_format');
    }
    final String decoded;
    try {
      decoded = utf8.decode(bytes);
    } on FormatException {
      throw const NotebookIngestionException('invalid_encoding');
    }
    if (decoded.length > maximumCharacters ||
        RegExp(r'[\x00-\x08\x0b\x0e-\x1f\x7f]').hasMatch(decoded) ||
        decoded.startsWith('%PDF-') ||
        decoded.startsWith('PK\u0003\u0004') ||
        decoded.startsWith('MZ')) {
      throw const NotebookIngestionException('invalid_text');
    }
    final normalized = decoded
        .replaceFirst(RegExp(r'^\uFEFF'), '')
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .trim();
    if (normalized.isEmpty) {
      throw const NotebookIngestionException('empty_source');
    }
    final paragraphs = normalized.split(RegExp(r'\n[ \t]*\n+'));
    return List.unmodifiable([
      for (var i = 0; i < paragraphs.length; i++)
        ExtractedNotebookBlock('block-${i + 1}', paragraphs[i].trim()),
    ]);
  }
}
