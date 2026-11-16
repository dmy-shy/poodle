part of 'notebook_screen.dart';

class _SavedNotes extends StatefulWidget {
  const _SavedNotes({required this.repository, required this.notebookId});
  final NotebookRepository repository;
  final String notebookId;

  @override
  State<_SavedNotes> createState() => _SavedNotesState();
}

class _SavedNotesState extends State<_SavedNotes> {
  late final int _generation = widget.repository.generation;
  late Future<List<StudyNote>> _notes = widget.repository.notes(
    widget.notebookId,
  );
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _generation;
    _notes;
    widget.repository.addListener(_accountChanged);
  }

  void _accountChanged() {
    if (widget.repository.generation != _generation && mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.repository.removeListener(_accountChanged);
    super.dispose();
  }

  void _reload() =>
      setState(() => _notes = widget.repository.notes(widget.notebookId));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final uk = l.localeName == 'uk';
    return Scaffold(
      appBar: AppBar(title: Text(l.notebookSavedNotes)),
      body: widget.repository.generation != _generation
          ? Text(l.notebookNotebookUnavailableRefreshToTryAgain)
          : FutureBuilder(
              future: _notes,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: TextButton(
                      onPressed: _reload,
                      child: Text(l.authRetry),
                    ),
                  );
                }
                final notes = snapshot.data ?? const <StudyNote>[];
                if (notes.isEmpty) {
                  return Center(
                    child: Text(l.notebookNoSavedNotes),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final note in notes)
                      ExpansionTile(
                        title: Text(
                          MaterialLocalizations.of(
                            context,
                          ).formatMediumDate(note.createdAt.toLocal()),
                        ),
                        subtitle: note.stale
                            ? Text(
                                l.notebookSourcesChangedAskAgainForAnUpdatedAnswer,
                              )
                            : null,
                        children: [
                          MarkdownBody(
                            data: note.content,
                            selectable: true,
                            imageBuilder: (_, _, alt) => Text(alt ?? ''),
                            onTapLink: (_, _, _) {},
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                tooltip: l.notebookCopyAnswer,
                                icon: const Icon(Icons.copy_outlined),
                                onPressed: () => Clipboard.setData(
                                  ClipboardData(text: note.content),
                                ),
                              ),
                              IconButton(
                                tooltip: l.notebookDeleteNote,
                                icon: const Icon(Icons.delete_outline),
                                onPressed: _deleting
                                    ? null
                                    : () async {
                                        final confirmed =
                                            await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  l.notebookDeleteNoteConfirm,
                                                ),
                                                actions: [
                                                  ConfirmationActions(
                                                    cancel: l.cancel,
                                                    confirm: uk
                                                        ? 'Видалити'
                                                        : 'Delete',
                                                    destructive: true,
                                                  ),
                                                ],
                                              ),
                                            );
                                        if (confirmed != true ||
                                            !mounted ||
                                            _deleting ||
                                            widget.repository.generation !=
                                                _generation) {
                                          return;
                                        }
                                        setState(() => _deleting = true);
                                        try {
                                          await widget.repository.deleteNote(
                                            widget.notebookId,
                                            note.id,
                                          );
                                          if (mounted &&
                                              widget.repository.generation ==
                                                  _generation) {
                                            _reload();
                                          }
                                        } catch (_) {
                                          if (mounted &&
                                              widget.repository.generation ==
                                                  _generation) {
                                            ScaffoldMessenger.of(
                                              this.context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  l.notebookDeleteNoteFailed,
                                                ),
                                              ),
                                            );
                                          }
                                        } finally {
                                          if (mounted) {
                                            setState(() => _deleting = false);
                                          }
                                        }
                                      },
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
    );
  }
}
