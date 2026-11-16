import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/institution_repository.dart';
import 'package:poodle_flutter/features/university/presentation/views/operator_review_screen.dart';
import 'package:poodle_flutter/features/university/presentation/view_models/operator_review_view_model.dart';

class Review extends InstitutionRepository {
  String? rejected;
  @override
  Future<List<AdministratorRequest>> requests(int offset) async => [
    const AdministratorRequest(
      id: 'one',
      name: 'Olena',
      email: 'olena@example.test',
      university: 'Volyn University',
      position: 'IT coordinator',
      note: 'Contact our office',
      status: 'pending',
    ),
  ];
  @override
  Future<List<UniversityOption>> universities() async => [];
  @override
  Future<void> reject(String id, String reason) async {
    rejected = reason;
  }
}

void main() {
  testWidgets(
    'operator reads representative details and records rejection reason',
    (tester) async {
      final repository = Review();
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => OperatorReviewViewModel(repository)..load(),
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const OperatorReviewScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('olena@example.test'), findsOneWidget);
      expect(find.text('Position: IT coordinator'), findsOneWidget);
      final note = find.byKey(const ValueKey('review-note-one'));
      await tester.ensureVisible(note);
      await tester.pumpAndSettle();
      await tester.enterText(
        note,
        'Cannot verify university authority',
      );
      await tester.ensureVisible(find.text('Reject request'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reject request'));
      await tester.pumpAndSettle();
      expect(repository.rejected, 'Cannot verify university authority');
    },
  );
}
