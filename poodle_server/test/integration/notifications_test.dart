import 'package:poodle_server/src/modules/notifications/notification_service.dart';
import 'dart:convert';
import 'dart:io';
import 'package:poodle_server/src/auth/identity_auth_config.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/server.dart' show ServerInternalMethods;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Notification account boundaries', (builder, endpoints) {
    late Session session;
    var sequence = 0;
    setUp(() {
      session = builder.build();
      addTearDown(session.close);
      session.serverpod.initializeAuthServices(
        tokenManagerBuilders: [
          JwtConfig(
            algorithm: JwtAlgorithm.hmacSha512(
              SecretKey('course-test-signing-key'),
            ),
            refreshTokenHashPepper: 'course-test-refresh-pepper',
            issuer: 'poodle',
          ),
        ],
        identityProviderBuilders: [
          identityEmailConfig(
            pepper: 'course-test-email-pepper',
            runMode: ServerpodRunMode.test,
          ),
        ],
      );
      session.serverpod.server.setAuthenticationHandlerForTesting(
        AuthServices.instance.authenticationHandler,
      );
    });
    Future<(int, dynamic)> request(
      String endpoint,
      String method,
      Map<String, dynamic> body, {
      String? token,
    }) async {
      final client = HttpClient();
      try {
        final request = await client.postUrl(
          Uri.parse(
            'http://localhost:${session.serverpod.server.port}/$endpoint/$method',
          ),
        );
        request.headers.contentType = ContentType.json;
        if (token != null) {
          request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
        }
        request.write(jsonEncode(body));
        final response = await request.close();
        final text = await utf8.decoder.bind(response).join();
        if (text.isEmpty) return (response.statusCode, null);
        try {
          return (response.statusCode, jsonDecode(text));
        } on FormatException {
          // Parameter parsing can fail before Serverpod's JSON response layer.
          if (response.statusCode < 400) rethrow;
          return (response.statusCode, text);
        }
      } finally {
        client.close(force: true);
      }
    }

    Future<(UuidValue, String)> account({
      bool admin = false,
      bool bootstrap = false,
    }) async {
      final email =
          'course-${DateTime.now().microsecondsSinceEpoch}-${sequence++}@example.test';
      final user = await AuthServices.instance.authUsers.create(session);
      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: user.id,
        email: email,
        password: 'Course-password-123',
      );
      await AccountAccess.db.insertRow(
        session,
        AccountAccess(
          authUserId: user.id,
          isAdmin: admin,
          developmentBootstrap: bootstrap,
        ),
      );
      final response = await request('emailIdp', 'login', {
        'email': email,
        'password': 'Course-password-123',
      });
      expect(response.$1, 200);
      return (
        user.id,
        AuthSuccess.fromJson(Map<String, dynamic>.from(response.$2)).token,
      );
    }

    test(
      'registration rotates tokens and protects new account leases',
      () async {
        final alice = await account();
        final bob = await account();
        final installation = const Uuid().v4obj().toString();
        Future<String> register(
          String bearer,
          String deviceToken, {
          String? device,
        }) async {
          final result = await request('pushDevices', 'register', {
            'installationId': device ?? installation,
            'platform': 'ios',
            'token': deviceToken,
          }, token: bearer);
          expect(result.$1, 200);
          return result.$2 as String;
        }

        Future<void> unregister(String bearer, String lease) async {
          final result = await request('pushDevices', 'unregister', {
            'registrationId': lease,
          }, token: bearer);
          expect(result.$1, 200);
        }

        final oldLease = await register(alice.$2, 'fake-token-1');
        final rotated = await register(alice.$2, 'fake-token-2');
        await unregister(alice.$2, oldLease);
        expect(await PushDeviceRecord.db.count(session), 1);
        expect(
          (await PushDeviceRecord.db.find(session)).single.token,
          'fake-token-2',
        );
        final bobLease = await register(bob.$2, 'fake-token-2');
        await unregister(alice.$2, rotated);
        await unregister(alice.$2, bobLease);
        final bound = (await PushDeviceRecord.db.find(session)).single;
        expect(bound.ownerId, bob.$1);
        expect(bound.registrationId.toString(), bobLease);
        // Provider tokens remain unique even if an installation ID changes.
        final replaced = await register(
          bob.$2,
          'fake-token-2',
          device: const Uuid().v4obj().toString(),
        );
        expect(await PushDeviceRecord.db.count(session), 1);
        await unregister(bob.$2, bobLease);
        expect(await PushDeviceRecord.db.count(session), 1);
        await unregister(bob.$2, replaced);
        await unregister(bob.$2, replaced);
        expect(await PushDeviceRecord.db.count(session), 0);
      },
    );

    test('concurrent registration retains one installation binding', () async {
      final user = await account();
      final installation = const Uuid().v4obj().toString();
      final results = await Future.wait([
        for (final value in ['concurrent-token-1', 'concurrent-token-2'])
          request('pushDevices', 'register', {
            'installationId': installation,
            'platform': 'android',
            'token': value,
          }, token: user.$2),
      ]);
      expect(results.map((r) => r.$1), everyElement(200));
      final rows = await PushDeviceRecord.db.find(
        session,
        where: (t) =>
            t.installationId.equals(UuidValue.withValidation(installation)),
      );
      expect(rows, hasLength(1));
      expect(
        results.map((r) => r.$2),
        contains(rows.single.registrationId.toString()),
      );
      await request('pushDevices', 'unregister', {
        'registrationId': rows.single.registrationId.toString(),
      }, token: user.$2);
    });

    test(
      'notification persistence rolls back with the originating event',
      () async {
        final user = await account();
        await expectLater(
          session.db.transaction((tx) async {
            await NotificationService().forUser(
              session,
              tx,
              recipientId: user.$1,
              eventKey: 'rolled-back',
              category: 'grade',
              title: 'Uncommitted',
            );
            throw StateError('Originating event failed');
          }),
          throwsStateError,
        );
        expect(
          await NotificationRecord.db.count(
            session,
            where: (t) => t.recipientId.equals(user.$1),
          ),
          0,
        );
      },
    );

    test(
      'registration rejects anonymous, invalid and revoked accounts',
      () async {
        final user = await account();
        final valid = {
          'installationId': const Uuid().v4obj().toString(),
          'platform': 'android',
          'token': 'fake-token',
        };
        expect(
          (await request('pushDevices', 'register', valid)).$1,
          isNot(200),
        );
        for (final invalid in [
          {...valid, 'platform': 'web'},
          {...valid, 'token': ''},
          {...valid, 'token': 'has whitespace'},
          {...valid, 'token': List.filled(4097, 'x').join()},
        ]) {
          expect(
            (await request(
              'pushDevices',
              'register',
              invalid,
              token: user.$2,
            )).$1,
            isNot(200),
          );
        }
        await AuthServices.instance.authUsers.update(
          session,
          authUserId: user.$1,
          blocked: true,
        );
        expect(
          (await request('pushDevices', 'register', valid, token: user.$2)).$1,
          isNot(200),
        );
        expect(await PushDeviceRecord.db.count(session), 0);
      },
    );

    test(
      'inbox isolates recipients, deduplicates events and scopes read actions',
      () async {
        final alice = await account();
        final bob = await account();
        final service = NotificationService();
        await session.db.transaction((tx) async {
          for (final user in [alice, bob]) {
            for (var retry = 0; retry < 2; retry++) {
              await service.forUser(
                session,
                tx,
                recipientId: user.$1,
                eventKey: 'same-event',
                category: 'grade',
                title: 'Grade published',
              );
            }
          }
        });
        expect(await NotificationRecord.db.count(session), 2);
        final bobItem = (await NotificationRecord.db.find(
          session,
          where: (t) => t.recipientId.equals(bob.$1),
        )).single;
        final foreign = {'id': bobItem.id.toString()};
        expect(
          (await request('notifications', 'get', foreign, token: alice.$2)).$2,
          isNull,
        );
        await request('notifications', 'markRead', foreign, token: alice.$2);
        await request('notifications', 'markAllRead', {}, token: alice.$2);
        expect(
          (await request(
            'notifications',
            'unreadCount',
            {},
            token: alice.$2,
          )).$2,
          0,
        );
        expect(
          (await request('notifications', 'unreadCount', {}, token: bob.$2)).$2,
          1,
        );
        final listed = await request('notifications', 'list', {
          'offset': 0,
          'limit': 50,
          'category': 'grade',
          'unreadOnly': true,
        }, token: bob.$2);
        expect(listed.$1, 200);
        expect(listed.$2, hasLength(1));
        await request('notifications', 'markRead', foreign, token: bob.$2);
        final readAt = (await NotificationRecord.db.findById(
          session,
          bobItem.id!,
        ))!.readAt;
        await request('notifications', 'markRead', foreign, token: bob.$2);
        expect(
          (await NotificationRecord.db.findById(session, bobItem.id!))!.readAt,
          readAt,
        );
      },
    );
  }, rollbackDatabase: RollbackDatabase.disabled);
}
