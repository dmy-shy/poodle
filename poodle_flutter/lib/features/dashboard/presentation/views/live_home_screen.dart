import '../../../../app/floating_action_clearance.dart';
import '../view_models/admin_directory_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/admin_overview_repository.dart';
import '../../../teaching/presentation/views/create_assessment_action.dart';
import '../../../teaching/presentation/views/teaching_common.dart';
import '../view_models/live_home_view_model.dart';

class HomeLoad<T> extends StatefulWidget {
  const HomeLoad({
    super.key,
    required this.future,
    required this.builder,
    required this.retry,
  });
  final Future<T> future;
  final Widget Function(T) builder;
  final VoidCallback retry;
  @override
  State<HomeLoad<T>> createState() => _HomeLoadState<T>();
}

class _HomeLoadState<T> extends State<HomeLoad<T>> {
  T? previous;
  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
    future: widget.future,
    builder: (context, snapshot) {
      final t = AppLocalizations.of(context);
      if (snapshot.hasData) previous = snapshot.data;
      final value = previous;
      if (snapshot.hasError) {
        return Column(
          children: [
            if (value != null) widget.builder(value),
            ListTile(
              title: Text(t.homeError),
              trailing: TextButton(
                onPressed: widget.retry,
                child: Text(t.dashboardRetry),
              ),
            ),
          ],
        );
      }
      if (snapshot.connectionState != ConnectionState.done) {
        return Column(
          children: [
            if (value != null) widget.builder(value),
            const LinearProgressIndicator(),
          ],
        );
      }
      return widget.builder(snapshot.data as T);
    },
  );
}

class LiveHomeScreen extends StatelessWidget {
  const LiveHomeScreen({
    super.key,
    this.institutionAccess = false,
    this.pendingCount,
    this.refreshPendingCount,
  });
  final bool institutionAccess;
  final ValueListenable<int?>? pendingCount;
  final Future<void> Function()? refreshPendingCount;
  @override
  Widget build(BuildContext context) {
    final model = context.watch<LiveHomeViewModel>();
    final t = AppLocalizations.of(context);
    final admin = context.watch<AuthRepository>().session?.isAdmin == true;
    Widget heading(String title, [VoidCallback? all]) => Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        children: [
          Semantics(
            header: true,
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          if (all != null)
            TextButton(onPressed: all, child: Text(t.dashboardViewAll)),
        ],
      ),
    );
    return Scaffold(
      floatingActionButtonLocation: FloatingActionClearance.locationOf(context),
      floatingActionButton: CreateAssessmentAction(
        courses: model.taught,
        onCreated: model.refresh,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await model.refresh();
          await refreshPendingCount?.call();
        },
        child: ListView(
          key: const PageStorageKey('live-home-scroll'),
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 112),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (institutionAccess) ...[
                      if (admin)
                        ListTile(
                          title: Text(t.institutionOperator),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (pendingCount case final count?)
                                ValueListenableBuilder<int?>(
                                  valueListenable: count,
                                  builder: (context, value, _) => value == null
                                      ? const SizedBox.shrink()
                                      : Semantics(
                                          label: t.institutionPendingCount(
                                            value,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: Text('$value'),
                                          ),
                                        ),
                                ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          onTap: () async {
                            await context.push('/more/university-requests');
                            await refreshPendingCount?.call();
                          },
                        ),
                      if (context
                              .watch<AuthRepository>()
                              .session
                              ?.isUniversityAdmin ==
                          true)
                        ListTile(
                          title: Text(t.institutionAdmin),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/more/university'),
                        ),
                      if (context
                                  .watch<AuthRepository>()
                                  .session
                                  ?.teacherApproved ==
                              true &&
                          context
                                  .watch<AuthRepository>()
                                  .session
                                  ?.universityId !=
                              null)
                        ListTile(
                          title: Text(t.institutionTeaching),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/more/teaching-courses'),
                        ),
                    ],
                    if (admin) ...[
                      heading(t.homePlatform),
                      HomeLoad(
                        future: model.adminLoad,
                        retry: model.refresh,
                        builder: (value) {
                          if (value == null) return Text(t.homeError);
                          final metrics = [
                            ('accounts', t.homeAccounts, value.accounts),
                            ('students', t.homeStudents, value.students),
                            ('teachers', t.homeTeachers, value.teachers),
                            ('admins', t.homeAdmins, value.admins),
                            ('courses', t.coursesTab, value.courses),
                            if (!institutionAccess)
                              (
                                'invitations',
                                t.homeInvitations,
                                value.pendingInvitations,
                              ),
                          ];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = constraints.maxWidth;
                                  final columns = width >= 840
                                      ? 3
                                      : width >= 560
                                      ? 2
                                      : 1;
                                  final cardWidth =
                                      (width - 12 * (columns - 1)) / columns;
                                  return Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: [
                                      for (final metric in metrics)
                                        SizedBox(
                                          width: cardWidth,
                                          child: Card(
                                            child: ListTile(
                                              title: Text(metric.$2),
                                              subtitle: Text(
                                                '${metric.$3}',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.headlineMedium,
                                              ),
                                              trailing: const Icon(
                                                Icons.chevron_right,
                                              ),
                                              onTap: () =>
                                                  metric.$1 == 'invitations'
                                                  ? context.push(
                                                      '/more/invitations',
                                                    )
                                                  : context.push(
                                                      '/home/admin/${metric.$1}',
                                                    ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              Text(t.homeOverlap),
                            ],
                          );
                        },
                      ),
                      ListTile(
                        title: Text(t.homeMyCourses),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.go('/courses'),
                      ),
                    ] else ...[
                      if (model.tasks != null)
                        HomeLoad(
                          future: model.taskLoad,
                          retry: model.refresh,
                          builder: (value) {
                            if (value == null || value.tasks.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            final tasks = [...value.tasks]
                              ..sort((a, b) {
                                final due = a.deadline.compareTo(b.deadline);
                                return due != 0
                                    ? due
                                    : a.activityId.toString().compareTo(
                                        b.activityId.toString(),
                                      );
                              });
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                heading(
                                  t.homeNextUp,
                                  () => context.push('/more/feature/tasks'),
                                ),
                                for (final task in tasks.take(3))
                                  Card(
                                    child: ListTile(
                                      title: Text(task.activityTitle),
                                      subtitle: Text(
                                        '${task.courseTitle} · ${teachingDate(context, task.deadline)}',
                                      ),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () async {
                                        await context.push(
                                          '/courses/${task.courseId}/activity/${task.activityId}/work',
                                        );
                                        if (context.mounted) model.refresh();
                                      },
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      HomeLoad(
                        future: model.courseLoad,
                        retry: model.refresh,
                        builder: (courses) {
                          final study = courses
                              .where((c) => c.role == 'student' && !c.hidden)
                              .take(3);
                          if (study.isEmpty) {
                            return courses.isEmpty && model.taught.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Text(t.homeEmpty),
                                  )
                                : const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              heading(
                                t.homeStudyCourses,
                                () => context.go('/courses'),
                              ),
                              for (final course in study)
                                Card(
                                  child: ListTile(
                                    title: Text(course.title),
                                    subtitle: course.category == null
                                        ? null
                                        : Text(course.category!),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () => context.push(
                                      '/home/course/${course.id}',
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      HomeLoad(
                        future: model.teachingLoad,
                        retry: model.refresh,
                        builder: (courses) {
                          if (courses.isEmpty) return const SizedBox.shrink();
                          final sorted = [...courses]
                            ..sort((a, b) {
                              final pending = b.pendingGrades.compareTo(
                                a.pendingGrades,
                              );
                              return pending != 0
                                  ? pending
                                  : a.title.compareTo(b.title);
                            });
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              heading(
                                t.homeTeachCourses,
                                () => context.go('/courses'),
                              ),
                              for (final course in sorted.take(3))
                                Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ListTile(
                                        title: Text(course.title),
                                        subtitle: Text(
                                          '${t.teachingPendingGrading}: ${course.pendingGrades} · ${t.teachingDrafts}: ${course.drafts}',
                                        ),
                                        trailing: const Icon(
                                          Icons.chevron_right,
                                        ),
                                        onTap: () async {
                                          await context.push(
                                            '/courses/${course.courseId}/teaching',
                                          );
                                          if (context.mounted) model.refresh();
                                        },
                                      ),
                                      if (institutionAccess)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton.icon(
                                            key: ValueKey(
                                              'invite-student-${course.courseId}',
                                            ),
                                            onPressed: () => context.push(
                                              '/courses/${course.courseId}/teaching?tab=students',
                                            ),
                                            icon: const Icon(
                                              Icons.person_add_alt_1_outlined,
                                            ),
                                            label: Text(
                                              t.institutionInviteStudent,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminDirectoryScreen extends StatefulWidget {
  const AdminDirectoryScreen({
    super.key,
    required this.repository,
    required this.category,
    required this.title,
  });
  final AdminOverviewRepository repository;
  final String category, title;
  @override
  State<AdminDirectoryScreen> createState() => _AdminDirectoryScreenState();
}

class _AdminDirectoryScreenState extends State<AdminDirectoryScreen> {
  late final model = AdminDirectoryViewModel(widget.repository, widget.category)
    ..load();
  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListenableBuilder(
        listenable: model,
        builder: (_, _) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final row in model.rows)
              ListTile(
                title: Text(row.label),
                subtitle: Text(
                  widget.category == 'courses'
                      ? '${t.homeStudents}: ${row.students} · ${t.homeTeachers}: ${row.teachers}'
                      : [
                          if (row.student) t.homeStudents,
                          if (row.teacher) t.homeTeachers,
                          if (row.admin) t.homeAdmins,
                        ].join(' · '),
                ),
              ),
            if (model.busy) const LinearProgressIndicator(),
            if (!model.busy && model.rows.isEmpty && !model.failed)
              Text(t.homeEmpty),
            if (model.failed) Text(t.homeError),
            if (!model.busy && (model.more || model.failed))
              TextButton(
                onPressed: model.load,
                child: Text(model.failed ? t.dashboardRetry : t.homeMore),
              ),
          ],
        ),
      ),
    );
  }
}
