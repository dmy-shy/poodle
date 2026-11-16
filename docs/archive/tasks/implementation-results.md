# Onboarding implementation results

Implemented the approved onboarding spec in the Flutter authentication preview.

## Delivered

- Ten English/Ukrainian feature stories covering courses, materials, notebook, sources, planning, assignments, communication, teaching, offline reading and personal preferences. Copy identifies the experience as a feature preview.
- First-launch onboarding after splash and before login, with device completion saved through shared_preferences. Restored sessions bypass onboarding; completion survives logout and relaunch. Storage failures do not block access.
- Eight-second autoplay, segmented progress, tap/swipe and keyboard navigation, overlapping pause reasons, background/route suspension and a final Get started action.
- Accessible manual playback, localized controls and announcements, responsive scrolling text and layouts tested with enlarged text. The app remains light-only; primary system language selects Ukrainian or English, with English fallback.
- Existing auth preview scenarios retained. The user-approved accessible X button dismisses the password-reset dialog.

## Structure

Storage lives in `poodle_flutter/lib/data/services/onboarding_store.dart`, with completion state in `lib/data/repositories/onboarding_repository.dart`. The story catalog, ViewModel, screen and focused widgets live in `lib/features/onboarding/`. Composition and startup routing remain in `lib/app/poodle_app.dart`.

The stories describe planned LMS capabilities; this change does not implement those backend features. Future authentication integration remains behind AuthRepository and uses Serverpod according to ARCHITECTURE.md.

## Verification

- 54 tests pass, including persistence, startup/session routing, playback timing, lifecycle, gestures, keyboard, accessibility, localization and visual baselines.
- Handwritten-source coverage: 961 of 1,006 executable lines (95.5%). Generated localization output is excluded.
- Static analysis is clean; formatting check reports no changes.
- Debug web build passes with `lib/main_preview.dart` as the target.
- Independent review identified initial-background playback and backward-navigation timing races. Regression tests reproduced both issues before the fixes.
- A temporary navigation-guard mutation was caught by the tests; the original implementation was restored before final verification.

## Preview

Use `--dart-define=ONBOARDING_PREVIEW=true` to force a fresh tour with isolated in-memory completion state. Normal launches use durable preferences. Non-normal PREVIEW_SCENARIO values bypass the tour unless the fresh-tour override is enabled.

Visual baselines: [first story](../../../poodle_flutter/test/widget/goldens/onboarding_0_en.png), [Ukrainian notebook story](../../../poodle_flutter/test/widget/goldens/onboarding_2_uk.png), [current final story](../../../poodle_flutter/test/widget/goldens/onboarding_4_en.png).

## Next steps

1. Use the Serverpod MCP hot restart and log tools when available to verify the running app. These tools were not exposed in this session; the server was not started by the agent.
2. Complete Android/iOS device acceptance, including VoiceOver/TalkBack, background/resume, gestures and first-launch persistence.
3. Continue the architecture-defined LMS implementation separately, keeping backend features in Serverpod and authentication behind AuthRepository.
