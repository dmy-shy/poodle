# Testing strategy

Use Flutter's test tools, Dart's `test` package, and Serverpod integration helpers. Test each MVVM component through its observable behavior and use fakes for repository/service boundaries.

See [ARCHITECTURE.md](../architecture/ARCHITECTURE.md) for the design, [STATUS.md](../status/STATUS.md) for the implementation inventory and [OFFLINE.md](../architecture/OFFLINE.md) for synchronization rules. The gates below are release targets unless a dated result explicitly records a pass.

## Test locations

| Location | Responsibility |
| --- | --- |
| `poodle_flutter/test/unit/` | ViewModels, repository cache/refresh logic, models, and service adapters |
| `poodle_flutter/test/widget/` | Views, shared UI, navigation, dependency injection, and accessibility |
| `poodle_flutter/integration_test/` | Planned teacher/student mobile workflows; this directory does not yet exist |
| `poodle_server/test/unit/` | Authorization rules, deadlines, completion, grading, and notification scheduling |
| `poodle_server/test/integration/` | Endpoints and persistence against real PostgreSQL/pgvector, including streams and jobs |
| `poodle_worker/test/unit/` | Validation, normalization, source-version handling, job-state transitions, and provider adapters |
| `poodle_worker/test/integration/` | Real extraction tools, fixture files, controlled HTTP responses, and job recovery |
| `tests/ai_evaluation/` | Planned cross-package English/Ukrainian grounded-answer evaluation; directory absent |
| `tests/load/` | Planned authenticated concurrency checks; directory absent |

Within unit/widget folders, mirror the relevant source areas, such as `data/repositories/`, `features/courses/`, and `ui/components/`. Keep reusable fixture inputs in each package's `test/fixtures/`; fakes, builders, and test setup belong in `test/support/`. Cross-package evaluation data stays with its evaluation suite. Use package-local `test/` for Dart tests; root `tests/` holds cross-package checks.

Do not hand-edit generated Serverpod client or protocol code. Validate client/server compatibility through application integration tests.

## Test levels

Check the signed-in header and account menu on Android and iOS at narrow widths, large text, and safe-area insets; verify Profile and Search return to their originating screen.

- **Unit:** test ViewModel loading/success/failure states and commands; repository caching, refresh, retry, and isolation; pure backend rules; worker validation and normalization. Use fake services/providers, deterministic timestamps, and controlled failures.
- **Widget:** test the shared Material 3 Views and components with fake dependencies, routing, settings, calendar, empty/error states, semantic labels, enlarged text, and English/Ukrainian localization. Verify the shared design on Android and iOS; cover platform-sensitive interactions separately.
- **Server integration:** use Serverpod helpers and a clean PostgreSQL/pgvector test database. Exercise authenticated endpoints, transactions, persistence, streaming authorization, notification outbox behavior, and durable ingestion jobs.
- **Worker integration:** use PDF/office/image/media/HTML fixtures, actual CLI extraction tools, and a controlled HTTP server. Test English/Ukrainian OCR and article extraction separately from live provider calls. Fake AI providers for repeatable pipeline tests.
- **Mobile end-to-end:** use seeded teacher/student accounts and real backend interactions. Verify complete workflows on Android and iOS, including reconnection and account cleanup.
- **AI evaluation:** maintain bilingual, teacher-reviewed source/question fixtures. Check grounded answers, source-wide summaries, citation locations, and refusal when evidence is insufficient.

Use shared visual baselines for feature screens. The approved [iOS navigation exception](../specs/SPEC-ios-tab-bar.md) needs platform-specific shell checks: iOS 26+ Liquid Glass and separate Search, iOS 15–25 Cupertino fallback, Android Material bar, and the wide rail. `test/widget/ios_navigation_test.dart` exercises route/native selection synchronization, minimization, reduced motion, preserved branch state, protected previews, Home utilities, localization and enlarged text. Native UIKit rendering itself requires an iOS build and device/simulator acceptance; Flutter's mocked platform-view tests do not prove its appearance. Run Android/iOS checks for keyboard insets, text selection, scrolling, route transitions, Android back, supported iOS back-swipe, and system permission/file/share interfaces.

## Coverage and quality gates (targets)

Require at least 80% coverage for handwritten Dart logic across the app, backend, and worker, and 90% for authorization, deadline, and cache-isolation logic. Exclude generated protocol/client/localization code. Coverage does not replace meaningful scenario tests or AI evaluation.

Every cited ID must resolve to an authorized source version and location. At least 90% of evaluation answers must be judged correct and source-supported. Run live-provider evaluation before changing prompts or model configuration; keep routine tests deterministic with provider fakes.

## Required acceptance scenarios

| Area | Scenarios |
| --- | --- |
| Access | Course-specific roles, invitation flows, cross-course isolation, private-source ownership, participant-only messages, and revoked membership |
| Assignments | Submission replacement/version history, opening/deadline boundaries, grading locks, teacher feedback, and reopening with a new deadline |
| Progress | Manual materials, accepted submissions, exclusion of optional/draft activities, empty denominator, and recalculation after requirement changes |
| Course browsing | Favorites, search/filter/sort, layout preferences, and hiding without changing enrollment or deadlines |
| Calendar | Device-timezone boundaries, week-start preferences, upcoming/overdue tasks, and edited deadlines without duplicate linked events |
| Notifications | Permission denial, preferences, canceled reminders, changed deadlines, submitted assignments, retry deduplication, authorized targets, and invalid-device cleanup |
| Messaging | Pair reuse, pagination, unread counts, participant-only subscriptions, duplicate sends, reconnect/server restart, and history access after shared-course eligibility ends |
| Offline | Cached reading, blocked server writes, no outgoing-message queue, explicit download/refresh/removal, interrupted refresh, storage failure, stale indicators, and logout/account isolation |
| Ingestion | MIME/signature mismatch, malformed/encrypted/macro-enabled files, input limits, oversized decompression, extraction failure, bounded retries, and restart-safe completion |
| Website import | Private IPv4/IPv6 destinations, redirects, DNS changes, connection destination validation, timeouts, unsupported pages, normalized output, and changed-source versions |
| AI | Source-selection and ownership filtering, correct citation IDs/locations, insufficient-evidence responses, source-wide summaries, and bilingual answers |
| UI | Shared Material 3 layouts/styles, Android/iOS interaction behavior, English/Ukrainian, dark mode, enlarged text, accessible labels, and loading/empty/error/processing/offline states |
| Load | 30 authenticated users with 10 concurrent normal operations; verify errors, persistence, reconnect behavior, and responsive foreground actions |

## Verification order

### Historical identity access milestone

`poodle_flutter/test/unit/data/` covers secure/memory storage leases, the live
repository lifecycle and the generated client's HTTP contracts against an isolated
fixture server. These fixture tests do not prove backend JWT validation. Live auth
widget coverage is in `test/widget/live_auth_flow_test.dart`; preview and onboarding
regressions remain in their existing suites. Run Flutter tests with `--concurrency=1`
for repeatable visual baseline comparisons in this environment.

Server unit tests cover invitation policy and delivery/bootstrap mode guards.
`identity_access_test.dart` exercises real persistence; `identity_jwt_test.dart`
sends actual bearer HTTP requests through the SDK authentication handler rather
than injecting authenticated test sessions. Both require the new identity migration.
The original migration/runtime blocker and measured results are recorded in
[identity implementation results](../archive/tasks/identity-access-results.md). That dated
checkpoint predates the current generated migrations and live feature work;
use [STATUS.md](../status/STATUS.md) for today's state.

### Project acceptance

1. Run affected unit and widget tests for a change.
2. Run relevant backend/worker integration tests when contracts, persistence, processing, or synchronization change.
3. Verify complete teacher/student and offline flows before release, including real-device Android/iOS checks and database restore checks.
4. Run live AI evaluations for prompt/model changes and the load scenario before pilot readiness.

For documentation-only changes, check Markdown structure, relative links, consistent folder names, and agreement between the architecture, status, offline, notifications and testing documents. Application tests are not required when application code has not changed.

## References

- [Flutter architecture and testing recommendations](https://docs.flutter.dev/app-architecture/recommendations)
- [Serverpod integration testing](https://docs.serverpod.dev/concepts/testing/get-started)
