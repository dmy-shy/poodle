import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../ui/theme/poodle_theme.dart';
import '../../quotes.dart';
import '../widgets/shimmer_quote.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    this.quote = SplashQuoteId.shevchenko,
    this.animate = true,
  });
  final SplashQuoteId quote;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final copy = quote.localized(AppLocalizations.of(context));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: SizedBox(
                height: max(440, constraints.maxHeight),
                width: constraints.maxWidth,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: _SplashBrand(animate: animate),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 328),
                        child: ShimmerQuote(
                          text: copy.text,
                          animate: animate,
                          style: TextStyle(
                            fontFamily: 'MontserratAlternates',
                            fontSize: 14,
                            height: 1.6,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        copy.author,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SplashBrand extends StatefulWidget {
  const _SplashBrand({required this.animate});

  final bool animate;

  @override
  State<_SplashBrand> createState() => _SplashBrandState();
}

class _SplashBrandState extends State<_SplashBrand>
    with SingleTickerProviderStateMixin {
  static const _durationMs = 780;
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: _durationMs),
  );

  void _syncMotion() {
    if (!widget.animate || MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else if (_controller.value == 0 && !_controller.isAnimating) {
      _controller.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant _SplashBrand oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncMotion();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const logo = 'assets/images/splash-logo.svg';
    const logoHeight = 240.0;
    const scale = logoHeight / 160;
    const letterStyle = TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 15 * scale,
      height: 1,
      color: PoodleTheme.terracotta,
    );

    Widget reveal(Widget child, int start, int end, {double offset = 0}) {
      final progress = _controller.drive(
        CurveTween(
          curve: Interval(
            start / _durationMs,
            end / _durationMs,
            curve: Curves.easeOutCubic,
          ),
        ),
      );
      return FadeTransition(
        opacity: progress,
        child: SlideTransition(
          position: progress.drive(
            Tween(begin: Offset(-offset, 0), end: Offset.zero),
          ),
          child: child,
        ),
      );
    }

    return Semantics(
      image: true,
      label: 'Poodle LMS',
      excludeSemantics: true,
      child: Stack(
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(0.7 * scale, scale),
              // Flutter SVG does not render the original SVG filters.
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: 0.87 * scale,
                  sigmaY: 0.87 * scale,
                ),
                child: SvgPicture.asset(
                  logo,
                  colorFilter: const ColorFilter.mode(
                    Color(0x54DE7759),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          SvgPicture.asset(
            logo,
            height: logoHeight,
            width: logoHeight * 882 / 922,
          ),
          // Place the mark in the open space between the feet in the SVG.
          Positioned(
            left: 364 * logoHeight / 922,
            width: 294 * logoHeight / 922,
            top: 824 * logoHeight / 922,
            height: 72 * logoHeight / 922,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (i, letter) in ['L', 'M', 'S'].indexed)
                    reveal(
                      Text(letter, style: letterStyle),
                      i * 180,
                      (i + 1) * 180,
                      offset: 0.12,
                    ),
                  const SizedBox(width: 3 * scale),
                  reveal(
                    SvgPicture.asset(
                      'assets/images/globe.svg',
                      width: 14 * scale,
                      height: 14 * scale,
                    ),
                    540,
                    _durationMs,
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
