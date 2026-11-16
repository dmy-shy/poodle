import 'package:poodle_server/src/auth/email_delivery_context.dart';
import 'package:test/test.dart';

void main() {
  test(
    'concurrent requests keep their own language and restore English afterwards',
    () async {
      expect(EmailDeliveryContext.locale, 'en');
      final result = await Future.wait([
        EmailDeliveryContext.run('uk', () async {
          await Future<void>.delayed(Duration.zero);
          return EmailDeliveryContext.locale;
        }),
        EmailDeliveryContext.run('de', () async {
          await Future<void>.delayed(Duration.zero);
          return EmailDeliveryContext.locale;
        }),
      ]);
      expect(result, ['uk', 'en']);
      expect(EmailDeliveryContext.locale, 'en');
      await expectLater(
        EmailDeliveryContext.run('uk', () async => throw StateError('failed')),
        throwsStateError,
      );
      expect(EmailDeliveryContext.locale, 'en');
    },
  );
}
