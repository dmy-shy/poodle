# Initial commit file audit

Audit date: 2026-11-16.

The audit examined the Git index: 994 UTF-8 text files and 231 binary files.
Checks included credential patterns, comparisons with local ignored password
configuration, bounded ZIP/DOCX fixture inspection, and OCR of 57 documentation
screenshots. Candidate matches were reviewed rather than automatically removed.

## Changes

- Removed the embedded database password from the shared VS Code task.
- Replaced both Docker database password literals with required environment
  variables. See [server setup](server.md#optional-docker-database-passwords).
- Replaced GitHub Actions password literals with explicit disposable CI-only
  values. Production and developer credentials are not used by CI.
- Removed four generated `IDEWorkspaceChecks.plist` files from the Git index
  and ignored future copies. Local files remain available.

## Retained files

Source, generated Serverpod contracts, migrations, dependency lockfiles,
test fixtures, approved visual baselines, and linked documentation are part
of the reproducible project. The RSA private key in
`poodle_server/test/support/google_keys.dart` is an explicitly public,
test-only fixture, not a deployment credential.

Firebase client configuration and OAuth client IDs remain because the mobile
builds use them. Firebase describes these client configuration values as
[public identifiers](https://firebase.google.com/docs/projects/learn-more).
Firebase API keys must be
[restricted to the appropriate APIs and clients](https://firebase.google.com/docs/projects/api-keys);
this local file audit cannot verify cloud-side key restrictions.

## Limits

No other live credential was identified by these checks. Pattern scanning and
OCR are not proof that arbitrary data contains no secrets. Test credentials
and placeholders remain intentionally. Build output, personal tooling caches,
local environment files and Serverpod password files remain ignored.

The previous root commit must not be a parent of the replacement initial
commit. Removing that commit from the branch does not revoke its credentials
or securely erase recovery objects from the local Git database. Rotate any
credential that was shared, published, or reused outside local development.
