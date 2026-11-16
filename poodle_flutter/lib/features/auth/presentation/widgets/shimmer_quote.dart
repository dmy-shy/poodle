import 'package:flutter/material.dart';

/// Keeps one semantic text node while its paint changes; attribution is external.
class ShimmerQuote extends StatefulWidget {
  const ShimmerQuote({
    super.key,
    required this.text,
    required this.style,
    this.animate = true,
  });
  final String text;
  final TextStyle style;
  final bool animate;
  @override
  State<ShimmerQuote> createState() => _ShimmerQuoteState();
}

class _ShimmerQuoteState extends State<ShimmerQuote>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  void _updateAnimation() {
    if (widget.animate && !MediaQuery.disableAnimationsOf(context)) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAnimation();
  }

  @override
  void didUpdateWidget(covariant ShimmerQuote oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(
      widget.text,
      textAlign: TextAlign.center,
      style: widget.style,
    );
    if (!widget.animate || MediaQuery.disableAnimationsOf(context)) return text;
    final colors = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      child: text,
      builder: (context, child) {
        final center = -2 + 4 * _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(center - 1, 0),
            end: Alignment(center + 1, 0),
            colors: [
              colors.onSurfaceVariant,
              colors.onSurface,
              colors.onSurfaceVariant,
            ],
            stops: const [0.25, 0.5, 0.75],
          ).createShader(bounds),
          child: child,
        );
      },
    );
  }
}
