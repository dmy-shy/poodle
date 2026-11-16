# Spec: Course views by UUID with seeded content

> **Historical course-view milestone.** The protected course APIs and live screens now exist, with later teaching and notebook work built on them. Earlier migration/runtime blockers below are dated checkpoint claims. See [STATUS.md](../status/STATUS.md) for the current source inventory.

> UI refresh: the requirements below for visible sample and feature preview labels are superseded. Simulated actions and unavailable features still describe their actual outcome.

Status: approved by the user on 2026-10-22 after confirming the seed-access
and file-handler decisions. This is a user-facing course-view slice across
the already approved `course-membership` → `course-content` boundaries in
[CAPABILITY-MAP-backend.md](../architecture/CAPABILITY-MAP-backend.md). It does not replace those
modules' provider contracts.

## Objective

Let a signed-in student or teacher open an authorized course by UUID and
read its ordered subjects/sections and activities. A small set of development
and test courses supplies realistic content while the course authoring and
enrollment workflows are built. The explicit `main_preview.dart` app uses
matching deterministic fixtures. This replaces the course-detail placeholder
without claiming that other dashboard tasks, grades, or announcements are live.

The five attached Moodle screenshots are **examples of information hierarchy and
content types**, not instructions to copy Moodle styling, private links, grades,
names, dates, or data. Poodle keeps its shared Material 3 design and bilingual
English/Ukrainian controls. The user supplies sample PDF and DOCX files;
the implementation must not generate replacement documents.

### Approved scope assumptions

1. Course record IDs and course route parameters are UUIDs, never sequential
   numbers or title-based slugs. The two seed courses use fixed, distinct UUIDs
   shared with their preview fixtures. Existing `course-design` and
   `course-writing` values are legacy fixture labels to replace, not accepted
   course route IDs. Unknown valid UUIDs get a safe unavailable view.
2. Seed courses and their content live in Serverpod's **development/test**
   database only. Seeding is idempotent and cannot run in staging/production.
   The preview entry point has matching local fixtures, clearly labeled
   `Feature preview`. It never bypasses live endpoint authorization.
3. Live course reads require an active per-course student or teacher membership.
   The existing development admin receives a teacher membership for seeded
   courses so they can be viewed locally. Other accounts need an explicit
   membership; global admin authority alone does not grant content access.
4. Module and lab test variants expose read-only instructions, availability,
   attempt-limit/time-limit metadata when present, and an explanation that
   attempts and grading are not available in this milestone. Existing attempts,
   scores, and progress are never fabricated.
5. The course view is initially online-first. Preview fixtures work without a
   server. Account-scoped SQLite caching, explicit downloads, and offline file
   reading remain governed by [OFFLINE.md](../architecture/OFFLINE.md) and are not added here.

## Existing implementation and dependencies

- Home currently has the two legacy sample labels above in
  `poodle_flutter/lib/data/repositories/dashboard_repository.dart`; title/category
  text is selected by ID in `features/dashboard/presentation/dashboard_copy.dart`.
  Its `/home/course/:id` route renders `PreviewDestination`.
- `/courses` is a placeholder. There are no course/section/material Serverpod
  models, memberships, or course repositories yet. `main.dart` uses real auth;
  `main_preview.dart` is the separate simulated-auth entry point.
- The approved backend map assigns course records, membership and member-only
  read routes to `course-membership`, then ordered sections and content to
  `course-content`. That provider boundary must be implemented before the live
  view can read seeded content. The identity migration/runtime acceptance
  recorded in [tasks/identity-access-results.md](../archive/tasks/identity-access-results.md)
  is also a prerequisite for live acceptance.

## User-visible scope

### Finding and opening a course

- The Courses destination lists courses visible to the current account, with
  title, optional category/thumbnail, and a clear empty state. This milestone
  does not add search, filters, favorites, hidden courses, or enrollment editing.
- Tapping a Home recent-course card or a Courses row opens a course route with
  the course UUID as its path parameter. Both entry points resolve the same
  repository course data. The existing Home course route (renamed to
  `/home/course/:courseId`) and a course route under `/courses` remain behind
  the signed-in router guard. Malformed,
  numeric and slug path parameters are rejected before loading course data.
  Direct entry rechecks authentication and membership through Serverpod, shows
  loading/retry or a safe unavailable state, and preserves a way back. An
  unknown UUID and a course the account cannot access have the same public
  unavailable presentation. Sign-out or account change clears course state and
  prevents an old response from reappearing.
- The live Home may keep unrelated fixture sections, but any course card that
  opens a live detail must represent an authorized server course. Do not turn a
  fixture card into apparent live enrollment or progress. Until server progress
  exists, show `No progress yet` rather than a made-up percentage.

### Course and section view

- Header: full course title, optional category/summary/image, and teacher or
  course information when present. Long names wrap; absent metadata is omitted.
- Body: server-ordered collapsible sections (also called subjects/topics in
  this request), each with an optional description and server-ordered activity
  rows. Provide a section index/jump control when there are multiple sections.
  Empty course and empty section states are explicit.
- Each row identifies its type with an icon **and text**, title, optional brief
  description, and availability/completion text only when it comes from real
  data. The course content view must not show a grade tab or progress bar based
  on fabricated values. Student reads exclude drafts; assigned teachers may
  inspect drafts with a visible Draft marker.
- Opening an activity shows a read-only detail screen. Previous/next activity
  moves through the same authorized, published sequence for students and the
  permitted sequence for teachers. A missing/unpublished/revoked item produces
  an unavailable view and cannot reveal its contents through direct ID access.

### Activity types for this milestone

| Type | Course row and detail | Action |
| --- | --- | --- |
| File (PDF or DOCX) | File name, type, optional size/description, and an authorized sample file | Open PDFs in a readable in-app viewer. Open DOCX files through a supported platform document handler after an authorized fetch; show a clear message if the device has no handler. Reauthorize every file request. Other file types may show metadata and an unsupported-viewer message. |
| External link | Title, description and destination host | Open an authorized HTTPS destination inside Poodle after a user action, following [SPEC-in-app-links.md](SPEC-in-app-links.md). Do not fetch/import the target into the server in this milestone. |
| Announcement | Title, body, author and publication time when present | Read the announcement inside the course. Unread tracking, notifications and discussions remain later work. |
| Module or lab test | Instructions, opening/closing time, current availability, optional attempt/time limits | Read details only. No start, submit, retry, score, grading or prior-attempt UI. |

Availability for a module/lab is calculated from server time and stored UTC
timestamps (`upcoming`, `available`, `closed`, or `unscheduled`); the device shows
dates in its local timezone. A missing timestamp is never invented. An activity
whose server-side access has been revoked cannot be opened from a stale list.

The seed includes at least one course with an information/announcement section
and another with materials and lab/module sections. Across the two seed UUIDs,
it includes a PDF, a DOCX, an HTTPS link, an announcement, and both module and
lab test variants. Seed URLs and documents must be safe, nonpersonal
demonstration resources; no copied contact details or private Moodle links from
the images.

## Data and authorization contract

- Serverpod owns course, membership, section and typed activity records. Use
  generated protocol models and endpoints; Flutter never imports server code
  or reads PostgreSQL directly. The course primary key is a UUID. Route values
  use canonical lowercase, hyphenated UUID text and are parsed/validated at
  the boundary. Section and activity identifiers exposed in routes are UUIDs
  as well; database ordering is a separate explicit field.
- Member-only list/detail and activity-detail endpoints call the existing
  authenticated account check and then a reusable active-membership check on
  every request. Flutter route protection is a user experience guard, not the
  authorization boundary. A teacher in course A cannot see course B. Student
  responses omit unpublished sections/items. Recheck access before issuing a
  short-lived file URL or serving file bytes. Avoid distinct responses that
  disclose draft titles or private file addresses to unauthorized users.
- Store section/activity ordering explicitly. Public response models carry a
  typed activity discriminator, stable ID, display metadata, availability and
  only the fields valid for that type. Do not overload a URL field with quiz or
  announcement text. Course content is authored text; localize interface
  controls, status labels, dates and errors, but do not silently translate
  arbitrary teacher content. Seed fixtures provide representative English and
  Ukrainian authored text.
- The sample PDF and DOCX are private objects accessed through an authorized
  Serverpod storage boundary. DOCX handoff may require a temporary local copy;
  it must not become a persistent offline download and must be cleared when
  the account session ends. Tests can supply a fake object store. Storage
  implementation and viewer/handler dependency choices belong in the later
  technical plan; the contract is that a valid member can open either file
  and a nonmember cannot.
- Development/test seeding uses fixed UUIDs and upserts only the named sample
  records; repeated starts do not duplicate courses, sections, memberships, or
  activity rows, overwrite unrelated teacher content, or grant access to new
  users. Test setup remains isolated. Preview fixtures mirror the sample shape
  but never call production endpoints.

## Tech stack and project structure

Use existing Dart `^3.12.2`, Flutter `^3.44.4`, Serverpod `4.0.4`, PostgreSQL,
`provider`, `ChangeNotifier`, `go_router`, ARB localization, and the current
light-only Material 3 theme. Follow `View → ViewModel → Repository → Service` in
Flutter and `endpoint → service → repository → PostgreSQL/storage` on the server.

| Location | Responsibility |
| --- | --- |
| `poodle_server/lib/src/modules/courses/` | Course and membership endpoint, service, repository and `.spy.yaml` models. |
| `poodle_server/lib/src/modules/course_content/` | Ordered section/activity read contracts, seed data and authorization through the course membership boundary. |
| `poodle_server/test/unit/`, `test/integration/` | Access rules, seed idempotence, ordering and real endpoint/persistence checks. |
| `poodle_flutter/lib/features/courses/presentation/` | Course list/detail/activity Views, ViewModels and feature widgets. |
| `poodle_flutter/lib/data/repositories/`, `lib/data/services/` | Course repository interface, live Serverpod adapter and preview fixture adapter. |
| `poodle_flutter/lib/domain/models/` | Immutable course projections where they simplify UI state. |
| `poodle_flutter/lib/app/`, `lib/app/l10n/` | Route composition, session disposal and English/Ukrainian ARB strings. |
| `poodle_flutter/test/unit/`, `test/widget/` | Repository/ViewModel and screen/navigation/accessibility tests. |

The concrete filenames and any narrowly needed PDF/DOCX/URL opening dependencies
are chosen in the technical plan. Do not edit `poodle_server/lib/src/generated/`,
`poodle_client/`, or generated localization output manually.

## Code style

Follow formatted Dart: `lower_snake_case.dart`, UpperCamelCase types,
lowerCamelCase members, immutable UI state and unmodifiable collections.
For example, the ViewModel receives an ID and a repository, then exposes a
state; the View does not read Serverpod directly:

```dart
class CourseDetailState {
  const CourseDetailState({
    required this.courseId,
    this.course,
    this.loading = false,
    this.error,
  });

  /// Canonical UUID validated at the route boundary.
  final String courseId;
  final CourseDetail? course;
  final bool loading;
  final CourseLoadError? error;
}
```

Repository/service code maps generated DTOs to UI models and handles retry,
refresh and session invalidation. Views render state and forward actions.

## Commands and runtime workflow

From `poodle_server/`, use the following CLI checks (RTK is required by this
repository's instructions):

```sh
rtk proxy /Users/mac/Documents/flutter/bin/dart analyze lib test
rtk proxy /Users/mac/Documents/flutter/bin/dart format lib test
rtk proxy /Users/mac/Documents/flutter/bin/dart test
```

From `poodle_flutter/`:

```sh
rtk proxy /Users/mac/Documents/flutter/bin/flutter gen-l10n
rtk proxy /Users/mac/Documents/flutter/bin/dart analyze lib test
rtk proxy /Users/mac/Documents/flutter/bin/dart format lib test
rtk proxy /Users/mac/Documents/flutter/bin/flutter test --no-pub --concurrency=1
```

After model edits, use **Serverpod MCP** `create_migration` and
`apply_migrations` after analysis/formatting. Use its `hot_restart` for routing,
composition or generated-contract changes, then `tail_server_logs` and
`tail_flutter_logs`. The user's `serverpod start` process owns both runtimes;
the agent never starts it. If MCP reports it stopped, ask the user to start it
and stop runtime work. Direct CLI generation/migration is only the documented
fallback when the server cannot start at all. Requested app interaction testing
uses Serverpod MCP `get_flutter_app_dtd`, Dart MCP
`connect_dart_tooling_daemon`, then `flutter_driver`.

## Testing strategy

- Server unit/integration: different active memberships and teacher/student
  roles, revoked membership, cross-course and direct-ID access, draft hiding,
  file authorization, duplicate seed runs, content ordering, malformed/numeric/
  slug IDs, unknown UUIDs, and UTC availability boundaries. Use the embedded
  test database configured by the project; `dart test` requires no Docker.
- Flutter unit/widget: list/detail/activity loading, empty/error/retry,
  refreshing and session changes; row type/metadata; section expansion/index;
  previous/next navigation; unavailable states; external-link confirmation;
  unsupported file types and missing DOCX handlers; English/Ukrainian labels,
  large text and semantics.
- Integration/device acceptance: development admin membership sees seeded
  courses through live Serverpod; a nonmember cannot open either course or the
  PDF or DOCX by direct ID; Android back and iOS swipe return to the source tab;
  PDF, DOCX and external link open through their intended handlers. Record
  unavailable runtime/device checks as pending rather than claiming they passed.
- Follow [TESTING.md](../development/TESTING.md): at least 80% coverage for handwritten Dart
  logic and 90% for authorization/cache-isolation logic. Avoid tests that only
  repeat sample fixture constants.

## Boundaries

- **Always:** enforce membership server-side; keep seed and preview data
  visibly distinct from real user progress/grades; store times in UTC and
  display local times; support English/Ukrainian controls and accessible Material
  3 layouts; clear account-scoped data on sign-out; use Serverpod for backend.
- **Ask first:** changing the approved role model, enabling seed data in
  staging/production, adding a new external service, changing storage topology,
  or making a destructive migration that cannot preserve data. A proposed
  dependency is documented in the plan for review before implementation.
- **Never:** expose drafts, file targets or course data across memberships;
  copy private Moodle links or personal data from screenshots; invent grades,
  completion, quiz attempts or enrollment; edit generated code; start the
  server from the agent.

## Success criteria

1. The two fixed UUIDs resolve to distinct, seeded, ordered courses in
   development/test, and matching preview fixtures can be opened by UUID.
   Re-running the seed creates no duplicates or unintended memberships.
2. The live Courses list and Home course entry open the same authorized detail;
   malformed, numeric, slug, unknown, unauthorized and revoked route IDs reveal
   no protected content. Server endpoints enforce access even if a client
   bypasses Flutter routing.
3. Student and teacher views obey publication rules. Sections and activity rows
   retain server order; all four content types and both module/lab variants
   have the specified readable details and honest unavailable states.
4. Authorized sample PDF and DOCX files open through their specified viewers;
   their underlying content is denied to a nonmember. HTTPS links open only
   after a user action. Quiz attempts, scores, fabricated progress and unread
   states are absent.
5. Sign-out/account changes remove prior course data from the UI. English and
   Ukrainian controls, local date display, large text, semantics and navigation
   work on both mobile platforms.
6. The AGENTS.md verification order and relevant unit/widget/integration checks
   pass, or specific live/device checks are recorded as pending with cause.

## Approved decisions and planning details

1. Development admin teacher membership is the local access path for the seed.
   Other users remain subject to normal enrollment.
2. The PDF viewer, DOCX handler integration and private sample-object transport
   are selected in the technical plan and must satisfy the authorization
   behavior above.

The approved spec proceeds to a separately reviewed technical plan before
implementation tasks or code changes.
