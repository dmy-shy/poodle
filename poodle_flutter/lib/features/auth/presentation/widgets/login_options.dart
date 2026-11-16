import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../view_models/login_view_model.dart';

class LoginOptions extends StatelessWidget {
  const LoginOptions({super.key, required this.onForgot});
  final VoidCallback onForgot;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<LoginViewModel>();
    final strings = AppLocalizations.of(context);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        MergeSemantics(
          child: InkWell(
            onTap: model.state.busy
                ? null
                : () => model.setRememberMe(!model.state.rememberMe),
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: model.state.rememberMe,
                  onChanged: model.state.busy
                      ? null
                      : (value) => model.setRememberMe(value ?? false),
                ),
                Flexible(
                  child: Text(
                    strings.rememberMe,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: model.state.busy ? null : onForgot,
          child: Text(strings.forgotPassword, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

class InvitationHint extends StatelessWidget {
  const InvitationHint({super.key});
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final preview = context.watch<LoginViewModel>().isPreview;
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          preview ? strings.invitationPrompt : strings.institutionContactPrompt,
        ),
        TextButton(
          onPressed: () => !preview
              ? context.push('/university/request')
              : showDialog<void>(
                  context: context,
                  builder: (context) {
                    final strings = AppLocalizations.of(context);
                    return AlertDialog(
                      scrollable: true,
                      title: Text(strings.invitationTitle),
                      content: Text(strings.invitationBody),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(strings.close),
                        ),
                      ],
                    );
                  },
                ),
          child: Text(
            preview
                ? strings.invitationAction
                : strings.institutionContactAction,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
