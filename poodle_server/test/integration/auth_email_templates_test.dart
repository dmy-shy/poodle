import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:poodle_server/src/auth/email_idp_endpoint.dart';
import 'package:poodle_server/src/auth/identity_auth_config.dart';
import 'package:poodle_server/src/auth/transactional_email.dart';
import 'package:poodle_server/src/modules/identity/identity_service.dart';
import 'package:poodle_server/src/modules/identity/account_email_endpoint.dart';
import 'package:poodle_server/src/modules/identity/administrator_requests_endpoint.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Auth email templates', (builder, endpoints) {
    late Session session;
    setUp(() {
      session = builder.build();
      addTearDown(session.close);
      TransactionalEmail.configure(
        resendApiKey: 'test-key',
        from: 'accounts@poodle.ink',
      );
      addTearDown(() => TransactionalEmail.configure());
      session.serverpod.initializeAuthServices(
        tokenManagerBuilders: [
          JwtConfig(
            algorithm: JwtAlgorithm.hmacSha512(
              SecretKey('email-template-test-key'),
            ),
            refreshTokenHashPepper: 'email-template-refresh',
            issuer: 'poodle',
          ),
        ],
        identityProviderBuilders: [
          identityEmailConfig(
            pepper: 'email-template-pepper',
            runMode: ServerpodRunMode.test,
          ),
        ],
      );
    });

    test(
      'university access requests use the matching verification template',
      () async {
        for (final locale in ['en', 'uk']) {
          final email = 'university-$locale-${const Uuid().v4()}@example.test';
          late String code;
          final startedAt = DateTime.now().toUtc();
          final endpoint = AdministratorRequestsEndpoint();
          final id = await http.runWithClient(
            () => endpoint.begin(
              session,
              name: 'Test User',
              email: email,
              university: 'Test University',
              position: 'Coordinator',
              note: '',
              locale: locale,
            ),
            () => MockClient((request) async {
              final body = jsonDecode(request.body) as Map<String, dynamic>;
              expect(body.keys, unorderedEquals(['from', 'to', 'template']));
              expect(body['to'], [email]);
              expect(
                body['template']['id'],
                'poodle-administrator-request-$locale',
              );
              final variables =
                  body['template']['variables'] as Map<String, dynamic>;
              code = variables['CODE'] as String;
              expect(code, matches(r'^\d{8}$'));
              final deadline = DateTime.parse(
                '${variables['EXPIRES_AT_UTC']}Z',
              );
              expect(
                deadline.difference(startedAt).inSeconds,
                inInclusiveRange(840, 900),
              );
              expect(request.headers['Idempotency-Key'], isNot(contains(code)));
              return http.Response('{"id":"test"}', 200);
            }),
          );
          await endpoint.verify(session, requestId: id, code: code);
        }
      },
    );

    test(
      'registration uses Ukrainian template with the actual SDK code',
      () async {
        final email =
            'template-registration-${DateTime.now().microsecondsSinceEpoch}@example.test';
        final issuer = await AuthServices.instance.authUsers.create(session);
        await IdentityService.createInvitation(
          session,
          email: email,
          issuerId: issuer.id,
        );
        String? code;
        final before = DateTime.now().toUtc();
        final requestId = await http.runWithClient(
          () => EmailIdpEndpoint().startRegistration(
            session,
            email: email,
            locale: 'uk',
          ),
          () => MockClient((request) async {
            final body = jsonDecode(request.body) as Map;
            expect(body['template']['id'], 'poodle-registration-uk');
            code = body['template']['variables']['CODE'] as String;
            expect(code, matches(r'^\d{8}$'));
            final expiry = DateTime.parse(
              '${body['template']['variables']['EXPIRES_AT_UTC']}Z',
            );
            expect(
              expiry.difference(before).inSeconds,
              inInclusiveRange(840, 900),
            );
            return http.Response('{"id":"test"}', 200);
          }),
        );
        expect(code, isNotNull);
        final proof = await EmailIdpEndpoint().verifyRegistrationCode(
          session,
          accountRequestId: requestId,
          verificationCode: code!,
        );
        expect(proof, isNotEmpty);
      },
    );

    test(
      'password reset uses the requested language and its SDK proof remains valid',
      () async {
        final email =
            'template-reset-${DateTime.now().microsecondsSinceEpoch}@example.test';
        final user = await AuthServices.instance.authUsers.create(session);
        await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
          session,
          authUserId: user.id,
          email: email,
          password: 'Test-password-123',
        );
        String? code;
        final id = await http.runWithClient(
          () => EmailIdpEndpoint().startPasswordReset(
            session,
            email: email,
            locale: 'uk',
          ),
          () => MockClient((request) async {
            final body = jsonDecode(request.body) as Map;
            expect(body['template']['id'], 'poodle-password-reset-uk');
            code = body['template']['variables']['CODE'] as String;
            expect(code, matches(r'^\d{8}$'));
            return http.Response('{"id":"test"}', 200);
          }),
        );
        expect(code, isNotNull);
        expect(
          await EmailIdpEndpoint().verifyPasswordResetCode(
            session,
            passwordResetRequestId: id,
            verificationCode: code!,
          ),
          isNotEmpty,
        );
      },
    );

    test(
      'email change resend rotates code and key while preserving the deadline and locale',
      () async {
        final email =
            'template-change-${DateTime.now().microsecondsSinceEpoch}@example.test';
        final user = await AuthServices.instance.authUsers.create(session);
        await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
          session,
          authUserId: user.id,
          email: email,
          password: 'Test-password-123',
        );
        await AccountAccess.db.insertRow(
          session,
          AccountAccess(authUserId: user.id),
        );
        final credentials = await EmailIdpEndpoint().login(
          session,
          email: email,
          password: 'Test-password-123',
        );
        final authenticated = await session.serverpod.createSession(
          enableLogging: false,
        );
        addTearDown(authenticated.close);
        authenticated.updateAuthenticated(
          await AuthServices.instance.authenticationHandler(
            authenticated,
            credentials.token,
          ),
        );
        final payloads = <Map>[];
        final keys = <String>[];
        await http.runWithClient(
          () async {
            final pending = await AccountEmailService.start(
              authenticated,
              newEmail: 'new-$email',
              currentPassword: 'Test-password-123',
              locale: 'uk',
            );
            // Advance the cooldown fixture without waiting a real minute.
            final row = (await PendingEmailChange.db.findById(
              session,
              pending.id,
            ))!;
            await PendingEmailChange.db.updateRow(
              session,
              row.copyWith(
                resendAvailableAt: DateTime.now().toUtc().subtract(
                  const Duration(minutes: 1),
                ),
              ),
            );
            final resent = await AccountEmailService.resend(authenticated);
            expect(resent.expiresAt, pending.expiresAt);
          },
          () => MockClient((request) async {
            payloads.add(jsonDecode(request.body) as Map);
            keys.add(request.headers['Idempotency-Key']!);
            return http.Response('{"id":"sent"}', 200);
          }),
        );
        expect(payloads, hasLength(2));
        expect(
          payloads.map((p) => p['template']['id']),
          everyElement('poodle-email-change-uk'),
        );
        expect(
          payloads[0]['template']['variables']['EXPIRES_AT_UTC'],
          payloads[1]['template']['variables']['EXPIRES_AT_UTC'],
        );
        expect(keys[0], isNot(keys[1]));
        expect(
          payloads[0]['template']['variables']['CODE'],
          isNot(payloads[1]['template']['variables']['CODE']),
        );
        final pending = (await AccountEmailService.pending(authenticated))!;
        final row = (await PendingEmailChange.db.findById(
          session,
          pending.id,
        ))!;
        await PendingEmailChange.db.updateRow(
          session,
          row.copyWith(
            resendAvailableAt: DateTime.now().toUtc().subtract(
              const Duration(minutes: 1),
            ),
          ),
        );
        await http.runWithClient(
          () => expectLater(
            AccountEmailService.resend(authenticated),
            throwsStateError,
          ),
          () => MockClient((_) async => http.Response('provider failure', 503)),
        );
        // Failed delivery must not invalidate the code that was actually delivered.
        await AccountEmailService.confirm(
          authenticated,
          code: payloads[1]['template']['variables']['CODE'] as String,
        );
        expect(
          (await EmailIdpEndpoint().login(
            session,
            email: 'new-$email',
            password: 'Test-password-123',
          )).authUserId,
          user.id,
        );
      },
    );
  }, rollbackDatabase: RollbackDatabase.disabled);
}
