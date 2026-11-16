import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/services/session_credential_store.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class DurableStorage implements ClientAuthSuccessStorage {
  AuthSuccess? value;
  bool fail = false;
  @override
  Future<AuthSuccess?> get() async => value;
  @override
  Future<void> set(AuthSuccess? data) async {
    if (fail) throw StateError('Storage unavailable');
    value = data;
  }
}

AuthSuccess credential(String token) => AuthSuccess(
  authStrategy: 'jwt',
  token: token,
  refreshToken: 'test-refresh',
  authUserId: UuidValue.fromString('00000000-0000-4000-8000-000000000001'),
  scopeNames: {},
);

void main() {
  test(
    'remember off removes old durable credentials and stores rotation in memory',
    () async {
      final durable = DurableStorage()..value = credential('old');
      final store = SessionCredentialStore(durable);
      final lease = await store.beginSession(rememberMe: false);
      expect(durable.value, isNull);
      await lease.set(credential('new'));
      expect((await lease.get())?.token, 'new');
      expect(durable.value, isNull);
      await lease.set(credential('rotated'));
      expect((await lease.get())?.token, 'rotated');
      expect(durable.value, isNull);
    },
  );

  test('remember on persists and restores the supported envelope', () async {
    final durable = DurableStorage();
    final store = SessionCredentialStore(durable);
    final lease = await store.beginSession(rememberMe: true);
    await lease.set(credential('saved'));
    final relaunched = SessionCredentialStore(durable);
    expect((await relaunched.lease().get())?.token, 'saved');
  });

  test(
    'late writes from an old manager cannot restore a logged-out session',
    () async {
      final durable = DurableStorage();
      final store = SessionCredentialStore(durable);
      final old = await store.beginSession(rememberMe: true);
      await old.set(credential('old'));
      await store.clear();
      await old.set(credential('late-refresh'));
      expect(await store.lease().get(), isNull);
      expect(durable.value, isNull);
    },
  );

  test(
    'failed persistence is surfaced and does not publish a remembered value',
    () async {
      final durable = DurableStorage();
      final store = SessionCredentialStore(durable);
      final lease = await store.beginSession(rememberMe: true);
      durable.fail = true;
      await expectLater(lease.set(credential('unsaved')), throwsStateError);
      expect(await lease.get(), isNull);
    },
  );
}
