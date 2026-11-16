# Backend platform implementation

Specification: [SPEC-backend-platform.md](../../specs/SPEC-backend-platform.md).
The user requested implementation on 2026-10-22, authorizing execution of this
module. Google authentication remains a future extension. Existing onboarding
plan/task records are preserved.

## Plan and tasks

- [x] Inspect Serverpod's installed database/test APIs and the existing migration
  registry. Confirm the template configuration already supplies the required
  connection management. Verify the existing greeting test as a baseline.
- [x] Add a database integration suite covering isolated PostgreSQL access,
  current migrations, committed ORM persistence, UTC timestamps, and failed
  transaction rollback/recovery. Reuse the built-in test table; add no model or
  migration.
- [x] Replace template server documentation with the database/runtime workflow
  and clarify development/test configuration comments.
- [x] Run analysis, formatting, targeted and full server tests, and executable
  compilation. Record actual results and runtime MCP limitations.

## Scope

This implements `backend-platform`. Role checks, invitation-gated authentication,
the development/test admin seed, course memberships, and course content remain
the following modules listed in the approved capability map. No new connection
adapter, public database route, schema, dependency, or generated-code edit is
needed for this module.

## Verification

All commands ran from `poodle_server/` using the installed SDK at
`/Users/mac/Documents/flutter/bin/cache/dart-sdk/bin/dart` through `rtk proxy`:

- `dart analyze`: no issues.
- `dart format test/integration/backend_platform_test.dart`: formatted the new
  handwritten test; generated files were excluded.
- `dart test test/integration/backend_platform_test.dart`: five checks passed.
- `dart test`: all six server tests passed, including the template greeting test.
- `dart build cli --target bin/main.dart --output /tmp/poodle_server_platform_check_build`:
  passed; produced `bundle/bin/main` and three native build assets.
- Local Markdown link checks passed.

The original spec's `dart compile exe` command failed because it cannot process
the installed dependencies' native build hooks. The spec and README were updated
to `dart build cli`, which is also the project's existing Dockerfile build
command. Normal Dart commands initially encountered sandbox restrictions on SDK
cache/telemetry files; authorized verification succeeded with the required
filesystem access.

No model changes or migrations were required. No runtime source or Flutter
changes require a restart. Serverpod runtime MCP tools are not exposed in this
session, so live server/Flutter log review remains pending. No development server
was started by the agent. No new handwritten production logic was added, so a
new logic coverage measurement is not applicable to this module.
