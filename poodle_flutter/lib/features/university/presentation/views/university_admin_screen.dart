import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../view_models/university_admin_view_model.dart';
import '../widgets/institution_widgets.dart';

class UniversityAdminScreen extends StatefulWidget {
  const UniversityAdminScreen({super.key});
  @override
  State<UniversityAdminScreen> createState() => _UniversityAdminScreenState();
}

class _UniversityAdminScreenState extends State<UniversityAdminScreen> {
  final _email = TextEditingController();
  String _purpose = 'teacherCandidate';
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UniversityAdminViewModel>();
    final text = AppLocalizations.of(context);
    return InstitutionPage(
      title: text.institutionAdmin,
      children: [
        if (model.busy) const LinearProgressIndicator(),
        if (model.error case final code?) InstitutionError(code: code),
        TextButton(
          onPressed: model.busy ? null : model.load,
          child: Text(text.institutionRefresh),
        ),
        TextField(
          key: const ValueKey('university-invite-email'),
          controller: _email,
          enabled: !model.busy,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: text.email),
        ),
        DropdownButtonFormField<String>(
          initialValue: _purpose,
          items: [
            DropdownMenuItem(
              value: 'teacherCandidate',
              child: Text(text.institutionTeacher),
            ),
            DropdownMenuItem(
              value: 'universityAdmin',
              child: Text(text.institutionAdministrator),
            ),
          ],
          onChanged: model.busy
              ? null
              : (value) => setState(() => _purpose = value!),
        ),
        FilledButton(
          onPressed: model.busy
              ? null
              : () => model.invite(_email.text, _purpose),
          child: Text(text.authInvite),
        ),
        if (model.sent)
          Semantics(liveRegion: true, child: Text(text.institutionInviteSent)),
        Text(
          text.institutionMembers,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        for (final member in model.members)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(member.email),
                  if (member.teacher) Text(text.institutionTeacher),
                  if (member.administrator) Text(text.institutionAdministrator),
                  TextButton(
                    onPressed: model.busy
                        ? null
                        : () => model.administrator(
                            member.id,
                            !member.administrator,
                          ),
                    child: Text(
                      member.administrator
                          ? text.institutionRemoveAdmin
                          : text.institutionGrantAdmin,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (model.members.isEmpty && !model.busy) Text(text.institutionEmpty),
        Wrap(
          children: [
            TextButton(
              onPressed: model.busy || model.memberOffset == 0
                  ? null
                  : () => model.pageMembers(-1),
              child: Text(text.authPreviousPage),
            ),
            TextButton(
              onPressed: model.busy || model.members.length < 50
                  ? null
                  : () => model.pageMembers(1),
              child: Text(text.authNextPage),
            ),
          ],
        ),
        Text(
          text.authInvitations,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        for (final invitation in model.invitations)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(invitation.email),
                  Text(
                    invitation.purpose == 'universityAdmin'
                        ? text.institutionAdministrator
                        : invitation.purpose == 'student'
                        ? text.institutionStudent
                        : text.institutionTeacher,
                  ),
                  Text(
                    invitation.accepted
                        ? text.authAccepted
                        : invitation.revoked
                        ? text.authRevoked
                        : !invitation.expiresAt.isAfter(DateTime.now())
                        ? text.authExpired
                        : '${text.authExpires}: ${MaterialLocalizations.of(context).formatMediumDate(invitation.expiresAt.toLocal())}',
                  ),
                  if (!invitation.accepted &&
                      !invitation.revoked &&
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
          children: [
            TextButton(
              onPressed: model.busy || model.invitationOffset == 0
                  ? null
                  : () => model.pageInvitations(-1),
              child: Text(text.authPreviousPage),
            ),
            TextButton(
              onPressed: model.busy || model.invitations.length < 20
                  ? null
                  : () => model.pageInvitations(1),
              child: Text(text.authNextPage),
            ),
          ],
        ),
      ],
    );
  }
}
