import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/student_grades_repository.dart';
import '../view_models/student_grades_view_model.dart';

class StudentGradesScreen extends StatefulWidget {
  const StudentGradesScreen({super.key, required this.repository});
  final StudentGradesRepository repository;

  @override
  State<StudentGradesScreen> createState() => _StudentGradesScreenState();
}

class _StudentGradesScreenState extends State<StudentGradesScreen> {
  late final StudentGradesViewModel _model;
  @override
  void initState() {
    super.initState();
    _model = StudentGradesViewModel(widget.repository);
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(text.dashboardGrades)),
      body: FutureBuilder<StudentGradesResponse>(
        future: _model.result,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextButton(
                onPressed: () => setState(() => _model.reload()),
                child: Text(text.dashboardRetry),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final courses = snapshot.data!.courses;
          if (courses.isEmpty) {
            return Center(child: Text(text.studentGradesEmpty));
          }
          return ListView(
            children: [
              for (final course in courses) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    course.courseTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                for (final grade in course.grades)
                  ListTile(
                    title: Text(grade.activityTitle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(switch (grade.status) {
                          'graded' => text.studentGradesGraded,
                          'pending' => text.studentGradesPending,
                          _ => text.teachingNotSubmitted,
                        }),
                        if (grade.points != null && grade.maximum != null)
                          Text(
                            '${_number(grade.points!)} / ${_number(grade.maximum!)}',
                          ),
                        if (grade.feedback case final feedback?
                            when feedback.isNotEmpty)
                          Text(feedback),
                      ],
                    ),
                    onTap: () => context.push(
                      '/courses/${grade.courseId}/activity/${grade.activityId}/work',
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

String _number(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toString();
