import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../data/services/course_browser_controller.dart';
import '../../../../data/services/course_link_policy.dart';

enum CourseBrowserNotice { blocked, unsupported }

class CourseBrowserViewModel extends ChangeNotifier {
  CourseBrowserViewModel({required this.initialUri, required this.title})
    : currentUri = initialUri;

  final Uri initialUri;
  Uri currentUri;
  String title;
  bool loading = true;
  bool failed = false;
  bool canGoBack = false;
  int progress = 0;
  CourseBrowserNotice? notice;
  CourseBrowserController? _controller;
  bool _active = true;
  bool _backPending = false;
  int _historyRequest = 0;

  void attach(CourseBrowserController controller) {
    if (!_active) return;
    _controller = controller;
    unawaited(updateHistory());
  }

  bool navigationAllowed(String? value, {bool isMainFrame = true}) {
    if (!_active) return false;
    if (!isMainFrame || courseLinkUri(value) != null) return true;
    notice = CourseBrowserNotice.blocked;
    loading = false;
    notifyListeners();
    return false;
  }

  bool loadStarted(String? value) {
    if (!navigationAllowed(value)) return false;
    currentUri = courseLinkUri(value)!;
    title = currentUri.host;
    progress = 0;
    loading = true;
    failed = false;
    notice = null;
    notifyListeners();
    return true;
  }

  void pageChanged(String? value) {
    if (!_active) return;
    final uri = courseLinkUri(value);
    if (uri == null) return;
    currentUri = uri;
    notifyListeners();
    unawaited(updateHistory());
  }

  void titleChanged(String? value) {
    if (!_active) return;
    title = value == null || value.trim().isEmpty ? currentUri.host : value;
    notifyListeners();
  }

  void progressChanged(int value) {
    if (!_active) return;
    progress = value.clamp(0, 100);
    notifyListeners();
  }

  void loadFinished(String? value) {
    if (!_active) return;
    final uri = courseLinkUri(value);
    if (uri == null) return;
    currentUri = uri;
    loading = false;
    progress = 100;
    notifyListeners();
    unawaited(updateHistory());
  }

  void loadFailed(String? value, {bool isMainFrame = true}) {
    if (!_active || !isMainFrame) return;
    final uri = courseLinkUri(value);
    if (uri == null) return;
    currentUri = uri;
    failed = true;
    loading = false;
    notifyListeners();
  }

  void unsupported() {
    if (!_active) return;
    notice = CourseBrowserNotice.unsupported;
    loading = false;
    notifyListeners();
  }

  void dismissNotice() {
    if (!_active) return;
    notice = null;
    notifyListeners();
  }

  Future<void> updateHistory() async {
    final controller = _controller;
    if (!_active || controller == null) return;
    final request = ++_historyRequest;
    try {
      final result = await controller.canGoBack();
      if (!_active || request != _historyRequest) return;
      canGoBack = result;
      notifyListeners();
    } catch (_) {
      // Closing the route remains possible if a native view has disappeared.
    }
  }

  Future<bool> goBack() async {
    final controller = _controller;
    if (!_active || controller == null) return false;
    if (_backPending) return true;
    _backPending = true;
    try {
      final hasHistory = await controller.canGoBack();
      if (!_active) return true;
      if (!hasHistory) return false;
      await controller.goBack();
      await updateHistory();
      return true;
    } catch (_) {
      return false;
    } finally {
      _backPending = false;
    }
  }

  Future<void> reload() async {
    final controller = _controller;
    if (!_active || controller == null) return;
    failed = false;
    notice = null;
    loading = true;
    progress = 0;
    notifyListeners();
    try {
      await controller.reload();
    } catch (_) {
      loadFailed(currentUri.toString());
    }
  }

  void invalidate() {
    _active = false;
    _controller = null;
    _historyRequest++;
  }

  @override
  void dispose() {
    invalidate();
    super.dispose();
  }
}
