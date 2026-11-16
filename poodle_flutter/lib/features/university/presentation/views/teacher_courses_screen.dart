import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/institution_repository.dart';
import '../view_models/teacher_courses_view_model.dart';
import '../widgets/institution_widgets.dart';

class TeacherCoursesScreen extends StatefulWidget {
  const TeacherCoursesScreen({super.key, this.onEdit});
  final ValueChanged<String>? onEdit;
  @override
  State<TeacherCoursesScreen> createState() => _TeacherCoursesScreenState();
}

class _TeacherCoursesScreenState extends State<TeacherCoursesScreen> {
  final _title = TextEditingController();
  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TeacherCoursesViewModel>();
    final text = AppLocalizations.of(context);
    return InstitutionPage(
      title: text.institutionTeaching,
      children: [
        if (model.busy) const LinearProgressIndicator(),
        if (model.error case final code?) InstitutionError(code: code),
        TextButton(
          onPressed: model.busy ? null : model.load,
          child: Text(text.institutionRefresh),
        ),
        TextField(
          key: const ValueKey('course-title'),
          controller: _title,
          enabled: !model.busy,
          maxLength: 200,
          decoration: InputDecoration(labelText: text.institutionCourseTitle),
        ),
        FilledButton(
          onPressed: model.busy
              ? null
              : () async {
                  await model.create(_title.text);
                  if (mounted && model.error == null) _title.clear();
                },
          child: Text(text.institutionCreateCourse),
        ),
        if (model.sent)
          Semantics(liveRegion: true, child: Text(text.institutionInviteSent)),
        if (model.courses.isEmpty && !model.busy) Text(text.institutionEmpty),
        for (final course in model.courses)
          _CourseCard(
            key: ValueKey(course.id),
            course: course,
            onEdit: widget.onEdit,
          ),
      ],
    );
  }
}

class _CourseCard extends StatefulWidget {
  const _CourseCard({super.key, required this.course, this.onEdit});
  final ManagedCourse course;
  final ValueChanged<String>? onEdit;
  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  final _email = TextEditingController();
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TeacherCoursesViewModel>();
    final text = AppLocalizations.of(context);
    final c = widget.course;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(c.title, style: Theme.of(context).textTheme.titleLarge),
            Text(
              c.published ? text.institutionPublished : text.institutionDraft,
            ),
            OutlinedButton(
              onPressed: model.busy || widget.onEdit == null
                  ? null
                  : () => widget.onEdit!(c.id),
              child: Text(text.institutionEditCourse),
            ),
            FilledButton(
              onPressed: model.busy
                  ? null
                  : () => model.publish(c.id, !c.published),
              child: Text(
                c.published
                    ? text.institutionUnpublish
                    : text.institutionPublish,
              ),
            ),
            TextField(
              key: ValueKey('student-email-${c.id}'),
              controller: _email,
              enabled: !model.busy,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: text.email),
            ),
            OutlinedButton(
              onPressed: model.busy
                  ? null
                  : () => model.invite(c.id, _email.text),
              child: Text(text.institutionInviteStudent),
            ),
          ],
        ),
      ),
    );
  }
}
