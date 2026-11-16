# Spec: Google authentication extension

> **Implemented in source; acceptance remains open.** Google ID-token login/link and live Flutter controls exist. Read [Google results](../archive/tasks/google-auth-results.md) and [STATUS.md](../status/STATUS.md) for the current verification boundary; the original proposal below is retained as design history.

Status: implemented in source; live linked-account/device acceptance pending. Mobile Google authentication uses the existing emailIdp endpoint with googleLogin and linkGoogle methods. Module id: `google-auth-extension` in [CAPABILITY-MAP-backend.md](../architecture/CAPABILITY-MAP-backend.md).

## Objective

Extend Poodle's real Serverpod authentication so an invited account can sign in with Google in addition to email/password. Keep Serverpod as the session issuer and preserve the same global admin and course-scoped teacher/student authorization checks regardless of sign-in method. The live mobile button obtains Google proof through the auth gateway; the explicit preview composition retains simulated Google authentication. Runtime acceptance requires configured Google clients and a working identity-access runtime.

## Assumptions and scope

1. Google is an additional sign-in method, not a new Poodle role or a replacement for email/password.
2. A Google identity must have a verified email matching an active invitation before a new Poodle account is created. Existing Poodle accounts require an explicit, authenticated linking step before Google can sign them in; matching an existing email alone must not silently link accounts.
3. Poodle stores the provider's stable account identifier for later sign-ins. Provider credentials and token verification remain server-side; only Poodle's normal authenticated session reaches course endpoints.
4. Declined sign-in, revoked invitation, invalid provider proof, mismatched linked identity, and network failure have distinct user-visible outcomes without exposing sensitive provider details.
5. No Google account receives admin authority automatically. Admin status and course memberships remain managed by Poodle.

## Tech stack

- Existing Dart/Flutter `^3.12.2` and Flutter `^3.44.4` project, Serverpod auth packages `4.0.4`, and the generated `poodle_client`.
- Native Google ID tokens are acquired through google_sign_in 7.2.0 and verified through the installed Serverpod Google provider. Google operations use generated emailIdp.googleLogin and emailIdp.linkGoogle methods.
- PostgreSQL stores the minimal account-to-provider link through a Serverpod model and migration if the base auth package does not own that link.

## Commands and runtime workflow

From the repository root, verification uses:

```sh
cd poodle_server
rtk proxy dart analyze
rtk proxy dart format lib test
rtk proxy dart test
cd ../poodle_flutter
rtk proxy flutter analyze
rtk proxy dart format lib test
rtk proxy flutter test
```

Use Serverpod MCP `create_migration` and `apply_migrations` for any new model; use MCP hot restart and logs after changes that require it. The user starts `serverpod start`. Do not start it from the agent. For user-requested live app testing, obtain the Flutter DTD through Serverpod MCP, connect through Dart MCP, then use `flutter_driver` as directed by [AGENTS.md](../../AGENTS.md).

## Project structure

| Path | Responsibility |
| --- | --- |
| `poodle_server/lib/src/auth/` | Provider callback/verification and account-linking entry points |
| `poodle_server/lib/src/core/` | Reusable authenticated-account checks owned by `identity-access` |
| `poodle_server/lib/src/modules/` | Provider-link persistence if the supported auth package requires a Poodle model |
| `poodle_server/test/unit/` and `test/integration/` | Proof validation, invite/linking rules, and persistence tests |
| `poodle_flutter/lib/data/repositories/` | Real `AuthRepository` adapter to Serverpod auth; preserve the fake for preview tests |
| `poodle_flutter/lib/features/auth/` | Existing login UI and ViewModel behavior for Google outcomes |

Generated server/client code is never edited directly.

## Code style

Keep provider claims separate from Poodle authorization. A verified provider identity is a narrow input to the account-linking service:

```dart
class VerifiedGoogleIdentity {
  const VerifiedGoogleIdentity({
    required this.subject,
    required this.email,
  });

  final String subject;
  final String email;
}
```

Application services accept this value only from the server-side verifier, never from a request body. The linking service decides whether the identity matches an invitation or an already-linked account; endpoints do not grant roles from provider claims.

## Testing strategy

- Unit tests: invitation acceptance, explicit existing-account linking, duplicate provider subject, unverified email, wrong audience/issuer, expired proof, canceled sign-in, and no role escalation.
- Server integration tests: provider link persistence, account/session issuance through Serverpod, refusal for uninvited identities, and continued protection of admin/course routes.
- Flutter widget/unit tests: Google success, cancellation, invalid or expired proof, network failure, and sign-out without leaking the prior account's state.
- No live Google call is required for routine tests; use controlled provider proof or a verifier fake. Validate one configured end-to-end flow before release.
- Meet [TESTING.md](../development/TESTING.md) coverage expectations, including at least 90% for touched authorization logic.

## Boundaries

- **Always:** verify provider proof server-side; enforce the invitation and explicit-link rules; reuse Serverpod sessions; protect account and course access independently of sign-in method; keep provider tokens out of logs.
- **Ask first:** adding a new provider SDK, changing existing-account linking policy, or changing the invitation model defined by `identity-access`.
- **Never:** auto-create an uninvited account, auto-link an existing account solely by matching email, grant admin from a Google claim, persist raw provider tokens as application data, or edit generated code.

## Success criteria

1. An invited, verified Google identity can complete the approved sign-in flow and receive a normal Serverpod session.
2. An existing account can use Google only after an explicit authenticated link; attempts to link another account's Google identity fail.
3. Uninvited, unverified, invalid, expired, and revoked identities cannot authenticate or gain access to protected routes.
4. Global admin and per-course teacher/student permissions are unchanged by the sign-in method.
5. The real Flutter auth adapter reports success, cancellation, and failures without retaining credentials or state from another account.
6. Relevant server and Flutter analysis, formatting, unit, integration, and widget tests pass; configured end-to-end verification is recorded before release.

## Open questions

- Which Google client IDs and platform registrations will be used for Android and iOS? Provide these when implementation is scheduled; no credential or private key belongs in this spec. (Will provide after implementation or during it)
- Should an invited account be allowed to choose Google as its first sign-in method? This spec assumes yes for a pending invitation and requires explicit linking for an existing account. (Yes)
