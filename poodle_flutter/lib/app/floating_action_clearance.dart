import 'dart:math' as math;

import 'package:flutter/material.dart';

class FloatingActionClearance extends InheritedWidget {
  const FloatingActionClearance({
    super.key,
    required this.bottom,
    required super.child,
  });

  final double bottom;

  static FloatingActionButtonLocation locationOf(BuildContext context) {
    final bottom =
        context
            .dependOnInheritedWidgetOfExactType<FloatingActionClearance>()
            ?.bottom ??
        0;
    return bottom == 0
        ? FloatingActionButtonLocation.endFloat
        : _AboveBar(bottom);
  }

  @override
  bool updateShouldNotify(FloatingActionClearance oldWidget) =>
      bottom != oldWidget.bottom;
}

class _AboveBar extends FloatingActionButtonLocation {
  const _AboveBar(this.bottom);
  final double bottom;

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry geometry) {
    final standard = FloatingActionButtonLocation.endFloat.getOffset(geometry);
    return Offset(
      standard.dx,
      math.min(
        standard.dy,
        geometry.scaffoldSize.height -
            geometry.floatingActionButtonSize.height -
            bottom -
            16,
      ),
    );
  }
}
