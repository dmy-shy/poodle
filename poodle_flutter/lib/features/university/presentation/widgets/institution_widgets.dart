import 'package:flutter/material.dart';
import '../../../../app/l10n/app_localizations.dart';

class InstitutionPage extends StatelessWidget {
  const InstitutionPage({
    super.key,
    required this.title,
    required this.children,
  });
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              for (final child in children)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: child,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class InstitutionError extends StatelessWidget {
  const InstitutionError({super.key, required this.code});
  final String code;
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final message = switch (code) {
      'lastAdministrator' => text.institutionLastAdmin,
      'universityConflict' ||
      'invitationConflict' ||
      'accountAlreadyExists' => text.institutionConflict,
      'invalidCode' => text.institutionInvalidCode,
      'invalid_input' || 'invalidCourseTitle' => text.institutionRequired,
      'forbidden' => text.institutionForbidden,
      _ => text.authUnavailable,
    };
    return Semantics(
      liveRegion: true,
      child: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
