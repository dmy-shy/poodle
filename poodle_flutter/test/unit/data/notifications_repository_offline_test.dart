import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_client/poodle_client.dart' as api;
import 'package:poodle_flutter/data/repositories/account_notebook_cache.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/notifications_repository.dart';
import 'package:poodle_flutter/data/services/serverpod_auth_gateway.dart';
import 'package:poodle_flutter/data/services/session_credential_store.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class _Memory implements ClientAuthSuccessStorage {
  @override
  Future<AuthSuccess?> get() async => null;
  @override
  Future<void> set(AuthSuccess? data) async {}
}

void main() {
  const id = '019a0acf-0000-7000-8000-000000000001';
  test(
    'inbox remains readable but cannot mark read after network loss',
    () async {
      final root = await Directory.systemTemp.createTemp('poodle-inbox-cache-');
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        await utf8.decoder.bind(request).join();
        final body = switch (request.uri.path) {
          '/notifications/list' => [
            api.NotificationItem(
              id: api.UuidValue.withValidation(id),
              category: 'assignment',
              title: 'Due soon',
              createdAt: DateTime.utc(2026, 11, 12),
            ).toJson(),
          ],
          '/notifications/unreadCount' => 1,
          _ => null,
        };
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode(body));
        await request.response.close();
      });
      final gateway = ServerpodAuthGateway(
        'http://127.0.0.1:${server.port}/',
        SessionCredentialStore(_Memory()),
        monitorConnectivity: false,
      );
      final repo = ServerpodNotificationsRepository(
        gateway,
        cache: AccountNotebookCache(root: root, namespace: 'inbox-server'),
      )..bindAccount('alice');
      addTearDown(() async {
        gateway.dispose();
        await server.close(force: true);
        await root.delete(recursive: true);
      });
      final online = await repo.list(offset: 0, limit: 20);
      expect(online.single.title, 'Due soon');
      expect(await repo.unreadCount(), 1);
      await server.close(force: true);
      final offline = await repo.list(offset: 0, limit: 20);
      expect(offline.single.title, 'Due soon');
      expect(await repo.unreadCount(), 1);
      expect(repo.isStale, isTrue);
      await expectLater(repo.markRead(id), throwsA(AuthFailure.network));
      repo.bindAccount('bob');
      await expectLater(
        repo.list(offset: 0, limit: 20),
        throwsA(AuthFailure.network),
      );
    },
  );
}
