import '../../../../app/floating_action_clearance.dart';
import 'create_assessment_action.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/institution_repository.dart';
import '../../../university/presentation/widgets/institution_widgets.dart';
import 'teaching_common.dart';

class TeacherHomePanel extends StatefulWidget {
  const TeacherHomePanel({super.key});
  @override
  State<TeacherHomePanel> createState() => _TeacherHomePanelState();
}

class _TeacherHomePanelState extends State<TeacherHomePanel> {
  TeachingViewModel<List<TeachingCourseView>>? model;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repo = teachingRepositoryOf(context);
    if (repo != null && model == null) {
      model = TeachingViewModel(repo, repo.dashboard)..load();
    }
  }

  @override
  void dispose() {
    model?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = model;
    if (vm == null) return const SizedBox.shrink();
    final t = teachingText(context);
    return ListenableBuilder(
      listenable: vm,
      builder: (_, _) {
        if (vm.value?.isEmpty == true) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.homeTeachCourses,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: vm.busy ? null : vm.load,
                  icon: const Icon(Icons.refresh),
                  tooltip: t.teachingRefresh,
                ),
              ],
            ),
            if (vm.busy) const LinearProgressIndicator(),
            teachingNotice(context, vm.error),
            for (final course in vm.value ?? <TeachingCourseView>[])
              Card(
                child: ListTile(
                  title: Text(course.title),
                  subtitle: Text(
                    '${t.teachingPendingGrading}: ${course.pendingGrades} · ${t.teachingDrafts}: ${course.drafts}\n${t.teachingAwaitingRelease}: ${course.unreleasedTests}${course.upcomingDeadlines.isEmpty ? '' : '\n${t.teachingDeadline}: ${teachingDate(context, course.upcomingDeadlines.first)}'}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context
                      .push('/courses/${course.courseId}/teaching')
                      .then((_) => vm.load()),
                ),
              ),
            if (vm.value?.isNotEmpty == true)
              TextButton.icon(
                onPressed: () => context.push('/home/teacher-defaults'),
                icon: const Icon(Icons.tune),
                label: Text(t.teachingTeacherDefaults),
              ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class TeacherWorkspace extends StatefulWidget {
  const TeacherWorkspace({
    super.key,
    required this.courseId,
    this.institutionRepository,
    this.initialTab = 0,
  });
  final String courseId;
  final InstitutionRepository? institutionRepository;
  final int initialTab;
  @override
  State<TeacherWorkspace> createState() => _TeacherWorkspaceState();
}

class _TeacherWorkspaceState extends State<TeacherWorkspace> {
  late final repository = context.read<TeachingRepository?>()!;
  late final model = TeachingViewModel(
    repository,
    () => repository.activities(widget.courseId),
  )..load();
  late final courseTitles = repository.dashboard();
  late final roster = TeachingViewModel(
    repository,
    () => repository.members(widget.courseId),
  )..load();
  @override
  void dispose() {
    model.dispose();
    roster.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = teachingText(context);
    return DefaultTabController(
      length: 4,
      initialIndex: widget.initialTab,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionClearance.locationOf(
          context,
        ),
        floatingActionButton: ListenableBuilder(
          listenable: model,
          builder: (_, _) => model.value == null
              ? const SizedBox.shrink()
              : CreateAssessmentAction(
                  courses: [
                    TeachingCourseView(
                      courseId: UuidValue.withValidation(widget.courseId),
                      title: '',
                      pendingGrades: 0,
                      drafts: 0,
                      unreleasedTests: 0,
                      upcomingDeadlines: [],
                    ),
                  ],
                  courseId: widget.courseId,
                  onCreated: model.load,
                ),
        ),
        appBar: AppBar(
          title: FutureBuilder<List<TeachingCourseView>>(
            future: courseTitles,
            builder: (_, snapshot) => Text(
              snapshot.data
                      ?.where((c) => c.courseId.toString() == widget.courseId)
                      .firstOrNull
                      ?.title ??
                  t.homeTeachCourses,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => context.push('/home/teacher-defaults'),
              icon: const Icon(Icons.tune),
              tooltip: t.teachingTeacherDefaults,
            ),
            IconButton(
              onPressed: () {
                model.load();
                roster.load();
              },
              icon: const Icon(Icons.refresh),
              tooltip: t.teachingRefresh,
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: t.teachingAssignments),
              Tab(text: t.teachingTests),
              Tab(text: t.teachingGradebook),
              Tab(text: t.teachingStudents),
            ],
          ),
        ),
        body: ListenableBuilder(
          listenable: Listenable.merge([model, roster]),
          builder: (_, _) {
            if (model.value == null) {
              return Center(
                child: model.busy
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          teachingNotice(context, model.error),
                          TextButton(
                            onPressed: model.load,
                            child: Text(t.teachingRetry),
                          ),
                        ],
                      ),
              );
            }
            final activities = model.value!;
            return TabBarView(
              children: [
                for (final kind in ['assignment', 'test'])
                  ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
                    children: [
                      if (!activities.any((a) => a.kind == kind))
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(t.teachingNoActivitiesYet),
                        ),
                      for (final a in activities.where((a) => a.kind == kind))
                        Card(
                          child: ListTile(
                            title: Text(a.settings.title),
                            subtitle: Text(
                              '${a.published ? t.teachingPublished : t.teachingDraft} · ${t.teachingVersion} ${a.revision}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context
                                .push(
                                  '/courses/${widget.courseId}/activity/${a.activityId}/work',
                                )
                                .then((_) => model.load()),
                          ),
                        ),
                    ],
                  ),
                _gradebook(context, activities),
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    teachingNotice(context, roster.error),
                    if (roster.busy) const LinearProgressIndicator(),
                    if (widget.institutionRepository case final invitations?)
                      if (roster.value != null)
                        _StudentInviteForm(
                          repository: invitations,
                          courseId: widget.courseId,
                          onInvited: roster.load,
                        ),
                    if (roster.value?.every((m) => m.role != "student") == true)
                      Text(t.teachingNoStudentsYet),
                    for (final m
                        in (roster.value ?? <TeachingMemberView>[]).where(
                          (m) => m.role == "student",
                        ))
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text(m.label),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _gradebook(
    BuildContext context,
    List<TeachingActivityView> activities,
  ) {
    final t = teachingText(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final member in (roster.value ?? <TeachingMemberView>[]).where(
          (m) => m.role == 'student',
        ))
          ExpansionTile(
            title: Text(member.label),
            children: [
              for (final a in activities)
                Builder(
                  builder: (_) {
                    final submission = a.submissions
                        .where((s) => s.ownerId == member.id)
                        .firstOrNull;
                    final attempts =
                        a.attempts
                            .where(
                              (v) => v.ownerId == member.id && v.score != null,
                            )
                            .toList()
                          ..sort(
                            (x, y) => (y.score! / y.maxPoints).compareTo(
                              x.score! / x.maxPoints,
                            ),
                          );
                    final best = attempts.firstOrNull;
                    return ListTile(
                      title: Text(a.settings.title),
                      subtitle: Text(
                        a.kind == 'test'
                            ? best == null
                                  ? t.teachingNotSubmitted
                                  : '${t.teachingBestScore}: ${best.score} / ${best.maxPoints} · ${a.released ? t.teachingPublished : t.teachingDraft}'
                            : submission == null
                            ? t.teachingNotSubmitted
                            : submission.grade == null
                            ? t.teachingNotGraded
                            : '${submission.grade} / ${a.settings.maxPoints} · ${submission.published ? t.teachingPublished : t.teachingDraft}',
                      ),
                      onTap: () => context
                          .push(
                            '/courses/${widget.courseId}/activity/${a.activityId}/work',
                          )
                          .then((_) => model.load()),
                    );
                  },
                ),
            ],
          ),
      ],
    );
  }
}

class _StudentInviteForm extends StatefulWidget {
  const _StudentInviteForm({
    required this.repository,
    required this.courseId,
    required this.onInvited,
  });

  final InstitutionRepository repository;
  final String courseId;
  final VoidCallback onInvited;

  @override
  State<_StudentInviteForm> createState() => _StudentInviteFormState();
}

class _StudentInviteFormState extends State<_StudentInviteForm> {
  final _email = TextEditingController();
  bool _busy = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _invite() async {
    if (_busy) return;
    final email = _email.text.trim();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      setState(() {
        _error = 'invalid_input';
        _sent = false;
      });
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _sent = false;
    });
    try {
      await widget.repository.invite(
        email,
        'student',
        courseId: widget.courseId,
      );
      if (!mounted) return;
      _email.clear();
      setState(() => _sent = true);
      widget.onInvited();
    } on InstitutionProblem catch (problem) {
      if (mounted) setState(() => _error = problem.code);
    } catch (_) {
      if (mounted) setState(() => _error = 'unavailable');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = teachingText(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: const ValueKey('student-invite-email'),
            controller: _email,
            enabled: !_busy,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(labelText: text.email),
            onSubmitted: (_) => _invite(),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _busy ? null : _invite,
            icon: const Icon(Icons.person_add_alt_1_outlined),
            label: Text(text.institutionInviteStudent),
          ),
          if (_sent)
            Semantics(
              liveRegion: true,
              child: Text(text.institutionInviteSent),
            ),
          if (_error case final error?) InstitutionError(code: error),
        ],
      ),
    );
  }
}
