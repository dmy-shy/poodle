# University access implementation — in progress

The approved multi-university onboarding plan is not fully implemented. This record distinguishes implemented code from completed runtime verification.

## Implemented

- University ownership and separate platform-operator/university-administrator authority.
- Public administrator request, email proof, rate limits, operator review and approval/rejection endpoints.
- University-scoped administrator, teacher and student invitations, email-bound acceptance, co-administrator management and last-administrator protection.
- Transactional email outbox, delivery retry scheduling and configured first-operator invitation bootstrap.
- Teacher draft-course creation, publication and student invitation endpoints.
- Membership filtering across course, messaging, search, notification, files, learning, teaching and notebook access paths.
- Bilingual request, operator-review, university-management and teacher-course screens connected to the live repository and role-specific navigation.
- Live sign-in administrator contact link. Preview retains its invitation explanation.
- Invitation email prefilling and preservation through splash on a fresh installation.
- Access-grant audit persistence and development seed ownership; legacy data backfill remains pending.

## Review fixes and verification

- Invitation acceptance rechecks whether the issuer is blocked. The same transactional grant policy is used for invitation creation, acceptance, revocation, and administrator changes. Grants waiting on a lock cannot proceed after the issuer loses authority.
- Operator bootstrap can replace expired or revoked invitations when there is no operator. An active invitation for the configured mailbox suppresses duplicate mail.
- Applicants can request another verification code or correct their email without re-entering the form. Role-change notices resolve the target account's authentication email when its projected email is missing.
- Peer discovery queries only shared courses. Membership checks and course list reads batch their data access.
- University routes are owned by the feature. Views, ViewModels, widgets, and tests now follow the project layout. Generated screenshot-diff files were removed; golden baselines were retained.
- The startup navigation test holds session restoration pending; inverting splash-link capture now fails the test. Widget tests also verify role guards for operator, university administrator, teacher, and student routes.
- Focused verification: **25 Flutter tests and 43 backend tests passed**; one optional live-search test skipped. Flutter and backend analysis reported no issues. The backend run measured 23/26 lines in the shared grant policy and 74/128 in the access service; the 90% authorization target is not established.
- No schema changes in the review fixes. The latest access-audit migration was already applied. Serverpod hot restart succeeded; recent logs showed Flutter reloads and a transient browser-refresh warning.

## Remaining rollout work

- Backfill legacy university ownership and verify existing accounts and courses retain access.
- Verify invitation links on Android and iOS from a delivered email, including platform link association and first-launch behavior.
- Complete real-device acceptance for operator review, university administration, and course creation.
- Configure deployment mail and verify operator bootstrap and delivery with the actual provider. Extend retry and authorization coverage.
