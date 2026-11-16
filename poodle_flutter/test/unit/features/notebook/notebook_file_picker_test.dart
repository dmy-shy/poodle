import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/services/notebook_file_picker.dart';

void main() {
  test('all notebook formats have iOS types as well as file extensions', () {
    final group = NotebookFilePicker.acceptedTypes([
      'txt',
      'md',
      'pdf',
      'docx',
    ]);

    expect(group.extensions, ['txt', 'md', 'pdf', 'docx']);
    expect(group.uniformTypeIdentifiers, [
      'public.plain-text',
      'net.daringfireball.markdown',
      'com.adobe.pdf',
      'org.openxmlformats.wordprocessingml.document',
    ]);
  });
}
