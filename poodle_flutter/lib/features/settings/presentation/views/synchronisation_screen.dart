import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/repositories/course_repository.dart';
import '../../../../data/services/course_download_service.dart';
import '../../../../data/services/sync_coordinator.dart';

class SynchronisationScreen extends StatefulWidget {
  const SynchronisationScreen({
    super.key,
    required this.repository,
    this.downloads,
    this.sync,
  });
  final CourseRepository repository;
  final CourseDownloadService? downloads;
  final SyncCoordinator? sync;
  @override
  State<SynchronisationScreen> createState() => _SynchronisationScreenState();
}

class _SynchronisationScreenState extends State<SynchronisationScreen> {
  bool _busy = false;
  bool _failed = false;
  @override
  void initState() {
    super.initState();
    widget.sync?.addListener(_changed);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _refresh();
    });
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.sync?.removeListener(_changed);
    super.dispose();
  }

  Future<void> _refresh() async {
    if (widget.sync != null) {
      await widget.sync!.refresh();
      return;
    }
    if (_busy) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      final courses = await widget.repository.list();
      if (!widget.repository.listIsStale) {
        await widget.downloads?.reconcileInventory(courses);
      }
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uk = Localizations.localeOf(context).languageCode == 'uk';
    final sync = widget.sync;
    final states = sync == null
        ? <SyncState>[]
        : [
            for (final area in SyncArea.values) sync.status(area).state,
          ];
    final partial =
        states.contains(SyncState.current) &&
        states.any(
          (state) => state == SyncState.cached || state == SyncState.failed,
        );
    final refreshed = widget.repository.listRefreshedAt;
    final status = partial
        ? (uk ? 'Часткова синхронізація' : 'Partial sync')
        : states.contains(SyncState.failed)
        ? (uk ? 'Помилка синхронізації' : 'Sync failed')
        : states.contains(SyncState.cached)
        ? (uk ? 'Збережено офлайн' : 'Offline copy')
        : states.contains(SyncState.refreshing)
        ? (uk ? 'Синхронізація…' : 'Syncing…')
        : _failed
        ? (uk ? 'Не вдалося оновити курси' : 'Could not refresh courses')
        : _busy
        ? (uk ? 'Синхронізація…' : 'Syncing…')
        : widget.repository.listIsStale
        ? (uk ? 'Збережено офлайн' : 'Offline copy')
        : refreshed == null && widget.repository.supportsPreferences
        ? (uk ? 'Ще не синхронізовано' : 'Never synced')
        : (uk ? 'Оновлено' : 'Up to date');
    return Scaffold(
      appBar: AppBar(title: Text(uk ? 'Синхронізація' : 'Synchronisation')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (sync != null)
            for (final area in [
              SyncArea.courses,
              SyncArea.calendar,
              SyncArea.notebook,
              SyncArea.notifications,
            ])
              if (sync.status(area).state != SyncState.never ||
                  area == SyncArea.courses)
                ListTile(
                  title: Text(
                    uk
                        ? switch (area) {
                            SyncArea.courses => 'Курси',
                            SyncArea.calendar => 'Календар',
                            SyncArea.notebook => 'Нотатник',
                            SyncArea.notifications => 'Сповіщення',
                            _ => 'Завантаження',
                          }
                        : area.name[0].toUpperCase() + area.name.substring(1),
                  ),
                  subtitle: Text(switch (sync.status(area).state) {
                    SyncState.never =>
                      uk ? 'Ще не синхронізовано' : 'Never synced',
                    SyncState.refreshing => uk ? 'Синхронізація…' : 'Syncing…',
                    SyncState.current => uk ? 'Оновлено' : 'Up to date',
                    SyncState.cached => uk ? 'Збережено офлайн' : 'Cached',
                    SyncState.failed => uk ? 'Помилка' : 'Failed',
                  }),
                ),
          if (sync == null)
            Text(
              uk ? 'Курси' : 'Courses',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          if (sync == null) const SizedBox(height: 8),
          Text(status),
          if (refreshed != null)
            Text(
              '${uk ? 'Останнє оновлення' : 'Last refreshed'}: ${DateFormat.yMd(Localizations.localeOf(context).toString()).add_jm().format(refreshed.toLocal())}',
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _busy ? null : _refresh,
            icon: Icon(_failed ? Icons.refresh : Icons.sync),
            label: Text(
              _failed
                  ? (uk ? 'Повторити' : 'Retry')
                  : (uk ? 'Синхронізувати зараз' : 'Sync now'),
            ),
          ),
        ],
      ),
    );
  }
}
