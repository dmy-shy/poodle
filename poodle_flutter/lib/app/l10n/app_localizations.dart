import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
  ];

  /// No description provided for @courseFavoriteStatus.
  ///
  /// In en, this message translates to:
  /// **'Favorite course'**
  String get courseFavoriteStatus;

  /// No description provided for @splashQuoteShevchenko.
  ///
  /// In en, this message translates to:
  /// **'Learn from others, but do not forsake your own.'**
  String get splashQuoteShevchenko;

  /// No description provided for @splashQuoteForestSong.
  ///
  /// In en, this message translates to:
  /// **'No, I am alive! I will live forever!'**
  String get splashQuoteForestSong;

  /// No description provided for @splashQuoteHope.
  ///
  /// In en, this message translates to:
  /// **'Keep hoping, even without hope.'**
  String get splashQuoteHope;

  /// No description provided for @splashQuoteStruggle.
  ///
  /// In en, this message translates to:
  /// **'Only by struggling do we live…'**
  String get splashQuoteStruggle;

  /// No description provided for @splashQuoteAwaken.
  ///
  /// In en, this message translates to:
  /// **'Rise, wake up, come alive!'**
  String get splashQuoteAwaken;

  /// No description provided for @splashAuthorShevchenko.
  ///
  /// In en, this message translates to:
  /// **'Taras Shevchenko'**
  String get splashAuthorShevchenko;

  /// No description provided for @splashAuthorUkrainka.
  ///
  /// In en, this message translates to:
  /// **'Lesia Ukrainka'**
  String get splashAuthorUkrainka;

  /// No description provided for @splashAuthorFranko.
  ///
  /// In en, this message translates to:
  /// **'Ivan Franko'**
  String get splashAuthorFranko;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A little curiosity goes a long way.\nSign in to keep learning.'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'yourname@lntu.edu.ua'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @googleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get googleSignIn;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @invitationPrompt.
  ///
  /// In en, this message translates to:
  /// **'New to Poodle?'**
  String get invitationPrompt;

  /// No description provided for @invitationAction.
  ///
  /// In en, this message translates to:
  /// **'Join by invitation'**
  String get invitationAction;

  /// No description provided for @invitationTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning starts with an invitation'**
  String get invitationTitle;

  /// No description provided for @invitationBody.
  ///
  /// In en, this message translates to:
  /// **'Poodle is invitation-only. Ask your teacher or administrator for an invitation to join your learning community.'**
  String get invitationBody;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address.'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get passwordRequired;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'That email or password isn\'t correct. Try again.'**
  String get invalidCredentials;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect. Please try again.'**
  String get networkError;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get resetTitle;

  /// No description provided for @resetBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll help you get back to learning.'**
  String get resetBody;

  /// No description provided for @sendReset.
  ///
  /// In en, this message translates to:
  /// **'Send reset instructions'**
  String get sendReset;

  /// No description provided for @resetConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset request'**
  String get resetConfirmationTitle;

  /// No description provided for @resetConfirmationBody.
  ///
  /// In en, this message translates to:
  /// **'No email was sent.'**
  String get resetConfirmationBody;

  /// No description provided for @demoSession.
  ///
  /// In en, this message translates to:
  /// **'Demo session'**
  String get demoSession;

  /// No description provided for @demoBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set to explore. This preview uses simulated sign-in; your learning space is coming next.'**
  String get demoBody;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @previewLabel.
  ///
  /// In en, this message translates to:
  /// **'UI preview · simulated sign-in'**
  String get previewLabel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @mascotLabel.
  ///
  /// In en, this message translates to:
  /// **'Poodle mascot'**
  String get mascotLabel;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @onboardingPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous story'**
  String get onboardingPrevious;

  /// No description provided for @onboardingPause.
  ///
  /// In en, this message translates to:
  /// **'Pause stories'**
  String get onboardingPause;

  /// No description provided for @onboardingPlay.
  ///
  /// In en, this message translates to:
  /// **'Play stories'**
  String get onboardingPlay;

  /// No description provided for @onboardingManual.
  ///
  /// In en, this message translates to:
  /// **'Manual playback'**
  String get onboardingManual;

  /// No description provided for @onboardingPreview.
  ///
  /// In en, this message translates to:
  /// **'Feature preview'**
  String get onboardingPreview;

  /// No description provided for @onboardingPosition.
  ///
  /// In en, this message translates to:
  /// **'Story {current} of {total}'**
  String onboardingPosition(int current, int total);

  /// No description provided for @onboardingPrivate.
  ///
  /// In en, this message translates to:
  /// **'Only yours'**
  String get onboardingPrivate;

  /// No description provided for @onboardingCitation.
  ///
  /// In en, this message translates to:
  /// **'Source · page 12'**
  String get onboardingCitation;

  /// No description provided for @onboardingReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Offline reading'**
  String get onboardingReadOnly;

  /// No description provided for @onboardingPractice.
  ///
  /// In en, this message translates to:
  /// **'Ungraded practice'**
  String get onboardingPractice;

  /// No description provided for @onboardingSampleCourse.
  ///
  /// In en, this message translates to:
  /// **'Creative thinking'**
  String get onboardingSampleCourse;

  /// No description provided for @onboardingSampleLesson.
  ///
  /// In en, this message translates to:
  /// **'A new perspective'**
  String get onboardingSampleLesson;

  /// No description provided for @onboardingSampleTask.
  ///
  /// In en, this message translates to:
  /// **'Explore the next chapter'**
  String get onboardingSampleTask;

  /// No description provided for @onboardingSampleFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback, when you\'re ready'**
  String get onboardingSampleFeedback;

  /// No description provided for @onboardingDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents & images'**
  String get onboardingDocuments;

  /// No description provided for @onboardingLinks.
  ///
  /// In en, this message translates to:
  /// **'Public links'**
  String get onboardingLinks;

  /// No description provided for @onboardingTranscripts.
  ///
  /// In en, this message translates to:
  /// **'Recordings & transcripts'**
  String get onboardingTranscripts;

  /// No description provided for @onboardingToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get onboardingToday;

  /// No description provided for @onboardingMessage.
  ///
  /// In en, this message translates to:
  /// **'A question worth asking'**
  String get onboardingMessage;

  /// No description provided for @onboardingInvitation.
  ///
  /// In en, this message translates to:
  /// **'By invitation'**
  String get onboardingInvitation;

  /// No description provided for @onboardingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Reading & reminders'**
  String get onboardingPreferences;

  /// No description provided for @onboardingCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your learning, in one place.'**
  String get onboardingCoursesTitle;

  /// No description provided for @onboardingCoursesBody.
  ///
  /// In en, this message translates to:
  /// **'Find your courses, pick up where you left off, and see your progress.'**
  String get onboardingCoursesBody;

  /// No description provided for @onboardingCoursesCard.
  ///
  /// In en, this message translates to:
  /// **'Your courses'**
  String get onboardingCoursesCard;

  /// No description provided for @onboardingCoursesTag.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get onboardingCoursesTag;

  /// No description provided for @onboardingMaterialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Find what you need to learn.'**
  String get onboardingMaterialsTitle;

  /// No description provided for @onboardingMaterialsBody.
  ///
  /// In en, this message translates to:
  /// **'Move through modules, read materials, and return to any activity.'**
  String get onboardingMaterialsBody;

  /// No description provided for @onboardingMaterialsCard.
  ///
  /// In en, this message translates to:
  /// **'Course materials'**
  String get onboardingMaterialsCard;

  /// No description provided for @onboardingMaterialsTag.
  ///
  /// In en, this message translates to:
  /// **'Module 01'**
  String get onboardingMaterialsTag;

  /// No description provided for @onboardingNotebookTitle.
  ///
  /// In en, this message translates to:
  /// **'Study with answers you can check.'**
  String get onboardingNotebookTitle;

  /// No description provided for @onboardingNotebookBody.
  ///
  /// In en, this message translates to:
  /// **'Ask about your sources, explore cited answers, and practise with summaries, flashcards, and quizzes.'**
  String get onboardingNotebookBody;

  /// No description provided for @onboardingNotebookCard.
  ///
  /// In en, this message translates to:
  /// **'Your private notebook'**
  String get onboardingNotebookCard;

  /// No description provided for @onboardingNotebookTag.
  ///
  /// In en, this message translates to:
  /// **'Sources, not guesses'**
  String get onboardingNotebookTag;

  /// No description provided for @onboardingSourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Bring your study sources together.'**
  String get onboardingSourcesTitle;

  /// No description provided for @onboardingSourcesBody.
  ///
  /// In en, this message translates to:
  /// **'Add documents, images, public links, or recordings to your private notebook.'**
  String get onboardingSourcesBody;

  /// No description provided for @onboardingSourcesCard.
  ///
  /// In en, this message translates to:
  /// **'Your study collection'**
  String get onboardingSourcesCard;

  /// No description provided for @onboardingSourcesTag.
  ///
  /// In en, this message translates to:
  /// **'Ready to study'**
  String get onboardingSourcesTag;

  /// No description provided for @onboardingPlanningTitle.
  ///
  /// In en, this message translates to:
  /// **'Know what comes next.'**
  String get onboardingPlanningTitle;

  /// No description provided for @onboardingPlanningBody.
  ///
  /// In en, this message translates to:
  /// **'Keep assignments, lectures, preparation, and exams in view with your calendar and tasks.'**
  String get onboardingPlanningBody;

  /// No description provided for @onboardingPlanningCard.
  ///
  /// In en, this message translates to:
  /// **'A little more prepared'**
  String get onboardingPlanningCard;

  /// No description provided for @onboardingPlanningTag.
  ///
  /// In en, this message translates to:
  /// **'Your next steps'**
  String get onboardingPlanningTag;

  /// No description provided for @onboardingAssignmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit, improve, track your results.'**
  String get onboardingAssignmentsTitle;

  /// No description provided for @onboardingAssignmentsBody.
  ///
  /// In en, this message translates to:
  /// **'Send work before the deadline, review submission versions, and read grades and feedback.'**
  String get onboardingAssignmentsBody;

  /// No description provided for @onboardingAssignmentsCard.
  ///
  /// In en, this message translates to:
  /// **'Every step counts'**
  String get onboardingAssignmentsCard;

  /// No description provided for @onboardingAssignmentsTag.
  ///
  /// In en, this message translates to:
  /// **'Work, then feedback'**
  String get onboardingAssignmentsTag;

  /// No description provided for @onboardingConnectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay connected to your course.'**
  String get onboardingConnectedTitle;

  /// No description provided for @onboardingConnectedBody.
  ///
  /// In en, this message translates to:
  /// **'Read announcements, message classmates or teachers privately, and keep track of updates.'**
  String get onboardingConnectedBody;

  /// No description provided for @onboardingConnectedCard.
  ///
  /// In en, this message translates to:
  /// **'Learning, together'**
  String get onboardingConnectedCard;

  /// No description provided for @onboardingConnectedTag.
  ///
  /// In en, this message translates to:
  /// **'One-to-one conversations'**
  String get onboardingConnectedTag;

  /// No description provided for @onboardingTeachingTitle.
  ///
  /// In en, this message translates to:
  /// **'A shared space for teaching.'**
  String get onboardingTeachingTitle;

  /// No description provided for @onboardingTeachingBody.
  ///
  /// In en, this message translates to:
  /// **'Invite students, publish materials and assignments, and follow their work in the gradebook.'**
  String get onboardingTeachingBody;

  /// No description provided for @onboardingTeachingCard.
  ///
  /// In en, this message translates to:
  /// **'Room for great teaching'**
  String get onboardingTeachingCard;

  /// No description provided for @onboardingTeachingTag.
  ///
  /// In en, this message translates to:
  /// **'Invite. Teach. Encourage.'**
  String get onboardingTeachingTag;

  /// No description provided for @onboardingOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep reading when you\'re offline.'**
  String get onboardingOfflineTitle;

  /// No description provided for @onboardingOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'Download materials and revisit saved study content wherever you are.'**
  String get onboardingOfflineBody;

  /// No description provided for @onboardingOfflineCard.
  ///
  /// In en, this message translates to:
  /// **'A little learning, anywhere'**
  String get onboardingOfflineCard;

  /// No description provided for @onboardingOfflineTag.
  ///
  /// In en, this message translates to:
  /// **'Saved for later'**
  String get onboardingOfflineTag;

  /// No description provided for @onboardingPersonalTitle.
  ///
  /// In en, this message translates to:
  /// **'Make Poodle work for you.'**
  String get onboardingPersonalTitle;

  /// No description provided for @onboardingPersonalBody.
  ///
  /// In en, this message translates to:
  /// **'Manage your profile, files, reading preferences, notifications, and storage, with help close by.'**
  String get onboardingPersonalBody;

  /// No description provided for @onboardingPersonalCard.
  ///
  /// In en, this message translates to:
  /// **'Your space to grow'**
  String get onboardingPersonalCard;

  /// No description provided for @onboardingPersonalTag.
  ///
  /// In en, this message translates to:
  /// **'Make yourself at home'**
  String get onboardingPersonalTag;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @coursesTab.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get coursesTab;

  /// No description provided for @myCoursesTab.
  ///
  /// In en, this message translates to:
  /// **'My courses'**
  String get myCoursesTab;

  /// No description provided for @searchTab.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTab;

  /// No description provided for @searchPreview.
  ///
  /// In en, this message translates to:
  /// **'Search preview'**
  String get searchPreview;

  /// No description provided for @messagesTab.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTab;

  /// No description provided for @compactMessagesTab.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get compactMessagesTab;

  /// No description provided for @notificationsTab.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTab;

  /// No description provided for @moreTab.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTab;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsSpaceUsage.
  ///
  /// In en, this message translates to:
  /// **'Space usage'**
  String get settingsSpaceUsage;

  /// No description provided for @settingsSynchronisation.
  ///
  /// In en, this message translates to:
  /// **'Synchronisation'**
  String get settingsSynchronisation;

  /// No description provided for @settingsSharedFiles.
  ///
  /// In en, this message translates to:
  /// **'Shared files'**
  String get settingsSharedFiles;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsSystem;

  /// No description provided for @settingsTextSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get settingsTextSize;

  /// No description provided for @settingsStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get settingsStandard;

  /// No description provided for @settingsLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get settingsLarge;

  /// No description provided for @settingsExtraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra large'**
  String get settingsExtraLarge;

  /// No description provided for @settingsSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save settings. Try again.'**
  String get settingsSaveFailed;

  /// No description provided for @settingsSpaceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Storage usage is not available yet.'**
  String get settingsSpaceUnavailable;

  /// No description provided for @settingsSyncUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Synchronisation is not available yet.'**
  String get settingsSyncUnavailable;

  /// No description provided for @settingsFilesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Shared files are not available yet.'**
  String get settingsFilesUnavailable;

  /// No description provided for @settingsAboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Poodle is a learning space for courses, assignments and study tools.'**
  String get settingsAboutDescription;

  /// No description provided for @settingsLicences.
  ///
  /// In en, this message translates to:
  /// **'Open source licences'**
  String get settingsLicences;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility statement'**
  String get settingsAccessibility;

  /// No description provided for @settingsResourceComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This resource is coming soon.'**
  String get settingsResourceComingSoon;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsVersionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Version unavailable'**
  String get settingsVersionUnavailable;

  /// No description provided for @routeNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get routeNotFoundTitle;

  /// No description provided for @routeNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'This page is unavailable. You can return to Home and continue learning.'**
  String get routeNotFoundMessage;

  /// No description provided for @routeErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get routeErrorTitle;

  /// No description provided for @routeErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open this page. Please return to Home and try again.'**
  String get routeErrorMessage;

  /// No description provided for @dashboardWelcome.
  ///
  /// In en, this message translates to:
  /// **'A little progress, every day'**
  String get dashboardWelcome;

  /// No description provided for @dashboardPreviewBody.
  ///
  /// In en, this message translates to:
  /// **'Sample learning data for this UI preview.'**
  String get dashboardPreviewBody;

  /// No description provided for @dashboardUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming tasks'**
  String get dashboardUpcoming;

  /// No description provided for @dashboardRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent courses'**
  String get dashboardRecent;

  /// No description provided for @dashboardAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get dashboardAnnouncements;

  /// No description provided for @dashboardQuickLinks.
  ///
  /// In en, this message translates to:
  /// **'Quick links'**
  String get dashboardQuickLinks;

  /// No description provided for @dashboardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get dashboardViewAll;

  /// No description provided for @dashboardRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get dashboardRetry;

  /// No description provided for @dashboardRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get dashboardRefresh;

  /// No description provided for @dashboardLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your dashboard. Try again.'**
  String get dashboardLoadError;

  /// No description provided for @dashboardOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline · saved data may be out of date.'**
  String get dashboardOffline;

  /// No description provided for @dashboardEmptyTasks.
  ///
  /// In en, this message translates to:
  /// **'No upcoming tasks.'**
  String get dashboardEmptyTasks;

  /// No description provided for @dashboardEmptyCourses.
  ///
  /// In en, this message translates to:
  /// **'No recent courses.'**
  String get dashboardEmptyCourses;

  /// No description provided for @dashboardEmptyAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements.'**
  String get dashboardEmptyAnnouncements;

  /// No description provided for @dashboardDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get dashboardDue;

  /// No description provided for @dashboardOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get dashboardOverdue;

  /// No description provided for @dashboardLastAccess.
  ///
  /// In en, this message translates to:
  /// **'Last opened'**
  String get dashboardLastAccess;

  /// No description provided for @dashboardNoRequired.
  ///
  /// In en, this message translates to:
  /// **'No required activities'**
  String get dashboardNoRequired;

  /// No description provided for @dashboardProgress.
  ///
  /// In en, this message translates to:
  /// **'{value}% complete'**
  String dashboardProgress(int value);

  /// No description provided for @dashboardUpdated.
  ///
  /// In en, this message translates to:
  /// **'Sample updated {date}'**
  String dashboardUpdated(String date);

  /// No description provided for @dashboardCourseDesign.
  ///
  /// In en, this message translates to:
  /// **'Creative thinking'**
  String get dashboardCourseDesign;

  /// No description provided for @dashboardCourseWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing studio'**
  String get dashboardCourseWriting;

  /// No description provided for @dashboardCategoryArts.
  ///
  /// In en, this message translates to:
  /// **'Arts & design'**
  String get dashboardCategoryArts;

  /// No description provided for @dashboardCategoryLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get dashboardCategoryLanguage;

  /// No description provided for @dashboardTaskReading.
  ///
  /// In en, this message translates to:
  /// **'Read the next chapter'**
  String get dashboardTaskReading;

  /// No description provided for @dashboardTaskReflection.
  ///
  /// In en, this message translates to:
  /// **'Submit your reflection'**
  String get dashboardTaskReflection;

  /// No description provided for @dashboardAnnouncementWeek.
  ///
  /// In en, this message translates to:
  /// **'This week\'s materials'**
  String get dashboardAnnouncementWeek;

  /// No description provided for @dashboardAnnouncementWeekExcerpt.
  ///
  /// In en, this message translates to:
  /// **'The new reading list is ready.'**
  String get dashboardAnnouncementWeekExcerpt;

  /// No description provided for @dashboardAnnouncementWeekBody.
  ///
  /// In en, this message translates to:
  /// **'The new reading list is ready. Explore the next topic when you have time.'**
  String get dashboardAnnouncementWeekBody;

  /// No description provided for @dashboardAnnouncementWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to class'**
  String get dashboardAnnouncementWelcome;

  /// No description provided for @dashboardAnnouncementWelcomeExcerpt.
  ///
  /// In en, this message translates to:
  /// **'I\'m glad you\'re here.'**
  String get dashboardAnnouncementWelcomeExcerpt;

  /// No description provided for @dashboardAnnouncementWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'I\'m glad you\'re here. Let\'s make room for curiosity and thoughtful work.'**
  String get dashboardAnnouncementWelcomeBody;

  /// No description provided for @dashboardSampleAuthor.
  ///
  /// In en, this message translates to:
  /// **'Course teacher'**
  String get dashboardSampleAuthor;

  /// No description provided for @dashboardUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get dashboardUnread;

  /// No description provided for @dashboardCoursePreview.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get dashboardCoursePreview;

  /// No description provided for @dashboardMessagesPreview.
  ///
  /// In en, this message translates to:
  /// **'Private messages'**
  String get dashboardMessagesPreview;

  /// No description provided for @dashboardNotificationsPreview.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get dashboardNotificationsPreview;

  /// No description provided for @dashboardFeaturePreview.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming to Poodle. No live learning data is available in this preview.'**
  String get dashboardFeaturePreview;

  /// No description provided for @dashboardCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get dashboardCalendar;

  /// No description provided for @calendarMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calendarMonth;

  /// No description provided for @calendarUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events'**
  String get calendarUpcoming;

  /// No description provided for @calendarLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load next 30 days'**
  String get calendarLoadMore;

  /// No description provided for @calendarOpenNow.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get calendarOpenNow;

  /// No description provided for @calendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarToday;

  /// No description provided for @calendarPreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get calendarPreviousMonth;

  /// No description provided for @calendarNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get calendarNextMonth;

  /// No description provided for @calendarNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events for this date.'**
  String get calendarNoEvents;

  /// No description provided for @calendarOpens.
  ///
  /// In en, this message translates to:
  /// **'Opens'**
  String get calendarOpens;

  /// No description provided for @calendarCloses.
  ///
  /// In en, this message translates to:
  /// **'Closes'**
  String get calendarCloses;

  /// No description provided for @calendarCourse.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get calendarCourse;

  /// No description provided for @calendarType.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get calendarType;

  /// No description provided for @calendarGoToActivity.
  ///
  /// In en, this message translates to:
  /// **'Go to activity'**
  String get calendarGoToActivity;

  /// No description provided for @calendarFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter calendar'**
  String get calendarFilter;

  /// No description provided for @calendarAllFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get calendarAllFilters;

  /// No description provided for @calendarCached.
  ///
  /// In en, this message translates to:
  /// **'Showing saved calendar dates. Refresh to check for changes.'**
  String get calendarCached;

  /// No description provided for @calendarAssignment.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get calendarAssignment;

  /// No description provided for @calendarTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get calendarTest;

  /// No description provided for @studentTasksOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get studentTasksOverdue;

  /// No description provided for @studentTasksUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get studentTasksUpcoming;

  /// No description provided for @studentTasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks with deadlines.'**
  String get studentTasksEmpty;

  /// No description provided for @studentTasksError.
  ///
  /// In en, this message translates to:
  /// **'Could not load tasks.'**
  String get studentTasksError;

  /// No description provided for @studentGradesPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get studentGradesPending;

  /// No description provided for @studentGradesGraded.
  ///
  /// In en, this message translates to:
  /// **'Graded'**
  String get studentGradesGraded;

  /// No description provided for @studentGradesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No grades yet'**
  String get studentGradesEmpty;

  /// No description provided for @dashboardTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get dashboardTasks;

  /// No description provided for @dashboardDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get dashboardDownloads;

  /// No description provided for @dashboardGrades.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get dashboardGrades;

  /// No description provided for @dashboardFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get dashboardFiles;

  /// No description provided for @dashboardProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get dashboardProfile;

  /// No description provided for @dashboardSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get dashboardSettings;

  /// No description provided for @dashboardHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get dashboardHelp;

  /// No description provided for @dashboardBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get dashboardBack;

  /// No description provided for @authStorageError.
  ///
  /// In en, this message translates to:
  /// **'Secure session storage is unavailable. Please retry.'**
  String get authStorageError;

  /// No description provided for @authAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have access to this action.'**
  String get authAccessDenied;

  /// No description provided for @authInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'The code is invalid or expired. Request a new code.'**
  String get authInvalidCode;

  /// No description provided for @authPasswordPolicy.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters without surrounding spaces.'**
  String get authPasswordPolicy;

  /// No description provided for @authUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This action is unavailable. Please try again.'**
  String get authUnavailable;

  /// No description provided for @authRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to restore your session'**
  String get authRecoveryTitle;

  /// No description provided for @authRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get authRetry;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Return to login'**
  String get authBackToLogin;

  /// No description provided for @authLogoutUnconfirmed.
  ///
  /// In en, this message translates to:
  /// **'Signed out on this device. Server revocation could not be confirmed.'**
  String get authLogoutUnconfirmed;

  /// No description provided for @authLogoutStorage.
  ///
  /// In en, this message translates to:
  /// **'Signed out locally. Secure storage cleanup failed; retry sign out before closing the app.'**
  String get authLogoutStorage;

  /// No description provided for @authRequestCode.
  ///
  /// In en, this message translates to:
  /// **'Request verification code'**
  String get authRequestCode;

  /// No description provided for @authCodeNotice.
  ///
  /// In en, this message translates to:
  /// **'If this address is eligible, a verification code has been issued. In local development, find it in the server logs.'**
  String get authCodeNotice;

  /// No description provided for @authVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get authVerificationCode;

  /// No description provided for @authVerifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get authVerifyCode;

  /// No description provided for @authNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPassword;

  /// No description provided for @authPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match.'**
  String get authPasswordMismatch;

  /// No description provided for @authSavePassword.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get authSavePassword;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Accept invitation'**
  String get authCreateAccount;

  /// No description provided for @authResetDone.
  ///
  /// In en, this message translates to:
  /// **'Password updated. Sign in with your new password.'**
  String get authResetDone;

  /// No description provided for @authStartOver.
  ///
  /// In en, this message translates to:
  /// **'Request another code'**
  String get authStartOver;

  /// No description provided for @authAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get authAccount;

  /// No description provided for @authChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get authChangeEmail;

  /// No description provided for @authNewEmail.
  ///
  /// In en, this message translates to:
  /// **'New email'**
  String get authNewEmail;

  /// No description provided for @authCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get authCurrentPassword;

  /// No description provided for @authEmailChangeStart.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get authEmailChangeStart;

  /// No description provided for @authEmailChangeCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your new email.'**
  String get authEmailChangeCode;

  /// No description provided for @authEmailChangePending.
  ///
  /// In en, this message translates to:
  /// **'Verification is pending for {email}.'**
  String authEmailChangePending(String email);

  /// No description provided for @authEmailChangeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm email change'**
  String get authEmailChangeConfirm;

  /// No description provided for @authEmailChangeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel pending change'**
  String get authEmailChangeCancel;

  /// No description provided for @authEmailChangeResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authEmailChangeResend;

  /// No description provided for @authPasswordManagedByGoogle.
  ///
  /// In en, this message translates to:
  /// **'Your password is managed by Google.'**
  String get authPasswordManagedByGoogle;

  /// No description provided for @authAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get authAdmin;

  /// No description provided for @authMember.
  ///
  /// In en, this message translates to:
  /// **'Account active'**
  String get authMember;

  /// No description provided for @authTeacherApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved for future teacher memberships'**
  String get authTeacherApproved;

  /// No description provided for @authInvitations.
  ///
  /// In en, this message translates to:
  /// **'Teacher invitations'**
  String get authInvitations;

  /// No description provided for @authInvite.
  ///
  /// In en, this message translates to:
  /// **'Create invitation'**
  String get authInvite;

  /// No description provided for @authRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get authRevoke;

  /// No description provided for @authAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get authAccepted;

  /// No description provided for @authRevoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get authRevoked;

  /// No description provided for @authExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get authExpired;

  /// No description provided for @authExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get authExpires;

  /// No description provided for @authNoInvitations.
  ///
  /// In en, this message translates to:
  /// **'No invitations on this page.'**
  String get authNoInvitations;

  /// No description provided for @authNextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get authNextPage;

  /// No description provided for @authPreviousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get authPreviousPage;

  /// No description provided for @authInviteCreated.
  ///
  /// In en, this message translates to:
  /// **'Invitation created. Ask the recipient to choose Join by invitation.'**
  String get authInviteCreated;

  /// No description provided for @courseUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This course or activity is unavailable.'**
  String get courseUnavailable;

  /// No description provided for @courseEmpty.
  ///
  /// In en, this message translates to:
  /// **'No courses yet.'**
  String get courseEmpty;

  /// No description provided for @courseContentEmpty.
  ///
  /// In en, this message translates to:
  /// **'No published materials yet.'**
  String get courseContentEmpty;

  /// No description provided for @courseSample.
  ///
  /// In en, this message translates to:
  /// **'Sample course'**
  String get courseSample;

  /// No description provided for @courseDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get courseDraft;

  /// No description provided for @courseTeacherView.
  ///
  /// In en, this message translates to:
  /// **'Teacher view'**
  String get courseTeacherView;

  /// No description provided for @courseSections.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get courseSections;

  /// No description provided for @courseOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Open file'**
  String get courseOpenFile;

  /// No description provided for @courseOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Open website'**
  String get courseOpenLink;

  /// No description provided for @courseExternalLink.
  ///
  /// In en, this message translates to:
  /// **'Opens inside Poodle.'**
  String get courseExternalLink;

  /// No description provided for @courseLinkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to open this link. Refresh the activity and try again.'**
  String get courseLinkError;

  /// No description provided for @browserReload.
  ///
  /// In en, this message translates to:
  /// **'Reload page'**
  String get browserReload;

  /// No description provided for @browserClose.
  ///
  /// In en, this message translates to:
  /// **'Close browser'**
  String get browserClose;

  /// No description provided for @browserDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss message'**
  String get browserDismiss;

  /// No description provided for @browserLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading page'**
  String get browserLoading;

  /// No description provided for @browserLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load this page. Check your connection and retry.'**
  String get browserLoadError;

  /// No description provided for @browserBlocked.
  ///
  /// In en, this message translates to:
  /// **'Only secure HTTPS links can be opened here.'**
  String get browserBlocked;

  /// No description provided for @browserUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Popups and downloads are not supported in this browser.'**
  String get browserUnsupported;

  /// No description provided for @courseDocxNotice.
  ///
  /// In en, this message translates to:
  /// **'Opens in a document app. That app may retain a copy.'**
  String get courseDocxNotice;

  /// No description provided for @courseFileError.
  ///
  /// In en, this message translates to:
  /// **'Unable to open this file or link. Please retry.'**
  String get courseFileError;

  /// No description provided for @courseNoHandler.
  ///
  /// In en, this message translates to:
  /// **'Install an app that can open DOCX documents, then retry.'**
  String get courseNoHandler;

  /// No description provided for @courseReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Read-only details. Attempts and submissions are not available in this milestone.'**
  String get courseReadOnly;

  /// No description provided for @courseAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get courseAvailable;

  /// No description provided for @courseUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Not open yet'**
  String get courseUpcoming;

  /// No description provided for @courseClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get courseClosed;

  /// No description provided for @courseUnscheduled.
  ///
  /// In en, this message translates to:
  /// **'No availability dates'**
  String get courseUnscheduled;

  /// No description provided for @courseOpens.
  ///
  /// In en, this message translates to:
  /// **'Opens'**
  String get courseOpens;

  /// No description provided for @courseCloses.
  ///
  /// In en, this message translates to:
  /// **'Closes'**
  String get courseCloses;

  /// No description provided for @courseAttemptLimit.
  ///
  /// In en, this message translates to:
  /// **'Allowed attempts'**
  String get courseAttemptLimit;

  /// No description provided for @courseTimeLimit.
  ///
  /// In en, this message translates to:
  /// **'Time limit in minutes'**
  String get courseTimeLimit;

  /// No description provided for @coursePrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous activity'**
  String get coursePrevious;

  /// No description provided for @courseNext.
  ///
  /// In en, this message translates to:
  /// **'Next activity'**
  String get courseNext;

  /// No description provided for @courseFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get courseFile;

  /// No description provided for @courseLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get courseLink;

  /// No description provided for @courseAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get courseAnnouncement;

  /// No description provided for @courseModule.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get courseModule;

  /// No description provided for @courseLab.
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get courseLab;

  /// No description provided for @courseNoProgress.
  ///
  /// In en, this message translates to:
  /// **'No progress yet'**
  String get courseNoProgress;

  /// No description provided for @teachingTeaching.
  ///
  /// In en, this message translates to:
  /// **'Teaching'**
  String get teachingTeaching;

  /// No description provided for @teachingTeacherDefaults.
  ///
  /// In en, this message translates to:
  /// **'Teacher defaults'**
  String get teachingTeacherDefaults;

  /// No description provided for @teachingAssignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get teachingAssignments;

  /// No description provided for @teachingTests.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get teachingTests;

  /// No description provided for @teachingGradebook.
  ///
  /// In en, this message translates to:
  /// **'Gradebook'**
  String get teachingGradebook;

  /// No description provided for @teachingStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get teachingStudents;

  /// No description provided for @teachingCreateAssignment.
  ///
  /// In en, this message translates to:
  /// **'Create assignment'**
  String get teachingCreateAssignment;

  /// No description provided for @teachingCreateTest.
  ///
  /// In en, this message translates to:
  /// **'Create test'**
  String get teachingCreateTest;

  /// No description provided for @teachingPendingGrading.
  ///
  /// In en, this message translates to:
  /// **'Pending grading'**
  String get teachingPendingGrading;

  /// No description provided for @teachingDrafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get teachingDrafts;

  /// No description provided for @teachingAwaitingRelease.
  ///
  /// In en, this message translates to:
  /// **'Awaiting release'**
  String get teachingAwaitingRelease;

  /// No description provided for @teachingNoTeachingCourses.
  ///
  /// In en, this message translates to:
  /// **'No teaching courses'**
  String get teachingNoTeachingCourses;

  /// No description provided for @teachingNoActivitiesYet.
  ///
  /// In en, this message translates to:
  /// **'No activities yet'**
  String get teachingNoActivitiesYet;

  /// No description provided for @teachingTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get teachingTitle;

  /// No description provided for @teachingInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get teachingInstructions;

  /// No description provided for @teachingMaximumPoints.
  ///
  /// In en, this message translates to:
  /// **'Maximum points'**
  String get teachingMaximumPoints;

  /// No description provided for @teachingRequiredActivity.
  ///
  /// In en, this message translates to:
  /// **'Required activity'**
  String get teachingRequiredActivity;

  /// No description provided for @teachingAllowText.
  ///
  /// In en, this message translates to:
  /// **'Allow text'**
  String get teachingAllowText;

  /// No description provided for @teachingAllowFile.
  ///
  /// In en, this message translates to:
  /// **'Allow file'**
  String get teachingAllowFile;

  /// No description provided for @teachingAttemptsAllowed.
  ///
  /// In en, this message translates to:
  /// **'Attempts allowed'**
  String get teachingAttemptsAllowed;

  /// No description provided for @teachingTimeLimitMinutes.
  ///
  /// In en, this message translates to:
  /// **'Time limit (minutes)'**
  String get teachingTimeLimitMinutes;

  /// No description provided for @teachingShuffleQuestions.
  ///
  /// In en, this message translates to:
  /// **'Shuffle questions'**
  String get teachingShuffleQuestions;

  /// No description provided for @teachingOpens.
  ///
  /// In en, this message translates to:
  /// **'Opens'**
  String get teachingOpens;

  /// No description provided for @teachingDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get teachingDeadline;

  /// No description provided for @teachingSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get teachingSaveDraft;

  /// No description provided for @teachingPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get teachingPublish;

  /// No description provided for @teachingSaveDefaults.
  ///
  /// In en, this message translates to:
  /// **'Save defaults'**
  String get teachingSaveDefaults;

  /// No description provided for @teachingSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get teachingSaved;

  /// No description provided for @teachingAddQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get teachingAddQuestion;

  /// No description provided for @teachingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get teachingQuestion;

  /// No description provided for @teachingSingleChoice.
  ///
  /// In en, this message translates to:
  /// **'Single choice'**
  String get teachingSingleChoice;

  /// No description provided for @teachingTrueOrFalse.
  ///
  /// In en, this message translates to:
  /// **'True or false'**
  String get teachingTrueOrFalse;

  /// No description provided for @teachingOptionsOnePerLine.
  ///
  /// In en, this message translates to:
  /// **'Options (one per line)'**
  String get teachingOptionsOnePerLine;

  /// No description provided for @teachingCorrectOptionNumber.
  ///
  /// In en, this message translates to:
  /// **'Correct option number'**
  String get teachingCorrectOptionNumber;

  /// No description provided for @teachingPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get teachingPoints;

  /// No description provided for @teachingRemoveQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove question'**
  String get teachingRemoveQuestion;

  /// No description provided for @teachingSection.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get teachingSection;

  /// No description provided for @teachingEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get teachingEdit;

  /// No description provided for @teachingReleaseResults.
  ///
  /// In en, this message translates to:
  /// **'Release results'**
  String get teachingReleaseResults;

  /// No description provided for @teachingResultsHiddenUntilTeacherRelease.
  ///
  /// In en, this message translates to:
  /// **'Results hidden until teacher release'**
  String get teachingResultsHiddenUntilTeacherRelease;

  /// No description provided for @teachingStartTest.
  ///
  /// In en, this message translates to:
  /// **'Start test'**
  String get teachingStartTest;

  /// No description provided for @teachingSubmitTest.
  ///
  /// In en, this message translates to:
  /// **'Submit test'**
  String get teachingSubmitTest;

  /// No description provided for @teachingSaveAnswer.
  ///
  /// In en, this message translates to:
  /// **'Save answer'**
  String get teachingSaveAnswer;

  /// No description provided for @teachingYourResponse.
  ///
  /// In en, this message translates to:
  /// **'Your response'**
  String get teachingYourResponse;

  /// No description provided for @teachingAttachFile.
  ///
  /// In en, this message translates to:
  /// **'Attach file'**
  String get teachingAttachFile;

  /// No description provided for @teachingFileAttached.
  ///
  /// In en, this message translates to:
  /// **'File attached'**
  String get teachingFileAttached;

  /// No description provided for @teachingSubmitAssignment.
  ///
  /// In en, this message translates to:
  /// **'Submit assignment'**
  String get teachingSubmitAssignment;

  /// No description provided for @teachingUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get teachingUnderReview;

  /// No description provided for @teachingPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get teachingPublished;

  /// No description provided for @teachingDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get teachingDraft;

  /// No description provided for @teachingFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get teachingFeedback;

  /// No description provided for @teachingGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get teachingGrade;

  /// No description provided for @teachingOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Open file'**
  String get teachingOpenFile;

  /// No description provided for @teachingReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get teachingReopen;

  /// No description provided for @teachingRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get teachingRefresh;

  /// No description provided for @teachingRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get teachingRetry;

  /// No description provided for @teachingCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get teachingCancel;

  /// No description provided for @teachingNoSubmissionsYet.
  ///
  /// In en, this message translates to:
  /// **'No submissions yet'**
  String get teachingNoSubmissionsYet;

  /// No description provided for @teachingNoAttemptsYet.
  ///
  /// In en, this message translates to:
  /// **'No attempts yet'**
  String get teachingNoAttemptsYet;

  /// No description provided for @teachingNotSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Not submitted'**
  String get teachingNotSubmitted;

  /// No description provided for @teachingBestScore.
  ///
  /// In en, this message translates to:
  /// **'Best score'**
  String get teachingBestScore;

  /// No description provided for @teachingVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get teachingVersion;

  /// No description provided for @teachingSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get teachingSubmitted;

  /// No description provided for @teachingTimeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time remaining'**
  String get teachingTimeRemaining;

  /// No description provided for @teachingNotGraded.
  ///
  /// In en, this message translates to:
  /// **'Not graded'**
  String get teachingNotGraded;

  /// No description provided for @teachingCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get teachingCorrectAnswer;

  /// No description provided for @teachingSelectASection.
  ///
  /// In en, this message translates to:
  /// **'Select a section'**
  String get teachingSelectASection;

  /// No description provided for @teachingUnavailableCheckYourConnectionAndAccess.
  ///
  /// In en, this message translates to:
  /// **'Unavailable. Check your connection and access.'**
  String get teachingUnavailableCheckYourConnectionAndAccess;

  /// No description provided for @teachingInvalidSettingsOrQuestionsCheckTheForm.
  ///
  /// In en, this message translates to:
  /// **'Invalid settings or questions. Check the form.'**
  String get teachingInvalidSettingsOrQuestionsCheckTheForm;

  /// No description provided for @teachingChangedElsewhereRefreshBeforeSaving.
  ///
  /// In en, this message translates to:
  /// **'Changed elsewhere. Refresh before saving.'**
  String get teachingChangedElsewhereRefreshBeforeSaving;

  /// No description provided for @teachingSubmissionsAreClosedOrUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Submissions are closed or under review.'**
  String get teachingSubmissionsAreClosedOrUnderReview;

  /// No description provided for @teachingCloseTheTestBeforeReleasingResults.
  ///
  /// In en, this message translates to:
  /// **'Close the test before releasing results.'**
  String get teachingCloseTheTestBeforeReleasingResults;

  /// No description provided for @teachingAttemptLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Attempt limit reached.'**
  String get teachingAttemptLimitReached;

  /// No description provided for @teachingUsePdfDocxJpegOrPngUpToMb.
  ///
  /// In en, this message translates to:
  /// **'Use PDF, DOCX, JPEG or PNG, up to 20 MB.'**
  String get teachingUsePdfDocxJpegOrPngUpToMb;

  /// No description provided for @teachingCompleteTheRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Complete the required fields.'**
  String get teachingCompleteTheRequiredFields;

  /// No description provided for @teachingCloseTestNow.
  ///
  /// In en, this message translates to:
  /// **'Close test now'**
  String get teachingCloseTestNow;

  /// No description provided for @teachingViewWork.
  ///
  /// In en, this message translates to:
  /// **'View work'**
  String get teachingViewWork;

  /// No description provided for @teachingContinueTest.
  ///
  /// In en, this message translates to:
  /// **'Continue test'**
  String get teachingContinueTest;

  /// No description provided for @teachingNoStudentsYet.
  ///
  /// In en, this message translates to:
  /// **'No students yet'**
  String get teachingNoStudentsYet;

  /// No description provided for @teachingUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading'**
  String get teachingUploading;

  /// No description provided for @teachingYouHaveUnsavedChangesLeave.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Leave?'**
  String get teachingYouHaveUnsavedChangesLeave;

  /// No description provided for @teachingLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get teachingLeave;

  /// No description provided for @notebookSourcePassage.
  ///
  /// In en, this message translates to:
  /// **'Source passage'**
  String get notebookSourcePassage;

  /// No description provided for @notebookVersion.
  ///
  /// In en, this message translates to:
  /// **'version'**
  String get notebookVersion;

  /// No description provided for @notebookConnectionUnavailableCloseAndTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Connection unavailable. Close and try again.'**
  String get notebookConnectionUnavailableCloseAndTryAgain;

  /// No description provided for @notebookThisPassageIsNoLongerAvailableRefreshTheNotebook.
  ///
  /// In en, this message translates to:
  /// **'This passage is no longer available. Refresh the notebook.'**
  String get notebookThisPassageIsNoLongerAvailableRefreshTheNotebook;

  /// No description provided for @notebookRemovePrivateFile.
  ///
  /// In en, this message translates to:
  /// **'Remove private file'**
  String get notebookRemovePrivateFile;

  /// No description provided for @notebookChangingSourcesInvalidatesPreviousAnswers.
  ///
  /// In en, this message translates to:
  /// **'Changing sources invalidates previous answers.'**
  String get notebookChangingSourcesInvalidatesPreviousAnswers;

  /// No description provided for @notebookRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get notebookRemove;

  /// No description provided for @notebookSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get notebookSources;

  /// No description provided for @notebookNotConfiguredYet.
  ///
  /// In en, this message translates to:
  /// **'Not configured yet'**
  String get notebookNotConfiguredYet;

  /// No description provided for @notebookYourTeacherHasNotConfiguredThisNotebookYet.
  ///
  /// In en, this message translates to:
  /// **'Your teacher has not configured this notebook yet.'**
  String get notebookYourTeacherHasNotConfiguredThisNotebookYet;

  /// No description provided for @notebookAddASourceToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Add a source to get started'**
  String get notebookAddASourceToGetStarted;

  /// No description provided for @notebookChooseAPrivateFileOrWaitForCourseMaterials.
  ///
  /// In en, this message translates to:
  /// **'Choose a private file or wait for course materials from your teacher.'**
  String get notebookChooseAPrivateFileOrWaitForCourseMaterials;

  /// No description provided for @notebookMyFiles.
  ///
  /// In en, this message translates to:
  /// **'My files'**
  String get notebookMyFiles;

  /// No description provided for @notebookCourseMaterials.
  ///
  /// In en, this message translates to:
  /// **'Course materials'**
  String get notebookCourseMaterials;

  /// No description provided for @notebookReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get notebookReady;

  /// No description provided for @notebookFileScanningIsTemporarilyUnavailableTryUploadingAgainLater.
  ///
  /// In en, this message translates to:
  /// **'File scanning is temporarily unavailable. Try uploading again later.'**
  String get notebookFileScanningIsTemporarilyUnavailableTryUploadingAgainLater;

  /// No description provided for @notebookThisFileCouldNotPassTheSafetyCheckChoose.
  ///
  /// In en, this message translates to:
  /// **'This file could not pass the safety check. Choose another copy.'**
  String get notebookThisFileCouldNotPassTheSafetyCheckChoose;

  /// No description provided for @notebookPasswordProtectedFilesCannotBeUsedAskYourTeacher.
  ///
  /// In en, this message translates to:
  /// **'Password-protected files cannot be used. Ask your teacher for an unlocked copy.'**
  String get notebookPasswordProtectedFilesCannotBeUsedAskYourTeacher;

  /// No description provided for @notebookNoReadableTextFoundAskYourTeacherForA.
  ///
  /// In en, this message translates to:
  /// **'No readable text found. Ask your teacher for a text-based copy.'**
  String get notebookNoReadableTextFoundAskYourTeacherForA;

  /// No description provided for @notebookThisFileIsTooLargeOrComplexAskYour.
  ///
  /// In en, this message translates to:
  /// **'This file is too large or complex. Ask your teacher for a smaller copy.'**
  String get notebookThisFileIsTooLargeOrComplexAskYour;

  /// No description provided for @notebookThisDocumentContainsUnsupportedContentAskYourTeacherFor.
  ///
  /// In en, this message translates to:
  /// **'This document contains unsupported content. Ask your teacher for a plain document.'**
  String get notebookThisDocumentContainsUnsupportedContentAskYourTeacherFor;

  /// No description provided for @notebookCouldNotPrepareSource.
  ///
  /// In en, this message translates to:
  /// **'Could not prepare source'**
  String get notebookCouldNotPrepareSource;

  /// No description provided for @notebookPreparingSource.
  ///
  /// In en, this message translates to:
  /// **'Preparing source'**
  String get notebookPreparingSource;

  /// No description provided for @notebookAddPrivateFile.
  ///
  /// In en, this message translates to:
  /// **'Add private file'**
  String get notebookAddPrivateFile;

  /// No description provided for @notebookUpTo25MiB.
  ///
  /// In en, this message translates to:
  /// **'up to 25 MiB'**
  String get notebookUpTo25MiB;

  /// No description provided for @notebookYourPrivateStudySpace.
  ///
  /// In en, this message translates to:
  /// **'Your private study space'**
  String get notebookYourPrivateStudySpace;

  /// No description provided for @notebookAskAQuestionCheckTheEvidenceKeepLearning.
  ///
  /// In en, this message translates to:
  /// **'Ask a question. Check the evidence. Keep learning.'**
  String get notebookAskAQuestionCheckTheEvidenceKeepLearning;

  /// No description provided for @notebookSelectAReadySourceInSourcesToAskA.
  ///
  /// In en, this message translates to:
  /// **'Select a ready source in Sources to ask a question.'**
  String get notebookSelectAReadySourceInSourcesToAskA;

  /// No description provided for @notebookSummarizeSelectedSources.
  ///
  /// In en, this message translates to:
  /// **'Summarize selected sources'**
  String get notebookSummarizeSelectedSources;

  /// No description provided for @notebookExplainKeyConcepts.
  ///
  /// In en, this message translates to:
  /// **'Explain key concepts'**
  String get notebookExplainKeyConcepts;

  /// No description provided for @notebookHelpMeRevise.
  ///
  /// In en, this message translates to:
  /// **'Help me revise'**
  String get notebookHelpMeRevise;

  /// No description provided for @notebookPreparingYourFile.
  ///
  /// In en, this message translates to:
  /// **'Preparing your file…'**
  String get notebookPreparingYourFile;

  /// No description provided for @notebookWaitingToPrepareYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Waiting to prepare your answer…'**
  String get notebookWaitingToPrepareYourAnswer;

  /// No description provided for @notebookPreparingYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Preparing your answer…'**
  String get notebookPreparingYourAnswer;

  /// No description provided for @notebookNewResponse.
  ///
  /// In en, this message translates to:
  /// **'New response'**
  String get notebookNewResponse;

  /// No description provided for @notebookAskAboutYourSources.
  ///
  /// In en, this message translates to:
  /// **'Ask about your sources'**
  String get notebookAskAboutYourSources;

  /// No description provided for @notebookAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get notebookAsk;

  /// No description provided for @notebookStudyAssistant.
  ///
  /// In en, this message translates to:
  /// **'Study assistant'**
  String get notebookStudyAssistant;

  /// No description provided for @notebookSourcesChangedAskAgainForAnUpdatedAnswer.
  ///
  /// In en, this message translates to:
  /// **'Sources changed. Ask again for an updated answer.'**
  String get notebookSourcesChangedAskAgainForAnUpdatedAnswer;

  /// No description provided for @notebookCopyAnswer.
  ///
  /// In en, this message translates to:
  /// **'Copy answer'**
  String get notebookCopyAnswer;

  /// No description provided for @notebookAnswerCopied.
  ///
  /// In en, this message translates to:
  /// **'Answer copied'**
  String get notebookAnswerCopied;

  /// No description provided for @notebookStudyNotebook.
  ///
  /// In en, this message translates to:
  /// **'Study notebook'**
  String get notebookStudyNotebook;

  /// No description provided for @notebookRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get notebookRefresh;

  /// No description provided for @notebookConnectionUnavailableYourWorkIsStillHere.
  ///
  /// In en, this message translates to:
  /// **'Connection unavailable. Your work is still here.'**
  String get notebookConnectionUnavailableYourWorkIsStillHere;

  /// No description provided for @notebookSelectAReadySourceFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a ready source first.'**
  String get notebookSelectAReadySourceFirst;

  /// No description provided for @notebookTheStudyAssistantHasReachedItsUsageLimit.
  ///
  /// In en, this message translates to:
  /// **'The study assistant has reached its usage limit.'**
  String get notebookTheStudyAssistantHasReachedItsUsageLimit;

  /// No description provided for @notebookSourcesChangedRefreshBeforeAskingAgain.
  ///
  /// In en, this message translates to:
  /// **'Sources changed. Refresh before asking again.'**
  String get notebookSourcesChangedRefreshBeforeAskingAgain;

  /// No description provided for @notebookChooseAnAllowedDocumentUpTo25MB.
  ///
  /// In en, this message translates to:
  /// **'Choose an allowed document up to 25 MB.'**
  String get notebookChooseAnAllowedDocumentUpTo25MB;

  /// No description provided for @notebookFileLimitReachedRemoveAnOldPrivateFileOr.
  ///
  /// In en, this message translates to:
  /// **'File limit reached. Remove an old private file or try tomorrow.'**
  String get notebookFileLimitReachedRemoveAnOldPrivateFileOr;

  /// No description provided for @notebookNotebookUnavailableRefreshToTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Notebook unavailable. Refresh to try again.'**
  String get notebookNotebookUnavailableRefreshToTryAgain;

  /// No description provided for @notebookProcessingFailed.
  ///
  /// In en, this message translates to:
  /// **'Notebook couldn’t finish processing. Try again.'**
  String get notebookProcessingFailed;

  /// No description provided for @notebookCheckAgain.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get notebookCheckAgain;

  /// No description provided for @notebookChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get notebookChat;

  /// No description provided for @notebookEvidence.
  ///
  /// In en, this message translates to:
  /// **'{ready, plural, =0{No ready sources} =1{1 ready source} other{{ready} ready sources}} · {excluded} unavailable'**
  String notebookEvidence(int ready, int excluded);

  /// No description provided for @googleUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in is not configured.'**
  String get googleUnavailable;

  /// No description provided for @googleLink.
  ///
  /// In en, this message translates to:
  /// **'Link Google'**
  String get googleLink;

  /// No description provided for @googleLinked.
  ///
  /// In en, this message translates to:
  /// **'Google linked'**
  String get googleLinked;

  /// No description provided for @googleProofInvalid.
  ///
  /// In en, this message translates to:
  /// **'Unable to verify Google sign-in. Try again.'**
  String get googleProofInvalid;

  /// No description provided for @googleLinkRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your existing method, then link Google in Account.'**
  String get googleLinkRequired;

  /// No description provided for @googleEmailMismatch.
  ///
  /// In en, this message translates to:
  /// **'Choose Google with the same email as your Poodle account.'**
  String get googleEmailMismatch;

  /// No description provided for @googleLinkConflict.
  ///
  /// In en, this message translates to:
  /// **'This Google identity cannot be linked to this account.'**
  String get googleLinkConflict;

  /// No description provided for @invitationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'An active invitation is required to join Poodle.'**
  String get invitationUnavailable;

  /// No description provided for @searchQueryLabel.
  ///
  /// In en, this message translates to:
  /// **'Search course content'**
  String get searchQueryLabel;

  /// No description provided for @searchQueryTooLong.
  ///
  /// In en, this message translates to:
  /// **'Use 500 characters or fewer.'**
  String get searchQueryTooLong;

  /// No description provided for @searchQueryInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a search of up to 500 characters without control characters.'**
  String get searchQueryInvalid;

  /// No description provided for @searchClearQuery.
  ///
  /// In en, this message translates to:
  /// **'Clear query'**
  String get searchClearQuery;

  /// No description provided for @searchCourseFilter.
  ///
  /// In en, this message translates to:
  /// **'Course filter'**
  String get searchCourseFilter;

  /// No description provided for @searchFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get searchFilters;

  /// No description provided for @searchTypeFilter.
  ///
  /// In en, this message translates to:
  /// **'Content type'**
  String get searchTypeFilter;

  /// No description provided for @searchAllCourses.
  ///
  /// In en, this message translates to:
  /// **'All courses'**
  String get searchAllCourses;

  /// No description provided for @searchAllKinds.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get searchAllKinds;

  /// No description provided for @searchActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get searchActivities;

  /// No description provided for @searchLoading.
  ///
  /// In en, this message translates to:
  /// **'Searching course content'**
  String get searchLoading;

  /// No description provided for @searchOffline.
  ///
  /// In en, this message translates to:
  /// **'Search needs an internet connection.'**
  String get searchOffline;

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search is unavailable.'**
  String get searchFailed;

  /// No description provided for @searchIntro.
  ///
  /// In en, this message translates to:
  /// **'Describe what you want to find in English or Ukrainian. Search looks for related topics across your courses.'**
  String get searchIntro;

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchRecent;

  /// No description provided for @searchNoRecent.
  ///
  /// In en, this message translates to:
  /// **'No recent searches. Try to search.'**
  String get searchNoRecent;

  /// No description provided for @searchRemoveRecent.
  ///
  /// In en, this message translates to:
  /// **'Remove recent search: {query}'**
  String searchRemoveRecent(String query);

  /// No description provided for @searchClearRecent.
  ///
  /// In en, this message translates to:
  /// **'Clear all recent searches'**
  String get searchClearRecent;

  /// No description provided for @searchHistoryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update recent searches.'**
  String get searchHistoryFailed;

  /// No description provided for @searchNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchNoMatches;

  /// No description provided for @searchNoMatchesHint.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or adjust your filters.'**
  String get searchNoMatchesHint;

  /// No description provided for @searchClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get searchClearSearch;

  /// No description provided for @searchResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 result} other{{count} results}}'**
  String searchResultCount(int count);

  /// No description provided for @searchKeywordOnly.
  ///
  /// In en, this message translates to:
  /// **'Search by meaning is unavailable. Showing keyword matches.'**
  String get searchKeywordOnly;

  /// No description provided for @searchIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Some course materials may not be searchable yet.'**
  String get searchIncomplete;

  /// No description provided for @searchCapped.
  ///
  /// In en, this message translates to:
  /// **'Showing the top 50 results. Refine your search to narrow the list.'**
  String get searchCapped;

  /// No description provided for @searchPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String searchPage(int page);

  /// No description provided for @searchFileExcerpt.
  ///
  /// In en, this message translates to:
  /// **'File excerpt'**
  String get searchFileExcerpt;

  /// No description provided for @studioTitle.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get studioTitle;

  /// No description provided for @studioIntro.
  ///
  /// In en, this message translates to:
  /// **'Create study materials from your selected sources.'**
  String get studioIntro;

  /// No description provided for @studioLibrary.
  ///
  /// In en, this message translates to:
  /// **'Your study materials'**
  String get studioLibrary;

  /// No description provided for @studioEmpty.
  ///
  /// In en, this message translates to:
  /// **'No study materials yet.'**
  String get studioEmpty;

  /// No description provided for @studioQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get studioQuiz;

  /// No description provided for @studioAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio Overview'**
  String get studioAudio;

  /// No description provided for @studioFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Flash Cards'**
  String get studioFlashcards;

  /// No description provided for @studioLanguage.
  ///
  /// In en, this message translates to:
  /// **'Output language'**
  String get studioLanguage;

  /// No description provided for @studioGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get studioGenerate;

  /// No description provided for @studioQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get studioQueued;

  /// No description provided for @studioProcessing.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get studioProcessing;

  /// No description provided for @studioStale.
  ///
  /// In en, this message translates to:
  /// **'Sources changed. Generate again.'**
  String get studioStale;

  /// No description provided for @studioInsufficient.
  ///
  /// In en, this message translates to:
  /// **'There isn’t enough evidence. Try adding more sources.'**
  String get studioInsufficient;

  /// No description provided for @studioAudioUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Audio is unavailable. Try again.'**
  String get studioAudioUnavailable;

  /// No description provided for @studioTranscript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get studioTranscript;

  /// No description provided for @studioShowFront.
  ///
  /// In en, this message translates to:
  /// **'Show front'**
  String get studioShowFront;

  /// No description provided for @studioShowAnswer.
  ///
  /// In en, this message translates to:
  /// **'Show answer'**
  String get studioShowAnswer;

  /// No description provided for @studioPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get studioPrevious;

  /// No description provided for @studioNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get studioNext;

  /// No description provided for @studioScore.
  ///
  /// In en, this message translates to:
  /// **'Score: {score} / {total}'**
  String studioScore(int score, int total);

  /// No description provided for @studioRestart.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get studioRestart;

  /// No description provided for @studioYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get studioYourAnswer;

  /// No description provided for @studioCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get studioCorrect;

  /// No description provided for @studioIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get studioIncorrect;

  /// No description provided for @studioPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get studioPause;

  /// No description provided for @studioPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get studioPlay;

  /// No description provided for @homeNextUp.
  ///
  /// In en, this message translates to:
  /// **'Next up'**
  String get homeNextUp;

  /// No description provided for @homeStudyCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses I study'**
  String get homeStudyCourses;

  /// No description provided for @homeTeachCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses I teach'**
  String get homeTeachCourses;

  /// No description provided for @homeCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get homeCreate;

  /// No description provided for @homeChooseCourse.
  ///
  /// In en, this message translates to:
  /// **'Choose a course'**
  String get homeChooseCourse;

  /// No description provided for @homePlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform overview'**
  String get homePlatform;

  /// No description provided for @homeAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get homeAccounts;

  /// No description provided for @homeStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get homeStudents;

  /// No description provided for @homeTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get homeTeachers;

  /// No description provided for @homeAdmins.
  ///
  /// In en, this message translates to:
  /// **'Administrators'**
  String get homeAdmins;

  /// No description provided for @homeInvitations.
  ///
  /// In en, this message translates to:
  /// **'Pending invitations'**
  String get homeInvitations;

  /// No description provided for @homeOverlap.
  ///
  /// In en, this message translates to:
  /// **'People can belong to more than one category.'**
  String get homeOverlap;

  /// No description provided for @homeMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get homeMore;

  /// No description provided for @homeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get homeEmpty;

  /// No description provided for @homeError.
  ///
  /// In en, this message translates to:
  /// **'Could not load. Try again.'**
  String get homeError;

  /// No description provided for @homeMyCourses.
  ///
  /// In en, this message translates to:
  /// **'My courses'**
  String get homeMyCourses;

  /// No description provided for @institutionRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'University access'**
  String get institutionRequestTitle;

  /// No description provided for @institutionRequestIntro.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your university. Verify your email, then we will contact your university to confirm your authority.'**
  String get institutionRequestIntro;

  /// No description provided for @institutionName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get institutionName;

  /// No description provided for @institutionUniversity.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get institutionUniversity;

  /// No description provided for @institutionPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get institutionPosition;

  /// No description provided for @institutionNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get institutionNote;

  /// No description provided for @institutionRequired.
  ///
  /// In en, this message translates to:
  /// **'Complete the required fields.'**
  String get institutionRequired;

  /// No description provided for @institutionSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get institutionSendCode;

  /// No description provided for @institutionVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify email'**
  String get institutionVerify;

  /// No description provided for @institutionAwaitingReview.
  ///
  /// In en, this message translates to:
  /// **'Your request is awaiting review.'**
  String get institutionAwaitingReview;

  /// No description provided for @institutionLastAdmin.
  ///
  /// In en, this message translates to:
  /// **'Add another administrator before removing the last one.'**
  String get institutionLastAdmin;

  /// No description provided for @institutionConflict.
  ///
  /// In en, this message translates to:
  /// **'This email already has access or an invitation for a different university or role.'**
  String get institutionConflict;

  /// No description provided for @institutionInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'The code is invalid or expired. Request a new code.'**
  String get institutionInvalidCode;

  /// No description provided for @institutionContactPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you a university administrator?'**
  String get institutionContactPrompt;

  /// No description provided for @institutionContactAction.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get institutionContactAction;

  /// No description provided for @institutionOperator.
  ///
  /// In en, this message translates to:
  /// **'University requests'**
  String get institutionOperator;

  /// No description provided for @institutionApplicant.
  ///
  /// In en, this message translates to:
  /// **'Applicant'**
  String get institutionApplicant;

  /// No description provided for @institutionReviewDecision.
  ///
  /// In en, this message translates to:
  /// **'Review decision'**
  String get institutionReviewDecision;

  /// No description provided for @institutionUniversityAssignment.
  ///
  /// In en, this message translates to:
  /// **'University assignment'**
  String get institutionUniversityAssignment;

  /// No description provided for @institutionReviewNoteRequired.
  ///
  /// In en, this message translates to:
  /// **'A note is required for either decision.'**
  String get institutionReviewNoteRequired;

  /// No description provided for @institutionRequestUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This request is no longer available.'**
  String get institutionRequestUnavailable;

  /// No description provided for @institutionNewRequestAlert.
  ///
  /// In en, this message translates to:
  /// **'New university request'**
  String get institutionNewRequestAlert;

  /// No description provided for @institutionNewRequestsAlert.
  ///
  /// In en, this message translates to:
  /// **'New university requests are ready for review'**
  String get institutionNewRequestsAlert;

  /// No description provided for @institutionPendingCount.
  ///
  /// In en, this message translates to:
  /// **'Awaiting review: {count}'**
  String institutionPendingCount(int count);

  /// No description provided for @institutionAdmin.
  ///
  /// In en, this message translates to:
  /// **'University administration'**
  String get institutionAdmin;

  /// No description provided for @institutionTeaching.
  ///
  /// In en, this message translates to:
  /// **'Manage my courses'**
  String get institutionTeaching;

  /// No description provided for @institutionApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve and invite'**
  String get institutionApprove;

  /// No description provided for @institutionReject.
  ///
  /// In en, this message translates to:
  /// **'Reject request'**
  String get institutionReject;

  /// No description provided for @institutionReviewNote.
  ///
  /// In en, this message translates to:
  /// **'Verification details / rejection reason'**
  String get institutionReviewNote;

  /// No description provided for @institutionSlug.
  ///
  /// In en, this message translates to:
  /// **'University URL name'**
  String get institutionSlug;

  /// No description provided for @institutionNewUniversity.
  ///
  /// In en, this message translates to:
  /// **'Create a new university'**
  String get institutionNewUniversity;

  /// No description provided for @institutionReviewIntro.
  ///
  /// In en, this message translates to:
  /// **'Confirm the representative’s authority with the university before approving.'**
  String get institutionReviewIntro;

  /// No description provided for @institutionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get institutionEmpty;

  /// No description provided for @institutionMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get institutionMembers;

  /// No description provided for @institutionTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get institutionTeacher;

  /// No description provided for @institutionAdministrator.
  ///
  /// In en, this message translates to:
  /// **'University administrator'**
  String get institutionAdministrator;

  /// No description provided for @institutionStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get institutionStudent;

  /// No description provided for @institutionGrantAdmin.
  ///
  /// In en, this message translates to:
  /// **'Make administrator'**
  String get institutionGrantAdmin;

  /// No description provided for @institutionRemoveAdmin.
  ///
  /// In en, this message translates to:
  /// **'Remove administrator rights'**
  String get institutionRemoveAdmin;

  /// No description provided for @institutionInviteSent.
  ///
  /// In en, this message translates to:
  /// **'Access updated or invitation queued for email delivery.'**
  String get institutionInviteSent;

  /// No description provided for @institutionCreateCourse.
  ///
  /// In en, this message translates to:
  /// **'Create course'**
  String get institutionCreateCourse;

  /// No description provided for @institutionCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Course title'**
  String get institutionCourseTitle;

  /// No description provided for @institutionPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish course'**
  String get institutionPublish;

  /// No description provided for @institutionUnpublish.
  ///
  /// In en, this message translates to:
  /// **'Move to draft'**
  String get institutionUnpublish;

  /// No description provided for @institutionDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft — visible only to teachers'**
  String get institutionDraft;

  /// No description provided for @institutionPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get institutionPublished;

  /// No description provided for @institutionInviteStudent.
  ///
  /// In en, this message translates to:
  /// **'Invite student'**
  String get institutionInviteStudent;

  /// No description provided for @institutionEditCourse.
  ///
  /// In en, this message translates to:
  /// **'Edit course content'**
  String get institutionEditCourse;

  /// No description provided for @institutionPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting review'**
  String get institutionPending;

  /// No description provided for @institutionApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get institutionApproved;

  /// No description provided for @institutionRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get institutionRejected;

  /// No description provided for @institutionRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get institutionRefresh;

  /// No description provided for @institutionForbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have access to this action.'**
  String get institutionForbidden;

  /// No description provided for @messagesDrafts.
  ///
  /// In en, this message translates to:
  /// **'My drafts'**
  String get messagesDrafts;

  /// No description provided for @messagesDraftsDescription.
  ///
  /// In en, this message translates to:
  /// **'Save notes and messages for yourself'**
  String get messagesDraftsDescription;

  /// No description provided for @messagesNoRecipients.
  ///
  /// In en, this message translates to:
  /// **'No eligible classmates or teachers yet.'**
  String get messagesNoRecipients;

  /// No description provided for @messagesNew.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get messagesNew;

  /// No description provided for @messagesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Messages could not be loaded.'**
  String get messagesLoadError;

  /// No description provided for @messagesRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get messagesRetry;

  /// No description provided for @messagesDraftsHint.
  ///
  /// In en, this message translates to:
  /// **'Save a note for later'**
  String get messagesDraftsHint;

  /// No description provided for @messagesEmptyThread.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get messagesEmptyThread;

  /// No description provided for @messagesReadOnly.
  ///
  /// In en, this message translates to:
  /// **'This conversation is read-only because you no longer share an active course.'**
  String get messagesReadOnly;

  /// No description provided for @messagesComposerHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get messagesComposerHint;

  /// No description provided for @messagesSend.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get messagesSend;

  /// No description provided for @messagesIncomingAlert.
  ///
  /// In en, this message translates to:
  /// **'New message. Tap to view.'**
  String get messagesIncomingAlert;

  /// No description provided for @messagesOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open messaging. Please try again.'**
  String get messagesOpenError;

  /// No description provided for @messageToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get messageToday;

  /// No description provided for @messageYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get messageYesterday;

  /// No description provided for @notebookSaveNote.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get notebookSaveNote;

  /// No description provided for @notebookSavedNotes.
  ///
  /// In en, this message translates to:
  /// **'Saved notes'**
  String get notebookSavedNotes;

  /// No description provided for @notebookNoteSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get notebookNoteSaved;

  /// No description provided for @notebookSaveNoteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save note'**
  String get notebookSaveNoteFailed;

  /// No description provided for @notebookNoSavedNotes.
  ///
  /// In en, this message translates to:
  /// **'No saved notes'**
  String get notebookNoSavedNotes;

  /// No description provided for @notebookDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get notebookDeleteNote;

  /// No description provided for @notebookDeleteNoteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete note?'**
  String get notebookDeleteNoteConfirm;

  /// No description provided for @notebookDeleteNoteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete note'**
  String get notebookDeleteNoteFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
