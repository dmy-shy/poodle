# iOS tab bar implementation results — 2026-10-23

## Delivered

- iPhone iOS 26+ navigation uses an app-owned UIKit platform view with system `UIGlassEffect`, native buttons and SF Symbols. Four labeled tabs (Home, My courses, Calendar, Notifications) share a floating glass capsule; Search is a separate glass circle.
- Flutter owns route selection. Per-view channels synchronize native taps, direct routes, locale, text scale, selected state, motion preference and scroll minimization. Downward scrolling minimizes; upward scrolling or tapping the minimized active control expands. Reduced Motion and accessible navigation retain the expanded bar.
- iOS 15–25 uses a Cupertino fallback with the same five destinations. iPhone landscape retains bottom navigation; wide layouts retain the existing Material rail.
- Home exposes Messages and More; More retains account/sign-out. Calendar shortcut selects Calendar on iOS. Calendar, Notifications and Search remain labeled previews. No live search or calendar backend was added.
- Existing branches keep their indices; protected Calendar/Search branches are appended. Tab changes retain Home scroll and nested course state. English/Ukrainian copy is generated from ARB sources.
- Android retains its Material destinations, icons and layout. Cupertino theming is scoped to iOS. No package dependency, database model or migration was added.

## Verification

- New iOS assertions were run before implementation and failed for missing navigation/utility controls.
- `rtk proxy dart analyze`: no issues found.
- `rtk proxy dart format --output=none --set-exit-if-changed` on the seven changed handwritten Dart/test files: zero changes.
- All eight new iOS navigation widget tests passed. Coverage includes native channel route synchronization, native scroll minimize/expand, Reduced Motion, fallback destinations, route guards/sign-out, state retention, Calendar shortcut, nested courses, landscape, Android destinations, English/Ukrainian at 320 points and 2× text.
- Full `rtk proxy flutter test --no-pub --concurrency=1`: **128 passed, 4 failed**. Remaining failures are dashboard goldens `home_en_light`, `home_uk_light`, `home_empty_light`, `home_offline_light`. No golden was updated.
- To isolate these failures, copied the package to `/private/tmp/poodle-tabbar-android-baseline`, substituted a simple Material-only shell without the new iOS bridge/scroll/theme behavior and removed added content-bottom padding. The same four visual tests failed; all four rendered PNGs were byte-for-byte identical to this implementation. This demonstrates the remaining dashboard baseline differences are independent of the new navigation. The stored masters still include an explicit Refresh button/currently absent content layout. The existing offline interaction test was corrected to use the actual RefreshIndicator pull gesture.
- Initial unconditional Cupertino theming caused two additional visual mismatches; scoping it to iOS fixed those. All other visual tests passed in the final suite.
- Android debug APK build passed: `rtk proxy flutter build apk --debug --no-pub -t lib/main_preview.dart`. Gradle reported the existing `flutter_web_auth_2` Kotlin plugin migration warning.
- iOS simulator debug build passed: `rtk proxy flutter build ios --simulator --debug --no-codesign --no-pub -t lib/main_preview.dart`. Xcode compiled and linked the new Swift view and registration successfully.
- Dart MCP connected to the user's existing iPhone app, hot restart succeeded, and runtime error inspection returned **No runtime errors found**.

## Remaining native acceptance

Hot restart cannot add new Swift code to an already installed runner. Rebuild/relaunch the iOS app through the normal project workflow to load the native bridge. Until then, capability detection safely retains Cupertino navigation in that runner.

The Serverpod MCP runtime tools are not exposed in this session, so Serverpod hot restart and server/Flutter log-tail checks could not be performed. No server was started. Dart MCP restart/error inspection supplied partial runtime evidence. Flutter driver reported that the extension is not enabled in the running app, so interactive driver acceptance/screenshot capture was unavailable.

After native relaunch, check the actual glass backdrop over content, all five taps/selected semantics, minimize/re-expand gestures, home-indicator insets, final content reachability, keyboard behavior, English/Ukrainian native labels at enlarged text, VoiceOver and Reduce Motion. Check an older iOS runner for fallback appearance. Widget platform-view mocks verify the protocol and routing, not UIKit rendering. Android TalkBack/device appearance also remains a manual acceptance check.

## Main files

- `poodle_flutter/lib/app/ios_navigation_bar.dart`: platform choice, Cupertino fallback and native bridge.
- `poodle_flutter/lib/app/signed_in_shell.dart`: platform destination mapping, secondary controls and scroll behavior.
- `poodle_flutter/ios/Runner/PoodleTabBar.swift`: native Liquid Glass surface.
- `poodle_flutter/ios/Runner/AppDelegate.swift` and Xcode project: view registration and compilation.
- `poodle_flutter/test/widget/ios_navigation_test.dart`: eight new platform/routing tests.

The approved specification, plan, task list, architecture and testing guidance are updated alongside the implementation.

## Padding/selection correction — 2026-10-23

The user's native screenshot exposed a duplicate blue selected-button highlight over the app's selection capsule. Native buttons now expose selection through accessibility traits and the app's tint/capsule, without also entering UIKit's selected visual state. The capsule has 6-point outer padding and 2-point horizontal separation from its cell bounds. Icons and labels have a 4-point gap and 6-point vertical content padding. Flutter reserves the complete native icon/label/padding height, including multiline Ukrainian labels measured at semibold weight. Android is unaffected.

Verification: Dart analysis clean; formatting applied; all eight iOS navigation tests passed. Native simulator rebuild result recorded below. The running app received a Dart hot restart; the Swift correction still requires native rebuild/relaunch to appear.

Correction build: iOS simulator debug build passed (Xcode 33.3 seconds). Dart MCP runtime inspection after restart reported no errors. Native visual confirmation after relaunch remains pending.

## Single-line label correction — 2026-10-23

The native iOS 26+ button font is reduced from 11 to 10 points. Button configuration and UILabel both disable title wrapping; labels shrink to their available cell width instead of breaking Notifications/Сповіщення across lines. Full localized accessibility labels are retained. Flutter now measures the native labels as one line and sends scaling relative to the same 10-point base font. Existing local bar padding customizations, Android and the older-iOS fallback are preserved.

The supplied Medium article describes UITabBarItem font appearance; this app owns native UIButton labels, so the font adjustment is applied directly to their configurations. Dart analysis and format checks passed. Runtime hot restart succeeded. Final focused test/build results follow.

Single-line correction verification: all eight navigation widget tests passed; iOS simulator debug build passed (Xcode 44.5 seconds); runtime error inspection found no errors. The native font change requires rebuild/relaunch and still needs visual confirmation in the installed runner.
