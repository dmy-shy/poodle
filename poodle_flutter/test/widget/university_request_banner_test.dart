import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/app/l10n/app_localizations.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/notifications_repository.dart';
import 'package:poodle_flutter/features/messaging/presentation/widgets/incoming_message_banner.dart';

class _RequestNotifications extends NotificationsRepository {
  @override
  Future<List<PoodleNotification>> list({
    required int offset,
    required int limit,
    String? category,
    bool unreadOnly = false,
  }) async => [
    for (final id in ['one', 'two'])
      PoodleNotification(
        id: id,
        requestId: id,
        category: 'universityRequest',
        title: 'VNU',
        createdAt: DateTime.utc(2026, 11, 15),
        readAt: null,
      ),
  ];

  @override
  Future<void> markRead(String id) async {}
  @override
  Future<int> unreadCount() async => 2;
  @override
  Future<void> markAllRead() async {}
}

void main() {
  testWidgets('groups signed-in request alerts and opens a request', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      restoredSession: const AuthSession(
        'admin@example.test',
        userId: 'admin',
        isAdmin: true,
      ),
      latency: Duration.zero,
    );
    addTearDown(auth.dispose);
    PoodleNotification? opened;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => IncomingMessageBanner(
          repository: null,
          notifications: _RequestNotifications(),
          auth: auth,
          currentPath: () => '/home',
          onOpen: (_) {},
          onOpenRequest: (item) => opened = item,
          child: child!,
        ),
        home: const Scaffold(body: Text('Home')),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('New university request'), findsOneWidget);
    expect(
      find.text('New university requests are ready for review'),
      findsOneWidget,
    );
    await tester.tap(find.text('New university request'));
    expect(opened?.requestId, 'one');
  });
}
