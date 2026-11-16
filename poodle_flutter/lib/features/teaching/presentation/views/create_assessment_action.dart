import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/auth_repository.dart';
import 'teaching_common.dart';
import 'teaching_editor.dart';

class CreateAssessmentAction extends StatelessWidget {
  const CreateAssessmentAction({
    super.key,
    required this.courses,
    this.courseId,
    this.onCreated,
  });
  final List<TeachingCourseView> courses;
  final String? courseId;
  final VoidCallback? onCreated;
  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty ||
        context.watch<AuthRepository>().session?.offline == true) {
      return const SizedBox.shrink();
    }
    final t = teachingText(context);
    return FloatingActionButton(
      tooltip: t.homeCreate,
      heroTag: null,
      onPressed: () async {
        var selected = courseId;
        selected ??= await showModalBottomSheet<String>(
          context: context,
          useRootNavigator: true,
          useSafeArea: true,
          builder: (c) => SafeArea(
            top: false,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(title: Text(t.homeChooseCourse)),
                for (final course in courses)
                  ListTile(
                    title: Text(course.title),
                    onTap: () => Navigator.pop(c, course.courseId.toString()),
                  ),
              ],
            ),
          ),
        );
        if (selected == null || !context.mounted) return;
        final kind = await showModalBottomSheet<String>(
          context: context,
          useRootNavigator: true,
          useSafeArea: true,
          builder: (c) => SafeArea(
            top: false,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.assignment_outlined),
                  title: Text(t.teachingCreateAssignment),
                  onTap: () => Navigator.pop(c, 'assignment'),
                ),
                ListTile(
                  leading: const Icon(Icons.quiz_outlined),
                  title: Text(t.teachingCreateTest),
                  onTap: () => Navigator.pop(c, 'test'),
                ),
              ],
            ),
          ),
        );
        if (kind == null || !context.mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => TeachingEditor(courseId: selected, kind: kind),
          ),
        );
        if (context.mounted) onCreated?.call();
      },
      child: const Icon(Icons.add),
    );
  }
}
