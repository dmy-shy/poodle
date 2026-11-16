# Flutter & Serverpod project

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `poodle_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `poodle_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.

## Current Poodle state

Poodle is a bilingual English/Ukrainian LMS. Follow docs/architecture/ARCHITECTURE.md and docs/development/TESTING.md;
docs/status/STATUS.md is the current implementation inventory. `lib/main.dart` composes live
Serverpod-backed authentication, institutions, courses, teaching, notebook, search,
messaging, notifications and student-learning repositories. Serverpod's built-in
email provider and JWT manager remain the auth base; optional Google login/link
is implemented. The explicit `lib/main_preview.dart` entry point retains
simulated authentication and fixture content labeled Feature preview. Historical
milestone specs and task results describe their own verification dates, not the
current whole-app acceptance state.

Views and ChangeNotifier ViewModels live in `lib/features/auth/`; repository contracts
and the fake live in `lib/data/repositories/`. The app composition/router and generated
ARB localization output live in `lib/app/`; shared Material 3 themes in `lib/ui/theme/`.
The current app uses the light theme only, regardless of device brightness.
The primary system language selects Ukrainian (`uk`) or English (`en`); all others
fall back to English. Splash quotes follow the app language and are selected once per launch.

Use `PREVIEW_SCENARIO` to select normal, invalidCredentials, networkFailure,
googleCancelled, resetFailure, or restoredSession. These are UI-only scenarios.
Unit/widget tests and visual baselines are under `poodle_flutter/test/`.
Keep Serverpod auth work behind AuthRepository and follow the MCP rules above.

## Onboarding stories

Follow docs/specs/SPEC-onboarding.md for the original design. Five local English/Ukrainian
feature stories currently appear after
splash on the first signed-out launch. Skip/Get started save an installation-level
completion flag with shared_preferences; logout does not reset it. Restored sessions
go directly to the live Home (or preview Home in `main_preview.dart`). The tour
does not grant feature access; the preview entry point retains its Feature preview
labels.

Story Views/widgets/ViewModel are under lib/features/onboarding/. Completion storage
lives behind OnboardingRepository and OnboardingStore. Frame progress stays local
to the View; the ViewModel schedules story boundaries and independent pause reasons.
Reduced motion/accessibility uses manual playback. The app remains light-only.

Use --dart-define=ONBOARDING_PREVIEW=true for a fresh, nonpersistent tour without
changing real preferences. Non-normal PREVIEW_SCENARIO cases bypass the tour unless
that override is set. Preserve the Serverpod MCP runtime workflow above.
