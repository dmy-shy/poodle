# poodle_server

Poodle's Serverpod backend uses PostgreSQL through `Session.db` and generated
Serverpod models. The database foundation is covered by
[SPEC-backend-platform.md](../specs/SPEC-backend-platform.md). Authentication,
membership, and content modules follow the
[backend capability map](../architecture/CAPABILITY-MAP-backend.md). The current module and
release inventory is [STATUS.md](../status/STATUS.md).

## Development

From this directory, the developer starts the server and its companion Flutter
app with:

```sh
rtk proxy serverpod start
```

Serverpod watches source changes, generates the protocol/client, and hot reloads.
Use Serverpod MCP for runtime restarts, logs, and database migrations. The agent
must not start the development server itself.

## Database configuration

| Environment | Configuration | Database lifecycle |
| --- | --- | --- |
| Development | `config/development.yaml`: localhost:8090, `poodle` | Serverpod manages PostgreSQL using `.serverpod/development/pgdata`; data survives normal restarts |
| Test | `config/test.yaml`: localhost:9090 | Serverpod manages PostgreSQL using `.serverpod/test/pgdata`; `withServerpod` creates and drops an isolated database per group by default |
| Staging/production | `config/staging.yaml`, `config/production.yaml` | Replace template hosts/names with deployment values; use the private database network and required TLS configuration |

Database passwords belong in the ignored `config/passwords.yaml` or the
deployment's supported secret configuration. Never put passwords into endpoints,
tracked YAML, or logs. `.serverpod/` is ignored because it contains local database
files, runtime state, and sockets. Do not delete that directory as a routine fix;
it contains the development database.

Use Serverpod's connection management; application code does not open an
independent PostgreSQL connection pool. Endpoints delegate to application
services, repositories perform database operations, and transactions group
dependent writes. Prefer generated ORM methods; use `QueryParameters` for values
when a direct query is necessary. Store timestamps as UTC instants. Map failures
to controlled API errors instead of returning SQL or database exception text.

## Migrations

Edit handwritten `.spy.yaml` models and endpoint source. The running Serverpod
watcher regenerates protocol/client code; never edit `lib/src/generated/`, the
generated test tools, or `poodle_client` manually. After a table model change,
use Serverpod MCP `create_migration`, review the resulting migration, and use
`apply_migrations`. Use `create_repair_migration` through MCP for schema drift.
Follow [AGENTS.md](../../AGENTS.md) for the narrow data-preserving SQL exception and
the CLI fallback when the server cannot start at all.

The migration registry now includes identity, course, notebook, teaching,
notifications, push-device, search, messaging and university-access tables.
The presence of a migration file does not by itself prove that a particular
deployment database has applied it.

## Verification

Run from this directory:

```sh
rtk proxy dart analyze
rtk proxy dart format test/integration/backend_platform_test.dart
rtk proxy dart test test/integration/backend_platform_test.dart
rtk proxy dart test
rtk proxy dart build cli --target bin/main.dart --output /tmp/poodle_server_platform_check_build
```

Tests need no Docker or separately started development server. The database
foundation suite checks the actual test PostgreSQL connection, current project
and auth migrations, committed ORM insert/read/update operations, UTC timestamp
round trips, and rollback/recovery after a failed query. It reuses Serverpod's
built-in `serverpod_readwrite_test` table. Automatic test rollback is explicitly
disabled in this group to exercise real commits and transactions; test records
are cleaned up, and the group's ephemeral database is dropped afterward.

The platform tests are database integration checks, not a live Flutter authentication test.
The identity suites additionally exercise invitation persistence and real JWT HTTP requests.
Current integration suites also cover course access, Google auth, teaching,
messaging, notifications, university access, notebook access and files.

## Current runtime composition

`lib/server.dart` configures Serverpod email/JWT authentication, optional Google
identity, transactional mail configuration, private/public cloud storage with a
database fallback, development academic seeds and platform-operator bootstrap.
It schedules institution-mail delivery. `lib/src/modules/` contains the live
course, identity/university, teaching, student learning, messaging, notifications,
notebook, search, files and admin endpoints. The separately launched
[`poodle_worker`](worker.md) processes notebook and search jobs.

The initial identity implementation record is a historical checkpoint. Use
[STATUS.md](../status/STATUS.md) and the newer dated task results for current scope;
verify migration state against the active database through Serverpod MCP.

For a connection failure, check the active run mode and its database host/port,
then check that the ignored database password matches the local configuration.
For a schema mismatch, inspect migration status and server logs through MCP;
avoid resetting the development database. Keep failure diagnostics on the server
and return generic errors to clients. Live restart/log checks require the
Serverpod MCP connection and a development server started by the user.


## Optional Docker database passwords

The normal `serverpod start` and test workflows use managed PostgreSQL and
do not need Docker. If you choose the optional `docker-compose.yaml` services,
provide `SERVERPOD_PASSWORD_database` for the development database and
`POODLE_DOCKER_TEST_DATABASE_PASSWORD` for the optional test database through
your shell environment or an ignored `poodle_server/.env` file. Compose fails
with a setup message if either value is missing. Keep the API's database
password consistent with the database you use. Never commit these local values.

The VS Code start task reads Serverpod's normal local configuration instead
of embedding a database password. GitHub Actions uses disposable test-only
database passwords; they must not be reused for development or deployment.
