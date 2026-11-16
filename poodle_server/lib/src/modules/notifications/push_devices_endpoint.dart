import 'package:serverpod/serverpod.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';

/// Registration IDs are leases: delayed logout cannot remove a newer binding.
class PushDevicesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<UuidValue> register(
    Session session,
    UuidValue installationId,
    String platform,
    String token,
  ) async {
    final account = await AccountAuthorization.requireAccount(session);
    if (!{'ios', 'android'}.contains(platform) ||
        token.isEmpty ||
        token.length > 4096 ||
        RegExp(r'\s').hasMatch(token)) {
      throw ArgumentError('Invalid push registration');
    }
    return session.db.transaction((tx) async {
      // Serializes installation replacement and token reassignment together.
      // Bound to this short transaction; no provider requests happen here.
      await session.db.unsafeQuery(
        "SELECT pg_advisory_xact_lock(hashtextextended('push-registration', 0))",
        transaction: tx,
      );
      final previous = await PushDeviceRecord.db.findFirstRow(
        session,
        where: (t) => t.installationId.equals(installationId),
        transaction: tx,
      );
      await PushDeviceRecord.db.deleteWhere(
        session,
        where: (t) =>
            t.installationId.equals(installationId) | t.token.equals(token),
        transaction: tx,
      );
      final now = DateTime.now().toUtc();
      final registrationId = Uuid().v4obj();
      await PushDeviceRecord.db.insertRow(
        session,
        PushDeviceRecord(
          installationId: installationId,
          registrationId: registrationId,
          ownerId: account.authUserId,
          platform: platform,
          token: token,
          createdAt: previous?.createdAt ?? now,
          updatedAt: now,
        ),
        transaction: tx,
      );
      return registrationId;
    });
  }

  Future<void> unregister(Session session, UuidValue registrationId) async {
    final account = await AccountAuthorization.requireAccount(session);
    await PushDeviceRecord.db.deleteWhere(
      session,
      where: (t) =>
          t.registrationId.equals(registrationId) &
          t.ownerId.equals(account.authUserId),
    );
  }
}
