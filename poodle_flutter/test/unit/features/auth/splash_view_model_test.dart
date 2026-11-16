import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/features/auth/quotes.dart';
import 'package:poodle_flutter/features/auth/presentation/view_models/splash_view_model.dart';

void main() {
  test(
    'launch selects one quote and becomes ready only after the minimum duration',
    () async {
      final gate = Completer<void>();
      final repository = FakeAuthRepository(latency: Duration.zero);
      var selections = 0;
      final model = SplashViewModel(
        repository,
        wait: (_) => gate.future,
        selectQuote: () {
          selections++;
          return SplashQuoteId.hope;
        },
      );
      addTearDown(model.dispose);
      addTearDown(repository.dispose);
      final pending = model.start();
      await model.start();
      expect(model.ready, isFalse);
      expect(model.quote, SplashQuoteId.hope);
      gate.complete();
      await pending;
      expect(model.ready, isTrue);
      expect(selections, 1);
    },
  );
}
