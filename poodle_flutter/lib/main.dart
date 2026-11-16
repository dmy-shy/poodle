import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/l10n/app_localizations.dart';
import 'app/poodle_app.dart';
import 'app/system_locale.dart';
import 'client.dart';
import 'firebase_initialization.dart';
import 'push_registration.dart';
import 'ui/theme/poodle_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseReady = await initializeMobileFirebase();
  if (firebaseReady &&
      !kIsWeb &&
      defaultTargetPlatform == TargetPlatform.android) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(startAndroidPushRegistration());
    });
  }
  runApp(const _LiveApplication());
}

class _LiveApplication extends StatefulWidget {
  const _LiveApplication();

  @override
  State<_LiveApplication> createState() => _LiveApplicationState();
}

class _LiveApplicationState extends State<_LiveApplication> {
  late Future<LiveAppDependencies> _initialization;
  LiveAppDependencies? _repository;

  @override
  void initState() {
    super.initState();
    _initialization = _initialize();
  }

  Future<LiveAppDependencies> _initialize() async {
    final repository = await createLiveAppDependencies();
    if (!mounted) {
      repository.dispose();
      throw StateError('Application closed.');
    }
    _repository = repository;
    return repository;
  }

  @override
  void dispose() {
    _repository?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<LiveAppDependencies>(
    future: _initialization,
    builder: (_, snapshot) {
      if (snapshot.data case final repository?) {
        return PoodleApp(
          repository: repository.auth,
          institutionRepository: repository.institutions,
          adminOverviewRepository: repository.adminOverview,
          courseRepository: repository.courses,
          notebookRepository: repository.notebooks,
          notificationsRepository: repository.notifications,
          teachingRepository: repository.teaching,
          studentTasksRepository: repository.studentTasks,
          studentGradesRepository: repository.studentGrades,
          myFilesRepository: repository.myFiles,
          messagingRepository: repository.messaging,
          searchRepository: repository.search,
        );
      }
      return MaterialApp(
        theme: PoodleTheme.build(),
        themeMode: ThemeMode.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        localeListResolutionCallback: (locales, _) =>
            resolveSystemLocale(locales?.firstOrNull),
        home: Builder(
          builder: (context) {
            final text = AppLocalizations.of(context);
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: snapshot.hasError
                      ? Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(text.authRecoveryTitle),
                              Text(text.authUnavailable),
                              FilledButton(
                                onPressed: () => setState(
                                  () => _initialization = _initialize(),
                                ),
                                child: Text(text.authRetry),
                              ),
                            ],
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
