enum DashboardPreviewScenario { normal, empty, loadFailure, offline }

DashboardPreviewScenario parseDashboardPreviewScenario(String value) =>
    DashboardPreviewScenario.values.firstWhere(
      (scenario) => scenario.name == value,
      orElse: () => throw ArgumentError.value(
        value,
        'DASHBOARD_PREVIEW_SCENARIO',
        'Unknown preview scenario',
      ),
    );

class DashboardLoadException implements Exception {}

class DashboardOfflineException implements Exception {}

class DashboardTask {
  const DashboardTask(this.id, this.courseId, this.dueAtUtc);
  final String id;
  final String courseId;
  final DateTime dueAtUtc;
}

class DashboardCourse {
  const DashboardCourse(this.id, this.lastAccessUtc, this.progress);
  final String id;
  final DateTime lastAccessUtc;

  /// Null means no required activities.
  final int? progress;
}

class DashboardAnnouncement {
  const DashboardAnnouncement(
    this.id,
    this.courseId,
    this.publishedAtUtc,
    this.unread,
  );
  final String id;
  final String courseId;
  final DateTime publishedAtUtc;
  final bool unread;
}

class DashboardSnapshot {
  DashboardSnapshot({
    required List<DashboardTask> tasks,
    required List<DashboardCourse> courses,
    required List<DashboardAnnouncement> announcements,
    required this.referenceAtUtc,
    required this.updatedAtUtc,
    this.stale = false,
  }) : tasks = List.unmodifiable(tasks),
       courses = List.unmodifiable(courses),
       announcements = List.unmodifiable(announcements);

  final List<DashboardTask> tasks;
  final List<DashboardCourse> courses;
  final List<DashboardAnnouncement> announcements;
  final DateTime referenceAtUtc;
  final DateTime updatedAtUtc;
  final bool stale;
}

abstract class DashboardRepository {
  DashboardSnapshot? get currentSnapshot;
  Future<DashboardSnapshot> load();
  Future<DashboardSnapshot> refresh();
  void clear();
}

/// Local sample content. No account records or network requests are made.
class FakeDashboardRepository implements DashboardRepository {
  FakeDashboardRepository({
    this.scenario = DashboardPreviewScenario.normal,
    DateTime Function()? clock,
    this.latency = const Duration(milliseconds: 300),
  }) : _clock = clock ?? DateTime.now;

  final DashboardPreviewScenario scenario;
  final DateTime Function() _clock;
  final Duration latency;
  DashboardSnapshot? _snapshot;
  @override
  DashboardSnapshot? get currentSnapshot => _snapshot;
  bool _failedOnce = false;
  int _generation = 0;

  @override
  Future<DashboardSnapshot> load() async {
    final generation = _generation;
    await Future<void>.delayed(latency);
    if (generation != _generation) throw DashboardLoadException();
    if (scenario == DashboardPreviewScenario.loadFailure && !_failedOnce) {
      _failedOnce = true;
      throw DashboardLoadException();
    }
    return _snapshot ??= _makeSnapshot();
  }

  @override
  Future<DashboardSnapshot> refresh() async {
    final generation = _generation;
    await Future<void>.delayed(latency);
    if (generation != _generation) throw DashboardLoadException();
    if (scenario == DashboardPreviewScenario.offline) {
      throw DashboardOfflineException();
    }
    return _snapshot ??= _makeSnapshot();
  }

  @override
  void clear() {
    _generation++;
    _snapshot = null;
    _failedOnce = false;
  }

  DashboardSnapshot _makeSnapshot() {
    final now = _clock().toUtc();
    if (scenario == DashboardPreviewScenario.empty) {
      return DashboardSnapshot(
        tasks: const [],
        courses: const [],
        announcements: const [],
        referenceAtUtc: now,
        updatedAtUtc: now,
      );
    }
    final tasks =
        [
          DashboardTask(
            'task-reading',
            '019a0acf-0000-7000-8000-000000000001',
            now.add(const Duration(days: 2)),
          ),
          DashboardTask(
            'task-reflection',
            '019a0acf-0000-7000-8000-000000000002',
            now.subtract(const Duration(hours: 8)),
          ),
        ]..sort((a, b) {
          final result = a.dueAtUtc.compareTo(b.dueAtUtc);
          return result != 0 ? result : a.id.compareTo(b.id);
        });
    final courses =
        [
          DashboardCourse(
            '019a0acf-0000-7000-8000-000000000002',
            now.subtract(const Duration(days: 2)),
            null,
          ),
          DashboardCourse(
            '019a0acf-0000-7000-8000-000000000001',
            now.subtract(const Duration(hours: 2)),
            60,
          ),
        ]..sort((a, b) {
          final result = b.lastAccessUtc.compareTo(a.lastAccessUtc);
          return result != 0 ? result : a.id.compareTo(b.id);
        });
    final announcements =
        [
          DashboardAnnouncement(
            'announcement-welcome',
            '019a0acf-0000-7000-8000-000000000002',
            now.subtract(const Duration(days: 3)),
            false,
          ),
          DashboardAnnouncement(
            'announcement-week',
            '019a0acf-0000-7000-8000-000000000001',
            now.subtract(const Duration(hours: 4)),
            true,
          ),
        ]..sort((a, b) {
          final result = b.publishedAtUtc.compareTo(a.publishedAtUtc);
          return result != 0 ? result : a.id.compareTo(b.id);
        });
    return DashboardSnapshot(
      tasks: tasks,
      courses: courses,
      announcements: announcements,
      referenceAtUtc: now,
      updatedAtUtc: now.subtract(const Duration(minutes: 10)),
      stale: scenario == DashboardPreviewScenario.offline,
    );
  }
}
