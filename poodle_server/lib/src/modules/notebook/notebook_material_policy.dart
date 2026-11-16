import '../../generated/protocol.dart';

/// Shared eligibility checks for teacher choices and source registration.
abstract final class NotebookMaterialPolicy {
  static String format(CourseActivityRecord activity) {
    final file = activity.file;
    const mimeTypes = {
      'pdf': 'application/pdf',
      'txt': 'text/plain',
      'md': 'text/markdown',
      'docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    };
    final format = file?.fileName.split('.').last.toLowerCase();
    if (activity.kind != 'file' ||
        file == null ||
        !mimeTypes.containsKey(format) ||
        mimeTypes[format] != file.mimeType ||
        file.sizeBytes <= 0 ||
        file.sizeBytes > 25 * 1024 * 1024 ||
        file.checksum.isEmpty ||
        activity.storageId != 'private' ||
        activity.storagePath == null ||
        activity.storagePath!.isEmpty) {
      throw NotebookError(code: 'invalid_configuration');
    }
    return format!;
  }
}
