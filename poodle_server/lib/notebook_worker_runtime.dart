import 'dart:io';

import 'package:serverpod/serverpod.dart'
    show DatabaseCloudStorage, Session, ServerpodConfig;
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'src/generated/serverpod.dart' as generated;

/// Database/storage host for a trusted worker. Does not start API listeners,
/// apply migrations, initialize authentication, or run development seeds.
class NotebookWorkerRuntime {
  NotebookWorkerRuntime._(this._pod);
  final generated.Serverpod _pod;

  static Future<NotebookWorkerRuntime> open({
    required Directory serverDirectory,
    required String mode,
    ServerpodConfig Function(ServerpodConfig)? configOverride,
  }) async {
    final pod = generated.Serverpod(
      [
        '--mode',
        mode,
      ],
      serverDirectory: serverDirectory,
      configOverride: configOverride,
    );
    pod.addCloudStorage(
      await ServerpodCloudProvider.private(
        fallback: () => DatabaseCloudStorage('private'),
      ),
    );
    return NotebookWorkerRuntime._(pod);
  }

  String? getPassword(String name) => _pod.getPassword(name);

  Future<Session> createSession() => _pod.createSession(enableLogging: false);
  Future<void> close() => _pod.shutdown(exitProcess: false);
}
