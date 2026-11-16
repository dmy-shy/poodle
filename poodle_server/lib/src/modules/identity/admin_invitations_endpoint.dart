import 'package:serverpod/serverpod.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import 'identity_policy.dart';
import 'identity_service.dart';

class AdminInvitationsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<InvitationSummary>> list(
    Session session, {
    required int limit,
    required int offset,
  }) async {
    await AccountAuthorization.requireAdmin(session);
    IdentityPolicy.validatePage(limit: limit, offset: offset);
    return (await AccountInvitation.db.find(
      session,
      limit: limit,
      offset: offset,
      orderByList: (t) => [t.id.desc()],
    )).map(IdentityService.summary).toList();
  }

  Future<InvitationSummary> create(
    Session session, {
    required String email,
  }) async {
    final admin = await AccountAuthorization.requireAdmin(session);
    if (session.serverpod.runMode != ServerpodRunMode.development &&
        session.serverpod.runMode != ServerpodRunMode.test) {
      throw IdentityAccessException(code: 'forbidden');
    }
    return IdentityService.createInvitation(
      session,
      email: email,
      issuerId: admin.authUserId,
    );
  }

  Future<void> revoke(
    Session session, {
    required UuidValue invitationId,
  }) async {
    await AccountAuthorization.requireAdmin(session);
    await IdentityService.revokeInvitation(session, invitationId);
  }
}
