# Notebook implementation status

## Verified on 2026-10-29

Android Studio's Serverpod terminal confirmed that migration
`20261029130710820-notebook` applied and the server reloaded successfully.
The broken, unregistered migration is preserved under the server's
`.dart_tool/migration-backups/` directory.

The backend has assessment-scoped notebook configuration, private student
notebooks, source selection, chat job submission/status, chunking, rank fusion,
citation validation primitives and a provider adapter. The ingestion and chat worker checkpoint below now connects these pieces into
a fake-provider-tested backend pipeline; mobile notebook UI remains pending.

## Material registration checkpoint

Configuring a module/test now registers shared sources and durable `ingest`
jobs in the same transaction as the configuration. Repeated configuration
reuses a source/job for the same source checksum. A course advisory lock
serializes configuration updates so stale revisions fail with
`configuration_conflict`. Invalid formats return `invalid_configuration`.

Material registration requires published files from the same course, private
storage, a supported extension/MIME pair (PDF, TXT, Markdown, DOCX), a checksum,
and a declared size from 1 byte through 25 MiB. These are metadata checks;
the ingestion worker must verify actual bytes, checksum, signature and limits.

Notebook reads recheck current publication and storage linkage before exposing
shared material. Integration tests use real JWT authentication and an isolated
database with a `Test data` assessment. They verify registration, concurrent
revision conflicts, repeated configuration, private source/job isolation,
membership revocation, unpublishing and rejection of public storage.
Fixtures contain metadata only; they do not claim to test document extraction.

Validation: server `dart analyze` reported no issues; changed Dart files are
formatted; the full server suite passed all 45 tests, including the three new
notebook integration scenarios. Android Studio showed successful server and
Flutter hot reloads after the backend changes, with no new errors visible.
Coverage percentages and mobile interaction acceptance were not measured here.

The course HTTP test helper also accepts non-JSON error responses for malformed
UUID parameters, while still rejecting malformed successful responses.

## Ingestion core checkpoint

Added the `poodle_worker` workspace package. It implements single-extraction
leases across processes, backoff/three-attempt retry limits, expired-lease
recovery and fenced completion. Shared material publication, course/storage
linkage and checksum are checked again at execution and completion. Worker
sessions must disable query logging. API and worker source updates share the
course lock.

TXT/Markdown bytes are read from private storage, validated, normalized into
located blocks, chunked and embedded through an injected provider. Immutable
source versions, pgvector chunks, budget settlement, source ready state and
job completion commit atomically. The monthly cap is reserved before embedding
calls; failed/crashed requests are charged conservatively when usage is unknown.
The polling loop closes sessions and finishes active work before shutdown.

The original bilingual study fixture now exercises real private storage and
pgvector with a fake provider. All 22 worker tests pass; worker coverage is
281/289 lines (97.2%), including 97.7% in ingestion and 93.3% in extraction.
Analysis is clean in both packages. No provider credential or external API call
was used. No data model change or additional migration was necessary.
The backend regression suite also passed all 45 tests. Android Studio's terminal
showed successful server/Flutter reloads with no new errors visible after the
workspace changes.

This is a tested worker core, not a deployed/live worker. The separate process
entry point, provider/model identity and private storage composition remain to
be connected. PDF/DOCX explicitly fail as unsupported until bounded native
adapters exist. See [worker details](../../development/worker.md).

## Chat execution and process checkpoint

Added `NotebookChatWorker`: selected/version-authorized vector and lexical
retrieval with reciprocal rank fusion, bounded evidence, private provider calls,
validated citations, bilingual insufficient-evidence refusal, usage reservation
and atomic user/assistant history. Execution and commit both recheck persisted
account/membership/publication/configuration/selection/version authority.

`notebook.getTurns` uses the real authenticated account, returns only its private
history, and hides answers/citations when cited material is no longer available.
HTTP integration tests cover owner access, teacher/anonymous denial and source
deselection. The history endpoint uses a dedicated service; this also resolved a
stale incremental analyzer state that had omitted the notebook endpoint.

The source version records now persist embedding-space identity; answers persist
citation metadata and refusal state. Migration
`20261029144829910-notebook-answers` was created and applied through Serverpod
MCP. It only adds columns and preserves existing rows. Legacy unidentified
embedding versions are excluded from worker retrieval.

`poodle_worker/bin/main.dart` composes the existing OpenAI adapter, private
Serverpod database/storage runtime, pinned embedding model and ingestion/chat
loops. It requires explicit generation model and token prices. It handles
shutdown, closes sessions and never starts an API server or applies migrations.
A runtime integration test verifies database access with logging disabled and
no API listeners. The adapter no longer has an invented default generation
model; redirects are disabled, responses are bounded and HTTP behavior is
covered with a fake transport.

The user chose OpenAI and will provide their existing key locally. No key was
created, written, disclosed or used for a live API request. Configuration and
launch instructions are in [the worker README](../../development/worker.md).

Validation: both packages pass `dart analyze`. The full server suite passed 53
tests and the worker suite passed 31 tests; the focused authenticated notebook
suite also covers concurrent first opens and idempotent retries after source
selection/budget-payload changes. Measured library line coverage: worker
461/473 (97.5%); notebook-related server code 588/638 (92.2%), including
execution authorization 65/69 (94.2%). Worker command behavior is verified by
a subprocess test; command subprocess lines are excluded from those library
coverage figures. Live model output quality and mobile interaction are not
covered by these results.

## Mobile notebook and development sample

The live Flutter composition now injects a session-scoped notebook repository.
Module/test activities link to a notebook route with a screen-owned ViewModel.
The English/Ukrainian screen displays preparation status, source selection,
private chat history, asynchronous answer status, stale-answer redaction and
source/version/location citations. Requests use the existing authenticated
Serverpod client; account changes clear questions/history and fence late reads.
No notebook content or outgoing question is persisted locally. Ambiguous retries
reuse the same request key while the screen remains alive.

The development seed adds an original bilingual Markdown source and configured
`Test data / Тестові дані` assessment to the first sample course, provided its
bootstrap teacher remains enrolled. It stores actual private bytes and queues
ingestion, preserves teacher edits and never grants or reactivates membership.
The server suite verifies stored text, repeatability and revoked membership.

Latest validation: all **54 server tests** pass after the runtime smoke test was
isolated onto its own embedded PostgreSQL data directory and port. All **31
worker tests** pass. The focused Flutter run passes **28 tests**, including
repository HTTP contracts, ViewModel cancellation/retry/polling, English and
Ukrainian widgets at enlarged text, account-switch cleanup, module-to-notebook navigation, app routing/auth
regressions and gateway tests. Static analysis is clean across all three packages.
The wider Flutter run reports **138 passes and 21 failures** in onboarding,
preview-content expectations, plugin setup and visual baselines; these are not
claimed as passing. See `/tmp/poodle-flutter-final.log` for that run.

Notebook Flutter library coverage in the focused run was above 90% per file
(repository contract, live adapter, ViewModel and View). The earlier measured
worker/server library coverage is recorded above; it predates the final seed
addition. No live AI quality, mobile acceptance or load result is claimed.
Serverpod MCP hot restart/reload operations succeeded. No app DTD was available
from `get_flutter_app_dtd`, so live driver acceptance could not run.

## Remaining implementation

1. User local OpenAI credential/model/price configuration, then worker launch,
   live bilingual answer evaluation and deployment. No live provider call was
   made and the development worker queue was not consumed.
2. Live Android/iOS acceptance, offline/reconnect and pilot load validation.
3. Bounded PDF/DOCX extraction, private uploads and optional study artifacts.

The TXT/Markdown RAG flow and mobile screen are implemented and tested with
fakes. This checkpoint does not claim full NotebookLM feature parity.
Serverpod MCP is available through its local socket; migration/reload/log
operations use that MCP connection.

## Demo model selection

User selected GPT-6 Luna. `poodle_worker/demo.env.sh` supplies public model,
reasoning (`none`) and budget-price settings. The worker forwards the optional
reasoning effort through the existing Responses adapter. The pinned embedding
space remains unchanged. The existing-key decision is unchanged; the user
provides it locally. No secret was written and no live provider call was made.

## Live GPT-6 Luna acceptance — 2026-10-29

This verification supersedes the earlier statements that no live provider call
or DTD session was available. The existing key was supplied locally by the user.
No credential was generated or committed.

Real Responses requests exposed a JSON-mode HTTP 400 at `input`. The adapter now
uses strict structured output with the required answer/citation/refusal schema.
Permanent HTTP errors are classified separately from retryable failures; only
allowlisted status/code/parameter identifiers are retained, without error bodies.

The opt-in worker integration test passed against real OpenAI embeddings and
GPT-6 Luna in an isolated Serverpod database. It verifies private Markdown
ingestion, builtin email/JWT login, notebook HTTP endpoints, cited English and
Ukrainian answers, unsupported-question refusal, and settled usage reservations.
The report is `tasks/notebook-live-demo-results.json`: four chunks, no provider
failures, 383 accounted microdollars and zero outstanding reservations.

After the fix, all 55 server tests and 31 routine worker tests passed; the live
test is skipped by default. Server and worker static analysis passed.

The development teacher account was correctly denied student notebook access.
At the user's request, a separate student account was created with builtin
email authentication and enrolled only in the Creative thinking sample course.
Its supplied password is not stored in source or this report. The demo's queued
Markdown source was ingested. Flutter Driver navigated Courses → Creative
thinking → Test data → Study notebook, submitted English and Ukrainian questions,
and observed live answers with `test-data.md · version 1 · block-3` citations.
The separate development worker is running for the demo.
The live UI also displayed the unsupported-question refusal without citations,
then retained all six turns after leaving and reopening the notebook. Serverpod
MCP logs show successful notebook calls; Dart reports no Flutter runtime errors.
Flutter stdout contains tooling tracker notices from timed-out driver probes.
This was acceptance on the running web app, not Android/iOS device acceptance.

## Bounded document ingestion — 2026-10-29

PDF and DOCX shared course sources now flow through the same authorized,
lease-fenced ingestion pipeline as TXT/Markdown. Real Poppler extracts PDF text
with page locations. A separate Python ZIP/XML adapter extracts DOCX body and
table paragraphs with stable paragraph locations, without executing office
content or resolving relationships. Original bytes are checked before parsing.
The subprocess receives no worker credentials and applies CPU/output/time and
decompression limits; Linux also enforces 512 MiB address space. macOS development
does not enforce that memory limit. Poppler was installed locally for real-tool
verification; deployment requires Python 3 and Poppler in the worker image.

The Flutter source model now carries the safe failure code to localized recovery
guidance for encrypted, unreadable, oversized and unsupported-content documents.
No generated code, data models or migrations changed.

All 37 worker tests passed (one live-provider test skipped by default), including
real bilingual PDF/DOCX extraction, private-storage database ingestion, encrypted
and empty PDFs, macros, external relationships, traversal, entity declarations,
decompression bombs, tool absence and timeout. All 15 focused Flutter tests passed.
Static checks and the Serverpod MCP restart/log review completed. OCR, other
office formats, private uploads and Android/iOS acceptance remain pending.


## Private uploads checkpoint — 2026-10-30

Implemented begin/upload/finalize APIs, owner-bound private paths and request
keys, teacher format policy, byte/count/rate limits, mobile file picking,
account-change fencing, localized status/errors, selection and removal.
Deletion removes original bytes, extracted versions/chunks and selection;
worker revalidation prevents deleted or revoked sources from becoming ready.
No database schema change/migration was needed; protocol DTOs/client were
regenerated. A stale incremental analyzer was resolved by isolating upload
handling in a new dedicated service file.

Validation: 56 server tests, 43 worker tests (one opt-in live test skipped),
and 17 focused Flutter tests pass. Changed paths pass static analysis and are
formatted. Tests cover real HTTP storage upload/finalization, teacher and other
student denial, invalid/oversize/disallowed inputs, metadata-bound idempotency,
removal, scanner gating before provider calls, revocation/deletion during
execution and account changes during file picking. Serverpod MCP restart and
reload succeeded; Flutter Driver health responds. Full live file-picker/device
acceptance and a real antivirus scan are not claimed.

Live private ingestion remains blocked by ClamAV setup: Homebrew 1.5.4_1 fails
signature verification (upstream Homebrew issue 322047). A downloaded official
package also failed local macOS signature verification and was left unexecuted.
No verification bypass was applied. The demo worker runs the updated code with
fail-closed scanning. Existing shared-material chat remains available.
