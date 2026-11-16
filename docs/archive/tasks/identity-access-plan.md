# Identity access implementation plan

Specification: [SPEC-identity-access.md](../../specs/SPEC-identity-access.md).
Spec and plan approved by the user on 2026-10-22. Source implementation is complete;
database migration and runtime acceptance are pending. See [results](identity-access-results.md).
Existing completed module records are preserved.

## Sequence and verification checkpoints

### 1. Define persistent identity and generated contracts

Add `AccountAccess` and `AccountInvitation` `.spy.yaml` models under
`poodle_server/lib/src/modules/identity/`. Link account access uniquely to the
built-in auth user; store admin authority and teacher eligibility separately.
Invitation fields cover normalized email, trusted issuer, teacher purpose,
expiry, acceptance, and revocation. Add safe account/invitation projections and
typed access failures without exposing credentials or verification proofs.

Use database uniqueness and transactional locking for account linkage and
invitation acceptance. Avoid course/global teacher/student grants. Generate
protocol/client output through the running Serverpod watcher; never hand edit
generated code. Use MCP to create/apply the migration and inspect its SQL.

Checkpoint: generated protocol compiles; isolated database tests establish
constraints and invitation state transitions. No downstream client code is
written against guessed generated APIs.

### 2. Enforce account and session authorization

Implement reusable `requireAccount` and `requireAdmin` checks under
`poodle_server/lib/src/core/`. Resolve identity from verified authentication;
check current built-in user, Poodle access record, and JWT refresh/session record.
Return unauthenticated for invalid/revoked sessions and forbidden for a valid
nonadmin. Implement `account.me` and bounded admin invitation list/create/revoke
endpoints backed by identity services. Derive issuer exclusively from session.

Checkpoint: actual bearer HTTP tests reject missing, tampered, expired, blocked,
and revoked credentials; nonadmins cannot use invitation APIs; changes to admin
authority apply on the next request. Test pagination, expiry, and revocation.

### 3. Control email registration, reset, and local bootstrap

Replace unrestricted inherited email endpoint behavior with controlled methods
using Serverpod's existing email business APIs. Preserve SDK code verification,
password policy, throttling, token rotation, and hashing. Registration rechecks
and consumes an eligible invitation atomically with creation of account access.
Prevent direct inherited endpoint bypasses. Reset completion revokes previous
sessions. Configure a consistent JWT issuer.

Use development code logging and a captured test delivery adapter. Staging and
production fail explicitly when email delivery is unavailable; do not log codes
there. Real email transport remains deferred.

Add idempotent seed bootstrap using ignored development configuration with the
approved values. Guard execution by development mode; tests invoke an explicit
fixture path. Never reset a changed password, regrant removed authority, or
promote an unrelated matching account. Keep the short seed password exception
inside bootstrap only.

Checkpoint: integration tests cover invited registration through every exposed
route, final-step revocation, concurrent acceptance, generic public notices,
reset/revocation, refresh rotation/replay, and all seed collision/mode cases.

### 4. Implement Flutter service and repository lifecycle

Keep the generated client at the service boundary. Await initialization and
protected `account.me` before publishing a session. Extend `AuthRepository` with
explicit lifecycle states, stable account projection, invite/reset commands,
and recoverable network/storage failures; update the fake to retain previews.

Implement supported session-envelope storage with selectable memory/secure
policy before credential writes. Remember-me off clears old persisted data;
remember-me on verifies persistence. Reuse the SDK refresh coordination where
it satisfies the contract; add only missing coordination and bounded retry.
Use operation generation guards to prevent late results reviving a session.
Logout attempts revocation before clearing credentials and always clears local
account state, exposing an unconfirmed-revocation outcome when offline.

Declare `serverpod_auth_core_client` / `serverpod_auth_core_flutter` directly,
at the existing 4.0.4 version, only if imported directly for storage/session
interfaces. Do not upgrade dependencies. Reuse the Flutter auth package's secure
storage implementation where possible; add a direct secure-storage declaration
only if implementation actually imports it.

Checkpoint: service/repository tests cover credential errors, denied access,
startup retry, storage failures, remember-me policies, refresh concurrency,
logout races, stale completions, and cross-account cleanup.

### 5. Connect live UI and complete account workflows

Make `main.dart` compose the real client/repository; preserve `main_preview.dart`
with fakes. Validate server URL configuration and preserve local device setup.
Update router/splash recovery to prevent protected deep links during restoration,
logout, or expired sessions. Preserve installation onboarding state and validated
session bypass. Hide Google only in live mode.

Add invited email/code/password screens and complete reset code/new-password
steps. Add a real account destination under More and a minimal admin invitation
list/create/revoke screen. ViewModels call repositories; Views do not access a
global client. Preserve light styling, English/Ukrainian localization, and
explicit feature-preview labels for fixture dashboard data. Generate localization
output from ARB sources.

Checkpoint: widget/router tests verify both locales, recovery and back navigation,
admin denial, transient code cleanup, large text, and existing preview/onboarding
regressions. Build both live and preview entry points.

### 6. Verify the integrated boundary and document results

Run analysis, format changed handwritten sources, create/apply migrations via
MCP where needed, then MCP hot restart, server/Flutter tests and build checks,
and MCP log inspection in the project's prescribed order. Measure handwritten
logic coverage against the spec's 80% overall / 90% authorization targets.
Use embedded PostgreSQL for tests and actual bearer HTTP credentials for the
JWT boundary rather than relying solely on injected test authentication.

Run the acceptance sequence from the spec: seeded admin login, protected account,
teacher invite/acceptance, nonadmin denial, persistence/relaunch, rotation,
online logout, reset, startup network recovery, and offline local logout.
Use MCP DTD/Flutter driver for live interaction. Record unavailable runtime and
Android/iOS security checks explicitly as pending; never infer success from a
web build. Update the spec, capability map, and implementation results honestly.

## Dependencies and execution

Sequence: models/generated contract → authorization → controlled email/bootstrap
→ Flutter service/repository → live screens/routing → integrated verification.
Server tests are added alongside each server change; Flutter tests accompany
the adapter and UI changes. Independent test fixtures/localization preparation
can proceed while awaiting generated output. No agent delegation is required.
After plan approval, split these stages into small file-scoped tasks with
acceptance criteria and verification in `tasks/todo.md`, preserving its completed
onboarding record.

## Risks and mitigations

| Risk | Mitigation |
| --- | --- |
| Template email methods bypass invitations | Inventory every generated reachable method; override/restrict each path and test direct calls |
| Access JWT survives revocation | Require a current active account and session record on protected Poodle calls |
| Concurrent registrations consume an invitation twice | Database constraints, transaction locking, final eligibility recheck, race tests |
| Seed promotes an existing user or resets authority | Persistent bootstrap identity, collision rejection, idempotency tests |
| Remember-me or logout races restore old credentials | Configure storage before writes; operation generations; concurrent-operation tests |
| Production accidentally logs verification codes | Explicit run-mode delivery policy; tests assert no nondevelopment logging fallback |
| Missing runtime tools prevent generated API/migrations | Stop dependent implementation at the actual missing boundary; preserve completed source work and report pending actions |

## Current environment limitation

Serverpod and Dart runtime MCP tools are not exposed in this session. No stopped
server response has been received, and the agent has not started a server. MCP
generation/migration/runtime checks cannot currently be performed. CLI analysis,
formatting, tests, and builds remain available, subject to SDK filesystem access.
The referenced `planning-and-task-breakdown` helper skill is not installed; this
plan uses the explicit planning requirements in the invoked skill.
