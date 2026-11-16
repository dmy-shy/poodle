import 'dart:io';
import 'dart:typed_data';
import 'text_extractor.dart';

/// Fail closed when the scanner or its signatures are unavailable.
Future<void> scanNotebookUpload(
  Uint8List bytes, {
  String? executable,
  String? database,
  Duration timeout = const Duration(seconds: 90),
}) async {
  final directory = await Directory.systemTemp.createTemp('poodle-scan-');
  Process? process;
  try {
    final file = File('${directory.path}/upload');
    await file.writeAsBytes(bytes, flush: true);
    process = await Process.start(
      executable ?? Platform.environment['NOTEBOOK_CLAMSCAN'] ?? 'clamscan',
      [
        '--quiet',
        '--no-summary',
        '--max-filesize=25M',
        '--max-scansize=64M',
        '--max-recursion=12',
        '--max-files=2000',
        '--alert-exceeds-max=yes',
        '--alert-encrypted=yes',
        '--alert-macros=yes',
        '--fail-if-cvd-older-than=7',
        if ((database ?? Platform.environment['NOTEBOOK_CLAMAV_DATABASE'])
            case final String database)
          '--database=$database',
        file.path,
      ],
      includeParentEnvironment: false,
      environment: {'PATH': Platform.environment['PATH'] ?? '/usr/bin:/bin'},
    );
    final stdoutDone = process.stdout.drain<void>();
    final stderrDone = process.stderr.drain<void>();
    final code = await process.exitCode.timeout(timeout);
    await Future.wait([stdoutDone, stderrDone]);
    if (code != 0) {
      throw NotebookIngestionException(
        code == 1 ? 'unsafe_upload' : 'scanner_unavailable',
      );
    }
  } on NotebookIngestionException {
    rethrow;
  } catch (_) {
    throw const NotebookIngestionException('scanner_unavailable');
  } finally {
    process?.kill(ProcessSignal.sigkill);
    await directory.delete(recursive: true);
  }
}
