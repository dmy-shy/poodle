import 'package:serverpod/serverpod.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import 'account_email_endpoint.dart';

class AccountEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<AccountSnapshot> me(Session session) =>
      AccountAuthorization.requireAccount(session);

  Future<PendingEmailChangeSummary?> pendingEmailChange(Session session) =>
      AccountEmailService.pending(session);
  Future<PendingEmailChangeSummary> startEmailChange(
    Session session, {
    required String newEmail,
    required String currentPassword,
    required String locale,
  }) => AccountEmailService.start(
    session,
    newEmail: newEmail,
    currentPassword: currentPassword,
    locale: locale,
  );
  Future<PendingEmailChangeSummary> resendEmailChange(Session session) =>
      AccountEmailService.resend(session);
  Future<void> cancelEmailChange(Session session) =>
      AccountEmailService.cancel(session);
  Future<void> confirmEmailChange(Session session, {required String code}) =>
      AccountEmailService.confirm(session, code: code);
}
