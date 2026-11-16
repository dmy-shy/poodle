import 'package:serverpod/serverpod.dart';

/// Acquire the recipient email lock before university/operator locks whenever
/// both are needed. All authority mutations use the same transaction locks.
abstract final class IdentityLocks {
  static Future<void> email(Session session, String key, Transaction tx) async {
    await session.db.unsafeQuery(
      'SELECT pg_advisory_xact_lock(hashtextextended(@email, 0))',
      parameters: QueryParameters.named({'email': 'poodle.identity:$key'}),
      transaction: tx,
    );
  }

  static Future<void> university(
    Session session,
    UuidValue id,
    Transaction tx,
  ) => email(session, 'university-admins:$id', tx);

  static Future<void> operatorBootstrap(Session session, Transaction tx) =>
      email(session, 'platform-operator-bootstrap', tx);
}
