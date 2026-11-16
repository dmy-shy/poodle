import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../view_models/verification_view_model.dart';
import '../widgets/auth_messages.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, this.initialEmail});
  final String? initialEmail;
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _value = TextEditingController();
  final _confirm = TextEditingController();
  VerificationStep? _previous;
  @override
  void dispose() {
    _value.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<VerificationViewModel>();
    final strings = AppLocalizations.of(context);
    final step = model.step;
    if (_previous != step) {
      if (_previous == null && step == VerificationStep.email) {
        _value.text = widget.initialEmail ?? '';
      } else {
        _value.clear();
      }
      _confirm.clear();
      _previous = step;
    }
    final password = step == VerificationStep.password;
    final label = switch (step) {
      VerificationStep.email => strings.email,
      VerificationStep.code => strings.authVerificationCode,
      VerificationStep.password => strings.authNewPassword,
      VerificationStep.done => strings.authResetDone,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(model.reset ? strings.resetTitle : strings.invitationTitle),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                if (step == VerificationStep.code) ...[
                  Text(strings.authCodeNotice),
                  const SizedBox(height: 20),
                ],
                if (step == VerificationStep.done) ...[
                  Text(strings.authResetDone),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(strings.authBackToLogin),
                  ),
                ] else ...[
                  TextField(
                    key: ValueKey('verification-${step.name}'),
                    controller: _value,
                    enabled: !model.busy,
                    obscureText: password,
                    autocorrect: false,
                    enableSuggestions: !password,
                    keyboardType: step == VerificationStep.email
                        ? TextInputType.emailAddress
                        : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: label,
                      errorText: strings.emailError(model.emailIssue),
                    ),
                  ),
                  if (password) ...[
                    const SizedBox(height: 16),
                    TextField(
                      key: const ValueKey('verification-confirm'),
                      controller: _confirm,
                      enabled: !model.busy,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        labelText: strings.authConfirmPassword,
                        errorText: model.mismatch
                            ? strings.authPasswordMismatch
                            : null,
                      ),
                    ),
                    if (!model.reset)
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(strings.rememberMe),
                        value: model.rememberMe,
                        onChanged: model.busy
                            ? null
                            : (value) => setState(
                                () => model.rememberMe = value ?? false,
                              ),
                      ),
                  ],
                  if (model.error case final error?)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          strings.failureMessage(error),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: model.busy
                        ? null
                        : () => model.submit(
                            _value.text,
                            confirmation: _confirm.text,
                          ),
                    child: Text(
                      model.busy
                          ? strings.loading
                          : switch (step) {
                              VerificationStep.email => strings.authRequestCode,
                              VerificationStep.code => strings.authVerifyCode,
                              _ =>
                                model.reset
                                    ? strings.authSavePassword
                                    : strings.authCreateAccount,
                            },
                    ),
                  ),
                  if (step != VerificationStep.email)
                    TextButton(
                      onPressed: model.busy ? null : model.startOver,
                      child: Text(strings.authStartOver),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
