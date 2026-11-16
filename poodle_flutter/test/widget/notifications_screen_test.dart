import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/notifications_repository.dart';
import 'package:poodle_flutter/features/notifications/presentation/views/notifications_screen.dart';
import 'package:poodle_flutter/features/notifications/presentation/view_models/notifications_view_model.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';

class _Notifications extends NotificationsRepository {
  String? lastCategory;
  bool lastUnreadOnly = false;
  bool allMarked = false;

  @override
  Future<List<PoodleNotification>> list({
    required int offset,
    required int limit,
    String? category,
    bool unreadOnly = false,
  }) async {
    lastCategory = category;
    lastUnreadOnly = unreadOnly;
    if (allMarked && unreadOnly) return [];
    return [
      if (category == null || category == 'assignment')
        PoodleNotification(
          id: 'one',
          category: 'assignment',
          title: 'Practice essay',
          createdAt: DateTime.utc(2026, 11, 5),
          readAt: allMarked ? DateTime.utc(2026, 11, 5) : null,
        ),
    ];
  }

  @override
  Future<int> unreadCount() async => allMarked ? 0 : 1;

  @override
  Future<void> markRead(String id) async => allMarked = true;

  @override
  Future<void> markAllRead() async => allMarked = true;
}

void main() {
  testWidgets('filters and marks the live inbox as read', (tester) async {
    final auth = FakeAuthRepository(
      restoredSession: const AuthSession('student@example.test', userId: 'one'),
      latency: Duration.zero,
    );
    final repository = _Notifications();
    final model = NotificationsViewModel(repository, auth)..refresh();
    addTearDown(model.dispose);
    addTearDown(auth.dispose);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthRepository>.value(value: auth),
          ChangeNotifierProvider.value(value: model),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const NotificationsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Practice essay'), findsOneWidget);
    expect(find.text('Unread: 1'), findsOneWidget);

    await tester.tap(find.text('Unread only'));
    await tester.pumpAndSettle();
    expect(repository.lastUnreadOnly, isTrue);

    await tester.tap(find.text('Mark all read'));
    await tester.pumpAndSettle();
    expect(repository.allMarked, isTrue);
    expect(find.text('No notifications yet'), findsOneWidget);
  });
}
