import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/calendar_repository.dart';
import '../../../../data/repositories/course_repository.dart';
import '../../../dashboard/presentation/dashboard_copy.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _month;
  late DateTime _selected;
  int _view = 0;
  int _upcomingDays = 30;
  Set<String> _courses = {};
  Set<ActivityKind> _kinds = {};

  @override
  void initState() {
    super.initState();
    _month = DateTime(DateTime.now().year, DateTime.now().month);
    _selected = DateUtils.dateOnly(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<CalendarRepository>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<CalendarRepository>();
    final text = AppLocalizations.of(context);
    final snapshot = repo.snapshot;
    final allEvents = snapshot?.events ?? const <CalendarEvent>[];
    final courseIds = allEvents.map((e) => e.course.id).toSet();
    _courses = _courses.intersection(courseIds);
    final kinds = allEvents.map((e) => e.activity.kind).toSet();
    _kinds = _kinds.intersection(kinds);
    final events = allEvents
        .where(
          (e) =>
              (_courses.isEmpty || _courses.contains(e.course.id)) &&
              (_kinds.isEmpty || _kinds.contains(e.activity.kind)),
        )
        .toList();
    final now = DateTime.now().toUtc();
    final displayed = switch (_view) {
      1 =>
        events
            .where(
              (e) =>
                  e.atUtc.isAfter(now) &&
                  e.atUtc.isBefore(now.add(Duration(days: _upcomingDays))),
            )
            .toList(),
      2 => _openEvents(repo, events),
      _ =>
        events
            .where((e) => DateUtils.isSameDay(e.atUtc.toLocal(), _selected))
            .toList(),
    };
    final markedDays = events
        .map((e) => DateUtils.dateOnly(e.atUtc.toLocal()))
        .toSet();
    return Scaffold(
      appBar: AppBar(
        title: Text(text.dashboardCalendar),
        actions: [
          PopupMenuButton<String>(
            tooltip: text.calendarFilter,
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => setState(() {
              if (value.startsWith('course:')) {
                final id = value.substring(7);
                if (!_courses.add(id)) _courses.remove(id);
              } else if (value.startsWith('kind:')) {
                final kind = ActivityKind.values.byName(value.substring(5));
                if (!_kinds.add(kind)) _kinds.remove(kind);
              } else {
                _courses.clear();
                _kinds.clear();
              }
            }),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'all', child: Text(text.calendarAllFilters)),
              for (final course in {
                for (final e in allEvents) e.course.id: e.course,
              }.values)
                CheckedPopupMenuItem(
                  value: 'course:${course.id}',
                  checked: _courses.contains(course.id),
                  child: Text(course.title),
                ),
              for (final kind in kinds)
                CheckedPopupMenuItem(
                  value: 'kind:${kind.name}',
                  checked: _kinds.contains(kind),
                  child: Text(_kindName(text, kind)),
                ),
            ],
          ),
          IconButton(
            tooltip: text.dashboardRefresh,
            onPressed: () => repo.load(refresh: true),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await repo.load(refresh: true);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            if (snapshot?.stale == true)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.cloud_off_outlined),
                  title: Text(text.calendarCached),
                ),
              ),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(value: 0, label: Text(text.calendarMonth)),
                    ButtonSegment(
                      value: 1,
                      label: Text(
                        text.localeName == "uk" ? "Незабаром" : "Upcoming",
                      ),
                    ),
                    ButtonSegment(value: 2, label: Text(text.calendarOpenNow)),
                  ],
                  selected: {_view},
                  onSelectionChanged: (values) =>
                      setState(() => _view = values.first),
                ),
              ),
            ),
            if (_view == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: text.calendarPreviousMonth,
                    onPressed: () => setState(
                      () => _month = DateTime(_month.year, _month.month - 1),
                    ),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text(
                      MaterialLocalizations.of(context).formatMonthYear(_month),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _month = DateTime.now();
                      _selected = DateUtils.dateOnly(DateTime.now());
                    }),
                    child: Text(text.calendarToday),
                  ),
                  IconButton(
                    tooltip: text.calendarNextMonth,
                    onPressed: () => setState(
                      () => _month = DateTime(_month.year, _month.month + 1),
                    ),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              _MonthGrid(
                month: _month,
                selected: _selected,
                marked: markedDays,
                onSelect: (day) => setState(() => _selected = day),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              _view == 2
                  ? text.calendarOpenNow
                  : _view == 1
                  ? text.calendarUpcoming
                  : MaterialLocalizations.of(context).formatFullDate(_selected),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (snapshot == null)
              const Padding(
                padding: EdgeInsets.all(36),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (displayed.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(text.calendarNoEvents),
              )
            else
              for (final event in displayed)
                Card(
                  child: ListTile(
                    leading: Icon(
                      event.activity.kind == ActivityKind.test
                          ? Icons.quiz_outlined
                          : Icons.assignment_outlined,
                    ),
                    title: Text(event.activity.title),
                    subtitle: Text(
                      '${event.course.title}\n${event.moment == CalendarMoment.opening ? text.calendarOpens : text.calendarCloses} · ${localDate(context, event.atUtc)}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showEvent(context, event),
                  ),
                ),
            if (_view == 1 && displayed.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _upcomingDays += 30),
                child: Text(text.calendarLoadMore),
              ),
          ],
        ),
      ),
    );
  }

  List<CalendarEvent> _openEvents(
    CalendarRepository repo,
    List<CalendarEvent> events,
  ) {
    final ids = repo.openActivities.map((a) => a.id).toSet();
    final nextEventByActivity = <String, CalendarEvent>{};
    for (final event in events.where((e) => ids.contains(e.activity.id))) {
      final prior = nextEventByActivity[event.activity.id];
      final shouldPreferClose =
          event.moment == CalendarMoment.closing &&
          event.atUtc.isAfter(DateTime.now().toUtc());
      if (prior == null || shouldPreferClose) {
        nextEventByActivity[event.activity.id] = event;
      }
    }
    return nextEventByActivity.values.toList();
  }

  void _showEvent(BuildContext context, CalendarEvent event) {
    final text = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.activity.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                '${event.moment == CalendarMoment.opening ? text.calendarOpens : text.calendarCloses}: ${localDate(context, event.atUtc)}',
              ),
              Text('${text.calendarCourse}: ${event.course.title}'),
              Text(
                '${text.calendarType}: ${_kindName(text, event.activity.kind)}',
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  context.push(
                    '/home/course/${event.course.id}/activity/${event.activity.id}',
                  );
                },
                child: Text(text.calendarGoToActivity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.selected,
    required this.marked,
    required this.onSelect,
  });
  final DateTime month, selected;
  final Set<DateTime> marked;
  final ValueChanged<DateTime> onSelect;
  @override
  Widget build(BuildContext context) {
    final locale = MaterialLocalizations.of(context);
    final firstOffset = (DateTime(month.year, month.month, 1).weekday + 6) % 7;
    final count = DateUtils.getDaysInMonth(month.year, month.month);
    final rows = ((firstOffset + count + 6) ~/ 7);
    final weekdays = [
      for (var i = 0; i < 7; i++) locale.narrowWeekdays[(i + 1) % 7],
    ];
    return Column(
      children: [
        Row(
          children: [
            for (final day in weekdays)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      day,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ),
          ],
        ),
        for (var week = 0; week < rows; week++)
          Row(
            children: [
              for (var weekday = 0; weekday < 7; weekday++)
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: Builder(
                      builder: (context) {
                        final dayNumber = week * 7 + weekday - firstOffset + 1;
                        if (dayNumber < 1 || dayNumber > count) {
                          return const SizedBox.shrink();
                        }
                        final day = DateTime(
                          month.year,
                          month.month,
                          dayNumber,
                        );
                        final isSelected = DateUtils.isSameDay(day, selected);
                        final hasEvents = marked.any(
                          (value) => DateUtils.isSameDay(value, day),
                        );
                        return InkWell(
                          onTap: () => onSelect(day),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                child: Text(
                                  '$dayNumber',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              if (hasEvents)
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

String _kindName(AppLocalizations text, ActivityKind kind) => switch (kind) {
  ActivityKind.assignment => text.calendarAssignment,
  ActivityKind.test || ActivityKind.module => text.calendarTest,
  ActivityKind.lab => text.courseLab,
  _ => text.courseFile,
};
