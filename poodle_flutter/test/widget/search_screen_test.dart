import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_client/poodle_client.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/repositories/search_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';

class _SearchFixture extends PreviewSearchRepository {
  final queries = <String>[];
  final kinds = <String?>[];
  bool empty = false;
  @override
  Future<SearchResponse> search(
    String query, {
    String? courseId,
    String? kind,
  }) async {
    queries.add(query);
    kinds.add(kind);
    final id = UuidValue.withValidation('019a0acf-0000-7000-8000-000000000001');
    return SearchResponse(
      results: empty
          ? []
          : [
              SearchHit(
                targetId: id,
                courseId: id,
                kind: 'course',
                title: 'Структури даних',
                breadcrumb: '',
                excerpt: 'Алгоритми і дерева',
                draft: false,
              ),
            ],
      keywordOnly: true,
      incomplete: false,
      capped: false,
    );
  }
}

void main() {
  testWidgets(
    'header opens search, submits Ukrainian and retains results on Back',
    (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final auth = FakeAuthRepository(
        latency: Duration.zero,
        restoredSession: const AuthSession('student@example.com'),
      );
      final onboarding = OnboardingRepository(
        MemoryOnboardingStore(completed: true),
      );
      final search = _SearchFixture();
      addTearDown(auth.dispose);
      addTearDown(onboarding.dispose);
      await tester.pumpWidget(
        PoodleApp(
          repository: auth,
          onboardingRepository: onboarding,
          dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
          searchRepository: search,
          minimumSplashDuration: Duration.zero,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('header-search')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'бінарне дерево');
      await tester.pump();
      expect(search.queries, isEmpty);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(search.queries, ['бінарне дерево']);
      expect(find.text('Структури даних'), findsOneWidget);
      await tester.tap(find.text('Структури даних'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Структури даних'), findsOneWidget);
      await tester.tap(find.byTooltip('Clear query'));
      await tester.pumpAndSettle();
      expect(find.text('бінарне дерево'), findsOneWidget);
      await tester.tap(find.byTooltip('Remove recent search: бінарне дерево'));
      await tester.pumpAndSettle();
      expect(find.text('No recent searches. Try to search.'), findsOneWidget);
    },
    variant: const TargetPlatformVariant({TargetPlatform.android}),
  );

  testWidgets('filters, empty results, and invalid input', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('student@example.com'),
    );
    final onboarding = OnboardingRepository(
      MemoryOnboardingStore(completed: true),
    );
    final search = _SearchFixture()..empty = true;
    addTearDown(auth.dispose);
    addTearDown(onboarding.dispose);
    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        onboardingRepository: onboarding,
        dashboardRepository: FakeDashboardRepository(latency: Duration.zero),
        searchRepository: search,
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('header-search')));
    await tester.pumpAndSettle();
    expect(find.text('No recent searches. Try to search.'), findsOneWidget);
    expect(find.text('Recent searches'), findsNothing);
    final emptyIcon = find.byIcon(Icons.history);
    expect(tester.getCenter(emptyIcon).dy, greaterThan(400));
    expect(
      tester.widget<Icon>(emptyIcon).color,
      Theme.of(tester.element(emptyIcon)).colorScheme.primary,
    );
    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Courses').last);
    await tester.pumpAndSettle();
    expect(search.queries, isEmpty);
    expect(search.kinds, isEmpty);
    await tester.tapAt(const Offset(390, 400));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  English \n lesson  ');
    await tester.tap(find.byTooltip('Search').last);
    await tester.pumpAndSettle();
    expect(search.queries, ['English lesson']);
    expect(search.kinds, ['course']);
    expect(find.text('No results found'), findsOneWidget);
    expect(find.text('Recent searches'), findsNothing);
    await tester.tap(find.text('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('Recent searches'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'bad\u0000input');
    await tester.tap(find.byTooltip('Search').last);
    await tester.pumpAndSettle();
    expect(search.queries, hasLength(1));
    expect(find.textContaining('control characters'), findsOneWidget);
  }, variant: const TargetPlatformVariant({TargetPlatform.android}));
}
