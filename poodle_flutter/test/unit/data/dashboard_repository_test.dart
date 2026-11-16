import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';

void main() {
  final now = DateTime.utc(2026, 10, 20, 12);

  test(
    'normal fixture orders sections and keeps timestamps stable on refresh',
    () async {
      final repository = FakeDashboardRepository(clock: () => now);
      final first = await repository.load();
      final second = await repository.load();
      expect(
        first.tasks.first.dueAtUtc.isBefore(first.tasks.last.dueAtUtc),
        isTrue,
      );
      expect(
        first.courses.first.lastAccessUtc.isAfter(
          first.courses.last.lastAccessUtc,
        ),
        isTrue,
      );
      expect(
        first.announcements.first.publishedAtUtc.isAfter(
          first.announcements.last.publishedAtUtc,
        ),
        isTrue,
      );
      expect(second.tasks.first.dueAtUtc, first.tasks.first.dueAtUtc);
      expect(first.courses.any((course) => course.progress == null), isTrue);
    },
  );

  test('failure retries into content and empty scenario has no rows', () async {
    final failure = FakeDashboardRepository(
      scenario: DashboardPreviewScenario.loadFailure,
      clock: () => now,
    );
    await expectLater(failure.load(), throwsA(isA<DashboardLoadException>()));
    expect((await failure.load()).tasks, isNotEmpty);
    final empty = FakeDashboardRepository(
      scenario: DashboardPreviewScenario.empty,
      clock: () => now,
    );
    expect((await empty.load()).tasks, isEmpty);
  });

  test('clear invalidates a pending load before another session', () async {
    final repository = FakeDashboardRepository(
      clock: () => now,
      latency: const Duration(milliseconds: 10),
    );
    final pending = repository.load();
    repository.clear();
    await expectLater(pending, throwsA(isA<DashboardLoadException>()));
    expect((await repository.load()).tasks, isNotEmpty);
  });

  test('offline keeps sample data and rejects refresh', () async {
    final repository = FakeDashboardRepository(
      scenario: DashboardPreviewScenario.offline,
      clock: () => now,
    );
    final snapshot = await repository.load();
    expect(snapshot.stale, isTrue);
    await expectLater(
      repository.refresh(),
      throwsA(isA<DashboardOfflineException>()),
    );
    expect(snapshot.tasks, isNotEmpty);
  });
}
