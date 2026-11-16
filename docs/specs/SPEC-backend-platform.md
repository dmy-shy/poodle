# Spec: Backend platform and database foundation

Status: implemented and automated verification passed on 2026-10-22; live runtime log review remains pending. Module id: `backend-platform` in [CAPABILITY-MAP-backend.md](../architecture/CAPABILITY-MAP-backend.md).

## Objective

Make Serverpod's PostgreSQL connection and migration workflow a verified foundation for Poodle's multi-user backend. The current template already configures PostgreSQL for development, test, staging, and production; this module verifies and documents that path instead of introducing a second database client or exposing a database connection route. Downstream modules will use Serverpod sessions, generated models, and migrations for durable state.

The first acceptance target is a deterministic server integration check that connects to the isolated test database and executes a database operation through Serverpod. The test database is managed by Serverpod from `config/test.yaml` without Docker. No Poodle domain table is introduced solely to prove connectivity.

## Assumptions

1. Development and test use the configured local PostgreSQL data paths. Staging and production connection values are deployment configuration, not targets of this local verification.
2. The first new domain migration belongs to `identity-access` or `course-membership`; this module does not create an artificial table.
3. A database failure is reported as an operational error. Client endpoints never reveal connection strings, SQL details, or credentials.
4. Database rows store timestamps in UTC, as required by [ARCHITECTURE.md](../architecture/ARCHITECTURE.md).

## Tech stack

- Dart SDK `^3.12.2`, Serverpod `4.0.4`, and PostgreSQL through the existing Serverpod configuration.
- `serverpod_test` `4.0.4` and Dart `test` for integration checks.
- Serverpod-generated protocol, client, and migration files remain generated artifacts.

## Commands and runtime workflow

From the repository root, run the following for implementation verification, in the project-prescribed order:

```sh
cd poodle_server
rtk proxy dart analyze
rtk proxy dart format lib test
rtk proxy dart test test/integration/backend_platform_test.dart
rtk proxy dart test
```

For a compile check, run `rtk proxy dart build cli --target bin/main.dart --output /tmp/poodle_server_platform_check_build` from `poodle_server/`. Native build hooks in the existing dependencies require `dart build cli`; `dart compile exe` does not support them. If a future model change is necessary, use the Serverpod MCP `create_migration` and `apply_migrations` tools after analysis and formatting. Use MCP for hot restart and server/Flutter logs. The user starts development with `serverpod start`; the agent does not start the server. If the MCP reports that the server is not running, stop runtime work and ask the user to start it. Direct `serverpod generate` is only the documented fallback when the server cannot start at all.

## Project structure

| Path | Responsibility |
| --- | --- |
| `poodle_server/config/*.yaml` | Environment-specific Serverpod database configuration; no committed passwords |
| `poodle_server/lib/src/core/` | Shared handwritten backend conventions only when needed by downstream modules |
| `poodle_server/migrations/` | Serverpod-managed schema migrations |
| `poodle_server/test/integration/` | Isolated database connection and persistence checks |
| `poodle_server/test/support/` | Test helpers only if reused by multiple suites |

No new public endpoint is required for database connectivity. A future health check must not disclose database internals.

## Code style

Use formatted Dart with `lower_snake_case.dart` files, UpperCamelCase types, lowerCamelCase members, explicit input validation, and narrow dependencies. A small shared value type is preferable to exposing raw query parameters across modules:

```dart
class PageSize {
  const PageSize._(this.value);

  final int value;

  static PageSize? tryParse(int value) {
    if (value < 1 || value > 50) return null;
    return PageSize._(value);
  }
}
```

Map invalid input to a controlled client error. Keep SQL and Serverpod session access inside repositories or narrow infrastructure adapters; endpoints delegate to application services.

## Testing strategy

- Use `withServerpod` in an integration test to verify an isolated test session can execute a database operation. Exercise a controlled failure path where practical, without requiring a running development server.
- When the first domain model arrives, its owning module must prove insert/read/update persistence, isolation between accounts, and migration compatibility. Do not add a table solely to inflate this module's test count.
- Follow [TESTING.md](../development/TESTING.md): at least 80% coverage of handwritten backend logic and 90% for authorization logic when introduced. Generated files are excluded.
- For this specification-only edit, check Markdown structure, links, and agreement with architecture and testing documents. Application tests are not required yet.

## Boundaries

- **Always:** use Serverpod's configured database and migration workflow; keep secrets out of tracked files and logs; store timestamps in UTC; use isolated test data; verify database failures do not leak internals.
- **Ask first:** changing the database provider, adding an independent ORM or connection pool, modifying deployment database topology, or making a destructive migration that cannot preserve data.
- **Never:** expose raw database connectivity to clients, hand-edit generated protocol/client code, start the server yourself, or use the project Docker Compose stack for tests.

## Success criteria

1. The server test suite can establish an isolated PostgreSQL connection using `config/test.yaml` and execute a database operation through Serverpod.
2. The existing development database configuration remains compatible with `serverpod start`; no second database connection mechanism is added.
3. Connection failures produce useful server diagnostics without revealing credentials or SQL details to clients.
4. No synthetic table, public database route, committed password, or manual generated-code edit is introduced.
5. Analysis, formatting, the targeted integration check, and applicable server tests pass when this module is implemented.

## Open questions

None blocking for this module. The local-only admin seed belongs to `identity-access`; its approved email and development password are recorded in the capability map. Production admin bootstrap remains a separate deployment decision.

## Implementation record

The existing Serverpod database configuration supplies the required connection
management. `poodle_server/test/integration/backend_platform_test.dart` now
verifies the configured isolated PostgreSQL database, current project and auth
migrations, committed ORM insert/read/update operations across sessions, UTC
timestamp precision, and rollback/recovery after a real PostgreSQL query error.
It reuses Serverpod's built-in connection test table and drops the ephemeral
database afterward. No domain table, migration, public endpoint, connection
adapter, or generated-code edit was needed.

The server README now documents environment configuration, secret handling,
ORM/transaction conventions, migrations, test isolation, and troubleshooting.
Development/test YAML comments now describe the actual embedded PostgreSQL
workflow. Existing configuration values are unchanged.

Verification: analysis passed, the new test file was formatted, all five targeted
checks passed, and the complete server suite passed all six tests. The server
and its native assets built successfully with `dart build cli`; the executable
is `/tmp/poodle_server_platform_check_build/bundle/bin/main`. Markdown links were
checked. No new production logic was introduced that needs a separate coverage
measurement. Serverpod runtime MCP tools were unavailable in this session, so
live server/Flutter logs could not be reviewed. No development server was
started by the agent.

See [the implementation task record](../archive/tasks/backend-platform.md). Authentication
roles, invitation enforcement, the local admin seed, and course endpoints are
the following modules in the approved map; this record does not mark them done.
