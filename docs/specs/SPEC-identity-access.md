# Spec: Real Flutter authentication and JWT authorization

> **Historical identity milestone.** Email/JWT authentication is implemented, and later work added Google and university access. The migration and preview claims below describe the original checkpoint. See [STATUS.md](../status/STATUS.md) for the current source and remaining acceptance work.

> UI refresh: the requirements below for visible sample and feature preview labels are superseded. Simulated actions and unavailable features still describe their actual outcome.

Status: approved by the user on 2026-10-22 and implemented in source. The migration/runtime note in the original [implementation evidence](../archive/tasks/identity-access-results.md) is a dated checkpoint; current release acceptance is tracked in [STATUS.md](../status/STATUS.md). Module id: `identity-access` in the approved
[backend capability map](../architecture/CAPABILITY-MAP-backend.md). Depends on the implemented
`backend-platform` module. This specification includes the Flutter consumer of
the identity boundary; it does not create another capability map.

## Objective

Connect the default Flutter application to Poodle's Serverpod backend through the
generated client. Replace simulated email login with verified, invitation-based
accounts and Serverpod-issued JWT sessions. A signed-in user must be validated
by a protected backend call before the application exposes its signed-in shell.
The server, rather than Flutter route guards or token payloads, decides access.

Implement this as one identity capability: account bootstrap, invitation-based
email authentication, session restoration/refresh/logout, server authorization,
and the real Flutter `AuthRepository` adapter. The provider boundary is reused
by the later course membership module.

Follow [ARCHITECTURE.md](../architecture/ARCHITECTURE.md), [TESTING.md](../development/TESTING.md),
[OFFLINE.md](../architecture/OFFLINE.md), and [AGENTS.md](../../AGENTS.md).

## Assumptions for review

1. Default `main.dart` becomes the live application composition. The separate
   `main_preview.dart` entry point remains deterministic and uses fakes.
2. Email/password is the live method for this milestone. Google remains the
   separate [future extension](SPEC-google-auth-extension.md). Hide the Google
   action in live mode so it cannot produce a simulated signed-in state.
3. Registration requires an active invitation and email verification. Existing
   uninvited auth rows do not automatically become authorized Poodle accounts.
4. Admin authority is global. Teacher and student roles belong to course
   memberships, which are implemented in `course-membership`. A nonadmin account
   is not assigned a fabricated global student or teacher role.
5. The approved admin seed runs only in development and explicitly requested
   test fixtures. Staging and production cannot enable that seed.
6. The initial target is Android/iOS, with Flutter web supported for local
   development verification. Production browser authentication/cookie policy is
   a separate deployment decision.
7. The user confirmed developer-visible verification codes in development and a
   captured delivery adapter in tests. Real email delivery is deferred to a later
   milestone; production must not use a code-logging fallback.
8. Dashboard/course/message data remains a labeled feature preview after real
   login. This identity milestone does not make those fixture records real.

## Existing implementation

- `poodle_server/lib/server.dart` already configures `JwtConfigFromPasswords`
  and the built-in email identity provider. Existing email registration endpoints
  inherit the template's unrestricted registration behavior.
- `poodle_flutter/lib/client.dart` creates a generated client and a
  `FlutterAuthSessionManager`, but initialization is not awaited and the default
  application does not use this client.
- `AuthRepository` is already the application boundary; its fake currently
  stores only an email and simulates login, restoration, reset, and Google.
- The router considers a non-null fake session authenticated. Splash has no
  recovery state for restoration failures.
- The database foundation integration checks are implemented. Application
  identity records, admin authorization, and invitation enforcement are not.

## Tech stack

- Dart `^3.12.2`, Flutter `^3.44.4`, Serverpod and auth packages `4.0.4`.
- Existing generated `poodle_client`, PostgreSQL, `provider`, `ChangeNotifier`,
  `go_router`, and English/Ukrainian ARB localization.
- Reuse `FlutterAuthSessionManager`, its supported storage interface, and
  Serverpod token refresh/revocation APIs. No custom JWT signer or password hash
  implementation is required.
- Reuse the installed secure storage support for mobile remembered sessions.
  Any new direct dependency declaration must match the actual imported package
  and be recorded during planning; avoid version upgrades for this milestone.

## Server identity and authorization contract

### Persisted identity boundary

Poodle stores a small account-access record linked uniquely to the built-in
Serverpod auth user. It records global admin authority and teacher approval
eligibility. Teacher approval permits future assignment to a teacher membership;
it is not a fourth role or a global teacher role. Email verification, password
hashes, JWT refresh credentials, and blocked-user state remain owned by
Serverpod auth.

Invitation records contain the normalized invited email, issuer, purpose,
creation/expiry time, and accepted/revoked state. For this module the exposed
admin operation invites a teacher candidate. Student invitations with a course
target belong to `course-membership`; this module supplies the reusable
verification/acceptance boundary.

An invitation expires after seven days, can be revoked, and can be consumed
once. Creation must not grant access to an existing account merely because its
email matches. Repeated invitation or acceptance requests cannot create
duplicate users, duplicate approvals, or additional privileges. Check the
current invitation at final account creation, not only when sending the code;
consume it in the same transaction as Poodle account authorization.

### API surface

Use generated Serverpod endpoint methods, not a parallel REST authentication
server. The following names describe the contract; generated Dart DTO/class
names can be finalized in the technical plan.

| Operation | Access | Required behavior |
| --- | --- | --- |
| Email login | Public, rate limited | Authenticate through Serverpod email auth; require an authorized, unblocked Poodle account; issue normal Serverpod JWT credentials |
| Begin invited registration | Public, rate limited | Start email verification for a currently invited address; use a generic response for unknown, ineligible, or existing addresses |
| Verify and finish invited registration | Verification proof | Use Serverpod code/completion-token validation, recheck invitation eligibility, create the access record and consume the invitation atomically |
| Password reset: begin, verify, finish | Public proof-based workflow | Reuse Serverpod reset/rate-limit logic; use generic request confirmation; set the new password and revoke prior sessions |
| JWT refresh | Valid refresh credential | Reuse Serverpod's refresh endpoint and rotation behavior; do not accept email/user IDs as substitutes for a refresh credential |
| `account.me` | Active authenticated Poodle session | Return trusted user ID, verified email, and current admin/teacher-approval information; expose no tokens, password hashes, or another user's data |
| `adminInvitations.list/create/revoke` | Current global admin | Manage teacher invitations with bounded pagination; derive issuer from the session; reject nonadmins even if they know a route or invitation ID |
| Current-device logout | Authenticated session | Reuse Serverpod revocation and clear the local session; do not revoke other devices on ordinary logout |

The inherited template email endpoints must not remain as a registration,
login, or reset bypass. Restrict/override them or expose a controlled endpoint
using the same built-in email business APIs. Verify all generated reachable
methods, including direct calls that bypass Flutter.

### JWT and permission checks

- Serverpod validates JWT signatures and expiry using server-held keys. Keep
  its existing 10-minute access-token and 14-day refresh-inactivity lifetimes
  unless review changes them. Use an explicit issuer consistently for issuance
  and validation in the live deployment configuration.
- Refresh rotation and its persistence belong to the supported Serverpod auth
  APIs. The client coalesces concurrent refresh attempts, retries the original
  request at most once after refresh, and never refreshes in an infinite loop.
- A reusable `requireAccount` service resolves the identity from the verified
  Serverpod session, then checks that its Poodle access record and built-in auth
  user are active. For JWT application requests it also checks that the session
  identified by the token's auth ID has not been revoked or expired. The stock
  JWT signature check alone does not provide immediate session revocation.
- `requireAdmin` builds on `requireAccount` and reads current admin authority
  from the database. An admin claim stored in a previously issued token is not
  sufficient. The next protected call must reflect an account block, admin
  removal, or session revocation.
- Missing, malformed, expired, or revoked credentials are unauthenticated.
  A valid active account lacking admin permission receives a distinct forbidden
  outcome. A network failure is not presented as invalid credentials.
- Teacher approval never grants course access. The provider contract supplies
  trusted account/admin checks; `course-membership` must later add active
  membership and per-course teacher/student checks before any course API ships.
- Never trust a request's user ID, email, role, or client-side decoded JWT as
  authorization. Derive the current user and all grant decisions on the server.

### Development academic seed

Set `poodleDevelopment{Admin,Teacher,Student}{Email,Password}` under
`development:` in the ignored server `config/passwords.yaml`. Configure all
three pairs together. The Student login uses an `@lntu.edu.ua` address. The
public signup and reset password policy remains in force.

To reuse an existing local login, verify its ID from the signed-in
`account.me` response or from the local development database and set
`poodleDevelopment{Admin,Teacher,Student}ExpectedAuthUserId` for that persona.
Leave the ID unset for a new login. The seed refuses ambiguous addresses or
IDs that do not match. It preserves the verified user's ID and provider links,
sets the requested initial email password once, and revokes prior sessions.

The accounts and academic courses are created together. Admin has no membership
in the new courses. Teacher teaches Linear Algebra and OOP and studies
Discrete Mathematics; Student studies Linear Algebra and Discrete Mathematics.
Later starts preserve passwords, roles, memberships, and course edits.
Existing English course records and notebook ownership are preserved. A new
English fixture is optional and requires the local sample documents on first
provisioning. Staging and production never run this seed.

## Flutter session and navigation contract

### Composition and state

`main.dart` creates one injected generated client and the real auth repository.
It resolves `SERVER_URL` through the existing configuration path and uses HTTPS
outside loopback development. A physical device must use a reachable development
host. No global client is accessed directly from a View or ViewModel.

Extend the application session projection beyond its current email-only shape
to include the stable user ID and server-confirmed authorization information.
Keep raw tokens inside the service/session manager. The repository exposes
explicit restoring, signed-out, signed-in, unavailable, and signing-out states
so initialization errors cannot leave a permanent splash.

Await client auth initialization and `account.me` before marking a live session
signed in. With no saved session, follow splash/onboarding/login normally. An
invalid or revoked saved session is cleared and leads to login. A transient
network/storage failure shows a recoverable connection/storage state with Retry
and a way to return to login; preserve potentially valid saved credentials on a
network failure. Do not display protected content based on token presence alone.

### Login and remember me

- Email/password login obtains credentials from the real generated endpoint,
  installs them in the session manager, then calls `account.me`. If authorization
  fails, clear the candidate credentials and remain signed out.
- Remember me off uses process-memory credential storage and clears any older
  persisted session. Remember me on stores the supported session credential
  envelope in mobile secure storage, including rotated credentials. Never store
  passwords or raw JWTs in `shared_preferences` or application models.
- Configure the storage policy before the first credential write. If requested
  secure persistence fails, report a recoverable storage error rather than
  silently claiming remember me worked. A session must not be published as
  successfully remembered while its persistence is incomplete.
- Login/logout/restore operations have a session generation guard. A late login,
  refresh, or `me` response cannot restore a session after logout or overwrite a
  newer account's state.

### Visible workflows

- Preserve the existing bilingual Material 3 login and validation behavior.
  Remove the simulated-auth disclosure from live auth screens. Preview mode
  continues to disclose simulation, including its Google preview action.
- Add a small invited-registration flow: email, verification code, and password
  creation. Generic request confirmation must not reveal invitation/account
  existence. No unrestricted signup control is introduced.
- Complete the password reset UI with verification-code and new-password steps;
  the existing request-only success dialog is insufficient for a real reset.
  Codes and completion tokens remain transient and are cleared on cancel/finish.
- Add a real account page under More with verified email and server-confirmed
  admin status. A minimal admin invitations screen provides a useful protected
  admin workflow for listing, creating, and revoking teacher invitations.
- Protect signed-in routes during startup, logout, expiry, and failed refresh.
  Admin routes require fresh server authorization and show an access-denied
  state for an authenticated nonadmin. Hiding navigation is only a UI aid.
- Keep signed-in LMS fixture destinations visibly labeled as feature previews.
  Remove copy that says the successful live login itself is simulated. No
  teacher/student course data or sample enrollment becomes an authorization fact.
- Existing onboarding completion remains installation-scoped. Real logout does
  not reset it; a validated restored session skips the signed-out tour.
- Local web testing must implement the same remember-me lifecycle and must not
  claim production browser credential protection. Production web cookie mode,
  origins, and CSRF policy are outside this mobile integration milestone.

### Logout and denied access

Clear protected UI, repository state, and account-specific pending work even if
the revocation call fails because the device is offline. Attempt current-device
server revocation while its credentials are still available, then remove local
credentials. Clearly report when server revocation was not confirmed; never
claim an offline logout revoked a credential already copied elsewhere. Do not
queue the logout credential for later replay.

A successful online logout or reset makes the previous session fail subsequent
Poodle protected calls, even if its JWT access expiry has not yet elapsed.
Refresh rejection signs out and clears state; a forbidden admin operation does
not by itself destroy an otherwise valid nonadmin session.

## Project structure

| Location | Responsibility |
| --- | --- |
| `poodle_server/lib/src/modules/identity/` | Access/invitation models, endpoints, application services, repositories, and development bootstrap |
| `poodle_server/lib/src/core/` | Reusable authenticated-account and admin checks |
| `poodle_server/lib/src/auth/`, `lib/server.dart` | Built-in email/JWT integration and controlled provider entry points |
| `poodle_server/test/unit/`, `test/integration/`, `test/support/` | Rules, real persistence, JWT boundary checks, and captured email delivery |
| `poodle_flutter/lib/app/`, `main.dart`, `client.dart` | Live composition, bootstrap/routing state, and preview capability configuration |
| `poodle_flutter/lib/data/repositories/` | Real `AuthRepository` implementation; retain the fake for previews/tests |
| `poodle_flutter/lib/data/services/` | Serverpod auth adapter and credential-storage policy |
| `poodle_flutter/lib/features/auth/` | Login, invitation acceptance, reset, and their ViewModels |
| `poodle_flutter/lib/features/account/` | Account and minimal admin invitation Views/ViewModels |
| `poodle_flutter/test/`, `integration_test/` | Adapter/session tests, routing/widget tests, and real auth acceptance flow |

The code generator owns all of `poodle_client`, server generated protocol files,
and generated test tools. Localization output is generated from ARB sources.

## Code style

Follow existing formatted Dart, immutable state projections, `ChangeNotifier`,
and dependency injection. The current repository contract already establishes
the intended boundary:

```dart
abstract class AuthRepository extends ChangeNotifier {
  AuthSession? get session;
  Future<AuthSession?> restoreSession();
  Future<void> signInWithEmail({
    required String email,
    required String password,
    required bool rememberMe,
  });
  Future<void> signOut();
}
```

Extend that boundary with explicit lifecycle states and invitation/reset
commands. Views render state; ViewModels call repositories; services wrap the
generated client. Server endpoints delegate to services and repositories.
Backend models use `.spy.yaml`; generated API models stay at the service edge
unless direct reuse serves the application. Do not duplicate password hashing,
JWT verification, or refresh-token rotation already supplied by Serverpod.

## Commands and runtime workflow

Run these commands from the indicated package directories. Analyze before
formatting per project rules; format only handwritten files changed by this
module, excluding generated protocol/client/test-tool output.

From `poodle_server/`:

```sh
rtk proxy dart analyze
rtk proxy dart format lib/server.dart lib/src/auth lib/src/core lib/src/modules/identity test/unit test/support
rtk proxy dart test
rtk proxy dart build cli --target bin/main.dart --output /tmp/poodle_identity_server_build
```

Also format the handwritten identity integration test files added under
`test/integration/`; do not format its generated `test_tools/` directory.
From `poodle_flutter/`:

```sh
rtk proxy flutter gen-l10n
rtk proxy dart analyze lib test integration_test
rtk proxy dart format lib/main.dart lib/client.dart lib/app lib/data lib/features/auth lib/features/account test integration_test
rtk proxy flutter test --coverage
rtk proxy flutter build web --debug --no-pub --target lib/main.dart
rtk proxy flutter build web --debug --no-pub --target lib/main_preview.dart
```

Directories named above are created by implementation where required. Exclude
generated localization output from manual edits/formatting. The executable SDK
under `flutter/bin/cache/dart-sdk/bin/dart` may be used if the Flutter wrapper
cannot update its cache in the agent sandbox.

The user starts the runtime with `serverpod start`. The agent never starts it.
Use Serverpod MCP to create/apply migrations and to hot restart after changing
Flutter composition or provider initialization, then inspect server/Flutter
logs. If MCP reports a stopped server, stop and ask the user to start it.
Never replace unavailable runtime MCP actions with equivalent CLI operations.

For requested live testing, use Serverpod MCP `get_flutter_app_dtd`, Dart MCP
`connect_dart_tooling_daemon`, and `flutter_driver`. Follow the driver's documented
text-entry-emulation setting and hot restart when changing it. Use tests with
isolated embedded PostgreSQL; no Docker is needed.

## Testing strategy

Meet [TESTING.md](../development/TESTING.md): at least 80% coverage of handwritten logic and
90% for authorization/account-isolation logic; exclude generated output. Test
observable outcomes, not copies of implementation branches.

- Server unit/integration: invitation expiry/revocation/reuse, final-step
  invitation recheck, concurrent acceptance, unique account linkage, seed
  idempotency/collision/run-mode guard, and no global teacher/student grants.
- Server JWT integration: correct/incorrect credentials, blocked/unapproved
  accounts, missing/malformed/tampered/expired tokens, successful rotation,
  refresh replay/revocation, active-session checks, and stale admin claims.
  Include requests using actual serialized bearer credentials through the test
  HTTP server; authenticated-session overrides alone do not test JWT verification.
- Authorization: anonymous calls are rejected, active nonadmins cannot list or
  change invitations, admins can perform the allowed operations, and user/issuer
  identity cannot be supplied by a malicious client. Test direct inherited
  registration routes for bypasses.
- Flutter unit/widget: real adapter mappings, memory versus secure remember-me
  storage, startup/retry/expiry, concurrent refresh, denied access, stale async
  completion after logout, code/password forms, and complete account state cleanup.
- Routing/localization: splash/onboarding/login/reset/invite/account/admin paths,
  back navigation, session loss on a protected deep link, both languages, enlarged
  text, and preview entry-point regression tests. Auth screens remain light-only.
- Acceptance: seed admin → real Flutter login → protected `me` → create teacher
  invitation → accept with a captured development code → nonadmin denied admin
  API → remember-me relaunch → refresh → online logout/revocation. Also verify
  password reset/new password, transient startup network failure, and offline
  local logout. Mobile security/storage behavior requires Android/iOS verification;
  a browser build alone does not establish it.

Routine tests use captured verification-code delivery and never send real email.
Real email delivery and its verification are deferred to a later milestone.
Record unavailable runtime/device checks as pending instead of claiming success.

## Boundaries

- **Always:** use built-in Serverpod email/JWT and generated clients; enforce
  invitation/account/session/admin checks on the server; preserve per-course
  roles for the membership module; keep credentials out of logs/UI state;
  preserve explicit preview entry points, onboarding, both locales, and existing
  UI styling; use MCP for migrations/runtime operations.
- **Ask first:** adding Google or another provider, production admin bootstrap,
  enabling the development seed outside development/tests, selecting a paid
  email provider, changing production browser auth deployment policy, or
  expanding into course membership/content administration.
- **Never:** use fake success in live mode, create uninvited authorized accounts,
  trust client role fields or decoded JWT claims for access, store passwords in
  Flutter, weaken the public password policy to match the development seed,
  expose secrets/verification proof in API diagnostics, edit generated code,
  start the runtime yourself, or mark untested device/runtime behavior complete.

## Success criteria

1. Default Flutter startup uses the injected real Serverpod client; preview
   scenarios remain available only through the explicit preview composition.
2. The approved local seed can log in through Flutter with a real Serverpod JWT;
   `account.me` confirms identity and admin authority. No production seed runs.
3. Invited, verified accounts can register; uninvited or revoked invitations
   cannot authorize accounts, including through inherited template endpoints.
4. Missing, tampered, expired, blocked, and revoked sessions fail Poodle protected
   calls. Nonadmins cannot invoke admin operations or become admins by modifying
   requests, cached state, or JWT payloads.
5. Refresh rotation, expiration, and current-device revocation work with actual
   bearer credentials. Current permissions are rechecked without waiting for a
   stale JWT role claim to expire.
6. Remember me off leaves no reusable persisted session. Remember me on restores
   through protected server validation. Network/storage failures are recoverable
   and cannot trap startup on the splash screen.
7. Logout and failed auth clear protected UI/account state; late asynchronous
   results cannot revive the previous session. Offline logout accurately reports
   unconfirmed server revocation.
8. Invitation acceptance and password reset work through all code/password steps
   in English and Ukrainian, with controlled failures and generic request notices.
9. Analysis, formatting, server/Flutter tests, required logic coverage, generated
   client compatibility, and both live/preview build checks pass. Migration and
   runtime/device verification results are recorded explicitly.

## Open questions and review

The existing approved role, Google deferral, seed credentials, and development-only
seed scope do not need another decision. The user confirmed development verification
codes now and real email delivery later on 2026-10-22. No blocking clarification
remains. The user approved implementation on 2026-10-22, including completing the
invite/reset screens and adding the minimal account/admin invitation workflow
described here.
