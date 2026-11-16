# Google authentication implementation

Android/iOS login and invitation-only signup use Serverpod Google ID-token verification and JWT sessions. Existing accounts explicitly link a matching verified Google email in Account. One Google subject per account; unlinking is deferred. Google-only accounts pass the existing account authorization checks. Remember me uses the existing credential storage and generation leases. Preview authentication remains separate.

## Configuration

- Server: supply the Google web OAuth client JSON through the ignored `googleClientSecret` password setting. Without it Google calls fail closed; email authentication remains available.
- Flutter: set the public web client ID and the iOS client ID prefix (the part before `.apps.googleusercontent.com`) in `poodle_flutter/google_oauth.properties`. Android and iOS builds read this file automatically. iOS derives its callback scheme from the same prefix.
- Register Android package `com.example.poodle_flutter` and signing SHA fingerprints; register iOS bundle `com.example.poodleFlutter`. Register any changed production identifiers separately.
- Rebuild the mobile app after editing the public IDs. Launch from Android Studio or run `flutter run` without Google flags. Restart Serverpod after updating its secret.

## Implementation detail

Google operations are generated methods `emailIdp.googleLogin(idToken)` and `emailIdp.linkGoogle(idToken)` on the existing handwritten auth endpoint. The incremental watcher repeatedly omitted newly added endpoint files; using the existing endpoint avoids exposing unrestricted SDK Google endpoints and keeps client generation compatible.

## Acceptance pending

No database migration is needed: Google links use the existing SDK table. Full mobile acceptance requires a Google account already linked to Poodle or covered by an active invitation.

Automated test results are recorded below after verification. The broader Flutter suite currently contains onboarding tests expecting ten frames against five current stories; these are outside the Google changes. Full coverage and real-device acceptance gates must be established before release.

## Automated verification

- Full server suite: 74 passed, including ten Google integration cases plus claim validation.
- Affected Flutter data and live-auth widget suites: 45 passed.
- Analysis: no errors or warnings; two existing notebook style informational diagnostics.
- The first Google validation test was observed failing before its implementation. Additional endpoint, gateway, and widget regression coverage was added during integration; this was not a strict red-before-green cycle for every slice.
- Full Flutter run encountered the pre-existing onboarding frame-count failures and generated-contract instability during edits; affected suites were rerun successfully after final generation. Full-suite coverage gates have not been established.
- Android debug APK, iOS debug simulator, live web, and preview web builds passed in the initial implementation.

## Google Cloud migration verification

- Static analysis and the 11 focused Serverpod Google auth tests passed. Serverpod hot-restarted through MCP and its runtime logs showed a successful reload.
- Android Studio built a debug APK and launched the iPhone 17 app without Google flags. Device Hub showed Google's account page for Poodle. A live Poodle session still needs verification with a linked account or active invitation.

## Configuration locations

- `poodle_server/config/passwords.yaml`: add `googleClientSecret` for the server run mode using the downloaded Web OAuth client JSON. Keep the secret in this ignored file.
- `poodle_flutter/google_oauth.properties`: set `GOOGLE_SERVER_CLIENT_ID` to the same web client ID as `googleClientSecret`, and `GOOGLE_IOS_CLIENT_ID_PREFIX` to the prefix from the iOS OAuth client in the same Google Cloud project.
- Register the current Android package and signing fingerprints and iOS bundle identifier in Google Cloud. Restart the user-managed launcher and rebuild the mobile app after adding these values.
