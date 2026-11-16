import 'package:poodle_server/src/modules/search/search_configuration.dart';
import 'package:test/test.dart';

void main() {
  test('uses Serverpod passwords and enables configured semantic search', () {
    final config = SearchConfiguration(
      environment: {},
      password: (name) => name == 'openAiApiKey' ? ' test-password ' : null,
    );
    expect(config.apiKey, 'test-password');
    expect(config.available, isTrue);
  });

  test(
    'environment overrides passwords and explicit false disables search',
    () {
      final config = SearchConfiguration(
        environment: {
          'OPENAI_API_KEY': 'environment-value',
          'POODLE_SEMANTIC_SEARCH_ENABLED': ' FALSE ',
        },
        password: (_) => 'password-value',
      );
      expect(config.apiKey, 'environment-value');
      expect(config.available, isFalse);
    },
  );

  test('missing or blank credentials leave keyword search available', () {
    final config = SearchConfiguration(
      environment: {'OPENAI_API_KEY': ' '},
      password: (_) => null,
    );
    expect(config.available, isFalse);
    expect(config.apiKey, isNull);
  });
}
