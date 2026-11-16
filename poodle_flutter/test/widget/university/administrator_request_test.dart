import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/institution_repository.dart';
import 'package:poodle_flutter/features/university/presentation/views/administrator_request_screen.dart';
import 'package:poodle_flutter/features/university/presentation/view_models/administrator_request_view_model.dart';

class Requests extends InstitutionRepository {
  Map<String, String>? submitted;
  String? verified;
  int sent = 0;
  bool invalidCode = false;
  String? verifiedRequest;
  @override
  Future<String> requestAdministrator(Map<String, String> fields) async {
    submitted = fields;
    sent++;
    return sent == 1 ? 'request-id' : 'request-id-$sent';
  }

  @override
  Future<void> verifyAdministrator(String id, String code) async {
    verifiedRequest = id;
    if (invalidCode) throw const InstitutionProblem('invalidCode');
    verified = code;
  }
}

void main() {
  testWidgets(
    'expired code can be replaced and email can be corrected without losing the form',
    (tester) async {
      final repository = Requests()..invalidCode = true;
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AdministratorRequestViewModel(repository),
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AdministratorRequestScreen(),
          ),
        ),
      );
      for (final field in {
        'name': 'Olena',
        'email': 'old@example.test',
        'university': 'Volyn University',
        'position': 'Coordinator',
      }.entries) {
        await tester.enterText(
          find.byKey(ValueKey('request-${field.key}')),
          field.value,
        );
      }
      await tester.ensureVisible(find.text('Send verification code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send verification code'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('request-code')),
        '11111111',
      );
      await tester.tap(find.text('Verify email'));
      await tester.pumpAndSettle();
      expect(
        find.text('The code is invalid or expired. Request a new code.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Request another code'));
      await tester.pumpAndSettle();
      expect(repository.sent, 2);
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('request-code')))
            .controller!
            .text,
        isEmpty,
      );
      await tester.tap(find.text('Change email'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('request-university')),
            )
            .controller!
            .text,
        'Volyn University',
      );
      await tester.enterText(
        find.byKey(const ValueKey('request-email')),
        'correct@example.test',
      );
      await tester.ensureVisible(find.text('Send verification code'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send verification code'));
      await tester.pumpAndSettle();
      repository.invalidCode = false;
      await tester.enterText(
        find.byKey(const ValueKey('request-code')),
        '22222222',
      );
      await tester.tap(find.text('Verify email'));
      await tester.pumpAndSettle();
      expect(repository.submitted!['email'], 'correct@example.test');
      expect(repository.verifiedRequest, 'request-id-3');
      expect(find.text('Your request is awaiting review.'), findsOneWidget);
    },
  );

  testWidgets('administrator verifies email before request reaches review', (
    tester,
  ) async {
    final repository = Requests();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AdministratorRequestViewModel(repository),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AdministratorRequestScreen(),
        ),
      ),
    );
    for (final field in {
      'name': 'Olena',
      'email': 'olena@example.test',
      'university': 'Volyn University',
      'position': 'IT coordinator',
    }.entries) {
      await tester.enterText(
        find.byKey(ValueKey('request-${field.key}')),
        field.value,
      );
    }
    await tester.ensureVisible(find.text('Send verification code'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send verification code'));
    await tester.pumpAndSettle();
    expect(repository.submitted?['locale'], 'en');
    expect(find.text('Your request is awaiting review.'), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('request-code')),
      '12345678',
    );
    await tester.tap(find.text('Verify email'));
    await tester.pumpAndSettle();
    expect(repository.verified, '12345678');
    expect(find.text('Your request is awaiting review.'), findsOneWidget);
  });
}
