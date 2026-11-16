import '../data/repositories/auth_repository.dart';
import '../data/repositories/fake_auth_repository.dart';

/// Select with `--dart-define=PREVIEW_SCENARIO=name`; never inferred from credentials.
FakeAuthRepository createPreviewRepository(
  String scenario, {
  Duration latency = const Duration(milliseconds: 700),
}) {
  return switch (scenario) {
    'normal' => FakeAuthRepository(latency: latency),
    'invalidCredentials' => FakeAuthRepository(
      latency: latency,
      emailFailure: AuthFailure.invalidCredentials,
    ),
    'networkFailure' => FakeAuthRepository(
      latency: latency,
      emailFailure: AuthFailure.network,
      googleFailure: AuthFailure.network,
      resetFailure: AuthFailure.network,
    ),
    'googleCancelled' => FakeAuthRepository(
      latency: latency,
      cancelGoogle: true,
    ),
    'resetFailure' => FakeAuthRepository(
      latency: latency,
      resetFailure: AuthFailure.network,
    ),
    'restoredSession' => FakeAuthRepository(
      latency: latency,
      restoredSession: const AuthSession('learner@example.com'),
    ),
    _ => throw ArgumentError.value(
      scenario,
      'PREVIEW_SCENARIO',
      'Unknown preview scenario',
    ),
  };
}
