import '../../../../ui/components/confirmation_actions.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'teaching_common.dart';
import 'teaching_editor.dart';

class TeachingActivityScreen extends StatefulWidget {
  const TeachingActivityScreen({
    super.key,
    required this.courseId,
    required this.activityId,
  });
  final String courseId, activityId;
  @override
  State<TeachingActivityScreen> createState() => _TeachingActivityScreenState();
}

class _TeachingActivityScreenState extends State<TeachingActivityScreen> {
  late final repo = context.read<TeachingRepository?>()!;
  late final model = TeachingViewModel(
    repo,
    () => repo.activity(widget.courseId, widget.activityId),
  )..load();
  final response = TextEditingController();
  String key = createTeachingId();
  String? uploadId;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final active = model.value?.attempts
          .where((v) => v.submittedAt == null)
          .firstOrNull;
      if (active != null && !model.value!.teacher) {
        if (remaining(active).inSeconds <= 0 && !model.busy) model.load();
        setState(() {});
      }
    });
  }

  Duration remaining(TeachingAttemptView attempt) {
    final serverTime = model.value!.serverTime;
    // The local clock is used only to render the timer. The server owns eligibility.
    return attempt.expiresAt.difference(
      serverTime.add(DateTime.now().toUtc().difference(model.receivedAt)),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    model.dispose();
    response.dispose();
    super.dispose();
  }

  Future<bool> command(
    Future<TeachingActivityView> Function() operation,
  ) async {
    final result = await model.run(operation);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final t = teachingText(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.teachingViewWork),
        actions: [
          IconButton(
            onPressed: model.busy ? null : () => command(model.loader),
            icon: const Icon(Icons.refresh),
            tooltip: t.teachingRefresh,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: model,
        builder: (_, _) {
          final a = model.value;
          if (a == null) {
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
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Text(
                    a.settings.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${a.published ? t.teachingPublished : t.teachingDraft} · ${t.teachingVersion} ${a.revision}',
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    a.settings.instructions,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${t.teachingMaximumPoints}: ${NumberFormat.decimalPattern(t.localeName).format(a.settings.maxPoints)}',
                  ),
                  if (a.settings.closesAt != null)
                    Text(
                      '${t.teachingDeadline}: ${teachingDate(context, a.settings.closesAt!)}',
                    ),
                  if (model.busy) const LinearProgressIndicator(),
                  teachingNotice(context, model.error),
                  if (a.teacher && !a.released)
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: model.busy
                              ? null
                              : () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => TeachingEditor(
                                        courseId: widget.courseId,
                                        kind: a.kind,
                                        activity: a,
                                      ),
                                    ),
                                  );
                                  await command(model.loader);
                                },
                          icon: const Icon(Icons.edit_outlined),
                          label: Text(t.teachingEdit),
                        ),
                        if (a.kind == 'test') ...[
                          OutlinedButton(
                            onPressed: model.busy
                                ? null
                                : () => command(
                                    () => repo.save(
                                      TeachingSaveInput(
                                        courseId: a.courseId,
                                        sectionId: a.sectionId,
                                        activityId: a.activityId,
                                        kind: a.kind,
                                        expectedRevision: a.revision,
                                        publish: true,
                                        settings: a.settings.copyWith(
                                          closesAt: DateTime.now().toUtc(),
                                        ),
                                        questions: a.questions,
                                      ),
                                    ),
                                  ),
                            child: Text(t.teachingCloseTestNow),
                          ),
                          FilledButton(
                            onPressed: model.busy
                                ? null
                                : () => command(
                                    () => repo.release(
                                      widget.courseId,
                                      widget.activityId,
                                    ),
                                  ),
                            child: Text(t.teachingReleaseResults),
                          ),
                        ],
                      ],
                    ),
                  const SizedBox(height: 20),
                  if (a.kind == 'assignment')
                    ..._assignment(context, a)
                  else
                    ..._test(context, a),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _assignment(BuildContext context, TeachingActivityView a) {
    final t = teachingText(context);
    final latest = a.submissions.firstOrNull;
    final canSubmit =
        !a.teacher &&
        latest?.underReview != true &&
        (a.settings.opensAt == null ||
            !a.serverTime.isBefore(a.settings.opensAt!)) &&
        (a.settings.closesAt == null ||
            a.serverTime.isBefore(a.settings.closesAt!));
    return [
      if (canSubmit) ...[
        if (a.settings.allowText)
          TextField(
            controller: response,
            maxLines: 5,
            maxLength: 20000,
            decoration: InputDecoration(
              labelText: t.teachingYourResponse,
              border: const OutlineInputBorder(),
            ),
          ),
        if (a.settings.allowFile)
          OutlinedButton.icon(
            onPressed: model.busy
                ? null
                : () async {
                    await command(() async {
                      final next = await repo.upload(
                        widget.courseId,
                        widget.activityId,
                      );
                      if (next != null) uploadId = next;
                      return a;
                    });
                  },
            icon: const Icon(Icons.attach_file),
            label: Text(
              uploadId == null ? t.teachingAttachFile : t.teachingFileAttached,
            ),
          ),
        FilledButton(
          onPressed: model.busy
              ? null
              : () async {
                  if (await command(
                    () => repo.submit(
                      widget.courseId,
                      widget.activityId,
                      response.text,
                      key,
                      uploadId: uploadId,
                    ),
                  )) {
                    key = createTeachingId();
                    uploadId = null;
                    response.clear();
                  }
                },
          child: Text(t.teachingSubmitAssignment),
        ),
      ],
      const SizedBox(height: 16),
      if (a.submissions.isEmpty) Text(t.teachingNoSubmissionsYet),
      for (final sub in a.submissions)
        Card(
          child: ExpansionTile(
            title: Text(
              a.teacher
                  ? sub.ownerLabel
                  : teachingDate(context, sub.submittedAt),
            ),
            subtitle: Text(
              '${a.teacher ? "${teachingDate(context, sub.submittedAt)} · " : ""}${sub.grade != null
                  ? '${sub.grade} / ${a.settings.maxPoints}'
                  : sub.underReview
                  ? t.teachingUnderReview
                  : t.teachingNotGraded}${sub.published ? ' · ${t.teachingPublished}' : ''}',
            ),
            childrenPadding: const EdgeInsets.all(16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: AlignmentDirectional.centerStart,
            children: [
              SelectableText(sub.text),
              if (sub.fileName != null)
                TextButton.icon(
                  onPressed: model.busy
                      ? null
                      : () => command(() async {
                          final url = await repo.file(
                            widget.courseId,
                            widget.activityId,
                            sub.id.toString(),
                          );
                          if (!await launchUrl(
                            Uri.parse(url),
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw const TeachingFailure('unavailable');
                          }
                          return a;
                        }),
                  icon: const Icon(Icons.description_outlined),
                  label: Text(sub.fileName!),
                ),
              if (sub.feedback?.isNotEmpty == true)
                Text('${t.teachingFeedback}: ${sub.feedback}'),
              if (a.teacher &&
                  a.submissions
                          .firstWhere((v) => v.ownerId == sub.ownerId)
                          .id ==
                      sub.id)
                Wrap(
                  spacing: 12,
                  children: [
                    FilledButton.tonal(
                      onPressed: model.busy ? null : () => _grade(a, sub),
                      child: Text(t.teachingGrade),
                    ),
                    TextButton(
                      onPressed: model.busy
                          ? null
                          : () async {
                              final deadline = await teachingPickDate(
                                context,
                                a.settings.closesAt?.add(
                                  const Duration(days: 1),
                                ),
                              );
                              if (deadline != null) {
                                await command(
                                  () => repo.reopen(
                                    widget.courseId,
                                    widget.activityId,
                                    sub.ownerId.toString(),
                                    deadline,
                                  ),
                                );
                              }
                            },
                      child: Text(t.teachingReopen),
                    ),
                  ],
                ),
            ],
          ),
        ),
    ];
  }

  Future<void> _grade(
    TeachingActivityView a,
    TeachingSubmissionView sub,
  ) async {
    final points = TextEditingController(text: sub.grade?.toString() ?? '');
    final feedback = TextEditingController(text: sub.feedback ?? '');
    final t = teachingText(context);
    final form = GlobalKey<FormState>();
    final publish = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.teachingGrade),
        content: Form(
          key: form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: points,
                  decoration: InputDecoration(
                    labelText: '${t.teachingPoints} / ${a.settings.maxPoints}',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) {
                    final n = double.tryParse(v ?? '');
                    return n == null ||
                            !n.isFinite ||
                            n < 0 ||
                            n > a.settings.maxPoints
                        ? t.teachingCompleteTheRequiredFields
                        : null;
                  },
                ),
                TextField(
                  controller: feedback,
                  decoration: InputDecoration(labelText: t.teachingFeedback),
                  maxLines: 4,
                  maxLength: 10000,
                ),
              ],
            ),
          ),
        ),
        actions: [
          DialogActionRow(
            cancel: t.teachingCancel,
            confirm: t.teachingPublish,
            onCancel: () => Navigator.pop(context),
            onConfirm: () {
              if (form.currentState!.validate()) Navigator.pop(context, true);
            },
            secondary: TextButton(
              onPressed: () {
                if (form.currentState!.validate()) {
                  Navigator.pop(context, false);
                }
              },
              child: Text(t.teachingSaveDraft),
            ),
          ),
        ],
      ),
    );
    if (publish != null) {
      await command(
        () => repo.grade(
          widget.courseId,
          widget.activityId,
          sub.id.toString(),
          double.parse(points.text),
          feedback.text,
          publish,
        ),
      );
    }
    // Dialog exit animation may still use its text controllers.
    Future<void>.delayed(const Duration(seconds: 1), () {
      points.dispose();
      feedback.dispose();
    });
  }

  List<Widget> _test(BuildContext context, TeachingActivityView a) {
    final t = teachingText(context);
    final active = a.attempts.where((v) => v.submittedAt == null).firstOrNull;
    final scores = a.attempts.where((v) => v.score != null).toList()
      ..sort(
        (x, y) => (y.score! / y.maxPoints).compareTo(x.score! / x.maxPoints),
      );
    return [
      if (!a.released) Text(t.teachingResultsHiddenUntilTeacherRelease),
      if (!a.teacher && !a.released && active == null)
        FilledButton(
          onPressed: model.busy
              ? null
              : () => command(
                  () => repo.start(widget.courseId, widget.activityId),
                ),
          child: Text(t.teachingStartTest),
        ),
      if (!a.teacher && active != null) ...[
        Text(
          '${t.teachingTimeRemaining}: ${remaining(active).inSeconds.clamp(0, 1000000)} s',
        ),
        for (final (i, q) in active.questions.indexed)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i + 1}. ${q.prompt}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  RadioGroup<int>(
                    groupValue: active.answers[i],
                    onChanged: model.busy
                        ? (_) {}
                        : (v) {
                            final answers = [...active.answers];
                            answers[i] = v!;
                            command(
                              () => repo.answers(
                                widget.courseId,
                                widget.activityId,
                                active.id.toString(),
                                answers,
                                false,
                              ),
                            );
                          },
                    child: Column(
                      children: [
                        for (final (option, text) in q.options.indexed)
                          RadioListTile<int>(value: option, title: Text(text)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        FilledButton(
          onPressed: model.busy
              ? null
              : () => command(
                  () => repo.answers(
                    widget.courseId,
                    widget.activityId,
                    active.id.toString(),
                    active.answers,
                    true,
                  ),
                ),
          child: Text(t.teachingSubmitTest),
        ),
      ],
      if (scores.isNotEmpty && !a.teacher)
        Text(
          '${t.teachingBestScore}: ${scores.first.score} / ${scores.first.maxPoints}',
        ),
      if (a.attempts.isEmpty) Text(t.teachingNoAttemptsYet),
      for (final attempt in a.attempts.where(
        (v) => a.teacher || v.submittedAt != null,
      ))
        Card(
          child: ExpansionTile(
            title: Text(
              a.teacher
                  ? attempt.ownerLabel
                  : '${t.teachingVersion} ${attempt.revision}',
            ),
            subtitle: Text(
              '${t.teachingVersion} ${attempt.revision} · ${attempt.submittedAt == null ? t.teachingNotSubmitted : t.teachingSubmitted}${attempt.score == null ? '' : ' · ${attempt.score} / ${attempt.maxPoints}'}',
            ),
            childrenPadding: const EdgeInsets.all(16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, q) in attempt.questions.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.prompt),
                      Text(
                        '${t.teachingYourResponse}: ${attempt.answers[i] < 0 ? '—' : q.options[attempt.answers[i]]}',
                      ),
                      if (q.correctIndex != null)
                        Text(
                          '${t.teachingCorrectAnswer}: ${q.options[q.correctIndex!]}',
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
    ];
  }
}
