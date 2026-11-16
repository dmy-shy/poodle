import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/account_notebook_cache.dart';

void main() {
  test(
    'notebook records reopen only for the matching server and account',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'poodle-notebook-cache-',
      );
      addTearDown(() => root.delete(recursive: true));
      final cache = AccountNotebookCache(root: root, namespace: 'server-a');
      final time = DateTime.utc(2026, 11, 12);
      await cache.write('alice', 'notebook:one', {
        'title': 'Private notes',
      }, time);
      final reopened = AccountNotebookCache(root: root, namespace: 'server-a');
      expect(
        (await reopened.read('alice', 'notebook:one'))?.value['title'],
        'Private notes',
      );
      expect((await reopened.read('alice', 'notebook:one'))?.refreshedAt, time);
      expect(await reopened.read('bob', 'notebook:one'), isNull);
      expect(
        await AccountNotebookCache(
          root: root,
          namespace: 'server-b',
        ).read('alice', 'notebook:one'),
        isNull,
      );
      await reopened.purge('alice');
      expect(await cache.read('alice', 'notebook:one'), isNull);
    },
  );
}
