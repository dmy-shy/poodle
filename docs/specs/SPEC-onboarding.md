# Spec: Poodle onboarding stories

> **Historical design, not the current story catalog.** This approved spec called for ten stories. `poodle_flutter/lib/features/onboarding/onboarding_story.dart` currently enables five (`courses`, `materials`, `notebook`, `sources`, `planning`); the other five are commented out. For implemented behavior and release gaps, see [STATUS.md](../status/STATUS.md). The original ten-story requirements below are retained as design history.

> UI refresh: the requirements below for visible sample and feature preview labels are superseded. Simulated actions and unavailable features still describe their actual outcome.

Status: Approved by the user on 2026-10-15 with “implement spec”. The current five-story tour is implemented; the original ten-story acceptance record below is historical. Android/iOS accessibility and device checks remain open.

## Objective

Introduce Poodle's learning and teaching benefits through an Instagram-like story slider. A new user should understand where to find learning materials, plan work, study with private AI tools, communicate, and read downloaded content before signing in.

This is one onboarding capability. The underlying course, assignment, messaging, AI, and download systems are subjects of the tour, not modules to implement in this scope.

Sources: [architecture](../architecture/ARCHITECTURE.md), [design](../architecture/DESIGN.md), [testing strategy](../development/TESTING.md), [offline rules](../architecture/OFFLINE.md), and the current light-only app constraint in [AGENTS.md](../../AGENTS.md).

### Confirmed decisions and assumptions

- Confirmed by the user: show once on first launch after splash and before login; persist completion on the device.
- Confirmed by the user: automatic advancement with pause, tap/swipe navigation, and manual advancement for reduced motion or screen readers.
- Proposed detail: eight seconds per story; the final story waits for an explicit Get started action.
- The tour is shared by students and teachers because roles are unknown before login. Do not require role selection.
- Keep the current simulated authentication milestone. Introduced product capabilities are planned, not functional demos. Show a persistent, localized Feature preview label in this milestone.
- Light theme only, including when the system is dark. Device language selects Ukrainian or English; unsupported primary languages use English.

## Experience and story content

Ten stories group all first-release user-facing capability areas. Each has one headline, a short supporting sentence, and an illustrative composition. The coverage column guides illustration details and content review; it is not a checklist to print on screen. The architecture remains authoritative for future feature behavior.

| ID | English headline and body | Ukrainian headline and body | Illustration and architectural coverage |
| --- | --- | --- | --- |
| courses | **Your learning, in one place.** Find your courses, pick up where you left off, and see your progress. | **Усе навчання — в одному місці.** Знаходьте курси, продовжуйте навчання й стежте за прогресом. | Dashboard with recent courses/upcoming tasks; course cards, title search, filters, favorites, personal hiding, sorting and list/card layouts. Progress is activity completion, not grades. |
| materials | **Find what you need to learn.** Move through modules, read materials, and return to any activity. | **Усе потрібне для навчання.** Переходьте між модулями, читайте матеріали й повертайтеся до занять. | Module outline and PDF/document preview; sections, index, typed materials, previous/next navigation, course dates, teacher profiles and unavailable-state explanations. |
| notebook | **Study with answers you can check.** Ask about your sources, explore cited answers, and practise with summaries, flashcards, and quizzes. | **Навчайтеся з відповідями, які можна перевірити.** Запитуйте про джерела, перевіряйте посилання й повторюйте матеріал із підсумками, картками та тестами. | Private course notebook, selected modules/sources, cited answer with page marker, summary, flashcard and ungraded practice quiz. Private uploads and notebook chats are not shared with teachers/classmates. No promise of infallible answers or formal grades from AI. |
| sources | **Bring your study sources together.** Add documents, images, public links, or recordings to your private notebook. | **Збирайте джерела для навчання.** Додавайте документи, зображення, публічні посилання чи записи до приватного нотатника. | File/link chips: PDF, TXT, Markdown, DOCX, PPTX, JPEG/PNG, audio/video, public websites/PDFs and public YouTube. Extraction/processing status and source selection; media study uses transcripts. No arbitrary-site, private-page, visual-video-analysis or instant-processing claims. |
| planning | **Know what comes next.** Keep assignments, lectures, preparation, and exams in view with your calendar and tasks. | **Знайте, що далі.** Плануйте завдання, лекції, підготовку й іспити в календарі та списку справ. | Calendar month/agenda, selected-day events, Today, course/type filters, upcoming/overdue tasks and assignment deadlines. Dates shown in device timezone. |
| assignments | **Submit, improve, track your results.** Send work before the deadline, review submission versions, and read grades and feedback. | **Здавайте роботи й стежте за результатами.** Надсилайте роботи до дедлайну, переглядайте версії, оцінки й відгуки. | Assignment card, version history and grade/feedback card. Replacement only while eligible; grading locks submissions. Pending grade is not zero. No unconditional resubmission promise. |
| connected | **Stay connected to your course.** Read announcements, message classmates or teachers privately, and keep track of updates. | **Будьте на зв’язку з курсом.** Читайте оголошення, спілкуйтеся приватно й стежте за оновленнями. | Announcement, two-person text conversation, unread/favorite indicators and notification inbox/reminder. Course-eligible participants only. Inbox works without push permission; messages never feed AI. No group chats, message attachments or public read receipts. |
| teaching | **A shared space for teaching.** Invite students, publish materials and assignments, and follow their work in the gradebook. | **Спільний простір для викладання.** Запрошуйте студентів, публікуйте матеріали й завдання та переглядайте роботи в журналі оцінок. | Approved teacher, invitation, publication state, students list and gradebook. Teacher access does not expose private notebooks or other people's private conversations. No public account registration. |
| offline | **Keep reading when you're offline.** Download materials and revisit saved study content wherever you are. | **Читайте навіть без інтернету.** Завантажуйте матеріали й повертайтеся до збереженого навчального вмісту будь-де. | Explicit download/refresh/removal, size/progress/storage indicator; saved summaries/cards/quizzes/answers, website snapshots and transcripts. Cached calendar/tasks and fetched chats can be read. Offline is read-only; sending, submitting, grading, AI generation and new imports require connectivity. No YouTube video download promise. |
| personal | **Make Poodle work for you.** Manage your profile, files, reading preferences, notifications, and storage, with help close by. | **Налаштуйте Poodle для себе.** Керуйте профілем, файлами, читанням, сповіщеннями й сховищем та знаходьте допомогу. | Owned uploads with course/notebook context; verified email/password/account controls, enrollment overview; text/zoom, course/calendar preferences, Wi-Fi-only downloads, support, privacy/version/licenses. The milestone follows system language and remains light-only; no theme/language switcher is introduced. Final Get started action leads to login. |

Preview visuals use fictional, localized sample content. Do not expose real users, files, grades, chats, provider names, or implementation terminology. Keep the Feature preview label distinct from story copy so a future release can remove it without rewriting every story.

## Design requirements

Reference: [Crevio onboarding concept linked by DESIGN.md](https://dribbble.com/shots/27186107-AI-Family-Organizer-App-Onboarding-Experience). Inspected reference elements: segmented bars at the top, illustration/card collage in the upper area, short centered headline/body below, generous white space and a rounded bottom Next/Get started button. Instagram-like tap, swipe and timing behavior is a Poodle requirement, not a behavior verified from this static reference.

- Adapt the composition to Poodle, rather than copying family portraits, reference artwork, or its brown button palette.
- Use DESIGN.md colors: primary `#C9674A`, secondary `#5E2F12`, black and white, with pale derived illustration surfaces. Resolve the existing theme seed `#C5684F` versus the documented primary through shared theme tokens during implementation; retain login/splash coherence.
- Reuse bundled Montserrat Alternates for display text, the existing body type scale, shared spacing and Material 3 controls. No dark variant.
- Header: segmented progress track, visible Back where applicable, pause/resume and Skip controls. Also expose localized Story X of 10; progress bars need not be ten tiny interactive buttons.
- Body: one feature illustration, headline and brief supporting copy. Create local compositions from Material icons, existing mascot and illustrative Flutter cards. No new stock-photo, animation-service or network-asset dependency is required.
- Footer: Next / Далі on stories 1–9; Get started / Почати on story 10. Minimum 48 logical-pixel interactive targets; primary button follows existing 56-pixel minimum height.
- Safe areas, portrait, landscape and tablets; constrain reading width without scaling text down. At 320×568 and 2× text size, reduce decorative illustration area and allow text scrolling while keeping controls reachable.
- Normal text contrast at least 4.5:1; meaningful visual controls at least 3:1. Decorative illustrations are excluded from semantics; a static text equivalent describes any essential information.

## Story interaction contract

1. Start at story 1 on an eligible fresh launch. Previous segments are filled, current segment displays elapsed progress, later segments are empty.
2. Advance automatically after eight seconds on stories 1–9. Story 10 fills its segment, then remains visible until Get started or Skip. Never loop or exit automatically.
3. Right tap on the illustration area / left swipe / Next advances one story. Left tap / right swipe / Back returns one story. At the first story, previous navigation is a no-op. At the final story, forward taps/swipes are no-ops; only Get started or Skip exits.
4. Each manual story change starts the destination at zero elapsed time. Completed segments reflect the current position, not permanent viewing history. One gesture must cause at most one transition, even when it coincides with a timer tick.
5. Press-and-hold on the illustration temporarily pauses. Release/cancel resumes only if no other pause reason is active. Persistent pause/resume is also available as a labeled button.
6. Pause while the app is inactive/backgrounded, the route is not current, text is being scrolled, or an accessibility focus change is being processed. Resume from remaining time, without counting background time. Preserve index and elapsed time across rotation and locale changes within the process.
7. Reduced motion or accessible navigation/screen-reader mode disables automatic advancement and decorative motion. Keep tap/swipe and labeled Previous/Next actions. Do not start automatic playback if that accessibility setting later turns off; require explicit Play. System accessibility pause must not be overridden by hold release.
8. Screen readers announce the story position/headline/body once on entry, not every progress tick. Essential navigation remains available without gestures. Physical keyboard arrows navigate, Space toggles playback when no control consumes it, and Enter activates the focused button.
9. Back on stories 2–10 goes to the previous story. Android back at story 1 follows the normal root-route exit behavior; it does not mark completion. A native back gesture must not reopen splash or bypass completion rules.
10. Navigation/illustration hit areas exclude header/footer controls and scrollable text. No tap-through or conflicting gestures.

## First-launch, persistence and routing contract

- Preserve the existing splash and its minimum duration/quote behavior. Load onboarding completion alongside session restoration; do not flash login before deciding the next route.
- After splash: a valid restored session goes to the existing signed-in destination; otherwise, an incomplete installation goes to `/onboarding`, and a completed installation goes to `/login`.
- Completion is installation-local and not tied to an authenticated account. Store a boolean completed marker behind an onboarding repository/service boundary; do not store credentials or analytics. Logout does not reset it. Reinstall or clearing app data resets it.
- Both Skip and Get started mark the tour completed and replace the route with login. Double taps must be idempotent. Back from login must not reopen onboarding or splash.
- Reading through all stories without explicitly exiting does not persist completion. Killing the app mid-tour restarts at story 1 on the next eligible launch.
- If completion cannot be read, treat it as incomplete. If saving fails, continue to login for the current process and avoid a redirect loop; the tour may reappear on a future launch. No storage failure should trap a user in onboarding.
- Retain a nonpersistent injected store for tests and a deterministic fresh-tour preview override. Preview overrides must not reset the real installation flag. Existing auth preview scenarios must remain usable and testable without changing real account behavior.
- Onboarding is fully local and works without connectivity. It requires no Serverpod endpoint, schema, AI request, authentication request, notification permission or file access prompt.
- No replay entry in Settings is required in this milestone because Settings is not implemented. A replay feature can be specified later.

## Tech stack and project structure

Use existing Flutter/Dart, ChangeNotifier, provider `6.1.5+1`, go_router `14.8.1`, Material 3 and ARB localization. Repository pubspec currently targets Dart `^3.12.2` and Flutter `^3.44.4`. Prefer Flutter's built-in animation and gesture APIs over a stories package.

| Location | Responsibility |
| --- | --- |
| `poodle_flutter/lib/features/onboarding/` | Stable story IDs/immutable models and local catalog |
| `poodle_flutter/lib/features/onboarding/presentation/views/` | Onboarding screen and layout |
| `poodle_flutter/lib/features/onboarding/presentation/view_models/` | Immutable story state and commands |
| `poodle_flutter/lib/features/onboarding/presentation/widgets/` | Story illustration, progress and controls |
| `poodle_flutter/lib/data/repositories/` | Onboarding completion contract and implementation |
| `poodle_flutter/lib/data/services/` | Device-preference storage adapter, if required |
| `poodle_flutter/lib/app/` | Router, injection, locale resolution and localized ARB messages |
| `poodle_flutter/lib/ui/theme/` | Shared visual tokens |
| `poodle_flutter/test/unit/features/onboarding/` | State/transition tests with deterministic time |
| `poodle_flutter/test/unit/data/` | Completion persistence/failure tests |
| `poodle_flutter/test/widget/` | Screen, gestures, routing, accessibility and visual baselines |
| `SPEC-onboarding.md` | This reviewed feature contract |

The user approved shared_preferences; version 2.5.6 is the direct dependency. PreferencesOnboardingStore wraps that plugin; MemoryOnboardingStore isolates tests and previews. The completion preference is not stored in account-scoped course caches. ONBOARDING_PREVIEW=true selects an isolated fresh tour; non-normal PREVIEW_SCENARIO values bypass the tour unless that override is set.

Views own rendering, animation, lifecycle/focus observations and gestures. ViewModels own immutable story state and navigation commands. Repositories own completion storage/error handling; services wrap platform storage. Inject deterministic time for state tests. Avoid putting frame-by-frame progress notifications on the whole app/router.

## Code style

Follow existing Dart formatting and `lower_snake_case.dart` filenames; classes use UpperCamelCase, members lowerCamelCase. Example of the existing project's immutable-state style, adapted to this feature:

```dart
@immutable
class OnboardingState {
  const OnboardingState({this.index = 0, this.paused = false});

  final int index;
  final bool paused;
}
```

This is a style example, not a complete state design. Keep all visible copy and semantic labels in English/Ukrainian ARB files; reference story IDs rather than localized text for state. Generate localization code with Flutter tools; never edit generated output by hand. Scope ViewModels to the workflow and dispose timers/listeners on exit.

## Commands and verification workflow

Run shell commands through RTK. The following use the installed Flutter SDK and are run from `poodle_flutter/` unless noted:

```sh
rtk proxy /Users/mac/Documents/flutter/bin/dart analyze lib test
rtk proxy /Users/mac/Documents/flutter/bin/dart format lib test
rtk proxy /Users/mac/Documents/flutter/bin/flutter gen-l10n
rtk proxy /Users/mac/Documents/flutter/bin/flutter test --no-pub --coverage
rtk proxy /Users/mac/Documents/flutter/bin/flutter test --no-pub test/widget/visual_baseline_test.dart
rtk proxy /Users/mac/Documents/flutter/bin/flutter build web --debug --no-pub --target lib/main_preview.dart
```

After approval and implementation, use the AGENTS checklist order for analysis/formatting, runtime restart, tests and logs. The user starts development with `rtk proxy serverpod start` from `poodle_server/`; the agent never starts it. Runtime operations must use Serverpod MCP: `hot_restart`, `tail_server_logs`, `tail_flutter_logs`; live interaction uses `get_flutter_app_dtd`, Dart MCP `connect_dart_tooling_daemon`, then `flutter_driver`. If tools are unavailable, report those checks pending. If MCP reports the server is not running, stop and ask the user to start it. No migrations are expected for this local-only feature.

## Testing strategy

Use red–green–refactor at public boundaries: ViewModel state, completion repository, rendered screen and routing. Follow TESTING.md: at least 80% handwritten logic coverage, excluding generated localization. Tests should demonstrate behavior, not reproduce implementation expressions.

- Unit: fixed story order/IDs; first/last bounds; manual transitions; eight-second boundaries; overlapping pause reasons; lifecycle elapsed-time preservation; final-story stop; accessibility override; disposed callbacks; duplicate completion; durable read/write and failure behavior.
- Widget: gestures plus visible controls, hold release/cancel, timer/manual race, Skip/Get started, platform back, keyboard navigation, live locale changes without resetting position, reduced motion/accessibility semantics, and light appearance under dark device settings.
- Routing: fresh signed-out install, completed install, mid-tour restart, restored session, logout, completion read/write failures and back-stack behavior. Inject independent stores to avoid test-order dependence.
- Visual/layout: English and Ukrainian representative stories (longest copy, first and last); 320×568 at 2× text, standard phone, landscape and tablet; light-only baselines; no clipped text or inaccessible controls. Load fonts/images deterministically before capture.
- Accessibility: labeled controls, logical focus order, contrast checks, 48-pixel targets, story announcements without progress-tick noise, pause/manual navigation. Verify VoiceOver and TalkBack on real Android/iOS devices before acceptance; automated semantics checks do not replace these.
- Existing splash/login tests remain green. No backend tests or live AI evaluations are needed because no backend or provider behavior changes.

## Boundaries

- **Always:** follow architecture/MVVM and existing theme/localization; keep the light-only constraint; present private data and offline limits accurately; use local illustrative data; test behavior before implementation; preserve current auth preview and generated Serverpod/client code; document verification limits.
- **Ask first:** changes to agreed launch timing/story content or persistence scope; new packages, schema, endpoints, authentication behavior or CI; replacing local illustrations with externally sourced/generated media.
- **Never:** implement the advertised LMS features as part of onboarding; send entered credentials or private material; autoplay audio/video; request permissions during the tour; allow unreadable timed content without manual controls; claim offline writes, public signup, group chats, graded AI quizzes or unrestricted website import; edit generated code manually.

## Success criteria

1. An eligible new installation shows splash → onboarding → login; Skip and Get started suppress onboarding on subsequent launches, including after logout.
2. All ten stories convey the listed first-release features and benefits in reviewed English/Ukrainian copy, with accurate private/offline boundaries and a visible Feature preview label in this milestone.
3. Segmented progress, automatic eight-second advancement, pause/hold, tap/swipe, keyboard and previous/next controls follow the interaction contract without skipped/double transitions.
4. Story 10 waits for explicit exit. Lifecycle, route changes, locale changes and rotation never lose the in-process reading position or advance in the background.
5. Reduced motion and accessible navigation use manual mode. Essential information and controls are reachable without timed gestures or sound.
6. Completion survives process restart; storage failures allow login without loops. Completion is device-local and independent of authentication.
7. Shared Poodle styling follows DESIGN.md's palette and reference composition; all screens stay light under dark system appearance and remain usable at the stated layout/text-size variants.
8. Existing app flows and affected tests pass; analyzer and formatter are clean; coverage meets TESTING.md. Live/device checks are either verified or explicitly reported pending.

## Implementation record

The original implementation checkpoint reported ten stories, eight-second playback, local completion, route integration and static illustrative scenes, with 54 passing tests and 95.5% handwritten-source line coverage at that date. The current catalog enables five stories, so those historical numbers are not a fresh verification of the present tour. Review found and regression-tested background startup and backward-input boundary races; both were fixed. The shared palette uses DESIGN.md tokens. Android/iOS device and VoiceOver/TalkBack checks remain open; see [STATUS.md](../status/STATUS.md) and [tasks/implementation-results.md](../archive/tasks/implementation-results.md).
