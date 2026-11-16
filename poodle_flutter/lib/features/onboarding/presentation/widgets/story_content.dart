import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../onboarding_story.dart';
import '../onboarding_copy.dart';
import '../view_models/onboarding_view_model.dart';
import 'story_gesture_area.dart';

class StoryContent extends StatelessWidget {
  const StoryContent({super.key, required this.model});
  final OnboardingViewModel model;

  void _focusChanged(BuildContext context) {
    model.setPaused(PauseReason.focus, true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) model.setPaused(PauseReason.focus, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final enlarged = MediaQuery.textScalerOf(context).scale(16) > 24;
        final illustrationHeight =
            constraints.maxHeight < (enlarged ? 540 : 300)
            ? 0.0
            : math.min(320.0, constraints.maxHeight * (enlarged ? .32 : .53));
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification) {
              model.setPaused(PauseReason.scroll, true);
            }
            if (notification is ScrollEndNotification) {
              model.setPaused(PauseReason.scroll, false);
            }
            return false;
          },
          child: SingleChildScrollView(
            key: ValueKey('story-content-${model.story.name}'),
            child: Column(
              children: [
                if (illustrationHeight > 0)
                  SizedBox(
                    height: illustrationHeight,
                    child: StoryGestureArea(model: model),
                  ),
                SizedBox(height: illustrationHeight > 0 ? 20 : 8),
                Semantics(
                  key: ValueKey('story-${model.story.name}'),
                  liveRegion: true,
                  container: true,
                  label:
                      '${l.onboardingPosition(model.state.index + 1, OnboardingStory.values.length)}. ${model.story.title(l)} ${model.story.body(l)}',
                  onDidGainAccessibilityFocus: () => _focusChanged(context),
                  child: ExcludeSemantics(
                    child: Column(
                      children: [
                        Text(
                          model.story.title(l),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 30,
                            height: 1.16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          model.story.body(l),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
