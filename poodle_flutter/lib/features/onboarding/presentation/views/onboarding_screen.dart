import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../ui/theme/poodle_theme.dart';
import '../../onboarding_story.dart';
import '../view_models/onboarding_view_model.dart';
import '../widgets/story_content.dart';
import '../widgets/story_progress.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});
  final Future<void> Function() onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final _progress = AnimationController(vsync: this);
  OnboardingViewModel? _model;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = context.read<OnboardingViewModel>();
    if (_model != model) {
      _model?.removeListener(_changed);
      _model = model;
      model.addListener(_changed);
    }
    final media = MediaQuery.of(context);
    final accessible = media.disableAnimations || media.accessibleNavigation;
    final obscured =
        !(ModalRoute.of(context)?.isCurrent ?? true) ||
        !TickerMode.valuesOf(context).enabled;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      model.setAccessible(accessible);
      model.setPaused(PauseReason.route, obscured);
      final lifecycle = WidgetsBinding.instance.lifecycleState;
      model.setPaused(
        PauseReason.lifecycle,
        lifecycle != null && lifecycle != AppLifecycleState.resumed,
      );
    });
    _syncProgress();
  }

  void _syncProgress() {
    final model = _model!;
    _progress.stop();
    _progress.value = model.progress;
    if (!model.state.paused) {
      unawaited(
        _progress.animateTo(
          1,
          duration: OnboardingViewModel.storyDuration - model.elapsed,
          curve: Curves.linear,
        ),
      );
    }
  }

  void _changed() {
    if (!mounted) return;
    _syncProgress();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) => _model?.setPaused(
    PauseReason.lifecycle,
    state != AppLifecycleState.resumed,
  );

  Future<void> _finish() async {
    if (_leaving) return;
    setState(() => _leaving = true);
    _model!.setPaused(PauseReason.route, true);
    await widget.onComplete();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _model?.removeListener(_changed);
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = _model!;
    final state = model.state;
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return PopScope(
      canPop: state.index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) model.previous();
      },
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowRight): model.next,
          const SingleActivator(LogicalKeyboardKey.arrowLeft): model.previous,
          const SingleActivator(LogicalKeyboardKey.space): model.togglePlayback,
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(PoodleTheme.spacing),
                    child: Column(
                      children: [
                        StoryProgress(
                          index: state.index,
                          count: OnboardingStory.values.length,
                          progress: _progress,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              tooltip: l.onboardingPrevious,
                              onPressed: state.index == 0
                                  ? null
                                  : model.previous,
                              icon: const Icon(Icons.arrow_back_rounded),
                            ),
                            IconButton(
                              tooltip: state.accessible
                                  ? l.onboardingManual
                                  : state.paused
                                  ? l.onboardingPlay
                                  : l.onboardingPause,
                              onPressed: state.accessible
                                  ? null
                                  : model.togglePlayback,
                              icon: Icon(
                                state.paused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _leaving ? null : _finish,
                                  child: Text(
                                    l.onboardingSkip,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ExcludeSemantics(
                          child: Text(
                            l.onboardingPosition(
                              state.index + 1,
                              OnboardingStory.values.length,
                            ),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(child: StoryContent(model: model)),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _leaving
                              ? null
                              : model.isLast
                              ? _finish
                              : model.next,
                          child: Text(
                            model.isLast ? l.onboardingStart : l.onboardingNext,
                          ),
                        ),
                        // Text(
                        //   l.onboardingPreview,
                        //   style: theme.textTheme.labelSmall?.copyWith(
                        //     color: theme.colorScheme.secondary,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
