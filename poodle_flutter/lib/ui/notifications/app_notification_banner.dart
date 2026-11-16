import 'package:flutter/material.dart';

/// Reusable presentation for any short, actionable in-app notification.
class AppNotificationBanner extends StatelessWidget {
  const AppNotificationBanner({
    super.key,
    required this.title,
    required this.message,
    required this.onTap,
    required this.onDismiss,
    this.icon = Icons.notifications_outlined,
  });
  final String title;
  final String message;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Material(
    elevation: 8,
    borderRadius: BorderRadius.circular(16),
    color: Theme.of(context).colorScheme.secondaryContainer,
    child: ListTile(
      leading: Icon(icon),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis),
      // This banner can live above Navigator's Overlay (MaterialApp.builder).
      // Tooltip requires an Overlay; semantics provides the accessible label
      // without that ancestor requirement.
      trailing: Semantics(
        label: MaterialLocalizations.of(context).closeButtonTooltip,
        child: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onDismiss,
        ),
      ),
      onTap: onTap,
    ),
  );
}
