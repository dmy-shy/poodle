import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../widgets/auth_messages.dart';

class AuthRecoveryScreen extends StatelessWidget {
  const AuthRecoveryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repository = context.watch<AuthRepository>();
    final text = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text.authRecoveryTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(
                  text.failureMessage(
                    repository.startupFailure ?? AuthFailure.unavailable,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: repository.restoreSession,
                  child: Text(text.authRetry),
                ),
                TextButton(
                  onPressed: repository.signOut,
                  child: Text(text.authBackToLogin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
