import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';

class NotebookPickedFile {
  const NotebookPickedFile(this.name, this.bytes);
  final String name;
  final Uint8List bytes;
}

class NotebookFilePicker {
  const NotebookFilePicker();
  static const maximumBytes = 25 * 1024 * 1024;
  static const _iosTypes = {
    'txt': 'public.plain-text',
    'md': 'net.daringfireball.markdown',
    'pdf': 'com.adobe.pdf',
    'docx': 'org.openxmlformats.wordprocessingml.document',
  };

  static XTypeGroup acceptedTypes(List<String> formats) => XTypeGroup(
    label: 'Documents',
    extensions: formats,
    uniformTypeIdentifiers: [
      for (final format in formats) ?_iosTypes[format],
    ],
  );

  Future<NotebookPickedFile?> pick(List<String> formats) async {
    final file = await openFile(
      acceptedTypeGroups: [acceptedTypes(formats)],
    );
    if (file == null) return null;
    final size = await file.length();
    if (size <= 0 || size > maximumBytes) {
      throw const FormatException('invalid_upload');
    }
    final builder = BytesBuilder(copy: false);
    await for (final chunk in file.openRead()) {
      if (builder.length + chunk.length > maximumBytes) {
        throw const FormatException('invalid_upload');
      }
      builder.add(chunk);
    }
    final bytes = builder.takeBytes();
    if (bytes.length != size) throw const FormatException('invalid_upload');
    return NotebookPickedFile(file.name, bytes);
  }
}
