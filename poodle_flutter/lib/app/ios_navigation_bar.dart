import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'l10n/app_localizations.dart';

bool usesIosBottomNavigation(BuildContext context) =>
    !kIsWeb &&
    defaultTargetPlatform == TargetPlatform.iOS &&
    MediaQuery.sizeOf(context).shortestSide < 600;

/// Router indices stay stable even though the visible iOS tabs differ.
const iosTabBranches = [0, 1, 5, 3, 6];
const materialTabBranches = [0, 1, 2, 3, 4];

class IosNavigationBar extends StatefulWidget {
  const IosNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.liquidGlass,
    required this.minimized,
    required this.onExpand,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool liquidGlass;
  final bool minimized;
  final VoidCallback onExpand;

  static const capabilities = MethodChannel('poodle/ios_navigation');

  @override
  State<IosNavigationBar> createState() => _IosNavigationBarState();
}

class _IosNavigationBarState extends State<IosNavigationBar> {
  MethodChannel? _channel;

  Map<String, Object> _configuration() => {
    'labels': iosTabLabels(context),
    'selectedIndex': widget.selectedIndex,
    'minimized': widget.minimized,
    'reduceMotion':
        MediaQuery.disableAnimationsOf(context) ||
        WidgetsBinding
            .instance
            .platformDispatcher
            .accessibilityFeatures
            .reduceMotion,
    'textScale': MediaQuery.textScalerOf(context).scale(10) / 10,
    'tint': CupertinoTheme.of(context).primaryColor.toARGB32(),
  };

  @override
  void didUpdateWidget(IosNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateNativeView();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateNativeView();
  }

  Future<void> _updateNativeView() async {
    final channel = _channel;
    if (channel == null) return;
    try {
      await channel.invokeMethod<void>('update', _configuration());
    } on PlatformException catch (error) {
      if (mounted) {
        FlutterError.reportError(FlutterErrorDetails(exception: error));
      }
    }
  }

  void _created(int viewId) {
    final channel = MethodChannel('poodle/ios_navigation/$viewId');
    _channel = channel;
    channel.setMethodCallHandler((call) async {
      if (!mounted) return;
      if (call.method == 'select' && call.arguments is int) {
        final index = call.arguments as int;
        if (index >= 0 && index < 5) widget.onSelected(index);
      } else if (call.method == 'expand') {
        widget.onExpand();
      }
    });
    _updateNativeView();
  }

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = iosTabLabels(context);
    final height = iosTabBarHeight(
      context,
      labels,
      liquidGlass: widget.liquidGlass,
    );
    if (widget.liquidGlass) {
      return SafeArea(
        top: false,
        child: SizedBox(
          height: height + 25,
          child: UiKitView(
            viewType: 'poodle/ios_tab_bar',
            creationParams: _configuration(),
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _created,
          ),
        ),
      );
    }
    const icons = [
      CupertinoIcons.house,
      CupertinoIcons.book,
      CupertinoIcons.calendar,
      CupertinoIcons.bell,
      CupertinoIcons.search,
    ];
    const selectedIcons = [
      CupertinoIcons.house_fill,
      CupertinoIcons.book_fill,
      CupertinoIcons.calendar,
      CupertinoIcons.bell_fill,
      CupertinoIcons.search,
    ];
    return CupertinoTabBar(
      currentIndex: widget.selectedIndex,
      onTap: widget.onSelected,
      height: height,
      items: [
        for (var i = 0; i < labels.length; i++)
          BottomNavigationBarItem(
            icon: Icon(icons[i]),
            activeIcon: Icon(selectedIcons[i]),
            label: labels[i],
          ),
      ],
    );
  }
}

List<String> iosTabLabels(BuildContext context) {
  final text = AppLocalizations.of(context);
  return [
    text.homeTab,
    text.myCoursesTab,
    text.dashboardCalendar,
    text.notificationsTab,
    text.searchTab,
  ];
}

double iosTabBarHeight(
  BuildContext context,
  List<String> labels, {
  required bool liquidGlass,
}) {
  final width = MediaQuery.sizeOf(context).width;
  final labelWidth = liquidGlass ? (width - 104) / 4 - 8 : width / 5 - 4;
  final scaler = MediaQuery.textScalerOf(context);
  var labelHeight = 0.0;
  for (final label in labels.take(liquidGlass ? 4 : 5)) {
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
      maxLines: liquidGlass ? 1 : null,
      textDirection: Directionality.of(context),
      textScaler: scaler,
    )..layout(maxWidth: math.max(1, labelWidth));
    labelHeight = math.max(labelHeight, painter.height);
    painter.dispose();
  }
  // Native content: 23-point icon, 4-point gap, 12-point button padding
  // and 12-point outer capsule padding. Native labels fit a single line.
  return math.max(64.0, (liquidGlass ? 46 : 44) + labelHeight);
}
