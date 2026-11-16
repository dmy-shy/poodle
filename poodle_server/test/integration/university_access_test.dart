import 'package:poodle_server/src/modules/identity/identity_locks.dart';
import 'dart:convert';
import 'dart:io';
import 'package:poodle_server/src/auth/identity_auth_config.dart';
import 'package:poodle_server/src/auth/transactional_email.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/server.dart' show ServerInternalMethods;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('University access boundary', (builder, endpoints) {
    late Session session;
    var sequence = 0;
    final codes = <String, String>{};
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
                }) async {
                  codes[email] = code;
                },
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
      bool universityAdmin = false,
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
          isUniversityAdmin: universityAdmin,
          universityId: universityId,
          developmentBootstrap: bootstrap,
          verifiedEmail: email,
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

    Future<(int, dynamic)> finishRegistration(String email) async {
      final started = await request('emailIdp', 'startRegistration', {
        'email': email,
      });
      expect(started.$1, 200);
      final proof = await request('emailIdp', 'verifyRegistrationCode', {
        'accountRequestId': started.$2,
        'verificationCode': codes[email],
      });
      expect(proof.$1, 200);
      return request('emailIdp', 'finishRegistration', {
        'registrationToken': proof.$2,
        'password': 'Invited-account-123',
      });
    }

    Future<String> register(String email) async {
      final result = await finishRegistration(email);
      expect(result.$1, 200);
      return AuthSuccess.fromJson(Map<String, dynamic>.from(result.$2)).token;
    }

    for (final purpose in ['teacherCandidate', 'universityAdmin', 'student']) {
      test('blocked inviter cannot authorize $purpose access', () async {
        final university = await UniversityRecord.db.insertRow(
          session,
          UniversityRecord(
            name: 'Blocked issuer $purpose',
            slug: 'blocked-${purpose.toLowerCase()}',
          ),
        );
        final issuer = await account(
          universityId: university.id!,
          universityAdmin: purpose != 'student',
          teacher: purpose == 'student',
        );
        final course = purpose == 'student'
            ? await request('course', 'create', {
                'title': 'Teacher invitation course',
              }, token: issuer.$2)
            : null;
        final email = 'blocked-${purpose.toLowerCase()}@example.test';
        expect(
          (await request('universityAccess', 'invite', {
            'email': email,
            'purpose': purpose,
            if (course != null) 'courseId': course.$2['id'],
          }, token: issuer.$2)).$1,
          200,
        );
        final user = (await AuthUser.db.findById(session, issuer.$1))!;
        await AuthUser.db.updateRow(session, user.copyWith(blocked: true));
        final accepted = await finishRegistration(email);
        expect(accepted.$1, isNot(200));
        expect(accepted.$2.toString(), contains('invitationUnavailable'));
      });
    }

    test('demoted administrator cannot finish a pending grant', () async {
      final university = await UniversityRecord.db.insertRow(
        session,
        UniversityRecord(name: 'Revoked authority', slug: 'revoked-authority'),
      );
      final first = await account(
        universityId: university.id!,
        universityAdmin: true,
      );
      final second = await account(
        universityId: university.id!,
        universityAdmin: true,
      );
      final target = await account(universityId: university.id!);
      final targetSnapshot = await request(
        'account',
        'me',
        {},
        token: target.$2,
      );
      final email = targetSnapshot.$2['email'] as String;
      Future<(int, dynamic)>? pending;
      await session.db.transaction((tx) async {
        await IdentityLocks.email(session, email, tx);
        pending = request('universityAccess', 'invite', {
          'email': email,
          'purpose': 'universityAdmin',
        }, token: first.$2);
        var waiting = false;
        for (var i = 0; i < 100; i++) {
          final rows = await session.db.unsafeQuery(
            "SELECT count(*) FROM pg_stat_activity WHERE wait_event = 'advisory' AND query LIKE '%pg_advisory_xact_lock%'",
          );
          if ((rows.single.first as int) > 0) {
            waiting = true;
            break;
          }
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
        expect(
          waiting,
          true,
          reason: 'Grant must wait after its initial authority check',
        );
        expect(
          (await request('universityAccess', 'setAdministrator', {
            'userId': first.$1.toString(),
            'enabled': false,
          }, token: second.$2)).$1,
          200,
        );
      });
      final result = await pending!;
      expect(result.$1, isNot(200));
      expect(result.$2.toString(), contains('forbidden'));
      final targetAfter = await request('account', 'me', {}, token: target.$2);
      expect(targetAfter.$2['isUniversityAdmin'], false);
    });

    test(
      'role change mail uses the target authentication email for legacy accounts',
      () async {
        final university = await UniversityRecord.db.insertRow(
          session,
          UniversityRecord(
            name: 'Legacy email university',
            slug: 'legacy-email',
          ),
        );
        final admin = await account(
          universityId: university.id!,
          universityAdmin: true,
        );
        final target = await account(universityId: university.id!);
        final operator = await account(admin: true);
        final actor = await request('account', 'me', {}, token: admin.$2);
        final actorEmail = actor.$2['email'];
        final before = await request('account', 'me', {}, token: target.$2);
        final email = before.$2['email'];
        final access = (await AccountAccess.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(target.$1),
        ))!;
        await AccountAccess.db.updateRow(
          session,
          access.copyWith(verifiedEmail: null),
        );
        final recipients = <String>[];
        TransactionalEmail.testDelivery =
            ({
              required email,
              required subject,
              required text,
              required key,
            }) async {
              if (subject.contains('administrator access') &&
                  text.contains('Changed by $actorEmail.')) {
                recipients.add(email);
              }
            };
        addTearDown(() => TransactionalEmail.testDelivery = null);
        expect(
          (await request('universityAccess', 'setAdministrator', {
            'userId': target.$1.toString(),
            'enabled': true,
          }, token: admin.$2)).$1,
          200,
        );
        expect(
          (await request(
            'administratorRequests',
            'retryMail',
            {},
            token: operator.$2,
          )).$1,
          200,
        );
        expect(recipients, [email]);
      },
    );

    test(
      'university admin invites a teacher who creates a course and invites a student',
      () async {
        final university = await UniversityRecord.db.insertRow(
          session,
          UniversityRecord(
            name: 'Invite University',
            slug: 'invite-university',
          ),
        );
        final admin = await account(
          universityId: university.id!,
          universityAdmin: true,
        );
        final invited = await request('universityAccess', 'invite', {
          'email': 'newteacher@example.test',
          'purpose': 'teacherCandidate',
        }, token: admin.$2);
        expect(invited.$1, 200);
        final teacher = await register('newteacher@example.test');
        final course = await request('course', 'create', {
          'title': 'First teaching course',
        }, token: teacher);
        expect(course.$1, 200);
        final studentInvite = await request('universityAccess', 'invite', {
          'email': 'newstudent@example.test',
          'purpose': 'student',
          'courseId': course.$2['id'],
        }, token: teacher);
        expect(studentInvite.$1, 200);
        final student = await register('newstudent@example.test');
        final draft = await request('course', 'getCourse', {
          'courseId': course.$2['id'],
        }, token: student);
        expect(draft.$1, isNot(200));
        expect(
          (await request('course', 'setPublished', {
            'courseId': course.$2['id'],
            'published': true,
          }, token: teacher)).$1,
          200,
        );
        final visible = await request('course', 'getCourse', {
          'courseId': course.$2['id'],
        }, token: student);
        expect(visible.$1, 200);
        expect(visible.$2['role'], 'student');
        final escalation = await request('universityAccess', 'invite', {
          'email': 'bad@example.test',
          'purpose': 'universityAdmin',
        }, token: teacher);
        expect(escalation.$1, isNot(200));
        expect(
          (await request('universityAccess', 'setAdministrator', {
            'userId': admin.$1.toString(),
            'enabled': false,
          }, token: admin.$2)).$1,
          isNot(200),
        );
      },
    );

    test(
      'blocked co-administrator cannot replace the last active administrator',
      () async {
        final university = await UniversityRecord.db.insertRow(
          session,
          UniversityRecord(
            name: 'Active administrators',
            slug: 'active-admins',
          ),
        );
        final active = await account(
          universityId: university.id!,
          universityAdmin: true,
        );
        final blocked = await account(
          universityId: university.id!,
          universityAdmin: true,
        );
        final user = (await AuthUser.db.findById(session, blocked.$1))!;
        await AuthUser.db.updateRow(session, user.copyWith(blocked: true));
        final result = await request('universityAccess', 'setAdministrator', {
          'userId': active.$1.toString(),
          'enabled': false,
        }, token: active.$2);
        expect(result.$1, isNot(200));
        expect(result.$2.toString(), contains('lastAdministrator'));
        final members = await request(
          'universityAccess',
          'members',
          {'offset': 0},
          token: active.$2,
        );
        expect(members.$1, 200);
        expect(
          (members.$2 as List).singleWhere(
            (m) => m['userId'] == active.$1.toString(),
          )['administrator'],
          true,
        );
      },
    );

    test('approved teacher creates a course and becomes its teacher', () async {
      final university = await UniversityRecord.db.insertRow(
        session,
        UniversityRecord(
          name: 'Teaching University',
          slug: 'teaching-university',
        ),
      );
      final teacher = await account(
        universityId: university.id!,
        teacher: true,
      );
      final student = await account(universityId: university.id!);
      final denied = await request('course', 'create', {
        'title': 'Denied',
      }, token: student.$2);
      expect(denied.$1, isNot(200));
      final created = await request('course', 'create', {
        'title': 'New course',
      }, token: teacher.$2);
      expect(created.$1, 200);
      expect(created.$2['title'], 'New course');
      expect(created.$2['role'], 'teacher');
      final listed = await request(
        'course',
        'listMyCourses',
        {},
        token: teacher.$2,
      );
      expect(listed.$1, 200);
      expect(
        (listed.$2 as List).map((row) => row['id']),
        contains(created.$2['id']),
      );
    });

    test('membership cannot grant access across universities', () async {
      final first = await UniversityRecord.db.insertRow(
        session,
        UniversityRecord(name: 'University A', slug: 'university-a'),
      );
      final second = await UniversityRecord.db.insertRow(
        session,
        UniversityRecord(name: 'University B', slug: 'university-b'),
      );
      final student = await account(universityId: first.id!);
      final course = await CourseRecord.db.insertRow(
        session,
        CourseRecord(
          title: 'Private University B course',
          universityId: second.id!,
        ),
      );
      await CourseMembership.db.insertRow(
        session,
        CourseMembership(
          courseId: course.id!,
          authUserId: student.$1,
          role: 'student',
        ),
      );
      final result = await request('course', 'getCourse', {
        'courseId': course.id.toString(),
      }, token: student.$2);
      expect(result.$1, isNot(200));
      expect(jsonEncode(result.$2), isNot(contains('Private University B')));
      final courses = await request(
        'course',
        'listMyCourses',
        {},
        token: student.$2,
      );
      expect(courses.$1, 200);
      expect(courses.$2, isEmpty);
      final sameUniversity = await account(universityId: second.id!);
      await CourseMembership.db.insertRow(
        session,
        CourseMembership(
          courseId: course.id!,
          authUserId: sameUniversity.$1,
          role: 'student',
        ),
      );
      final allowed = await request('course', 'getCourse', {
        'courseId': course.id.toString(),
      }, token: sameUniversity.$2);
      expect(allowed.$1, 200);
      expect(allowed.$2['title'], 'Private University B course');
      final peers = await request('messaging', 'eligiblePeers', {
        'query': '',
      }, token: student.$2);
      expect(peers.$1, 200);
      expect(peers.$2, isEmpty);
      final conversation = await request('messaging', 'openPeer', {
        'peerId': sameUniversity.$1.toString(),
      }, token: student.$2);
      expect(conversation.$1, isNot(200));
    });
  }, rollbackDatabase: RollbackDatabase.disabled);
}
