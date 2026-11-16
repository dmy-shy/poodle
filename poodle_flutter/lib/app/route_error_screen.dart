import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'l10n/app_localizations.dart';

/// A safe destination for routing failures; exception details stay in logs.
class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key, required this.notFound});
  final bool notFound;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(notFound ? text.routeNotFoundTitle : text.routeErrorTitle),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  notFound ? Icons.search_off : Icons.error_outline,
                  size: 56,
                ),
                const SizedBox(height: 16),
                Text(
                  notFound ? text.routeNotFoundMessage : text.routeErrorMessage,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => context.go('/home'),
                  child: Text(text.homeTab),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
