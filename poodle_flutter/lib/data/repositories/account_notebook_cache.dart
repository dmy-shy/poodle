import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_async/sqlite_async.dart';

class NotebookCacheSnapshot {
  const NotebookCacheSnapshot(this.value, this.refreshedAt);
  final Map<String, dynamic> value;
  final DateTime refreshedAt;
}

/// Read-only offline records, separated by Serverpod server and account.
class AccountNotebookCache {
  AccountNotebookCache({this.root, required this.namespace});
  final Directory? root;
  final String namespace;

  Future<File> _file(String account) async {
    final base =
        root ??
        Directory(
          '${(await getApplicationSupportDirectory()).path}/poodle-offline',
        );
    final name = sha256.convert(utf8.encode('$namespace:$account:notebook'));
    return File('${base.path}/$name.sqlite');
  }

  Future<SqliteDatabase> _open(String account) async {
    final file = await _file(account);
    await file.parent.create(recursive: true);
    final db = SqliteDatabase(path: file.path);
    await db.execute(
      'CREATE TABLE IF NOT EXISTS records (key TEXT PRIMARY KEY, payload TEXT NOT NULL, refreshed_at TEXT NOT NULL)',
    );
    return db;
  }

  Future<NotebookCacheSnapshot?> read(String account, String key) async {
    final file = await _file(account);
    if (!await file.exists()) return null;
    final db = await _open(account);
    try {
      final rows = await db.getAll(
        'SELECT payload, refreshed_at FROM records WHERE key = ?',
        [key],
      );
      if (rows.isEmpty) return null;
      try {
        return NotebookCacheSnapshot(
          jsonDecode(rows.single['payload'] as String) as Map<String, dynamic>,
          DateTime.parse(rows.single['refreshed_at'] as String),
        );
      } catch (_) {
        await db.execute('DELETE FROM records WHERE key = ?', [key]);
        return null;
      }
    } finally {
      await db.close();
    }
  }

  Future<void> write(
    String account,
    String key,
    Map<String, dynamic> value,
    DateTime refreshedAt,
  ) async {
    final db = await _open(account);
    try {
      await db.execute(
        'INSERT OR REPLACE INTO records (key, payload, refreshed_at) VALUES (?, ?, ?)',
        [key, jsonEncode(value), refreshedAt.toUtc().toIso8601String()],
      );
    } finally {
      await db.close();
    }
  }

  Future<void> remove(String account, String key) async {
    final file = await _file(account);
    if (!await file.exists()) return;
    final db = await _open(account);
    try {
      await db.execute('DELETE FROM records WHERE key = ?', [key]);
    } finally {
      await db.close();
    }
  }

  Future<void> purge(String account) async {
    final file = await _file(account);
    for (final suffix in ['', '-wal', '-shm']) {
      final target = File('${file.path}$suffix');
      if (await target.exists()) await target.delete();
    }
  }
}
