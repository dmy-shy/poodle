import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../repositories/auth_repository.dart';

/// Account identity paired with a durable SDK credential, never an auth token.
abstract class RememberedAccountStore {
  Future<AuthSession?> read(String server);
  Future<void> write(String server, AuthSession account);
  Future<void> clear(String server);
}

class SecureRememberedAccountStore implements RememberedAccountStore {
  SecureRememberedAccountStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();
  final FlutterSecureStorage _storage;
  String _key(String server) =>
      'poodle-remembered-account-${sha256.convert(utf8.encode(server))}';

  @override
  Future<AuthSession?> read(String server) async {
    final raw = await _storage.read(key: _key(server));
    if (raw == null) return null;
    try {
      final value = jsonDecode(raw);
      if (value case {
        'userId': final String id,
        'email': final String email,
      } when id.isNotEmpty && email.isNotEmpty) {
        return AuthSession(
          email,
          userId: id,
          isAdmin: value['isAdmin'] == true,
          universityId: value['universityId'] as String?,
          isUniversityAdmin: value['isUniversityAdmin'] == true,
          googleLinked: value['googleLinked'] == true,
          hasPassword: value['hasPassword'] == true,
          teacherApproved: value['teacherApproved'] == true,
          offline: true,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String server, AuthSession account) => _storage.write(
    key: _key(server),
    value: jsonEncode({
      'userId': account.userId,
      'email': account.email,
      'isAdmin': account.isAdmin,
      'universityId': account.universityId,
      'isUniversityAdmin': account.isUniversityAdmin,
      'googleLinked': account.googleLinked,
      'hasPassword': account.hasPassword,
      'teacherApproved': account.teacherApproved,
    }),
  );

  @override
  Future<void> clear(String server) => _storage.delete(key: _key(server));
}
