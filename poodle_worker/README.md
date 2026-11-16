# Notebook and search worker

1. Complete the [worker setup](../docs/development/worker.md), including provider settings and any tools needed for extraction.
2. From this package, run `dart run bin/main.dart` separately from the API.
3. Run `dart test` here. Routine tests use fake providers.

Use `--search-only` to run only indexing. See the [search rollout guide](../docs/guides/semantic-search-rollout.md).
