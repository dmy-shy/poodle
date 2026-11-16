import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../view_models/reset_view_model.dart';
import 'auth_messages.dart';

Future<void> showResetDialog(BuildContext context, String email) {
  final repository = context.read<AuthRepository>();
  return showDialog<void>(
    context: context,
    builder: (_) => ChangeNotifierProvider(
      create: (_) => ResetViewModel(repository),
      child: ResetDialog(email: email),
    ),
  );
}

class ResetDialog extends StatefulWidget {
  const ResetDialog({super.key, required this.email});
  final String email;
  @override
  State<ResetDialog> createState() => _ResetDialogState();
}

class _ResetDialogState extends State<ResetDialog> {
  late final _email = TextEditingController(text: widget.email);
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ResetViewModel>();
    final state = model.state;
    final strings = AppLocalizations.of(context);
    return AlertDialog(
      scrollable: true,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              state.sent ? strings.resetConfirmationTitle : strings.resetTitle,
            ),
          ),
          IconButton(
            tooltip: strings.close,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: SizedBox(
        width: 360,
        child: state.sent
            ? Semantics(
                liveRegion: true,
                child: Text(strings.resetConfirmationBody),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(strings.resetBody),
                  const SizedBox(height: 24),
                  TextField(
                    key: const ValueKey('resetEmail'),
                    controller: _email,
                    enabled: !state.busy,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => model.submit(_email.text),
                    decoration: InputDecoration(
                      labelText: strings.email,
                      errorText: strings.emailError(state.emailIssue),
                    ),
                  ),
                  if (state.error case final failure?) ...[
                    const SizedBox(height: 16),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        strings.failureMessage(failure),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
      ),
      actions: state.sent
          ? null
          : [
              FilledButton(
                onPressed: state.busy ? null : () => model.submit(_email.text),
                child: state.busy
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          semanticsLabel: strings.loading,
                        ),
                      )
                    : Text(strings.sendReset),
              ),
            ],
    );
  }
}
