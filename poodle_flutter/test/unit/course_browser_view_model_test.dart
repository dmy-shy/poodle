import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/services/course_browser_controller.dart';
import 'package:poodle_flutter/features/courses/presentation/view_models/course_browser_view_model.dart';

class FakeBrowserController implements CourseBrowserController {
  bool hasHistory = false;
  int backs = 0;
  int reloads = 0;
  Completer<bool>? pendingHistory;

  @override
  Future<bool> canGoBack() async => pendingHistory?.future ?? hasHistory;
  @override
  Future<void> goBack() async {
    backs++;
    hasHistory = false;
  }

  @override
  Future<void> reload() async => reloads++;
}

void main() {
  late CourseBrowserViewModel model;
  late FakeBrowserController controller;

  setUp(() {
    model = CourseBrowserViewModel(
      initialUri: Uri.parse('https://docs.flutter.dev/learn'),
      title: 'Flutter learning resources',
    );
    controller = FakeBrowserController();
    model.attach(controller);
  });
  tearDown(() => model.dispose());

  test('blocks non-HTTPS navigation without replacing the current page', () {
    model.loadFinished(model.initialUri.toString());
    expect(model.navigationAllowed('poodle://courses'), false);
    expect(model.notice, CourseBrowserNotice.blocked);
    expect(model.currentUri, model.initialUri);
    expect(model.failed, false);
    expect(model.navigationAllowed('https://flutter.dev'), true);
    model.loadStarted('https://flutter.dev');
    model.titleChanged('Flutter');
    expect(model.currentUri.host, 'flutter.dev');
    expect(model.title, 'Flutter');
    expect(model.notice, isNull);
  });

  test(
    'main-page failures persist through finish and recover on retry',
    () async {
      model.loadFailed(model.initialUri.toString(), isMainFrame: false);
      expect(model.failed, false);
      model.loadFailed(model.initialUri.toString());
      model.loadFinished(model.initialUri.toString());
      expect(model.failed, true);
      expect(model.loading, false);
      await model.reload();
      expect(controller.reloads, 1);
      expect(model.failed, false);
      expect(model.loading, true);
    },
  );

  test('back consumes web history, then allows the route to close', () async {
    controller.hasHistory = true;
    await model.updateHistory();
    expect(model.canGoBack, true);
    expect(await model.goBack(), true);
    expect(controller.backs, 1);
    expect(await model.goBack(), false);
  });

  test('redirect failures and successful redirects use the final host', () {
    model.loadFailed('https://example.com/redirected');
    expect(model.failed, true);
    expect(model.currentUri.host, 'example.com');
    model.loadStarted('https://example.com/redirected');
    model.loadFinished('https://flutter.dev/final');
    expect(model.currentUri.host, 'flutter.dev');
    expect(model.loading, false);
    expect(model.failed, false);
    model.progressChanged(500);
    expect(model.progress, 100);
    model.titleChanged('');
    expect(model.title, 'flutter.dev');
  });

  test(
    'popup notices are dismissible and invalidation rejects all navigation',
    () async {
      model.unsupported();
      expect(model.notice, CourseBrowserNotice.unsupported);
      model.dismissNotice();
      expect(model.notice, isNull);
      model.invalidate();
      expect(model.navigationAllowed('https://example.com'), false);
      await model.reload();
      expect(controller.reloads, 0);
      expect(await model.goBack(), false);
    },
  );

  test(
    'callbacks after disposal cannot notify or complete old history',
    () async {
      controller.pendingHistory = Completer<bool>();
      final pending = model.updateHistory();
      var notifications = 0;
      model.addListener(() => notifications++);
      model.dispose();
      controller.pendingHistory!.complete(true);
      await pending;
      model.loadStarted('https://flutter.dev');
      model.titleChanged('Old account');
      model.loadFailed(model.initialUri.toString());
      expect(notifications, 0);
      // Prevent a second dispose in tearDown.
      model = CourseBrowserViewModel(
        initialUri: Uri.https('example.com'),
        title: '',
      );
    },
  );
}
