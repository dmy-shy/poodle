import 'dart:io';

import 'package:poodle_server/notebook_worker_runtime.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// Read-only, redacted status for recent notebook worker jobs.
Future<void> main() async {
  final runtime = await NotebookWorkerRuntime.open(
    serverDirectory: Directory('../poodle_server'),
    mode: 'development',
  );
  try {
    final session = await runtime.createSession();
    try {
      final jobs = await NotebookJobRecord.db.find(
        session,
        orderBy: (t) => t.createdAt.desc(),
        limit: 20,
      );
      for (final job in jobs) {
        stdout.writeln(
          '${job.createdAt.toIso8601String()} '
          'type=${job.jobType} status=${job.status} attempts=${job.attempts} '
          'failure=${job.failureCode ?? '-'}',
        );
      }
    } finally {
      await session.close();
    }
  } finally {
    await runtime.close();
  }
}
