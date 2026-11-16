import 'dart:async';
import 'dart:ui' show PlatformDispatcher;
import '../../domain/models/institution.dart';
import 'google_credential_service.dart';
import 'package:poodle_client/poodle_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import '../repositories/auth_repository.dart';
import 'auth_gateway.dart';
import 'session_credential_store.dart';
import 'remembered_account_store.dart';
import '../../domain/models/course.dart' show CourseFailure;

/// Owns one current SDK client/manager. Retired managers have invalid storage leases.
class ServerpodAuthGateway extends AuthGateway {
  ServerpodAuthGateway(
    this._url,
    this._store, {
    this.monitorConnectivity = true,
    GoogleCredentialService? google,
    RememberedAccountStore? rememberedAccount,
    String Function()? languageCode,
  }) : _google = google ?? NativeGoogleCredentialService(),
       _languageCode =
           languageCode ??
           (() => PlatformDispatcher.instance.locale.languageCode),
       _remembered = rememberedAccount ?? SecureRememberedAccountStore() {
    _replaceClient(_store.lease());
  }
  final bool monitorConnectivity;
  final String Function() _languageCode;
  final GoogleCredentialService _google;
  final RememberedAccountStore _remembered;
  bool _rememberMe = false;
  @override
  bool get googleAvailable => _google.available;
  final String _url;
  String get serverIdentity => _url;
  final SessionCredentialStore _store;
  late Client _client;
  late FlutterAuthSessionManager _manager;
  int _generation = 0;
  int _verificationGeneration = 0;
  UuidValue? _request;
  String? _proof;
  bool? _reset;
  bool _disposed = false;

  void _replaceClient(ClientAuthSuccessStorage storage) {
    _manager = FlutterAuthSessionManager(storage: storage);
    _client = Client(_url, connectionTimeout: const Duration(seconds: 15))
      ..authSessionManager = _manager;
    if (monitorConnectivity) {
      _client.connectivityMonitor = FlutterConnectivityMonitor();
    }
    _manager.authInfoListenable.addListener(() {
      if (!_disposed) notifyListeners();
    });
  }

  @override
  bool get hasCredentials => _manager.isAuthenticated;

  /// Feature services share the current SDK client and its auth lifecycle.
  Future<T> withClient<T>(Future<T> Function(Client client) operation) =>
      _call(() => operation(_client));

  Future<T> _call<T>(Future<T> Function() operation) async {
    final clientAtStart = _client;
    try {
      return await operation();
    } on IdentityAccessException catch (error) {
      if (error.code == 'unauthenticated') {
        if (identical(clientAtStart, _client)) await discard();
        throw AuthFailure.invalidCredentials;
      }
      final googleFailure = <String, AuthFailure>{
        'googleProofInvalid': AuthFailure.googleProofInvalid,
        'googleLinkRequired': AuthFailure.googleLinkRequired,
        'googleEmailMismatch': AuthFailure.googleEmailMismatch,
        'googleLinkConflict': AuthFailure.googleLinkConflict,
        'invitationUnavailable': AuthFailure.invitationUnavailable,
        'emailUnavailable': AuthFailure.emailUnavailable,
        'emailChangeExpired': AuthFailure.emailChangeExpired,
        'emailChangeThrottled': AuthFailure.emailChangeThrottled,
        'passwordUnavailable': AuthFailure.passwordUnavailable,
      }[error.code];
      if (googleFailure != null) throw googleFailure;
      if (error.code == 'forbidden') throw AuthFailure.forbidden;
      throw AuthFailure.unavailable;
    } on EmailAccountLoginException {
      throw AuthFailure.invalidCredentials;
    } on AuthUserBlockedException {
      throw AuthFailure.invalidCredentials;
    } on EmailAccountRequestException catch (error) {
      throw error.reason == EmailAccountRequestExceptionReason.policyViolation
          ? AuthFailure.passwordPolicy
          : AuthFailure.invalidCode;
    } on EmailAccountPasswordResetException catch (error) {
      throw error.reason ==
              EmailAccountPasswordResetExceptionReason.policyViolation
          ? AuthFailure.passwordPolicy
          : AuthFailure.invalidCode;
    } on ServerpodClientUnauthorized {
      if (identical(clientAtStart, _client)) await discard();
      throw AuthFailure.invalidCredentials;
    } on ServerpodClientForbidden {
      throw AuthFailure.forbidden;
    } on ServerpodClientNetworkException {
      throw AuthFailure.network;
    } on ServerpodClientException {
      throw AuthFailure.unavailable;
    } on TimeoutException {
      throw AuthFailure.network;
    } on InstitutionProblem {
      rethrow;
    } on AuthFailure {
      rethrow;
    } on CourseFailure {
      rethrow;
    } on TeachingError {
      rethrow;
    } on NotebookError {
      rethrow;
    } catch (_) {
      throw AuthFailure.unavailable;
    }
  }

  Future<T> _storage<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (_) {
      throw AuthFailure.storage;
    }
  }

  AuthSession _project(AccountSnapshot value) => AuthSession(
    value.email,
    userId: value.authUserId.toString(),
    isAdmin: value.isAdmin,
    universityId: value.universityId?.toString(),
    isUniversityAdmin: value.isUniversityAdmin,
    googleLinked: value.googleLinked,
    hasPassword: value.hasPassword,
    teacherApproved: value.teacherApproved,
  );

  @override
  Future<AuthSession?> restore() => _call(() async {
    final generation = _generation;
    final manager = _manager;
    final client = _client;
    // Restore storage separately so a keychain error is not shown as a bad password.
    await _storage(manager.restore);
    bool initialized;
    try {
      initialized = await manager.initialize(
        timeout: const Duration(seconds: 15),
      );
    } on ServerpodClientNetworkException {
      return _offlineAccount(manager, generation);
    } on TimeoutException {
      return _offlineAccount(manager, generation);
    }
    if (generation != _generation) throw AuthFailure.cancelled;
    if (!initialized && manager.isAuthenticated) {
      return _offlineAccount(manager, generation);
    }
    if (!manager.isAuthenticated) return null;
    late final AccountSnapshot account;
    try {
      account = await client.account.me();
    } on ServerpodClientNetworkException {
      return _offlineAccount(manager, generation);
    } on TimeoutException {
      return _offlineAccount(manager, generation);
    }
    if (generation != _generation) throw AuthFailure.cancelled;
    final projected = _project(account);
    await _refreshRemembered(projected);
    return projected;
  });

  Future<void> _refreshRemembered(AuthSession account) async {
    if (await _storage(() => _remembered.read(_url)) != null) {
      await _storage(() => _remembered.write(_url, account));
    }
  }

  Future<AuthSession> _offlineAccount(
    FlutterAuthSessionManager manager,
    int generation,
  ) async {
    if (generation != _generation) throw AuthFailure.cancelled;
    if (!manager.isAuthenticated) throw AuthFailure.network;
    final account = await _storage(() => _remembered.read(_url));
    if (generation != _generation) throw AuthFailure.cancelled;
    if (account == null || account.userId == null) throw AuthFailure.network;
    return account;
  }

  Future<void> _prepare(bool rememberMe) async {
    final generation = ++_generation;
    _rememberMe = false;
    await _storage(() => _remembered.clear(_url));
    final lease = await _storage(
      () => _store.beginSession(rememberMe: rememberMe),
    );
    if (generation != _generation) throw AuthFailure.cancelled;
    _rememberMe = rememberMe;
    final old = _client;
    _replaceClient(lease);
    old.close();
  }

  Future<AuthSession> _install(
    Client client,
    FlutterAuthSessionManager manager,
    AuthSuccess credentials,
    int generation,
  ) async {
    if (generation != _generation) throw AuthFailure.cancelled;
    await _storage(() => manager.updateSignedInUser(credentials));
    if (generation != _generation) throw AuthFailure.cancelled;
    final account = await client.account.me();
    if (generation != _generation) throw AuthFailure.cancelled;
    final projected = _project(account);
    if (_rememberMe) await _storage(() => _remembered.write(_url, projected));
    if (generation != _generation) throw AuthFailure.cancelled;
    return projected;
  }

  @override
  Future<AuthSession> login(String email, String password, bool rememberMe) =>
      _call(() async {
        await _prepare(rememberMe);
        final generation = _generation;
        final client = _client;
        final manager = _manager;
        try {
          final credentials = await client.emailIdp.login(
            email: email,
            password: password,
          );
          return await _install(client, manager, credentials, generation);
        } catch (_) {
          if (generation == _generation) await discard();
          rethrow;
        }
      });

  @override
  Future<bool> logout() => _call(() async {
    try {
      return await _manager.signOutDevice();
    } finally {
      await _google.signOut();
    }
  });

  @override
  Future<AuthSession> loginGoogle(bool rememberMe) => _call(() async {
    await _prepare(rememberMe);
    final generation = _generation;
    final client = _client;
    final manager = _manager;
    try {
      final proof = await _google.acquire();
      if (generation != _generation) throw AuthFailure.cancelled;
      final credentials = await client.emailIdp.googleLogin(idToken: proof);
      return await _install(client, manager, credentials, generation);
    } catch (_) {
      if (generation == _generation) await discard();
      rethrow;
    }
  });

  @override
  Future<AuthSession> linkGoogle() => _call(() async {
    final generation = _generation;
    final client = _client;
    final proof = await _google.acquire();
    if (generation != _generation) throw AuthFailure.cancelled;
    await client.emailIdp.linkGoogle(idToken: proof);
    final result = await client.account.me();
    if (generation != _generation) throw AuthFailure.cancelled;
    final account = _project(result);
    await _refreshRemembered(account);
    return account;
  });

  @override
  Future<void> discard() async {
    ++_generation;
    _rememberMe = false;
    final old = _client;
    try {
      await _storage(() => _remembered.clear(_url));
      await _storage(_store.clear);
    } finally {
      _replaceClient(_store.lease());
      old.close();
      if (!_disposed) notifyListeners();
    }
  }

  @override
  Future<void> requestCode(String email, {required bool reset}) =>
      _call(() async {
        cancelVerification();
        final generation = _verificationGeneration;
        final locale = _languageCode() == 'uk' ? 'uk' : 'en';
        final request = reset
            ? await _client.emailIdp.startPasswordReset(
                email: email,
                locale: locale,
              )
            : await _client.emailIdp.startRegistration(
                email: email,
                locale: locale,
              );
        if (generation != _verificationGeneration) throw AuthFailure.cancelled;
        _request = request;
        _reset = reset;
      });

  @override
  Future<void> verifyCode(String code, {required bool reset}) =>
      _call(() async {
        final request = _request;
        if (request == null || reset != _reset) throw AuthFailure.invalidCode;
        final generation = _verificationGeneration;
        final proof = reset
            ? await _client.emailIdp.verifyPasswordResetCode(
                passwordResetRequestId: request,
                verificationCode: code,
              )
            : await _client.emailIdp.verifyRegistrationCode(
                accountRequestId: request,
                verificationCode: code,
              );
        if (generation != _verificationGeneration) throw AuthFailure.cancelled;
        _proof = proof;
      });

  @override
  Future<AuthSession> register(String password, bool rememberMe) =>
      _call(() async {
        final verificationGeneration = _verificationGeneration;
        final proof = _proof;
        if (proof == null || _reset != false) throw AuthFailure.invalidCode;
        await _prepare(rememberMe);
        final generation = _generation;
        final client = _client;
        final manager = _manager;
        try {
          final credentials = await client.emailIdp.finishRegistration(
            registrationToken: proof,
            password: password,
          );
          if (verificationGeneration != _verificationGeneration) {
            throw AuthFailure.cancelled;
          }
          final account = await _install(
            client,
            manager,
            credentials,
            generation,
          );
          cancelVerification();
          return account;
        } catch (_) {
          if (generation == _generation) await discard();
          rethrow;
        }
      });

  @override
  Future<void> resetPassword(String password) => _call(() async {
    final generation = _generation;
    final proof = _proof;
    if (proof == null || _reset != true) throw AuthFailure.invalidCode;
    await _client.emailIdp.finishPasswordReset(
      finishPasswordResetToken: proof,
      newPassword: password,
    );
    cancelVerification();
    if (generation == _generation) await discard();
  });

  @override
  void cancelVerification() {
    ++_verificationGeneration;
    _request = null;
    _proof = null;
    _reset = null;
  }

  @override
  Future<AuthSession> account() => _call(() async {
    final account = _project(await _client.account.me());
    await _refreshRemembered(account);
    return account;
  });
  @override
  Future<List<TeacherInvitation>> invitations(int offset) => _call(
    () async => (await _client.adminInvitations.list(limit: 20, offset: offset))
        .map(
          (value) => TeacherInvitation(
            id: value.id.toString(),
            email: value.email,
            expiresAt: value.expiresAt,
            acceptedAt: value.acceptedAt,
            revokedAt: value.revokedAt,
          ),
        )
        .toList(),
  );
  @override
  Future<void> invite(String email) => _call(() async {
    await _client.adminInvitations.create(email: email);
  });
  @override
  Future<void> revoke(String id) => _call(
    () => _client.adminInvitations.revoke(
      invitationId: UuidValue.withValidation(id),
    ),
  );
  PendingEmailChange _emailChange(PendingEmailChangeSummary value) =>
      PendingEmailChange(
        id: value.id.toString(),
        email: value.requestedEmail,
        expiresAt: value.expiresAt,
        resendAvailableAt: value.resendAvailableAt,
      );
  @override
  Future<PendingEmailChange?> pendingEmailChange() => _call(() async {
    final value = await _client.account.pendingEmailChange();
    return value == null ? null : _emailChange(value);
  });
  @override
  Future<PendingEmailChange> startEmailChange({
    required String email,
    required String currentPassword,
    required String locale,
  }) => _call(
    () async => _emailChange(
      await _client.account.startEmailChange(
        newEmail: email,
        currentPassword: currentPassword,
        locale: locale,
      ),
    ),
  );
  @override
  Future<PendingEmailChange> resendEmailChange() => _call(
    () async => _emailChange(await _client.account.resendEmailChange()),
  );
  @override
  Future<void> confirmEmailChange(String code) =>
      _call(() => _client.account.confirmEmailChange(code: code));
  @override
  Future<void> cancelEmailChange() => _call(_client.account.cancelEmailChange);
  @override
  void dispose() {
    _disposed = true;
    ++_generation;
    _store.retire();
    cancelVerification();
    _client.close();
    super.dispose();
  }
}
