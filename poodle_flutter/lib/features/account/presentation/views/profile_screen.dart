import '../../../../ui/components/confirmation_actions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../ui/components/email_avatar.dart';
import '../../../auth/presentation/widgets/auth_messages.dart';
import '../view_models/account_view_model.dart';
import '../view_models/email_change_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.institutionAccess = false});
  final bool institutionAccess;
  @override
  Widget build(BuildContext context) {
    final model = context.watch<AccountViewModel>();
    final text = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(text.dashboardProfile)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (model.busy) const LinearProgressIndicator(),
          if (model.error case final failure?) ...[
            Text(text.failureMessage(failure)),
            TextButton(
              onPressed: model.busy ? null : model.load,
              child: Text(text.authRetry),
            ),
          ] else if (model.account case final account?) ...[
            Center(
              child: EmailAvatar(email: account.email, radius: 36),
            ),
            const SizedBox(height: 20),
            SelectableText(
              account.email,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (!context.read<AuthRepository>().isPreview) ...[
              const SizedBox(height: 12),
              if (account.hasPassword)
                OutlinedButton(
                  onPressed: model.busy
                      ? null
                      : () => showEmailChangeDialog(context),
                  child: Text(text.authChangeEmail),
                )
              else
                Text(text.authPasswordManagedByGoogle),
            ],
            const SizedBox(height: 12),
            Text(account.isAdmin ? text.authAdmin : text.authMember),
            if (!context.read<AuthRepository>().isPreview &&
                (model.googleAvailable || account.googleLinked))
              account.googleLinked
                  ? Text(text.googleLinked)
                  : OutlinedButton(
                      onPressed: model.busy ? null : model.linkGoogle,
                      child: Text(text.googleLink),
                    ),
            if (account.teacherApproved) Text(text.authTeacherApproved),
            if (institutionAccess && account.isAdmin)
              ListTile(
                title: Text(text.institutionOperator),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/more/university-requests'),
              ),
            if (institutionAccess && account.isUniversityAdmin)
              ListTile(
                title: Text(text.institutionAdmin),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/more/university'),
              ),
            if (institutionAccess &&
                account.teacherApproved &&
                account.universityId != null)
              ListTile(
                title: Text(text.institutionTeaching),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/more/teaching-courses'),
              ),
            if (account.isAdmin && !institutionAccess)
              ListTile(
                title: Text(text.authInvitations),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/more/invitations'),
              ),
          ],
        ],
      ),
    );
  }
}

Future<void> showEmailChangeDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) => const _EmailChangeDialog(),
);

class _EmailChangeDialog extends StatefulWidget {
  const _EmailChangeDialog();
  @override
  State<_EmailChangeDialog> createState() => _EmailChangeDialogState();
}

class _EmailChangeDialogState extends State<_EmailChangeDialog> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  late final EmailChangeViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = EmailChangeViewModel(context.read<AuthRepository>())
      ..addListener(_changed);
  }

  void _changed() => setState(() {});

  @override
  void dispose() {
    _model.dispose();
    _email.dispose();
    _password.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _start() => _model.start(
    _email.text,
    _password.text,
    Localizations.localeOf(context).languageCode == 'uk' ? 'uk' : 'en',
  );

  Future<void> _confirm() async {
    if (await _model.confirm(_code.text) && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _cancel() async {
    if (await _model.cancel() && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(text.authChangeEmail),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_model.sent) ...[
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: text.authNewEmail),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: text.authCurrentPassword),
            ),
          ] else ...[
            Text(text.authEmailChangeCode),
            TextField(
              controller: _code,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: text.authVerificationCode),
            ),
          ],
          if (_model.failure case final failure?)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(text.failureMessage(failure)),
            ),
        ],
      ),
      actions: [
        DialogActionRow(
          cancel: text.cancel,
          confirm: _model.sent
              ? text.authEmailChangeConfirm
              : text.authEmailChangeStart,
          onCancel: _model.busy ? null : _cancel,
          onConfirm: _model.busy ? null : (_model.sent ? _confirm : _start),
          secondary: !_model.sent
              ? null
              : TextButton(
                  onPressed: _model.busy ? null : _model.resend,
                  child: Text(text.authEmailChangeResend),
                ),
        ),
      ],
    );
  }
}

class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({super.key});
  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  final _email = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<InvitationsViewModel>();
    final text = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(text.authInvitations)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (model.busy) const LinearProgressIndicator(),
              if (model.error case final failure?) ...[
                Semantics(
                  liveRegion: true,
                  child: Text(text.failureMessage(failure)),
                ),
                TextButton(
                  onPressed: model.busy ? null : model.load,
                  child: Text(text.authRetry),
                ),
              ],
              if (model.error == null) ...[
                Form(
                  key: _form,
                  child: TextFormField(
                    key: const ValueKey('invite-email'),
                    controller: _email,
                    enabled: !model.busy,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(labelText: text.email),
                    validator: (value) =>
                        RegExp(
                          r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                        ).hasMatch(value?.trim() ?? '')
                        ? null
                        : text.emailInvalid,
                  ),
                ),
                FilledButton(
                  onPressed: model.busy
                      ? null
                      : () async {
                          if (_form.currentState!.validate()) {
                            await model.create(_email.text);
                            if (mounted && model.error == null) _email.clear();
                          }
                        },
                  child: Text(text.authInvite),
                ),
                if (model.created)
                  Semantics(
                    liveRegion: true,
                    child: Text(text.authInviteCreated),
                  ),
                const SizedBox(height: 24),
                if (model.invitations.isEmpty && !model.busy)
                  Text(text.authNoInvitations),
                for (final invitation in model.invitations)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(invitation.email),
                          Text(
                            invitation.acceptedAt != null
                                ? text.authAccepted
                                : invitation.revokedAt != null
                                ? text.authRevoked
                                : !invitation.expiresAt.isAfter(DateTime.now())
                                ? text.authExpired
                                : '${text.authExpires}: ${MaterialLocalizations.of(context).formatMediumDate(invitation.expiresAt.toLocal())}',
                          ),
                          if (invitation.acceptedAt == null &&
                              invitation.revokedAt == null &&
                              invitation.expiresAt.isAfter(DateTime.now()))
                            TextButton(
                              onPressed: model.busy
                                  ? null
                                  : () => model.revoke(invitation.id),
                              child: Text(text.authRevoke),
                            ),
                        ],
                      ),
                    ),
                  ),
                Wrap(
                  spacing: 12,
                  children: [
                    TextButton(
                      onPressed: model.busy || model.offset == 0
                          ? null
                          : () => model.page(-1),
                      child: Text(text.authPreviousPage),
                    ),
                    TextButton(
                      onPressed: model.busy || model.invitations.length < 20
                          ? null
                          : () => model.page(1),
                      child: Text(text.authNextPage),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
