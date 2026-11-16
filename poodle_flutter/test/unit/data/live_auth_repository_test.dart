import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/live_auth_repository.dart';
import 'package:poodle_flutter/data/services/auth_gateway.dart';

class TestGateway extends AuthGateway {
  Completer<AuthSession>? loginResult;
  AuthSession? restored;
  AuthFailure? restoreFailure;
  Object? unexpectedRestoreFailure;
  AuthFailure? discardFailure;
  AuthFailure? loginFailure;
  AuthFailure? logoutError;
  AuthFailure? accountFailure;
  Completer<AuthSession>? accountResult;
  final calls = <String>[];
  bool confirmedLogout = true;
  bool discarded = false;
  @override
  bool get hasCredentials => restored != null;
  @override
  Future<AuthSession?> restore() async {
    if (restoreFailure case final error?) throw error;
    if (unexpectedRestoreFailure case final error?) throw error;
    return restored;
  }

  @override
  Future<AuthSession> login(
    String email,
    String password,
    bool rememberMe,
  ) async {
    if (loginFailure case final error?) throw error;
    return loginResult?.future ?? AuthSession(email, userId: email);
  }

  @override
  Future<bool> logout() async {
    if (logoutError case final error?) throw error;
    return confirmedLogout;
  }

  @override
  Future<void> discard() async {
    discarded = true;
    if (discardFailure case final error?) throw error;
  }

  @override
  void cancelVerification() {}
  void loseCredentials() {
    restored = null;
    notifyListeners();
  }

  @override
  Future<AuthSession> account() async {
    if (accountFailure case final error?) throw error;
    return accountResult?.future ?? restored!;
  }

  @override
  Future<void> requestCode(String email, {required bool reset}) async =>
      calls.add('request:$reset:$email');
  @override
  Future<void> verifyCode(String code, {required bool reset}) async =>
      calls.add('verify:$reset:$code');
  @override
  Future<void> resetPassword(String password) async => calls.add('reset');
  @override
  Future<AuthSession> register(String password, bool rememberMe) async =>
      const AuthSession('invited@example.test', teacherApproved: true);
  @override
  Future<List<TeacherInvitation>> invitations(int offset) async {
    calls.add('list:$offset');
    return [];
  }

  @override
  Future<void> invite(String email) async => calls.add('invite:$email');
  @override
  Future<void> revoke(String id) async => calls.add('revoke:$id');
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('empty restore is signed out and live mode is explicit', () async {
    final repository = LiveAuthRepository(TestGateway());
    addTearDown(repository.dispose);
    expect(repository.isPreview, isFalse);
    expect(repository.lifecycle, AuthLifecycle.restoring);
    expect(await repository.restoreSession(), isNull);
    expect(repository.lifecycle, AuthLifecycle.signedOut);
    await expectLater(
      repository.signInWithGoogle(),
      throwsA(AuthFailure.unavailable),
    );
  });

  test(
    'invalid restore clears credentials but cleanup failure allows retry',
    () async {
      final gateway = TestGateway()
        ..restoreFailure = AuthFailure.invalidCredentials
        ..discardFailure = AuthFailure.storage;
      final repository = LiveAuthRepository(gateway);
      addTearDown(repository.dispose);
      await repository.restoreSession();
      expect(repository.startupFailure, AuthFailure.storage);
      expect(repository.lifecycle, AuthLifecycle.unavailable);
      gateway.discardFailure = null;
      await repository.restoreSession();
      expect(gateway.discarded, isTrue);
      expect(repository.startupFailure, isNull);
      expect(repository.lifecycle, AuthLifecycle.signedOut);
    },
  );

  test('unexpected restore failure leaves a recoverable state', () async {
    final repository = LiveAuthRepository(
      TestGateway()..unexpectedRestoreFailure = StateError('adapter failed'),
    );
    addTearDown(repository.dispose);
    await repository.restoreSession();
    expect(repository.startupFailure, AuthFailure.unavailable);
    expect(repository.lifecycle, AuthLifecycle.unavailable);
  });

  test(
    'failed login stays signed out and successful login clears failure',
    () async {
      final gateway = TestGateway()
        ..loginFailure = AuthFailure.invalidCredentials;
      final repository = LiveAuthRepository(gateway);
      addTearDown(repository.dispose);
      Future<void> login() => repository.signInWithEmail(
        email: 'member@example.test',
        password: 'not-stored',
        rememberMe: false,
      );
      await expectLater(login(), throwsA(AuthFailure.invalidCredentials));
      expect(repository.lifecycle, AuthLifecycle.signedOut);
      gateway.loginFailure = null;
      await login();
      expect(repository.session?.email, 'member@example.test');
      expect(repository.lifecycle, AuthLifecycle.signedIn);
    },
  );

  test('credential loss clears published identity immediately', () async {
    final gateway = TestGateway()
      ..restored = const AuthSession('member@example.test');
    final repository = LiveAuthRepository(gateway);
    addTearDown(repository.dispose);
    await repository.restoreSession();
    gateway.loseCredentials();
    expect(repository.session, isNull);
    expect(repository.lifecycle, AuthLifecycle.signedOut);
  });

  test(
    'account refresh updates authority; forbidden does not sign out',
    () async {
      final gateway = TestGateway()
        ..restored = const AuthSession('member@example.test', isAdmin: true);
      final repository = LiveAuthRepository(gateway);
      addTearDown(repository.dispose);
      await repository.restoreSession();
      gateway.restored = const AuthSession('member@example.test');
      expect((await repository.refreshAccount()).isAdmin, isFalse);
      gateway.accountFailure = AuthFailure.forbidden;
      await expectLater(
        repository.refreshAccount(),
        throwsA(AuthFailure.forbidden),
      );
      expect(repository.lifecycle, AuthLifecycle.signedIn);
    },
  );

  test('late account refresh cannot republish after logout', () async {
    final gateway = TestGateway()..accountResult = Completer<AuthSession>();
    final repository = LiveAuthRepository(gateway);
    addTearDown(repository.dispose);
    final refresh = repository.refreshAccount();
    final check = expectLater(refresh, throwsA(AuthFailure.cancelled));
    await repository.signOut();
    gateway.accountResult!.complete(const AuthSession('late@example.test'));
    await check;
    expect(repository.session, isNull);
  });

  test('logout surfaces storage cleanup failure and retry clears it', () async {
    final gateway = TestGateway()
      ..logoutError = AuthFailure.network
      ..discardFailure = AuthFailure.storage;
    final repository = LiveAuthRepository(gateway);
    addTearDown(repository.dispose);
    await repository.signOut();
    expect(repository.logoutFailure, AuthFailure.storage);
    expect(repository.lifecycle, AuthLifecycle.signedOut);
    gateway.logoutError = null;
    gateway.discardFailure = null;
    await repository.signOut();
    expect(repository.logoutFailure, isNull);
  });

  test(
    'verification and admin operations use the adapter and publish only completed signup',
    () async {
      final gateway = TestGateway();
      final repository = LiveAuthRepository(gateway);
      addTearDown(repository.dispose);
      await repository.requestInvitation('invited@example.test');
      await repository.verifyInvitation('proof');
      expect(repository.session, isNull);
      await repository.completeInvitation('new-password', rememberMe: false);
      expect(repository.session?.teacherApproved, isTrue);
      await repository.requestPasswordReset('invited@example.test');
      await repository.verifyPasswordReset('reset-proof');
      await repository.completePasswordReset('replacement');
      expect(await repository.listInvitations(offset: 20), isEmpty);
      await repository.createInvitation('new@example.test');
      await repository.revokeInvitation('invitation-id');
      expect(gateway.calls, [
        'request:false:invited@example.test',
        'verify:false:proof',
        'request:true:invited@example.test',
        'verify:true:reset-proof',
        'reset',
        'list:20',
        'invite:new@example.test',
        'revoke:invitation-id',
      ]);
    },
  );

  test('disposed repository ignores a late login completion', () async {
    final gateway = TestGateway()..loginResult = Completer<AuthSession>();
    final repository = LiveAuthRepository(gateway);
    final login = repository.signInWithEmail(
      email: 'late@example.test',
      password: 'not-stored',
      rememberMe: false,
    );
    repository.dispose();
    gateway.loginResult!.complete(const AuthSession('late@example.test'));
    await login;
    expect(repository.session, isNull);
  });
  test(
    'startup network failure is recoverable and preserves credentials',
    () async {
      final gateway = TestGateway()..restoreFailure = AuthFailure.network;
      final repository = LiveAuthRepository(gateway);
      addTearDown(repository.dispose);
      expect(await repository.restoreSession(), isNull);
      expect(repository.lifecycle, AuthLifecycle.unavailable);
      expect(gateway.discarded, isFalse);
      gateway.restoreFailure = null;
      gateway.restored = const AuthSession(
        'admin@example.test',
        userId: 'admin',
        isAdmin: true,
      );
      await repository.restoreSession();
      expect(repository.session?.isAdmin, isTrue);
      expect(repository.lifecycle, AuthLifecycle.signedIn);
    },
  );

  test('logout invalidates a pending login before it can publish', () async {
    final gateway = TestGateway()..loginResult = Completer<AuthSession>();
    final repository = LiveAuthRepository(gateway);
    addTearDown(repository.dispose);
    final login = repository.signInWithEmail(
      email: 'late@example.test',
      password: 'not-stored',
      rememberMe: false,
    );
    await repository.signOut();
    gateway.loginResult!.complete(const AuthSession('late@example.test'));
    await login;
    expect(repository.session, isNull);
    expect(repository.lifecycle, AuthLifecycle.signedOut);
  });

  test(
    'offline logout clears the account and reports unconfirmed revocation',
    () async {
      final gateway = TestGateway()
        ..restored = const AuthSession('a@example.test')
        ..confirmedLogout = false;
      final repository = LiveAuthRepository(gateway);
      addTearDown(repository.dispose);
      await repository.restoreSession();
      await repository.signOut();
      expect(repository.session, isNull);
      expect(repository.logoutFailure, AuthFailure.network);
      expect(gateway.discarded, isTrue);
    },
  );
}
