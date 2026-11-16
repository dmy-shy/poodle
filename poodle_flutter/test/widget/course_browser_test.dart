import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/app/signed_in_shell.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/course_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/course_browser_controller.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';
import 'package:poodle_flutter/features/courses/presentation/view_models/course_browser_view_model.dart';

class TestBrowserController implements CourseBrowserController {
  bool history = false;
  int backs = 0;
  int reloads = 0;
  @override
  Future<bool> canGoBack() async => history;
  @override
  Future<void> goBack() async {
    backs++;
    history = false;
  }

  @override
  Future<void> reload() async {
    reloads++;
  }
}

void main() {
  late FakeAuthRepository auth;
  late PreviewCourseRepository courses;
  late OnboardingRepository onboarding;
  late TestBrowserController controller;
  late CourseBrowserViewModel browser;

  Future<GoRouter> start(WidgetTester tester) async {
    auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('student@example.test'),
    );
    courses = PreviewCourseRepository();
    onboarding = OnboardingRepository(MemoryOnboardingStore(completed: true));
    controller = TestBrowserController();
    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        courseRepository: courses,
        onboardingRepository: onboarding,
        minimumSplashDuration: Duration.zero,
        courseWebViewBuilder: (model) {
          browser = model;
          model.attach(controller);
          model.loadFinished(model.initialUri.toString());
          return const SizedBox.expand(child: Text('Website surface'));
        },
      ),
    );
    await tester.pumpAndSettle();
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      auth.dispose();
      courses.dispose();
      onboarding.dispose();
    });
    return GoRouter.of(tester.element(find.byType(SignedInShell)));
  }

  Future<String> activityPath(String base) async {
    final content = await courses.content(sampleDesignId);
    final link = content.sections
        .expand((s) => s.activities)
        .firstWhere((a) => a.kind == ActivityKind.link);
    return '$base/activity/${link.id}';
  }

  testWidgets('website starts directly below toolbar with a status-bar inset', (
    tester,
  ) async {
    tester.view.padding = const FakeViewPadding(top: 59);
    addTearDown(tester.view.resetPadding);
    final router = await start(tester);
    router.push<void>(await activityPath('/courses/$sampleDesignId'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open website'));
    await tester.pumpAndSettle();
    final toolbar = find.byType(AppBar).last;
    final surface = find.byWidgetPredicate(
      (widget) =>
          widget is SizedBox &&
          widget.child is Text &&
          (widget.child! as Text).data == 'Website surface',
    );
    expect(
      tester.getTopLeft(surface).dy,
      closeTo(tester.getBottomLeft(toolbar).dy, 0.1),
    );
  });

  for (final base in [
    '/courses/$sampleDesignId',
    '/home/course/$sampleDesignId',
  ]) {
    testWidgets('$base opens in-app and Back consumes website history first', (
      tester,
    ) async {
      final router = await start(tester);
      final path = await activityPath(base);
      router.push<void>(path);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open website'));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '$path/browser');
      expect(router.state.uri.query, isEmpty);
      expect(find.text('Website surface'), findsOneWidget);
      expect(find.text('docs.flutter.dev'), findsOneWidget);
      controller.history = true;
      await browser.updateHistory();
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(controller.backs, 1);
      expect(find.text('Website surface'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Open website'), findsOneWidget);
      expect(router.state.uri.path, path);
    });
  }

  testWidgets(
    'page failure retries, notices stay readable, and sign-out removes the page',
    (tester) async {
      final router = await start(tester);
      router.go(await activityPath('/courses/$sampleDesignId'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open website'));
      await tester.pumpAndSettle();
      browser.loadFailed(browser.currentUri.toString());
      await tester.pumpAndSettle();
      expect(
        find.text('Unable to load this page. Check your connection and retry.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(controller.reloads, 1);
      browser.loadFinished(browser.currentUri.toString());
      browser.navigationAllowed('http://example.com');
      await tester.pumpAndSettle();
      expect(
        find.text('Only secure HTTPS links can be opened here.'),
        findsOneWidget,
      );
      await auth.signOut();
      await tester.pumpAndSettle();
      expect(find.text('Website surface'), findsNothing);
      expect(find.text('Welcome back'), findsOneWidget);
      browser.titleChanged('Late page callback');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a browser deep link without an authorized memory payload is unavailable',
    (tester) async {
      final router = await start(tester);
      router.go('${await activityPath('/courses/$sampleDesignId')}/browser');
      await tester.pumpAndSettle();
      expect(
        find.text('This course or activity is unavailable.'),
        findsOneWidget,
      );
      expect(find.text('Website surface'), findsNothing);
    },
  );

  testWidgets('Ukrainian browser controls fit narrow screens with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    tester.platformDispatcher.localesTestValue = [const Locale('uk')];
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final router = await start(tester);
    router.go(await activityPath('/courses/$sampleDesignId'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Відкрити вебсайт'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Відкрити вебсайт'));
    await tester.pumpAndSettle();
    browser.unsupported();
    await tester.pumpAndSettle();
    expect(find.byTooltip('Закрити браузер'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'account changes destroy the page and reject its old route payload',
    (tester) async {
      final router = await start(tester);
      final path = await activityPath('/courses/$sampleDesignId');
      router.go(path);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open website'));
      await tester.pumpAndSettle();
      final oldRequest = router.state.extra;
      courses.bindAccount('different-account');
      await tester.pumpAndSettle();
      expect(find.text('Website surface'), findsNothing);
      expect(
        find.text('This course or activity is unavailable.'),
        findsOneWidget,
      );
      router.go('/home');
      await tester.pumpAndSettle();
      router.push<void>('$path/browser', extra: oldRequest);
      await tester.pumpAndSettle();
      expect(find.text('Website surface'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Close exits immediately even when website history exists', (
    tester,
  ) async {
    final router = await start(tester);
    router.go(await activityPath('/courses/$sampleDesignId'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open website'));
    await tester.pumpAndSettle();
    controller.history = true;
    await browser.updateHistory();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close browser'));
    await tester.pumpAndSettle();
    expect(find.text('Website surface'), findsNothing);
    expect(find.text('Open website'), findsOneWidget);
    expect(controller.backs, 0);
  });

  testWidgets(
    'iOS route back-swipe returns to the activity without web history',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final router = await start(tester);
      router.go(await activityPath('/courses/$sampleDesignId'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open website'));
      await tester.pumpAndSettle();
      await tester.dragFrom(const Offset(1, 250), const Offset(350, 0));
      await tester.pumpAndSettle();
      expect(find.text('Website surface'), findsNothing);
      expect(find.text('Open website'), findsOneWidget);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );
}
