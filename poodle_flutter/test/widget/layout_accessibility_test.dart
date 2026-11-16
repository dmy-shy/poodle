import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/features/auth/presentation/view_models/login_view_model.dart';
import 'package:poodle_flutter/features/auth/presentation/views/login_screen.dart';
import '../support/test_app.dart';

void main() {
  for (final variant in [
    (
      size: const Size(390, 844),
      locale: const Locale('en'),
      scale: 1.0,
      keyboard: 0.0,
    ),
    (
      size: const Size(320, 568),
      locale: const Locale('uk'),
      scale: 2.0,
      keyboard: 200.0,
    ),
    (
      size: const Size(844, 390),
      locale: const Locale('en'),
      scale: 2.0,
      keyboard: 160.0,
    ),
    (
      size: const Size(768, 1024),
      locale: const Locale('uk'),
      scale: 2.0,
      keyboard: 0.0,
    ),
  ]) {
    testWidgets(
      'login remains usable at ${variant.size}, ${variant.locale}, ${variant.scale}x',
      (tester) async {
        tester.view.physicalSize = variant.size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repository = FakeAuthRepository(latency: Duration.zero);
        final model = LoginViewModel(repository);
        addTearDown(model.dispose);
        addTearDown(repository.dispose);
        final semantics = tester.ensureSemantics();
        try {
          await tester.pumpWidget(
            testApp(
              MediaQuery(
                data: MediaQueryData(
                  size: variant.size,
                  textScaler: TextScaler.linear(variant.scale),
                  viewInsets: EdgeInsets.only(bottom: variant.keyboard),
                ),
                child: ChangeNotifierProvider.value(
                  value: model,
                  child: const LoginScreen(),
                ),
              ),
              locale: variant.locale,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          final button = find.text(
            variant.locale.languageCode == 'uk' ? 'Увійти' : 'Log in',
          );
          await tester.ensureVisible(button);
          await tester.pumpAndSettle();
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await tester.tap(button);
          await tester.pumpAndSettle();
          expect(
            find.text(
              variant.locale.languageCode == 'uk'
                  ? 'Уведіть пароль.'
                  : 'Enter your password.',
            ),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
        } finally {
          semantics.dispose();
        }
      },
    );
  }
}
