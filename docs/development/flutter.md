# Poodle Flutter

The current feature inventory and open release checks are in
[STATUS.md](../status/STATUS.md). This package has live and explicit preview entry points.

The default `lib/main.dart` connects to Serverpod through `LiveAuthRepository`.
The SDK manages JWT issuance, refresh and secure credential serialization. The
app publishes a signed-in session only after `account.me` succeeds. Remember me
uses secure storage; otherwise credentials remain in memory. Connection or
storage failure during restore presents recovery actions. The live composition
also injects institution, course, teaching, student learning, notebook, search,
messaging and notification repositories.

## Development

The developer runs `rtk proxy serverpod start` from `poodle_server`; it launches
the configured Flutter app and watches source changes. Follow the project's MCP
workflow for restarts, migrations, logs and app interaction.

Server URL resolution uses Serverpod's `getServerUrl` (`SERVER_URL` override or
`assets/config.json`). The checked-in asset targets `http://localhost:8080`.
Use `http://10.0.2.2:8080` for Android emulator access to the host. Release builds
require HTTPS. Debug loopback HTTP is allowed; another development host requires
`--dart-define=ALLOW_INSECURE_DEVELOPMENT_SERVER=true`. Android cleartext access
is enabled only in the debug manifest. To run on a physical iPhone against the
local Serverpod server, keep the phone and Mac on the same Wi-Fi network, find
the device ID with `flutter devices`, then from `poodle_flutter` run:

```sh
rtk proxy bash tool/run_local_device.sh <device-id>
```

The script passes the Mac's current Wi-Fi address as `SERVER_URL`. iOS requests
local network access on first connection. Physical-device secure storage
acceptance remains pending.

## Authentication flows

- Sign in with an existing email/password account.
- Eligible users can use Google login; an existing account can link a matching
  verified Google identity in Account. Provider configuration is required.
- Platform operators review university requests; university administrators
  manage institution invitations. Invited users verify their email and choose a
  password. Development verification codes appear in server logs.
- Password reset uses request → verification → new password. Existing sessions
  are revoked by the backend after reset.
- Logout immediately clears the account. If remote revocation is unconfirmed or
  local deletion fails, the signed-out screen offers a retry.

The server bootstraps development personas only in development and can issue the
first platform-operator invitation from its configured mailbox. Teacher
eligibility is distinct from active course membership. Production mail and
delivered-link acceptance remain release work.

## Explicit preview

`lib/main_preview.dart` retains simulated authentication, `PREVIEW_SCENARIO`
and fixture destinations labeled Feature preview. The live `lib/main.dart`
shows role-aware Home and Serverpod-backed feature screens. The current
onboarding catalog contains five stories; its completion is installation-scoped
and survives logout. `ONBOARDING_PREVIEW=true` forces an isolated tour.

## Verification

```sh
rtk proxy flutter analyze --no-pub
rtk proxy flutter test --no-pub --coverage --concurrency=1
rtk proxy flutter build web --debug --no-pub --target lib/main.dart --output /tmp/poodle_identity_live_web
rtk proxy flutter build web --debug --no-pub --target lib/main_preview.dart --output /tmp/poodle_identity_preview_web
```

The commands above are examples, not a claim of a fresh passing full suite.
For dated evidence and remaining device checks, see [STATUS.md](../status/STATUS.md)
and [TESTING.md](TESTING.md).
