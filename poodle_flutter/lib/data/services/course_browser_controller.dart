/// Native page commands, separated from browser state for deterministic tests.
abstract interface class CourseBrowserController {
  Future<bool> canGoBack();
  Future<void> goBack();
  Future<void> reload();
}
