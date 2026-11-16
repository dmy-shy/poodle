import 'dart:convert';
import 'dart:io';
import 'package:poodle_server/src/auth/identity_auth_config.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:poodle_server/src/modules/identity/development_admin_seed.dart';
import 'package:poodle_server/src/modules/identity/development_academic_seed.dart';
import 'package:poodle_server/src/modules/identity/identity_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/server.dart' show ServerInternalMethods;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Identity real bearer boundary', (builder, endpoints) {
    late Session session;
    final delivered = <String, String>{};
    var sequence = 0;
    late String email;
    const password = 'Test-password-123';

    Future<(int, Map<String, dynamic>)> request(
      String endpoint,
      String method,
      Map<String, dynamic> body, {
      String? token,
    }) async {
      final http = HttpClient();
      try {
        final outgoing = await http.postUrl(
          Uri.parse(
            'http://localhost:${session.serverpod.server.port}/$endpoint/$method',
          ),
        );
        outgoing.headers.contentType = ContentType.json;
        if (token != null) {
          outgoing.headers.set(
            HttpHeaders.authorizationHeader,
            'Bearer $token',
          );
        }
        outgoing.write(jsonEncode(body));
        final response = await outgoing.close();
        final text = await utf8.decoder.bind(response).join();
        final Object? decoded = text.isEmpty ? null : jsonDecode(text);
        return (
          response.statusCode,
          decoded is Map<String, dynamic> ? decoded : <String, dynamic>{},
        );
      } finally {
        http.close(force: true);
      }
    }

    Future<AuthSuccess> login(
      String address, {
      String secret = password,
    }) async {
      final (status, data) = await request('emailIdp', 'login', {
        'email': address,
        'password': secret,
      });
      expect(status, 200, reason: 'Expected a successful real email login');
      return AuthSuccess.fromJson(data);
    }

    Future<UuidValue> createAccount({bool admin = false}) async {
      final user = await AuthServices.instance.authUsers.create(session);
      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: user.id,
        email: email,
        password: password,
      );
      await AccountAccess.db.insertRow(
        session,
        AccountAccess(authUserId: user.id, isAdmin: admin),
      );
      return user.id;
    }

    setUp(() {
      session = builder.build();
      addTearDown(() => session.close());
      email = 'jwt-${sequence++}@example.test';
      delivered.clear();
      session.serverpod.initializeAuthServices(
        tokenManagerBuilders: [
          JwtConfig(
            algorithm: JwtAlgorithm.hmacSha512(
              SecretKey('identity-test-signing-key'),
            ),
            refreshTokenHashPepper: 'identity-test-refresh-pepper',
            issuer: 'poodle',
          ),
        ],
        identityProviderBuilders: [
          identityEmailConfig(
            pepper: 'identity-test-email-pepper',
            runMode: ServerpodRunMode.test,
            delivery:
                ({
                  required email,
                  required code,
                  required passwordReset,
                }) async {
                  delivered['$passwordReset:$email'] = code;
                },
          ),
        ],
      );
      // Install the actual SDK verifier on the ephemeral HTTP test server.
      // No authentication-info overrides are used in these tests.
      session.serverpod.server.setAuthenticationHandlerForTesting(
        AuthServices.instance.authenticationHandler,
      );
    });

    test(
      'actual JWT authorizes me; missing, malformed and tampered JWTs fail',
      () async {
        await createAccount();
        final credentials = await login(email);
        final (status, account) = await request(
          'account',
          'me',
          {},
          token: credentials.token,
        );
        expect(status, 200);
        expect(account['email'], email);
        expect(account['isAdmin'], isFalse);
        for (final token in <String?>[
          null,
          'not-a-jwt',
          '${credentials.token}tampered',
        ]) {
          expect(
            (await request('account', 'me', {}, token: token)).$1,
            isNot(200),
          );
        }
      },
    );

    test('unapproved accounts and incorrect passwords cannot log in', () async {
      final user = await AuthServices.instance.authUsers.create(session);
      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: user.id,
        email: email,
        password: password,
      );
      expect(
        (await request('emailIdp', 'login', {
          'email': email,
          'password': password,
        })).$1,
        isNot(200),
      );
      expect(
        (await request('emailIdp', 'login', {
          'email': email,
          'password': 'incorrect',
        })).$1,
        isNot(200),
      );
    });

    test(
      'nonadmin denial does not invalidate its otherwise valid session',
      () async {
        await createAccount();
        final credentials = await login(email);
        final (denied, error) = await request('adminInvitations', 'list', {
          'limit': 20,
          'offset': 0,
        }, token: credentials.token);
        expect(denied, isNot(200));
        expect((error['data'] as Map<String, dynamic>)['code'], 'forbidden');
        expect(
          (await request('account', 'me', {}, token: credentials.token)).$1,
          200,
        );
      },
    );

    test(
      'admin removal and account blocking affect the next bearer call',
      () async {
        final user = await createAccount(admin: true);
        final credentials = await login(email);
        expect(
          (await request('adminInvitations', 'list', {
            'limit': 20,
            'offset': 0,
          }, token: credentials.token)).$1,
          200,
        );
        final access = (await AccountAccess.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(user),
        ))!;
        await AccountAccess.db.updateRow(
          session,
          access.copyWith(isAdmin: false),
        );
        expect(
          (await request('adminInvitations', 'list', {
            'limit': 20,
            'offset': 0,
          }, token: credentials.token)).$1,
          isNot(200),
        );
        final authUser = (await AuthUser.db.findById(session, user))!;
        await AuthUser.db.updateRow(session, authUser.copyWith(blocked: true));
        expect(
          (await request('account', 'me', {}, token: credentials.token)).$1,
          isNot(200),
        );
      },
    );

    test(
      'refresh rotates credentials and revocation immediately denies old access',
      () async {
        await createAccount();
        final credentials = await login(email);
        final (refreshStatus, refreshData) = await request(
          'jwtRefresh',
          'refreshAccessToken',
          {'refreshToken': credentials.refreshToken},
        );
        expect(refreshStatus, 200);
        final rotated = AuthSuccess.fromJson(refreshData);
        expect(rotated.refreshToken, isNot(credentials.refreshToken));
        expect(
          (await request('account', 'me', {}, token: rotated.token)).$1,
          200,
        );
        expect(
          (await request(
            'serverpod_auth_core.status',
            'signOutDevice',
            {},
            token: rotated.token,
          )).$1,
          200,
        );
        expect(
          (await request('account', 'me', {}, token: rotated.token)).$1,
          isNot(200),
        );
      },
    );

    test('uninvited registration sends no code and cannot complete', () async {
      final id = await endpoints.emailIdp.startRegistration(
        builder,
        email: email,
      );
      expect(delivered, isEmpty);
      await expectLater(
        endpoints.emailIdp.verifyRegistrationCode(
          builder,
          accountRequestId: id,
          verificationCode: '12345678',
        ),
        throwsA(isA<EmailAccountRequestException>()),
      );
    });

    test(
      'invitation revoked after verification prevents final account creation',
      () async {
        final issuer = await AuthServices.instance.authUsers.create(session);
        final invite = await IdentityService.createInvitation(
          session,
          email: email,
          issuerId: issuer.id,
        );
        final id = await endpoints.emailIdp.startRegistration(
          builder,
          email: email,
        );
        final proof = await endpoints.emailIdp.verifyRegistrationCode(
          builder,
          accountRequestId: id,
          verificationCode: delivered['false:$email']!,
        );
        await IdentityService.revokeInvitation(session, invite.id);
        await expectLater(
          endpoints.emailIdp.finishRegistration(
            builder,
            registrationToken: proof,
            password: password,
          ),
          throwsA(isA<IdentityAccessException>()),
        );
        expect(
          await EmailAccount.db.findFirstRow(
            session,
            where: (t) => t.email.equals(email),
          ),
          isNull,
        );
      },
    );

    test(
      'verified invitation grants teacher eligibility and never global admin',
      () async {
        final issuer = await AuthServices.instance.authUsers.create(session);
        await IdentityService.createInvitation(
          session,
          email: email,
          issuerId: issuer.id,
        );
        final id = await endpoints.emailIdp.startRegistration(
          builder,
          email: email,
        );
        final proof = await endpoints.emailIdp.verifyRegistrationCode(
          builder,
          accountRequestId: id,
          verificationCode: delivered['false:$email']!,
        );
        final credentials = await endpoints.emailIdp.finishRegistration(
          builder,
          registrationToken: proof,
          password: password,
        );
        final (status, account) = await request(
          'account',
          'me',
          {},
          token: credentials.token,
        );
        expect(status, 200);
        expect(account['teacherApproved'], isTrue);
        expect(account['isAdmin'], isFalse);
      },
    );

    test(
      'completed reset changes password and revokes all old sessions',
      () async {
        await createAccount();
        final credentials = await login(email);
        final id = await endpoints.emailIdp.startPasswordReset(
          builder,
          email: email,
        );
        final proof = await endpoints.emailIdp.verifyPasswordResetCode(
          builder,
          passwordResetRequestId: id,
          verificationCode: delivered['true:$email']!,
        );
        await endpoints.emailIdp.finishPasswordReset(
          builder,
          finishPasswordResetToken: proof,
          newPassword: 'A-new-password-123',
        );
        expect(
          (await request('account', 'me', {}, token: credentials.token)).$1,
          isNot(200),
        );
        expect(
          (await login(email, secret: 'A-new-password-123')).authUserId,
          credentials.authUserId,
        );
      },
    );

    test(
      'academic fixtures preserve identities and enforce course roles',
      () async {
        final existing = await createAccount();
        final configs = <DevelopmentPersona, DevelopmentLogin>{
          DevelopmentPersona.admin: (
            email: 'fixture-admin@example.test',
            password: 'fixture-admin',
            expectedUserId: null,
          ),
          DevelopmentPersona.teacher: (
            email: email,
            password: 'fixture-teacher',
            expectedUserId: existing,
          ),
          DevelopmentPersona.student: (
            email: 'fixture-student@lntu.edu.ua',
            password: 'fixture-student',
            expectedUserId: null,
          ),
        };
        await expectLater(
          DevelopmentAcademicSeed.ensure(session, configs),
          throwsStateError,
        );
        final unverified = {...configs};
        unverified[DevelopmentPersona.teacher] = (
          email: email,
          password: 'fixture-teacher',
          expectedUserId: null,
        );
        await expectLater(
          DevelopmentAcademicSeed.ensure(
            session,
            unverified,
            testFixture: true,
          ),
          throwsException,
        );
        await login(email);
        final installs = await Future.wait([
          DevelopmentAcademicSeed.ensure(session, configs, testFixture: true),
          DevelopmentAcademicSeed.ensure(session, configs, testFixture: true),
        ]);
        expect(
          installs.whereType<Map<DevelopmentPersona, UuidValue>>(),
          hasLength(1),
        );
        final ids = installs
            .whereType<Map<DevelopmentPersona, UuidValue>>()
            .single;
        expect(ids[DevelopmentPersona.teacher], existing);

        Future<AuthSuccess> fixtureLogin(DevelopmentPersona persona) {
          final config = configs[persona]!;
          return login(config.email, secret: config.password);
        }

        final teacher = await fixtureLogin(DevelopmentPersona.teacher);
        final student = await fixtureLogin(DevelopmentPersona.student);
        final admin = await fixtureLogin(DevelopmentPersona.admin);

        Future<CourseRecord> course(String title) async => (await CourseRecord
            .db
            .findFirstRow(session, where: (t) => t.title.equals(title)))!;
        final linear = await course('Linear Algebra');
        final discrete = await course('Discrete Mathematics');
        final oop = await course('OOP');
        Future<int> access(
          String endpoint,
          String method,
          AuthSuccess auth, [
          UuidValue? courseId,
        ]) async {
          final (status, _) = await request(endpoint, method, {
            if (courseId != null) 'courseId': courseId.toString(),
            if (endpoint == 'adminInvitations') ...{'limit': 20, 'offset': 0},
          }, token: auth.token);
          return status;
        }

        expect(await access('adminInvitations', 'list', admin), 200);
        expect(await access('adminInvitations', 'list', teacher), isNot(200));
        expect(await access('teaching', 'members', teacher, linear.id), 200);
        expect(
          await access('teaching', 'members', teacher, discrete.id),
          isNot(200),
        );
        expect(
          await access(
            'courseContent',
            'getCourseContent',
            teacher,
            discrete.id,
          ),
          200,
        );
        expect(
          await access('course', 'getCourse', student, oop.id),
          isNot(200),
        );
        expect(
          await access('course', 'getCourse', admin, linear.id),
          isNot(200),
        );

        final membership = (await CourseMembership.db.findFirstRow(
          session,
          where: (t) =>
              t.courseId.equals(linear.id!) & t.authUserId.equals(existing),
        ))!;
        await CourseMembership.db.updateRow(
          session,
          membership.copyWith(active: false),
        );
        expect(
          await access('teaching', 'members', teacher, linear.id),
          isNot(200),
        );
        expect(
          await DevelopmentAcademicSeed.ensure(
            session,
            configs,
            testFixture: true,
          ),
          isNull,
        );
        expect(
          (await CourseMembership.db.findById(session, membership.id!))!.active,
          isFalse,
        );
      },
    );

    test(
      'bootstrap is explicit in tests and does not regrant removed authority',
      () async {
        await expectLater(
          DevelopmentAdminSeed.ensure(
            session,
            email: email,
            password: 'poodle',
          ),
          throwsStateError,
        );
        await DevelopmentAdminSeed.ensure(
          session,
          email: email,
          password: 'poodle',
          testFixture: true,
        );
        final account = (await EmailAccount.db.findFirstRow(
          session,
          where: (t) => t.email.equals(email),
        ))!;
        final access = (await AccountAccess.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(account.authUserId),
        ))!;
        await AccountAccess.db.updateRow(
          session,
          access.copyWith(isAdmin: false),
        );
        await DevelopmentAdminSeed.ensure(
          session,
          email: email,
          password: 'different',
          testFixture: true,
        );
        expect(
          (await AccountAccess.db.findById(session, access.id!))!.isAdmin,
          isFalse,
        );
        await login(email, secret: 'poodle');
      },
    );
  }, rollbackDatabase: RollbackDatabase.disabled);
}
