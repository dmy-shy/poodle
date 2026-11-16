# Identity access tasks

Spec and plan approved on 2026-10-22. Tasks execute under that authorization.

Source implementation is present for every group below. Unchecked groups retain
database/runtime acceptance work; they are not verified complete. See
[results](identity-access-results.md) for the exact checks and blockers.

- [ ] Identity models and account DTOs (model files under `modules/identity/`).
  - Acceptance: unique auth linkage, explicit admin/teacher eligibility, invitation lifecycle, safe projections.
  - Verify: generator validation, compilation, migration constraints.
- [x] Invitation policy (`identity_policy.dart`, unit tests).
  - Acceptance: normalized valid email, bounded pagination, single-use seven-day eligibility with exact expiry boundary.
  - Verify: focused server tests, analysis.
- [ ] Current account/session guards (`core/`, guard integration tests).
  - Acceptance: active account and unrevoked JWT session required; current DB admin authority enforced.
  - Verify: actual bearer HTTP and changed-authority tests.
- [ ] Account endpoint and admin invitations (endpoints, identity service/repository).
  - Acceptance: trusted identity, bounded list, admin-only create/revoke, server-derived issuer.
  - Verify: database integration and nonadmin denial tests.
- [ ] Controlled email registration (email endpoint, registration service, tests).
  - Acceptance: all inherited routes controlled; final transaction consumes invitation and authorizes account once.
  - Verify: direct endpoint bypass, revocation, expiry, and concurrent acceptance tests.
- [ ] Reset/JWT configuration and delivery (server setup, auth configuration, tests).
  - Acceptance: reset revokes sessions; issuer consistent; development codes only; captured test sender.
  - Verify: reset, rotation/replay, and delivery mode tests.
- [ ] Development bootstrap (seed service, ignored local configuration, tests).
  - Acceptance: development/explicit test only; approved account created once; collision and regrant rejected.
  - Verify: repeat, collision, changed-password/authority, production-mode tests.
- [x] Session storage policy (Flutter service, tests, direct dependency declarations if imported).
  - Acceptance: memory/secure policy before writes, old durable credentials removed, failures surfaced.
  - Verify: memory, persistence, error, rotation and concurrent-operation tests.
- [x] Real auth repository and SDK adapter (repository/service, tests).
  - Acceptance: protected validation before signed in; restore/retry/logout lifecycle; no stale completions.
  - Verify: session/refresh/network/storage/denial/isolation tests.
- [ ] Live composition and routing (main/client/router/splash, tests).
  - Acceptance: default real client, explicit fake preview, recovery states, onboarding preserved.
  - Verify: startup, deep-link, expiry/logout and preview regression tests.
- [ ] Invitation/reset forms (Views/ViewModels, ARB sources, tests).
  - Acceptance: all proof/password steps, both locales, transient proof cleanup, no live Google action.
  - Verify: widget/navigation/enlarged-text tests.
- [ ] Account/admin screens (account feature, repository boundary, tests).
  - Acceptance: server-confirmed account, invitation list/create/revoke, nonadmin denial.
  - Verify: widget and protected API acceptance tests.
- [ ] Integrated verification and documentation.
  - Acceptance: analyze/format, migration MCP, restart MCP, tests, coverage, live/preview builds and log checks recorded.
  - Verify: spec acceptance sequence; record unavailable runtime/device checks as pending.
