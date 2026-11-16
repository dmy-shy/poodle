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
  withServerpod('Given private messaging', (builder, _) {
    late Session session;
    var sequence = 0;

    setUp(() {
      session = builder.build();
      addTearDown(session.close);
      session.serverpod.initializeAuthServices(
        tokenManagerBuilders: [
          JwtConfig(
            algorithm: JwtAlgorithm.hmacSha512(
              SecretKey('messaging-test-signing-key'),
            ),
            refreshTokenHashPepper: 'messaging-test-refresh-pepper',
            issuer: 'poodle',
          ),
        ],
        identityProviderBuilders: [
          identityEmailConfig(
            pepper: 'messaging-test-email-pepper',
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
        return (
          response.statusCode,
          text.isEmpty ? null : jsonDecode(text),
        );
      } finally {
        client.close(force: true);
      }
    }

    Future<(UuidValue, String)> account() async {
      final email =
          'message-${DateTime.now().microsecondsSinceEpoch}-${sequence++}@example.test';
      final user = await AuthServices.instance.authUsers.create(session);
      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: user.id,
        email: email,
        password: 'Course-password-123',
      );
      await AccountAccess.db.insertRow(
        session,
        AccountAccess(authUserId: user.id),
      );
      final client = HttpClient();
      try {
        final login = await client.postUrl(
          Uri.parse(
            'http://localhost:${session.serverpod.server.port}/emailIdp/login',
          ),
        );
        login.headers.contentType = ContentType.json;
        login.write(
          jsonEncode({'email': email, 'password': 'Course-password-123'}),
        );
        final response = await login.close();
        final body = await utf8.decoder.bind(response).join();
        expect(response.statusCode, 200);
        return (
          user.id,
          AuthSuccess.fromJson(
            Map<String, dynamic>.from(jsonDecode(body)),
          ).token,
        );
      } finally {
        client.close(force: true);
      }
    }

    test(
      'when opening drafts twice then returns one private conversation',
      () async {
        final alice = await account();
        final first = await request(
          'messaging',
          'openSelf',
          {},
          token: alice.$2,
        );
        final second = await request(
          'messaging',
          'openSelf',
          {},
          token: alice.$2,
        );

        expect(first.$1, 200);
        expect(second.$1, 200);
        expect(first.$2['id'], second.$2['id']);
        expect(first.$2['isSelf'], isTrue);
        expect(first.$2['unreadCount'], 0);
      },
    );

    test(
      'when active classmates open a peer chat then they reuse one conversation',
      () async {
        final alice = await account();
        final bob = await account();
        final course = await CourseRecord.db.insertRow(
          session,
          CourseRecord(title: 'Messaging course'),
        );
        await CourseMembership.db.insert(session, [
          CourseMembership(
            courseId: course.id!,
            authUserId: alice.$1,
            role: 'student',
          ),
          CourseMembership(
            courseId: course.id!,
            authUserId: bob.$1,
            role: 'teacher',
          ),
        ]);

        final fromAlice = await request(
          'messaging',
          'openPeer',
          {'peerId': bob.$1.toString()},
          token: alice.$2,
        );
        final fromBob = await request(
          'messaging',
          'openPeer',
          {'peerId': alice.$1.toString()},
          token: bob.$2,
        );

        expect(fromAlice.$1, 200);
        expect(fromBob.$1, 200);
        expect(fromAlice.$2['id'], fromBob.$2['id']);
        expect(fromAlice.$2['isSelf'], isFalse);
        expect(fromAlice.$2['canSend'], isTrue);
      },
    );

    test(
      'when a participant retries a send then the recipient sees one unread message',
      () async {
        final alice = await account();
        final bob = await account();
        final course = await CourseRecord.db.insertRow(
          session,
          CourseRecord(title: 'Message delivery course'),
        );
        await CourseMembership.db.insert(session, [
          CourseMembership(
            courseId: course.id!,
            authUserId: alice.$1,
            role: 'student',
          ),
          CourseMembership(
            courseId: course.id!,
            authUserId: bob.$1,
            role: 'student',
          ),
        ]);
        final conversation = await request(
          'messaging',
          'openPeer',
          {'peerId': bob.$1.toString()},
          token: alice.$2,
        );
        final body = {
          'conversationId': conversation.$2['id'],
          'clientSendId': const Uuid().v4obj().toString(),
          'text': 'Can you review the assignment?',
        };
        final sent = await request('messaging', 'send', body, token: alice.$2);
        final retried = await request(
          'messaging',
          'send',
          body,
          token: alice.$2,
        );
        final history = await request(
          'messaging',
          'listMessages',
          {
            'conversationId': conversation.$2['id'],
            'beforeId': null,
            'limit': 50,
          },
          token: bob.$2,
        );

        expect(sent.$1, 200);
        expect(retried.$1, 200);
        expect(sent.$2['id'], retried.$2['id']);
        expect(history.$1, 200);
        expect(history.$2, hasLength(1));
        expect(history.$2.single['text'], 'Can you review the assignment?');

        final inboxBeforeRead = await request(
          'messaging',
          'listConversations',
          {},
          token: bob.$2,
        );
        expect(inboxBeforeRead.$1, 200);
        expect(inboxBeforeRead.$2.single['unreadCount'], 1);

        final markedRead = await request(
          'messaging',
          'markRead',
          {
            'conversationId': conversation.$2['id'],
            'throughMessageId': sent.$2['id'],
          },
          token: bob.$2,
        );
        final inboxAfterRead = await request(
          'messaging',
          'listConversations',
          {},
          token: bob.$2,
        );
        expect(markedRead.$1, 200);
        expect(inboxAfterRead.$1, 200);
        expect(inboxAfterRead.$2.single['unreadCount'], 0);
      },
    );
  }, rollbackDatabase: RollbackDatabase.disabled);
}
