/// Pure policy rules for assessment notebooks.
///
/// Keep these checks independent of database models so the worker, endpoints,
/// and tests can use the same boundary rules.
abstract final class NotebookPolicy {
  static const defaultMonthlyCapMicros = 10_000_000;
  static const maximumMonthlyCapMicros = 30_000_000;
  static const supportedUploadFormats = {'pdf', 'txt', 'md', 'docx'};

  static bool validDefaultMaterials({
    required String targetCourseId,
    required List<NotebookMaterialPolicyInput> materials,
  }) {
    if (targetCourseId.isEmpty || materials.isEmpty) return false;
    final seen = <String>{};
    for (final material in materials) {
      if (material.id.isEmpty ||
          !seen.add(material.id) ||
          material.courseId != targetCourseId ||
          !material.published ||
          !material.isFile) {
        return false;
      }
    }
    return true;
  }

  static List<String> normalizeFormats(Iterable<String> formats) {
    final normalized =
        formats
            .map((format) => format.trim().toLowerCase().replaceFirst('.', ''))
            .where((format) => format.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    if (normalized.any((format) => !supportedUploadFormats.contains(format))) {
      throw ArgumentError.value(
        formats,
        'formats',
        'Unsupported upload format',
      );
    }
    return List.unmodifiable(normalized);
  }

  /// Costs are represented as millionths of one US dollar.
  static bool canReserveMicros({
    required int spentMicros,
    required int reservedMicros,
    required int requestMicros,
    required int configuredCapMicros,
  }) {
    if (spentMicros < 0 || reservedMicros < 0 || requestMicros <= 0) {
      return false;
    }
    if (!validConfiguredCapMicros(configuredCapMicros)) return false;
    return spentMicros + reservedMicros + requestMicros <= configuredCapMicros;
  }

  static bool validConfiguredCapMicros(int value) =>
      value > 0 && value <= maximumMonthlyCapMicros;
}

class NotebookMaterialPolicyInput {
  const NotebookMaterialPolicyInput({
    required this.id,
    required this.courseId,
    required this.published,
    required this.isFile,
  });

  final String id;
  final String courseId;
  final bool published;
  final bool isFile;
}
