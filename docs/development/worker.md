# Notebook worker

The separate Dart worker consumes durable notebook `ingest`, `chat`, Studio and
search-index jobs. It is not
launched by `serverpod start`. The API remains responsible for authentication,
assessment configuration, source selection, job submission and private history.
See [STATUS.md](../status/STATUS.md) for the wider release boundary.

## Local configuration and launch

Provide your existing OpenAI key as `OPENAI_API_KEY` in the worker's local
environment. Do not put it in chat, source files, Flutter defines or Git.
The user owns key provisioning; no key was created during implementation.

Required environment variables:

| Variable | Meaning |
| --- | --- |
| `OPENAI_API_KEY` | Existing OpenAI credential, available only to the worker |
| `NOTEBOOK_GENERATION_MODEL` | Explicit Responses API model supporting JSON output |
| `NOTEBOOK_EMBEDDING_MICROS_PER_MILLION_TOKENS` | Positive embedding price |
| `NOTEBOOK_INPUT_MICROS_PER_MILLION_TOKENS` | Positive generation input price |
| `NOTEBOOK_OUTPUT_MICROS_PER_MILLION_TOKENS` | Positive generation output price |

Prices are integer **millionths of USD per million tokens**. Set them from your
provider's applicable rates; no assumed rate is baked into the command. Use a
conservative input price that covers applicable charges. Accounting does not
synchronize provider invoices. The global monthly cap defaults to USD 10 and
has a policy ceiling of USD 30.

Optional: `NOTEBOOK_SERVER_DIRECTORY` defaults to `../poodle_server` relative to
the working directory; `NOTEBOOK_SERVER_MODE` defaults to `development`, and
also accepts `staging` or `production`. The runtime reads that Serverpod mode's
database/password configuration and the API's private cloud-storage mapping.
It does not start API listeners, apply migrations or run development seeds.

After providing the variables, from `poodle_worker/`:

```sh
rtk dart run bin/main.dart
```

`--once` processes at most one job of each enabled kind, then exits. `--search-only`
indexes course search without notebook model/pricing configuration. SIGINT
and SIGTERM finish the active job before closing the private session. Missing
configuration exits before opening storage or calling OpenAI. Starting this
worker is separate from starting the API; migrations must already be applied.
The demo worker has also been exercised against the development database.

The embedding model is pinned to `text-embedding-3-small`, 1,536 dimensions,
with persisted identity `openai:text-embedding-3-small:1536:v1`. Query retrieval
requires an identical identity. Existing versions marked `legacy-unidentified`
are excluded; re-index them before use. Equal dimensions do not make models
interchangeable.

## GPT-6 Luna demo preset

The selected demo model is `gpt-6-luna`, with `reasoning.effort=none` for quick
source-grounded answers. The preset contains only public settings, never a key.
Once your existing key is available in the local environment, from this folder:

```sh
source demo.env.sh
rtk dart run bin/main.dart
```

`demo.env.sh` sets the model, reasoning effort and token prices. Its generation
prices conservatively use the documented Standard long-context rates; they are
budget accounting assumptions, not a measurement of your invoice. Embeddings
remain pinned to `text-embedding-3-small`; changing the generation model does
not require re-embedding source documents. Optional `NOTEBOOK_REASONING_EFFORT`
accepts `none`, `low`, `medium`, `high`, `xhigh` or `max`; omit it to use the chosen
model's default.

References checked 2026-10-29: [GPT-6 Luna](https://developers.openai.com/api/docs/models/gpt-6-luna),
[embedding model](https://developers.openai.com/api/docs/models/text-embedding-3-small).
Live verification on 2026-10-29 passed with this model and embedding space.
The Responses adapter uses a strict JSON schema for answers and citations.

## Processing and privacy

- Separate durable leases permit one ingestion and one chat at a time across
  worker processes. Three attempts, queued backoff, expired-lease recovery and
  fenced completion handle crashes. All private sessions disable SQL logging.
- TXT/Markdown extraction verifies real private bytes, SHA-256, strict UTF-8,
  signatures/controls and limits: 25 MiB, 500,000 characters, 256 chunks,
  8,000 UTF-8 bytes per chunk. Located immutable source versions and pgvector
  chunks commit atomically with source/job completion and budget settlement.
- Shared source publication, course/storage linkage and checksum are rechecked.
  PDF/DOCX use the bounded document adapter described below. Private-upload
  ingestion runs through a fail-closed ClamAV scan gate.
- Chat rechecks account status, active student membership, published assessment,
  defaults/selections, source versions, configuration revision and embedding
  identity before requests and completion. Changed snapshots fail safely.
- Vector cosine and PostgreSQL lexical rankings are restricted to authorized
  selected versions **before scoring**, combined with reciprocal rank fusion,
  and limited to eight evidence chunks. Evidence is treated as untrusted text.
- Valid responses must cite retrieved chunk IDs. Citation titles/version IDs/
  locations come from persisted records. Invalid citations save no answer.
  Insufficient evidence produces an English/Ukrainian server refusal.
- A budget reservation precedes provider work. Success settles actual usage;
  unknown failure/crash usage conservatively charges the reservation. User and
  assistant turns, citation metadata, accounting and completion commit together.
- `notebook.getTurns` is owner-only and rechecks current access. Withdrawn or
  deselected cited sources hide the affected saved answer and its citations.
- The OpenAI adapter disables redirects, bounds response size to 1 MiB and
  returns safe error codes without exposing provider bodies or credentials.

## Verification

Run `rtk dart analyze` and `rtk dart test --coverage=coverage` in this package.
Routine tests use Serverpod's embedded PostgreSQL/pgvector and actual private
database storage, with fake providers. No Docker, development API or live AI
credential is needed. The bilingual original fixture is `test/fixtures/study.md`.

The worker integration tests also run real PDF extraction, OCR, and audio
processing. On Ubuntu, install the same tools used by GitHub Actions:

```sh
sudo apt-get update
sudo apt-get install -y python3 poppler-utils tesseract-ocr tesseract-ocr-eng tesseract-ocr-ukr ffmpeg
tesseract --list-langs
```

Confirm the language list includes both `eng` and `ukr` before running tests.

The opt-in live test uses the same isolated database, real private seed bytes,
OpenAI embeddings, JWT login and notebook HTTP endpoints. With the existing key
exported locally, run from this folder:

```sh
source demo.env.sh
NOTEBOOK_LIVE_TEST=1 rtk dart test test/integration/live_notebook_demo_test.dart --concurrency=1
```

It checks cited English/Ukrainian answers, insufficient-evidence refusal and
budget settlement. Ordinary test runs skip it. Optional `NOTEBOOK_LIVE_REPORT`
sets a JSON report destination; reports contain the original demo questions,
answers and citation metadata, never credentials or provider error bodies.

The server suite additionally tests real JWT history ownership, stale-answer
redaction, adapter HTTP contracts and a database-only worker runtime. Passing
fake-provider tests does not establish live answer quality, provider model
compatibility or deployment readiness. The Flutter notebook screen supports
module/test entry, source selection, chat polling, citations and bilingual
document failure guidance. Studio uses the same queue and budget to generate
English or Ukrainian quizzes, flashcards, and private audio over selected
sources. Live Android/iOS acceptance is unverified.

For Audio Overview, install FFmpeg and FFprobe in the worker environment.
`NOTEBOOK_FFMPEG` and `NOTEBOOK_FFPROBE` override their
paths. The configured OpenAI key needs access to `gpt-audio-1.5`. Set
`NOTEBOOK_AUDIO_RESERVATION_MICROS` to tune the per-job speech budget
reservation (default `800000`).

## PDF and DOCX extraction

Install Python 3, Poppler (`pdfinfo`, `pdftotext`, `pdftoppm`), and Tesseract
with `eng` and `ukr` language data in the worker image. On
macOS, `brew install poppler` supplies Poppler; on Debian use `poppler-utils`.
Optional `NOTEBOOK_PYTHON_EXECUTABLE`, `NOTEBOOK_PDFINFO_EXECUTABLE`, and
`NOTEBOOK_PDFTOTEXT_EXECUTABLE`, `NOTEBOOK_PDFTOPPM_EXECUTABLE`, and
`NOTEBOOK_TESSERACT_EXECUTABLE` override executable paths. Ship the package's
`lib/src/extractors/extract_document.py` alongside Dart sources when deploying.

The adapter verifies original byte length, SHA-256 and format signature before
launching a process with argument lists and no shell. Child processes receive
PATH and locale only, never the worker's OpenAI key or database configuration.
Per-job private temporary directories are deleted after success or failure.

PDFs use Poppler's text layer and retain `page-N` citation locations. Pages
without a text layer are rasterized at a bounded size and OCRed with English and
Ukrainian Tesseract data. At most 20 pages per PDF may need OCR; the 200-page
limit still applies to text-layer PDFs. Encrypted documents are rejected.
A 500,000-character cap, 4 MiB output cap, 170-second CPU limit and 180-second
wall timeout bound extraction. Linux applies
a 512 MiB address-space limit inherited by Poppler. Darwin refuses that memory
limit; macOS is a development environment, while untrusted production ingestion
must run on Linux with container resource limits.

DOCX reads bounded OOXML body paragraphs/table text directly with Python's
standard ZIP/XML parsers. It does not invoke Office, execute fields/macros or
resolve links. Citation locations are `paragraph-N`; headings and table-cell
paragraphs retain document order. Headers, footers, drawings and pagination are
not extracted. LibreOffice remains planned for future office formats/layout
conversion. ZIP members are never unpacked to paths. Validation rejects macros,
embedded binary objects, external relationships, traversal/duplicate entries,
encrypted ZIP entries, XML entities/DTDs and oversized decompression (2,000
entries, 32 MiB total, 8 MiB/XML part, maximum 100:1 expansion ratio).

Real-tool fixtures cover bilingual PDF/DOCX text and hostile documents. These
tests require the native tools; ordinary runs still make no OpenAI calls.
Original fixture regeneration is in `test/fixtures/generate_documents.py`.

## Development sample

On a development API restart, an existing bootstrap teacher in the first sample
course enables the original bilingual **Test data / Тестові дані** assessment.
Its Markdown study file is stored privately and queued for ingestion. The seed
preserves teacher edits and never changes enrollment. An existing student
membership in that course is required to open its private notebook; the seed
never grants or reactivates membership. Once the configured worker processes
the file, open the assessment's **Study notebook / Навчальний блокнот** button.

## Private notebook uploads

Students can add TXT, Markdown, PDF or DOCX files allowed by the assessment's
teacher configuration. The development sample currently allows TXT/Markdown.
The API issues a 10-minute private-storage upload description, validates stored
size on finalization, and only then queues ingestion. Limits are 25 MiB/file,
20 active private files/account and 50 upload attempts/account/day. Upload
request keys are bound to the owner, notebook and immutable file metadata.
Private sources are selected automatically and visible only in their owner's
notebook. Removing one tombstones it, removes extracted versions/chunks and
selection, deletes the original object, and invalidates related answer access.
An outstanding upload capability can remain valid until its short expiry;
a late unverified upload is inaccessible and subject to storage expiry cleanup.

Install ClamAV and maintain its official signatures with `freshclam` before
accepting private uploads. Optional `NOTEBOOK_CLAMSCAN` selects the executable;
`NOTEBOOK_CLAMAV_DATABASE` selects its signature directory. The worker verifies
actual byte length and SHA-256 before scanning, then rechecks ownership,
membership, assessment publication and allowed format before embedding/commit.
Scanner subprocesses receive PATH only, use private temporary files, discard
all output and have a 90-second timeout. Infected/encrypted/macro/over-limit
files and unavailable/stale scanners fail closed. Signature databases must be
no more than seven days old. Deploy untrusted ingestion on Linux with container
CPU/memory limits as described above. Shared teacher-material processing is
unchanged; this scan gate applies to new student uploads.

The 2026-10-30 checkpoint below is historical. [Mobile device evidence from
2026-11-14](../archive/tasks/notebook-e2e-results.md) records refreshed official
signatures, real benign/EICAR scan behavior and successful private document
ingestion, alongside an intermittent scanned-PDF extraction failure.

Local verification on 2026-10-30 found a Homebrew ClamAV/OpenSSL regression:
https://github.com/Homebrew/homebrew-core/issues/322047 . Official signature
updates fail verification. The separately downloaded upstream macOS package
also failed macOS signature verification and was not executed or installed.
The demo worker uses the installed Homebrew scanner and fails private ingestion
with `scanner_unavailable` until a working scanner/signature database is supplied.
No signature verification was disabled. Scanner adapter tests use process test
doubles; private ingestion tests inject scan decisions and are not evidence of
a successful antivirus scan on this machine.
