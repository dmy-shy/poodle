# Spec: In-app browser for course links

Status: approved for implementation by the user's “Implement this spec” request
on 2026-10-23. Course Link activities and explicit unsupported popup/download
messages are the accepted first-release scope. This spec changes only the external-link
opening behavior in [SPEC-course-view.md](SPEC-course-view.md). Its earlier
"open via the platform browser" requirement is superseded for course link
activities when this spec is approved and implemented.

## Objective

Let a signed-in student or teacher open an authorized HTTPS course link in a
Poodle screen, read the page, follow ordinary web links, refresh, and return to
the same course activity without switching apps. The first entry point is the
**Open website** button on the Link activity shown in the supplied screenshot.
The shared Material 3 interface remains bilingual (English/Ukrainian) and
usable on Android and iOS.

### Scope assumptions for review

1. "Both platforms" means Android and iOS. Desktop and Flutter web are outside
   this mobile feature's acceptance scope.
2. This applies to course **Link** activities from both `/courses/...` and
   `/home/course/...`, including the explicit preview app. It does not turn all
   selectable text, onboarding copy, or unrelated app links into browser routes.
3. The screenshot is a reference for the entry point and surrounding Poodle UI,
   not an instruction to reproduce pixel positions or its claim that the link
   opens in the platform browser.
4. The initial destination remains an explicit HTTPS URL supplied by the
   authorized course activity. No arbitrary URL entry field is added.

## User behavior and success criteria

1. Tapping **Open website** re-reads the activity through `CourseRepository`
   before opening it. If access was revoked, the activity changed, or the URL is
   missing/invalid, stay on the activity and show a localized error. Do not open
   a stale URL from the rendered row.
2. A successful tap opens a browser route within the current signed-in shell.
   Keep the existing tab selection and Poodle styling. The browser displays a
   clear title or destination host, a close/back control, reload, and a loading
   indicator. The source activity remains reachable when the browser closes.
   Change the activity hint from "Opens in your browser" to accurate in-app
   wording in both languages.
3. Ordinary HTTPS navigation, including redirects, stays in the same WebView.
   The current page title/host and loading state update. A main-frame request
   to a non-HTTPS or malformed URL is blocked with a localized explanation;
   there is no silent handoff to another app. JavaScript-driven popup windows
   and downloads are not part of this first release; when such an action cannot
   be handled safely in the same view, show an understandable unsupported-action
   message instead of a blank page or crash.
4. The in-screen back control and Android system Back go to prior WebView
   history when available, otherwise close the browser route. On iOS, the
   visible back control has the same behavior and supported route back-swipe
   closes the browser when there is no web history. Reload retries the current
   page; it must not duplicate the browser route.
5. A top-level load failure, no connection, or TLS failure shows a localized
   error and retry action inside the browser screen. Subresource errors do not
   replace an otherwise usable page. The screen remains closable at all times.
6. The browser never receives Poodle's Serverpod JWT, app auth headers, or
   privileged JavaScript bridge. The URL is not placed in a route path or
   logged by new application code. Web content is untrusted and cannot navigate
   to privileged app routes through custom schemes.
7. Signing out or switching accounts closes/protects the browser route through
   the existing auth guard. A pending activity fetch or page-load callback may
   not reopen the prior user's link or update a disposed screen.

### Out of scope

Website import, downloads, file uploads, browser tabs, bookmarks, address-bar
editing, cross-site sign-in support, browser extensions, and changes to the
Serverpod course schema or endpoint contract. PDF/DOCX opening remains governed
by the course-view spec.

## Tech stack and platform adaptation

- Use the stable `flutter_inappwebview` 6.1.x package (currently 6.1.5 on
  [pub.dev](https://pub.dev/packages/flutter_inappwebview)); lock the resolved
  version in the workspace lockfile. Embed its `InAppWebView` widget in a
  Flutter route, rather than showing a separate native browser window. The
  package uses Android WebView and iOS WKWebView, so the shared screen needs
  platform-specific build and interaction verification. See the plugin's
  [setup requirements](https://inappwebview.dev/docs/intro/) and
  [navigation/window guidance](https://inappwebview.dev/docs/webview/in-app-webview/).
- **Android:** confirm the resolved Flutter `minSdk`, `compileSdk`, and Gradle
  plugin meet the package minimums (API 19 with hybrid composition, compile API
  34, AGP 7.3). The main manifest already declares `INTERNET`; retain that
  permission and do not enable cleartext traffic. Verify native plugin
  registration after a full app rebuild, system Back with web history, touch
  scrolling, text selection, loading/error states, and TalkBack.
- **iOS:** the project targets iOS 15 with Swift 5, above the package's iOS 12
  minimum. Verify package linkage with this project's existing iOS package
  setup, a fresh simulator/device build, WKWebView navigation, safe areas,
  route back-swipe, text selection, loading/error states, and VoiceOver. Keep
  App Transport Security intact; this feature accepts HTTPS only.
- Use one Material 3 browser layout on both platforms. Preserve platform
  navigation gestures and accessibility behavior rather than maintaining
  parallel Android/iOS screen designs. Do not assume a hot restart loads a
  newly added native plugin; native build/relaunch is a verification gate.

## Commands

Run from `poodle_flutter/` unless noted. The `rtk` prefix follows the project
shell instructions. These are implementation and verification commands; this
document-only specification does not run them.

```sh
rtk proxy flutter pub get
rtk proxy dart analyze
rtk proxy dart format lib test
rtk proxy flutter test --concurrency=1 test/widget/course_screen_test.dart
rtk proxy flutter test --concurrency=1
rtk proxy flutter build apk --debug -t lib/main_preview.dart
rtk proxy flutter build ios --simulator --debug --no-codesign -t lib/main_preview.dart
```

The user starts the live server and app with `serverpod start`. For live
verification, use the Serverpod MCP tools for hot restart and logs; if the
server is unavailable, stop and ask the user to start it. Use its Flutter DTD
and the Dart MCP driver when testing the running app. No migration is expected.

## Project structure and implementation boundary

| Location | Responsibility |
| --- | --- |
| `poodle_flutter/pubspec.yaml` and workspace `pubspec.lock` | Package declaration and resolved version |
| `poodle_flutter/lib/features/courses/presentation/views/` | Browser route View, controls, loading/error presentation |
| `poodle_flutter/lib/features/courses/presentation/view_models/` | Browser state and commands if the View needs a separate ChangeNotifier |
| `poodle_flutter/lib/data/services/` | Testable URL policy and WebView platform adapter, if needed; no feature UI state |
| `poodle_flutter/lib/app/poodle_app.dart` | Browser route in both existing course entry branches, behind auth guard |
| `poodle_flutter/lib/app/l10n/app_en.arb`, `app_uk.arb` | User-facing browser copy; generated localization files are never edited |
| `poodle_flutter/test/unit/`, `test/widget/` | URL policy/state and route/UI behavior with a controllable WebView boundary |

Keep the existing `CourseRepository.activity` access recheck. Refactor the
link-specific branch of `CourseViewModel.open` so navigation can use its fresh,
validated URL; leave PDF/DOCX handling in `CourseFileService`. Do not pass the
destination through query parameters or persist it as course state. Native
WebView callbacks and controller lifetime belong to the browser route.

## Code style

Follow existing Dart naming, `dart format`, feature folders, and explicit
failure handling. A small pure policy function should be independently
testable; for example:

```dart
bool isAllowedWebDestination(Uri uri) =>
    uri.scheme == 'https' && uri.host.isNotEmpty && uri.userInfo.isEmpty;
```

Apply the same policy to the initial URL and top-level navigations. Validate
the final navigation behavior on both native WebViews, since callbacks for
redirects and new windows differ by platform.

## Testing strategy

- **Unit:** valid/invalid initial URL and main-frame navigation decisions;
  stale or revoked activity recheck; sign-out/canceled async work. Fake the
  browser boundary so unit tests do not need a native WebView.
- **Widget:** both course route families open the browser and return to the
  source activity; English/Ukrainian labels and errors; loading/retry/reload;
  accessible controls and narrow screen with enlarged text. Use a fake browser
  View/adapter for deterministic route tests, not a live website.
- **Native acceptance:** build and use the `https://docs.flutter.dev/learn`
  preview link on Android and iOS. Check initial load, an ordinary HTTPS link,
  redirect, web-history Back, close, reload, offline/retry, blocked non-HTTPS
  navigation, and auth sign-out. Record any site-specific popup/download
  limitation rather than treating a widget test as native proof.
- **Regression:** existing course, auth, and preview navigation tests remain
  green. Follow [TESTING.md](../development/TESTING.md) and the project analysis/format,
  runtime/log checklist when implementation begins.

## Boundaries

- **Always:** reauthorize the activity before launch; validate HTTPS and
  navigation; localize visible copy; preserve the signed-in guard; test both
  native platforms; keep WebView failures recoverable.
- **Ask first:** expanding this to unrelated hyperlinks, supporting HTTP or
  custom URL schemes, adding downloads/file permissions, or changing Serverpod
  data and endpoint contracts. The requested `flutter_inappwebview` dependency
  is already authorized by this request.
- **Never:** edit generated Serverpod client/server or generated localization
  code, send JWTs into website requests, bypass TLS errors, enable global
  cleartext/ATS exceptions, or silently hand unsupported navigation to an
  external app.

## Implementation decisions

The user's implementation request accepts course Link activities as the scope
and clear unsupported-action messages for popups/downloads. A link whose type
or URL changed during the access recheck requires refreshing the activity before
opening it. Browser route payloads stay in memory and carry the repository's
account generation, so restoring an old route cannot reopen another account's
web content. See [implementation plan](../archive/tasks/in-app-links-plan.md).
