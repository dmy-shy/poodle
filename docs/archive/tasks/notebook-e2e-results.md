# Notebook mobile end-to-end results — 2026-11-14

## Scope

Tested the signed-in student notebook on an iPhone 17 Pro simulator (iOS 26.4) and Medium Phone emulator (Android 16/API 36), against the demo server and separately running notebook worker. The teacher enabled DOCX, MD, PDF, and TXT. Both devices used the same student account.

## Device evidence

| Check | iOS | Android | Result |
| --- | --- | --- | --- |
| Allowed formats | [Screenshot](notebook-e2e-evidence/ios/sources-all-formats.png) | [Screenshot](notebook-e2e-evidence/android/sources-all-formats.png) | Both show DOCX, MD, PDF, TXT and a 25 MiB limit. |
| Private sources | [Shared-account ready list](notebook-e2e-evidence/ios/shared-account-sources-ready.png) | [DOCX](notebook-e2e-evidence/android/docx-ready.png), [PDF](notebook-e2e-evidence/android/pdf-ready.png), [scanned PDF](notebook-e2e-evidence/android/scanned-pdf-ready.png) | Android uploaded TXT, MD, DOCX, born-digital PDF, and scanned PDF; all eventually reached Ready. iOS showed the synced sources after refresh. Independent iOS upload was not verified. |
| Loading and error | — | [Preparing file](notebook-e2e-evidence/android/upload-scanned-pdf.png), [first scanned-PDF failure](notebook-e2e-evidence/android/scanned-pdf-error.png) | Loading appeared. The first scanned-PDF job failed; retrying the same file succeeded. |
| Quiz | [Correct cited answer](notebook-e2e-evidence/ios/quiz-answer.png) | [Loading](notebook-e2e-evidence/android/quiz-loading.png), [Ready](notebook-e2e-evidence/android/quiz-ready.png), [correct cited answer](notebook-e2e-evidence/android/quiz-answer.png) | New eight-question English quiz generated on Android, appeared on iOS, and the first answer was checked on both. |
| Flash cards | [Flipped cited card](notebook-e2e-evidence/ios/flashcard-answer.png) | [Ready](notebook-e2e-evidence/android/flashcards-ready.png), [flipped cited card](notebook-e2e-evidence/android/flashcard-answer.png) | New 12-card English set generated on Android, appeared on iOS, and the first card flipped on both. |
| Audio Overview | [Queued](notebook-e2e-evidence/ios/audio-queued.png), [player and transcript](notebook-e2e-evidence/ios/audio-playing.png) | [Ready](notebook-e2e-evidence/android/audio-ready.png), [player and transcript](notebook-e2e-evidence/android/audio-playing.png) | New English overview generated on iOS, appeared on Android, and its playback controls were exercised on both. |
| Existing chat | [Screenshot](notebook-e2e-evidence/ios/chat-existing-answer.png) | [Screenshot](notebook-e2e-evidence/android/chat-existing-answer.png) | Saved answer and citations display on both. A new chat response was not generated. |

These are direct simulator captures. The Android emulator needed `adb reverse tcp:8080 tcp:8080` because development upload URLs pointed to `localhost:8080`. Before forwarding, one upload stayed at preparation and its abandoned source was removed. Mobile Flutter Driver could not attach: Serverpod's mobile runners reported `App failed to start` after building, and `get_flutter_app_dtd` exposed only the web app. Device interactions were manual or through Device Hub accessibility controls.

## Worker and scanner

The worker is connected to the same development database as the app: DOCX, PDF, scanned PDF, quiz, flash-card, and audio jobs reached `complete`. The first scanned-PDF attempt reached extraction and failed with `extraction_failed` after one attempt; the same fixture succeeded on retry. The live OCR path is therefore intermittently unreliable, although the worker connection works. `poodle_worker/tool/notebook_job_status.dart` prints job statuses and failure codes without private content.

ClamAV initially refused benign files because its signatures were older than seven days. Updated ClamAV and refreshed official signatures. A real benign scan exits 0, while the EICAR test signature exits 1 under the worker's fail-closed policy. Added Tesseract OCR for textless PDF pages in English and Ukrainian with page citations and a 20-page cap. Real-tool tests covered English, Ukrainian, mixed text/OCR, encrypted and empty PDFs, and missing tools. The focused extractor suite passed 8 tests; the full worker suite passed 50 tests with 1 skipped after restoring local FFmpeg. Worker and Flutter static analysis passed. Flutter upload now times out after three minutes instead of waiting indefinitely.

## Open acceptance items

- Diagnose the intermittent live `extraction_failed` result for scanned PDFs.
- Verify direct iOS upload, unsupported and oversize files, offline recovery, and cross-account privacy on devices.
- Earlier Studio attempts with small sources showed the expected insufficient-evidence state; the newer quiz, flash-card, and audio jobs succeeded with the larger source set.
- Restore mobile Flutter Driver access if automated device regression is required.

No credentials or private user document contents are in this report.
