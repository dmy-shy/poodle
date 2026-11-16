import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/services/course_link_policy.dart';

void main() {
  test('allows complete HTTPS destinations with paths and fragments', () {
    expect(
      courseLinkUri('https://docs.flutter.dev/learn?lang=uk#start'),
      Uri.parse('https://docs.flutter.dev/learn?lang=uk#start'),
    );
  });

  test('rejects malformed destinations, credentials and other schemes', () {
    for (final value in [
      null,
      '',
      'https://',
      '/learn',
      'http://example.com',
      'javascript:alert(1)',
      'file:///private/document',
      'poodle://courses',
      'mailto:hello@example.com',
      'https://user:secret@example.com',
      'https://exa mple.com',
      'https://example.com:bad',
      'https://example.com:99999',
      '\nhttps://example.com',
    ]) {
      expect(courseLinkUri(value), isNull, reason: '$value');
    }
  });
}
