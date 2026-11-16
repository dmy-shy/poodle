# Poodle

Poodle is an English/Ukrainian learning management app for students, teachers, and university administrators.

1. Install Flutter 3.47.4 (with Dart 3.13.3; pinned in `.fvmrc`) and Serverpod CLI 4.0.4.
2. From the repository root, run `flutter pub get --enforce-lockfile`.
3. Set up local configuration using the [server guide](docs/development/server.md).
4. From `poodle_server/`, run `serverpod start`. It launches the configured Flutter companion app.
5. To work on notebook processing or search indexing, start the [worker](poodle_worker/README.md) separately.

For a standalone UI demo, follow the [preview instructions](poodle_flutter/README.md). For account access, see the [user guide](docs/guides/getting-started.md).

Run `dart analyze` from the root, `flutter test` from `poodle_flutter/`, and `dart test` from each of `poodle_server/` and `poodle_worker/`. See the [testing guide](docs/development/TESTING.md) for prerequisites.

[Documentation](docs/README.md) · [Current status](docs/status/STATUS.md)
