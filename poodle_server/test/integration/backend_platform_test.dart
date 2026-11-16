import 'dart:convert';
import 'dart:io';

import 'package:serverpod/protocol.dart' show ReadWriteTestEntry;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Backend platform',
    (sessionBuilder, endpoints) {
      late Session session;

      setUp(() {
        session = sessionBuilder.build();
        addTearDown(() => session.close());
      });

      test(
        'connects to isolated PostgreSQL using the test configuration',
        () async {
          final result = await session.db.unsafeQuery(
            'SELECT current_database()',
          );
          final database = session.serverpod.config.database!;

          expect(database, isA<PostgresDatabaseConfig>());
          expect(result.single.single, database.name);
          expect(database.name, isNot(anyOf('poodle', 'poodle_test')));
          expect(database.port, 9090);
          expect((database as PostgresDatabaseConfig).dataPath, isNotEmpty);
        },
      );

      test(
        'applies the latest project and installed auth migrations',
        () async {
          final versions = File('migrations/migration_registry.txt')
              .readAsLinesSync()
              .map((line) => line.trim())
              .where((line) => line.isNotEmpty && !line.startsWith('#'));
          final latest = versions.last;
          final definition =
              jsonDecode(
                    File(
                      'migrations/$latest/definition_project.json',
                    ).readAsStringSync(),
                  )
                  as Map<String, dynamic>;
          final expected = <String, String>{
            definition['moduleName'] as String: latest,
            for (final module
                in definition['installedModules'] as List<dynamic>)
              module['module'] as String: module['version'] as String,
          };
          final result = await session.db.unsafeQuery(
            'SELECT module, version FROM serverpod_migrations',
          );
          final installed = {
            for (final row in result) row[0] as String: row[1] as String,
          };

          expect(installed, containsPair('serverpod_auth_core', isNotEmpty));
          expect(installed, containsPair('serverpod_auth_idp', isNotEmpty));
          expect(installed, containsPair('poodle', latest));
          for (final module in expected.entries) {
            expect(installed, containsPair(module.key, module.value));
          }

          final tables = await session.db.unsafeQuery('''
        SELECT to_regclass('serverpod_auth_core_user')::text,
               to_regclass('serverpod_auth_idp_email_account')::text,
               to_regclass('serverpod_auth_core_jwt_refresh_token')::text
      ''');
          expect(tables.single, everyElement(isNotNull));
        },
      );

      test('persists ORM writes and updates across Serverpod sessions', () async {
        // Reuse Serverpod's built-in connection test table; no domain schema is
        // needed. Automatic rollback is disabled to verify actual committed writes.
        final inserted = await ReadWriteTestEntry.db.insertRow(
          session,
          ReadWriteTestEntry(number: 42),
        );
        addTearDown(() async {
          await ReadWriteTestEntry.db.deleteRow(session, inserted);
        });
        final reader = sessionBuilder.build();
        addTearDown(() => reader.close());

        final stored = await ReadWriteTestEntry.db.findById(
          reader,
          inserted.id!,
        );
        expect(stored?.number, 42);

        await ReadWriteTestEntry.db.updateRow(
          session,
          inserted.copyWith(number: 43),
        );
        final updated = await ReadWriteTestEntry.db.findById(
          reader,
          inserted.id!,
        );
        expect(updated?.number, 43);
      });

      test('round-trips UTC timestamps with microsecond precision', () async {
        final instant = DateTime.parse('2026-10-22T12:34:56.123456+03:00');
        final result = await session.db.unsafeQuery(
          'SELECT CAST(@instant AS timestamptz)',
          parameters: QueryParameters.named({'instant': instant}),
        );
        final stored = result.single.single as DateTime;

        expect(stored, instant.toUtc());
        expect(stored.isUtc, isTrue);
      });

      test(
        'rolls back a failed transaction and keeps the session usable',
        () async {
          int? rolledBackId;

          await expectLater(
            session.db.transaction((transaction) async {
              final entry = await ReadWriteTestEntry.db.insertRow(
                session,
                ReadWriteTestEntry(number: 99),
                transaction: transaction,
              );
              rolledBackId = entry.id;
              await session.db.unsafeQuery(
                'SELECT 1 / 0',
                transaction: transaction,
              );
            }),
            throwsA(
              isA<DatabaseQueryException>().having(
                (error) => error.code,
                'PostgreSQL division-by-zero code',
                '22012',
              ),
            ),
          );

          expect(rolledBackId, isNotNull);
          expect(
            await ReadWriteTestEntry.db.findById(session, rolledBackId!),
            isNull,
          );
          final recovered = await session.db.unsafeQuery('SELECT 1');
          expect(recovered.single.single, 1);
        },
      );
    },
    ephemeralDatabase: true,
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
