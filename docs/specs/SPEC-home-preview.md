# Spec: Home dashboard and shared navigation preview

> **Historical preview milestone.** The live `main.dart` now uses a role-aware Serverpod-backed Home and live course, messaging, notifications and search routes. The simulated `main_preview.dart` still keeps preview content. The investigation and requirements below describe the earlier preview milestone; see [STATUS.md](../status/STATUS.md) for the current app.

> UI refresh: the requirements below for visible sample and feature preview labels are superseded. Simulated actions and unavailable features still describe their actual outcome.

Status: Implemented UI preview. The user authorized implementation after reviewing this spec; live runtime and device acceptance remain pending.

## Objective

Replace the current signed-in demo destination with a useful, bilingual preview of a student's learning overview and the app's five primary destinations. A learner can scan upcoming work, return to a recent course, read sample announcements, and discover where other features will live.

This is one UI milestone: the signed-in overview and its navigation frame. Other destinations expose explanatory placeholders, rather than implementing their independent LMS capabilities. The user selected this direction after reviewing real authentication, dashboard preview, and course/material options.

Follow [ARCHITECTURE.md](../architecture/ARCHITECTURE.md), [TESTING.md](../development/TESTING.md), [OFFLINE.md](../architecture/OFFLINE.md), [DESIGN.md](../architecture/DESIGN.md), and [AGENTS.md](../../AGENTS.md). This preview deliberately brings forward the dashboard UI from delivery step 4 while real authentication and course capabilities remain future work. It does not complete those architectural delivery steps.

## Investigation: what is already implemented

| Area | Evidence in the current source | Completion boundary |
| --- | --- | --- |
| Splash | `poodle_flutter/lib/features/auth/presentation/views/splash_screen.dart` and `view_models/splash_view_model.dart` | One Ukrainian quote per launch, minimum splash duration, simulated session restoration. Tests cover layout, quote selection and startup timing. |
| Onboarding | `poodle_flutter/lib/features/onboarding/`, `data/repositories/onboarding_repository.dart`, and `data/services/onboarding_store.dart` | Ten bilingual stories, playback/pause/manual controls, installation-level completion, storage-failure fallback, and routing. Tests cover behavior, persistence and representative visual baselines. |
| Login | Auth Views/ViewModels and `data/repositories/fake_auth_repository.dart` | Email/password and Google simulations, field validation, remember-me UI, reset-request preview and invitation explanation. No real login, Google authorization, reset email or persisted auth session. |
| Home | `poodle_flutter/lib/features/auth/presentation/views/home_screen.dart` | A mascot, Demo session text and Sign out button. Its source explicitly identifies it as a destination for verifying login, rather than an LMS dashboard. |
| Composition | `poodle_flutter/lib/main.dart`, `main_preview.dart`, and `app/poodle_app.dart` | The default app delegates to the preview. The router always redirects a signed-in session to `/demo`; that guard must evolve to permit navigation within the signed-in shell. |
| Backend foundation | `poodle_server/lib/server.dart` and `lib/src/auth/` | Built-in email identity provider and JWT refresh are configured. The retained Flutter client bootstrap is not connected to the preview composition. No dashboard/course/material backend is implemented. |
| Shared UI | `poodle_flutter/lib/ui/theme/poodle_theme.dart` and `app/l10n/` | Shared Material 3 theme, documented terracotta palette, English/Ukrainian localization, primary-system-language resolution and light-only appearance. |

All seven items in [the onboarding task list](../archive/tasks/todo.md) are checked. [The implementation record](../archive/tasks/implementation-results.md) reports 54 passing tests, 95.5% handwritten-source coverage, clean analysis/formatting and a passing debug web build. Those are historical results, not checks rerun during this investigation. The record leaves live MCP checks and Android/iOS/VoiceOver/TalkBack acceptance pending. Existing visual-failure images alone do not establish the current test outcome.

There are no `features/dashboard/`, course repositories, account-scoped SQLite caches, or implemented LMS destinations in the inspected source tree. Existing auth/routing tests assert the demo screen; they will need behavior-focused updates when it is replaced.

## Assumptions for review

1. This milestone remains a local UI preview using simulated authentication and synthetic data; it sends no credentials, emails or LMS requests.
2. Home represents a student overview. Teacher-specific publishing, student management and gradebook workflows require separate specifications.
3. Courses, Messages, Notifications and More establish navigation expectations. Only Home receives substantive dashboard content; More also provides the existing Sign out action.
4. Light-only styling and the existing system-language rules remain in force. Dark mode and settings are deferred.
5. Existing Flutter dependencies and bundled assets are sufficient. No new package, backend endpoint, database migration, permission prompt or external media is required.

## Scope and screen contract

### Signed-in shell

- Show five primary destinations in this order: Home / Головна, Courses / Курси, Messages / Повідомлення, Notifications / Сповіщення, More / Ще.
- Use a shared Material 3 navigation bar on compact layouts and a navigation rail when the available width is at least 600 logical pixels. Enlarged labels must remain readable through adaptive layout rather than reduced text scaling.
- The active destination has a visible and semantic selected state. Keep a visible localized Feature preview label and an explanation that sign-in and learning data are simulated on every signed-in destination, including detail placeholders.
- Home is selected after a successful simulated sign-in or restored preview session. Switching destinations preserves Home's loaded snapshot and scroll position within the session; reselecting the active destination is a no-op.
- Courses, Messages and Notifications show a destination-specific title, brief localized explanation and preview status. Do not fabricate unread badges, live conversations, enrollment management or a functioning inbox.
- More shows Calendar, Tasks, Downloads, Grades, Files, Profile, Settings and Help entries, each opening a labeled feature placeholder. It also exposes Sign out. Profile/settings forms, storage controls and actual support delivery are outside this milestone.

### Home content

Use the following reading order. Keep content vertically scrollable; wider layouts may place sections in columns while preserving semantic reading order.

| Section | Required content | Interaction |
| --- | --- | --- |
| Header | Home title, localized device-local date, generic welcome and preview disclosure | No invented profile name, avatar identity or role selector. |
| Upcoming tasks | At most three sample assignments, each with title, course, due date/time and textual due/overdue state | A row opens the contextual assignment placeholder; View all opens Tasks. |
| Recent courses | At most three sample courses with thumbnail/Material placeholder, title, category, last access and progress | A card opens the contextual course placeholder; View all selects Courses. |
| Announcements | At most two sample announcements with title, short excerpt, course, author, publication time and sample unread/read styling | A row opens a read-only sample announcement containing its full body. Opening it does not update read state. |
| Quick links | Calendar and Tasks | Open the respective placeholders under More. |

Required fixture cases include an overdue task, a future task, a course with nonzero progress, a course with no required activities, and both read and unread announcements. These are illustrative facts, not server-derived account records. Never add submit, complete, grade, send, download or mark-read controls to imply those operations work.

Order tasks by deadline ascending, including overdue items; order courses by last access descending and announcements by publication time descending. Break timestamp ties by stable fixture ID. Preserve full titles through wrapping or accessible detail text, rather than silently losing their distinguishing content.

Progress is a supplied sample value reflecting the architecture's eventual server-calculated progress. Do not create client-side completion rules. For no required activities, show No required activities / Немає обов'язкових завдань and no misleading 0% bar. Always pair progress color with a textual value.

### Destination behavior and routing

- Use stable routes `/home`, `/courses`, `/messages`, `/notifications` and `/more`. Keep `/demo` as a compatibility redirect to `/home`, subject to the same startup/session guard.
- Extend the current guard so valid signed-in locations remain reachable. Signed-out attempts to open any shell or nested preview route must pass through the existing splash/onboarding/login decisions without briefly revealing signed-in content.
- Pushed course, assignment and announcement previews retain the originating tab context. App back returns to that origin with its scroll position; a direct nested preview link has a safe parent destination. Do not promise restoration of a protected deep link after login in this milestone.
- Selecting Calendar or Tasks from Home selects More and opens the corresponding placeholder; back returns to More. View all announcements opens a read-only sample list under Home.
- At a non-Home tab root, Android back returns to Home. At Home root, normal root-route exit behavior applies. Keep supported iOS back gestures for pushed routes; do not force Android platform styling on iOS.
- Signing out from More clears preview dashboard state and pending loads, replaces signed-in navigation, and follows existing onboarding eligibility. It does not reset installation completion. A restored session with an incomplete tour retains the current behavior: sign-out makes that tour eligible again.
- A late response from a disposed/signed-out workflow must never repopulate the next session or reopen a protected route.

## Data, state and preview scenarios

Follow `View -> ViewModel -> Repository -> Service`. Put dashboard data ownership behind a shared abstract `DashboardRepository`; provide an injected in-memory fake returning immutable dashboard snapshots. A local fixture needs no artificial network-service layer. Keep the boundary replaceable with a future Serverpod service without changing Views.

Scope the dashboard repository to the simulated signed-in session and the Home ViewModel to its screen/workflow. The repository does not depend on `AuthRepository` or other repositories; composition coordinates identity and disposal. Other tabs do not read data from Home widgets or own duplicate mutable dashboard collections.

Store fixture timestamps as UTC and format them using the device timezone and selected English/Ukrainian locale. Inject the clock for reproducible ordering, relative deadlines and tests. A fixture factory can anchor sample dates to a launch clock; tests use a fixed clock. A locale change rerenders text without discarding loaded state or scroll position. Refresh must not arbitrarily move sample deadlines.

Support the following proposed `--dart-define=DASHBOARD_PREVIEW_SCENARIO=...` values independently of `PREVIEW_SCENARIO` and `ONBOARDING_PREVIEW`:

| Value | Behavior |
| --- | --- |
| `normal` | Brief loading state followed by populated sample data; refresh succeeds. |
| `empty` | Loading followed by section-specific empty messages, with navigation still available. |
| `loadFailure` | First load fails with a localized inline error and Retry; retry returns normal fixtures. |
| `offline` | A supplied sample snapshot displays an offline/stale banner and sample last-update time; refresh explains that the simulation is offline and preserves the snapshot. |

Unknown scenario values fail visibly during preview setup, consistent with existing auth scenario handling. A dashboard scenario never creates an auth session or bypasses onboarding; pair it with the existing `restoredSession` scenario when direct signed-in preview access is useful.

Expose explicit initial-loading, content, empty and failure states. Refresh retains existing content and shows a bounded progress indicator. Refresh failure preserves the previous snapshot and exposes retry feedback. Coalesce repeated loads/refreshes and clear busy state after success or failure. No initial or refresh failure traps the navigation shell.

The offline case is a rendering simulation, not SQLite persistence, connectivity monitoring or completed offline support. All scenarios remain usable without a running backend. No cache, download, account data or user action is persisted by this milestone.

## Visual and accessibility requirements

- Extend the current shared theme using `#C9674A`, `#5E2F12`, existing typography and spacing. Use bundled images/icons and Material controls. The app currently imports Flutter Material directly; do not introduce a `material_ui` dependency solely to match architecture terminology.
- Keep safe areas, responsive content widths, section hierarchy and restrained card surfaces consistent with splash/login/onboarding. No platform-specific screen variants.
- All visible copy, statuses, dates, tooltips and semantic labels support English and Ukrainian through ARB localization. Unsupported primary languages continue to fall back to English.
- Verify 320×568 and 390×844 portrait, 844×390 landscape and 768×1024 tablet layouts, including 2× text. Navigation labels, due dates, Retry and Sign out must remain reachable without overflow or clipped essential information.
- Interactive targets are at least 48 logical pixels. Normal text has at least 4.5:1 contrast and meaningful controls at least 3:1. Do not rely on color for overdue, progress, unread or selected states.
- Provide logical focus order, meaningful section headings, selected navigation semantics, keyboard activation and screen-reader labels for progress/dates. Exclude decorative thumbnails from duplicate announcements. Announce loading/error transitions without repetitive animation announcements; respect reduced motion.

## Tech stack and project structure

Use the existing workspace constraints: Dart `^3.12.2`, Flutter `^3.44.4`, provider `6.1.5+1`, go_router `14.8.1`, intl `^0.20.2` and the current Material 3 theme. Serverpod `4.0.4` remains the backend foundation but receives no changes in this preview.

| Location | Responsibility |
| --- | --- |
| `poodle_flutter/lib/app/` | Signed-in routing, shell composition, dependency injection, scenario selection and ARB localization. |
| `poodle_flutter/lib/features/dashboard/presentation/views/` | Home dashboard View. |
| `poodle_flutter/lib/features/dashboard/presentation/view_models/` | Immutable dashboard UI state and commands. |
| `poodle_flutter/lib/features/dashboard/presentation/widgets/` | Dashboard sections and contextual sample content. |
| `poodle_flutter/lib/data/repositories/` | Dashboard contract and fake; fixture ownership and refresh/error handling. |
| `poodle_flutter/lib/domain/models/` | Immutable dashboard projection types where needed; do not prebuild full LMS entities. |
| `poodle_flutter/lib/ui/components/` | Reused navigation/preview presentation; shared UI does not depend on feature presentation. |
| `poodle_flutter/test/unit/` | Mirror dashboard ViewModel, repository and scenario source areas. |
| `poodle_flutter/test/widget/` | Shell, dashboard, routing, localized layouts and visual baselines. |
| `poodle_flutter/test/fixtures/` and `test/support/` | Deterministic test data, clocks and reusable fakes. |

The substantive Home screen belongs in `features/dashboard/`, not `features/auth/`. Remove or retire the old demo-only View when references and tests migrate. Keep existing onboarding plan/task records intact; write the next plan and task breakdown only after this spec is approved.

## Code style

Follow existing formatted Dart, relative imports within the app, `lower_snake_case.dart` files, UpperCamelCase classes and lowerCamelCase members. Existing immutable state example from `reset_view_model.dart`:

```dart
@immutable
class ResetState {
  const ResetState({
    this.busy = false,
    this.sent = false,
    this.emailIssue,
    this.error,
  });
  final bool busy;
  final bool sent;
  final EmailIssue? emailIssue;
  final AuthFailure? error;
}
```

Use the same constructor/final-field approach for dashboard state, with unmodifiable collections. Views render state and forward commands; they do not select scenarios, sort repository data or call Serverpod directly. Keep UI strings out of models and ViewModels. Generate localization output through Flutter; never edit it manually.

## Commands and runtime workflow

Commands below run from `poodle_flutter/` through RTK. Localization generation is needed when ARB messages change; follow the AGENTS analysis → format → applicable migrations → restart → tests → logs checklist for implementation verification.

```sh
rtk proxy /Users/mac/Documents/flutter/bin/flutter gen-l10n
rtk proxy /Users/mac/Documents/flutter/bin/dart analyze lib test
rtk proxy /Users/mac/Documents/flutter/bin/dart format lib test
rtk proxy /Users/mac/Documents/flutter/bin/flutter test --no-pub --coverage
rtk proxy /Users/mac/Documents/flutter/bin/flutter test --no-pub test/widget/visual_baseline_test.dart test/widget/onboarding_visual_test.dart
rtk proxy /Users/mac/Documents/flutter/bin/flutter build web --debug --no-pub --target lib/main_preview.dart --dart-define=PREVIEW_SCENARIO=restoredSession --dart-define=DASHBOARD_PREVIEW_SCENARIO=normal
```

The new dashboard scenario flag is a proposed implementation contract, not an option already supported by the current source. Build the other three scenario variants using the same command with the final value replaced. The full widget suite must include new dashboard/shell visual tests in addition to the existing baselines.

Only the user starts development, using `rtk proxy serverpod start` from `poodle_server/`. The agent never starts the server or Flutter app via CLI. Use Serverpod MCP for `hot_restart`, `tail_server_logs` and `tail_flutter_logs`; routing/composition changes require a hot restart. For requested live app testing, use `get_flutter_app_dtd`, Dart MCP `connect_dart_tooling_daemon`, then `flutter_driver`. If text entry emulation is needed, follow AGENTS.md and hot restart after changing `driver.dart`.

No migration or backend test is expected for this UI-only scope. If MCP reports the server is stopped, stop and ask the user to start it. Serverpod/Dart runtime MCP tools were not exposed during this investigation; report runtime checks pending if that remains true at implementation time. Do not substitute CLI runtime operations.

## Testing strategy

Use Flutter tests with injected repositories, clock and deterministic latency; follow the project's test-first practice. Require at least 80% coverage of handwritten logic and 90% for any touched account-isolation/navigation-authorization logic, excluding generated code. Do not inflate coverage with tests that merely repeat fixture constants.

- Unit: initial load, empty/error/retry, refresh coalescing and failure recovery, stable ordering/ties, timezone/deadline boundaries, supplied progress/no-required-activities behavior, and stale callbacks after disposal/session replacement.
- Widget: five destinations and selected state, every dashboard action's target, contextual back navigation, sign-out, section empty states, offline disclosure, refresh feedback, scroll/state preservation, and English/Ukrainian accessibility/layout variants.
- Routing regression: fresh/completed onboarding, restored sessions, both sign-in methods, canceled/failed sign-in, reset preview, protected nested locations, `/demo` compatibility and removal of signed-in content after logout. Preserve the existing incomplete-tour-after-restored-session behavior explicitly.
- Visual: deterministic Home baselines in English/Ukrainian plus representative loading, empty, failure and offline states, compact navigation bar and wide rail. Review changed baselines; retain existing splash/login/onboarding baselines unless a deliberate shared-style change is approved.
- Device acceptance: Android/iOS navigation, back gestures, background/resume, enlarged text, keyboard/focus, TalkBack and VoiceOver. Record pending checks explicitly; widget semantics tests do not replace real-device acceptance.

For this specification-only change, follow TESTING.md's documentation rule: verify Markdown structure, local links and consistency with architecture/offline/testing documents. Application analysis, tests, runtime restart and log checks are not required until application code changes.

## Boundaries

- **Always:** preserve preview disclosure, auth/onboarding behavior, light-only Material styling and both locales; keep sample data behind a session-scoped repository; use UTC data/device-local display; test observable behavior and report verification limits; keep all future backend work in Serverpod.
- **Ask first:** changing this preview into live authentication/data, expanding a placeholder into an LMS capability, teacher-specific workflows, persistent caching, new dependencies, schema changes, external media or CI changes.
- **Never:** send real credentials/emails, call AI services, invent real enrollment/unread/grade data, claim SQLite/offline synchronization exists, queue writes, change onboarding completion on sign-out, leak one session's state into another, edit generated client/protocol/localization output manually, or start the server yourself.

## Success criteria

1. Existing simulated sign-in and restored-session flows reach the new Home; first-launch onboarding and all current auth preview scenarios still behave as specified.
2. All five destinations are reachable, accurately selected and usable across the stated sizes/text scales; unfinished areas visibly explain their preview status.
3. Home renders the specified task/course/announcement/shortcut sections in the specified order, with localized sample data and no implied working LMS mutations.
4. Every visible content action has the specified destination and return path; protected navigation, `/demo` compatibility and platform back behavior pass regression tests.
5. Normal, empty, load-failure/retry and offline/stale simulations are deterministic and distinct. Refresh preserves content, handles failures and cannot duplicate requests or leave permanent loading indicators.
6. Dates use the device timezone; due/overdue and no-required-activities states remain understandable without color. Language changes and tab switches preserve the current session's state.
7. Sign-out disposes data/workflows, prevents stale response reuse and preserves installation-level onboarding completion rules.
8. Relevant tests, analysis, formatting and debug build pass; required logic coverage is met. Device/runtime verification is completed or explicitly recorded as pending without claiming release readiness.

## Open questions and approval

No blocking clarification remains after the user's selection. Approval should confirm the proposed student-only fixture scope, five-destination shell, section order, placeholder interactions and scenario names. Any preferred Home visual reference can be supplied during review; otherwise the implementation should extend the existing Poodle design tokens.

## Implementation record

The signed-in demo destination has been replaced by the Home dashboard and five-destination shell. The ViewModel and injected dashboard repository own loading, refresh, fixture ordering, stale/error states and session clearing. Auth and onboarding previews still determine access; `/demo` redirects to Home. English/Ukrainian ARB messages cover the new surfaces. Six reviewed Home visual baselines cover English, Ukrainian, loading, empty, load failure and offline states. The old demo-only Home View was removed.

Verification: `dart analyze lib test` reported no issues; `dart format lib test` completed; the full Flutter suite passed serially with 78 tests. Coverage excluding generated code is 1,407/1,483 handwritten lines (94.9%); the dashboard repository is 92.2%, the app router 98.2%, and the signed-in shell 100%. Debug web builds passed for all four `DASHBOARD_PREVIEW_SCENARIO` values with `PREVIEW_SCENARIO=restoredSession`. A parallel full-suite run had an intermittent pixel mismatch in the existing onboarding visual baseline; that test and the entire suite passed serially. Visual baseline execution should remain serial until that separate intermittent difference is resolved.

Serverpod MCP hot restart and log tools were not exposed in this session, so live runtime verification remains pending. Android/iOS navigation, TalkBack and VoiceOver checks also remain pending. No server, model, migration or real authentication behavior was changed.
