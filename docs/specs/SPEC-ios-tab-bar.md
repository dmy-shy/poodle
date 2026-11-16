# Spec: iOS 26+ signed-in tab bar

> **Historical navigation milestone.** The live Calendar, Notifications and Search routes now use data-backed screens; preview behavior below applies to the earlier milestone and explicit preview app. See [STATUS.md](../status/STATUS.md) for current feature status.

> UI refresh: the requirements below for visible sample and feature preview labels are superseded. Simulated actions and unavailable features still describe their actual outcome.

Status: implemented (2026-10-23); automated/build verification recorded in [results](../archive/tasks/ios-tab-bar-results.md), native device acceptance pending. The user resolved the three scope questions and then approved the full spec with “I approve this, implement”. This specification covers one capability: the signed-in navigation bar on iPhone.

## Objective

Give learners on iOS 26 and newer a bottom navigation bar that follows Apple's current iPhone tab-bar pattern: four labeled destinations in a floating, translucent group and a visually separate circular Search control at the trailing edge. Keep the existing Android Material navigation and signed-in learning screens working as they do today. The supplied screenshot is a visual reference for grouping and placement; its sample labels and content are not Poodle requirements.

This is an explicit, narrow exception to the shared Material 3 navigation rule in [ARCHITECTURE.md](../architecture/ARCHITECTURE.md). Only the signed-in navigation chrome and the routes needed for its destinations become platform-specific. Authentication, feature Views, repositories, and the light theme remain shared. Update the architecture and affected testing guidance when the change is implemented.

Apple describes iPhone tab bars as floating over content on a Liquid Glass background and supports a distinct trailing Search tab. Its guidance also calls for visible labels, stable access to top-level sections, and preserved navigation state. [Tab bars](https://developer.apple.com/design/human-interface-guidelines/tab-bars), [Search fields](https://developer.apple.com/design/human-interface-guidelines/search-fields).

## Scope decisions and assumptions

1. The new visual treatment targets iPhone-sized, signed-in layouts running iOS 26 or newer. The existing wide-screen navigation rail remains the tablet layout in this milestone. This is an assumption about scope, not a claim that Apple's iPadOS tab bar looks like the iPhone bar.
2. Android keeps its current Home, Courses, Messages, Notifications, and More labels, icons, order, Material `NavigationBar`/`NavigationRail`, routes, and behavior.
3. On iOS, the four grouped destinations are Home, **My courses**, Calendar, and Notifications, in that order. Search is the separate fifth control. English and Ukrainian labels are required; the screenshot's Explore, Favorites, and Settings are examples only.
4. Calendar, Notifications, and Search remain clearly labeled Feature preview destinations for this navigation milestone. The tab-bar change does not claim to implement calendar data, notification delivery, or global search.
5. Existing Messages and More/account/sign-out routes stay available through secondary navigation on iOS, even though they leave the primary bar. Home provides accessible Messages and More entry points; More retains account and Sign out controls.
6. iOS 15–25 remains supported because the project currently has a 15.0 deployment target. It uses a Cupertino-style bottom bar with the same five iOS destinations; the separate Search circle and iOS 26+ minimization are limited to iOS 26+.

## User behavior and success criteria

### iOS navigation

1. On a supported compact iPhone, a signed-in learner sees a floating bottom bar with four labeled, scalable platform-style icons in a rounded translucent group. The selected destination is visually distinct and exposed as selected to accessibility services. Search appears as a separate circular magnifying-glass control at the trailing edge, with a localized accessibility label.
2. The bar stays in the safe area above the home indicator and does not cover the last reachable content or interactive control. It adapts to small widths, landscape, English/Ukrainian labels, and enlarged text without clipping a destination or creating a More overflow tab. Keep meaningful labels visible in the expanded bar; the separate Search control may be icon-only visually.
3. Tapping Home, My courses, Calendar, or Notifications changes the selected top-level destination. Home and courses keep their existing content and nested routes. Calendar and Notifications show honest preview content until their own feature milestones exist. Reselecting the active destination does not discard its state. Switching away and back preserves each tab's route and scroll position where the current shell already does so.
4. On scrollable signed-in content, downward scrolling minimizes the iOS 26+ bar to reclaim space; upward scrolling or returning toward the top restores it. The active destination and Search remain reachable in the minimized state. Reduced-motion settings avoid unnecessary movement, and keyboard display must not strand navigation behind the keyboard.
5. Tapping the separate Search circle opens a localized, clearly labeled Search preview. It does not focus an editable field or show fabricated results. This is an interim behavior: Apple's separate-button search pattern normally focuses a search field and opens the keyboard; a later search milestone must replace the preview with that behavior or revisit the control style. [Search fields](https://developer.apple.com/design/human-interface-guidelines/search-fields).
6. Home exposes clearly labeled, accessible Messages and More controls on iOS. Messages opens its existing preview. More retains its feature entries, account access, and Sign out. A Home-to-Calendar quick link selects the new Calendar destination on iOS; Android's existing quick-link behavior remains unchanged.
7. Existing protected routes remain protected after sign-out and account changes. Direct links to `/messages`, `/more`, and their children still resolve safely. A secondary iOS screen opened from Home retains a clear way back to Home and does not display an unrelated selected tab. The existing Android system-back behavior stays intact.

### Android and wider layouts

8. On Android, the compact Material navigation bar and wide navigation rail continue to render the same five destinations and preserve their current navigation behavior. Existing Home quick links, More's Calendar entry, account access, and Sign out remain usable.
9. On iOS 15–25 compact layouts, show a Cupertino-style bottom bar for Home, My courses, Calendar, Notifications, and Search. Search can be the fifth labeled item in this fallback; tapping it opens the same preview. On wide Apple layouts, keep the current rail. No iPadOS top tab-bar redesign is included.

### Accessibility and content

10. Use localized English/Ukrainian labels and semantics from ARB sources, SF Symbols or equivalently recognizable iOS icons, touch targets of at least 44 points on iOS, sufficient contrast against moving content, and a sensible VoiceOver focus order. Do not rely on translucency or color alone to convey selection.
11. The signed-in Feature preview disclosure remains visible. No backend endpoint, Serverpod model, database migration, notification permission, or search index is introduced by this navigation milestone.

On iOS 26+, keep floating actions at least 16 points above the glass bar in both sizes. Animate changes between selected tabs and fade selection when entering or leaving Search. Apply selection immediately when Reduce Motion is enabled.

## Technical context and project structure

The app uses Dart `^3.12.2`, Flutter `^3.44.4`, `go_router` `14.8.1`, and `provider` `6.1.5+1`. `PoodleApp` uses `MaterialApp.router` and a `StatefulShellRoute.indexedStack`. `SignedInShell` currently chooses a Material `NavigationBar` below 600 logical pixels and a `NavigationRail` above that width. The current five branch roots are `/home`, `/courses`, `/messages`, `/notifications`, and `/more`; Calendar is currently a More preview. The iOS deployment target is 15.0.

| Location | Responsibility in this change |
| --- | --- |
| `poodle_flutter/lib/app/signed_in_shell.dart` | Select the iOS/Android navigation chrome and map visible controls to routes without changing shared feature Views. |
| `poodle_flutter/lib/app/poodle_app.dart` | Add protected iOS Calendar/Search destinations and preserve existing branch/deep-link behavior. |
| `poodle_flutter/lib/app/preview_destinations.dart` | Reuse or adapt honest placeholder content and secondary navigation entry points. |
| `poodle_flutter/lib/app/l10n/app_en.arb`, `app_uk.arb` | Add any My courses, Search, and accessibility copy; regenerate output rather than editing generated localization files. |
| `poodle_flutter/test/widget/` | Verify platform selection, routing/state preservation, localization, semantics, safe areas, and small/large layouts. |
| `ARCHITECTURE.md`, `TESTING.md` | Record the approved navigation exception and platform-specific acceptance checks. |

Flutter's standard `CupertinoTabBar` is an iOS-styled full-width bar, but its documented API does not provide a distinct trailing Search control or iOS 26 scroll minimization by itself. The linked `liquid_tabbar_minimize` package advertises a native SwiftUI bar on iOS 26+, a separate action control, and a custom fallback on older iOS; its action-control semantics and route integration must be verified before choosing it. The plan may select that package, a small native bridge, or another implementation that satisfies the observable contract. Do not use the package's Android custom bar. [Flutter CupertinoTabBar](https://api.flutter.dev/flutter/cupertino/CupertinoTabBar-class.html), [liquid_tabbar_minimize](https://pub.dev/packages/liquid_tabbar_minimize).

Implementation decision: use an app-owned UIKit platform view in `ios/Runner/PoodleTabBar.swift`. It composes native buttons/SF Symbols with the system iOS 26 `UIGlassEffect` and a separate glass Search button. GoRouter selection and Flutter scroll/accessibility state flow through a per-view method channel; there is no additional window or package dependency. The linked package's native code does not synchronize later `currentIndex` changes, so it would not satisfy the route-selection contract without modification. The compatible fallback uses Flutter's `CupertinoTabBar`.

## Commands and runtime workflow

Run Flutter commands from `poodle_flutter/`. These are the commands for the later implementation phase; this documentation-only specification does not run application checks.

```sh
rtk proxy dart analyze
rtk proxy dart format lib test
rtk proxy flutter test --concurrency=1 test/widget/dashboard_shell_test.dart
rtk proxy flutter test --concurrency=1
rtk proxy flutter build ios --simulator --debug --no-codesign -t lib/main_preview.dart
rtk proxy flutter build apk --debug -t lib/main_preview.dart
```

Follow the project's verification order: analyze, format, migrations only if models change, then Serverpod MCP hot restart when required, applicable tests, and Serverpod MCP server/Flutter log review. The user starts `serverpod start`; never start it from this task. If live Serverpod MCP calls report that the server is unavailable, stop and ask the user to start it. When explicitly testing the running app, obtain its DTD through Serverpod MCP, connect the Dart MCP, then use Flutter driver. A newly added native iOS plugin needs a fresh native build; hot restart alone cannot verify linkage.

## Code style and boundaries

Keep existing `lower_snake_case.dart` filenames, formatted Dart, ARB-based copy, View-to-ViewModel-to-Repository boundaries, and GoRouter as the route source of truth. A platform check belongs at the shell boundary rather than in every feature View. For example, a pure label mapping can stay small and testable:

```dart
String courseTabLabel(AppLocalizations text, {required bool ios}) =>
    ios ? text.myCoursesTab : text.coursesTab;
```

- **Always:** preserve Android's visible navigation and authenticated route guard; label previews honestly; check VoiceOver/TalkBack and both languages; update architecture/testing documents for the approved exception.
- **Ask first:** changing the five requested iOS destinations or adding live search/calendar/notification functionality beyond this navigation milestone.
- **Never:** edit generated Serverpod/client/localization code by hand, hide protected routes behind only a visual control, or replace Android's Material bar with the linked package's custom bar.

## Testing strategy

- Widget tests use platform overrides to assert the correct bar on iOS versus Android, each destination's route/selected semantics, preserved Home scroll state, safe-area behavior, 320-point width, landscape, 2× text, and English/Ukrainian labels. Keep the existing Android shell regression tests meaningful.
- Simulator/device checks on iOS 26+ confirm actual translucency, separate Search placement, scroll minimization/re-expansion, keyboard interaction, VoiceOver, and nested route return behavior. Check an iOS 15–25 device or simulator for the Cupertino fallback and the same five destinations. Android checks confirm unchanged Material presentation, system Back, and TalkBack.
- No server test is required unless the later plan changes a backend contract; no migration is expected.

## Approval status

The user chose Home or account controls for Messages and More, a labeled Search preview, and a Cupertino-style iOS 15–25 fallback with the same five destinations. The full specification and implementation were approved on 2026-10-23.
