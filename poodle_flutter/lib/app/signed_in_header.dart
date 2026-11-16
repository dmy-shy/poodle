import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth_repository.dart';
import '../ui/components/email_avatar.dart';
import 'l10n/app_localizations.dart';

class SignedInHeader extends StatelessWidget {
  const SignedInHeader({
    super.key,
    required this.showSearch,
    required this.onSignOut,
    this.onHome,
  });

  final bool showSearch;
  final VoidCallback onSignOut;
  final VoidCallback? onHome;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final email = context.watch<AuthRepository>().session?.email ?? '';
    final theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 12, 4),
          child: Row(
            children: [
              if (onHome != null)
                IconButton(
                  key: const ValueKey('header-home-back'),
                  tooltip: text.homeTab,
                  onPressed: onHome,
                  icon: const Icon(Icons.arrow_back),
                ),
              Expanded(
                child: Text(
                  'Poodle',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              if (showSearch)
                IconButton(
                  key: const ValueKey('header-search'),
                  tooltip: text.searchTab,
                  onPressed: () => context.push('/search-content'),
                  icon: const Icon(Icons.search),
                ),
              PopupMenuButton<String>(
                key: const ValueKey('account-menu'),
                tooltip: text.authAccount,
                icon: EmailAvatar(email: email),
                onSelected: (choice) {
                  switch (choice) {
                    case 'profile':
                      context.push('/profile');
                      return;
                    case 'messages':
                      context.go('/messages');
                      return;
                    case 'more':
                      context.go('/more');
                      return;
                    case 'settings':
                      context.push('/more/feature/$choice');
                      return;
                    case 'help':
                      context.push('/help');
                      return;
                    case 'signout':
                      onSignOut();
                      return;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    enabled: false,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 230),
                      child: Text(email, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'profile',
                    child: Text(text.dashboardProfile),
                  ),
                  PopupMenuItem(
                    value: 'messages',
                    child: Text(text.messagesTab),
                  ),
                  PopupMenuItem(value: 'more', child: Text(text.moreTab)),
                  PopupMenuItem(
                    value: 'settings',
                    child: Text(text.dashboardSettings),
                  ),
                  PopupMenuItem(value: 'help', child: Text(text.dashboardHelp)),
                  const PopupMenuDivider(),
                  PopupMenuItem(value: 'signout', child: Text(text.signOut)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
