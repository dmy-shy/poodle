import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../view_models/notifications_view_model.dart';
import '../../../../data/repositories/auth_repository.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<NotificationsViewModel>();
    final copy = _Copy(Localizations.localeOf(context).languageCode == 'uk');
    final colors = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final admin = context.watch<AuthRepository>().session?.isAdmin == true;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).notificationsTab),
        actions: [
          if (model.unreadCount > 0)
            TextButton(
              onPressed: model.loading || model.isStale
                  ? null
                  : model.markAllRead,
              child: Text(copy.markAllRead),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      copy.unread(model.unreadCount),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final entry in <(String?, String)>[
                            (null, copy.all),
                            ('assignment', copy.assignment),
                            ('deadline', copy.deadline),
                            ('grade', copy.grade),
                            if (admin)
                              ('universityRequest', t.institutionOperator),
                          ])
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(entry.$2),
                                selected: model.category == entry.$1,
                                onSelected: (_) => model.filter(entry.$1),
                              ),
                            ),
                        ],
                      ),
                    ),
                    FilterChip(
                      label: Text(copy.unreadOnly),
                      selected: model.unreadOnly,
                      onSelected: (value) =>
                          model.filter(model.category, onlyUnread: value),
                    ),
                  ],
                ),
              ),
              if (model.isStale)
                MaterialBanner(
                  content: Text(
                    '${copy.uk ? 'Збережено офлайн · Оновлено' : 'Offline copy · Last refreshed'} ${model.lastRefreshedAt == null ? '' : DateFormat.yMd(Localizations.localeOf(context).toString()).add_jm().format(model.lastRefreshedAt!.toLocal())}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: model.refresh,
                      child: Text(copy.retry),
                    ),
                  ],
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: model.refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      if (model.loading)
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (model.items.isEmpty && model.error == null)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(child: Text(copy.empty)),
                        ),
                      for (final item in model.items)
                        ListTile(
                          key: ValueKey(item.id),
                          leading: CircleAvatar(
                            backgroundColor: item.unread
                                ? colors.primaryContainer
                                : colors.surfaceContainerHighest,
                            child: Icon(
                              switch (item.category) {
                                'deadline' => Icons.schedule_outlined,
                                'grade' => Icons.workspace_premium_outlined,
                                _ => Icons.assignment_outlined,
                              },
                              color: item.unread
                                  ? colors.onPrimaryContainer
                                  : colors.onSurfaceVariant,
                            ),
                          ),
                          title: Text(
                            item.category == 'universityRequest'
                                ? '${t.institutionNewRequestAlert}: ${item.title}'
                                : item.title,
                            style: TextStyle(
                              fontWeight: item.unread
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            '${item.category == 'universityRequest' ? t.institutionOperator : copy.category(item.category)} · '
                            '${DateFormat.yMMMd(Localizations.localeOf(context).toString()).add_jm().format(item.createdAt.toLocal())}',
                          ),
                          trailing: item.unread
                              ? Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: colors.primary,
                                )
                              : null,
                          onTap: () async {
                            await model.markRead(item);
                            if (!context.mounted) return;
                            final courseId = item.courseId;
                            final activityId = item.activityId;
                            if (courseId != null && activityId != null) {
                              context.go(
                                '/courses/$courseId/activity/$activityId',
                              );
                            } else if (item.requestId != null && admin) {
                              context.push(
                                '/more/university-requests?requestId=${item.requestId}',
                              );
                            }
                          },
                        ),
                      if (model.error != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(copy.error),
                                TextButton(
                                  onPressed: model.items.isEmpty
                                      ? model.refresh
                                      : model.loadMore,
                                  child: Text(copy.retry),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (model.hasMore && model.items.isNotEmpty)
                        Center(
                          child: TextButton(
                            onPressed: model.loadingMore
                                ? null
                                : model.loadMore,
                            child: model.loadingMore
                                ? const CircularProgressIndicator()
                                : Text(copy.loadMore),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Copy {
  const _Copy(this.uk);
  final bool uk;
  String get all => uk ? 'Усі' : 'All';
  String get assignment => uk ? 'Завдання' : 'Assignments';
  String get deadline => uk ? 'Терміни' : 'Deadlines';
  String get grade => uk ? 'Оцінки' : 'Grades';
  String get unreadOnly => uk ? 'Лише непрочитані' : 'Unread only';
  String get markAllRead => uk ? 'Прочитати всі' : 'Mark all read';
  String get empty => uk ? 'Сповіщень поки немає' : 'No notifications yet';
  String get error =>
      uk ? 'Не вдалося завантажити сповіщення' : 'Could not load notifications';
  String get retry => uk ? 'Повторити' : 'Retry';
  String get loadMore => uk ? 'Показати ще' : 'Load more';
  String unread(int count) => uk ? 'Непрочитаних: $count' : 'Unread: $count';
  String category(String value) => switch (value) {
    'assignment' => assignment,
    'deadline' => deadline,
    'grade' => grade,
    _ => uk ? 'Оновлення' : 'Update',
  };
}
