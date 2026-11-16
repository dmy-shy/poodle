import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/repositories/dashboard_repository.dart';
import '../features/dashboard/presentation/dashboard_copy.dart';
import 'l10n/app_localizations.dart';

class PreviewDestination extends StatelessWidget {
  const PreviewDestination({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_stories_outlined, size: 64),
                const SizedBox(height: 16),
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  text.localeName == "uk"
                      ? "Ця функція недоступна."
                      : "This feature is unavailable.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: Text(text.dashboardBack),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MoreDestination extends StatelessWidget {
  const MoreDestination({super.key, required this.onSignOut});
  final VoidCallback onSignOut;
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final entries = <(String, String, IconData)>[
      ('calendar', text.dashboardCalendar, Icons.calendar_month_outlined),
      ('tasks', text.dashboardTasks, Icons.checklist_outlined),
      ('downloads', text.dashboardDownloads, Icons.download_outlined),
      ('grades', text.dashboardGrades, Icons.grade_outlined),
      ('files', text.dashboardFiles, Icons.folder_outlined),
      ('profile', text.dashboardProfile, Icons.person_outline),
      ('settings', text.dashboardSettings, Icons.settings_outlined),
      ('help', text.dashboardHelp, Icons.help_outline),
    ];
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Semantics(
              header: true,
              child: Text(
                text.moreTab,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 16),
            for (final (id, label, icon) in entries)
              ListTile(
                leading: Icon(icon),
                title: Text(label),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  switch (id) {
                    case 'calendar':
                      context.go('/calendar');
                    case 'profile':
                      context.push('/profile');
                    case 'help':
                      context.push('/help');
                    default:
                      context.push('/more/feature/$id');
                  }
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(text.signOut),
              onTap: onSignOut,
            ),
          ],
        ),
      ),
    );
  }
}

String moreFeatureTitle(AppLocalizations text, String id) => switch (id) {
  'calendar' => text.dashboardCalendar,
  'tasks' => text.dashboardTasks,
  'downloads' => text.dashboardDownloads,
  'grades' => text.dashboardGrades,
  'files' => text.dashboardFiles,
  'profile' => text.dashboardProfile,
  'settings' => text.dashboardSettings,
  'help' => text.dashboardHelp,
  _ => text.moreTab,
};

class AnnouncementListPreview extends StatelessWidget {
  const AnnouncementListPreview({super.key, required this.snapshot});
  final DashboardSnapshot? snapshot;
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Semantics(
              header: true,
              child: Text(
                text.dashboardAnnouncements,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            if (snapshot?.announcements.isEmpty ?? true)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(text.dashboardEmptyAnnouncements),
              ),
            for (final announcement
                in snapshot?.announcements ?? <DashboardAnnouncement>[])
              ListTile(
                title: Text(announcementTitle(text, announcement.id)),
                subtitle: Text(announcementExcerpt(text, announcement.id)),
                onTap: () =>
                    context.push('/home/announcement/${announcement.id}'),
              ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementPreview extends StatelessWidget {
  const AnnouncementPreview({
    super.key,
    required this.id,
    required this.snapshot,
  });
  final String id;
  final DashboardSnapshot? snapshot;
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final announcement = snapshot?.announcements
        .where((item) => item.id == id)
        .firstOrNull;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Semantics(
            header: true,
            child: Text(
              announcementTitle(text, id),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 12),
          if (announcement != null)
            Text(courseTitle(text, announcement.courseId)),
          if (announcement != null)
            Text(localDate(context, announcement.publishedAtUtc)),
          const SizedBox(height: 20),
          Text(announcementBody(text, id)),
          const SizedBox(height: 20),
          Text(text.dashboardFeaturePreview),
          TextButton(onPressed: context.pop, child: Text(text.dashboardBack)),
        ],
      ),
    );
  }
}
