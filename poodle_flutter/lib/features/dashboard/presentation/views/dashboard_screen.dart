import 'package:flutter/material.dart';
import '../../../teaching/presentation/views/teacher_workspace.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../dashboard_copy.dart';
import '../view_models/dashboard_view_model.dart';
import '../../../../data/repositories/course_repository.dart';
import '../../../../data/repositories/dashboard_repository.dart'
    show DashboardCourse;
import '../../../courses/presentation/views/home_courses.dart';
import '../../../../data/repositories/calendar_repository.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    this.courseRepository,
    this.calendarRepository,
    this.calendarLocation = '/more/feature/calendar',
  });
  final CourseRepository? courseRepository;
  final CalendarRepository? calendarRepository;
  final String calendarLocation;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final state = context.watch<DashboardViewModel>().state;
    final snapshot = state.snapshot;
    final model = context.read<DashboardViewModel>();
    if (widget.calendarRepository != null) {
      context.watch<CalendarRepository>();
    }
    final calendar = widget.calendarRepository?.snapshot;
    final upcomingEvents = <String, CalendarEvent>{};
    for (final event in calendar?.events ?? const <CalendarEvent>[]) {
      if (event.atUtc.isAfter(DateTime.now().toUtc())) {
        upcomingEvents.putIfAbsent(event.activity.id, () => event);
      }
    }
    return RefreshIndicator(
      onRefresh: model.refresh,
      child: CustomScrollView(
        controller: _scroll,
        key: const PageStorageKey('home-scroll'),
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    20 + MediaQuery.paddingOf(context).bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          text.homeTab,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      // const SizedBox(height: 6),
                      Text(
                        text.dashboardWelcome,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (snapshot != null)
                        Text(localDate(context, snapshot.referenceAtUtc)),
                      const SizedBox(height: 12),
                      const TeacherHomePanel(),
                      const SizedBox(height: 12),
                      if (snapshot?.stale == true)
                        _Notice(text.dashboardOffline),
                      if (snapshot?.stale == true)
                        Text(
                          text.dashboardUpdated(
                            localDate(context, snapshot!.updatedAtUtc),
                          ),
                        ),
                      if (state.busy && snapshot == null)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Semantics(
                              liveRegion: true,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.hourglass_top_outlined,
                                    size: 36,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(text.loading),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (state.loadError && snapshot == null) ...[
                        _Notice(text.dashboardLoadError),
                        FilledButton(
                          onPressed: model.load,
                          child: Text(text.dashboardRetry),
                        ),
                      ],
                      if (snapshot != null) ...[
                        if (state.refreshing) const LinearProgressIndicator(),
                        if (state.refreshError)
                          _Notice(
                            state.offlineError
                                ? text.dashboardOffline
                                : text.dashboardLoadError,
                          ),
                        _SectionHeading(
                          text.dashboardUpcoming,
                          onViewAll: () => context.go('/calendar'),
                        ),
                        if (upcomingEvents.isEmpty && snapshot.tasks.isEmpty)
                          _Empty(text.dashboardEmptyTasks),
                        if (calendar != null)
                          for (final event in upcomingEvents.values.take(3))
                            Card(
                              child: ListTile(
                                key: ValueKey(event.id),
                                title: Text(event.activity.title),
                                subtitle: Text(
                                  '${event.course.title}\n${localDate(context, event.atUtc)}',
                                ),
                                isThreeLine: true,
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => context.push(
                                  '/home/course/${event.course.id}/activity/${event.activity.id}',
                                ),
                              ),
                            ),
                        if (calendar == null)
                          for (final task in snapshot.tasks.take(3))
                            Card(
                              child: ListTile(
                                key: ValueKey(task.id),
                                minVerticalPadding: 16,
                                title: Text(taskTitle(text, task.id)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(courseTitle(text, task.courseId)),
                                    Text(
                                      '${task.dueAtUtc.isBefore(snapshot.referenceAtUtc) ? text.dashboardOverdue : text.dashboardDue} · ${localDate(context, task.dueAtUtc)}',
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () =>
                                    context.push('/home/task/${task.id}'),
                              ),
                            ),
                        _SectionHeading(
                          text.dashboardRecent,
                          onViewAll: () => context.go('/courses'),
                        ),
                        if (widget.courseRepository != null)
                          HomeCourses(repository: widget.courseRepository!),
                        if (widget.courseRepository == null &&
                            snapshot.courses.isEmpty)
                          _Empty(text.dashboardEmptyCourses),
                        for (final course
                            in widget.courseRepository == null
                                ? snapshot.courses.take(3)
                                : <DashboardCourse>[])
                          Card(
                            child: ListTile(
                              key: ValueKey(course.id),
                              minVerticalPadding: 16,
                              leading: const Icon(
                                Icons.menu_book_outlined,
                                size: 32,
                              ),
                              title: Text(courseTitle(text, course.id)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(courseCategory(text, course.id)),
                                  Text(
                                    '${text.dashboardLastAccess} ${localDate(context, course.lastAccessUtc)}',
                                  ),
                                  Text(
                                    course.progress == null
                                        ? text.dashboardNoRequired
                                        : text.dashboardProgress(
                                            course.progress!,
                                          ),
                                  ),
                                  if (course.progress != null)
                                    LinearProgressIndicator(
                                      value: course.progress! / 100,
                                      semanticsLabel: text.dashboardProgress(
                                        course.progress!,
                                      ),
                                    ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () =>
                                  context.push('/home/course/${course.id}'),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.title, {this.onViewAll});
  final String title;
  final VoidCallback? onViewAll;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28, bottom: 8),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final heading = Semantics(
          header: true,
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        );
        final button = onViewAll == null
            ? null
            : TextButton(
                onPressed: onViewAll,
                child: Text(AppLocalizations.of(context).dashboardViewAll),
              );
        if (constraints.maxWidth < 400 ||
            MediaQuery.textScalerOf(context).scale(16) > 24) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading,
              ?button,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: heading),
            ?button,
          ],
        );
      },
    ),
  );
}

class _Notice extends StatelessWidget {
  const _Notice(this.message);
  final String message;
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty(this.message);
  final String message;
  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.all(16), child: Text(message));
}
