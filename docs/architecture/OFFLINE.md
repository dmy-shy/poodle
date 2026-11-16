# Offline behavior and synchronization

Poodle supports offline reading of downloaded or previously cached content. Serverpod exposes the remote endpoints; Flutter repositories explicitly manage account-scoped SQLite records and local files. This is not automatic database replication. See [STATUS.md](../status/STATUS.md) for the wider implementation inventory.

## Implementation status

The current Flutter app caches the course list and details, explicit mobile course file downloads, notebook overviews and previously fetched answers/study artifacts/citation passages, the notification inbox, and calendar assessment dates. A remembered account can reopen these reads without a network connection. Cached screens show stale status and provide retry. Logout removes account-scoped copies. Calendar stores its lightweight snapshot in server-and-account-scoped SQLite on mobile (preferences on web). The live app refreshes the course list, calendar, and notification first page/unread count on sign-in, reconnect, and foreground return. The Synchronisation screen reports each available refresh result. Download metadata can be compared with saved files without fetching replacement bytes.

Private conversations now have Serverpod history/send/read endpoints and a live Flutter screen, but there is no conversation SQLite cache or Serverpod message stream. The UI polls while active; offline history and reconnect catch-up remain targets. Imported website and YouTube snapshots are not exposed by the current ingestion API, so their offline reading and explicit download remain unimplemented. Audio study artifacts provide a cached transcript, while audio playback requires a connection. The table distinguishes current behavior from targets.

See [ARCHITECTURE.md](ARCHITECTURE.md) for the overall design and [TESTING.md](../development/TESTING.md) for verification scenarios.

## Capabilities

| Action | Offline behavior |
| --- | --- |
| Read materials | Available when explicitly downloaded |
| Read imported websites or YouTube content | Target only; import and local snapshots are absent |
| Read study outputs | Previously fetched notebook answers, notes and Studio items where cached; audio playback still needs network |
| Read calendar and tasks | Cached assessment opening/deadline dates; task-list offline behavior is not established |
| Read private conversations | Target only; current message history requires the server |
| Change device-local settings | Language, text size and Wi-Fi-only download preference; dark theme, zoom and layout/sort preferences are targets |
| Publish/edit materials or assignments | Requires connectivity |
| Submit/replace work, grade, or reopen assignments | Requires connectivity |
| Generate AI output or import new sources | Requires connectivity |
| Send messages or update server read cursors | Requires connectivity |
| Change completion, account preferences, or notification read state | Requires connectivity |
| Download or refresh content | Requires connectivity |
| Remove local downloads | Available offline |

Do not queue offline writes or outgoing messages. Cached screens show offline/stale status and the last successful refresh. Cached deadlines and permissions are not authoritative for server actions.

## Downloads, sync, and unsync

- **Download:** mobile course-file downloads explicitly save authorized content for offline reading. The live UI exposes progress, failure, storage use and removal. Wi-Fi-only behavior is a stored preference; verify enforcement separately before claiming it as a release gate.
- **Sync:** fetch current authorized metadata and refresh selected downloads/source versions. Lightweight cached records refresh when connectivity returns, a relevant screen opens, or the app returns to the foreground. New large files require explicit download.
- **Unsync / Remove local download:** cancel an active download and remove its local files and download records. Preserve server content, enrollment, grades, and server-saved study artifacts. Download again later if still authorized.

Store source version and integrity metadata with each completed download. Make a new version available only after it finishes and passes validation; an interrupted refresh does not replace a usable prior copy. Clean up partial files after cancellation and offer retry after network/storage failures. Recheck authorization before starting or retrying a download.

Refresh linked calendar/task records rather than appending duplicates when deadlines change. Refresh course progress, account preferences, and notification state from the server when online; do not manufacture local completion or read-state updates while disconnected.

## Private-chat recovery (target)

The following behavior is not yet implemented. Cache fetched history in account-scoped SQLite. Offline reading must not send read acknowledgments to the server.

When a conversation opens, connectivity returns, or the app is foregrounded, fetch missed messages and current unread counts through Serverpod, and restore authenticated streaming subscriptions. Merge paginated history and stream events by server message ID. Catch up after a server restart rather than relying on delivery of every live event.

Sending requires connectivity. Display a message as sent only after server acknowledgment. If a response is lost after sending, retry with the original client idempotency key or reconcile history so the server does not create duplicates. Failed/uncertain sends remain visibly unconfirmed.

The server permits participants to read existing history after their shared-course relationship ends, but requires an active shared course for new sends. Reconnection must respect this distinction.

## Account isolation and authorization

Separate caches and downloaded files by authenticated account. Cancel subscriptions and downloads and clear account-specific SQLite data, files, and partial downloads on logout or account removal. Device appearance preferences may remain.

On each successful refresh, recheck membership and ownership and remove content that is no longer authorized. Previously downloaded content cannot be revoked instantaneously while a device is disconnected. Reauthorize all subsequent server requests and download URLs.
