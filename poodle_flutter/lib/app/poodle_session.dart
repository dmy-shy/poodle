part of 'poodle_app.dart';

extension _PoodleSession on _PoodleAppState {
  Future<void> _signOut() async {
    final oldAccount = _account;
    if (oldAccount != null && !widget.repository.isPreview && !kIsWeb) {
      unawaited(_downloads.purge(oldAccount).catchError((_) {}));
    }
    _dashboard.clear();
    _courses.clear();
    widget.teachingRepository?.bindAccount(null);
    unawaited(_files.reset(null).catchError((_) {}));
    await widget.repository.signOut();
  }

  void _accountChanged() {
    final session = widget.repository.session;
    final account = session?.userId ?? session?.email;
    if (_account != account) {
      final oldAccount = _account;
      _account = account;
      _pendingRequestCount.value = null;
      _sync.bindAccount(account);
      if (!widget.repository.isPreview && !kIsWeb) {
        _downloads.bindAccount(account);
        if (oldAccount != null && oldAccount != account) {
          unawaited(_downloads.purge(oldAccount).catchError((_) {}));
        }
      }
      _dashboard.clear();
      _courses.bindAccount(account);
      widget.notebookRepository?.bindAccount(account);
      widget.notificationsRepository?.bindAccount(account);
      widget.teachingRepository?.bindAccount(account);
      _calendar.bindAccount(account);
      unawaited(_files.reset(account).catchError((_) {}));
      if (account != null && !widget.repository.isPreview) {
        unawaited(_sync.refresh());
      }
    }
  }
}
