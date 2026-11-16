# Semantic search rollout

Search uses current course membership and publication rules. It includes course
and section metadata, activity content, and eligible course files. The worker
backfills the search index independently of notebooks. Queries are stored in
per-account recent history and are never included in search diagnostics.

1. Apply the additive Serverpod migration. Run the existing Dart worker with
   `OPENAI_API_KEY` in its environment, or configure the Serverpod
   `openAiApiKey` password for the selected run mode. The API and worker use
   the same precedence: a nonblank environment key overrides the password. To run only search indexing, use
   `dart run bin/main.dart --search-only` from the worker package. The regular
   worker also indexes search. Neither mode starts the API.
2. Wait for indexing to catch up. Inspect counts by state in
   `poodle_search_index_job` and the oldest queued `availableAt`. Investigate
   failed jobs before resetting them to queued with zero attempts; their
   metadata remains searchable while indexing is incomplete.
3. Run the opt-in relevance check from the server package:
   `POODLE_RUN_LIVE_SEARCH_EVAL=true dart test test/integration/course_access_test.dart -n 'live search relevance'`.
   Use a server-side embedding credential. The test sends synthetic content
   and queries from the bilingual fixture, and checks top-five coverage by
   language pair and unrelated queries. Have a Ukrainian-speaking reviewer
   check the fixture and extend it with representative pilot material.
4. Calibrate `POODLE_SEARCH_MIN_SIMILARITY` on relevance and unrelated queries.
   The initial value is 0.30. Before enabling for the pilot, verify p95 latency
   under three seconds with 30 users and ten concurrent operations, and exercise
   VoiceOver/TalkBack on a device. Run both English and Ukrainian flows.
5. Semantic search activates automatically when an embedding credential is
   configured. Set `POODLE_SEMANTIC_SEARCH_ENABLED=false` while preparing or
   evaluating an environment, or to return to keyword matching without losing
   history. Restart through the normal deployment workflow after configuration
   changes. The API closes its per-request embedding connection after each query.

The next accessibility milestone is a whole-app audit: authenticate and complete
onboarding, then review dashboard, courses, notebook, teaching, notifications,
and settings with VoiceOver and TalkBack. Cover labels, reading and focus order,
text scaling, contrast, and touch targets, with regression tests for fixes.
