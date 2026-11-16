import '../../../../ui/components/poodle_filled_icon_button.dart';
import '../../../../ui/components/confirmation_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/notebook_repository.dart';
import '../view_models/notebook_view_model.dart';
import 'aurora_wave.dart';
import 'notebook_studio_panel.dart';

part 'notebook_saved_notes.dart';

class NotebookScreen extends StatefulWidget {
  const NotebookScreen({super.key});
  @override
  State<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends State<NotebookScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _question = TextEditingController();
  final _chatScroll = ScrollController();
  final _sourceScroll = ScrollController();
  int? _generation;
  int? _tab;
  String? _lastTurn;
  bool _newResponse = false;
  bool _sending = false;
  AppLocalizations get l => AppLocalizations.of(context);
  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    context.read<NotebookViewModel>().setForeground(
      state == AppLifecycleState.resumed,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabs.dispose();
    _question.dispose();
    _chatScroll.dispose();
    _sourceScroll.dispose();
    super.dispose();
  }

  void _bottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_chatScroll.hasClients) return;
      _chatScroll.jumpTo(_chatScroll.position.maxScrollExtent);
      if (_newResponse) setState(() => _newResponse = false);
    });
  }

  Future<void> _send(NotebookViewModel model) async {
    final draft = _question.text;
    setState(() => _sending = true);
    await model.ask(draft);
    if (!mounted) return;
    setState(() {
      _sending = false;
      if (model.submittedQuestion == draft.trim() && _question.text == draft) {
        _question.clear();
      }
    });
    _bottom();
  }

  Future<void> _passage(
    NotebookViewModel model,
    StudyTurn turn,
    StudyCitation citation,
  ) async {
    model.openPassage(turn.id, citation);
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => AnimatedBuilder(
        animation: model,
        builder: (_, _) => SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(sheetContext).height * .65,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.notebookSourcePassage,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: l.close,
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Text(
                  '${citation.title} · ${l.notebookVersion} ${citation.version}${citation.location == null ? '' : ' · ${citation.location}'}',
                ),
                const SizedBox(height: 16),
                if (model.passageLoading)
                  const LinearProgressIndicator()
                else if (model.passage != null)
                  SelectableText(model.passage!)
                else
                  Text(
                    model.passageError == NotebookFailure.network
                        ? l.notebookConnectionUnavailableCloseAndTryAgain
                        : l.notebookThisPassageIsNoLongerAvailableRefreshTheNotebook,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    model.closePassage();
  }

  Future<void> _remove(NotebookViewModel model, StudySource source) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.notebookRemovePrivateFile),
        content: Text(
          '${source.title}\n\n${l.notebookChangingSourcesInvalidatesPreviousAnswers}',
        ),
        actions: [
          ConfirmationActions(
            cancel: l.cancel,
            confirm: l.notebookRemove,
            destructive: true,
          ),
        ],
      ),
    );
    if (confirmed == true && mounted && !model.busy && model.pending == null) {
      await model.removeUpload(source.id);
    }
  }

  Widget _empty(IconData icon, String title, String body) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(body, textAlign: TextAlign.center),
      ],
    ),
  );
  Widget _sources(NotebookViewModel model) {
    final notebook = model.notebook;
    return ListView(
      key: const PageStorageKey('notebook-sources'),
      controller: _sourceScroll,
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.notebookSources, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l.notebookChangingSourcesInvalidatesPreviousAnswers),
        if (notebook?.configured == false)
          _empty(
            Icons.school_outlined,
            l.notebookNotConfiguredYet,
            l.notebookYourTeacherHasNotConfiguredThisNotebookYet,
          ),
        if (notebook?.configured == true) ...[
          if (model.uploadingFileName != null)
            ListTile(
              leading: const CircularProgressIndicator(),
              title: Text(model.uploadingFileName!),
              subtitle: Text(l.notebookPreparingYourFile),
            ),
          if (notebook!.sources.isEmpty)
            _empty(
              Icons.library_add_outlined,
              l.notebookAddASourceToGetStarted,
              l.notebookChooseAPrivateFileOrWaitForCourseMaterials,
            ),
          for (final private in [false, true]) ...[
            if (notebook.sources.any((s) => s.privateUpload == private))
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 8),
                child: Text(
                  private ? l.notebookMyFiles : l.notebookCourseMaterials,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            for (final source in notebook.sources.where(
              (s) => s.privateUpload == private,
            ))
              Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            value: source.selected,
                            title: Text(source.title),
                            subtitle: Text(switch (source.status) {
                              'ready' => l.notebookReady,
                              'failed'
                                  when source.failureCode ==
                                      'scanner_unavailable' =>
                                l.notebookFileScanningIsTemporarilyUnavailableTryUploadingAgainLater,
                              'failed'
                                  when source.failureCode == 'unsafe_upload' =>
                                l.notebookThisFileCouldNotPassTheSafetyCheckChoose,
                              'failed'
                                  when source.failureCode ==
                                      'encrypted_document' =>
                                l.notebookPasswordProtectedFilesCannotBeUsedAskYourTeacher,
                              'failed'
                                  when source.failureCode == 'empty_source' =>
                                l.notebookNoReadableTextFoundAskYourTeacherForA,
                              'failed'
                                  when source.failureCode ==
                                      'extraction_limit' =>
                                l.notebookThisFileIsTooLargeOrComplexAskYour,
                              'failed'
                                  when source.failureCode == 'active_content' =>
                                l.notebookThisDocumentContainsUnsupportedContentAskYourTeacherFor,
                              'failed' => l.notebookCouldNotPrepareSource,
                              _ => l.notebookPreparingSource,
                            }),
                            onChanged:
                                model.busy ||
                                    model.repository.isStale ||
                                    model.pending != null ||
                                    model.needsReconcile
                                ? null
                                : (value) =>
                                      model.select(source.id, value ?? false),
                          ),
                        ),
                        if (source.privateUpload)
                          IconButton(
                            tooltip: l.notebookRemovePrivateFile,
                            onPressed:
                                model.busy ||
                                    model.repository.isStale ||
                                    model.pending != null ||
                                    model.needsReconcile
                                ? null
                                : () => _remove(model, source),
                            icon: const Icon(Icons.delete_outline),
                          ),
                      ],
                    ),
                    if (source.status != 'ready' && source.status != 'failed')
                      const LinearProgressIndicator(),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 24),
          if (notebook.allowedFormats.isNotEmpty) ...[
            OutlinedButton.icon(
              onPressed:
                  model.busy ||
                      model.repository.isStale ||
                      model.pending != null ||
                      model.needsReconcile
                  ? null
                  : model.upload,
              icon: const Icon(Icons.upload_file),
              label: Text(l.notebookAddPrivateFile),
            ),
            const SizedBox(height: 8),
            Text(
              "${notebook.allowedFormats.join(', ').toUpperCase()} · ${l.notebookUpTo25MiB}",
            ),
          ],
        ],
      ],
    );
  }

  Widget _chat(NotebookViewModel model) => Column(
    children: [
      Expanded(
        child: ListView(
          key: const PageStorageKey('notebook-chat'),
          controller: _chatScroll,
          padding: const EdgeInsets.all(16),
          children: [
            if (model.history.isEmpty && model.submittedQuestion == null) ...[
              _empty(
                Icons.auto_stories_outlined,
                l.notebookYourPrivateStudySpace,
                model.readyCount > 0
                    ? l.notebookAskAQuestionCheckTheEvidenceKeepLearning
                    : l.notebookSelectAReadySourceInSourcesToAskA,
              ),
              if (model.readyCount > 0)
                for (final prompt in [
                  l.notebookSummarizeSelectedSources,
                  l.notebookExplainKeyConcepts,
                  l.notebookHelpMeRevise,
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ActionChip(
                      label: Text(prompt),
                      onPressed: () => setState(() => _question.text = prompt),
                    ),
                  ),
            ],
            for (final turn in model.history) _turn(model, turn),
            if (model.submittedQuestion != null)
              _bubble(model.submittedQuestion!),
            if (model.questionFailed && model.submittedQuestion != null)
              TextButton(
                onPressed: model.busy
                    ? null
                    : () => model.pending == null
                          ? model.ask(model.submittedQuestion!)
                          : model.poll(),
                child: Text(l.notebookCheckAgain),
              ),
            if ((model.pending != null &&
                    model.error != NotebookFailure.network) ||
                model.sending)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    AuroraWave(label: l.notebookPreparingYourAnswer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        model.sending || model.pending?.status == 'queued'
                            ? l.notebookWaitingToPrepareYourAnswer
                            : model.importing
                            ? l.notebookPreparingYourFile
                            : l.notebookPreparingYourAnswer,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      if (_newResponse)
        TextButton(onPressed: _bottom, child: Text(l.notebookNewResponse)),
      Padding(
        padding: const EdgeInsets.all(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: l.notebookEvidence(
                    model.readyCount,
                    model.excludedCount,
                  ),
                  onPressed: () {
                    _tabs.animateTo(0);
                    setState(() => _tab = 0);
                    if (_sourceScroll.hasClients) _sourceScroll.jumpTo(0);
                  },
                  icon: const Icon(Icons.tune),
                ),
                Expanded(
                  child: TextField(
                    controller: _question,
                    onChanged: (_) => setState(() {}),
                    minLines: 1,
                    maxLines: 4,
                    maxLength: 4000,
                    decoration: InputDecoration(
                      hintText: l.notebookAskAboutYourSources,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
                PoodleFilledIconButton(
                  tooltip: l.notebookAsk,
                  onPressed:
                      model.canAsk &&
                          !_sending &&
                          _question.text.trim().isNotEmpty
                      ? () => _send(model)
                      : null,
                  icon: Icons.arrow_upward,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
  Widget _bubble(String content) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SelectableText(content),
    ),
  );
  Widget _turn(NotebookViewModel model, StudyTurn turn) {
    if (turn.role == 'user') return _bubble(turn.content);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: l.notebookStudyAssistant,
            child: const CircleAvatar(child: Icon(Icons.school_outlined)),
          ),
          const SizedBox(height: 12),
          if (turn.stale)
            Text(l.notebookSourcesChangedAskAgainForAnUpdatedAnswer)
          else ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: SelectionArea(
                child: MarkdownBody(
                  data: turn.content,
                  softLineBreak: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                      .copyWith(
                        blockSpacing: 12,
                        p: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(height: 1.5),
                        codeblockPadding: const EdgeInsets.all(12),
                        codeblockDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                  imageBuilder: (uri, title, alt) => Text(alt ?? ''),
                  onTapLink: (_, _, _) {},
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (var i = 0; i < turn.citations.length; i++)
                  ActionChip(
                    label: Text(
                      '${i + 1}. ${turn.citations[i].title}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: turn.citations[i].chunkId == null
                        ? null
                        : () => _passage(model, turn, turn.citations[i]),
                  ),
              ],
            ),
            Wrap(
              spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  tooltip: l.notebookCopyAnswer,
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: turn.content));
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(content: Text(l.notebookAnswerCopied)),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy_outlined),
                ),
                TextButton.icon(
                  onPressed: model.repository.isStale || _savingNote
                      ? null
                      : () => _saveNote(model, turn),
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: Text(l.notebookSaveNote),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  bool _savingNote = false;

  Future<void> _saveNote(NotebookViewModel model, StudyTurn turn) async {
    final id = model.notebook?.id;
    if (id == null || _savingNote) return;
    final generation = model.repository.generation;
    setState(() => _savingNote = true);
    var ok = false;
    try {
      await model.repository.saveNote(id, turn.id);
      ok = true;
    } catch (_) {
      // The action remains available for retry.
    } finally {
      if (mounted) setState(() => _savingNote = false);
    }
    if (!mounted || generation != model.repository.generation) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? l.notebookNoteSaved : l.notebookSaveNoteFailed,
        ),
      ),
    );
  }

  Widget _studio(NotebookViewModel model) {
    final notebook = model.notebook;
    final id = notebook?.id;
    if (id == null || notebook == null) {
      return Center(child: Text(l.notebookSelectAReadySourceFirst));
    }
    final ready = [
      for (final source in notebook.sources)
        if (source.selected && source.status == 'ready') source.id,
    ]..sort();
    return NotebookStudioPanel(
      key: ValueKey('${model.repository.generation}:$id'),
      repository: model.repository,
      notebookId: id,
      active: _tab == 2,
      readyCount: ready.length,
      sources: ready.join(','),
    );
  }

  Widget _tabContent(int index, List<Widget> children) => IndexedStack(
    index: index,
    children: [
      for (final (i, child) in children.indexed)
        TickerMode(enabled: i == index, child: child),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final model = context.watch<NotebookViewModel>();
    if (_generation != model.repository.generation) {
      _generation = model.repository.generation;
      _question.clear();
      _tab = null;
      _lastTurn = null;
      _newResponse = false;
    }
    if (_tab == null && model.notebook != null) {
      _tab = model.readyCount > 0 ? 1 : 0;
    }
    final last = model.history.lastOrNull?.id;
    if (last != null && last != _lastTurn) {
      final nearBottom =
          _lastTurn == null ||
          !_chatScroll.hasClients ||
          _chatScroll.position.extentAfter < 80;
      if (nearBottom) {
        _bottom();
      } else {
        _newResponse = true;
      }
    }
    _lastTurn = last;
    _tabs.index = _tab ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.notebookStudyNotebook),
        actions: [
          IconButton(
            tooltip: l.notebookSavedNotes,
            icon: const Icon(Icons.bookmarks_outlined),
            onPressed: model.notebook?.id == null
                ? null
                : () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => _SavedNotes(
                        repository: model.repository,
                        notebookId: model.notebook!.id!,
                      ),
                    ),
                  ),
          ),
          IconButton(
            tooltip: l.notebookRefresh,
            onPressed: model.busy
                ? null
                : model.pending == null
                ? model.load
                : model.poll,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                if (model.error != null &&
                    model.error != NotebookFailure.cancelled)
                  MaterialBanner(
                    content: Text(switch (model.error!) {
                      NotebookFailure.network =>
                        l.notebookConnectionUnavailableYourWorkIsStillHere,
                      NotebookFailure.processing => l.notebookProcessingFailed,
                      NotebookFailure.noSources =>
                        l.notebookSelectAReadySourceFirst,
                      NotebookFailure.budget =>
                        l.notebookTheStudyAssistantHasReachedItsUsageLimit,
                      NotebookFailure.changed =>
                        l.notebookSourcesChangedRefreshBeforeAskingAgain,
                      NotebookFailure.invalidUpload =>
                        l.notebookChooseAnAllowedDocumentUpTo25MB,
                      NotebookFailure.uploadLimit =>
                        l.notebookFileLimitReachedRemoveAnOldPrivateFileOr,
                      _ => l.notebookNotebookUnavailableRefreshToTryAgain,
                    }),
                    actions: [
                      TextButton(
                        onPressed: model.busy
                            ? null
                            : model.error == NotebookFailure.processing &&
                                  model.questionFailed &&
                                  model.submittedQuestion != null
                            ? () => model.ask(model.submittedQuestion!)
                            : model.pending == null
                            ? model.load
                            : model.poll,
                        child: Text(l.notebookCheckAgain),
                      ),
                    ],
                  ),
                if (model.repository.isStale)
                  MaterialBanner(
                    content: Text(
                      '${l.localeName == 'uk' ? 'Збережено офлайн · Оновлено' : 'Offline copy · Last refreshed'} ${model.repository.lastRefreshedAt?.toLocal().toString() ?? ''}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: model.busy ? null : model.load,
                        child: Text(l.notebookCheckAgain),
                      ),
                    ],
                  ),
                Expanded(
                  child: model.notebook == null && model.busy
                      ? _skeleton()
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final wide = constraints.maxWidth >= 1000;
                            final workspace = wide
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        SizedBox(
                                          width: 320,
                                          child: _sources(model),
                                        ),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          child: _tabContent(
                                            _tab == 2 ? 1 : 0,
                                            [_chat(model), _studio(model)],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : _tabContent(
                                    _tab ?? 0,
                                    [
                                      _sources(model),
                                      _chat(model),
                                      _studio(model),
                                    ],
                                  );
                            return Column(
                              children: [
                                TabBar(
                                  controller: _tabs,
                                  onTap: (index) =>
                                      setState(() => _tab = index),
                                  tabs: [
                                    Tab(text: l.notebookSources),
                                    Tab(text: l.notebookChat),
                                    Tab(text: l.studioTitle),
                                  ],
                                ),
                                Expanded(child: workspace),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _skeleton() => Semantics(
    label: l.loading,
    child: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        for (var i = 0; i < 4; i++)
          Container(
            height: 72,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
      ],
    ),
  );
}
