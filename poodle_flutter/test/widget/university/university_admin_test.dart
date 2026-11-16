import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/institution_repository.dart';
import 'package:poodle_flutter/features/university/presentation/views/university_admin_screen.dart';
import 'package:poodle_flutter/features/university/presentation/view_models/university_admin_view_model.dart';

class University extends InstitutionRepository {
  String? invited, purpose;
  @override
  Future<List<UniversityMember>> members(int offset) async => [
    const UniversityMember('one', 'admin@example.test', true, false),
  ];
  @override
  Future<List<UniversityInvitation>> invitations(int offset) async => [];
  @override
  Future<void> invite(String email, String role, {String? courseId}) async {
    invited = email;
    purpose = role;
  }
}

void main() {
  testWidgets('university administrator invites a teacher with explicit role', (
    tester,
  ) async {
    final repository = University();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => UniversityAdminViewModel(repository)..load(),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const UniversityAdminScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('university-invite-email')),
      'teacher@example.test',
    );
    await tester.tap(find.text('Create invitation'));
    await tester.pumpAndSettle();
    expect(repository.invited, 'teacher@example.test');
    expect(repository.purpose, 'teacherCandidate');
    expect(
      find.text('Access updated or invitation queued for email delivery.'),
      findsOneWidget,
    );
  });
}
