import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/repositories/teaching_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';

class _Teaching extends TeachingRepository {
  @override
  Future<TeachingActivityView> activity(String course, String id) async =>
      throw const TeachingFailure('unavailable');
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('teacher home assignment work route opens its screen', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('teacher@example.com'),
    );
    final onboarding = OnboardingRepository(
      MemoryOnboardingStore(completed: true),
    );
    final teaching = _Teaching();
    addTearDown(auth.dispose);
    addTearDown(onboarding.dispose);
    addTearDown(teaching.dispose);
    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        onboardingRepository: onboarding,
        teachingRepository: teaching,
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go(
      '/home/course/019a0acf-0050-7000-8000-000000000001/activity/4afffbe8-9de6-4121-9de1-e4f1d096d405/work',
    );
    await tester.pumpAndSettle();
    expect(find.text('View work'), findsWidgets);
    expect(find.textContaining('GoException'), findsNothing);
  });

  testWidgets('unknown route shows friendly recovery without exception text', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      latency: Duration.zero,
      restoredSession: const AuthSession('teacher@example.com'),
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
        minimumSplashDuration: Duration.zero,
      ),
    );
    await tester.pumpAndSettle();
    GoRouter.of(
      tester.element(find.byType(Scaffold).first),
    ).go('/home/does-not-exist');
    await tester.pumpAndSettle();
    expect(find.text('Page not found'), findsOneWidget);
    expect(find.textContaining('GoException'), findsNothing);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Upcoming tasks'), findsOneWidget);
  });
}
