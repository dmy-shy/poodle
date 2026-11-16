import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/teaching_repository.dart';
import 'package:poodle_flutter/data/repositories/institution_repository.dart';
import 'package:poodle_flutter/features/teaching/presentation/views/teacher_workspace.dart';
import 'package:poodle_flutter/features/teaching/presentation/views/teaching_editor.dart';

class _Teaching extends TeachingRepository {
  TeachingSaveInput? saved;
  @override
  Future<List<TeachingCourseView>> dashboard() async => [];
  @override
  Future<List<TeachingActivityView>> activities(String course) async => [];
  @override
  Future<List<TeachingMemberView>> members(String course) async => [
    TeachingMemberView(
      id: UuidValue.withValidation('019a0acf-0000-7000-8000-000000000004'),
      label: 'teacher@example.test',
      role: 'teacher',
    ),
    TeachingMemberView(
      id: UuidValue.withValidation('019a0acf-0000-7000-8000-000000000003'),
      label: 'student@example.test',
      role: 'student',
    ),
  ];
  @override
  Future<TeachingSettings> defaults([TeachingSettings? value]) async =>
      value ?? TeachingSettings(title: '', instructions: '');
  @override
  Future<List<({String id, String title})>> sections(String course) async => [
    (id: '019a0acf-0000-7000-8000-000000000002', title: 'Materials'),
  ];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Invitations extends InstitutionRepository {
  String? invitedEmail;
  String? courseId;

  @override
  Future<void> invite(String email, String purpose, {String? courseId}) async {
    invitedEmail = email;
    this.courseId = courseId;
  }
}

Widget app(
  TeachingRepository repo,
  Widget child, {
  Locale locale = const Locale('en'),
  double scale = 1,
}) => ChangeNotifierProvider<TeachingRepository?>.value(
  value: repo,
  child: ChangeNotifierProvider<AuthRepository>(
    create: (_) => FakeAuthRepository(
      restoredSession: const AuthSession('teacher@example.test'),
    ),
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: child,
    ),
  ),
);
void main() {
  testWidgets('workspace exposes authoring, gradebook and authorized roster', (
    tester,
  ) async {
    final repo = _Teaching()..bindAccount('teacher');
    final invitations = _Invitations();
    final branch = GlobalKey<NavigatorState>();
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.padding = const FakeViewPadding(bottom: 34);
    tester.view.viewPadding = const FakeViewPadding(bottom: 34);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewPadding);
    await tester.pumpWidget(
      app(
        repo,
        Navigator(
          key: branch,
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => TeacherWorkspace(
              courseId: '019a0acf-0000-7000-8000-000000000001',
              institutionRepository: invitations,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Create'));
    await tester.pumpAndSettle();
    expect(find.text('Create assignment'), findsOneWidget);
    expect(find.text('Create test'), findsOneWidget);
    final createTest = find.widgetWithText(ListTile, 'Create test');
    final sheetContext = tester.element(createTest);
    final sheetNavigator = Navigator.of(sheetContext);
    expect(
      sheetNavigator,
      same(Navigator.of(sheetContext, rootNavigator: true)),
    );
    expect(sheetNavigator, isNot(same(branch.currentState)));
    expect(
      tester.getBottomLeft(createTest).dy,
      lessThanOrEqualTo(
        tester.view.physicalSize.height / tester.view.devicePixelRatio - 34,
      ),
    );
    sheetNavigator.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tests'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Students'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Students'));
    await tester.pumpAndSettle();
    expect(find.text('student@example.test'), findsOneWidget);
    expect(find.text('teacher@example.test'), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('student-invite-email')),
      'newstudent@example.test',
    );
    await tester.ensureVisible(find.text('Invite student'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Invite student'));
    await tester.pumpAndSettle();
    expect(invitations.invitedEmail, 'newstudent@example.test');
    expect(invitations.courseId, '019a0acf-0000-7000-8000-000000000001');
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'Ukrainian editor remains usable at large text on a narrow screen',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = _Teaching()..bindAccount('teacher');
      await tester.pumpWidget(
        app(
          repo,
          const TeachingEditor(
            courseId: '019a0acf-0000-7000-8000-000000000001',
            kind: 'test',
          ),
          locale: const Locale('uk'),
          scale: 2,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Створити тест'), findsOneWidget);
      expect(find.text('Назва'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
