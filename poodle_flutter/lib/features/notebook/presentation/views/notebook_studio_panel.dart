import '../../../../ui/components/confirmation_actions.dart';
import '../../../../ui/components/poodle_filled_icon_button.dart';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/notebook_repository.dart';

import 'studio_audio_clip.dart'
    if (dart.library.io) 'studio_audio_clip_io.dart';

import '../../studio_content.dart';

part 'notebook_studio_detail.dart';

class NotebookStudioPanel extends StatefulWidget {
  const NotebookStudioPanel({
    super.key,
    required this.repository,
    required this.notebookId,
    required this.active,
    required this.readyCount,
    required this.sources,
  });

  final NotebookRepository repository;
  final String notebookId;
  final bool active;
  final int readyCount;
  final Object? sources;

  @override
  State<NotebookStudioPanel> createState() => _NotebookStudioPanelState();
}

class _NotebookStudioPanelState extends State<NotebookStudioPanel>
    with WidgetsBindingObserver {
  List<StudyStudioItem>? _items;
  StudyStudioItem? _detail;
  Timer? _timer;
  bool _foreground = true,
      _refreshing = false,
      _sending = false,
      _opening = false;
  bool _refreshAgain = false;
  Object? _error;
  int _revision = 0;
  final _retryKeys = <(StudioKind, String), String>{};

  AppLocalizations get l => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.active) _refresh();
  }

  @override
  void didUpdateWidget(NotebookStudioPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sources != widget.sources) {
      _detail = null;
      _revision++;
    }
    if (!widget.active) {
      _timer?.cancel();
    } else if (!oldWidget.active || oldWidget.sources != widget.sources) {
      _refresh();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _timer?.cancel();
    if (_foreground && widget.active) _refresh();
    if (mounted) setState(() {});
  }

  void _schedule() {
    _timer?.cancel();
    if (!mounted ||
        !widget.active ||
        !_foreground ||
        widget.repository.isStale) {
      return;
    }
    final pending = _items?.any((i) => i.pending) ?? false;
    if (pending || _detail != null || _error != null) {
      _timer = Timer(Duration(seconds: pending ? 3 : 15), _refresh);
    }
  }

  Future<void> _refresh() async {
    if (!widget.active) return;
    if (_refreshing) {
      _refreshAgain = true;
      return;
    }
    _refreshing = true;
    final revision = _revision;
    try {
      final items = await widget.repository.studioItems(widget.notebookId);
      if (!mounted || revision != _revision) return;
      setState(() {
        _items = items;
        _error = null;
        if (_detail != null &&
            !items.any(
              (item) => item.id == _detail!.id && item.status == 'ready',
            )) {
          _detail = null;
          _error = NotebookFailure.changed;
        }
      });
    } catch (e) {
      if (!mounted || revision != _revision) return;
      setState(() {
        if (e != NotebookFailure.network) {
          _items = null;
          _detail = null;
          _revision++;
        }
        _error = e;
      });
    } finally {
      _refreshing = false;
      if (mounted) {
        if (_refreshAgain && widget.active && _foreground) {
          _refreshAgain = false;
          unawaited(_refresh());
        } else {
          _schedule();
        }
      }
    }
  }

  Future<void> _generate(StudioKind kind, {String? preferred}) async {
    if (_sending || widget.readyCount == 0 || widget.repository.isStale) return;
    final language = await showDialog<String>(
      context: context,
      builder: (context) => _StudioLanguageDialog(
        kind: kind,
        initial: preferred ?? Localizations.localeOf(context).languageCode,
      ),
    );
    if (!mounted || !widget.active || _sending || language == null) return;
    final key = _retryKeys.putIfAbsent((kind, language), () {
      final random = Random.secure();
      return List.generate(
        24,
        (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
      ).join();
    });
    setState(() => _sending = true);
    try {
      await widget.repository.generateStudio(
        widget.notebookId,
        kind,
        language,
        key,
      );
      _retryKeys.remove((kind, language));
      if (!mounted) return;
      if (mounted) await _refresh();
    } catch (e) {
      if (e != NotebookFailure.network) _retryKeys.remove((kind, language));
      if (mounted) _notice(_studioError(l, e));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _notice(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  Future<void> _open(StudyStudioItem item) async {
    if (_opening) return;
    setState(() => _opening = true);
    final revision = _revision;
    try {
      final detail = await widget.repository.studioItem(
        widget.notebookId,
        item.id,
      );
      if (!mounted || revision != _revision || !widget.active) return;
      if (detail.status != 'ready') {
        _notice(l.studioStale);
        await _refresh();
        return;
      }
      setState(() => _detail = detail);
      _schedule();
    } catch (e) {
      if (mounted) _notice(_studioError(l, e));
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    if (detail != null) {
      return _StudioDetail(
        key: ValueKey(detail.id),
        item: detail,
        offline: widget.repository.isStale,
        active: widget.active && _foreground,
        audio: () =>
            widget.repository.studioAudio(widget.notebookId, detail.id),
        passage: (chunk) => widget.repository.studioPassage(
          widget.notebookId,
          detail.id,
          chunk,
        ),
        close: () => setState(() => _detail = null),
      );
    }
    final canGenerate =
        widget.readyCount > 0 && !_sending && !widget.repository.isStale;
    return ListView(
      key: const PageStorageKey('notebook-studio-list'),
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.studioTitle, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          widget.readyCount == 0
              ? l.notebookSelectAReadySourceFirst
              : l.studioIntro,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final kind in StudioKind.values)
              FilledButton.tonalIcon(
                onPressed: canGenerate ? () => _generate(kind) : null,
                icon: Icon(_studioIcon(kind)),
                label: Text(_studioName(l, kind)),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                l.studioLibrary,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton(
              tooltip: l.notebookRefresh,
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        if (_error case final error?)
          Text(
            _studioError(l, error),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        if ((_items == null && _error == null) || _sending || _opening)
          const LinearProgressIndicator(),
        if (_items?.isEmpty ?? false)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(l.studioEmpty),
          ),
        for (final item in _items ?? const <StudyStudioItem>[])
          Card(
            child: ListTile(
              leading: item.pending
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(_studioIcon(item.kind)),
              title: Text(
                item.title.isEmpty ? _studioName(l, item.kind) : item.title,
              ),
              subtitle: Text(
                '${_studioLanguage(item.language)} · ${_status(item)}',
              ),
              onTap: item.status == 'ready' && !_opening
                  ? () => _open(item)
                  : null,
              trailing: item.status == 'failed' || item.status == 'stale'
                  ? IconButton(
                      tooltip: l.studioGenerate,
                      icon: const Icon(Icons.replay),
                      onPressed: canGenerate
                          ? () => _generate(item.kind, preferred: item.language)
                          : null,
                    )
                  : item.status == 'ready'
                  ? const Icon(Icons.chevron_right)
                  : null,
            ),
          ),
      ],
    );
  }

  String _status(StudyStudioItem item) => switch (item.status) {
    'queued' => l.studioQueued,
    'processing' => l.studioProcessing,
    'ready' => l.notebookReady,
    'stale' => l.studioStale,
    'failed' => switch (item.failureCode) {
      'monthly_budget_exceeded' =>
        l.notebookTheStudyAssistantHasReachedItsUsageLimit,
      'sources_changed' => l.studioStale,
      'insufficient_evidence' => l.studioInsufficient,
      'audio_unavailable' => l.studioAudioUnavailable,
      _ => l.notebookProcessingFailed,
    },
    _ => l.notebookProcessingFailed,
  };
}

String _studioName(AppLocalizations l, StudioKind kind) => switch (kind) {
  StudioKind.quiz => l.studioQuiz,
  StudioKind.audio => l.studioAudio,
  StudioKind.flashcards => l.studioFlashcards,
};
IconData _studioIcon(StudioKind kind) => switch (kind) {
  StudioKind.quiz => Icons.quiz_outlined,
  StudioKind.audio => Icons.headphones_outlined,
  StudioKind.flashcards => Icons.style_outlined,
};
String _studioLanguage(String lang) => lang == 'uk' ? 'Українська' : 'English';
String _studioError(AppLocalizations l, Object error) => switch (error) {
  NotebookFailure.network => l.notebookConnectionUnavailableYourWorkIsStillHere,
  NotebookFailure.noSources => l.notebookSelectAReadySourceFirst,
  NotebookFailure.changed => l.studioStale,
  NotebookFailure.budget => l.notebookTheStudyAssistantHasReachedItsUsageLimit,
  _ => l.notebookNotebookUnavailableRefreshToTryAgain,
};

class _StudioLanguageDialog extends StatefulWidget {
  const _StudioLanguageDialog({required this.kind, required this.initial});
  final StudioKind kind;
  final String initial;
  @override
  State<_StudioLanguageDialog> createState() => _StudioLanguageDialogState();
}

class _StudioLanguageDialogState extends State<_StudioLanguageDialog> {
  late String _language = widget.initial == 'uk' ? 'uk' : 'en';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(_studioName(l, widget.kind)),
      content: DropdownMenu<String>(
        label: Text(l.studioLanguage),
        initialSelection: _language,
        dropdownMenuEntries: [
          for (final lang in ['en', 'uk'])
            DropdownMenuEntry(value: lang, label: _studioLanguage(lang)),
        ],
        onSelected: (lang) {
          if (lang != null) _language = lang;
        },
      ),
      actions: [
        DialogActionRow(
          cancel: l.cancel,
          confirm: l.studioGenerate,
          onCancel: () => Navigator.pop(context),
          onConfirm: () => Navigator.pop(context, _language),
        ),
      ],
    );
  }
}
