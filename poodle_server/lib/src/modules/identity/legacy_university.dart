import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

abstract final class LegacyUniversity {
  static final id = UuidValue.withValidation(
    '019a0acf-0050-7000-8000-000000009999',
  );
  static Future<void> ensure(Session session, Transaction tx) async {
    if (await UniversityRecord.db.findById(session, id, transaction: tx) ==
        null) {
      await UniversityRecord.db.insertRow(
        session,
        UniversityRecord(
          id: id,
          name: 'Legacy pilot university',
          slug: 'legacy-pilot',
        ),
        transaction: tx,
      );
    }
  }
}
