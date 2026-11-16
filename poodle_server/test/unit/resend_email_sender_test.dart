import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:poodle_server/src/auth/resend_email_sender.dart';
import 'package:test/test.dart';

void main() {
  test(
    'retries reuse a key while a rotated resend code gets a new key',
    () async {
      final keys = <String>[];
      final deadlines = <String>[];
      await http.runWithClient(
        () async {
          final sender = ResendEmailSender(
            apiKey: 'secret',
            from: 'accounts@poodle.ink',
          );
          for (final code in ['01234567', '01234567', '87654321']) {
            await sender.sendCode(
              email: 'user@example.test',
              code: code,
              purpose: 'email',
              requestId: 'same-request',
              expiresAt: DateTime.utc(2026, 11, 15, 12, 15),
            );
          }
        },
        () => MockClient((request) async {
          keys.add(request.headers['Idempotency-Key']!);
          deadlines.add(
            jsonDecode(request.body)['template']['variables']['EXPIRES_AT_UTC']
                as String,
          );
          return http.Response('{"id":"sent"}', 200);
        }),
      );
      expect(keys[0], keys[1]);
      expect(keys[2], isNot(keys[0]));
      expect(
        keys.every((key) => key.length <= 256 && !key.contains('87654321')),
        isTrue,
      );
      expect(deadlines, everyElement('2026-11-15 12:15'));
    },
  );
  test('a stalled provider times out', () async {
    await http.runWithClient(() async {
      await expectLater(
        ResendEmailSender(
          apiKey: 'secret',
          from: 'accounts@poodle.ink',
          timeout: const Duration(milliseconds: 10),
        ).sendCode(
          email: 'user@example.test',
          code: '12345678',
          purpose: 'reset',
          requestId: '1',
          expiresAt: DateTime.utc(2026, 11, 15, 12, 15),
        ),
        throwsA(isA<TimeoutException>()),
      );
    }, () => MockClient((_) => Completer<http.Response>().future));
  });
  test(
    'provider rejection fails delivery without leaking response data',
    () async {
      await http.runWithClient(
        () async {
          await expectLater(
            ResendEmailSender(
              apiKey: 'secret',
              from: 'accounts@poodle.ink',
            ).sendCode(
              email: 'user@example.test',
              code: '12345678',
              purpose: 'email',
              requestId: '1',
              expiresAt: DateTime.utc(2026, 11, 15, 12, 15),
            ),
            throwsA(
              predicate(
                (e) =>
                    e.toString().contains('429') &&
                    !e.toString().contains('private-provider-data'),
              ),
            ),
          );
        },
        () => MockClient(
          (_) async => http.Response('private-provider-data', 429),
        ),
      );
    },
  );
  test(
    'routes each purpose and locale to its published alias with English fallback',
    () async {
      for (final sample in [
        ('registration', 'en', 'poodle-registration-en'),
        ('registration', 'uk', 'poodle-registration-uk'),
        ('reset', 'en', 'poodle-password-reset-en'),
        ('reset', 'uk', 'poodle-password-reset-uk'),
        ('email', 'en', 'poodle-email-change-en'),
        ('email', 'uk', 'poodle-email-change-uk'),
        ('reset', 'fr', 'poodle-password-reset-en'),
      ]) {
        await http.runWithClient(
          () => ResendEmailSender(apiKey: 'test', from: 'accounts@poodle.ink')
              .sendCode(
                email: 'user@example.test',
                code: '12345678',
                purpose: sample.$1,
                requestId: '1',
                locale: sample.$2,
                expiresAt: DateTime.utc(2026, 11, 15, 12, 15),
              ),
          () => MockClient((request) async {
            expect(
              (jsonDecode(request.body)['template'] as Map)['id'],
              sample.$3,
            );
            return http.Response('{"id":"sent"}', 200);
          }),
        );
      }
    },
  );
  test(
    'sends the published reset template with a leading-zero code and UTC deadline',
    () async {
      await http.runWithClient(
        () =>
            ResendEmailSender(
              apiKey: 'test-secret',
              from: 'Poodle <accounts@poodle.ink>',
            ).sendCode(
              email: 'user@example.test',
              code: '01234567',
              purpose: 'reset',
              requestId: 'request-1',
              locale: 'uk',
              expiresAt: DateTime.parse('2026-11-15T14:15:00+02:00'),
            ),
        () => MockClient((request) async {
          expect(request.url.toString(), 'https://api.resend.com/emails');
          expect(request.method, 'POST');
          expect(request.headers['authorization'], 'Bearer test-secret');
          expect(jsonDecode(request.body), {
            'from': 'Poodle <accounts@poodle.ink>',
            'to': ['user@example.test'],
            'template': {
              'id': 'poodle-password-reset-uk',
              'variables': {
                'CODE': '01234567',
                'EXPIRES_AT_UTC': '2026-11-15 12:15',
              },
            },
          });
          expect(
            request.headers['Idempotency-Key'],
            isNot(contains('01234567')),
          );
          return http.Response('{"id":"mail-1"}', 200);
        }),
      );
    },
  );
}
