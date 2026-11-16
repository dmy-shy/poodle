import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_async/sqlite_async.dart';

import '../../domain/models/course.dart';

class CourseListCacheSnapshot {
  const CourseListCacheSnapshot(this.courses, this.refreshedAt);
  final List<CourseInfo> courses;
  final DateTime refreshedAt;
}

class CourseContentCacheSnapshot {
  const CourseContentCacheSnapshot(this.content, this.refreshedAt);
  final CourseContent content;
  final DateTime refreshedAt;
}

/// Durable, account and server scoped read cache. No credentials are stored here.
class AccountCourseCache {
  AccountCourseCache({this.root, required this.namespace});
  final Directory? root;
  final String namespace;

  Future<File> _file(String account) async {
    final base =
        root ??
        Directory(
          '${(await getApplicationSupportDirectory()).path}/poodle-offline',
        );
    final name = sha256.convert(utf8.encode('$namespace:$account'));
    return File('${base.path}/$name.sqlite');
  }

  Future<SqliteDatabase> _open(String account) async {
    final file = await _file(account);
    await file.parent.create(recursive: true);
    final db = SqliteDatabase(path: file.path);
    await db.execute(
      'CREATE TABLE IF NOT EXISTS course_list (id TEXT PRIMARY KEY, title TEXT NOT NULL, category TEXT, summary TEXT, teacher TEXT, sample INTEGER NOT NULL, starred INTEGER NOT NULL, hidden INTEGER NOT NULL)',
    );
    await db.execute(
      'CREATE TABLE IF NOT EXISTS refresh_state (scope TEXT PRIMARY KEY, refreshed_at TEXT NOT NULL)',
    );
    await db.execute(
      'CREATE TABLE IF NOT EXISTS course_detail (course_id TEXT PRIMARY KEY, payload TEXT NOT NULL, refreshed_at TEXT NOT NULL)',
    );
    await db.writeTransaction((tx) async {
      final columns = await tx.getAll('PRAGMA table_info(course_list)');
      if (!columns.any((c) => c['name'] == 'role')) {
        await tx.execute('ALTER TABLE course_list ADD COLUMN role TEXT');
      }
    });
    return db;
  }

  Future<CourseListCacheSnapshot?> read(String account) async {
    final file = await _file(account);
    if (!await file.exists()) return null;
    final db = await _open(account);
    try {
      final stamp = await db.getAll(
        'SELECT refreshed_at FROM refresh_state WHERE scope = ?',
        ['courses'],
      );
      if (stamp.isEmpty) return null;
      final rows = await db.getAll(
        'SELECT id, title, category, summary, teacher, sample, starred, hidden, role FROM course_list ORDER BY title, id',
      );
      return CourseListCacheSnapshot([
        for (final row in rows)
          CourseInfo(
            id: row['id'] as String,
            role: row['role'] as String?,
            title: row['title'] as String,
            category: row['category'] as String?,
            summary: row['summary'] as String?,
            teacherName: row['teacher'] as String?,
            sample: row['sample'] == 1,
            starred: row['starred'] == 1,
            hidden: row['hidden'] == 1,
          ),
      ], DateTime.parse(stamp.single['refreshed_at'] as String));
    } finally {
      await db.close();
    }
  }

  Future<void> write(
    String account,
    List<CourseInfo> courses,
    DateTime refreshedAt,
  ) async {
    final db = await _open(account);
    try {
      await db.writeTransaction((tx) async {
        await tx.execute('DELETE FROM course_list');
        for (final item in courses) {
          await tx.execute(
            'INSERT INTO course_list (id, title, category, summary, teacher, sample, starred, hidden, role) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [
              item.id,
              item.title,
              item.category,
              item.summary,
              item.teacherName,
              item.sample ? 1 : 0,
              item.starred ? 1 : 0,
              item.hidden ? 1 : 0,
              item.role,
            ],
          );
        }
        await tx.execute(
          'DELETE FROM course_detail WHERE course_id NOT IN (SELECT id FROM course_list)',
        );
        await tx.execute(
          'INSERT OR REPLACE INTO refresh_state (scope, refreshed_at) VALUES (?, ?)',
          ['courses', refreshedAt.toUtc().toIso8601String()],
        );
      });
    } finally {
      await db.close();
    }
  }

  Future<void> writeContent(
    String account,
    CourseContent content,
    DateTime refreshedAt,
  ) async {
    final db = await _open(account);
    try {
      await db.execute(
        'INSERT OR REPLACE INTO course_detail (course_id, payload, refreshed_at) VALUES (?, ?, ?)',
        [
          content.course.id,
          jsonEncode(_encodeContent(content)),
          refreshedAt.toUtc().toIso8601String(),
        ],
      );
    } finally {
      await db.close();
    }
  }

  Future<CourseContentCacheSnapshot?> readContent(
    String account,
    String id,
  ) async {
    final file = await _file(account);
    if (!await file.exists()) return null;
    final db = await _open(account);
    try {
      final rows = await db.getAll(
        'SELECT payload, refreshed_at FROM course_detail WHERE course_id = ?',
        [id],
      );
      if (rows.isEmpty) return null;
      try {
        final content = _decodeContent(
          jsonDecode(rows.single['payload'] as String) as Map<String, dynamic>,
        );
        if (content.course.id != id) return null;
        return CourseContentCacheSnapshot(
          content,
          DateTime.parse(rows.single['refreshed_at'] as String),
        );
      } catch (_) {
        await db.execute('DELETE FROM course_detail WHERE course_id = ?', [id]);
        return null;
      }
    } finally {
      await db.close();
    }
  }

  Future<void> removeContent(String account, String id) async {
    final file = await _file(account);
    if (!await file.exists()) return;
    final db = await _open(account);
    try {
      await db.execute('DELETE FROM course_detail WHERE course_id = ?', [id]);
    } finally {
      await db.close();
    }
  }

  Map<String, dynamic> _encodeContent(CourseContent value) => {
    'course': {
      'id': value.course.id,
      'title': value.course.title,
      'category': value.course.category,
      'summary': value.course.summary,
      'teacherName': value.course.teacherName,
      'role': value.course.role,
      'sample': value.course.sample,
      'starred': value.course.starred,
      'hidden': value.course.hidden,
    },
    'teacherView': value.teacherView,
    'serverTime': value.serverTime?.toIso8601String(),
    'sections': [
      for (final section in value.sections)
        {
          'id': section.id,
          'title': section.title,
          'description': section.description,
          'draft': section.draft,
          'activities': [
            for (final item in section.activities)
              {
                'id': item.id,
                'courseId': item.courseId,
                'title': item.title,
                'kind': item.kind.name,
                'description': item.description,
                'draft': item.draft,
                'managedAssessment': item.managedAssessment,
                'file': item.file == null
                    ? null
                    : {
                        'name': item.file!.name,
                        'mimeType': item.file!.mimeType,
                        'sizeBytes': item.file!.sizeBytes,
                        'checksum': item.file!.checksum,
                      },
                'url': item.url,
                'body': item.body,
                'author': item.author,
                'publishedAt': item.publishedAt?.toIso8601String(),
                'instructions': item.instructions,
                'opensAt': item.opensAt?.toIso8601String(),
                'closesAt': item.closesAt?.toIso8601String(),
                'attemptLimit': item.attemptLimit,
                'timeLimitMinutes': item.timeLimitMinutes,
                'availability': item.availability,
                'previousId': item.previousId,
                'nextId': item.nextId,
              },
          ],
        },
    ],
  };

  CourseContent _decodeContent(Map<String, dynamic> data) {
    final c = data['course'] as Map<String, dynamic>;
    return CourseContent(
      course: CourseInfo(
        id: c['id'] as String,
        role: c['role'] as String?,
        title: c['title'] as String,
        category: c['category'] as String?,
        summary: c['summary'] as String?,
        teacherName: c['teacherName'] as String?,
        sample: c['sample'] as bool? ?? false,
        starred: c['starred'] as bool? ?? false,
        hidden: c['hidden'] as bool? ?? false,
      ),
      teacherView: data['teacherView'] as bool? ?? false,
      serverTime: DateTime.tryParse(data['serverTime'] as String? ?? ''),
      sections: [
        for (final s in data['sections'] as List<dynamic>)
          ContentSection(
            id: s['id'] as String,
            title: s['title'] as String,
            description: s['description'] as String?,
            draft: s['draft'] as bool? ?? false,
            activities: [
              for (final a in s['activities'] as List<dynamic>)
                CourseActivity(
                  id: a['id'] as String,
                  courseId: a['courseId'] as String,
                  title: a['title'] as String,
                  kind: ActivityKind.values.byName(a['kind'] as String),
                  description: a['description'] as String?,
                  draft: a['draft'] as bool? ?? false,
                  managedAssessment: a['managedAssessment'] as bool? ?? false,
                  file: a['file'] == null
                      ? null
                      : CourseFile(
                          name: a['file']['name'] as String,
                          mimeType: a['file']['mimeType'] as String,
                          sizeBytes: a['file']['sizeBytes'] as int,
                          checksum: a['file']['checksum'] as String,
                        ),
                  url: a['url'] as String?,
                  body: a['body'] as String?,
                  author: a['author'] as String?,
                  publishedAt: DateTime.tryParse(
                    a['publishedAt'] as String? ?? '',
                  ),
                  instructions: a['instructions'] as String?,
                  opensAt: DateTime.tryParse(a['opensAt'] as String? ?? ''),
                  closesAt: DateTime.tryParse(a['closesAt'] as String? ?? ''),
                  attemptLimit: a['attemptLimit'] as int?,
                  timeLimitMinutes: a['timeLimitMinutes'] as int?,
                  availability: a['availability'] as String?,
                  previousId: a['previousId'] as String?,
                  nextId: a['nextId'] as String?,
                ),
            ],
          ),
      ],
    );
  }

  Future<void> purge(String account) async {
    final file = await _file(account);
    for (final suffix in ['', '-wal', '-shm']) {
      final target = File('${file.path}$suffix');
      if (await target.exists()) await target.delete();
    }
  }
}
