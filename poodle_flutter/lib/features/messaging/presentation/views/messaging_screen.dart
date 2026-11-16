import 'dart:async';

import '../../../../app/floating_action_clearance.dart';
import '../../../../app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../data/repositories/messaging_repository.dart';
import '../view_models/messaging_view_model.dart';
import '../../message_timestamp_formatter.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key, this.clock});

  final DateTime Function()? clock;

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen>
    with WidgetsBindingObserver {
  Timer? _dateTimer;

  void _scheduleDateRefresh() {
    _dateTimer?.cancel();
    final now = widget.clock?.call() ?? DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    _dateTimer = Timer(
      midnight.difference(now) + const Duration(seconds: 1),
      () {
        if (mounted) setState(() {});
        _scheduleDateRefresh();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
      _scheduleDateRefresh();
    }
  }

  @override
  void dispose() {
    _dateTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _openConversation(PoodleConversation conversation) async {
    await context.push('/messages/${conversation.id}', extra: conversation);
    if (mounted) await context.read<MessagingViewModel>().load();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleDateRefresh();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessagingViewModel>().load();
    });
  }

  Future<void> _startConversation(BuildContext context) async {
    final copy = AppLocalizations.of(context);
    final model = context.read<MessagingViewModel>();
    final found = await model.searchPeers('');
    if (!context.mounted || !found) return;
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_note_outlined),
              title: Text(copy.messagesDrafts),
              subtitle: Text(copy.messagesDraftsDescription),
              onTap: () async {
                final conversation = await model.openSelf();
                if (!sheetContext.mounted) return;
                Navigator.pop(sheetContext);
                if (context.mounted && conversation != null) {
                  await _openConversation(conversation);
                }
              },
            ),
            for (final peer in model.peers)
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(peer.email),
                onTap: () async {
                  final conversation = await model.openPeer(peer.id);
                  if (!sheetContext.mounted) return;
                  Navigator.pop(sheetContext);
                  if (context.mounted && conversation != null) {
                    await _openConversation(conversation);
                  }
                },
              ),
            if (model.peers.isEmpty)
              ListTile(
                title: Text(copy.messagesNoRecipients),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDrafts(BuildContext context) async {
    final conversation = await context.read<MessagingViewModel>().openSelf();
    if (context.mounted && conversation != null) {
      await _openConversation(conversation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context);
    final model = context.watch<MessagingViewModel>();
    final formatter = MessageTimestampFormatter(
      Localizations.localeOf(context).toString(),
    );
    final now = widget.clock?.call() ?? DateTime.now();
    return Scaffold(
      appBar: AppBar(title: Text(copy.messagesTab)),
      floatingActionButtonLocation: FloatingActionClearance.locationOf(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: model.loading || model.acting
            ? null
            : () => _startConversation(context),
        icon: const Icon(Icons.edit_outlined),
        label: Text(copy.messagesNew),
      ),
      body: RefreshIndicator(
        onRefresh: model.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (model.actionError != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Semantics(
                  liveRegion: true,
                  child: Text(copy.messagesOpenError),
                ),
              ),
            if (model.acting) const LinearProgressIndicator(),
            if (model.loading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (model.error != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(copy.messagesLoadError),
                    TextButton(
                      onPressed: model.load,
                      child: Text(copy.messagesRetry),
                    ),
                  ],
                ),
              ),
            if (!model.conversations.any((conversation) => conversation.isSelf))
              ListTile(
                key: const ValueKey('conversation:drafts'),
                leading: const CircleAvatar(
                  child: Icon(Icons.edit_note_outlined),
                ),
                title: Text(copy.messagesDrafts),
                subtitle: Text(copy.messagesDraftsHint),
                onTap: model.loading || model.acting
                    ? null
                    : () => _openDrafts(context),
              ),
            for (final conversation in model.conversations)
              ListTile(
                key: ValueKey('conversation:${conversation.id}'),
                leading: CircleAvatar(
                  child: Icon(
                    conversation.isSelf
                        ? Icons.edit_note_outlined
                        : Icons.person_outline,
                  ),
                ),
                title: Text(
                  conversation.isSelf
                      ? copy.messagesDrafts
                      : conversation.peerEmail,
                ),
                subtitle: Text(
                  conversation.lastText ??
                      (conversation.isSelf
                          ? copy.messagesDraftsHint
                          : copy.messagesEmptyThread),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing:
                    conversation.lastMessageAt == null &&
                        conversation.unreadCount == 0
                    ? null
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (conversation.lastMessageAt case final timestamp?)
                            Semantics(
                              label: formatter.full(timestamp),
                              child: ExcludeSemantics(
                                child: Text(
                                  formatter.inbox(timestamp, now),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                            ),
                          if (conversation.unreadCount > 0)
                            Badge(label: Text('${conversation.unreadCount}')),
                        ],
                      ),
                onTap: () => _openConversation(conversation),
              ),
          ],
        ),
      ),
    );
  }
}

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required this.conversation, this.clock});
  final PoodleConversation conversation;
  final DateTime Function()? clock;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen>
    with WidgetsBindingObserver {
  final _composer = TextEditingController();
  Timer? _dateTimer;

  void _scheduleDateRefresh() {
    _dateTimer?.cancel();
    final now = widget.clock?.call() ?? DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    _dateTimer = Timer(
      midnight.difference(now) + const Duration(seconds: 1),
      () {
        if (mounted) setState(() {});
        _scheduleDateRefresh();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
      _scheduleDateRefresh();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleDateRefresh();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConversationViewModel>().load();
    });
  }

  @override
  void dispose() {
    _dateTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _composer.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final model = context.read<ConversationViewModel>();
    final text = _composer.text;
    if (await model.send(text)) _composer.clear();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ConversationViewModel>();
    final mine = model.accountId;
    final formatter = MessageTimestampFormatter(
      Localizations.localeOf(context).toString(),
    );
    final now = widget.clock?.call() ?? DateTime.now();
    final copy = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.conversation.isSelf
              ? copy.messagesDrafts
              : widget.conversation.peerEmail,
        ),
      ),
      body: Column(
        children: [
          if (!widget.conversation.canSend)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.surfaceContainer,
              padding: const EdgeInsets.all(16),
              child: Text(copy.messagesReadOnly),
            ),
          Expanded(
            child: model.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: model.messages.length,
                    itemBuilder: (context, index) {
                      final message = model.messages[index];
                      final sent = message.senderId == mine;
                      final newDay =
                          index == 0 ||
                          !formatter.sameDay(
                            model.messages[index - 1].createdAt,
                            message.createdAt,
                          );
                      return Column(
                        children: [
                          if (newDay)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                formatter.day(
                                  message.createdAt,
                                  now,
                                  today: copy.messageToday,
                                  yesterday: copy.messageYesterday,
                                ),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          Align(
                            alignment: sent
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Card(
                              color: sent
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.secondaryContainer
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(message.text),
                                    const SizedBox(height: 4),
                                    Semantics(
                                      label: formatter.full(message.createdAt),
                                      child: ExcludeSemantics(
                                        child: Text(
                                          formatter.time(message.createdAt),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelSmall,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _composer,
                      enabled: widget.conversation.canSend && !model.sending,
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 4000,
                      decoration: InputDecoration(
                        hintText: copy.messagesComposerHint,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    tooltip: copy.messagesSend,
                    onPressed: widget.conversation.canSend && !model.sending
                        ? _send
                        : null,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
