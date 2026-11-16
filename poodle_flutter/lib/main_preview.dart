import 'package:flutter/material.dart';
import 'app/poodle_app.dart';
import 'app/preview_scenarios.dart';
import 'data/repositories/onboarding_repository.dart';
import 'data/repositories/dashboard_repository.dart';
import 'data/services/onboarding_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const scenario = String.fromEnvironment(
    'PREVIEW_SCENARIO',
    defaultValue: 'normal',
  );
  const freshTour = bool.fromEnvironment('ONBOARDING_PREVIEW');
  const dashboardScenario = String.fromEnvironment(
    'DASHBOARD_PREVIEW_SCENARIO',
    defaultValue: 'normal',
  );
  runApp(
    PoodleApp(
      dashboardRepository: FakeDashboardRepository(
        scenario: parseDashboardPreviewScenario(dashboardScenario),
      ),
      onboardingRepository: freshTour || scenario != 'normal'
          ? OnboardingRepository(MemoryOnboardingStore(completed: !freshTour))
          : null,
      repository: createPreviewRepository(scenario),
    ),
  );
}
