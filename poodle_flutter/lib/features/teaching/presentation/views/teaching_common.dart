import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/teaching_repository.dart';
import '../../../../app/l10n/app_localizations.dart';
export '../../../../app/l10n/app_localizations.dart';
export '../../../../data/repositories/teaching_repository.dart';
export '../view_models/teaching_view_model.dart';

AppLocalizations teachingText(BuildContext context) =>
    AppLocalizations.of(context);
String teachingError(BuildContext context, String code) {
  final t = teachingText(context);
  return switch (code) {
    'invalid_settings' ||
    'invalid_questions' ||
    'invalid_answers' ||
    'invalid_submission' => t.teachingInvalidSettingsOrQuestionsCheckTheForm,
    'conflict' => t.teachingChangedElsewhereRefreshBeforeSaving,
    'submission_locked' => t.teachingSubmissionsAreClosedOrUnderReview,
    'test_open' => t.teachingCloseTheTestBeforeReleasingResults,
    'attempt_limit' => t.teachingAttemptLimitReached,
    'invalid_upload' || 'upload_limit' => t.teachingUsePdfDocxJpegOrPngUpToMb,
    _ => t.teachingUnavailableCheckYourConnectionAndAccess,
  };
}

Widget teachingNotice(BuildContext context, String? error) => error == null
    ? const SizedBox.shrink()
    : Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          teachingError(context, error),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
String teachingDate(BuildContext context, DateTime value) =>
    '${MaterialLocalizations.of(context).formatMediumDate(value.toLocal())} ${TimeOfDay.fromDateTime(value.toLocal()).format(context)}';
Future<DateTime?> teachingPickDate(
  BuildContext context,
  DateTime? value,
) async {
  final now = DateTime.now();
  final date = await showDatePicker(
    context: context,
    initialDate: value?.toLocal() ?? now,
    firstDate: DateTime(now.year - 2),
    lastDate: DateTime(now.year + 5),
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: value == null
        ? TimeOfDay.now()
        : TimeOfDay.fromDateTime(value.toLocal()),
  );
  return time == null
      ? null
      : DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        ).toUtc();
}

TeachingRepository? teachingRepositoryOf(BuildContext context) {
  try {
    return context.read<TeachingRepository?>();
  } on ProviderNotFoundException {
    return null;
  }
}
