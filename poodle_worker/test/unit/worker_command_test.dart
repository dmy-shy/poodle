import 'dart:io';
import 'package:test/test.dart';

void main() {
  test(
    'missing configuration exits before opening storage or making provider requests',
    () async {
      final result = await Process.run(
        Platform.resolvedExecutable,
        ['run', 'bin/main.dart', '--once'],
        includeParentEnvironment: false,
        environment: {
          'PATH': Platform.environment['PATH'] ?? '',
          'HOME': Platform.environment['HOME'] ?? '',
        },
      );
      expect(result.exitCode, 64);
      expect(result.stderr.toString(), contains('Configure OPENAI_API_KEY'));
      expect(result.stdout.toString(), isNot(contains('SERVERPOD')));
    },
  );
}
