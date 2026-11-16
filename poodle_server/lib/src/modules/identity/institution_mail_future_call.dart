import 'package:serverpod/serverpod.dart';
import 'institution_mail.dart';

class InstitutionMailFutureCall extends FutureCall {
  Future<void> deliver(Session session) async {
    await InstitutionMail.deliverPending(session);
  }
}
