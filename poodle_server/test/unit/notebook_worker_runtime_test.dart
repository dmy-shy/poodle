import 'dart:io';
import 'package:poodle_server/notebook_worker_runtime.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  test(
    'background runtime opens a private database session without API listeners',
    () async {
      // Own the test engine rather than stopping the engine used concurrently
      // by Serverpod's integration helpers when this runtime shuts down.
      final directory = await Directory.systemTemp.createTemp(
        'poodle-runtime-test-',
      );
      final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final port = socket.port;
      await socket.close();
      final runtime = await NotebookWorkerRuntime.open(
        serverDirectory: Directory.current,
        mode: 'test',
        configOverride: (config) => config.copyWith(
          database: DatabaseConfig(
            host: 'localhost',
            port: port,
            user: 'postgres',
            password: config.database!.password,
            name: 'postgres',
            dataPath: '${directory.path}/pgdata',
          ),
        ),
      );
      try {
        final session = await runtime.createSession();
        try {
          expect(session.enableLogging, false);
          final result = await session.db.unsafeQuery('SELECT 1');
          expect(result.single.single, 1);
        } finally {
          await session.close();
        }
      } finally {
        await runtime.close();
        await directory.delete(recursive: true);
      }
    },
  );
}
