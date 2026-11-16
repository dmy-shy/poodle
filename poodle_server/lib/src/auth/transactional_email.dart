import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'resend_email_sender.dart';

/// Minimal server-side transactional sender. Credentials stay in Serverpod
/// passwords and are never available to Flutter clients.
typedef MailDelivery =
    Future<void> Function({
      required String email,
      required String subject,
      required String text,
      required String key,
    });

abstract final class TransactionalEmail {
  /// External delivery adapter, honored only by test-mode sessions.
  static MailDelivery? testDelivery;
  static String? get actionOrigin => _actionOrigin;
  static String? _resendApiKey;
  static String? _from;
  static String? _actionOrigin;

  static bool get configured =>
      _resendApiKey != null &&
      _resendApiKey!.isNotEmpty &&
      _from != null &&
      _from!.isNotEmpty;

  static void configure({
    String? resendApiKey,
    String? from,
    String? actionOrigin,
  }) {
    _resendApiKey = resendApiKey?.trim();
    _from = from?.trim();
    _actionOrigin = actionOrigin?.trim();
  }

  static Future<void> sendCode(
    Session session, {
    required String email,
    required String code,
    required String purpose,
    String? requestId,
    String locale = 'en',
    DateTime? expiresAt,
  }) async {
    final subject = locale == 'uk'
        ? 'Код підтвердження Poodle'
        : 'Your Poodle verification code';
    final action = switch (purpose) {
      'reset' => locale == 'uk' ? 'скинути пароль' : 'reset your password',
      _ => locale == 'uk' ? 'підтвердити адресу' : 'verify your email address',
    };
    final administratorRequest = purpose == 'administratorRequest';
    final link =
        administratorRequest || requestId == null || _actionOrigin == null
        ? null
        : '${_actionOrigin!.replaceFirst(RegExp(r'/$'), '')}/account-actions/$purpose'
              '#request=$requestId&code=$code&locale=$locale';
    final body = locale == 'uk'
        ? 'Ваш код, щоб $action: $code. Він дійсний 15 хвилин.'
        : 'Your code to $action is $code. It expires in 15 minutes.';
    if (purpose == 'registration' ||
        purpose == 'reset' ||
        purpose == 'email' ||
        administratorRequest) {
      if (requestId == null || expiresAt == null) {
        throw ArgumentError(
          'Template delivery requires request ID and expiry.',
        );
      }
      if (session.serverpod.runMode == ServerpodRunMode.test &&
          testDelivery != null) {
        return testDelivery!(
          email: email,
          subject: subject,
          text: body,
          key: 'poodle-$purpose-$requestId',
        );
      }
      if (!configured) {
        if (session.serverpod.runMode == ServerpodRunMode.development) {
          session.log('Development email to $email: $subject\n$body');
          return;
        }
        throw StateError('Transactional email is not configured.');
      }
      return ResendEmailSender(apiKey: _resendApiKey!, from: _from!).sendCode(
        email: email,
        code: code,
        purpose: purpose,
        requestId: requestId,
        expiresAt: expiresAt,
        locale: locale,
      );
    }
    await sendMessage(
      session,
      email: email,
      subject: subject,
      text: [body, link].nonNulls.join('\n\n'),
      key: 'poodle-$purpose-${requestId ?? code}',
    );
  }

  static Future<void> sendMessage(
    Session session, {
    required String email,
    required String subject,
    required String text,
    required String key,
  }) async {
    if (session.serverpod.runMode == ServerpodRunMode.test &&
        testDelivery != null) {
      return testDelivery!(
        email: email,
        subject: subject,
        text: text,
        key: key,
      );
    }
    if (_resendApiKey == null ||
        _resendApiKey!.isEmpty ||
        _from == null ||
        _from!.isEmpty) {
      if (session.serverpod.runMode == ServerpodRunMode.development) {
        session.log('Development email to $email: $subject\n$text');
        return;
      }
      throw StateError('Transactional email is not configured.');
    }
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.postUrl(
        Uri.parse('https://api.resend.com/emails'),
      );
      request.headers
        ..set(HttpHeaders.authorizationHeader, 'Bearer $_resendApiKey')
        ..set(HttpHeaders.contentTypeHeader, 'application/json')
        ..set('Idempotency-Key', key);
      request.add(
        utf8.encode(
          jsonEncode({
            'from': _from,
            'to': [email],
            'subject': subject,
            'text': text,
          }),
        ),
      );
      final response = await request.close().timeout(
        const Duration(seconds: 10),
      );
      await response.drain<void>();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Resend rejected transactional email: ${response.statusCode}',
        );
      }
    } finally {
      client.close(force: true);
    }
  }
}
