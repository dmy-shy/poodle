part of 'notebook_studio_panel.dart';

class _StudioDetail extends StatefulWidget {
  const _StudioDetail({
    super.key,
    required this.item,
    required this.offline,
    required this.active,
    required this.close,
    required this.audio,
    required this.passage,
  });
  final StudyStudioItem item;
  final bool offline;
  final bool active;
  final VoidCallback close;
  final Future<StudyAudioAccess> Function() audio;
  final Future<String> Function(String) passage;

  @override
  State<_StudioDetail> createState() => _StudioDetailState();
}

class _StudioDetailState extends State<_StudioDetail> {
  final _answer = TextEditingController();
  late final _content = StudioContent.decode(
    widget.item.kind,
    widget.item.contentJson,
  );
  int _index = 0, _score = 0;
  int? _choice;
  bool _revealed = false, _done = false;
  String? _passageId;
  Future<String>? _passage;

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  void _resetQuestion() {
    _choice = null;
    _revealed = false;
    _passageId = null;
    _passage = null;
    _answer.clear();
  }

  Widget _citations(AppLocalizations l, List<String> ids) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final citation in widget.item.citations)
              if (ids.contains(citation.chunkId))
                ActionChip(
                  avatar: const Icon(Icons.book_outlined, size: 16),
                  label: Text(citation.title, overflow: TextOverflow.ellipsis),
                  onPressed: () => setState(() {
                    _passageId = citation.chunkId;
                    _passage = widget.passage(citation.chunkId!);
                  }),
                ),
          ],
        ),
        if (_passage != null && ids.contains(_passageId))
          FutureBuilder<String>(
            future: _passage,
            builder: (context, state) {
              if (state.connectionState != ConnectionState.done) {
                return const LinearProgressIndicator();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SelectableText(
                  state.data ??
                      _studioError(
                        l,
                        state.error ?? NotebookFailure.unavailable,
                      ),
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final content = _content;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: widget.close,
            icon: const Icon(Icons.arrow_back),
            label: Text(l.studioTitle),
          ),
        ),
        Text(
          widget.item.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        if (content == null || content.rows.isEmpty)
          Text(l.notebookProcessingFailed)
        else if (content case StudioAudio(:final rows)) ...[
          if (widget.offline)
            Text(
              Localizations.localeOf(context).languageCode == 'uk'
                  ? 'Аудіо потребує підключення. Текст доступний нижче.'
                  : 'Audio needs a connection. The transcript is available below.',
            )
          else
            _StudioAudioPlayer(active: widget.active, access: widget.audio),
          const SizedBox(height: 16),
          Text(
            l.studioTranscript,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          for (final (text, citations) in rows) ...[
            const SizedBox(height: 12),
            SelectableText(text),
            _citations(l, citations),
          ],
        ] else if (content case StudioFlashcards(:final rows))
          ..._flashcards(l, rows)
        else if (content case StudioQuiz(:final rows))
          ..._quiz(l, rows),
      ],
    );
  }

  List<Widget> _flashcards(
    AppLocalizations l,
    List<StudioCardRow> rows,
  ) {
    final (front, back, citations) = rows[_index];
    return [
      Text('${_index + 1} / ${rows.length}'),
      const SizedBox(height: 8),
      Card(
        child: InkWell(
          onTap: () => setState(() => _revealed = !_revealed),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Text(
                  _revealed ? back : front,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(_revealed ? l.studioShowFront : l.studioShowAnswer),
              ],
            ),
          ),
        ),
      ),
      if (_revealed) _citations(l, citations),
      Wrap(
        spacing: 8,
        children: [
          OutlinedButton(
            onPressed: _index == 0
                ? null
                : () => setState(() {
                    _index--;
                    _resetQuestion();
                  }),
            child: Text(l.studioPrevious),
          ),
          OutlinedButton(
            onPressed: _index == rows.length - 1
                ? null
                : () => setState(() {
                    _index++;
                    _resetQuestion();
                  }),
            child: Text(l.studioNext),
          ),
        ],
      ),
    ];
  }

  List<Widget> _quiz(AppLocalizations l, List<StudioQuizRow> rows) {
    if (_done) {
      return [
        Text(
          l.studioScore(_score, rows.length),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton(
            onPressed: () => setState(() {
              _score = 0;
              _index = 0;
              _done = false;
              _resetQuestion();
            }),
            child: Text(l.studioRestart),
          ),
        ),
      ];
    }
    final row = rows[_index];
    final choices = row.options;
    void advance(bool correct) => setState(() {
      if (correct) _score++;
      if (_index + 1 == rows.length) {
        _done = true;
      } else {
        _index++;
      }
      _resetQuestion();
    });
    return [
      Text('${_index + 1} / ${rows.length}'),
      const SizedBox(height: 8),
      Text(
        row.prompt,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 12),
      if (choices != null)
        for (var i = 0; i < choices.length; i++)
          Align(
            alignment: Alignment.centerLeft,
            child: ChoiceChip(
              label: Text(choices[i]),
              selected: _choice == i,
              onSelected: _revealed ? null : (_) => setState(() => _choice = i),
            ),
          )
      else
        TextField(
          controller: _answer,
          readOnly: _revealed,
          maxLength: 1000,
          maxLines: 3,
          decoration: InputDecoration(labelText: l.studioYourAnswer),
        ),
      const SizedBox(height: 12),
      if (!_revealed)
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton(
            onPressed: choices != null && _choice == null
                ? null
                : () => setState(() => _revealed = true),
            child: Text(l.studioShowAnswer),
          ),
        )
      else ...[
        if (choices != null)
          Text(
            _choice == row.correctIndex ? l.studioCorrect : l.studioIncorrect,
          ),
        SelectableText(
          row.answer,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SelectableText(row.explanation),
        _citations(l, row.citationIds),
        if (choices != null)
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () => advance(_choice == row.correctIndex),
              child: Text(l.studioNext),
            ),
          )
        else
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: () => advance(true),
                child: Text(l.studioCorrect),
              ),
              OutlinedButton(
                onPressed: () => advance(false),
                child: Text(l.studioIncorrect),
              ),
            ],
          ),
      ],
    ];
  }
}

class _StudioAudioPlayer extends StatefulWidget {
  const _StudioAudioPlayer({required this.active, required this.access});
  final bool active;
  final Future<StudyAudioAccess> Function() access;

  @override
  State<_StudioAudioPlayer> createState() => _StudioAudioPlayerState();
}

class _StudioAudioPlayerState extends State<_StudioAudioPlayer> {
  AudioPlayer? _player;
  StreamSubscription<PlayerException>? _errors;
  final _client = http.Client();
  StudioAudioClip? _clip;
  bool _loading = false, _failed = false;
  double _speed = 1;

  void _playbackFailed() {
    if (mounted) setState(() => _failed = true);
  }

  Future<StudioAudioClip> _download(String url) async {
    // Database storage serves a full response. Load the bounded clip once so
    // seeking works without requiring byte ranges from the storage provider.
    const limit = 3000000;
    final response = await _client
        .send(http.Request('GET', Uri.parse(url)))
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != 200 || (response.contentLength ?? 0) > limit) {
      final rejected = response.stream.listen((_) {});
      await rejected.cancel();
      throw StateError('Audio download unavailable');
    }
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in response.stream.timeout(
      const Duration(seconds: 20),
    )) {
      if (bytes.length + chunk.length > limit) {
        throw StateError('Audio download exceeded size limit');
      }
      bytes.add(chunk);
    }
    return cacheStudioAudio(bytes.takeBytes());
  }

  Future<void> _toggle() async {
    if (_loading || !widget.active) return;
    final reload = _failed || _clip == null;
    setState(() {
      _loading = true;
      _failed = false;
    });
    StudioAudioClip? staging;
    try {
      final player = _player ??= AudioPlayer();
      _errors ??= player.errorStream.listen((_) => _playbackFailed());
      if (!reload &&
          player.playing &&
          player.processingState != ProcessingState.completed) {
        await player.pause();
        return;
      }
      if (reload) {
        final position = player.processingState == ProcessingState.completed
            ? Duration.zero
            : player.position;
        final access = await widget.access();
        if (!mounted || !widget.active) return;
        staging = await _download(access.url);
        if (!mounted || !widget.active) return;
        await player.setAudioSource(
          AudioSource.uri(staging.uri),
          initialPosition: position,
        );
        if (!mounted) return;
        final prior = _clip;
        _clip = staging;
        staging = null;
        await prior?.dispose();
      } else if (player.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }
      if (mounted && widget.active) {
        unawaited(player.play().catchError((Object _) => _playbackFailed()));
      }
    } catch (_) {
      _playbackFailed();
    } finally {
      await staging?.dispose();
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void didUpdateWidget(_StudioAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.active) unawaited(_player?.pause());
  }

  @override
  void dispose() {
    _client.close();
    unawaited(_errors?.cancel());
    final clip = _clip;
    final player = _player;
    unawaited(() async {
      try {
        await player?.dispose();
      } finally {
        await clip?.dispose();
      }
    }());
    super.dispose();
  }

  String _time(Duration duration) =>
      '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final player = _player;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StreamBuilder<PlayerState>(
              stream: player?.playerStateStream,
              builder: (context, snapshot) {
                final playing =
                    snapshot.data?.playing == true &&
                    snapshot.data?.processingState != ProcessingState.completed;
                return PoodleFilledIconButton(
                  tooltip: playing ? l.studioPause : l.studioPlay,
                  onPressed: _loading ? null : _toggle,
                  icon: playing ? Icons.pause : Icons.play_arrow,
                );
              },
            ),
            const SizedBox(width: 8),
            if (player != null)
              DropdownButton<double>(
                value: _speed,
                isDense: true,
                items: [
                  for (final speed in [.75, 1.0, 1.25, 1.5, 2.0])
                    DropdownMenuItem(value: speed, child: Text('$speed×')),
                ],
                onChanged: (speed) async {
                  if (speed == null) return;
                  try {
                    await player.setSpeed(speed);
                    if (mounted) setState(() => _speed = speed);
                  } catch (_) {
                    if (mounted) setState(() => _failed = true);
                  }
                },
              ),
          ],
        ),
        if (_loading) const LinearProgressIndicator(),
        if (_failed) Text(l.studioAudioUnavailable),
        if (player != null)
          StreamBuilder<Duration?>(
            stream: player.durationStream,
            builder: (context, durationSnapshot) {
              final duration = durationSnapshot.data ?? Duration.zero;
              if (duration <= Duration.zero) return const SizedBox.shrink();
              return StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (context, positionSnapshot) {
                  final position = positionSnapshot.data ?? Duration.zero;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Slider(
                        max: duration.inMilliseconds.toDouble(),
                        value: position.inMilliseconds
                            .clamp(0, duration.inMilliseconds)
                            .toDouble(),
                        semanticFormatterCallback: (value) =>
                            _time(Duration(milliseconds: value.round())),
                        onChanged: _loading
                            ? null
                            : (value) async {
                                try {
                                  await player.seek(
                                    Duration(milliseconds: value.round()),
                                  );
                                } catch (_) {
                                  _playbackFailed();
                                }
                              },
                      ),
                      Text('${_time(position)} / ${_time(duration)}'),
                    ],
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
