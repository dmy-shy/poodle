import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/course_repository.dart';
import '../view_models/course_view_model.dart';

class HomeCourses extends StatelessWidget {
  const HomeCourses({super.key, required this.repository});
  final CourseRepository repository;
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => CourseViewModel(repository)..load(),
    child: const _Courses(),
  );
}

class _Courses extends StatelessWidget {
  const _Courses();
  @override
  Widget build(BuildContext context) {
    final model = context.watch<CourseViewModel>();
    final state = model.state;
    final text = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.busy) const LinearProgressIndicator(),
        if (state.failure != null) ...[
          Text(
            state.failure == CourseFailure.network
                ? text.networkError
                : text.courseUnavailable,
          ),
          TextButton(onPressed: model.load, child: Text(text.authRetry)),
        ],
        if (state.courses?.isEmpty == true) Text(text.courseEmpty),
        if (model.repository.listIsStale)
          Text(
            '${Localizations.localeOf(context).languageCode == 'uk' ? 'Збережено офлайн · Оновлено' : 'Offline copy · Last refreshed'} ${model.repository.listRefreshedAt == null ? '' : DateFormat.yMd(Localizations.localeOf(context).toString()).add_jm().format(model.repository.listRefreshedAt!.toLocal())}',
          ),
        for (final course
            in state.courses?.where((c) => !c.hidden).take(3) ?? <CourseInfo>[])
          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book_outlined, size: 32),
              title: Text(course.title),
              subtitle: Text(
                [
                  ?course.category,
                  text.courseNoProgress,
                ].join(' · '),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/home/course/${course.id}'),
            ),
          ),
      ],
    );
  }
}
