import 'identity_locks.dart';
import 'package:serverpod/serverpod.dart';
import '../../auth/transactional_email.dart';
import '../../generated/protocol.dart';

abstract final class InstitutionMail {
  static Future<void> queue(
    Session session, {
    required String key,
    required String email,
    required String subject,
    required String body,
    required Transaction transaction,
  }) async {
    if (await InstitutionMailRecord.db.findFirstRow(
          session,
          where: (t) => t.key.equals(key),
          transaction: transaction,
        ) !=
        null) {
      return;
    }
    await InstitutionMailRecord.db.insertRow(
      session,
      InstitutionMailRecord(
        key: key,
        email: email,
        subject: subject,
        body: body,
      ),
      transaction: transaction,
    );
  }

  static Future<int> deliverPending(Session session) async {
    final rows = await InstitutionMailRecord.db.find(
      session,
      where: (t) =>
          t.deliveredAt.equals(null) &
          (t.availableAt <= DateTime.now().toUtc()),
      limit: 20,
      orderBy: (t) => t.availableAt,
    );
    var delivered = 0;
    for (final candidate in rows) {
      final claimed = await session.db.transaction((tx) async {
        await IdentityLocks.email(session, 'mail:${candidate.id}', tx);
        final row = await InstitutionMailRecord.db.findById(
          session,
          candidate.id!,
          transaction: tx,
        );
        final now = DateTime.now().toUtc();
        if (row == null ||
            row.deliveredAt != null ||
            row.availableAt.isAfter(now)) {
          return null;
        }
        return InstitutionMailRecord.db.updateRow(
          session,
          row.copyWith(
            attempts: row.attempts + 1,
            availableAt: now.add(const Duration(minutes: 2)),
          ),
          transaction: tx,
        );
      });
      if (claimed == null) continue;
      try {
        await TransactionalEmail.sendMessage(
          session,
          email: claimed.email,
          subject: claimed.subject,
          text: claimed.body,
          key: claimed.key,
        );
        await InstitutionMailRecord.db.updateRow(
          session,
          claimed.copyWith(deliveredAt: DateTime.now().toUtc()),
        );
        delivered++;
      } catch (error) {
        await InstitutionMailRecord.db.updateRow(
          session,
          claimed.copyWith(
            availableAt: DateTime.now().toUtc().add(
              Duration(minutes: claimed.attempts.clamp(1, 60)),
            ),
          ),
        );
        session.log(
          'Institution email delivery failed; queued for retry (${error.runtimeType}).',
          level: LogLevel.warning,
        );
      }
    }
    return delivered;
  }

  static String invitationBody(
    String email,
    String university,
    String purpose,
  ) {
    final origin = TransactionalEmail.actionOrigin;
    final link = origin == null
        ? null
        : Uri.parse(origin)
              .resolve('/join')
              .replace(queryParameters: {'email': email})
              .toString();
    return 'Poodle: $university\nYou have been invited as $purpose. Open the invitation in Poodle and verify this email address. The invitation expires in seven days.\n'
        'Вас запрошено до Poodle ($university). Відкрийте запрошення та підтвердьте цю адресу. Запрошення дійсне сім днів.\n${link ?? 'Open Poodle /join to accept your invitation.'}';
  }
}
