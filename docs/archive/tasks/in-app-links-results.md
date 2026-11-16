# In-app links implementation results

Implemented 2026-10-23 following [the approved spec](../../specs/SPEC-in-app-links.md).

## Delivered

- Course Link activities open an embedded `flutter_inappwebview` 6.1.5 browser
  from both course route families after a fresh authorization/activity check.
- English/Ukrainian browser controls, progress, history Back, Close, reload,
  recoverable load errors, and blocked/unsupported-action messages.
- HTTPS validation for initial URLs and main-frame navigation; default TLS
  validation; no Poodle credentials, privileged bridge, or external-app handoff.
- Memory-only route payloads and account-generation guards prevent stale
  navigation after account changes. Existing PDF/DOCX handling is retained.
- Narrow Ukrainian layouts with enlarged text and iOS route back-swipe are
  covered by widget tests with an injected browser boundary.

## Platform adaptation

Android's existing AGP 9.1.0 cannot build this stable plugin because the plugin
uses the removed `proguard-android.txt` API. The project now uses AGP 8.13.2,
Kotlin 2.3.20 with the explicit Kotlin Android plugin, and the existing Gradle
9.3.1 wrapper. The debug APK builds successfully. Flutter warns that support for
AGP 8.13.2 will eventually be dropped; revisit when the plugin supports AGP 9.
The existing INTERNET permission and HTTPS-only network configuration remain.

The iOS plugin requires CocoaPods alongside the project's Swift Package Manager
dependencies. Flutter generated the CocoaPods integration and lockfile; the
Podfile explicitly retains the existing iOS 15 minimum. The simulator build
links successfully. Flutter warns that plugins without SPM support will need
an update in a future Flutter release. ATS remains intact.

## Verification

| Check | Measured result |
| --- | --- |
| `dart analyze` | No issues |
| `dart format` on changed Dart sources/tests | Complete |
| Focused browser policy, browser state, course state, browser routing and course screen tests | 27 passed |
| Full suite with coverage | 143 passed; 7 Home/onboarding golden mismatches |
| Android debug preview APK | Built successfully |
| iOS simulator debug preview app, unsigned | Built successfully |
| Connected iPhone app through Dart MCP | Hot restart succeeded; no runtime errors reported |

Full-suite output: `/tmp/poodle-in-app-links-tests.log`. The seven mismatches
are Home en/uk/empty/offline and onboarding 0 en/2 uk/9 en. Inspection shows
Home Refresh-button/content-position differences and an onboarding Feature
preview footer difference on screens not edited for this feature. Their
baselines were preserved; a pre-change full-suite baseline was not captured.

Coverage: URL policy 100% (10/10 lines), course ViewModel 92.6% (87/94), browser
ViewModel 92.5% (86/93), browser screen 98.1% (105/107). The native adapter is
replaced by a fake in widget tests and requires native interaction acceptance.

## Pending acceptance

The connected iPhone app has no Flutter driver extension. A full app relaunch
through the user's `serverpod start` workflow with configured `lib/driver.dart`
was requested; the new native plugin also needs that relaunch. No server or app
was started by CLI. Serverpod MCP tools are not exposed in this session, so
Serverpod server/Flutter log review could not be performed.

On Android and iOS, still verify real website load/navigation/redirects,
history Back, Close, reload, offline retry, rejected destinations,
popup/download notices, sign-out, scrolling/text selection, and
TalkBack/VoiceOver. Native builds and fake-backed widget tests do not establish
these interactions. No database migration or backend changes were required.
