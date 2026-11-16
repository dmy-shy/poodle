import 'dart:async';
import 'package:flutter/material.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/app/poodle_app.dart';
import 'package:poodle_flutter/features/auth/presentation/views/splash_screen.dart';
import 'package:poodle_flutter/data/repositories/institution_repository.dart';
import 'package:poodle_flutter/data/repositories/onboarding_repository.dart';
import 'package:poodle_flutter/data/services/onboarding_store.dart';
import '../../support/live_auth_fixture.dart';

class Institutions extends InstitutionRepository {
  final reads = <String>[];
  @override
  Future<List<AdministratorRequest>> requests(int offset) async {
    reads.add('requests');
    return [];
  }

  @override
  Future<List<UniversityOption>> universities() async {
    reads.add('universities');
    return [];
  }

  @override
  Future<List<UniversityMember>> members(int offset) async {
    reads.add('members');
    return [];
  }

  @override
  Future<List<UniversityInvitation>> invitations(int offset) async {
    reads.add('invitations');
    return [];
  }

  @override
  Future<List<ManagedCourse>> courses() async {
    reads.add('courses');
    return [];
  }
}

class RestoringAuth extends LiveAuthFixture {
  final restored = Completer<void>();
  @override
  Future<AuthSession?> restoreSession() async {
    await restored.future;
    return super.restoreSession();
  }
}

void main() {
  for (final scenario in [
    (
      role: 'operator',
      session: const AuthSession('operator@example.test', isAdmin: true),
      path: '/more/university-requests',
      destination: '/more/university-requests',
      reads: ['requests', 'universities'],
    ),
    (
      role: 'university admin',
      session: const AuthSession(
        'admin@example.test',
        universityId: 'uni',
        isUniversityAdmin: true,
      ),
      path: '/more/university',
      destination: '/more/university',
      reads: ['members', 'invitations'],
    ),
    (
      role: 'university admin',
      session: const AuthSession(
        'admin@example.test',
        universityId: 'uni',
        isUniversityAdmin: true,
      ),
      path: '/more/university-requests',
      destination: '/profile',
      reads: <String>[],
    ),
    (
      role: 'teacher',
      session: const AuthSession(
        'teacher@example.test',
        universityId: 'uni',
        teacherApproved: true,
      ),
      path: '/more/teaching-courses',
      destination: '/more/teaching-courses',
      reads: ['courses'],
    ),
    (
      role: 'student',
      session: const AuthSession('student@example.test', universityId: 'uni'),
      path: '/more/university',
      destination: '/profile',
      reads: <String>[],
    ),
  ]) {
    testWidgets(
      '${scenario.role} navigation to ${scenario.path} respects account authority',
      (tester) async {
        final auth = LiveAuthFixture(restoredSession: scenario.session);
        addTearDown(auth.dispose);
        final institutions = Institutions();
        await tester.pumpWidget(
          PoodleApp(
            repository: auth,
            institutionRepository: institutions,
            minimumSplashDuration: Duration.zero,
            onboardingRepository: OnboardingRepository(
              MemoryOnboardingStore(completed: true),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final router = GoRouter.of(
          tester.element(find.byKey(const ValueKey('account-menu'))),
        );
        router.go(scenario.path);
        await tester.pumpAndSettle();
        expect(
          router.routeInformationProvider.value.uri.path,
          scenario.destination,
        );
        expect(institutions.reads, scenario.reads);
      },
    );
  }

  testWidgets('signed-out administrator opens university request from login', (
    tester,
  ) async {
    final auth = LiveAuthFixture();
    addTearDown(auth.dispose);
    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        institutionRepository: Institutions(),
        minimumSplashDuration: Duration.zero,
        onboardingRepository: OnboardingRepository(
          MemoryOnboardingStore(completed: true),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Join by invitation'), findsNothing);
    await tester.ensureVisible(find.text('Contact us'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contact us'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'University access'), findsOneWidget);
    expect(find.byKey(const ValueKey('request-university')), findsOneWidget);
    final router = GoRouter.of(
      tester.element(find.byKey(const ValueKey('request-university'))),
    );
    router.go('/join?email=invited%40example.test');
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('verification-email')))
          .controller
          ?.text,
      'invited@example.test',
    );
  });
  testWidgets('invitation link survives splash on a fresh installation', (
    tester,
  ) async {
    final auth = RestoringAuth();
    addTearDown(auth.dispose);
    await tester.pumpWidget(
      PoodleApp(
        repository: auth,
        institutionRepository: Institutions(),
        minimumSplashDuration: Duration.zero,
        onboardingRepository: OnboardingRepository(MemoryOnboardingStore()),
      ),
    );
    await tester.pump();
    final router = GoRouter.of(tester.element(find.byType(SplashScreen)));
    router.go('/join?email=founder%40example.test');
    await tester.pump();
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);
    auth.restored.complete();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('verification-email')), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('verification-email')))
          .controller
          ?.text,
      'founder@example.test',
    );
  });
}
