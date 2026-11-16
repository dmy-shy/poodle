import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/app/signed_in_header.dart';
import 'package:poodle_flutter/app/ios_navigation_bar.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';

void main() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('poodle/ios_navigation'),
          (call) async => 25,
        );
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('poodle/ios_navigation'),
          null,
        );
  });

  Future<void> launch(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    Locale locale = const Locale('en'),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.localesTestValue = [locale];
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('student@example.com'),
    );
    final onboarding = OnboardingRepository(
      MemoryOnboardingStore(completed: true),
    );
    addTearDown(auth.dispose);
    addTearDown(onboarding.dispose);
    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        onboardingRepository: onboarding,
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder tab(String label) => find.descendant(
    of: find.byType(CupertinoTabBar),
    matching: find.text(label),
  );

  testIosWidgets(
    'iOS 26 native selection follows routes and scroll minimizes reversibly',
    (tester) async {
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(
        IosNavigationBar.capabilities,
        (call) async => 26,
      );
      final states = <Map<Object?, Object?>>[];
      String? nativeChannel;
      messenger.setMockMethodCallHandler(SystemChannels.platform_views, (
        call,
      ) async {
        if (call.method == 'create') {
          final args = call.arguments as Map;
          states.add(
            (const StandardMessageCodec().decodeMessage(
                      ByteData.sublistView(args['params'] as Uint8List),
                    )
                    as Map)
                .cast<Object?, Object?>(),
          );
          nativeChannel = 'poodle/ios_navigation/${args['id']}';
          messenger.setMockMethodCallHandler(MethodChannel(nativeChannel!), (
            update,
          ) async {
            if (update.method == 'update') {
              states.add((update.arguments as Map).cast<Object?, Object?>());
            }
            return null;
          });
        }
        return null;
      });
      addTearDown(() {
        messenger.setMockMethodCallHandler(SystemChannels.platform_views, null);
        if (nativeChannel != null) {
          messenger.setMockMethodCallHandler(
            MethodChannel(nativeChannel!),
            null,
          );
        }
      });
      tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
      tester.view.viewPadding = const FakeViewPadding(top: 59, bottom: 34);
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.view.resetViewPadding);
      await launch(tester);
      expect(find.byType(UiKitView), findsOneWidget);
      final router = GoRouter.of(tester.element(find.byType(IosNavigationBar)));
      router.go('/courses');
      await tester.pumpAndSettle();
      final coursesBar = find.widgetWithText(AppBar, 'Courses');
      expect(tester.getSize(coursesBar).height, lessThan(70));
      router.go('/calendar');
      await tester.pump(const Duration(milliseconds: 300));
      expect(states.last['selectedIndex'], 2);
      final header = find.byType(SignedInHeader);
      final calendarTitle = find.widgetWithText(AppBar, 'Calendar');
      expect(
        tester.getTopLeft(calendarTitle).dy,
        tester.getBottomLeft(header).dy,
      );
      expect(tester.getSize(calendarTitle).height, lessThan(70));
      tester.binding.channelBuffers.push(
        nativeChannel!,
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('select', 4),
        ),
        (_) {},
      );
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/search');
      expect(states.last['selectedIndex'], 4);
      final input = find.byType(TextField);
      expect(
        tester.getTopLeft(input).dy - tester.getBottomLeft(header).dy,
        inInclusiveRange(0, 8),
      );
      final historyIcon = find.byIcon(Icons.history);
      final emptyLabel = find.text('No recent searches. Try to search.');
      expect(tester.getSize(historyIcon).height, 72);
      expect(
        tester.getCenter(historyIcon).dx,
        closeTo(tester.getCenter(emptyLabel).dx, 1),
      );
      expect(
        tester.getTopLeft(historyIcon).dy,
        greaterThan(tester.getBottomLeft(input).dy + 40),
      );
      router.go('/home');
      await tester.pumpAndSettle();
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -350));
      await tester.pumpAndSettle();
      expect(states.last['minimized'], isTrue);
      tester.binding.channelBuffers.push(
        nativeChannel!,
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('expand'),
        ),
        (_) {},
      );
      await tester.pumpAndSettle();
      expect(states.last['minimized'], isFalse);
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          FakeAccessibilityFeatures(reduceMotion: true);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -350));
      await tester.pumpAndSettle();
      expect(states.last['minimized'], isFalse);
      expect(states.last['reduceMotion'], isTrue);
      tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testIosWidgets(
    'older iOS has five Cupertino destinations and labeled search',
    (
      tester,
    ) async {
      await launch(tester);
      expect(find.byType(CupertinoTabBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      for (final label in [
        'Home',
        'My courses',
        'Calendar',
        'Notifications',
        'Search',
      ]) {
        expect(tab(label), findsOneWidget);
      }
      await tester.tap(tab('Calendar'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        GoRouter.of(
          tester.element(tab('Home')),
        ).routeInformationProvider.value.uri.path,
        '/calendar',
      );
      await tester.tap(tab('Search'));
      await tester.pumpAndSettle();
      expect(find.text('Search course content'), findsOneWidget);
      expect(find.byType(EditableText), findsOneWidget);
      expect(find.text('Feature preview'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testIosWidgets('iOS Home keeps Messages, More and Sign out reachable', (
    tester,
  ) async {
    await launch(tester);
    await tester.tap(find.byKey(const ValueKey('account-menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(PopupMenuItem<String>, 'Messages'));
    await tester.pumpAndSettle();
    expect(find.text('Private messages'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('header-home-back')));
    await tester.pumpAndSettle();
    expect(find.text('Upcoming tasks'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('account-menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(PopupMenuItem<String>, 'More'));
    await tester.pumpAndSettle();
    expect(find.text('Sign out'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Sign out'),
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(CupertinoTabBar), findsNothing);
    final router = GoRouter.of(tester.element(find.text('Welcome back')));
    for (final path in ['/calendar', '/search']) {
      router.go(path);
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testIosWidgets(
    'iOS tab switches and Home utilities preserve Home scroll state',
    (tester) async {
      await launch(tester);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -350));
      await tester.pumpAndSettle();
      double offset() => tester
          .state<ScrollableState>(
            find
                .descendant(
                  of: find.byType(CustomScrollView),
                  matching: find.byType(Scrollable),
                )
                .first,
          )
          .position
          .pixels;
      final before = offset();
      expect(before, greaterThan(0));
      await tester.tap(tab('My courses'));
      await tester.pumpAndSettle();
      await tester.tap(tab('Home'));
      await tester.pumpAndSettle();
      expect(offset(), closeTo(before, 1));
      await tester.tap(find.byKey(const ValueKey('account-menu')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(PopupMenuItem<String>, 'More'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('header-home-back')));
      await tester.pumpAndSettle();
      expect(offset(), closeTo(before, 1));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testIosWidgets(
    'iPhone landscape keeps bottom tabs; Android retains Material destinations',
    (tester) async {
      await launch(tester);
      tester.view.physicalSize = const Size(844, 390);
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoTabBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
      final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(
        bar.destinations.cast<NavigationDestination>().map(
          (item) => item.label,
        ),
        ['Home', 'Courses', 'Messages', 'Notifications', 'More'],
      );
      await tester.pumpWidget(const SizedBox.shrink());
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    },
  );

  for (final locale in [const Locale('en'), const Locale('uk')]) {
    testIosWidgets(
      'Cupertino tabs stay usable at 320 points and 2x text in ${locale.languageCode}',
      (tester) async {
        await launch(
          tester,
          size: const Size(320, 568),
          locale: locale,
          textScale: 2,
        );
        final bar = tester.widget<CupertinoTabBar>(
          find.byType(CupertinoTabBar),
        );
        expect(bar.items.length, 5);
        expect(tester.takeException(), isNull);
        final search = locale.languageCode == 'uk' ? 'Пошук' : 'Search';
        await tester.tap(tab(search));
        await tester.pumpAndSettle();
        expect(
          find.text(
            locale.languageCode == 'uk'
                ? 'Пошук у матеріалах курсів'
                : 'Search course content',
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }

  testIosWidgets(
    'iOS Calendar tab selects Calendar and nested course state survives',
    (tester) async {
      await launch(tester, size: const Size(520, 844));
      expect(find.widgetWithText(ActionChip, 'Calendar'), findsNothing);
      await tester.tap(tab('Calendar'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        tester
            .widget<CupertinoTabBar>(find.byType(CupertinoTabBar))
            .currentIndex,
        2,
      );
      final selector = find.byType(SegmentedButton<int>);
      final list = find
          .ancestor(of: selector, matching: find.byType(ListView))
          .first;
      expect(
        tester.getCenter(selector).dx,
        closeTo(tester.getCenter(list).dx, 0.5),
      );
      final router = GoRouter.of(tester.element(find.byType(CupertinoTabBar)));
      const coursePath = '/courses/019a0acf-0000-7000-8000-000000000001';
      router.go(coursePath);
      await tester.pumpAndSettle();
      await tester.tap(tab('Notifications'));
      await tester.pumpAndSettle();
      await tester.tap(tab('My courses'));
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, coursePath);
      expect(find.text('Creative thinking / Творче мислення'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}

void testIosWidgets(
  String description,
  Future<void> Function(WidgetTester) body,
) {
  testWidgets(
    description,
    body,
    variant: TargetPlatformVariant({TargetPlatform.iOS}),
  );
}
