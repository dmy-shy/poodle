import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A compact, theme-colored waiting indicator for Notebook answers.
class AuroraWave extends StatefulWidget {
  const AuroraWave({super.key, required this.label});
  final String label;

  @override
  State<AuroraWave> createState() => _AuroraWaveState();
}

class _AuroraWaveState extends State<AuroraWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staticMotion = MediaQuery.disableAnimationsOf(context);
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: widget.label,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => SizedBox(
            width: 46,
            height: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                final wave = staticMotion
                    ? 0.0
                    : math.sin(2 * math.pi * (_controller.value - index * .13));
                return Transform.translate(
                  offset: Offset(0, -4 * wave),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color:
                          Color.lerp(
                            colors.primary,
                            colors.tertiary,
                            index / 4,
                          )!.withValues(
                            alpha: staticMotion ? 1 : .7 + .3 * wave.abs(),
                          ),
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 6),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
