import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../view_models/administrator_request_view_model.dart';
import '../widgets/institution_widgets.dart';

class AdministratorRequestScreen extends StatefulWidget {
  const AdministratorRequestScreen({super.key});
  @override
  State<AdministratorRequestScreen> createState() =>
      _AdministratorRequestScreenState();
}

class _AdministratorRequestScreenState
    extends State<AdministratorRequestScreen> {
  final _form = GlobalKey<FormState>();
  final _fields = {
    for (final key in [
      'name',
      'email',
      'university',
      'position',
      'note',
      'code',
    ])
      key: TextEditingController(),
  };
  @override
  void dispose() {
    for (final c in _fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AdministratorRequestViewModel>();
    final text = AppLocalizations.of(context);
    final labels = {
      'name': text.institutionName,
      'email': text.email,
      'university': text.institutionUniversity,
      'position': text.institutionPosition,
      'note': text.institutionNote,
    };
    return InstitutionPage(
      title: text.institutionRequestTitle,
      children: [
        Text(text.institutionRequestIntro),
        if (model.busy) const LinearProgressIndicator(),
        if (model.error case final error?) InstitutionError(code: error),
        if (model.submitted)
          Semantics(
            liveRegion: true,
            child: Text(text.institutionAwaitingReview),
          )
        else if (model.requestId != null) ...[
          Text(text.authCodeNotice),
          TextField(
            key: const ValueKey('request-code'),
            controller: _fields['code'],
            enabled: !model.busy,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: text.authVerificationCode),
          ),
          FilledButton(
            onPressed: model.busy
                ? null
                : () => model.verify(_fields['code']!.text),
            child: Text(text.institutionVerify),
          ),
          TextButton(
            onPressed: model.busy
                ? null
                : () async {
                    await model.resend();
                    if (mounted && model.error == null) {
                      _fields['code']!.clear();
                    }
                  },
            child: Text(text.authStartOver),
          ),
          TextButton(
            onPressed: model.busy
                ? null
                : () {
                    _fields['code']!.clear();
                    model.changeEmail();
                  },
            child: Text(text.authChangeEmail),
          ),
        ] else
          Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final entry in labels.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      key: ValueKey('request-${entry.key}'),
                      controller: _fields[entry.key],
                      enabled: !model.busy,
                      keyboardType: entry.key == 'email'
                          ? TextInputType.emailAddress
                          : TextInputType.text,
                      maxLength: entry.key == 'note'
                          ? 2000
                          : entry.key == 'university'
                          ? 200
                          : 120,
                      maxLines: entry.key == 'note' ? 3 : 1,
                      decoration: InputDecoration(labelText: entry.value),
                      validator: (value) {
                        if (entry.key == 'note') return null;
                        if (value == null || value.trim().isEmpty) {
                          return text.institutionRequired;
                        }
                        if (entry.key == 'email' &&
                            !RegExp(
                              r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                            ).hasMatch(value.trim())) {
                          return text.emailInvalid;
                        }
                        return null;
                      },
                    ),
                  ),
                FilledButton(
                  onPressed: model.busy
                      ? null
                      : () {
                          if (_form.currentState!.validate()) {
                            model.send({
                              for (final key in labels.keys)
                                key: _fields[key]!.text.trim(),
                              'locale': Localizations.localeOf(
                                context,
                              ).languageCode,
                            });
                          }
                        },
                  child: Text(text.institutionSendCode),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
