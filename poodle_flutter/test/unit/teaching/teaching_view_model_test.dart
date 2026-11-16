import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/teaching_repository.dart';
import 'package:poodle_flutter/features/teaching/presentation/view_models/teaching_view_model.dart';

class _Repository extends TeachingRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'session changes clear data and discard an in-flight response',
    () async {
      final repo = _Repository()..bindAccount('teacher');
      final pending = Completer<int>();
      final model = TeachingViewModel(repo, () => pending.future);
      final load = model.load();
      repo.bindAccount('student');
      pending.complete(42);
      await load;
      expect(model.value, isNull);
      expect(model.busy, isFalse);
      model.dispose();
      repo.dispose();
    },
  );
  test(
    'failed writes retain confirmed data and expose an actionable failure',
    () async {
      final repo = _Repository()..bindAccount('teacher');
      final model = TeachingViewModel(repo, () async => 1);
      await model.load();
      expect(
        await model.run(() async => throw const TeachingFailure('conflict')),
        isFalse,
      );
      expect(model.value, 1);
      expect(model.error, 'conflict');
      model.dispose();
      repo.dispose();
    },
  );
  test('disposed screens ignore delayed success', () async {
    final repo = _Repository()..bindAccount('teacher');
    final pending = Completer<int>();
    final model = TeachingViewModel(repo, () => pending.future);
    final load = model.load();
    model.dispose();
    pending.complete(7);
    await load;
    expect(model.value, isNull);
    repo.dispose();
  });
}
