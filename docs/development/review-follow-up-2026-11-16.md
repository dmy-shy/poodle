# Review follow-up: calendar isolation and Studio decoding

## Fixes

| Finding | Change | Regression coverage |
| --- | --- | --- |
| A pending cache read could restore a previous account’s calendar after an account switch. | Verify the account generation before assigning cached data. Superseded loads return no snapshot. Recheck the generation after asynchronous persistence before notifying listeners. | Delay the old account’s cache read until the new calendar is visible; check that the old load returns nothing and the new snapshot stays intact. |
| Malformed browser cache data could prevent calendar refresh. | Decode local data inside the recovery block. Purge malformed entries and continue loading course data. | Chrome tests recover from invalid JSON and a valid JSON array in place of an object. CI runs both browser cases. |
| Studio accepted malformed rows that could throw during rendering. | Decode quiz questions, flashcards, and transcripts into typed rows. Reject missing or wrongly typed fields, malformed citations, and invalid multiple-choice metadata. The Studio view displays its existing failure message for invalid content. | Decoder tests cover all three variants and malformed rows. Widget tests still cover quiz scoring, flashcards, and transcripts. |

There are no Serverpod schema or wire protocol changes.

## Verification

Workspace analysis passed with fatal informational findings enabled. The focused Flutter run passed eight tests on the native test runner. Chrome passed both browser recovery tests. Serverpod and Flutter restarted through MCP, and the sampled runtime logs showed no new errors.

These checks do not replace a fresh full-suite run or establish project-wide coverage. The prior review recorded 20 Flutter failures and one worker timeout, and the available reports did not verify the [coverage targets](TESTING.md#coverage-and-quality-gates-targets). The dependency advisory scan and a live device walkthrough remain unverified. Before release, rerun the full suites, establish coverage for the documented critical paths, and complete a lockfile advisory check through an approved workflow.
