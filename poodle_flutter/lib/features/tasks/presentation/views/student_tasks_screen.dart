import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_client/poodle_client.dart';
import 'package:provider/provider.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/student_tasks_repository.dart';
import '../view_models/student_tasks_view_model.dart';

class StudentTasksScreen extends StatelessWidget {
  const StudentTasksScreen({super.key, required this.repository});

  final StudentTasksRepository repository;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => StudentTasksViewModel(repository)..load(),
    child: const _TasksView(),
  );
}

class _TasksView extends StatelessWidget {
  const _TasksView();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<StudentTasksViewModel>();
    final text = AppLocalizations.of(context);
    final overdue = model.overdue;
    final upcoming = model.upcoming;
    return Scaffold(
      appBar: AppBar(title: Text(text.dashboardTasks)),
      body: model.loading
          ? const Center(child: CircularProgressIndicator())
          : model.failed
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(text.studentTasksError, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: model.load,
                      child: Text(text.dashboardRetry),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButton<String>(
                  isExpanded: true,
                  value: model.courseId ?? '',
                  onChanged: (value) =>
                      model.filter(value == '' ? null : value),
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(text.searchAllCourses),
                    ),
                    for (final course in model.courses.entries)
                      DropdownMenuItem(
                        value: course.key,
                        child: Text(
                          course.value,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                if (overdue.isEmpty && upcoming.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(text.studentTasksEmpty),
                  ),
                if (overdue.isNotEmpty) ...[
                  _Heading(text.studentTasksOverdue),
                  for (final task in overdue) _TaskTile(task),
                ],
                if (upcoming.isNotEmpty) ...[
                  _Heading(text.studentTasksUpcoming),
                  for (final task in upcoming) _TaskTile(task),
                ],
              ],
            ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Semantics(
      header: true,
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}

class _TaskTile extends StatelessWidget {
  const _TaskTile(this.task);

  final StudentTaskRow task;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final material = MaterialLocalizations.of(context);
    final deadline = task.deadline.toLocal();
    final date = material.formatMediumDate(deadline);
    final time = material.formatTimeOfDay(
      TimeOfDay.fromDateTime(deadline),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    final isTest = task.kind == 'test';
    final kind = isTest ? text.calendarTest : text.calendarAssignment;
    return ListTile(
      leading: Icon(isTest ? Icons.quiz_outlined : Icons.assignment_outlined),
      contentPadding: EdgeInsets.zero,
      title: Text(task.activityTitle),
      subtitle: Text('${task.courseTitle} · $kind\n$date · $time'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        await context.push<void>(
          '/courses/${task.courseId}/activity/${task.activityId}/work',
        );
        if (context.mounted) await context.read<StudentTasksViewModel>().load();
      },
    );
  }
}
