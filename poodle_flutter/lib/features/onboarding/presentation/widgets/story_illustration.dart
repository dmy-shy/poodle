import 'package:flutter/material.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../ui/theme/poodle_theme.dart';
import '../../onboarding_story.dart';
import '../onboarding_copy.dart';
import 'story_scene.dart';

/// Local, fictional feature scenes. Meaningful copy is repeated outside this art.
class StoryIllustration extends StatelessWidget {
  const StoryIllustration({super.key, required this.story});
  final OnboardingStory story;

  IconData get icon => switch (story) {
    OnboardingStory.courses => Icons.school_outlined,
    OnboardingStory.materials => Icons.auto_stories_outlined,
    OnboardingStory.notebook => Icons.auto_awesome_outlined,
    OnboardingStory.sources => Icons.library_add_outlined,
    OnboardingStory.planning => Icons.calendar_month_outlined,
    // OnboardingStory.assignments => Icons.task_alt,
    // OnboardingStory.connected => Icons.forum_outlined,
    // OnboardingStory.teaching => Icons.groups_outlined,
    // OnboardingStory.offline => Icons.download_done_rounded,
    // OnboardingStory.personal => Icons.tune_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      // Illustration text is decorative; essential story copy scales separately.
      child: MediaQuery.withNoTextScaling(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 330,
            height: 310,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 3,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: PoodleTheme.terracotta.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 14,
                  child: Icon(
                    Icons.add_rounded,
                    size: 26,
                    color: PoodleTheme.terracotta,
                  ),
                ),
                Positioned(
                  bottom: 32,
                  right: 8,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 30,
                    color: colors.secondary,
                  ),
                ),
                Positioned(
                  top: 43,
                  left: 32,
                  right: 32,
                  child: Transform.rotate(
                    angle: -.035,
                    child: Container(
                      height: 210,
                      decoration: BoxDecoration(
                        color: PoodleTheme.terracotta.withValues(alpha: .18),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 33,
                  left: 25,
                  right: 25,
                  child: Container(
                    height: 212,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: colors.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: colors.secondary.withValues(alpha: .07),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(icon, color: colors.primary, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                story.card(l),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(child: StoryScene(story: story)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 32,
                  right: 32,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colors.secondary,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            story == OnboardingStory.notebook
                                ? Icons.lock_outline
                                : Icons.check_circle_outline,
                            size: 16,
                            color: colors.onSecondary,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              story.tag(l),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors.onSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 3,
                  top: 4,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8E6DE),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset('assets/images/mascot.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
