import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

/// Sends server-generated verification values through published Resend templates.
class ResendEmailSender {
  ResendEmailSender({
    required this.apiKey,
    required this.from,
    this.timeout = const Duration(seconds: 10),
  });

  final String apiKey;
  final String from;
  final Duration timeout;

  Future<void> sendCode({
    required String email,
    required String code,
    required String purpose,
    required String requestId,
    required DateTime expiresAt,
    String locale = 'en',
  }) async {
    final templatePurpose = switch (purpose) {
      'registration' => 'registration',
      'reset' => 'password-reset',
      'email' => 'email-change',
      'administratorRequest' => 'administrator-request',
      _ => throw ArgumentError.value(
        purpose,
        'purpose',
        'Unsupported template',
      ),
    };
    final deadline = expiresAt.toUtc();
    String two(int value) => value.toString().padLeft(2, '0');
    final expiry =
        '${deadline.year}-${two(deadline.month)}-${two(deadline.day)} '
        '${two(deadline.hour)}:${two(deadline.minute)}';
    final body = jsonEncode({
      'from': from,
      'to': [email],
      'template': {
        'id': 'poodle-$templatePurpose-${locale == 'uk' ? 'uk' : 'en'}',
        'variables': {'CODE': code, 'EXPIRES_AT_UTC': expiry},
      },
    });
    final key = Hmac(
      sha256,
      utf8.encode(apiKey),
    ).convert(utf8.encode('$requestId:$body'));
    final client = http.Client();
    try {
      final response = await client
          .post(
            Uri.parse('https://api.resend.com/emails'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
              'Idempotency-Key': 'poodle-code-$key',
            },
            body: body,
          )
          .timeout(timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw StateError(
          'Resend rejected transactional email: ${response.statusCode}',
        );
      }
    } finally {
      client.close();
    }
  }
}
