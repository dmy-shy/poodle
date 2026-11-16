/// Shared server/worker configuration. No credential is sent to Flutter.
class SearchConfiguration {
  SearchConfiguration({
    required Map<String, String> environment,
    required String? Function(String name) password,
  }) : apiKey =
           _nonEmpty(environment['OPENAI_API_KEY']) ??
           _nonEmpty(password('openAiApiKey')),
       enabled =
           environment['POODLE_SEMANTIC_SEARCH_ENABLED']
               ?.trim()
               .toLowerCase() !=
           'false';

  final String? apiKey;
  final bool enabled;
  bool get available => enabled && apiKey != null;

  static String? _nonEmpty(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
