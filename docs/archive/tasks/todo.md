# Implementation tasks

This is a historical checklist from the October UI milestones. Its unchecked
course-view items and MCP blockers do not describe the current source tree.
See [STATUS.md](../../status/STATUS.md) for the 2026-11-15 implementation inventory and
open release gates; keep the dated results linked below as evidence.

## iOS tab bar — approved 2026-10-23

- [x] Routing regression tests. Acceptance: fail for missing iOS navigation before implementation, retain Android checks. Verify: focused Flutter shell tests.
- [x] Localized destination mapping and guarded Calendar/Search routes. Acceptance: iOS has requested five destinations; legacy branches retain state. Files: app router, shell, English/Ukrainian ARB. Verify: routing and locale tests.
- [x] UIKit Liquid Glass bar and Cupertino fallback. Acceptance: genuine iOS 26+ glass group plus Search circle, per-view route synchronization, scroll minimization and accessibility. Files: native view/factory, AppDelegate, Xcode project, Flutter bridge. Verify: bridge tests, analysis, simulator build.
- [x] Home utility access and Calendar shortcut. Acceptance: Messages, More, account and Sign out stay reachable on iOS; return goes Home. Files: shell, dashboard View, preview destination. Verify: navigation, sign-out and state preservation tests.
- [x] Integrated verification and documentation. Acceptance: analysis/format/tests/build results recorded; architecture/testing describe the exception. Verify: Flutter suite, builds, available MCP runtime restart/log review.

Results: [ios-tab-bar-results.md](ios-tab-bar-results.md).

- [ ] Native device acceptance after rebuild/relaunch: actual Liquid Glass backdrop, VoiceOver, keyboard, reduced motion, enlarged native labels, iOS 15–25 fallback, and Serverpod MCP log review. See results for tool limitations.

---

Current course-view plan: [approved implementation plan](plan.md), based on the
approved [course-view spec](../../specs/SPEC-course-view.md). The user authorized implementation.

## Course views

- [ ] UUID course/membership schema and authorization policy. Verify cross-course, revoked, and admin-only denial.
- [ ] Ordered typed content and protected read/file APIs. Verify draft hiding and time boundaries.
- [ ] Idempotent development/test course seed and private PDF/DOCX fixtures. Verify collisions and repeated runs.
- [ ] Session-scoped live/preview course repositories and authenticated client composition. Verify stale-response isolation.
- [x] UUID routes and list/detail/activity Views. Verified invalid IDs, navigation, localization and large text with unit/widget tests.
- [ ] PDF/DOCX/link opening services and temporary-file cleanup. Verify authorized fetch and missing handlers.
- [ ] Integrate Home course cards, complete analysis/format/tests/builds, migrations and runtime evidence.

Source implementation and verification evidence: [course-view results](course-view-results.md).
The user's PDF and replacement DOCX are integrated unchanged. Migration,
live authorization acceptance and Serverpod restart/log checks await a working
Serverpod MCP handshake. Backend source and generated contracts compile.

Existing [identity-access tasks](identity-access-tasks.md) and their pending
runtime acceptance remain tracked in
[identity-access results](identity-access-results.md).

## Completed onboarding tasks

- [x] Completion store/service and repository; verify durable reads, write/read failure, duplicate completion.
- [x] Story catalog and playback state; verify timing, pause overlap, bounds, race and disposal.
- [x] Localized story copy and controls; generate localization output, verify locale coverage.
- [x] Progress/illustration widgets; verify local assets and deterministic visual capture.
- [x] Responsive onboarding view; verify gestures, pause, keyboard, accessibility and layouts.
- [x] Startup injection/router and isolated preview override; verify first-launch/session/back-stack behavior.
- [x] Palette, light goldens, full checks and project notes; record actual verification and pending device checks.

Automated verification is complete (54 tests, 95.5% handwritten-source coverage, clean analysis). Live MCP restart/log checks and Android/iOS device/VoiceOver/TalkBack acceptance remain pending because the required runtime tools are not exposed in this session.

## In-app course links

- [x] Implement browser policy, state, native adapter, routes and localization.
- [x] Verify 27 focused tests, analysis, formatting and Android/iOS builds.
- [ ] Complete native interaction/accessibility acceptance after app relaunch.
- [ ] Review Serverpod runtime logs when its MCP tools are available.

See [results](in-app-links-results.md), including seven unrelated-screen golden
mismatches in the full suite.
