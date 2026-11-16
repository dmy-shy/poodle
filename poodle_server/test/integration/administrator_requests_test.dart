import 'package:poodle_server/src/auth/transactional_email.dart';
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
  withServerpod('Administrator requests', (builder, endpoints) {
    late Session session;
    var sequence = 0;
    final messages = <({String email, String text})>[];
    setUp(() {
      messages.clear();
      TransactionalEmail.testDelivery =
          ({
            required email,
            required subject,
            required text,
            required key,
          }) async {
            messages.add((email: email, text: text));
          };
    });
    tearDown(() => TransactionalEmail.testDelivery = null);
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
            delivery:
                ({
                  required email,
                  required code,
                  required passwordReset,
                }) async => messages.add((email: email, text: code)),
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
      bool teacher = false,
      UuidValue? universityId,
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
          teacherApproved: teacher,
          universityId: universityId,
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

    test('verified request reaches each platform admin inbox once', () async {
      final first = await account(admin: true);
      final second = await account(admin: true);
      final member = await account();
      final started = await request('administratorRequests', 'begin', {
        'name': 'University Coordinator',
        'email': 'alert@example.test',
        'university': 'Alert University',
        'position': 'Coordinator',
        'note': '',
        'locale': 'en',
      });
      expect(started.$1, 200);
      for (final token in [first.$2, second.$2, member.$2]) {
        final inbox = await request('notifications', 'list', {
          'offset': 0,
          'limit': 20,
          'category': 'universityRequest',
          'unreadOnly': false,
        }, token: token);
        expect(inbox.$1, 200);
        expect(inbox.$2, isEmpty);
      }
      final code = RegExp(
        r'\b[1-9]{8}\b',
      ).firstMatch(messages.last.text)!.group(0)!;
      expect(
        (await request('administratorRequests', 'verify', {
          'requestId': started.$2,
          'code': code,
        })).$1,
        200,
      );
      for (final token in [first.$2, second.$2]) {
        final inbox = await request('notifications', 'list', {
          'offset': 0,
          'limit': 20,
          'category': 'universityRequest',
          'unreadOnly': false,
        }, token: token);
        expect(inbox.$2, hasLength(1));
        expect(inbox.$2.single['requestId'], started.$2);
        final count = await request(
          'administratorRequests',
          'pendingCount',
          {},
          token: token,
        );
        expect(count.$2, 1);
        final exact = await request(
          'administratorRequests',
          'get',
          {'requestId': started.$2},
          token: token,
        );
        expect(exact.$2['id'], started.$2);
      }
      final memberInbox = await request('notifications', 'list', {
        'offset': 0,
        'limit': 20,
        'category': 'universityRequest',
        'unreadOnly': false,
      }, token: member.$2);
      expect(memberInbox.$2, isEmpty);
      expect(
        (await request(
          'administratorRequests',
          'pendingCount',
          {},
          token: member.$2,
        )).$1,
        isNot(200),
      );
    });

    test('operator approval invites only a university administrator', () async {
      final operator = await account(admin: true);
      final started = await request('administratorRequests', 'begin', {
        'name': 'University Coordinator',
        'email': 'founder@example.test',
        'university': 'Second University',
        'position': 'Coordinator',
        'note': '',
        'locale': 'en',
      });
      expect(started.$1, 200);
      final code = RegExp(
        r'\b[1-9]{8}\b',
      ).firstMatch(messages.last.text)!.group(0)!;
      expect(
        (await request('administratorRequests', 'verify', {
          'requestId': started.$2,
          'code': code,
        })).$1,
        200,
      );
      final approved = await request('administratorRequests', 'approve', {
        'requestId': started.$2,
        'universityName': 'Second University',
        'slug': 'second-university',
        'reviewNote': 'Confirmed with the university office',
      }, token: operator.$2);
      expect(approved.$1, 200);
      final registration = await request('emailIdp', 'startRegistration', {
        'email': 'founder@example.test',
      });
      expect(registration.$1, 200);
      final proof = await request('emailIdp', 'verifyRegistrationCode', {
        'accountRequestId': registration.$2,
        'verificationCode': messages.last.text,
      });
      expect(proof.$1, 200);
      final finished = await request('emailIdp', 'finishRegistration', {
        'registrationToken': proof.$2,
        'password': 'University-admin-123',
      });
      expect(finished.$1, 200);
      final token = AuthSuccess.fromJson(
        Map<String, dynamic>.from(finished.$2),
      ).token;
      final me = await request('account', 'me', {}, token: token);
      expect(me.$1, 200);
      expect(me.$2['isAdmin'], false);
      expect(me.$2['isUniversityAdmin'], true);
      expect(me.$2['universityId'], approved.$2['id']);
      expect(
        (await request('administratorRequests', 'list', {
          'offset': 0,
        }, token: token)).$1,
        isNot(200),
      );
      final duplicate = await request('administratorRequests', 'approve', {
        'requestId': started.$2,
        'universityName': 'Other University',
        'slug': 'wrong',
        'reviewNote': 'Again',
      }, token: operator.$2);
      expect(duplicate.$1, isNot(200));
    });

    test('verified applicant reaches only the operator review queue', () async {
      final operator = await account(admin: true);
      final ordinary = await account();
      final started = await request('administratorRequests', 'begin', {
        'name': 'Olena Teacher',
        'email': 'olena@example.test',
        'university': 'Volyn University',
        'position': 'IT coordinator',
        'note': 'Please contact our office',
        'locale': 'uk',
      });
      expect(started.$1, 200);
      final verification = messages.singleWhere(
        (m) => m.email == 'olena@example.test',
      );
      final code = RegExp(
        r'\b[1-9]{8}\b',
      ).firstMatch(verification.text)!.group(0)!;
      final before = await request('administratorRequests', 'list', {
        'offset': 0,
      }, token: operator.$2);
      expect(before.$1, 200);
      expect(
        (before.$2 as List).where((r) => r['email'] == 'olena@example.test'),
        isEmpty,
      );
      final verified = await request('administratorRequests', 'verify', {
        'requestId': started.$2,
        'code': code,
      });
      expect(verified.$1, 200);
      final pending = await request('administratorRequests', 'list', {
        'offset': 0,
      }, token: operator.$2);
      expect(pending.$1, 200);
      expect(
        (pending.$2 as List).singleWhere(
          (r) => r['email'] == 'olena@example.test',
        )['email'],
        'olena@example.test',
      );
      expect(
        (pending.$2 as List).singleWhere(
          (r) => r['email'] == 'olena@example.test',
        )['status'],
        'pending',
      );
      expect(jsonEncode(pending.$2), isNot(contains(code)));
      expect(
        (await request('administratorRequests', 'list', {
          'offset': 0,
        }, token: ordinary.$2)).$1,
        isNot(200),
      );
    });
  }, rollbackDatabase: RollbackDatabase.disabled);
}
