import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/dashboard_repository.dart';
import 'package:poodle_flutter/features/dashboard/presentation/view_models/dashboard_view_model.dart';

void main() {
  test('repeated refresh coalesces and failure keeps prior content', () async {
    final repository = _ControlledRepository();
    final model = DashboardViewModel(repository);
    repository.initial.complete(
      await FakeDashboardRepository(clock: () => DateTime.utc(2026)).load(),
    );
    await model.load();
    final first = model.refresh();
    final second = model.refresh();
    expect(repository.refreshCount, 1);
    repository.pending.completeError(DashboardLoadException());
    await Future.wait([first, second]);
    expect(model.state.snapshot, isNotNull);
    expect(model.state.refreshError, isTrue);
    expect(model.state.busy, isFalse);
    model.dispose();
  });

  test('disposed workflow ignores a late load result', () async {
    final repository = _ControlledRepository();
    final model = DashboardViewModel(repository);
    final load = model.load();
    model.dispose();
    repository.initial.complete(
      await FakeDashboardRepository(clock: () => DateTime.utc(2026)).load(),
    );
    await load;
    expect(model.state.snapshot, isNull);
  });
}

class _ControlledRepository implements DashboardRepository {
  final initial = Completer<DashboardSnapshot>();
  final pending = Completer<DashboardSnapshot>();
  int refreshCount = 0;

  @override
  DashboardSnapshot? get currentSnapshot => null;

  @override
  void clear() {}

  @override
  Future<DashboardSnapshot> load() => initial.future;

  @override
  Future<DashboardSnapshot> refresh() {
    refreshCount++;
    return pending.future;
  }
}
