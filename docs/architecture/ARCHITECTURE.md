# Poodle architecture

This document defines the intended LMS architecture. For what is implemented in the current source tree, read [STATUS.md](../status/STATUS.md). The delivery stages at the end summarize the difference between the design and the current app.

## Overview

Poodle is an Android/iOS LMS inspired by Moodle, with a private AI notebook for studying course material and preparing for modules and exams. Admins, teachers, and students use the same Flutter app, with screens and actions determined by authorization. The first release supports a closed pilot of up to 30 students.

The first-release target includes courses, modules, materials, assignments, versioned submissions, grades, private one-to-one chats, announcements, calendar, notifications, downloads, and AI study tools. Blogs, groups, tags, multi-account switching, and institutional integrations are later milestones. Ungraded practice quizzes and teacher-created tests now exist; broader graded quiz behavior remains outside this target.

Support English and Ukrainian. Store timestamps in UTC and display them in the device timezone.

## Technology

| Area | Choice |
| --- | --- |
| Mobile app | Flutter, with shared feature logic and one interface for Android/iOS |
| UI components | Shared themed Material 3 feature screens; native iOS bottom navigation as specified in `SPEC-ios-tab-bar.md` |
| State and navigation | `ChangeNotifier`, `provider` dependency injection, `go_router` |
| Backend | Serverpod modular monolith with PostgreSQL and pgvector |
| Local data | Account-scoped SQLite for supported mobile caches, with explicit repository-managed refresh |
| File storage | Serverpod private/public cloud storage with database fallback today; Cloudflare R2 is a deployment target |
| Ingestion | Separate Dart worker with native extraction tools |
| AI | OpenAI generation, embeddings and audio speech today; media transcription and a Gemini YouTube adapter are targets |
| Hosting | Railway is a target; deployment is not established by this repository |

Use provider adapters with server-side model configuration. Do not depend on experimental automatic database synchronization. See [offline behavior](OFFLINE.md) and [testing strategy](../development/TESTING.md).

## Unified UI

Signed-in root screens share a safe-area Poodle header with an account menu. The menu opens a read-only account profile and existing secondary destinations. Android exposes the Search preview from this header; compact iOS keeps Search in its bottom navigation. Nested screens retain contextual toolbars.

Use shared Material 3 feature screens with Poodle's colors, typography scale, spacing, and component styles. Android and iOS share feature layouts, dialogs, form controls, and loading/error states. The approved [iOS tab-bar milestone](../specs/SPEC-ios-tab-bar.md) is a limited exception: compact iPhone layouts use native UIKit Liquid Glass on iOS 26+ and a Cupertino bar on iOS 15–25. Their destinations are Home, My courses, Calendar, Notifications, and Search; Home retains Messages and More access. Android keeps its existing Material navigation, and wide layouts retain the rail. Other platform-specific UI changes require their own scoped decision.

- Keep shared style values in `ui/theme/` using `ThemeData`, `ColorScheme`, and `TextTheme`. The current app forces its light theme; dark mode is future work.
- Use Material components directly for standard controls. Extract reused application components into `ui/components/`; avoid wrapping every widget or building a replacement UI library.
- Keep feature-specific Views and ViewModels in their existing feature folders. Limit platform-specific presentation to the signed-in navigation shell and its small iOS bridge; share the feature screens and state.
- Preserve platform-appropriate keyboard/text-selection, scrolling, route transitions, Android back, and supported iOS back-swipe behavior. Keep Flutter's platform defaults and test navigation behavior instead of forcing an Android platform theme on iOS.
- OS permission prompts, file pickers, and share sheets remain system interfaces. A unified app design does not replace these native interactions.

Shared feature screens reduce duplicated component work. Both platforms require accessibility, navigation, keyboard, and real-device checks, including native iOS tab-bar acceptance; see [TESTING.md](../development/TESTING.md).

## Architecture and folders

Flutter follows MVVM: `View -> ViewModel -> Repository -> Service`. Data/state flows back to the ViewModel and View for rendering.

- **Views** render state and forward user actions. Keep layout, focus, scrolling, and animation concerns here.
- **ViewModels** expose immutable UI state and async commands. Pair each screen/workflow with its ViewModel.
- **Repositories** own application data, caching, refresh, retry, and error handling. Use abstract interfaces so tests can substitute fakes; multiple ViewModels can share a repository.
- **Services** wrap Serverpod clients, SQLite, files, and platform APIs. They do not own feature UI state.
- **Application models** are immutable data types. Map generated API models to application models where needed; avoid duplicating every generated type automatically.

Scope ViewModels to their screen/workflow and repositories to the authenticated session. Add domain use cases only for complex, repeated, or multi-repository workflows. Repositories do not depend on other repositories; coordinate them in ViewModels or use cases.

The backend uses `endpoint -> application service -> repository -> PostgreSQL/R2`. It enforces authorization, deadlines, grades, completion, and processing limits. The worker runs outside the request-handling process.

Current workspace structure (selected handwritten paths):

```text
poodle/
├── README.md
├── docs/                     # Architecture, development guides, specs and status
├── poodle_flutter/
│   ├── lib/
│   │   ├── app/                 # Routing, shell, localization
│   │   ├── data/                # Repositories, caches, services
│   │   ├── domain/models/
│   │   ├── features/            # Auth, courses, teaching, notebook and others
│   │   └── ui/                  # Shared components and light theme
│   └── test/                    # Unit and widget tests
├── poodle_server/
│   ├── lib/src/auth/
│   ├── lib/src/core/
│   ├── lib/src/modules/        # Handwritten endpoints, services, models
│   └── test/                   # Unit and integration tests
├── poodle_client/              # Generated Serverpod client
└── poodle_worker/
    ├── bin/
    ├── lib/src/jobs/
    ├── lib/src/extractors/
    └── test/                    # Unit and integration tests
```

Flutter feature screens and ViewModels live under `presentation/views` and `presentation/view_models` within their feature. Feature-specific widgets can live under `presentation/widgets`. Shared repositories stay in `data/repositories/`. The target dependency direction remains View → ViewModel → Repository → Service.

Serverpod maintains the generated client from backend endpoints/models. The running `serverpod start` watcher generates changes; follow [AGENTS.md](../../AGENTS.md) for the MCP migration/runtime workflow and do not hand-edit generated code. Flutter imports `poodle_client`, not `poodle_server`. Cross-package `tests/ai_evaluation` and `tests/load` are proposed, not present.

## Accounts, roles, and course access

Universities share a Serverpod backend. An institutional account belongs to one university; course membership grants its teacher or student role per course. Platform operators review verified requests from university representatives. The first operator receives an email-bound invitation for the mailbox configured in `initialPlatformOperatorEmail`. The server can replace an expired or revoked bootstrap invitation while no platform operator exists. Development seed accounts are restricted to local use.

| Role | Scope | Permissions |
| --- | --- | --- |
| Platform operator | Platform | Review requests, create or select a university, and invite its administrator |
| University administrator | One university | Invite teachers and co-administrators, manage university invitations, and change administrator roles while retaining an active administrator |
| Teacher | University eligibility and active course membership | Create draft courses when approved; manage and publish courses they teach; invite students to those courses |
| Student | Active course membership | Read published course content, submit assignments, and access their own grades and study data |

Registration uses Serverpod's email verification and consumes a seven-day, single-use invitation inside the account creation transaction. Issuing, accepting, and revoking university invitations share a server-side grant policy. Authority checks run inside the write transaction and serialize with administrator removal. Course reads and peer discovery check membership, university ownership, and publication as applicable. Platform authority does not grant access to private messages, notebooks, or student uploads.

Flutter's live entry point uses the Serverpod-backed repositories. University routes live with the university feature; Views and ViewModels are under its presentation folders. The preview entry point continues to use fake authentication. See the [university access results](../archive/tasks/university-access-results.md) for verified behavior and rollout gaps.

## Screens and student features

The following primary tabs apply to Android and the wide navigation rail. Compact iOS navigation uses the five destinations and secondary Home access specified above. The live Calendar, Search, Messages and Notifications routes use real repositories; `main_preview.dart` retains simulated destinations.

| Primary tab | Content |
| --- | --- |
| Home | Dashboard, upcoming tasks, recent courses, announcements, calendar shortcuts |
| Courses | Enrolled courses, search, filters, sorting, favorites, progress |
| Messages | Private conversations and unread counts |
| Notifications | Persistent notification inbox |
| More | Calendar, tasks, downloads, grades, files, profile, settings, help |

Student course screens expose Materials, Assignments, Notebook, and My grades. Teacher screens expose Materials, Assignments, Gradebook, and Students. Use accessible controls, scalable text, semantic labels, safe areas, ARB localization, and explicit loading/empty/error/processing/offline states.

- **Course browsing:** cards show thumbnail/placeholder, title, category, progress, and last access. Provide title search; All/In progress/Upcoming/Past/Favorites/Hidden filters; list/card layouts; name/last-access sorting. Hiding is a personal preference and does not change enrollment or reminders.
- **Course contents:** ordered collapsible sections, a section index, expandable descriptions, typed material rows, previous/next activity navigation, teacher profiles, course dates, and unavailable-state explanations. Students cannot see drafts.
- **Progress:** manually completed required materials plus accepted required assignment submissions. Calculate `floor(100 * completed required activities / published required activities)` on the server; exclude optional items and drafts. Show `No required activities` for an empty denominator. Recalculate when teachers change requirements. Grades and AI artifacts do not affect progress.
- **Calendar and tasks:** month/agenda views, date markers, selected-day events, month navigation, Today, course/type filters, and upcoming/overdue tasks. Include assignment opening/deadline events and teacher-created lectures, module preparation, and exams. Changes update existing linked events. Monday starts the week by default; Sunday is selectable.
- **Grades and announcements:** show points, maximum points, feedback, and pending/graded states; pending is not zero. Announcements show title, body, author, publication time, and unread state. Discussions are deferred.
- **Files and account:** show owned uploads with course/notebook context, profile, verified email, password change, enrollment summary, logout, support, app version, licenses, and privacy information.
- **Settings:** language, light/dark/system theme, text size, document/image zoom, notification preferences, course layout/sort, calendar defaults, Wi-Fi-only downloads, storage controls, and help. Follow device language/appearance initially; unsupported languages fall back to English.
- **Downloads:** explicit download/refresh/removal controls with size, progress, errors, and storage use. Store authorized materials, website snapshots, and transcripts. Details belong in [OFFLINE.md](OFFLINE.md).

## Assignments and grades

Teachers publish instructions, maximum points, opening/deadline timestamps, and required-completion status. Students may replace submissions until the deadline; retain every version. Grading records numeric points and feedback and locks further submissions. Reopening requires a new deadline. Server time and server rules determine eligibility.

## Private chats

Private messaging is separate from AI notebook chat. Each conversation has exactly two participants; group chats and course-wide rooms are outside the first release.

- Active users sharing an active course may start/send messages, including teacher-student, student-student, and teacher-teacher pairs. Reuse one conversation per unordered user pair across courses.
- Only participants may list, read, or subscribe. Teacher status grants no access to other private conversations. Existing history remains readable when the shared-course relationship ends, but sending requires it to resume.
- Plain text messages support up to 4,000 Unicode characters, paginated history, favorites, unread counts, and live updates. The inbox shows the participant, preview, time, and unread count; eligible member profiles expose Message.
- PostgreSQL stores messages and per-participant read cursors. Persist before publishing through authenticated Serverpod streams. Reconnect and retry rules are defined in [OFFLINE.md](OFFLINE.md).
- Attachments, editing/deletion, typing indicators, and public read receipts are deferred. Private messages never enter notebooks, embeddings, or AI prompts.

## Notifications

Provide a persistent inbox and FCM/APNs push for announcements, new assignments, deadline changes/reminders, published grades/feedback, and private messages. Support All/Unread/category filters, mark-read/mark-all-read, and authorized navigation to the target.

Create the inbox record and durable delivery-outbox entry with the triggering operation. Recheck authorization when opening a target. Request OS notification permission with an explanation; the inbox still works if permission is denied. Register devices per account, refresh tokens, and remove registrations on logout or invalid delivery responses. Push payloads contain opaque target IDs and generic text, not message bodies or grades.

Default reminders are 24 hours before a deadline, with one-hour or disabled alternatives. Before delivery, recheck membership, preferences, deadline, and submission status. Retry delivery without duplicating notifications or rolling back the underlying action.

## Notebook and AI study

Students have private course-scoped notebooks selecting modules or source subsets. Use published course materials plus owned uploads. Teachers and classmates cannot access private uploads or notebook chat history.

Offer cited answers, source-wide summaries, flashcards, and ungraded practice quizzes. Filter retrieval by membership, ownership, selected sources, and ready source versions; combine vector and keyword search. Validate citation IDs and explain insufficient evidence. Summaries process source sections before combining them. AI artifacts do not change formal grades or progress.

Start with roughly 512-token chunks and modest overlap. Preserve page/block or transcript locations for citations. Provider credentials and model configuration remain server-side.

## Dart ingestion and website parsing

Accept PDF, TXT, Markdown, DOCX, PPTX, JPEG/PNG, supported audio/video, public HTML/PDF URLs, and public YouTube links.

`Upload or URL -> validation -> extraction -> versioned snapshot -> chunks and embeddings -> ready`

The Dart worker processes durable PostgreSQL jobs separately from the API. Use one extraction job at a time initially, visible processing states, bounded retries, restart recovery, and idempotent completion. Dart coordinates native tools: Poppler for PDFs, LibreOffice for office conversion, Tesseract for English/Ukrainian OCR, and FFmpeg for media preparation. The current DOCX text-only adapter reads bounded OOXML body paragraphs/table text in an isolated Python process, without Office execution or external relationship resolution; LibreOffice conversion remains for future office formats/layout work. Launch tools with argument lists without a shell; bound execution time, memory, and decompression. Production binary ingestion runs on Linux with container limits; local macOS lacks the helper's Linux address-space limit. Transcribe media through provider adapters; video study uses transcripts rather than visual frames.

| Input | Processing limit |
| --- | --- |
| Documents | 25 MiB; 200 pages/slides |
| Images | 10 MiB; 25 megapixels |
| Audio/video | 250 MiB; 90 minutes |
| Web HTML | 10 MiB after decompression |

Validate ownership, extension, detected MIME type, signature, readability, and limits. Scan uploads; reject encrypted, active/macro-enabled, malformed, or unsafe inputs.

For websites, use a controlled Dart HTTP fetcher and a Dart `trafilatura` extraction adapter. PDF responses follow the document pipeline. Normalize headings, paragraphs, lists, and tables; preserve original/final URL, title/author where available, retrieval time, hash, stable block IDs, and source version. Cite the stored snapshot. Explicit refresh creates a new version when content changes.

Allow public HTTPS on port 443 without URL credentials or cookies. Validate IPv4/IPv6 destinations and the actual connection destination; block private, loopback, and link-local addresses and preserve TLS hostname verification. Disable automatic redirects; revalidate at most three redirects. Apply five-second connection and 30-second total timeouts. Do not fetch nested assets. Authenticated/paywall/CAPTCHA pages, JavaScript-only pages, and crawling are unsupported. Render normalized content with Flutter widgets without executing imported HTML or JavaScript.

## Railway deployment and security

Deploy one Serverpod API service, one Dart worker Docker service, and PostgreSQL using a pgvector-enabled image/template with persistent storage. Railway's standard PostgreSQL image does not include pgvector. Store uploaded files in private R2 rather than container-local storage. Android/iOS apps run on users' devices.

Keep API and worker services continuously running; use Serverpod's monolith role for scheduled calls and maintenance. Expose HTTPS and authenticated streams; keep database, worker, and administrative services private. Use server-side secrets, health checks, encrypted backups with seven daily/four weekly copies, and restore verification.

Use verified invitations and enforce platform, university, course, and resource ownership boundaries on the server. Authorize short-lived R2 URLs. Never log private source content, notebook chats, or message bodies. Treat imported content as untrusted data rather than instructions.

## Offline and testing

Offline use is read-only for downloaded/cached content, with device-local visual preferences available. See [OFFLINE.md](OFFLINE.md) for synchronization, local removal, recovery, and account isolation.

See [TESTING.md](../development/TESTING.md) for test locations, coverage, integration checks, AI evaluation, and acceptance scenarios.

## Delivery order

The original five-stage order remains a useful roadmap. [STATUS.md](../status/STATUS.md) records the current state of each stage: stages 1 and 2 have substantial implementation; stage 3 lacks completion/progress and real-time messaging; stage 4 lacks dedicated calendar/announcement services and push delivery; stage 5 has private sources and Studio but still lacks website/media import and several release checks.

## References

- [Flutter MVVM guide](https://docs.flutter.dev/app-architecture/guide) and [folder structure case study](https://docs.flutter.dev/app-architecture/case-study)
- [Flutter Material 3 components](https://docs.flutter.dev/ui/widgets/material) and [platform interaction adaptations](https://docs.flutter.dev/ui/adaptive-responsive/platform-adaptations)
- [Serverpod project packages](https://docs.serverpod.dev/concepts/server-fundamentals/your-serverpod-project) and [code generation](https://docs.serverpod.dev/concepts/cli/commands/generate)
- [Serverpod hosting](https://docs.serverpod.dev/deployments/custom-hosting/hosting-elsewhere) and [Railway pgvector deployment](https://docs.railway.com/guides/embeddings-pipeline)
- [Dart process API](https://api.dart.dev/dart-io/Process/start.html) and [Dart Trafilatura adapter](https://pub.dev/packages/trafilatura)
- [FCM for Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/get-started)
- [SSRF prevention](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html)
