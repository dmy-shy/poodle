import 'package:poodle_flutter/data/services/google_credential_service.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_client/poodle_client.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/services/serverpod_auth_gateway.dart';
import 'package:poodle_flutter/data/services/session_credential_store.dart';
import 'package:poodle_flutter/data/services/remembered_account_store.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class MemoryCredentials implements ClientAuthSuccessStorage {
  AuthSuccess? value;
  @override
  Future<AuthSuccess?> get() async => value;
  @override
  Future<void> set(AuthSuccess? data) async {
    value = data;
  }
}

class MemoryAccount implements RememberedAccountStore {
  AuthSession? value;
  @override
  Future<AuthSession?> read(String server) async => value == null
      ? null
      : AuthSession(
          value!.email,
          userId: value!.userId,
          offline: true,
          isAdmin: value!.isAdmin,
          teacherApproved: value!.teacherApproved,
        );
  @override
  Future<void> write(String server, AuthSession account) async {
    value = account;
  }

  @override
  Future<void> clear(String server) async {
    value = null;
  }
}

class TestGoogle implements GoogleCredentialService {
  Object? failure;
  @override
  bool get available => true;
  @override
  Future<String> acquire() async {
    if (failure != null) throw failure!;
    return 'google-proof';
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  const userId = '00000000-0000-4000-8000-000000000001';
  late HttpServer server;
  late ServerpodAuthGateway gateway;
  late MemoryCredentials durable;
  late SessionCredentialStore store;
  late Map<String, (int, Object?)> responses;
  late List<(String, Map<String, dynamic>, String?)> requests;
  late AuthSuccess credentials;
  late TestGoogle google;
  late MemoryAccount remembered;
  var languageCode = 'en';

  setUp(() async {
    languageCode = 'en';
    credentials = AuthSuccess(
      authStrategy: 'jwt',
      token: 'test-access',
      tokenExpiresAt: DateTime.now().toUtc().add(const Duration(minutes: 10)),
      refreshToken: 'test-refresh',
      authUserId: UuidValue.fromString(userId),
      scopeNames: {},
    );
    responses = {
      '/emailIdp/login': (200, credentials.toJson()),
      '/emailIdp/googleLogin': (200, credentials.toJson()),
      '/emailIdp/linkGoogle': (200, null),
      '/account/me': (
        200,
        AccountSnapshot(
          authUserId: UuidValue.fromString(userId),
          email: 'member@example.test',
          isAdmin: false,
          teacherApproved: true,
        ).toJson(),
      ),
      '/jwtRefresh/refreshAccessToken': (
        200,
        credentials
            .copyWith(token: 'rotated', refreshToken: 'rotated-refresh')
            .toJson(),
      ),
      '/serverpod_auth_core.status/isSignedIn': (200, true),
      '/serverpod_auth_core.status/signOutDevice': (200, null),
      '/emailIdp/startRegistration': (200, userId),
      '/emailIdp/verifyRegistrationCode': (200, 'registration-proof'),
      '/emailIdp/finishRegistration': (200, credentials.toJson()),
      '/emailIdp/startPasswordReset': (200, userId),
      '/emailIdp/verifyPasswordResetCode': (200, 'reset-proof'),
      '/emailIdp/finishPasswordReset': (200, null),
      '/adminInvitations/list': (200, <Object>[]),
      '/adminInvitations/create': (
        200,
        InvitationSummary(
          id: UuidValue.fromString(userId),
          email: 'teacher@example.test',
          createdAt: DateTime.now().toUtc(),
          expiresAt: DateTime.now().toUtc().add(const Duration(days: 7)),
        ).toJson(),
      ),
      '/adminInvitations/revoke': (200, null),
    };
    requests = [];
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      final raw = await utf8.decoder.bind(request).join();
      requests.add((
        request.uri.path,
        jsonDecode(raw) as Map<String, dynamic>,
        request.headers.value(HttpHeaders.authorizationHeader),
      ));
      final response = responses[request.uri.path] ?? (404, null);
      request.response.statusCode = response.$1;
      request.response.headers.contentType = ContentType.json;
      if (response.$2 != null) request.response.write(jsonEncode(response.$2));
      await request.response.close();
    });
    durable = MemoryCredentials();
    store = SessionCredentialStore(durable);
    google = TestGoogle();
    remembered = MemoryAccount();
    gateway = ServerpodAuthGateway(
      'http://127.0.0.1:${server.port}/',
      store,
      monitorConnectivity: false,
      google: google,
      rememberedAccount: remembered,
      languageCode: () => languageCode,
    );
  });
  tearDown(() async {
    gateway.dispose();
    await server.close(force: true);
  });

  test(
    'verification requests carry the primary app language to Serverpod',
    () async {
      languageCode = 'uk';
      await gateway.requestCode('member@example.test', reset: false);
      await gateway.requestCode('member@example.test', reset: true);
      languageCode = 'fr';
      await gateway.requestCode('member@example.test', reset: true);
      expect(
        requests
            .where((r) => r.$1.startsWith('/emailIdp/start'))
            .map((r) => r.$2),
        [
          {'email': 'member@example.test', 'locale': 'uk'},
          {'email': 'member@example.test', 'locale': 'uk'},
          {'email': 'member@example.test', 'locale': 'en'},
        ],
      );
    },
  );

  test('Google login validates account and honors memory storage', () async {
    final account = await gateway.loginGoogle(false);
    expect(account.userId, userId);
    expect(requests.first.$2, {'idToken': 'google-proof'});
    expect(durable.value, isNull);
  });
  test('Google cancellation remains signed out', () async {
    google.failure = AuthFailure.cancelled;
    await expectLater(
      gateway.loginGoogle(true),
      throwsA(AuthFailure.cancelled),
    );
    expect(gateway.hasCredentials, isFalse);
    expect(durable.value, isNull);
  });
  test('Google remember me restores durable credentials', () async {
    await gateway.loginGoogle(true);
    expect(durable.value, isNotNull);
    expect((await gateway.restore())?.userId, userId);
  });
  test('remembered account opens offline after a network failure', () async {
    await gateway.login('member@example.test', 'secret', true);
    final port = server.port;
    gateway.dispose();
    await server.close(force: true);
    gateway = ServerpodAuthGateway(
      'http://127.0.0.1:$port/',
      SessionCredentialStore(durable),
      monitorConnectivity: false,
      rememberedAccount: remembered,
    );
    final restored = await gateway.restore();
    expect(restored?.userId, userId);
    expect(restored?.offline, isTrue);
  });
  test('memory-only login leaves no offline identity to restore', () async {
    await gateway.login('member@example.test', 'secret', false);
    expect(remembered.value, isNull);
    expect(durable.value, isNull);
  });
  test('cancelled linking preserves existing credentials', () async {
    await gateway.login('member@example.test', 'secret', true);
    google.failure = AuthFailure.cancelled;
    await expectLater(gateway.linkGoogle(), throwsA(AuthFailure.cancelled));
    expect(gateway.hasCredentials, isTrue);
    expect(durable.value, isNotNull);
  });

  test(
    'login uses generated endpoint and validates bearer account before publishing',
    () async {
      final account = await gateway.login(
        'member@example.test',
        'secret',
        false,
      );
      expect(account.userId, userId);
      expect(account.teacherApproved, isTrue);
      expect(account.isAdmin, isFalse);
      expect(requests.first.$2, {
        'email': 'member@example.test',
        'password': 'secret',
      });
      expect(requests.last.$1, '/account/me');
      expect(requests.last.$3, 'Bearer test-access');
      expect(durable.value, isNull);
    },
  );

  test('remembered startup refreshes and validates account', () async {
    durable.value = credentials;
    expect((await gateway.restore())?.email, 'member@example.test');
    expect(
      requests.any((request) => request.$1 == '/jwtRefresh/refreshAccessToken'),
      isTrue,
    );
    expect(durable.value?.refreshToken, 'rotated-refresh');
  });

  test('missing session restores signed out without a network call', () async {
    expect(await gateway.restore(), isNull);
    expect(requests, isEmpty);
  });

  test('forbidden admin call preserves the session', () async {
    await gateway.login('member@example.test', 'secret', false);
    responses['/adminInvitations/list'] = (
      500,
      {
        'className': 'IdentityAccessException',
        'data': IdentityAccessException(code: 'forbidden').toJson(),
      },
    );
    await expectLater(gateway.invitations(0), throwsA(AuthFailure.forbidden));
    expect(gateway.hasCredentials, isTrue);
  });

  test(
    'rejected protected account clears candidate durable credentials',
    () async {
      responses['/account/me'] = (
        500,
        {
          'className': 'IdentityAccessException',
          'data': IdentityAccessException(code: 'unauthenticated').toJson(),
        },
      );
      await expectLater(
        gateway.login('member@example.test', 'secret', true),
        throwsA(AuthFailure.invalidCredentials),
      );
      expect(gateway.hasCredentials, isFalse);
      expect(durable.value, isNull);
    },
  );

  test(
    'invitation proof stays transient and is passed to SDK completion',
    () async {
      await gateway.requestCode('member@example.test', reset: false);
      await gateway.verifyCode('verification-code', reset: false);
      await gateway.register('Long-password-123', false);
      final finish = requests.firstWhere(
        (request) => request.$1 == '/emailIdp/finishRegistration',
      );
      expect(finish.$2['registrationToken'], 'registration-proof');
      expect(durable.value, isNull);
      await expectLater(
        gateway.register('Long-password-123', false),
        throwsA(AuthFailure.invalidCode),
      );
    },
  );

  test('reset uses all SDK steps and clears proof after completion', () async {
    await gateway.requestCode('member@example.test', reset: true);
    await gateway.verifyCode('verification-code', reset: true);
    await gateway.resetPassword('New-password-123');
    final finish = requests.firstWhere(
      (request) => request.$1 == '/emailIdp/finishPasswordReset',
    );
    expect(finish.$2['finishPasswordResetToken'], 'reset-proof');
    await expectLater(
      gateway.resetPassword('New-password-123'),
      throwsA(AuthFailure.invalidCode),
    );
  });

  test(
    'logout sends the current credential before deleting local storage',
    () async {
      await gateway.login('member@example.test', 'secret', true);
      expect(await gateway.logout(), isTrue);
      final logout = requests.firstWhere(
        (request) => request.$1 == '/serverpod_auth_core.status/signOutDevice',
      );
      expect(logout.$3, 'Bearer test-access');
      expect(durable.value, isNull);
      await gateway.discard();
      expect(remembered.value, isNull);
    },
  );

  test('cancelled verification cannot use old request proof', () async {
    await gateway.requestCode('member@example.test', reset: true);
    gateway.cancelVerification();
    await expectLater(
      gateway.verifyCode('old', reset: true),
      throwsA(AuthFailure.invalidCode),
    );
  });

  test(
    'admin invitation calls use bounded pagination and no client issuer',
    () async {
      await gateway.login('member@example.test', 'secret', false);
      expect(await gateway.invitations(20), isEmpty);
      await gateway.invite('teacher@example.test');
      await gateway.revoke(userId);
      expect(requests.firstWhere((r) => r.$1 == '/adminInvitations/list').$2, {
        'limit': 20,
        'offset': 20,
      });
      expect(
        requests.firstWhere((r) => r.$1 == '/adminInvitations/create').$2,
        {'email': 'teacher@example.test'},
      );
    },
  );
}
