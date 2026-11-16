import 'dart:io';
import 'dart:typed_data';
import 'package:poodle_worker/src/extractors/upload_scanner.dart';
import 'package:poodle_worker/poodle_worker.dart';
import 'package:test/test.dart';

void main() {
  test(
    'scanner exit codes fail closed and remove temporary private files',
    () async {
      final fixture = await Directory.systemTemp.createTemp(
        'poodle-scanner-test-',
      );
      addTearDown(() => fixture.delete(recursive: true));
      for (final code in [0, 1, 2]) {
        final script = File('${fixture.path}/scanner-$code');
        final observed = File('${fixture.path}/path-$code');
        await script.writeAsString(
          '#!/bin/sh\nfor argument in "\$@"; do last="\$argument"; done\nprintf "%s" "\$last" > "${observed.path}"\nexit $code\n',
        );
        await Process.run('chmod', ['700', script.path]);
        final result = scanNotebookUpload(
          Uint8List.fromList([1]),
          executable: script.path,
        );
        if (code == 0) {
          await result;
        } else {
          await expectLater(
            result,
            throwsA(
              isA<NotebookIngestionException>().having(
                (e) => e.code,
                'safe code',
                code == 1 ? 'unsafe_upload' : 'scanner_unavailable',
              ),
            ),
          );
        }
        expect(await File(await observed.readAsString()).exists(), isFalse);
      }
    },
  );
  test('missing scanner never accepts an upload', () async {
    await expectLater(
      scanNotebookUpload(
        Uint8List.fromList([1]),
        executable: '/nonexistent/poodle-clamscan',
      ),
      throwsA(
        isA<NotebookIngestionException>().having(
          (e) => e.code,
          'code',
          'scanner_unavailable',
        ),
      ),
    );
  });
}
