import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'teaching_common.dart';

class TeachingEditor extends StatefulWidget {
  const TeachingEditor({
    super.key,
    this.courseId,
    this.initialSectionId,
    this.kind = 'assignment',
    this.activity,
    this.defaultsOnly = false,
  });
  final String? courseId;
  final String? initialSectionId;
  final String kind;
  final TeachingActivityView? activity;
  final bool defaultsOnly;
  @override
  State<TeachingEditor> createState() => _TeachingEditorState();
}

class _TeachingEditorState extends State<TeachingEditor> {
  final form = GlobalKey<FormState>();
  final title = TextEditingController(),
      instructions = TextEditingController(),
      maxPoints = TextEditingController(),
      attempts = TextEditingController(),
      minutes = TextEditingController();
  final questions = <_QuestionFields>[];
  late final repo = context.read<TeachingRepository?>()!;
  late final model = TeachingViewModel<TeachingSettings>(repo, () async {
    final settings = widget.activity?.settings ?? await repo.defaults();
    if (!widget.defaultsOnly) sections = await repo.sections(widget.courseId!);
    _fill(settings);
    return settings;
  })..load();
  List<({String id, String title})> sections = [];
  String? section;
  DateTime? opens, closes;
  bool required = false, allowText = true, allowFile = true, shuffle = false;
  String? newId;
  void _fill(TeachingSettings s) {
    title.text = s.title;
    instructions.text = s.instructions;
    maxPoints.text = '${s.maxPoints}';
    attempts.text = '${s.attemptLimit}';
    minutes.text = '${s.timeLimitMinutes}';
    opens = s.opensAt;
    closes = s.closesAt;
    required = s.required;
    allowText = s.allowText;
    allowFile = s.allowFile;
    shuffle = s.shuffle;
    final preferred =
        widget.activity?.sectionId.toString() ?? widget.initialSectionId;
    section = preferred == null
        ? sections.firstOrNull?.id
        : sections.any((s) => s.id == preferred)
        ? preferred
        : null;
    for (final q in widget.activity?.questions ?? <TeachingQuestion>[]) {
      questions.add(_QuestionFields(q));
    }
  }

  @override
  void dispose() {
    model.dispose();
    for (final c in [title, instructions, maxPoints, attempts, minutes]) {
      c.dispose();
    }
    for (final q in questions) {
      q.dispose();
    }
    super.dispose();
  }

  Widget field(
    TextEditingController controller,
    String label, {
    bool number = false,
    bool integer = false,
    int lines = 1,
    String? hint,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      maxLines: lines,
      keyboardType: number
          ? TextInputType.numberWithOptions(decimal: !integer)
          : null,
      validator: (v) =>
          v == null ||
              v.trim().isEmpty ||
              (number &&
                  (double.tryParse(v) == null ||
                      !double.parse(v).isFinite ||
                      double.parse(v) <= 0 ||
                      (integer && int.tryParse(v) == null)))
          ? teachingText(context).teachingCompleteTheRequiredFields
          : null,
    ),
  );
  TeachingSettings _settings() => TeachingSettings(
    title: title.text.trim(),
    instructions: instructions.text,
    opensAt: opens,
    closesAt: closes,
    maxPoints: double.parse(maxPoints.text),
    required: required,
    allowText: allowText,
    allowFile: allowFile,
    attemptLimit: int.parse(attempts.text),
    timeLimitMinutes: int.parse(minutes.text),
    shuffle: shuffle,
  );
  Future<void> save(bool publish) async {
    if (!form.currentState!.validate()) return;
    final success = await model.run(() async {
      if (widget.defaultsOnly) return repo.defaults(_settings());
      // UUID creation is delegated to the SDK's UUID implementation.
      newId ??= createTeachingId();
      final result = await repo.save(
        TeachingSaveInput(
          courseId: UuidValue.withValidation(widget.courseId!),
          sectionId: UuidValue.withValidation(section!),
          activityId:
              widget.activity?.activityId ?? UuidValue.withValidation(newId!),
          kind: widget.kind,
          expectedRevision: widget.activity?.revision ?? 0,
          publish: publish,
          settings: _settings(),
          questions: widget.kind == 'test'
              ? questions.map((q) => q.value()).toList()
              : [],
        ),
      );
      return result.settings;
    });
    if (success && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final t = teachingText(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.defaultsOnly
              ? t.teachingTeacherDefaults
              : widget.kind == 'test'
              ? t.teachingCreateTest
              : t.teachingCreateAssignment,
        ),
      ),
      body: ListenableBuilder(
        listenable: model,
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
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Form(
                key: form,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (model.busy) const LinearProgressIndicator(),
                    teachingNotice(context, model.error),
                    if (!widget.defaultsOnly) ...[
                      DropdownButtonFormField<String>(
                        initialValue: section,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: t.teachingSection,
                        ),
                        items: sections
                            .map(
                              (s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(
                                  s.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: model.busy
                            ? null
                            : (v) => setState(() => section = v),
                        validator: (v) =>
                            v == null ? t.teachingSelectASection : null,
                      ),
                      field(
                        title,
                        t.teachingTitle,
                        hint: widget.kind != 'test'
                            ? null
                            : t.localeName == 'uk'
                            ? 'Наприклад, «Модуль 1» або «Іспит»'
                            : 'For example, “Module 1” or “Final exam”',
                      ),
                      field(instructions, t.teachingInstructions, lines: 4),
                      for (final opening in [true, false])
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            opening ? t.teachingOpens : t.teachingDeadline,
                          ),
                          subtitle: Text(
                            (opening ? opens : closes) == null
                                ? '—'
                                : teachingDate(
                                    context,
                                    (opening ? opens : closes)!,
                                  ),
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: model.busy
                              ? null
                              : () async {
                                  final date = await teachingPickDate(
                                    context,
                                    opening ? opens : closes,
                                  );
                                  if (date != null && mounted) {
                                    setState(() {
                                      if (opening) {
                                        opens = date;
                                      } else {
                                        closes = date;
                                      }
                                    });
                                  }
                                },
                        ),
                    ],
                    field(maxPoints, t.teachingMaximumPoints, number: true),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(t.teachingRequiredActivity),
                      value: required,
                      onChanged: model.busy
                          ? null
                          : (v) => setState(() => required = v),
                    ),
                    if (widget.kind == 'assignment' || widget.defaultsOnly) ...[
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t.teachingAllowText),
                        value: allowText,
                        onChanged: model.busy
                            ? null
                            : (v) => setState(() => allowText = v),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t.teachingAllowFile),
                        value: allowFile,
                        onChanged: model.busy
                            ? null
                            : (v) => setState(() => allowFile = v),
                      ),
                      Text(t.teachingUsePdfDocxJpegOrPngUpToMb),
                    ],
                    if (widget.kind == 'test' || widget.defaultsOnly) ...[
                      field(
                        attempts,
                        t.teachingAttemptsAllowed,
                        number: true,
                        integer: true,
                      ),
                      field(
                        minutes,
                        t.teachingTimeLimitMinutes,
                        number: true,
                        integer: true,
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t.teachingShuffleQuestions),
                        value: shuffle,
                        onChanged: model.busy
                            ? null
                            : (v) => setState(() => shuffle = v),
                      ),
                      Text(t.teachingResultsHiddenUntilTeacherRelease),
                    ],
                    if (widget.kind == 'test' && !widget.defaultsOnly) ...[
                      for (final (index, q) in questions.indexed)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${t.teachingQuestion} ${index + 1}',
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: t.teachingRemoveQuestion,
                                      onPressed: model.busy
                                          ? null
                                          : () => setState(() {
                                              questions.remove(q);
                                              q.dispose();
                                            }),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                                DropdownButtonFormField<String>(
                                  initialValue: q.kind,
                                  items: [
                                    DropdownMenuItem(
                                      value: 'choice',
                                      child: Text(t.teachingSingleChoice),
                                    ),
                                    DropdownMenuItem(
                                      value: 'trueFalse',
                                      child: Text(t.teachingTrueOrFalse),
                                    ),
                                  ],
                                  onChanged: (v) => setState(() {
                                    q.kind = v!;
                                    if (v == 'trueFalse') {
                                      q.options.text = 'True\nFalse';
                                    }
                                  }),
                                ),
                                field(q.prompt, t.teachingQuestion, lines: 3),
                                field(
                                  q.options,
                                  t.teachingOptionsOnePerLine,
                                  lines: 4,
                                ),
                                field(
                                  q.correct,
                                  t.teachingCorrectOptionNumber,
                                  number: true,
                                  integer: true,
                                ),
                                field(q.points, t.teachingPoints, number: true),
                              ],
                            ),
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: model.busy
                            ? null
                            : () => setState(
                                () => questions.add(_QuestionFields(null)),
                              ),
                        icon: const Icon(Icons.add),
                        label: Text(t.teachingAddQuestion),
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (widget.defaultsOnly)
                      FilledButton(
                        onPressed: model.busy ? null : () => save(false),
                        child: Text(t.teachingSaveDefaults),
                      )
                    else
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          OutlinedButton(
                            onPressed: model.busy ? null : () => save(false),
                            child: Text(t.teachingSaveDraft),
                          ),
                          FilledButton(
                            onPressed: model.busy ? null : () => save(true),
                            child: Text(t.teachingPublish),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuestionFields {
  _QuestionFields(TeachingQuestion? q)
    : prompt = TextEditingController(text: q?.prompt ?? ''),
      options = TextEditingController(text: q?.options.join('\n') ?? ''),
      correct = TextEditingController(text: '${(q?.correctIndex ?? 0) + 1}'),
      points = TextEditingController(text: '${q?.points ?? 1}'),
      kind = q?.kind ?? 'choice';
  final TextEditingController prompt, options, correct, points;
  String kind;
  TeachingQuestion value() => TeachingQuestion(
    prompt: prompt.text,
    kind: kind,
    options: options.text.split('\n').map((v) => v.trim()).toList(),
    correctIndex: int.parse(correct.text) - 1,
    points: double.parse(points.text),
  );
  void dispose() {
    for (final c in [prompt, options, correct, points]) {
      c.dispose();
    }
  }
}
