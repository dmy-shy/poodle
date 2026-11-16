import '../features/university/university_routes.dart';
import '../data/repositories/institution_repository.dart';
import '../data/repositories/admin_overview_repository.dart';
import '../features/dashboard/presentation/views/live_home_screen.dart';
import '../features/dashboard/presentation/view_models/live_home_view_model.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/repositories/search_repository.dart';
import '../features/search/presentation/views/search_screen.dart';
import '../features/search/presentation/view_models/search_view_model.dart';
import '../data/repositories/teaching_repository.dart';
import '../data/repositories/student_tasks_repository.dart';
import '../data/repositories/student_grades_repository.dart';
import '../data/repositories/my_files_repository.dart';
import '../data/repositories/messaging_repository.dart';
import '../features/messaging/presentation/views/messaging_screen.dart';
import '../features/messaging/presentation/view_models/messaging_view_model.dart';
import '../features/my_files/presentation/views/my_files_screen.dart';
import '../features/tasks/presentation/views/student_tasks_screen.dart';
import '../features/grades/presentation/views/student_grades_screen.dart';
import '../features/teaching/presentation/views/teacher_workspace.dart';
import '../features/teaching/presentation/views/teaching_editor.dart';
import '../features/teaching/presentation/views/teaching_activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../data/repositories/settings_repository.dart';
import '../features/settings/presentation/view_models/settings_view_model.dart';
import '../features/settings/presentation/views/settings_screen.dart';
import '../features/settings/presentation/views/synchronisation_screen.dart';
import '../features/settings/presentation/views/space_usage_screen.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/dashboard_repository.dart';
import '../data/repositories/onboarding_repository.dart';
import '../data/repositories/course_repository.dart';
import '../data/repositories/notebook_repository.dart';
import '../data/repositories/notifications_repository.dart';
import '../features/notifications/presentation/views/notifications_screen.dart';
import '../features/messaging/presentation/widgets/incoming_message_banner.dart';
import '../features/notifications/presentation/view_models/notifications_view_model.dart';
import '../features/notebook/presentation/views/notebook_screen.dart';
import '../features/notebook/presentation/views/notebook_settings_screen.dart';
import '../features/notebook/presentation/view_models/notebook_settings_view_model.dart';
import '../features/notebook/presentation/view_models/notebook_view_model.dart';
import '../data/repositories/calendar_repository.dart';
import '../features/calendar/presentation/views/calendar_screen.dart';
import '../data/services/course_file_service.dart';
import '../data/services/course_download_service.dart';
import '../data/services/sync_coordinator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../features/courses/presentation/view_models/course_view_model.dart';
import '../features/courses/presentation/views/course_screen.dart';
import '../features/courses/presentation/views/course_browser_screen.dart';
import '../features/courses/presentation/widgets/course_web_view.dart';
import '../data/services/onboarding_store.dart';
import '../features/onboarding/presentation/view_models/onboarding_view_model.dart';
import '../features/onboarding/presentation/views/onboarding_screen.dart';
import '../features/auth/presentation/view_models/login_view_model.dart';
import '../features/auth/presentation/view_models/splash_view_model.dart';
import '../features/auth/presentation/views/login_screen.dart';
import '../features/auth/presentation/views/splash_screen.dart';
import '../features/auth/presentation/views/auth_recovery_screen.dart';
import '../features/auth/presentation/views/verification_screen.dart';
import '../features/auth/presentation/view_models/verification_view_model.dart';
import '../features/account/presentation/views/profile_screen.dart';
import '../features/help/presentation/views/help_screen.dart';
import '../features/account/presentation/view_models/account_view_model.dart';
import '../features/dashboard/presentation/view_models/dashboard_view_model.dart';
import '../features/dashboard/presentation/views/dashboard_screen.dart';
import '../features/dashboard/presentation/dashboard_copy.dart';
import '../features/auth/quotes.dart';
import '../ui/theme/poodle_theme.dart';
import 'l10n/app_localizations.dart';
import 'system_locale.dart';
import 'preview_destinations.dart';
import 'signed_in_shell.dart';
import 'route_error_screen.dart';
import 'ios_navigation_bar.dart';

part 'poodle_routes.dart';
part 'poodle_session.dart';

/// The composition root. The caller owns the injected repository's lifetime.
class PoodleApp extends StatefulWidget {
  const PoodleApp({
    super.key,
    required this.repository,
    this.dashboardRepository,
    this.institutionRepository,
    this.adminOverviewRepository,
    this.onboardingRepository,
    this.courseRepository,
    this.notebookRepository,
    this.notificationsRepository,
    this.teachingRepository,
    this.studentTasksRepository,
    this.studentGradesRepository,
    this.myFilesRepository,
    this.messagingRepository,
    this.searchRepository,
    this.calendarRepository,
    this.courseWebViewBuilder,
    this.minimumSplashDuration = const Duration(seconds: 2),
    this.selectQuote,
    this.settingsRepository,
    this.loadAppVersion,
  });
  final AuthRepository repository;
  final InstitutionRepository? institutionRepository;
  final DashboardRepository? dashboardRepository;
  final AdminOverviewRepository? adminOverviewRepository;
  final OnboardingRepository? onboardingRepository;
  final CourseRepository? courseRepository;
  final NotebookRepository? notebookRepository;
  final NotificationsRepository? notificationsRepository;
  final TeachingRepository? teachingRepository;
  final StudentTasksRepository? studentTasksRepository;
  final StudentGradesRepository? studentGradesRepository;
  final MyFilesRepository? myFilesRepository;
  final MessagingRepository? messagingRepository;
  final SearchRepository? searchRepository;
  final CalendarRepository? calendarRepository;
  final CourseWebViewBuilder? courseWebViewBuilder;
  final Duration minimumSplashDuration;
  final SplashQuoteId Function()? selectQuote;
  final SettingsRepository? settingsRepository;
  final Future<String> Function()? loadAppVersion;
  @override
  State<PoodleApp> createState() => _PoodleAppState();
}

class _PoodleAppState extends State<PoodleApp> with WidgetsBindingObserver {
  late final CourseRepository _courses =
      widget.courseRepository ??
      (widget.repository.isPreview
          ? PreviewCourseRepository()
          : _UnavailableCourses());
  late final CalendarRepository _calendar =
      widget.calendarRepository ??
      CalendarRepository(_courses, preview: widget.repository.isPreview);
  final _files = CourseFileService();
  late final _downloads = CourseDownloadService(
    courses: _courses,
    files: _files,
    namespace: _courses.cacheNamespace ?? 'preview',
  );
  late final SettingsViewModel _settings = SettingsViewModel(
    widget.settingsRepository ??
        (widget.repository.isPreview
            ? MemorySettingsRepository()
            : PreferencesSettingsRepository()),
  );
  String? _account;
  final ValueNotifier<int?> _pendingRequestCount = ValueNotifier(null);
  Future<void> _refreshPendingRequestCount() async {
    final account = widget.repository.session?.userId;
    final source = widget.institutionRepository;
    if (account == null ||
        widget.repository.session?.isAdmin != true ||
        source == null) {
      _pendingRequestCount.value = null;
      return;
    }
    try {
      final count = await source.pendingRequestCount();
      if (mounted && widget.repository.session?.userId == account) {
        _pendingRequestCount.value = count;
      }
    } catch (_) {
      if (mounted && widget.repository.session?.userId == account) {
        _pendingRequestCount.value = null;
      }
    }
  }

  StreamSubscription<List<ConnectivityResult>>? _connectivity;
  late final SyncCoordinator _sync = SyncCoordinator({
    SyncArea.courses: () async {
      final courses = await _courses.list();
      if (_courses.listIsStale) return false;
      if (!widget.repository.isPreview && !kIsWeb) {
        await _downloads.reconcileInventory(courses);
      }
      return true;
    },
    SyncArea.calendar: () async {
      final snapshot = await _calendar.load(refresh: true);
      return snapshot != null && !snapshot.stale;
    },
    if (widget.notificationsRepository case final notifications?)
      SyncArea.notifications: () async {
        await notifications.list(offset: 0, limit: 20);
        await notifications.unreadCount();
        return !notifications.isStale;
      },
  });

  void _downloadSettingsChanged() {
    if (!widget.repository.isPreview && !kIsWeb) {
      _downloads.wifiOnlyDownloads = _settings.settings.wifiOnlyDownloads;
    }
  }

  late final _onboarding =
      widget.onboardingRepository ??
      OnboardingRepository(PreferencesOnboardingStore());
  late final DashboardRepository _dashboard =
      widget.dashboardRepository ?? FakeDashboardRepository();
  late final _splash = SplashViewModel(
    widget.repository,
    minimumDuration: widget.minimumSplashDuration,
    selectQuote: widget.selectQuote,
  );
  String? _pendingAuthLink;
  late final GoRouter _router = _buildRouter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!widget.repository.isPreview) {
      _connectivity = Connectivity().onConnectivityChanged.listen((results) {
        if (_account != null && !results.contains(ConnectivityResult.none)) {
          unawaited(_sync.refresh());
        }
      });
    }
    _settings.addListener(_downloadSettingsChanged);
    widget.repository.addListener(_accountChanged);
    // Also clean leftovers when startup remains signed out.
    unawaited(_files.reset(null).catchError((_) {}));
    _accountChanged();
    unawaited(_splash.start());
    unawaited(_onboarding.load());
    unawaited(_settings.load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_connectivity?.cancel());
    _sync.dispose();
    _settings.removeListener(_downloadSettingsChanged);
    widget.repository.removeListener(_accountChanged);
    _router.dispose();
    _splash.dispose();
    if (widget.onboardingRepository == null) _onboarding.dispose();
    if (widget.courseRepository == null) _courses.dispose();
    if (widget.calendarRepository == null) _calendar.dispose();
    _settings.dispose();
    _pendingRequestCount.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _account != null &&
        !widget.repository.isPreview) {
      unawaited(_sync.refresh());
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) => ChangeNotifierProvider<SettingsViewModel>.value(
    value: _settings,
    child: AnimatedBuilder(
      animation: _settings,
      builder: (context, _) => ChangeNotifierProvider<AuthRepository>.value(
        value: widget.repository,
        child: ChangeNotifierProvider<CalendarRepository>.value(
          value: _calendar,
          child: ChangeNotifierProvider<TeachingRepository?>.value(
            value: widget.teachingRepository,
            child: MaterialApp.router(
              title: 'Poodle',
              debugShowCheckedModeBanner: false,
              theme: PoodleTheme.build(),
              themeMode: ThemeMode.light,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: _settings.settings.language == 'system'
                  ? null
                  : Locale(_settings.settings.language),
              localeListResolutionCallback: (locales, _) =>
                  resolveSystemLocale(locales?.firstOrNull),
              builder: (context, child) {
                final factor = switch (_settings.settings.textSize) {
                  1 => 1.15,
                  2 => 1.30,
                  _ => 1.0,
                };
                final systemScale = MediaQuery.textScalerOf(context).scale(1.0);
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(systemScale * factor),
                  ),
                  child:
                      widget.messagingRepository != null ||
                          widget.notificationsRepository != null
                      ? IncomingMessageBanner(
                          repository: widget.messagingRepository,
                          notifications: widget.notificationsRepository,
                          onOpenNotifications: () =>
                              _router.go('/notifications'),
                          onPoll: _refreshPendingRequestCount,
                          onOpenRequest: (item) {
                            unawaited(
                              widget.notificationsRepository
                                      ?.markRead(item.id)
                                      .catchError((_) {}) ??
                                  Future.value(),
                            );
                            _router.push(
                              '/more/university-requests?requestId=${item.requestId}',
                            );
                          },
                          auth: widget.repository,
                          currentPath: () =>
                              _router.routeInformationProvider.value.uri.path,
                          onOpen: (conversation) => _router.go(
                            '/messages/${conversation.id}',
                            extra: conversation,
                          ),
                          child: child ?? const SizedBox.shrink(),
                        )
                      : child ?? const SizedBox.shrink(),
                );
              },
              routerConfig: _router,
            ),
          ),
        ),
      ),
    ),
  );
}

class _UnavailableCourses extends CourseRepository {
  @override
  Future<List<CourseInfo>> list() async => throw CourseFailure.unavailable;
  @override
  Future<CourseContent> content(String id) async =>
      throw CourseFailure.unavailable;
  @override
  Future<CourseActivity> activity(String courseId, String id) async =>
      throw CourseFailure.unavailable;
  @override
  Future<FileAccess> file(String courseId, String id) async =>
      throw CourseFailure.unavailable;
}
