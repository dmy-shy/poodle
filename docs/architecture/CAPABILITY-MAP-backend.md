# Capability Map: Poodle Backend

This map records the original module boundaries approved on 2026-10-22. The table below now includes a source-review status as of 2026-11-15. See [STATUS.md](../status/STATUS.md) for the full app and release boundary.

## Original assumptions and changes since approval

1. The initial request targeted the backend foundation and read routes. Later work added assignments, chats, notifications, ingestion, AI, institutions and search.
2. PostgreSQL is accessed through Serverpod's existing database configuration and ORM. “Connection to DB” means durable models, migrations, and a verified persistence path, not a public database connection endpoint.
3. Serverpod's email identity provider and JWT sessions remain the authentication base. Google login/link and verified invitation rules are now implemented; live Google account acceptance is still pending.
4. The early three-role model was superseded by platform operator, university administrator, university eligibility and course-scoped teacher/student membership. A teacher does not gain access to every course.
5. Course routes serve authenticated active members. Students see published content; assigned teachers can see drafts. Administrative authority does not grant access to private notebook or chat content.

## Role model for review

| Role | Scope | Initial authority |
| --- | --- | --- |
| Platform operator | Platform | Review verified university requests and invite the first university administrator |
| University administrator | One university | Invite teachers/co-administrators and manage university access |
| Teacher | University eligibility plus active course membership | Create eligible draft courses; manage/publish assigned courses and invite students |
| Student | Active course membership | Read published courses, submit work, see own grades and use private study data |

All accounts authenticate through Serverpod. Platform and university authority are distinct; course teacher/student authority comes from active memberships. Administrative access to private student data is not implied.

## Module boundaries

| Module id | Responsibility | Depends on | Delivery |
| --- | --- | --- | --- |
| `backend-platform` | Validate Serverpod/PostgreSQL configuration and persistence | — | Implemented |
| `identity-access` | Built-in email/JWT, live Flutter auth, verified invitations and account checks | `backend-platform` | Implemented; expanded to universities |
| `google-auth-extension` | Google ID-token login and account linking | `identity-access` | Implemented; device account acceptance open |
| `course-membership` | Course records, course-scoped roles and member-only read/write checks | `identity-access` | Implemented |
| `course-content` | Ordered sections, typed activities, private files and draft visibility | `course-membership` | Implemented; teacher editing uses `teaching` module |
| `assignments-grades` | Assignment lifecycle, versioned submissions, grading, deadline rules and tests | `course-content` | Implemented in `teaching` and `student_learning` |
| `completion-progress` | Manual completion and server-calculated required-activity progress | `course-content`, `assignments-grades` | Not implemented |
| `private-messaging` | Eligible pairs, persistent history, idempotent send and read cursors | `course-membership` | Implemented without streams/offline cache |
| `calendar-announcements` | Course events and dedicated announcements | `course-membership`, `assignments-grades` | Partial: calendar derives assessment dates; announcement content exists, but dedicated service/feed does not |
| `notifications` | Persistent inbox, preferences, outbox and remote push | `identity-access`, `private-messaging`, `calendar-announcements`, `assignments-grades` | Partial: inbox and registration endpoint; delivery and preferences absent |
| `source-ingestion` | Private uploads, durable jobs, document extraction and source versions | `course-content` | Partial: TXT/MD/PDF/DOCX; URL/media import absent |
| `study-notebook` | Private notebooks, cited answers, notes, quizzes, flash cards and audio | `source-ingestion`, `course-membership` | Implemented for supported sources; device/reliability gates open |
| `semantic-search` | Course-scoped lexical and embedding search with worker index | `course-content` | Implemented; pilot rollout open |
| `university-access` | Requests, operator review, administrators, invitations and tenancy | `identity-access` | Implemented; legacy backfill and delivery/device rollout open |

The original build order was `backend-platform` → `identity-access` → `course-membership` → `course-content`. Subsequent modules were implemented out of this map's initial scope.

## Historical approved decisions

- The initial implementation covers database persistence, invitation-based authentication, course membership, and basic course/section/material routes.
- Google sign-in was approved as a separate extension; see [SPEC-google-auth-extension.md](../specs/SPEC-google-auth-extension.md) and [implementation results](../archive/tasks/google-auth-results.md).
- Development seed accounts are restricted to local development and tests. Production uses an email-bound platform-operator invitation; see [university access results](../archive/tasks/university-access-results.md).
- Course teacher/student authority remains membership-scoped. The earlier global admin model was replaced by distinct platform-operator and university-administrator authority.

## Module specifications

| Module id | Specification | Status |
| --- | --- | --- |
| `backend-platform` | [SPEC-backend-platform.md](../specs/SPEC-backend-platform.md) | Implemented; dated verification in [backend results](../archive/tasks/backend-platform.md) |
| `identity-access` | [SPEC-identity-access.md](../specs/SPEC-identity-access.md) | Implemented; original results are a historical checkpoint ([evidence](../archive/tasks/identity-access-results.md)) |
| `google-auth-extension` | [SPEC-google-auth-extension.md](../specs/SPEC-google-auth-extension.md) | Implemented; device account acceptance open ([evidence](../archive/tasks/google-auth-results.md)) |

Later modules are indexed in [STATUS.md](../status/STATUS.md) and their dated `tasks/*-results.md` records.

## Boundary contracts to define in module specs

- `identity-access` provides trusted account identity; university access supplies platform and university administration checks.
- `course-membership` provides active-membership checks and per-course `teacher`/`student` role checks. Every module that exposes course data uses these checks at the service boundary.
- `course-content` provides published source references to future assignment, ingestion, and study modules.

