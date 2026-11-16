import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/services/sync_coordinator.dart';

void main() {
  test(
    'concurrent refreshes share work and preserve partial results',
    () async {
      final gate = Completer<void>();
      var courseReads = 0;
      final sync = SyncCoordinator({
        SyncArea.courses: () async {
          courseReads++;
          await gate.future;
          return true;
        },
        SyncArea.notifications: () async => false,
      });
      sync.bindAccount('alice');
      final first = sync.refresh();
      final second = sync.refresh();
      gate.complete();
      await Future.wait([first, second]);
      expect(courseReads, 1);
      expect(sync.status(SyncArea.courses).state, SyncState.current);
      expect(sync.status(SyncArea.notifications).state, SyncState.cached);
      sync.dispose();
    },
  );

  test('late results after account change cannot update new session', () async {
    final gate = Completer<void>();
    final sync = SyncCoordinator({
      SyncArea.courses: () async {
        await gate.future;
        return true;
      },
    });
    sync.bindAccount('alice');
    final pending = sync.refresh();
    sync.bindAccount('bob');
    gate.complete();
    await pending;
    expect(sync.status(SyncArea.courses).state, SyncState.never);
    sync.dispose();
  });
}
