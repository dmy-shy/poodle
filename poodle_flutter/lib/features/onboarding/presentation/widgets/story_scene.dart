import 'package:flutter/material.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../onboarding_story.dart';

class StoryScene extends StatelessWidget {
  const StoryScene({super.key, required this.story});
  final OnboardingStory story;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return switch (story) {
      OnboardingStory.planning => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              7,
              (i) => Container(
                width: 27,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == 3 ? colors.primary : colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  '${i + 12}',
                  style: TextStyle(
                    fontSize: 11,
                    color: i == 3 ? colors.onPrimary : colors.onSurface,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _row(context, Icons.event_note, l.onboardingSampleTask),
        ],
      ),
      OnboardingStory.notebook => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(context, Icons.lock_outline, l.onboardingPrivate),
          const SizedBox(height: 8),
          _line(context, 1),
          const SizedBox(height: 6),
          _line(context, .78),
          const SizedBox(height: 10),
          Text(
            l.onboardingCitation,
            style: TextStyle(
              color: colors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(l.onboardingPractice, style: const TextStyle(fontSize: 11)),
        ],
      ),
      OnboardingStory.sources => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _row(context, Icons.description_outlined, l.onboardingDocuments),
          _row(context, Icons.link, l.onboardingLinks),
          _row(context, Icons.graphic_eq, l.onboardingTranscripts),
        ],
      ),
      OnboardingStory.courses => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(context, Icons.bookmark_outline, l.onboardingSampleCourse),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: .65,
              minHeight: 7,
              color: colors.primary,
              backgroundColor: colors.surfaceContainer,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '65%',
            style: TextStyle(
              fontSize: 12,
              color: colors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      // OnboardingStory.assignments => Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     _row(context, Icons.check_circle_outline, l.onboardingSampleTask),
      //     _row(context, Icons.history, '01 → 02'),
      //     _row(context, Icons.chat_bubble_outline, l.onboardingSampleFeedback),
      //   ],
      // ),
      // OnboardingStory.connected => Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     _row(context, Icons.campaign_outlined, l.onboardingToday),
      //     _row(context, Icons.chat_bubble_outline, l.onboardingMessage),
      //     _row(context, Icons.notifications_none, l.onboardingSampleTask),
      //   ],
      // ),
      // OnboardingStory.teaching => Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     _row(context, Icons.person_add_alt, l.onboardingInvitation),
      //     _row(context, Icons.publish_outlined, l.onboardingSampleLesson),
      //     _row(context, Icons.fact_check_outlined, l.onboardingSampleFeedback),
      //   ],
      // ),
      // OnboardingStory.offline => Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     _row(context, Icons.download_done, l.onboardingSampleLesson),
      //     _row(context, Icons.wifi_off_outlined, l.onboardingReadOnly),
      //     _line(context, .85),
      //   ],
      // ),
      // OnboardingStory.personal => Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     _row(context, Icons.person_outline, l.onboardingSampleCourse),
      //     _row(context, Icons.text_fields, l.onboardingPreferences),
      //     _row(context, Icons.favorite_outline, l.onboardingSampleLesson),
      //   ],
      // ),
      OnboardingStory.materials => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _row(context, Icons.folder_open_outlined, l.onboardingSampleCourse),
          _row(
            context,
            Icons.picture_as_pdf_outlined,
            l.onboardingSampleLesson,
          ),
          _line(context, .8),
        ],
      ),
    };
  }

  Widget _row(BuildContext context, IconData icon, String label) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          label,
          maxLines: 2,
          style: const TextStyle(fontSize: 12, height: 1.3),
        ),
      ),
    ],
  );

  Widget _line(BuildContext context, double width) => FractionallySizedBox(
    widthFactor: width,
    child: Container(
      height: 7,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}
