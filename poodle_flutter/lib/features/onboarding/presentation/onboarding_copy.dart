import '../../../app/l10n/app_localizations.dart';
import '../onboarding_story.dart';

extension OnboardingCopy on OnboardingStory {
  String title(AppLocalizations l) => switch (this) {
    OnboardingStory.courses => l.onboardingCoursesTitle,
    OnboardingStory.materials => l.onboardingMaterialsTitle,
    OnboardingStory.notebook => l.onboardingNotebookTitle,
    OnboardingStory.sources => l.onboardingSourcesTitle,
    OnboardingStory.planning => l.onboardingPlanningTitle,
    // OnboardingStory.assignments => l.onboardingAssignmentsTitle,
    // OnboardingStory.connected => l.onboardingConnectedTitle,
    // OnboardingStory.teaching => l.onboardingTeachingTitle,
    // OnboardingStory.offline => l.onboardingOfflineTitle,
    // OnboardingStory.personal => l.onboardingPersonalTitle,
  };
  String body(AppLocalizations l) => switch (this) {
    OnboardingStory.courses => l.onboardingCoursesBody,
    OnboardingStory.materials => l.onboardingMaterialsBody,
    OnboardingStory.notebook => l.onboardingNotebookBody,
    OnboardingStory.sources => l.onboardingSourcesBody,
    OnboardingStory.planning => l.onboardingPlanningBody,
    // OnboardingStory.assignments => l.onboardingAssignmentsBody,
    // OnboardingStory.connected => l.onboardingConnectedBody,
    // OnboardingStory.teaching => l.onboardingTeachingBody,
    // OnboardingStory.offline => l.onboardingOfflineBody,
    // OnboardingStory.personal => l.onboardingPersonalBody,
  };
  String card(AppLocalizations l) => switch (this) {
    OnboardingStory.courses => l.onboardingCoursesCard,
    OnboardingStory.materials => l.onboardingMaterialsCard,
    OnboardingStory.notebook => l.onboardingNotebookCard,
    OnboardingStory.sources => l.onboardingSourcesCard,
    OnboardingStory.planning => l.onboardingPlanningCard,
    // OnboardingStory.assignments => l.onboardingAssignmentsCard,
    // OnboardingStory.connected => l.onboardingConnectedCard,
    // OnboardingStory.teaching => l.onboardingTeachingCard,
    // OnboardingStory.offline => l.onboardingOfflineCard,
    // OnboardingStory.personal => l.onboardingPersonalCard,
  };
  String tag(AppLocalizations l) => switch (this) {
    OnboardingStory.courses => l.onboardingCoursesTag,
    OnboardingStory.materials => l.onboardingMaterialsTag,
    OnboardingStory.notebook => l.onboardingNotebookTag,
    OnboardingStory.sources => l.onboardingSourcesTag,
    OnboardingStory.planning => l.onboardingPlanningTag,
    // OnboardingStory.assignments => l.onboardingAssignmentsTag,
    // OnboardingStory.connected => l.onboardingConnectedTag,
    // OnboardingStory.teaching => l.onboardingTeachingTag,
    // OnboardingStory.offline => l.onboardingOfflineTag,
    // OnboardingStory.personal => l.onboardingPersonalTag,
  };
}
