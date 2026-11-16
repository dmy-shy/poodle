# Notifications implementation status

Source review: 2026-11-15. This page supersedes the 2026-11-05 checkpoint. See [STATUS.md](STATUS.md) for the full LMS inventory.

## Implemented

- Serverpod stores recipient-scoped notification records. `NotificationService` writes assignment, changed-deadline and published-grade events inside the triggering teaching transaction, with a recipient/event key to avoid duplicates.
- Authenticated `notifications` endpoints list pages, count unread items, fetch one item, mark one read and mark all read. The live Flutter Notifications screen uses those endpoints with category/unread filters, pagination, refresh, read actions and related-activity navigation.
- The Flutter repository caches inbox pages and unread count for the signed-in account. [OFFLINE.md](../architecture/OFFLINE.md) describes the cache boundary.
- `push_devices_endpoint.dart` persists an authenticated installation/token lease and supports owner-bound unregister. The model and migration `20261104235616521-push-device-registration` exist; this is a backend registration contract, not working push delivery.
- Native Firebase config files are present for Android and iOS. `main.dart` initializes Firebase on mobile. Android calls `startAndroidPushRegistration`, requests permission, registers with Firebase and prints the installation ID in debug builds.

## Not connected yet

- Flutter does not call the Serverpod `pushDevices.register` or `unregister` endpoints. The Android callback receives/logs an installation ID rather than storing an account-bound delivery token. iOS does not start an equivalent registration flow.
- No FCM/APNs delivery adapter, delivery outbox/worker, retry or invalid-token cleanup is wired. A persisted inbox event does not produce a remote push.
- Preferences, deadline reminders and general announcement/message notification events are not implemented. Existing event producers are the teaching assignment/grade paths.
- Permission explanation, tap routing, signed-in token lifecycle and actual Android/iOS delivery acceptance remain open. The inbox remains usable without push.

## Evidence and next checks

Source: `poodle_server/lib/src/modules/notifications/`, `poodle_server/lib/src/modules/teaching/teaching_service.dart`, `poodle_flutter/lib/data/repositories/notifications_repository.dart`, `poodle_flutter/lib/features/notifications/`, `poodle_flutter/lib/firebase_initialization.dart`, and `poodle_flutter/lib/push_registration.dart`.

Existing backend and widget tests cover inbox operations and recipient isolation. They do not establish provider delivery. Finish account-bound token handling, delivery after commit, preference/reminder policy and mobile tap/device tests before describing push as complete. Follow [AGENTS.md](../../AGENTS.md) for Serverpod migration, restart and log checks if schema or runtime code changes.
