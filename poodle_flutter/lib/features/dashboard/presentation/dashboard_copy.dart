import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/l10n/app_localizations.dart';

String courseTitle(AppLocalizations text, String id) => switch (id) {
  '019a0acf-0000-7000-8000-000000000001' => text.dashboardCourseDesign,
  '019a0acf-0000-7000-8000-000000000002' => text.dashboardCourseWriting,
  _ => id,
};

String courseCategory(AppLocalizations text, String id) => switch (id) {
  '019a0acf-0000-7000-8000-000000000001' => text.dashboardCategoryArts,
  '019a0acf-0000-7000-8000-000000000002' => text.dashboardCategoryLanguage,
  _ => '',
};

String taskTitle(AppLocalizations text, String id) => switch (id) {
  'task-reading' => text.dashboardTaskReading,
  'task-reflection' => text.dashboardTaskReflection,
  _ => id,
};

String announcementTitle(AppLocalizations text, String id) => switch (id) {
  'announcement-week' => text.dashboardAnnouncementWeek,
  'announcement-welcome' => text.dashboardAnnouncementWelcome,
  _ => id,
};

String announcementExcerpt(AppLocalizations text, String id) => switch (id) {
  'announcement-week' => text.dashboardAnnouncementWeekExcerpt,
  'announcement-welcome' => text.dashboardAnnouncementWelcomeExcerpt,
  _ => '',
};

String announcementBody(AppLocalizations text, String id) => switch (id) {
  'announcement-week' => text.dashboardAnnouncementWeekBody,
  'announcement-welcome' => text.dashboardAnnouncementWelcomeBody,
  _ => '',
};

String localDate(BuildContext context, DateTime utc) {
  final locale = Localizations.localeOf(context).languageCode;
  return DateFormat.yMMMd(locale).add_jm().format(utc.toLocal());
}
