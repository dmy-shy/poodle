import 'package:flutter/material.dart';
import '../view_models/onboarding_view_model.dart';
import 'story_illustration.dart';

class StoryGestureArea extends StatefulWidget {
  const StoryGestureArea({super.key, required this.model});
  final OnboardingViewModel model;

  @override
  State<StoryGestureArea> createState() => _StoryGestureAreaState();
}

class _StoryGestureAreaState extends State<StoryGestureArea> {
  double _distance = 0;
  void _hold(bool paused) => widget.model.setPaused(PauseReason.hold, paused);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, area) => GestureDetector(
      key: const ValueKey('story-illustration'),
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTapDown: (_) => _hold(true),
      onTapCancel: () => _hold(false),
      onTapUp: (details) {
        _hold(false);
        details.localPosition.dx < area.maxWidth / 2
            ? widget.model.previous()
            : widget.model.next();
      },
      onLongPressStart: (_) => _hold(true),
      onLongPressEnd: (_) => _hold(false),
      onLongPressCancel: () => _hold(false),
      onHorizontalDragStart: (_) {
        _distance = 0;
        _hold(true);
      },
      onHorizontalDragUpdate: (details) =>
          _distance += details.primaryDelta ?? 0,
      onHorizontalDragCancel: () => _hold(false),
      onHorizontalDragEnd: (_) {
        _hold(false);
        if (_distance.abs() > 40) {
          _distance < 0 ? widget.model.next() : widget.model.previous();
        }
      },
      child: StoryIllustration(story: widget.model.story),
    ),
  );
}
