import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/features/auth/presentation/view_models/login_view_model.dart';
import 'package:poodle_flutter/features/auth/presentation/views/login_screen.dart';
import 'package:poodle_flutter/features/auth/presentation/views/splash_screen.dart';
import '../support/load_fonts.dart';
import '../support/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadPreviewFonts);
  for (final locale in [const Locale('en'), const Locale('uk')]) {
    testWidgets('login baseline ${locale.languageCode} light', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 940);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repository = FakeAuthRepository(latency: Duration.zero);
      final model = LoginViewModel(repository);
      addTearDown(model.dispose);
      addTearDown(repository.dispose);
      await tester.pumpWidget(
        testApp(
          ChangeNotifierProvider.value(
            value: model,
            child: const LoginScreen(),
          ),
          locale: locale,
        ),
      );
      await tester.runAsync(
        () => precacheImage(
          const AssetImage('assets/images/mascot.png'),
          tester.element(find.byType(LoginScreen)),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile(
          'goldens/login_${locale.languageCode}_light.png',
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }
  for (final locale in [const Locale('en'), const Locale('uk')]) {
    testWidgets('splash baseline ${locale.languageCode} light', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        testApp(const SplashScreen(animate: false), locale: locale),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(SplashScreen),
        matchesGoldenFile('goldens/splash_${locale.languageCode}_light.png'),
      );
    });
  }
}
