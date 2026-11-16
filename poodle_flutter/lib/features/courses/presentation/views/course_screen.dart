import '../../../../ui/components/confirmation_actions.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../../../../app/floating_action_clearance.dart';
import '../../../../data/repositories/teaching_repository.dart'
    show TeachingCourseView, UuidValue;
import '../../../teaching/presentation/views/create_assessment_action.dart';
import 'package:flutter/material.dart';
import '../../../teaching/presentation/views/teaching_common.dart'
    show teachingText, teachingRepositoryOf;
import '../../../teaching/presentation/views/teaching_editor.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/course_repository.dart';
import '../../../dashboard/presentation/dashboard_copy.dart' show localDate;
import '../view_models/course_view_model.dart';
import 'course_browser_screen.dart';
import '../widgets/course_actions_menu.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({
    super.key,
    required this.basePath,
    this.notebookAvailable = false,
    this.initialSection,
  });
  final bool notebookAvailable;
  final String? initialSection;
  final String basePath;
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final _sections = <String, GlobalKey>{};
  bool _focusedInitialSection = false;
  bool _showHidden = false;
  bool _showFavorites = false;
  Future<void> _confirmDownload(
    CourseViewModel model,
    CourseInfo course,
  ) async {
    final uk = Localizations.localeOf(context).languageCode == 'uk';
    int bytes;
    try {
      bytes = await model.downloadBytes(course.id);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              uk
                  ? 'Не вдалося перевірити файли курсу.'
                  : 'Could not check course files.',
            ),
          ),
        );
      }
      return;
    }
    if (!mounted) return;
    if (bytes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            uk
                ? 'У курсі немає файлів для завантаження.'
                : 'This course has no downloadable files.',
          ),
        ),
      );
      return;
    }
    final size = bytes >= 1024 * 1024
        ? '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB'
        : '${(bytes / 1024).ceil()} KB';
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(uk ? 'Завантажити курс?' : 'Download course?'),
        content: Text(
          uk
              ? 'Зберегти файли для читання офлайн ($size)?'
              : 'Save files for offline reading ($size)?',
        ),
        actions: [
          ConfirmationActions(
            cancel: uk ? 'Скасувати' : 'Cancel',
            confirm: uk ? 'Завантажити' : 'Download',
            destructive: false,
          ),
        ],
      ),
    );
    if (accepted != true || !mounted) return;
    final ok = await model.downloadCourse(course.id);
    if (!mounted) return;
    final message = ok
        ? (uk
              ? 'Файли курсу збережено офлайн.'
              : 'Course files saved for offline reading.')
        : model.downloadFailure == CourseFailure.wifiRequired
        ? (uk
              ? 'Підключіться до Wi-Fi та повторіть спробу.'
              : 'Connect to Wi-Fi and retry.')
        : model.downloadFailure == CourseFailure.cancelled
        ? (uk ? 'Завантаження скасовано.' : 'Download canceled.')
        : (uk
              ? 'Не вдалося завантажити файли. Спробуйте ще раз.'
              : 'Could not download files. Please retry.');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String get basePath => widget.basePath;
  @override
  Widget build(BuildContext context) {
    final model = context.watch<CourseViewModel>();
    final state = model.state;
    final text = AppLocalizations.of(context);
    final detail = state.value;
    final item = state.activity;
    final notebookActivityId =
        widget.notebookAvailable &&
            item != null &&
            !item.draft &&
            (item.kind == ActivityKind.module ||
                item.kind == ActivityKind.test) &&
            state.pdfPath == null
        ? item.id
        : null;
    if (!_focusedInitialSection &&
        detail != null &&
        widget.initialSection != null) {
      _focusedInitialSection = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final target = _sections[widget.initialSection]?.currentContext;
        if (target != null) Scrollable.ensureVisible(target);
      });
    }
    return Scaffold(
      floatingActionButtonLocation: FloatingActionClearance.locationOf(context),
      floatingActionButton:
          detail?.teacherView == true &&
              item == null &&
              teachingRepositoryOf(context) != null
          ? CreateAssessmentAction(
              courses: [
                TeachingCourseView(
                  courseId: UuidValue.withValidation(detail!.course.id),
                  title: detail.course.title,
                  pendingGrades: 0,
                  drafts: 0,
                  unreleasedTests: 0,
                  upcomingDeadlines: [],
                ),
              ],
              courseId: detail.course.id,
              onCreated: model.load,
            )
          : notebookActivityId != null
          ? FloatingActionButton(
              tooltip: text.notebookStudyNotebook,
              onPressed: () => context.push(
                '$basePath/activity/$notebookActivityId/notebook',
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.auto_stories_outlined),
                  Positioned(
                    top: -4,
                    right: -6,
                    child: ExcludeSemantics(
                      child: Icon(
                        Icons.circle,
                        key: const ValueKey('study-notebook-indicator'),
                        size: 8,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
      appBar: AppBar(
        title: Text(item == null ? text.coursesTab : _kind(text, item.kind)),
        actions: [
          if (detail != null && detail.sections.length > 1)
            PopupMenuButton<String>(
              tooltip: text.courseSections,
              icon: const Icon(Icons.list),
              onSelected: (id) {
                final target = _sections[id]?.currentContext;
                if (target != null) {
                  Scrollable.ensureVisible(
                    target,
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : const Duration(milliseconds: 250),
                  );
                }
              },
              itemBuilder: (_) => detail.sections
                  .map((s) => PopupMenuItem(value: s.id, child: Text(s.title)))
                  .toList(),
            ),
          IconButton(
            tooltip: text.dashboardRefresh,
            onPressed: state.busy ? null : model.load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: state.markdown != null
          ? SafeArea(
              top: false,
              child: Markdown(
                data: state.markdown!,
                selectable: true,
                imageBuilder: (_, _, alt) => Text(alt ?? ''),
                onTapLink: (_, _, _) {},
              ),
            )
          : state.pdfPath != null
          ? PdfViewer.file(
              state.pdfPath!,
              params: const PdfViewerParams(
                textSelectionParams: PdfTextSelectionParams(enabled: false),
              ),
            )
          : RefreshIndicator(
              onRefresh: model.load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  20 +
                      MediaQuery.paddingOf(context).bottom +
                      (notebookActivityId == null ? 0 : 88),
                ),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (item != null || detail != null)
                            Semantics(
                              header: true,
                              child: Text(
                                item?.title ?? detail!.course.title,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                            ),
                          if (state.busy)
                            const Center(child: CircularProgressIndicator()),
                          if (state.failure != null) ...[
                            Text(
                              state.failure == CourseFailure.network
                                  ? text.networkError
                                  : text.courseUnavailable,
                              semanticsLabel:
                                  state.failure == CourseFailure.network
                                  ? text.networkError
                                  : text.courseUnavailable,
                            ),
                            FilledButton(
                              onPressed: model.load,
                              child: Text(text.authRetry),
                            ),
                          ],
                          if (item != null &&
                              model.repository.contentIsStale(item.courseId))
                            Text(
                              '${Localizations.localeOf(context).languageCode == 'uk' ? 'Збережено офлайн · Оновлено' : 'Offline copy · Last refreshed'} ${model.repository.contentRefreshedAt(item.courseId) == null ? '' : DateFormat.yMd(Localizations.localeOf(context).toString()).add_jm().format(model.repository.contentRefreshedAt(item.courseId)!.toLocal())}',
                            ),
                          if (state.courses case final courses?) ...[
                            if (model.downloadingCourseId != null)
                              LinearProgressIndicator(
                                value: model.downloadTotal == 0
                                    ? null
                                    : model.downloadDone / model.downloadTotal,
                              ),
                            if (model.downloadingCourseId != null)
                              TextButton.icon(
                                onPressed: model.cancelDownload,
                                icon: const Icon(Icons.close),
                                label: Text(
                                  Localizations.localeOf(
                                            context,
                                          ).languageCode ==
                                          'uk'
                                      ? 'Скасувати завантаження'
                                      : 'Cancel download',
                                ),
                              ),
                            if (model.repository.listIsStale)
                              Text(
                                '${Localizations.localeOf(context).languageCode == 'uk' ? 'Збережено офлайн · Оновлено' : 'Offline copy · Last refreshed'} ${model.repository.listRefreshedAt == null ? '' : DateFormat.yMd(Localizations.localeOf(context).toString()).add_jm().format(model.repository.listRefreshedAt!.toLocal())}',
                              ),
                            if (courses.isEmpty) Text(text.courseEmpty),
                            if (model.repository.supportsPreferences)
                              Wrap(
                                spacing: 8,
                                children: [
                                  ChoiceChip(
                                    label: Text(
                                      Localizations.localeOf(
                                                context,
                                              ).languageCode ==
                                              'uk'
                                          ? 'Усі'
                                          : 'All',
                                    ),
                                    selected: !_showHidden && !_showFavorites,
                                    onSelected: (_) => setState(() {
                                      _showHidden = false;
                                      _showFavorites = false;
                                    }),
                                  ),
                                  ChoiceChip(
                                    label: Text(
                                      Localizations.localeOf(
                                                context,
                                              ).languageCode ==
                                              'uk'
                                          ? 'Обрані'
                                          : 'Favorites',
                                    ),
                                    selected: _showFavorites,
                                    onSelected: (_) => setState(() {
                                      _showFavorites = true;
                                      _showHidden = false;
                                    }),
                                  ),
                                  ChoiceChip(
                                    label: Text(
                                      Localizations.localeOf(
                                                context,
                                              ).languageCode ==
                                              'uk'
                                          ? 'Приховані'
                                          : 'Hidden',
                                    ),
                                    selected: _showHidden,
                                    onSelected: (_) => setState(() {
                                      _showHidden = true;
                                      _showFavorites = false;
                                    }),
                                  ),
                                ],
                              ),
                            for (final role in [
                              'student',
                              'teacher',
                              null,
                            ]) ...[
                              if (courses.any((c) => c.role == role))
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    role == 'teacher'
                                        ? text.homeTeachCourses
                                        : role == 'student'
                                        ? text.homeStudyCourses
                                        : text.coursesTab,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                ),
                              for (final course in courses.where(
                                (course) =>
                                    course.role == role &&
                                    (_showHidden
                                        ? course.hidden
                                        : !course.hidden &&
                                              (!_showFavorites ||
                                                  course.starred)),
                              ))
                                Card(
                                  child: Stack(
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                          Icons.menu_book_outlined,
                                        ),
                                        title: Text(course.title),
                                        subtitle: course.category == null
                                            ? null
                                            : Text(course.category!),
                                        trailing:
                                            model.repository.supportsPreferences
                                            ? CourseActionsMenu(
                                                hidden: course.hidden,
                                                starred: course.starred,
                                                downloadEnabled:
                                                    model.downloads != null &&
                                                    model.downloadingCourseId ==
                                                        null &&
                                                    !model
                                                        .repository
                                                        .listIsStale,
                                                mutationEnabled: !model
                                                    .repository
                                                    .listIsStale,
                                                downloaded: model
                                                    .downloadedCourseIds
                                                    .contains(course.id),
                                                onDownload: () =>
                                                    _confirmDownload(
                                                      model,
                                                      course,
                                                    ),
                                                onHide: () =>
                                                    model.setHidden(course),
                                                onStar: () =>
                                                    model.setStarred(course),
                                              )
                                            : const Icon(Icons.chevron_right),
                                        onTap: () => context.push(
                                          '/courses/${course.id}',
                                        ),
                                      ),
                                      if (course.starred)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Semantics(
                                            container: true,
                                            label: text.courseFavoriteStatus,
                                            child: const Icon(
                                              Icons.star,
                                              size: 20,
                                              color: Color(0xFFFFC107),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ],
                          if (detail != null) ...[
                            if (model.repository.contentIsStale(
                              detail.course.id,
                            ))
                              Text(
                                '${Localizations.localeOf(context).languageCode == 'uk' ? 'Збережено офлайн · Оновлено' : 'Offline copy · Last refreshed'} ${model.repository.contentRefreshedAt(detail.course.id) == null ? '' : DateFormat.yMd(Localizations.localeOf(context).toString()).add_jm().format(model.repository.contentRefreshedAt(detail.course.id)!.toLocal())}',
                              ),
                            if (detail.teacherView &&
                                teachingRepositoryOf(context) != null)
                              TextButton.icon(
                                onPressed: () => context.push(
                                  '$basePath/teaching',
                                ),
                                icon: const Icon(Icons.school_outlined),
                                label: Text(
                                  teachingText(context).homeTeachCourses,
                                ),
                              ),
                            if (detail.course.category case final category?)
                              Text(category),
                            if (detail.course.summary case final summary?)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: SelectableText(summary),
                              ),
                            if (detail.course.teacherName case final teacher?)
                              Text(teacher),
                            if (detail.sections.isEmpty ||
                                detail.sections.every(
                                  (s) => s.activities.isEmpty,
                                ))
                              Text(text.courseContentEmpty),
                            for (final section in detail.sections)
                              Card(
                                key: _sections.putIfAbsent(
                                  section.id,
                                  GlobalKey.new,
                                ),
                                child: ExpansionTile(
                                  key: PageStorageKey(section.id),
                                  initiallyExpanded: true,
                                  title: Text(section.title),
                                  subtitle: section.draft
                                      ? Text(text.courseDraft)
                                      : null,
                                  children: [
                                    if (detail.teacherView &&
                                        teachingRepositoryOf(context) != null)
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: OutlinedButton.icon(
                                          onPressed: () async {
                                            final saved =
                                                await Navigator.of(
                                                  context,
                                                ).push<bool>(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        TeachingEditor(
                                                          courseId:
                                                              detail.course.id,
                                                          initialSectionId:
                                                              section.id,
                                                          kind: 'test',
                                                        ),
                                                  ),
                                                );
                                            if (saved == true &&
                                                context.mounted) {
                                              await model.load();
                                            }
                                          },
                                          icon: const Icon(Icons.add),
                                          label: Text(text.teachingCreateTest),
                                        ),
                                      ),
                                    if (section.activities.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Text(text.courseContentEmpty),
                                      ),
                                    if (section.description
                                        case final description?)
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: SelectableText(description),
                                      ),
                                    for (final activity in section.activities)
                                      ListTile(
                                        leading: Icon(_icon(activity.kind)),
                                        title: Text(activity.title),
                                        subtitle: Text(
                                          [
                                            _kind(text, activity.kind),
                                            if (activity.draft)
                                              text.courseDraft,
                                            if (activity.file != null)
                                              activity.file!.name,
                                            if (activity.availability != null)
                                              _availability(
                                                text,
                                                activity.availability!,
                                              ),
                                          ].join(' · '),
                                        ),
                                        trailing:
                                            detail.teacherView &&
                                                widget.notebookAvailable &&
                                                !activity.draft &&
                                                (activity.kind ==
                                                        ActivityKind.module ||
                                                    activity.kind ==
                                                        ActivityKind.test)
                                            ? IconButton(
                                                tooltip: text.localeName == 'uk'
                                                    ? 'Налаштування блокнота'
                                                    : 'Notebook settings',
                                                icon: const Icon(
                                                  Icons.auto_stories_outlined,
                                                ),
                                                onPressed: () => context.push(
                                                  '$basePath/activity/${activity.id}/notebook-settings',
                                                ),
                                              )
                                            : const Icon(Icons.chevron_right),
                                        onTap: () => context.push(
                                          '$basePath/activity/${activity.id}',
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                          if (item != null) ...[
                            if (item.draft) Chip(label: Text(text.courseDraft)),
                            if (item.description case final description?)
                              SelectableText(description),
                            if (item.kind == ActivityKind.announcement) ...[
                              if (item.author case final author?) Text(author),
                              if (item.publishedAt case final date?)
                                Text(localDate(context, date)),
                              const SizedBox(height: 16),
                              SelectableText(item.body ?? ''),
                            ],
                            if (item.file case final file?) ...[
                              Text(file.name),
                              if (file.sizeBytes > 0)
                                Text('${file.sizeBytes} B'),
                              if (file.mimeType ==
                                  'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
                                Text(text.courseDocxNotice),
                            ],
                            if (item.kind == ActivityKind.link) ...[
                              SelectableText(item.url ?? ''),
                              Text(text.courseExternalLink),
                            ],
                            if (item.kind == ActivityKind.module ||
                                item.kind == ActivityKind.lab ||
                                item.kind == ActivityKind.assignment ||
                                item.kind == ActivityKind.test) ...[
                              Chip(
                                label: Text(
                                  _availability(
                                    text,
                                    item.availability ?? 'unscheduled',
                                  ),
                                ),
                              ),
                              SelectableText(item.instructions ?? ''),
                              if (item.opensAt case final date?)
                                Text(
                                  '${text.courseOpens}: ${localDate(context, date)}',
                                ),
                              if (item.closesAt case final date?)
                                Text(
                                  '${text.courseCloses}: ${localDate(context, date)}',
                                ),
                              if (item.attemptLimit case final limit?)
                                Text('${text.courseAttemptLimit}: $limit'),
                              if (item.timeLimitMinutes case final limit?)
                                Text('${text.courseTimeLimit}: $limit'),
                              const SizedBox(height: 16),
                              if (item.managedAssessment &&
                                  teachingRepositoryOf(context) != null)
                                FilledButton(
                                  onPressed: () => context.push(
                                    '$basePath/activity/${item.id}/work',
                                  ),
                                  child: Text(
                                    teachingText(context).teachingViewWork,
                                  ),
                                )
                              else
                                Text(text.courseReadOnly),
                            ],
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                if (item.previousId case final id?)
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => context.replace(
                                        '$basePath/activity/$id',
                                      ),
                                      child: Text(text.coursePrevious),
                                    ),
                                  ),
                                if (item.previousId != null &&
                                    item.nextId != null)
                                  const SizedBox(width: 12),
                                if (item.nextId case final id?)
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => context.replace(
                                        '$basePath/activity/$id',
                                      ),
                                      child: Text(text.courseNext),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (item.file != null ||
                                item.kind == ActivityKind.link)
                              FilledButton.icon(
                                onPressed: state.opening
                                    ? null
                                    : () async {
                                        final generation =
                                            model.repository.generation;
                                        final uri = await model.open();
                                        if (!context.mounted ||
                                            uri == null ||
                                            generation !=
                                                model.repository.generation) {
                                          return;
                                        }
                                        final path =
                                            '$basePath/activity/${item.id}';
                                        final router = GoRouter.of(context);
                                        if (router.state.uri.path != path) {
                                          return;
                                        }
                                        context.push(
                                          '$path/browser',
                                          extra: CourseBrowserRequest(
                                            uri: uri,
                                            title: item.title,
                                            courseId: item.courseId,
                                            activityId: item.id,
                                            generation: generation,
                                          ),
                                        );
                                      },
                                icon: state.opening
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.open_in_new),
                                label: Text(
                                  item.file != null
                                      ? text.courseOpenFile
                                      : text.courseOpenLink,
                                ),
                              ),
                            if (state.openFailure != null)
                              Text(
                                state.openFailure == CourseFailure.unavailable
                                    ? text.courseUnavailable
                                    : item.kind == ActivityKind.link
                                    ? text.courseLinkError
                                    : state.openFailure ==
                                          CourseFailure.noHandler
                                    ? text.courseNoHandler
                                    : text.courseFileError,
                              ),
                            const SizedBox(height: 24),
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

IconData _icon(ActivityKind kind) => switch (kind) {
  ActivityKind.file => Icons.description_outlined,
  ActivityKind.link => Icons.link,
  ActivityKind.announcement => Icons.campaign_outlined,
  ActivityKind.lab => Icons.science_outlined,
  ActivityKind.assignment => Icons.assignment_outlined,
  ActivityKind.module || ActivityKind.test => Icons.quiz_outlined,
};
String _kind(AppLocalizations text, ActivityKind kind) => switch (kind) {
  ActivityKind.file => text.courseFile,
  ActivityKind.link => text.courseLink,
  ActivityKind.announcement => text.courseAnnouncement,
  ActivityKind.lab => text.courseLab,
  ActivityKind.assignment => text.calendarAssignment,
  ActivityKind.module || ActivityKind.test => text.calendarTest,
};
String _availability(AppLocalizations text, String value) => switch (value) {
  'available' => text.courseAvailable,
  'upcoming' => text.courseUpcoming,
  'closed' => text.courseClosed,
  _ => text.courseUnscheduled,
};
