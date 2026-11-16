import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_flutter/ui/notifications/app_notification_banner.dart';
import 'package:poodle_flutter/features/messaging/presentation/widgets/incoming_message_banner.dart';
import 'package:poodle_flutter/data/repositories/auth_repository.dart';
import 'package:poodle_flutter/data/repositories/fake_auth_repository.dart';
import 'package:poodle_flutter/data/repositories/messaging_repository.dart';
import 'package:poodle_flutter/features/messaging/presentation/views/messaging_screen.dart';
import 'package:poodle_flutter/features/messaging/presentation/view_models/messaging_view_model.dart';
import 'package:provider/provider.dart';

import '../support/test_app.dart';

void main() {
  testWidgets('Ukrainian inbox and recipient picker translate app copy', (
    tester,
  ) async {
    final auth = FakeAuthRepository(latency: Duration.zero);
    await tester.pumpWidget(
      testApp(
        ChangeNotifierProvider(
          create: (_) => MessagingViewModel(const _MessagingFake(), auth),
          child: const MessagingScreen(),
        ),
        locale: const Locale('uk'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Повідомлення'), findsOneWidget);
    expect(find.text('Мої чернетки'), findsOneWidget);
    expect(find.text('teacher@example.test'), findsOneWidget);
    expect(find.text('Please check chapter two.'), findsOneWidget);
    await tester.tap(find.text('Нове повідомлення'));
    await tester.pumpAndSettle();
    expect(
      find.text('Зберігайте нотатки й повідомлення для себе'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Поки що немає одногрупників чи викладачів, яким можна написати.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Ukrainian drafts and read-only threads translate app copy', (
    tester,
  ) async {
    final auth = FakeAuthRepository(latency: Duration.zero);
    for (final canSend in [true, false]) {
      final conversation = PoodleConversation(
        id: canSend ? 'self' : 'peer',
        peerId: 'student',
        peerEmail: 'student@example.test',
        isSelf: canSend,
        canSend: canSend,
        unreadCount: 0,
      );
      await tester.pumpWidget(
        testApp(
          ChangeNotifierProvider(
            key: ValueKey(canSend),
            create: (_) => ConversationViewModel(
              const _MessagingFake(),
              conversation,
              auth,
            ),
            child: ConversationScreen(conversation: conversation),
          ),
          locale: const Locale('uk'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Напишіть повідомлення'), findsOneWidget);
      expect(find.byTooltip('Надіслати повідомлення'), findsOneWidget);
      if (canSend) {
        expect(find.text('Мої чернетки'), findsOneWidget);
      } else {
        expect(
          find.text(
            'Цю розмову можна лише переглядати, бо у вас більше немає спільного активного курсу.',
          ),
          findsOneWidget,
        );
        expect(
          tester.widget<TextField>(find.byType(TextField)).enabled,
          isFalse,
        );
      }
    }
  });

  testWidgets('open inbox updates its label after local midnight', (
    tester,
  ) async {
    var now = DateTime(2026, 11, 15, 23, 59, 59);
    final auth = FakeAuthRepository(latency: Duration.zero);
    final repository = _MessagingFake([
      PoodleConversation(
        id: 'peer',
        peerId: 'teacher',
        peerEmail: 'teacher@example.test',
        isSelf: false,
        canSend: true,
        unreadCount: 0,
        lastMessageAt: DateTime(2026, 11, 15, 10),
      ),
    ]);
    await tester.pumpWidget(
      testApp(
        ChangeNotifierProvider(
          create: (_) => MessagingViewModel(repository, auth),
          child: MessagingScreen(clock: () => now),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('10:00'), findsOneWidget);
    now = DateTime(2026, 11, 16, 0, 0, 2);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Sun'), findsOneWidget);
    expect(find.text('10:00'), findsNothing);
  });

  testWidgets('inbox shows a time above the unread badge', (tester) async {
    final now = DateTime.now();
    final auth = FakeAuthRepository(latency: Duration.zero);
    final repository = _MessagingFake([
      PoodleConversation(
        id: 'peer',
        peerId: 'teacher',
        peerEmail: 'teacher@example.test',
        isSelf: false,
        canSend: true,
        unreadCount: 2,
        lastMessageAt: DateTime(now.year, now.month, now.day, 1, 49),
      ),
    ]);
    await tester.pumpWidget(
      testApp(
        ChangeNotifierProvider(
          create: (_) => MessagingViewModel(repository, auth),
          child: const MessagingScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('01:49'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chat shows a date divider and time on every message', (
    tester,
  ) async {
    final now = DateTime.now();
    final auth = FakeAuthRepository(latency: Duration.zero);
    final conversation = PoodleConversation(
      id: 'peer',
      peerId: 'teacher',
      peerEmail: 'teacher@example.test',
      isSelf: false,
      canSend: true,
      unreadCount: 0,
    );
    final repository = _HistoryFake([
      PoodleMessage(
        id: 1,
        senderId: 'teacher',
        text: 'Yesterday message',
        createdAt: DateTime(now.year, now.month, now.day - 1, 23, 15),
      ),
      PoodleMessage(
        id: 2,
        senderId: 'teacher',
        text: 'Today message',
        createdAt: DateTime(now.year, now.month, now.day, 1, 49),
      ),
    ]);
    await tester.pumpWidget(
      testApp(
        ChangeNotifierProvider(
          create: (_) => ConversationViewModel(repository, conversation, auth),
          child: ConversationScreen(conversation: conversation),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('23:15'), findsOneWidget);
    expect(find.text('01:49'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'drafts network failure stays recoverable and retry opens the conversation',
    (tester) async {
      final auth = FakeAuthRepository(latency: Duration.zero);
      final repository = _OpeningFake();
      final router = GoRouter(
        initialLocation: '/messages',
        routes: [
          GoRoute(
            path: '/messages',
            builder: (_, _) => ChangeNotifierProvider(
              create: (_) => MessagingViewModel(repository, auth),
              child: const MessagingScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, _) =>
                    const Scaffold(body: Text('Draft conversation opened')),
              ),
            ],
          ),
        ],
      );
      await tester.pumpWidget(testApp(Router.withConfig(config: router)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('conversation:drafts')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        find.text('Could not open messaging. Please try again.'),
        findsOneWidget,
      );
      repository.fail = false;
      await tester.tap(find.byKey(const ValueKey('conversation:drafts')));
      await tester.pumpAndSettle();
      expect(find.text('Draft conversation opened'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
    },
  );
  testWidgets('banner lays out above the navigator at mobile width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(411, 914);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => Stack(
          children: [
            child!,
            Positioned(
              top: 0,
              left: 12,
              right: 12,
              child: SafeArea(
                child: AppNotificationBanner(
                  title: 'New notification',
                  message: 'Tap to view your new message',
                  onTap: () {},
                  onDismiss: () {},
                ),
              ),
            ),
          ],
        ),
        home: const Scaffold(body: Text('Home')),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('New notification'), findsOneWidget);
  });
  testWidgets('reusable banner supports a simple notification and dismissal', (
    tester,
  ) async {
    var opened = false;
    var dismissed = false;
    await tester.pumpWidget(
      testApp(
        Scaffold(
          body: AppNotificationBanner(
            title: 'Course update',
            message: 'Your grade is available',
            onTap: () => opened = true,
            onDismiss: () => dismissed = true,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Your grade is available'));
    expect(opened, isTrue);
    await tester.tap(find.byIcon(Icons.close));
    expect(dismissed, isTrue);
  });
  testWidgets('refreshes inbox after returning from a private chat', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      restoredSession: const AuthSession(
        'student@example.test',
        userId: 'student',
      ),
      latency: Duration.zero,
    );
    final repository = _RefreshFake();
    final router = GoRouter(
      initialLocation: '/messages',
      routes: [
        GoRoute(
          path: '/messages',
          builder: (_, _) => ChangeNotifierProvider(
            create: (_) => MessagingViewModel(repository, auth),
            child: const MessagingScreen(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, _) => Scaffold(
                body: TextButton(
                  onPressed: () {
                    repository.returned = true;
                    context.pop();
                  },
                  child: const Text('Back to chats'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(testApp(Router.withConfig(config: router)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('teacher@example.test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back to chats'));
    await tester.pumpAndSettle();
    expect(find.text('Updated preview'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
  });
  testWidgets(
    'shows unread messages on entry and resume and opens their chat',
    (
      tester,
    ) async {
      final auth = FakeAuthRepository(
        restoredSession: const AuthSession(
          'student@example.test',
          userId: 'student',
        ),
        latency: Duration.zero,
      );
      final repository = _IncomingFake()..received = true;
      PoodleConversation? opened;
      await tester.pumpWidget(
        testApp(
          IncomingMessageBanner(
            repository: repository,
            auth: auth,
            currentPath: () => '/home',
            onOpen: (conversation) => opened = conversation,
            child: const Scaffold(body: Text('Home')),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('New message. Tap to view.'), findsOneWidget);
      await tester.tap(find.text('New message. Tap to view.'));
      await tester.pump();
      expect(opened?.id, 'peer');
      expect(find.text('New message. Tap to view.'), findsNothing);
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('New message. Tap to view.'), findsNothing);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(find.text('New message. Tap to view.'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets('shows drafts before a peer conversation', (tester) async {
    final auth = FakeAuthRepository(
      restoredSession: const AuthSession(
        'student@example.test',
        userId: 'student',
      ),
      latency: Duration.zero,
    );
    await tester.pumpWidget(
      testApp(
        ChangeNotifierProvider(
          create: (_) => MessagingViewModel(_MessagingFake(), auth),
          child: const MessagingScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('My drafts'), findsOneWidget);
    expect(find.text('teacher@example.test'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('My drafts')).dy,
      lessThan(tester.getTopLeft(find.text('teacher@example.test')).dy),
    );
  });

  testWidgets('pins My drafts when there is no message history', (
    tester,
  ) async {
    final auth = FakeAuthRepository(
      restoredSession: const AuthSession(
        'student@example.test',
        userId: 'student',
      ),
      latency: Duration.zero,
    );
    await tester.pumpWidget(
      testApp(
        ChangeNotifierProvider(
          create: (_) => MessagingViewModel(_MessagingFake(const []), auth),
          child: const MessagingScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('My drafts'), findsOneWidget);
    expect(
      find.text('Start a private conversation or save a draft.'),
      findsNothing,
    );
  });
}

class _IncomingFake extends _MessagingFake {
  bool received = false;

  @override
  Future<List<PoodleConversation>> listConversations() async => [
    PoodleConversation(
      id: 'peer',
      peerId: 'teacher',
      peerEmail: 'teacher@example.test',
      isSelf: false,
      canSend: true,
      unreadCount: received ? 1 : 0,
      lastMessageAt: received ? DateTime.utc(2026, 11, 13) : null,
    ),
  ];
}

class _RefreshFake extends _MessagingFake {
  bool returned = false;
  @override
  Future<List<PoodleConversation>> listConversations() async => [
    PoodleConversation(
      id: 'peer',
      peerId: 'teacher',
      peerEmail: 'teacher@example.test',
      isSelf: false,
      canSend: true,
      unreadCount: 0,
      lastText: returned ? 'Updated preview' : 'Original preview',
    ),
  ];
}

class _MessagingFake implements MessagingRepository {
  const _MessagingFake([
    this.conversations = const [
      PoodleConversation(
        id: 'self',
        peerId: 'student',
        peerEmail: 'student@example.test',
        isSelf: true,
        canSend: true,
        unreadCount: 0,
      ),
      PoodleConversation(
        id: 'peer',
        peerId: 'teacher',
        peerEmail: 'teacher@example.test',
        isSelf: false,
        canSend: true,
        unreadCount: 2,
        lastText: 'Please check chapter two.',
      ),
    ],
  ]);

  final List<PoodleConversation> conversations;

  @override
  Future<List<PoodleConversation>> listConversations() async => conversations;

  @override
  Future<List<PoodlePeer>> eligiblePeers(String query) async => const [];
  @override
  Future<List<PoodleMessage>> listMessages(
    String conversationId, {
    int? beforeId,
  }) async => const [];
  @override
  Future<PoodleConversation> openPeer(String peerId) =>
      throw UnimplementedError();
  @override
  Future<PoodleConversation> openSelf() => throw UnimplementedError();
  @override
  Future<PoodleMessage> send(
    String conversationId,
    String clientSendId,
    String text,
  ) => throw UnimplementedError();

  @override
  Future<void> markRead(String conversationId, int throughMessageId) async {}
}

class _OpeningFake extends _MessagingFake {
  _OpeningFake() : super(const []);
  bool fail = true;
  @override
  Future<PoodleConversation> openSelf() async {
    if (fail) throw AuthFailure.network;
    return const PoodleConversation(
      id: 'self',
      peerId: 'student',
      peerEmail: 'student@example.test',
      isSelf: true,
      canSend: true,
      unreadCount: 0,
    );
  }
}

class _HistoryFake extends _MessagingFake {
  _HistoryFake(this.messages) : super(const []);
  final List<PoodleMessage> messages;

  @override
  Future<List<PoodleMessage>> listMessages(
    String conversationId, {
    int? beforeId,
  }) async => messages;
}
