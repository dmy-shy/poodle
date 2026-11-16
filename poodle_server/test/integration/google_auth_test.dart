import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:poodle_server/src/auth/identity_auth_config.dart';
import 'dart:io';
import 'package:serverpod/src/server/server.dart' show ServerInternalMethods;
import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:poodle_server/src/auth/google_identity.dart';
import 'package:poodle_server/src/modules/identity/identity_service.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';
import '../support/google_keys.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Google identity', (builder, endpoints) {
    late Session session;
    var sequence = 0;
    late String email;
    late String subject;
    String proof({
      String audience = 'poodle-test',
      String issuer = 'https://accounts.google.com',
      bool verified = true,
      Duration expiry = const Duration(minutes: 10),
    }) => JWT(
      {'email': email, 'email_verified': verified, 'aud': audience},
      subject: subject,
      issuer: issuer,
    ).sign(testRsaPrivateKey, algorithm: JWTAlgorithm.RS256, expiresIn: expiry);
    Future<AuthSuccess> login(String token) => http.runWithClient(
      () => endpoints.emailIdp.googleLogin(builder, idToken: token),
      () => MockClient((request) async {
        expect(request.url.path, '/oauth2/v3/certs');
        return http.Response(
          jsonEncode({
            'keys': [testRsaPublicJwk],
          }),
          200,
        );
      }),
    );
    setUp(() {
      session = builder.build();
      addTearDown(session.close);
      email = 'google-${sequence++}@example.test';
      subject = email;
      session.serverpod.initializeAuthServices(
        tokenManagerBuilders: [
          JwtConfig(
            algorithm: JwtAlgorithm.hmacSha512(
              SecretKey('google-test-signing'),
            ),
            refreshTokenHashPepper: 'google-test-pepper',
            issuer: 'poodle',
          ),
        ],
        identityProviderBuilders: [
          identityEmailConfig(
            pepper: "google-test-email-pepper",
            runMode: ServerpodRunMode.test,
          ),
          GoogleIdpConfig(
            clientSecret: GoogleClientSecret.fromJson({
              'web': {
                'client_id': 'poodle-test',
                'client_secret': 'test',
                'redirect_uris': <String>[],
              },
            }),
            googleAccountDetailsValidation: validateGoogleIdentity,
          ),
        ],
      );
    });
    Future<(int, Map<String, dynamic>)> request(
      String path,
      String token,
      Map<String, dynamic> body,
    ) async {
      final client = HttpClient();
      try {
        final req = await client.postUrl(
          Uri.parse('http://localhost:${session.serverpod.server.port}/$path'),
        );
        req.headers.contentType = ContentType.json;
        req.headers.set('Authorization', 'Bearer $token');
        req.write(jsonEncode(body));
        final response = await req.close();
        final raw = await utf8.decoder.bind(response).join();
        return (
          response.statusCode,
          (raw.isEmpty || raw == 'null')
              ? <String, dynamic>{}
              : jsonDecode(raw) as Map<String, dynamic>,
        );
      } finally {
        client.close(force: true);
      }
    }

    setUp(() {
      session.serverpod.server.setAuthenticationHandlerForTesting(
        AuthServices.instance.authenticationHandler,
      );
    });
    Future<void> invite() async {
      final issuer = await AuthServices.instance.authUsers.create(session);
      await IdentityService.createInvitation(
        session,
        email: email,
        issuerId: issuer.id,
      );
    }

    test(
      'existing email account requires explicit matching Google link',
      () async {
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
        final credentials = await AuthServices.instance.tokenManager.issueToken(
          session,
          authUserId: user.id,
          method: 'email',
        );
        await expectLater(
          login(proof()),
          throwsA(isA<IdentityAccessException>()),
        );
        final result = await http.runWithClient(
          () => request('emailIdp/linkGoogle', credentials.token, {
            'idToken': proof(),
          }),
          () => MockClient(
            (_) async => http.Response(
              jsonEncode({
                'keys': [testRsaPublicJwk],
              }),
              200,
            ),
          ),
        );
        expect(result.$1, 200);
        expect((await login(proof())).authUserId, user.id);
      },
    );
    test('concurrent Google signup creates one identity', () async {
      await invite();
      final results = await Future.wait([login(proof()), login(proof())]);
      expect(results[0].authUserId, results[1].authUserId);
    });
    test('Google JWT authorizes account and linking is idempotent', () async {
      await invite();
      final credentials = await login(proof());
      final me = await request('account/me', credentials.token, {});
      expect(me.$1, 200);
      expect(me.$2['googleLinked'], true);
      expect(me.$2['isAdmin'], false);
      final linked = await http.runWithClient(
        () => request('emailIdp/linkGoogle', credentials.token, {
          'idToken': proof(),
        }),
        () => MockClient(
          (_) async => http.Response(
            jsonEncode({
              'keys': [testRsaPublicJwk],
            }),
            200,
          ),
        ),
      );
      expect(linked.$1, 200);
      expect((await request('account/me', 'invalid', {})).$1, isNot(200));
    });
    test('uninvited Google user cannot create an authorized account', () async {
      await expectLater(
        login(proof()),
        throwsA(isA<IdentityAccessException>()),
      );
      await invite();
      expect((await login(proof())).authUserId, isNotNull);
    });
    test(
      'invited signup and returning login retain the same identity',
      () async {
        await invite();
        final first = await login(proof());
        final second = await login(proof());
        expect(second.authUserId, first.authUserId);
        expect(first.authStrategy, 'jwt');
      },
    );
    for (final invalid in [
      'audience',
      'issuer',
      'unverified',
      'expired',
      'tampered',
    ]) {
      test('rejects $invalid Google proof', () async {
        await invite();
        final token = switch (invalid) {
          'audience' => proof(audience: 'other'),
          'issuer' => proof(issuer: 'https://attacker.test'),
          'unverified' => proof(verified: false),
          'expired' => proof(expiry: const Duration(hours: -1)),
          _ => '${proof()}tamper',
        };
        await expectLater(
          login(token),
          throwsA(isA<IdentityAccessException>()),
        );
        expect((await login(proof())).authUserId, isNotNull);
      });
    }
  }, rollbackDatabase: RollbackDatabase.disabled);
}
