import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'signed_in_header.dart';
import 'ios_navigation_bar.dart';
import 'floating_action_clearance.dart';
import 'l10n/app_localizations.dart';

class SignedInShell extends StatefulWidget {
  const SignedInShell({
    super.key,
    required this.navigationShell,
    required this.onSignOut,
    this.offline = false,
    this.onRetryOnline,
  });
  final StatefulNavigationShell navigationShell;
  final VoidCallback onSignOut;
  final bool offline;
  final Future<void> Function()? onRetryOnline;

  @override
  State<SignedInShell> createState() => _SignedInShellState();
}

class _SignedInShellState extends State<SignedInShell>
    with WidgetsBindingObserver {
  bool _checkedIos = false;
  bool _liquidGlass = false;
  bool _minimized = false;
  double _scrollTravel = 0;
  int _lastBranch = 0;

  bool get _reduceMotion =>
      MediaQuery.disableAnimationsOf(context) ||
      WidgetsBinding
          .instance
          .platformDispatcher
          .accessibilityFeatures
          .reduceMotion;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAccessibilityFeatures() {
    setState(() {
      _minimized = false;
      _scrollTravel = 0;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (usesIosBottomNavigation(context) && !_checkedIos) {
      _checkedIos = true;
      _detectIosVersion();
    }
  }

  Future<void> _detectIosVersion() async {
    try {
      final version = await IosNavigationBar.capabilities.invokeMethod<int>(
        'majorVersion',
      );
      if (mounted) setState(() => _liquidGlass = (version ?? 0) >= 26);
    } on MissingPluginException {
      // Previews without the native runner retain usable Cupertino navigation.
    } on PlatformException {
      // A failed capability check keeps the compatible fallback available.
    }
  }

  void _selectBranch(int branch) {
    setState(() {
      _minimized = false;
      _scrollTravel = 0;
    });
    if (branch != widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(branch);
    }
  }

  bool _scroll(ScrollNotification notification) {
    if (!_liquidGlass ||
        !usesIosBottomNavigation(context) ||
        _reduceMotion ||
        MediaQuery.accessibleNavigationOf(context) ||
        notification.depth != 0 ||
        notification.metrics.axis != Axis.vertical) {
      return false;
    }
    if (notification is ScrollUpdateNotification &&
        notification.dragDetails != null) {
      final delta = notification.scrollDelta ?? 0;
      if (delta.sign != _scrollTravel.sign) _scrollTravel = 0;
      _scrollTravel += delta;
      final expand = notification.metrics.pixels <= 0 || _scrollTravel < -16;
      final minimize = notification.metrics.pixels > 80 && _scrollTravel > 32;
      if ((expand && _minimized) || (minimize && !_minimized)) {
        setState(() => _minimized = !expand);
        _scrollTravel = 0;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final ios = usesIosBottomNavigation(context);
    final rail = !ios && size.width >= 600;
    final branch = widget.navigationShell.currentIndex;
    if (_lastBranch != branch) {
      _lastBranch = branch;
      _minimized = false;
      _scrollTravel = 0;
    }
    final branches = ios ? iosTabBranches : materialTabBranches;
    final visibleIndex = branches.indexOf(branch);
    final selected = visibleIndex < 0 ? 0 : visibleIndex;
    final labels = [
      text.homeTab,
      text.coursesTab,
      text.messagesTab,
      text.notificationsTab,
      text.moreTab,
    ];
    const icons = [
      Icons.home_outlined,
      Icons.menu_book_outlined,
      Icons.chat_bubble_outline,
      Icons.notifications_none,
      Icons.more_horiz,
    ];
    final path = GoRouterState.of(context).uri.path;
    const rootPaths = {
      '/home',
      '/courses',
      '/messages',
      '/notifications',
      '/more',
      '/calendar',
      '/search',
    };
    final root = rootPaths.contains(path);
    final body = NotificationListener<ScrollNotification>(
      onNotification: _scroll,
      child: Column(
        children: [
          if (root)
            SignedInHeader(
              showSearch: !ios,
              onSignOut: widget.onSignOut,
              onHome: ios && visibleIndex < 0 ? () => _selectBranch(0) : null,
            ),
          if (widget.offline)
            MaterialBanner(
              content: Text(
                Localizations.localeOf(context).languageCode == 'uk'
                    ? 'Офлайн: доступні збережені дані. Зміни потребують підключення.'
                    : 'Offline: saved content is available. Changes need a connection.',
              ),
              actions: [
                TextButton(
                  onPressed: widget.onRetryOnline,
                  child: Text(
                    Localizations.localeOf(context).languageCode == 'uk'
                        ? 'Повторити'
                        : 'Retry',
                  ),
                ),
              ],
            ),
          Expanded(
            child: FloatingActionClearance(
              bottom: ios && _liquidGlass
                  ? iosTabBarHeight(
                          context,
                          iosTabLabels(context),
                          liquidGlass: true,
                        ) +
                        25 +
                        MediaQuery.viewPaddingOf(context).bottom
                  : 0,
              // The shared header already consumes the top system inset.
              child: Builder(
                builder: (bodyContext) => MediaQuery.removePadding(
                  context: bodyContext,
                  removeTop: root,
                  child: widget.navigationShell,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    final scaffold = Scaffold(
      extendBody: ios && _liquidGlass,
      body: rail
          ? Row(
              children: [
                SafeArea(
                  right: false,
                  child: NavigationRail(
                    selectedIndex: selected,
                    extended: size.width >= 950,
                    onDestinationSelected: (index) =>
                        _selectBranch(materialTabBranches[index]),
                    labelType: size.width >= 950
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.all,
                    destinations: [
                      for (var i = 0; i < labels.length; i++)
                        NavigationRailDestination(
                          icon: Icon(icons[i]),
                          label: Text(labels[i]),
                        ),
                    ],
                  ),
                ),
                Expanded(child: body),
              ],
            )
          : body,
      bottomNavigationBar: rail
          ? null
          : ios
          ? IosNavigationBar(
              selectedIndex: selected,
              liquidGlass: _liquidGlass,
              minimized:
                  _minimized &&
                  !_reduceMotion &&
                  !MediaQuery.accessibleNavigationOf(context),
              onExpand: () => setState(() => _minimized = false),
              onSelected: (index) => _selectBranch(iosTabBranches[index]),
            )
          : NavigationBar(
              selectedIndex: selected,
              onDestinationSelected: (index) =>
                  _selectBranch(materialTabBranches[index]),
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: [
                for (var i = 0; i < labels.length; i++)
                  _SingleLineNavigationDestination(
                    icon: Icon(icons[i]),
                    label: materialTabBranches[i] == 2
                        ? text.compactMessagesTab
                        : labels[i],
                    tooltip: labels[i],
                  ),
              ],
            ),
    );
    return PopScope(
      canPop: branch == 0 || context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && branch != 0) _selectBranch(0);
      },
      child: ios
          ? CupertinoTheme(
              data: CupertinoThemeData(
                brightness: Brightness.light,
                primaryColor: Theme.of(context).colorScheme.primary,
              ),
              child: scaffold,
            )
          : scaffold,
    );
  }
}

class _SingleLineNavigationDestination extends NavigationDestination {
  const _SingleLineNavigationDestination({
    required super.icon,
    required super.label,
    required super.tooltip,
  });

  @override
  Widget build(BuildContext context) => DefaultTextStyle.merge(
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    child: Builder(builder: super.build),
  );
}
