# Implementation plan: iOS tab bar

The user approved [SPEC-ios-tab-bar.md](../../specs/SPEC-ios-tab-bar.md) and requested implementation on 2026-10-23. That request authorizes executing this plan and its tasks in the same turn. Existing course and onboarding records below remain historical records.

Dependency order: platform/routing regression tests → localized destinations and stable branch mapping → native iOS 26+ bar and Cupertino fallback → secondary Home access → integration checks and documentation.

1. Add behavioral tests for iOS destinations, protected Calendar/Search routes, Messages/More return paths, Android's existing destinations, and preserved tab state. Confirm the new iOS assertions fail first.
2. Keep the five existing branch indices stable; append Calendar and Search. Map visible platform destinations to branches rather than assuming visual and router indices match. Wide rails retain their existing destinations. Treat hidden iOS branches as Home utilities with a visible return control.
3. Use a small app-owned UIKit platform view on iOS 26+: system `UIGlassEffect`, SF Symbols, selected tab semantics, and a separate circular Search button. Send route selection, labels, text scaling, motion preference, and minimized state through a per-view channel. Avoid the linked package: its native implementation does not synchronize later `currentIndex` changes. Older iOS uses `CupertinoTabBar` with the same five destinations. Android retains Material widgets.
4. Observe only vertical scrolling from the active shell. Use directional hysteresis to minimize/expand, disable minimization for reduced motion/accessibility, and reset it when changing destinations. Reserve enough inset for reachable content while allowing content behind the floating native surface. Home gains iOS Messages/More entry points and its Calendar shortcut selects Calendar.
5. Analyze and format, run focused and full Flutter tests, build native iOS and Android targets, and use the available MCP runtime tools for restart/log review. Document unavailable tool/device checks precisely. No backend change or migration is needed.

Risks: platform-view disposal and late channel events (per-view lifetime and mounted checks); route/visual selection mismatch (explicit mapping tests); small Ukrainian labels and enlarged text (adaptive measured native label height and fallback layout tests); native plugin linkage (fresh simulator build); scroll jitter (direction threshold and root vertical notifications only).

Work is sequential in this session. [todo.md](todo.md) tracks acceptance and results.

---

# Historical implementation plan: Course views by UUID

Status: approved for implementation by the user on 2026-10-22. Based on the approved
[course-view specification](../../specs/SPEC-course-view.md), the approved
[backend capability map](../../architecture/CAPABILITY-MAP-backend.md), and
[architecture](../../architecture/ARCHITECTURE.md). This is Phase 2 of the spec-driven workflow;
implementation tasks and code changes follow plan approval in later turns.

## Delivery boundary

Deliver member-only course listing and UUID detail routes, ordered read-only
content, two development/test seed courses, and matching explicit-preview
fixtures. This slice supplies the `course-membership` read/authorization boundary
needed by `course-content`; it does not implement general course editing,
enrollment administration, quiz attempts, grading, completion, or offline sync.
The signed-in Home may continue to label unrelated task/announcement data as
preview. Its course cards must use authorized course records and UUIDs.

## Dependency graph

```text
identity migration/runtime acceptance (existing pending work)
  → course + membership schema/authorization
    → section + typed activity schema/read API
      → development/test seed + private sample files
        → shared authenticated Flutter course repository
          → course list/detail/activity UI + Home integration
            → mobile and authorization acceptance
```

The schema/read boundaries are sequential because content references a course
and every content read needs the membership guard. Preview fixture UI can be
built after the common repository contract exists, in parallel with live data
mapping. File-opening adapters can be developed against fakes once their
interfaces are fixed. All integration paths converge before acceptance.

## Technical decisions

### IDs, models and endpoint boundaries

- Use Serverpod `.spy.yaml` UUID primary keys (`UuidValue?`,
  `defaultPersist=random_v7`) for courses, memberships, sections and
  activities. Seed IDs are fixed valid UUIDs, explicitly supplied when inserted;
  UUIDs are the only course/activity route identifiers. Add a unique membership
  constraint for `(courseId, authUserId)` and explicit section/activity order
  indexes. No URL slug or sequential database ID appears in a course route.
- The `course-membership` slice owns `Course`, `CourseMembership`, role
  (`teacher`/`student`) and active-state checks. A service reuses
  `AccountAuthorization.requireAccount`, then checks active membership for the
  requested course. Admin status alone does not satisfy the check. Expose a
  member-only `listMyCourses` and `getCourse(UuidValue courseId)` contract.
  Unknown and unauthorized UUIDs produce a nondisclosing result.
- The `course-content` slice owns `CourseSection` and `CourseActivity` common
  fields plus type-specific detail records for file, link, announcement and
  read-only assessment. Use explicit typed detail DTOs so a URL never carries
  test or announcement text. Expose `getCourseContent(courseId)`,
  `getActivity(courseId, activityId)` and `getFileUrl(courseId, activityId)`.
  Every endpoint calls the membership guard; student queries exclude drafts,
  teacher queries label them. The server supplies availability from UTC/server
  time. Section order and activity order are fields, not UUID sort order.
- The Flutter router validates canonical lowercase hyphenated UUID text before
  making a request; malformed, numeric and slug path values show unavailable.
  Authenticated route guards hide course screens after sign-out. Serverpod
  checks remain authoritative for a forged client or stale route. A valid
  unknown UUID and a forbidden course use the same user-facing unavailable
  state. Direct activity and file access rechecks membership and publication.

### Seed and private files

- Add two fixed UUID course fixtures with original English/Ukrainian sample
  content: an information/announcement section and materials/lab/module
  sections containing one PDF, one DOCX, an HTTPS link, an announcement, a
  module and a lab test. Keep seed constants/data in a development/test-only
  module; the preview adapter uses the same IDs and shape without calling a
  live endpoint. Remove the legacy `course-design`/`course-writing` route IDs.
- Seed only in development, or explicitly in isolated tests. After the existing
  admin bootstrap, attach teacher membership only to its account marked
  `developmentBootstrap`. If that account is absent, skip the membership and
  report the seed state; never promote a different admin. Insert missing named
  seed records by ID without overwriting teacher-edited content or granting
  all users membership. A collision with an unrelated record fails clearly.
- Use the already configured **private** Serverpod storage. Development uses
  its `DatabaseCloudStorage('private')` fallback; production storage topology
  remains unchanged. Use the user's supplied PDF/DOCX sample files in shared
  preview assets, store them under checksum-based private seed paths only when absent,
  and persist `storageId`, path, MIME, size and checksum in file detail rows.
  Repeated seeding verifies the expected file identity and never overwrites an
  unrelated object. Handle a storage/database partial failure idempotently on
  retry. No arbitrary user upload or document extraction enters this slice.
- `getFileUrl` verifies account, active membership, publication and file type
  before calling Serverpod's `temporaryDownloadUrl` for the private object.
  Use a short lifetime (target 60 seconds), never persist or log the URL, and
  request a fresh one for each open. A URL already issued remains usable until
  expiry; this is a bounded property of signed URLs, so keep the lifetime
  short and test that revocation blocks new URLs.

### Flutter data, navigation and opening actions

- Give the app one session-scoped `CourseRepository` interface with live and
  preview implementations. The live service must share the existing Serverpod
  client's auth session manager with `LiveAuthRepository`; do not create an
  independent token store. Map generated DTOs to immutable course models.
  The repository owns refresh/error mapping, cancellation generations and
  account clearing. Home and Courses ViewModels both consume it; repositories
  do not depend on each other. The preview repository is deterministic and
  retains a visible `Feature preview` label.
- Replace `/courses` and `/home/course/:id` placeholders with a list and
  UUID-based detail. Add an equivalent detail entry from the Courses branch,
  using the same ViewModel. Preserve source-tab back behavior and provide a
  safe parent for direct entry. A course ViewModel loads the ordered sections;
  an activity ViewModel loads one typed detail and previous/next IDs in the
  authorized sequence. Views only render state and forward actions.
- Add `pdfrx` for an in-app PDF viewer using Poodle's chrome, `open_filex` for
  DOCX platform handoff, `path_provider` for account-scoped temporary files,
  and `url_launcher` for explicit HTTPS links. As of this plan, review package
  constraints against `pdfrx 2.6.5`, `open_filex 5.0.0`,
  `path_provider 2.1.6`, and `url_launcher 6.3.3` before adding direct
  dependencies. The iOS project targets 15.0, above the documented minimum
  for these file handlers. A native/plugin smoke build is an early checkpoint.
  Fetch PDF/DOCX only after `getFileUrl`, store in a session-scoped temporary
  directory, open PDF in-app and DOCX with the platform handler, then remove
  Poodle's copy on close/sign-out and sweep leftovers at next app start.
  Report a missing DOCX handler. A receiving app may retain its own copy;
  Poodle cannot revoke that copy after user-initiated handoff.
- External-link rows show the host and open only an HTTPS URI after a tap.
  Localize UI chrome/status with ARB files; display authored seed text as stored,
  and UTC timestamps in device time. Do not add grade, attempt, fabricated
  progress, unread or manual-completion actions.

## Ordered checkpoints

1. **Prerequisite and contract check.** Confirm the identity migration can run
   and that protected `account.me` works. Review the current generated model
   conventions, Serverpod private storage, and shared auth-client lifecycle.
   If Serverpod MCP reports the user's server stopped, pause runtime work and
   ask them to start it; never start it from the agent.
2. **Membership vertical slice.** Add course/membership models, migration,
   reusable authorization service and member-only list/get endpoints. Verify
   two-account cross-course isolation, admin-without-membership denial,
   inactive membership and unknown UUIDs in server tests before content work.
3. **Content vertical slice.** Add ordered section/activity/type records and
   read endpoints. Verify draft filtering, direct activity ID denial, stable
   ordering, UTC availability boundaries and typed result mapping. Create/apply
   migrations through Serverpod MCP after analysis/formatting.
4. **Seed and file boundary.** Add the user's PDF/DOCX files, development/test
   seed and private storage linkage. Verify repeated runs, collisions,
   changed content preservation, missing bootstrap account behavior and
   authorized/denied/expired file links with the embedded test database and
   a storage fake where appropriate.
5. **Flutter repository and preview.** Compose one shared authenticated client
   and course repository, add matching preview fixtures, clear state on session
   change and make Home course cards refer to repository UUIDs. Verify no
   stale account response or fixture progress leaks into live views.
6. **Screens and openers.** Build Courses list, course detail, activity detail,
   section index, PDF/DOCX/link handlers and localized empty/error states.
   Verify route rejection, tab/back behavior, large text, semantics, both
   locales, and native plugin builds on Android/iOS before full acceptance.
7. **Integrated acceptance.** Follow AGENTS.md order: `dart analyze`,
   `dart format`, necessary MCP migrations, MCP hot restart, applicable server
   `dart test` and Flutter tests, then MCP server/Flutter logs. Use DTD and
   Dart Flutter driver for requested live app interaction. Confirm seed admin
   → list → course → PDF/DOCX, and nonmember direct-route/file denial. Record
   any unavailable MCP/device evidence as pending rather than claiming success.

## Risks and mitigations

| Risk | Mitigation / checkpoint |
| --- | --- |
| Identity migration or development bootstrap is not live yet | Treat it as the first integration prerequisite; keep course source/test work separate until the user's runtime is ready. |
| Serverpod MCP tools are unavailable in this chat | Do not replace normal migration/restart/log operations with CLI; report the exact blocked runtime checkpoint. The documented CLI fallback applies only when the server cannot start at all. |
| A course UUID is guessed or a stale card remains visible after revocation | Server checks account and active membership on every list/detail/activity/file request; invalidate session-scoped repository state and use nondisclosing unavailable UI. |
| Seed rerun damages teacher content or grants access broadly | Fixed IDs, seed ownership checks, insert-only behavior, one marked bootstrap account, isolated test fixtures and idempotence tests. |
| Private file URL outlives membership revocation | Issue only after authorization, expire quickly, never cache/log it, and deny subsequent URL requests; document the short-lived capability window. |
| Native PDF/DOCX plugin or handler differs by platform | Add dependencies and smoke-build early; wrap handlers behind services, test missing-handler behavior, and record Android/iOS device checks. |
| DOCX handoff leaves a copy in another app | Require explicit user tap, use Poodle temporary storage, clean Poodle's copy, and avoid describing the handoff as revocable/offline protected. |
| Current Home fixtures imply live enrollment/progress | Replace live course cards with repository records; keep unrelated fixture sections visibly labeled and remove fabricated course progress. |

## Review gate

Review the UUID/authorization model, private-file handoff and package choices,
seed behavior, and checkpoint order. Once approved, Phase 3 breaks these
checkpoints into small tasks in [todo.md](todo.md). No implementation begins
from this proposed plan.

## API references checked for this plan

- [Serverpod private storage and signed downloads](https://docs.serverpod.dev/cloud/concepts/storage)
  and [file upload/reference guidance](https://docs.serverpod.dev/concepts/endpoints-and-apis/file-uploads).
- Flutter package documentation for [pdfrx](https://pub.dev/packages/pdfrx),
  [open_filex](https://pub.dev/packages/open_filex),
  [path_provider](https://pub.dev/packages/path_provider), and
  [url_launcher](https://pub.dev/packages/url_launcher). These are proposed
  direct dependencies; native compatibility is verified before UI work.

## Earlier plans

The prior [identity-access implementation plan](identity-access-plan.md) is
retained. Its source implementation exists, with pending live acceptance
documented in [identity-access results](identity-access-results.md).

## Completed onboarding implementation plan

The user approved SPEC-onboarding.md with “implement spec” and explicitly approved shared_preferences for persistent completion. Execute the requested implementation with test-first checkpoints.

1. Add installation-level completion storage using shared_preferences, a fake store and a repository that handles read/write failure without blocking access. Verify persistence, failure and idempotent completion.
2. Add a ten-story catalog and workflow ViewModel. Keep timer boundaries in the ViewModel and frame animation in the View. Test eight-second transitions, independent pause reasons, manual navigation, final-story stop and disposal.
3. Add localized story copy and a light Material 3 screen with local illustrations, segmented progress, accessible controls and responsive text scrolling. Verify gestures, keyboard, lifecycle, localization, semantics and compact/enlarged layouts.
4. Wire splash → onboarding/login/demo using injected completion state. Preserve auth preview scenarios; add a fresh-tour preview override that never writes real preferences. Test fresh/completed/restored/error/relaunch/logout/back-stack flows.
5. Align the shared primary color with DESIGN.md, inspect and update affected light visual baselines, run analysis/format/full suite/coverage/build, and document outcomes. Live MCP and Android/iOS checks remain pending if the required tools are unavailable.

Dependencies: storage and workflow precede routing; local catalog/localization precede illustrations. No backend, migrations, real auth or LMS feature implementation. Existing Serverpod runtime rules remain unchanged.

Risks: timer/gesture double advances (boundary guard), background drift (monotonic elapsed clock), storage errors (in-process completion), inaccessible timed content (manual accessibility mode), small-screen clipping (scrollable text and reduced illustration), preview contamination (separate in-memory store).

Status: implemented and automated verification complete. See [implementation results](implementation-results.md) for evidence and pending live-device checks.

## In-app course links

See [implementation plan](in-app-links-plan.md) and
[verification results](in-app-links-results.md). Implementation and native
builds are complete; native interaction acceptance remains pending.
