part of 'poodle_app.dart';

extension _PoodleRoutes on _PoodleAppState {
  Widget _searchRoute({bool pushed = false}) => ChangeNotifierProvider(
    create: (_) => SearchViewModel(
      widget.searchRepository ??
          PreviewSearchRepository(
            widget.repository.isPreview ? _courses : null,
          ),
      _courses,
      widget.repository,
    ),
    child: SearchScreen(pushed: pushed, preview: widget.repository.isPreview),
  );

  Widget _courseRoute(
    String basePath, {
    String? courseId,
    String? activityId,
    String? sectionId,
  }) => ChangeNotifierProvider(
    key: ValueKey('$basePath/$activityId'),
    create: (_) => CourseViewModel(
      _courses,
      courseId: courseId,
      activityId: activityId,
      files: _files,
      downloads: !widget.repository.isPreview && !kIsWeb ? _downloads : null,
    )..load(),
    child: CourseScreen(
      basePath: basePath,
      initialSection: sectionId,
      notebookAvailable: widget.notebookRepository != null,
    ),
  );

  GoRoute _courseDetailRoute(String prefix, String path) => GoRoute(
    path: path,
    builder: (_, state) => _courseRoute(
      '$prefix/${state.pathParameters['courseId']}',
      courseId: state.pathParameters['courseId'],
      sectionId: state.uri.queryParameters['section'],
    ),
    routes: [
      if (widget.teachingRepository != null)
        GoRoute(
          path: 'teaching',
          builder: (_, state) => TeacherWorkspace(
            courseId: state.pathParameters['courseId']!,
            institutionRepository: widget.institutionRepository,
            initialTab: state.uri.queryParameters['tab'] == 'students' ? 3 : 0,
          ),
        ),
      GoRoute(
        path: 'activity/:activityId',
        builder: (_, state) => _courseRoute(
          '$prefix/${state.pathParameters['courseId']}',
          courseId: state.pathParameters['courseId'],
          activityId: state.pathParameters['activityId'],
        ),
        routes: [
          if (widget.teachingRepository != null)
            GoRoute(
              path: 'work',
              builder: (_, state) => TeachingActivityScreen(
                courseId: state.pathParameters['courseId']!,
                activityId: state.pathParameters['activityId']!,
              ),
            ),
          _browserRoute(prefix),
          _notebookRoute(),
          _notebookSettingsRoute(),
        ],
      ),
    ],
  );

  GoRoute _notebookSettingsRoute() => GoRoute(
    path: 'notebook-settings',
    builder: (_, state) {
      final repository = widget.notebookRepository;
      if (repository == null) return const Scaffold(body: SizedBox.shrink());
      return ChangeNotifierProvider(
        create: (_) => NotebookSettingsViewModel(
          repository,
          state.pathParameters['courseId']!,
          state.pathParameters['activityId']!,
        )..load(),
        child: const NotebookSettingsScreen(),
      );
    },
  );

  GoRoute _notebookRoute() => GoRoute(
    path: 'notebook',
    builder: (_, state) {
      final repository = widget.notebookRepository;
      if (repository == null) return const Scaffold(body: SizedBox.shrink());
      return ChangeNotifierProvider(
        key: ValueKey(
          'notebook:${state.pathParameters['courseId']}:${state.pathParameters['activityId']}',
        ),
        create: (_) => NotebookViewModel(
          repository,
          state.pathParameters['courseId']!,
          state.pathParameters['activityId']!,
        )..load(),
        child: const NotebookScreen(),
      );
    },
  );

  GoRoute _browserRoute(String prefix) => GoRoute(
    path: 'browser',
    builder: (_, state) {
      final courseId = state.pathParameters['courseId']!;
      final activityId = state.pathParameters['activityId']!;
      return CourseBrowserScreen(
        repository: _courses,
        courseId: courseId,
        activityId: activityId,
        activityPath: '$prefix/$courseId/activity/$activityId',
        request: state.extra is CourseBrowserRequest
            ? state.extra as CourseBrowserRequest
            : null,
        webViewBuilder: widget.courseWebViewBuilder,
      );
    },
  );
  GoRouter _buildRouter() => GoRouter(
    initialLocation: '/splash',
    errorBuilder: (_, state) => RouteErrorScreen(
      notFound: state.error is GoException,
    ),
    refreshListenable: Listenable.merge([
      _splash,
      _onboarding,
      widget.repository,
    ]),
    redirect: (context, state) {
      final lifecycle = widget.repository.lifecycle;
      final isAuthLink =
          !widget.repository.isPreview &&
          const [
            '/join',
            '/reset',
            '/university/request',
          ].contains(state.matchedLocation);
      final target =
          !_splash.ready ||
              !_onboarding.ready ||
              lifecycle == AuthLifecycle.restoring ||
              lifecycle == AuthLifecycle.signingOut
          ? '/splash'
          : lifecycle == AuthLifecycle.unavailable
          ? '/auth-recovery'
          : widget.repository.session == null
          ? (_onboarding.completed ? '/login' : '/onboarding')
          : '/home';
      if (target == '/splash' && isAuthLink) {
        _pendingAuthLink = state.uri.toString();
      }
      if (target == '/login' || target == '/onboarding') {
        if (isAuthLink) {
          _pendingAuthLink = null;
          return null;
        }
        final pending = _pendingAuthLink;
        if (pending != null) {
          _pendingAuthLink = null;
          return pending;
        }
      }
      if (target == '/home') {
        _pendingAuthLink = null;
        if (widget.repository.isPreview &&
            state.matchedLocation == '/more/invitations') {
          return '/more';
        }
        if (state.matchedLocation == '/demo') return '/home';
        const roots = [
          '/home',
          '/courses',
          '/messages',
          '/notifications',
          '/more',
          '/calendar',
          '/search',
          '/profile',
          '/help',
          '/search-preview',
          '/search-content',
          '/search-result',
        ];
        if (roots.any(
          (root) =>
              state.matchedLocation == root ||
              state.matchedLocation.startsWith('$root/'),
        )) {
          return null;
        }
      }
      return state.matchedLocation == target ? null : target;
    },
    routes: [
      ...universityRoutes(
        auth: widget.repository,
        institutions: widget.institutionRepository,
        onCoursesChanged: () => unawaited(_sync.refresh()),
        courseEditingAvailable: widget.teachingRepository != null,
        onRequestReviewed: () => unawaited(_refreshPendingRequestCount()),
      ),
      GoRoute(
        path: '/auth-recovery',
        builder: (_, _) => const AuthRecoveryScreen(),
      ),
      for (final reset in [false, true])
        GoRoute(
          path: reset ? '/reset' : '/join',
          builder: (_, state) => ChangeNotifierProvider(
            create: (_) =>
                VerificationViewModel(widget.repository, reset: reset),
            child: VerificationScreen(
              initialEmail: state.uri.queryParameters['email'],
            ),
          ),
        ),
      GoRoute(
        path: '/onboarding',
        builder: (_, _) => ChangeNotifierProvider(
          create: (_) => OnboardingViewModel(),
          child: OnboardingScreen(onComplete: _onboarding.complete),
        ),
      ),
      GoRoute(
        path: '/splash',
        builder: (_, _) => SplashScreen(quote: _splash.quote),
      ),
      GoRoute(
        path: '/login',
        builder: (_, _) => ChangeNotifierProvider(
          create: (_) => LoginViewModel(widget.repository),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/demo',
        redirect: (_, _) => '/home',
      ),
      GoRoute(
        path: '/profile',
        builder: (_, _) => ChangeNotifierProvider(
          create: (_) => AccountViewModel(widget.repository)..load(),
          child: ProfileScreen(
            institutionAccess: widget.institutionRepository != null,
          ),
        ),
      ),
      GoRoute(path: '/help', builder: (_, _) => const HelpScreen()),
      GoRoute(path: '/search-preview', redirect: (_, _) => '/search-content'),
      GoRoute(
        path: '/search-content',
        builder: (_, _) => _searchRoute(pushed: true),
      ),
      _courseDetailRoute('/search-result', '/search-result/:courseId'),
      GoRoute(
        path: '/more/invitations',
        redirect: (_, _) => widget.institutionRepository == null
            ? null
            : '/more/university-requests',
        builder: (_, _) => ChangeNotifierProvider(
          create: (_) => InvitationsViewModel(widget.repository)..load(),
          child: const InvitationsScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) => SignedInShell(
          navigationShell: navigationShell,
          onSignOut: _signOut,
          offline: widget.repository.session?.offline ?? false,
          onRetryOnline: () async {
            try {
              await widget.repository.refreshAccount();
            } catch (_) {
              // Keep the remembered offline session available for reading.
            }
          },
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, _) => !widget.repository.isPreview
                    ? ChangeNotifierProvider(
                        key: ValueKey(widget.repository.session?.userId),
                        create: (_) => LiveHomeViewModel(
                          _courses,
                          widget.studentTasksRepository,
                          widget.teachingRepository,
                          widget.repository.session?.isAdmin == true
                              ? widget.adminOverviewRepository
                              : null,
                        )..refresh(),
                        child: LiveHomeScreen(
                          institutionAccess:
                              widget.institutionRepository != null,
                          pendingCount: _pendingRequestCount,
                          refreshPendingCount: _refreshPendingRequestCount,
                        ),
                      )
                    : ChangeNotifierProvider(
                        create: (_) => DashboardViewModel(_dashboard)..load(),
                        child: DashboardScreen(
                          calendarRepository: widget.repository.isPreview
                              ? null
                              : _calendar,
                          calendarLocation: usesIosBottomNavigation(context)
                              ? '/calendar'
                              : '/more/feature/calendar',
                          courseRepository: widget.repository.isPreview
                              ? null
                              : _courses,
                        ),
                      ),
                routes: [
                  GoRoute(
                    path: 'admin/:category',
                    builder: (context, state) {
                      final category = state.pathParameters['category']!;
                      final t = AppLocalizations.of(context);
                      if (widget.repository.session?.isAdmin != true ||
                          widget.adminOverviewRepository == null) {
                        return Scaffold(body: Center(child: Text(t.homeError)));
                      }
                      return AdminDirectoryScreen(
                        repository: widget.adminOverviewRepository!,
                        category: category,
                        title: switch (category) {
                          'accounts' => t.homeAccounts,
                          'students' => t.homeStudents,
                          'teachers' => t.homeTeachers,
                          'admins' => t.homeAdmins,
                          _ => t.coursesTab,
                        },
                      );
                    },
                  ),
                  if (widget.teachingRepository != null)
                    GoRoute(
                      path: 'teacher-defaults',
                      builder: (_, _) =>
                          const TeachingEditor(defaultsOnly: true),
                    ),
                  GoRoute(
                    path: 'task/:id',
                    builder: (context, state) => PreviewDestination(
                      title: taskTitle(
                        AppLocalizations.of(context),
                        state.pathParameters['id']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'course/:courseId',
                    builder: (_, state) => _courseRoute(
                      '/home/course/${state.pathParameters['courseId']}',
                      courseId: state.pathParameters['courseId'],
                    ),
                    routes: [
                      GoRoute(
                        path: 'activity/:activityId',
                        builder: (_, state) => _courseRoute(
                          '/home/course/${state.pathParameters['courseId']}',
                          courseId: state.pathParameters['courseId'],
                          activityId: state.pathParameters['activityId'],
                        ),
                        routes: [
                          if (widget.teachingRepository != null)
                            GoRoute(
                              path: 'work',
                              builder: (_, state) => TeachingActivityScreen(
                                courseId: state.pathParameters['courseId']!,
                                activityId: state.pathParameters['activityId']!,
                              ),
                            ),
                          _browserRoute('/home/course'),
                          _notebookRoute(),
                          _notebookSettingsRoute(),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'announcements',
                    builder: (_, _) => AnnouncementListPreview(
                      snapshot: _dashboard.currentSnapshot,
                    ),
                  ),
                  GoRoute(
                    path: 'announcement/:id',
                    builder: (_, state) => AnnouncementPreview(
                      id: state.pathParameters['id']!,
                      snapshot: _dashboard.currentSnapshot,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/courses',
                builder: (_, _) => _courseRoute('/courses'),
                routes: [
                  _courseDetailRoute('/courses', ':courseId'),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/messages',
                builder: (context, _) {
                  final repository = widget.messagingRepository;
                  if (repository == null) {
                    return PreviewDestination(
                      title: AppLocalizations.of(
                        context,
                      ).dashboardMessagesPreview,
                    );
                  }
                  return ChangeNotifierProvider(
                    create: (_) =>
                        MessagingViewModel(repository, widget.repository),
                    child: const MessagingScreen(),
                  );
                },
                routes: [
                  GoRoute(
                    path: ':conversationId',
                    builder: (context, state) {
                      final repository = widget.messagingRepository;
                      final conversation = state.extra;
                      if (repository is! MessagingRepository ||
                          conversation is! PoodleConversation) {
                        return RouteErrorScreen(notFound: true);
                      }
                      return ChangeNotifierProvider(
                        create: (_) => ConversationViewModel(
                          repository,
                          conversation,
                          widget.repository,
                        ),
                        child: ConversationScreen(conversation: conversation),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notifications',
                builder: (context, _) {
                  final repository = widget.notificationsRepository;
                  if (repository == null) {
                    return PreviewDestination(
                      title: AppLocalizations.of(
                        context,
                      ).dashboardNotificationsPreview,
                    );
                  }
                  return ChangeNotifierProvider(
                    create: (_) =>
                        NotificationsViewModel(repository, widget.repository)
                          ..refresh(),
                    child: const NotificationsScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (_, _) => MoreDestination(onSignOut: _signOut),
                routes: [
                  GoRoute(
                    path: 'account',
                    redirect: (_, _) => '/profile',
                  ),
                  GoRoute(
                    path: 'feature/settings',
                    builder: (_, _) => const SettingsScreen(),
                    routes: [
                      GoRoute(
                        path: 'general',
                        builder: (_, _) => const GeneralSettingsScreen(),
                      ),
                      for (final kind in [
                        'shared-files',
                      ])
                        GoRoute(
                          path: kind,
                          builder: (_, _) =>
                              UnavailableSettingsScreen(kind: kind),
                        ),
                      GoRoute(
                        path: 'synchronisation',
                        builder: (_, _) => SynchronisationScreen(
                          repository: _courses,
                          sync: _sync,
                          downloads: widget.repository.isPreview || kIsWeb
                              ? null
                              : _downloads,
                        ),
                      ),
                      GoRoute(
                        path: 'space-usage',
                        builder: (_, _) => widget.repository.isPreview || kIsWeb
                            ? const UnavailableSettingsScreen(
                                kind: 'space-usage',
                              )
                            : SpaceUsageScreen(
                                downloads: _downloads,
                                files: _files,
                              ),
                      ),
                      GoRoute(
                        path: 'about',
                        builder: (_, _) => AboutSettingsScreen(
                          loadVersion:
                              widget.loadAppVersion ??
                              () async =>
                                  (await PackageInfo.fromPlatform()).version,
                        ),
                      ),
                    ],
                  ),
                  if (widget.studentTasksRepository case final repository?)
                    GoRoute(
                      path: 'feature/tasks',
                      builder: (_, _) =>
                          StudentTasksScreen(repository: repository),
                    ),
                  if (widget.studentGradesRepository case final repository?)
                    GoRoute(
                      path: 'feature/grades',
                      builder: (_, _) =>
                          StudentGradesScreen(repository: repository),
                    ),
                  if (widget.myFilesRepository case final repository?)
                    GoRoute(
                      path: 'feature/files',
                      builder: (_, _) => MyFilesScreen(repository: repository),
                    ),
                  GoRoute(
                    path: 'feature/:id',
                    redirect: (_, state) =>
                        state.pathParameters['id'] == 'profile'
                        ? '/profile'
                        : null,
                    builder: (context, state) =>
                        state.pathParameters['id'] == 'downloads'
                        ? widget.repository.isPreview || kIsWeb
                              ? DownloadsUnavailableScreen(
                                  preview: widget.repository.isPreview,
                                )
                              : SpaceUsageScreen(
                                  downloads: _downloads,
                                  files: _files,
                                  downloadsPage: true,
                                )
                        : PreviewDestination(
                            title: moreFeatureTitle(
                              AppLocalizations.of(context),
                              state.pathParameters['id']!,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, _) =>
                    CalendarScreen(key: const ValueKey('calendar')),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (_, _) => _searchRoute(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
