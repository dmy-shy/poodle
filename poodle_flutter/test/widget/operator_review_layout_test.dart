import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/institution_repository.dart';
import 'package:poodle_flutter/features/university/presentation/view_models/operator_review_view_model.dart';
import 'package:poodle_flutter/features/university/presentation/views/operator_review_screen.dart';

class _Requests extends InstitutionRepository {
  @override
  Future<List<AdministratorRequest>> requests(int offset) async => const [
    AdministratorRequest(
      id: 'one',
      name: 'Dmytro VNU',
      email: 'request@example.test',
      university: 'VNU',
      position: 'Head of University',
      note: '',
      status: 'pending',
    ),
  ];

  @override
  Future<List<UniversityOption>> universities() async => [];
}

void main() {
  testWidgets('review card keeps controls separated on a narrow phone', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final model = OperatorReviewViewModel(_Requests())..load();
    addTearDown(model.dispose);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: model,
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.3),
            ),
            child: child!,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const OperatorReviewScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Applicant'), findsOneWidget);
    expect(find.text('Review decision'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Approve and invite'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
