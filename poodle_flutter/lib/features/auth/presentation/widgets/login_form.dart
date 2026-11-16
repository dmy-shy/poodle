import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../view_models/login_view_model.dart';
import 'auth_messages.dart';
import 'login_options.dart';
import 'reset_dialog.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<LoginViewModel>().submitEmail(_email.text, _password.text);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<LoginViewModel>();
    final state = model.state;
    final strings = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const ValueKey('email'),
            controller: _email,
            enabled: !state.busy,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            autocorrect: false,
            onSubmitted: (_) => _passwordFocus.requestFocus(),
            decoration: InputDecoration(
              labelText: strings.email,
              hintText: strings.emailHint,
              errorText: strings.emailError(state.emailIssue),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('password'),
            controller: _password,
            focusNode: _passwordFocus,
            enabled: !state.busy,
            obscureText: !state.passwordVisible,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            autocorrect: false,
            enableSuggestions: false,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              labelText: strings.password,
              hintText: strings.passwordHint,
              errorText: state.passwordMissing
                  ? strings.passwordRequired
                  : null,
              suffixIcon: IconButton(
                tooltip: state.passwordVisible
                    ? strings.hidePassword
                    : strings.showPassword,
                onPressed: state.busy ? null : model.togglePassword,
                icon: Icon(
                  state.passwordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          LoginOptions(
            onForgot: () => model.isPreview
                ? showResetDialog(context, _email.text)
                : context.push('/reset'),
          ),
          const SizedBox(height: 16),
          if (state.error case final failure?) ...[
            Semantics(
              liveRegion: true,
              child: Text(
                strings.failureMessage(failure),
                style: TextStyle(color: colors.error),
              ),
            ),
            const SizedBox(height: 16),
          ],
          FilledButton(
            onPressed: state.busy ? null : _submit,
            child: state.action == AuthAction.email
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      semanticsLabel: strings.loading,
                    ),
                  )
                : Text(strings.logIn, textAlign: TextAlign.center),
          ),
          if (model.isPreview ||
              !kIsWeb &&
                  (defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS)) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(child: Divider()),
                const SizedBox(width: 12),
                Flexible(
                  flex: 2,
                  child: Text(
                    strings.orContinueWith,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: state.busy || !model.googleAvailable
                  ? null
                  : model.submitGoogle,
              child: state.action == AuthAction.google
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        semanticsLabel: strings.loading,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/google.svg',
                          package: 'serverpod_auth_idp_flutter',
                          width: 20,
                          height: 20,
                          excludeFromSemantics: true,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            strings.googleSignIn,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
          if (!model.isPreview && model.logoutFailure != null) ...[
            const SizedBox(height: 16),
            Semantics(
              liveRegion: true,
              child: Text(
                model.logoutFailure == AuthFailure.storage
                    ? strings.authLogoutStorage
                    : strings.authLogoutUnconfirmed,
              ),
            ),
            if (model.logoutFailure == AuthFailure.storage)
              TextButton(
                onPressed: model.retrySignOut,
                child: Text(strings.signOut),
              ),
          ],
          const InvitationHint(),
        ],
      ),
    );
  }
}
