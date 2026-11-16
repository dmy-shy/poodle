import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/messaging_repository.dart';
import '../../../../data/repositories/notifications_repository.dart';
import '../../../../ui/notifications/app_notification_banner.dart';
import '../../../../app/l10n/app_localizations.dart';

class IncomingMessageBanner extends StatefulWidget {
  const IncomingMessageBanner({
    super.key,
    required this.repository,
    required this.auth,
    required this.currentPath,
    required this.onOpen,
    required this.child,
    this.notifications,
    this.onOpenNotifications,
    this.onOpenRequest,
    this.onPoll,
    this.interval = const Duration(seconds: 5),
  });
  final MessagingRepository? repository;
  final NotificationsRepository? notifications;
  final VoidCallback? onOpenNotifications;
  final ValueChanged<PoodleNotification>? onOpenRequest;
  final Future<void> Function()? onPoll;
  final AuthRepository auth;
  final String Function() currentPath;
  final ValueChanged<PoodleConversation> onOpen;
  final Widget child;
  final Duration interval;
  @override
  State<IncomingMessageBanner> createState() => _IncomingMessageBannerState();
}

class _Alert {
  _Alert(this.id, this.title, this.message, this.open, this.icon);
  final String id, title, message;
  final VoidCallback open;
  final IconData icon;
}

class _IncomingMessageBannerState extends State<IncomingMessageBanner>
    with WidgetsBindingObserver {
  Timer? _timer, _dismiss;
  String? _account;
  int _epoch = 0;
  bool _busy = false, _foreground = true;
  final _seen = <String>{};
  final _queue = <_Alert>[];
  _Alert? _incoming;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.auth.addListener(_authChanged);
    _account = widget.auth.session?.userId;
    _timer = Timer.periodic(widget.interval, (_) => _poll());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _poll();
    });
  }

  void _reset() {
    _epoch++;
    _seen.clear();
    _queue.clear();
    _dismiss?.cancel();
    setState(() => _incoming = null);
  }

  void _authChanged() {
    final account = widget.auth.session?.userId;
    if (account == _account) return;
    _account = account;
    _reset();
    _poll();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final foreground = state == AppLifecycleState.resumed;
    if (_foreground == foreground) return;
    _foreground = foreground;
    _reset();
    if (_foreground) _poll();
  }

  Future<void> _poll() async {
    if (_busy || !_foreground || _account == null) return;
    final epoch = _epoch;
    _busy = true;
    final alerts = <_Alert>[];
    try {
      final copy = AppLocalizations.of(context);
      final uk = Localizations.localeOf(context).languageCode == 'uk';
      try {
        final conversations =
            await widget.repository?.listConversations() ??
            <PoodleConversation>[];
        for (final c in conversations) {
          if (c.isSelf ||
              c.unreadCount == 0 ||
              widget.currentPath() == '/messages/${c.id}') {
            continue;
          }
          alerts.add(
            _Alert(
              'message:${c.id}:${c.lastMessageAt}',
              c.peerEmail,
              copy.messagesIncomingAlert,
              () => widget.onOpen(c),
              Icons.chat_bubble_outline,
            ),
          );
        }
      } catch (_) {
        /* Allow the other source to succeed. */
      }
      try {
        final source = widget.notifications;
        if (source != null) {
          final items = await source.list(
            offset: 0,
            limit: 20,
            unreadOnly: true,
          );
          if (!source.isStale) {
            final freshRequests = items
                .where(
                  (item) =>
                      item.category == 'universityRequest' &&
                      item.requestId != null &&
                      item.unread &&
                      !_seen.contains('notification:${item.id}'),
                )
                .toList();
            if (freshRequests.isNotEmpty &&
                widget.auth.session?.isAdmin == true) {
              for (final item in freshRequests) {
                _seen.add('notification:${item.id}');
              }
              final newest = freshRequests.first;
              if (!mounted || epoch != _epoch) return;
              alerts.add(
                _Alert(
                  'request-batch:${newest.id}',
                  copy.institutionNewRequestAlert,
                  freshRequests.length == 1
                      ? newest.title
                      : copy.institutionNewRequestsAlert,
                  () => widget.onOpenRequest?.call(newest),
                  Icons.school_outlined,
                ),
              );
            }
            for (final item in items.where((item) => item.unread)) {
              if (item.category == 'universityRequest' ||
                  widget.currentPath() == '/notifications') {
                continue;
              }
              alerts.add(
                _Alert(
                  'notification:${item.id}',
                  uk ? 'Сповіщення' : 'Notification',
                  item.title,
                  () => widget.onOpenNotifications?.call(),
                  Icons.notifications_outlined,
                ),
              );
            }
          }
        }
      } catch (_) {
        /* Retry next tick without interrupting the screen. */
      }
      try {
        await widget.onPoll?.call();
      } catch (_) {
        /* The request count can retry at the next poll. */
      }
      if (!mounted || epoch != _epoch) return;
      for (final alert in alerts) {
        if (_seen.add(alert.id)) _queue.add(alert);
      }
      if (_incoming == null) _next();
    } finally {
      _busy = false;
      if (mounted && epoch != _epoch) _poll();
    }
  }

  void _next() {
    _dismiss?.cancel();
    setState(() => _incoming = _queue.isEmpty ? null : _queue.removeAt(0));
    if (_incoming != null) _dismiss = Timer(const Duration(seconds: 8), _next);
  }

  @override
  void dispose() {
    widget.auth.removeListener(_authChanged);
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _dismiss?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      widget.child,
      if (_incoming case final alert?)
        Positioned(
          top: 0,
          left: 12,
          right: 12,
          child: SafeArea(
            child: AppNotificationBanner(
              title: alert.title,
              message: alert.message,
              icon: alert.icon,
              onDismiss: _next,
              onTap: () {
                _next();
                alert.open();
              },
            ),
          ),
        ),
    ],
  );
}
