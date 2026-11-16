// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get courseFavoriteStatus => 'Обраний курс';

  @override
  String get splashQuoteShevchenko =>
      'І чужому научайтесь, й свого не цурайтесь.';

  @override
  String get splashQuoteForestSong => 'Ні! я жива! Я буду вічно жити!';

  @override
  String get splashQuoteHope => 'Без надії таки сподіватись';

  @override
  String get splashQuoteStruggle => 'Лиш боротись значить жить…';

  @override
  String get splashQuoteAwaken => 'Встань, прокинься, пробудись!';

  @override
  String get splashAuthorShevchenko => 'Тарас Шевченко';

  @override
  String get splashAuthorUkrainka => 'Леся Українка';

  @override
  String get splashAuthorFranko => 'Іван Франко';

  @override
  String get loginTitle => 'З поверненням';

  @override
  String get loginSubtitle =>
      'Трохи цікавості — і стільки відкриттів.\nУвійдіть, щоб продовжити навчання.';

  @override
  String get email => 'Електронна пошта';

  @override
  String get emailHint => 'yourname@lntu.edu.ua';

  @override
  String get password => 'Пароль';

  @override
  String get passwordHint => 'Уведіть пароль';

  @override
  String get showPassword => 'Показати пароль';

  @override
  String get hidePassword => 'Приховати пароль';

  @override
  String get rememberMe => 'Запам’ятати мене';

  @override
  String get forgotPassword => 'Забули пароль?';

  @override
  String get logIn => 'Увійти';

  @override
  String get googleSignIn => 'Увійти з Google';

  @override
  String get orContinueWith => 'або продовжити з';

  @override
  String get invitationPrompt => 'Уперше в Poodle?';

  @override
  String get invitationAction => 'Приєднатися за запрошенням';

  @override
  String get invitationTitle => 'Навчання починається із запрошення';

  @override
  String get invitationBody =>
      'До Poodle можна приєднатися лише за запрошенням. Зверніться до викладача або адміністратора, щоб долучитися до навчальної спільноти.';

  @override
  String get close => 'Закрити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get emailRequired => 'Уведіть електронну пошту.';

  @override
  String get emailInvalid => 'Уведіть коректну електронну пошту.';

  @override
  String get passwordRequired => 'Уведіть пароль.';

  @override
  String get invalidCredentials =>
      'Неправильна пошта або пароль. Спробуйте ще раз.';

  @override
  String get networkError => 'Не вдалося з’єднатися. Спробуйте ще раз.';

  @override
  String get resetTitle => 'Забули пароль?';

  @override
  String get resetBody =>
      'Уведіть електронну пошту, щоб повернутися до навчання.';

  @override
  String get sendReset => 'Надіслати інструкції';

  @override
  String get resetConfirmationTitle => 'Запит на скидання пароля';

  @override
  String get resetConfirmationBody => 'Електронного листа не надіслано.';

  @override
  String get demoSession => 'Демонстраційний сеанс';

  @override
  String get demoBody =>
      'Усе готово до нових відкриттів. У цьому перегляді вхід імітовано; навчальний простір з’явиться згодом.';

  @override
  String get signOut => 'Вийти';

  @override
  String get previewLabel => 'Перегляд інтерфейсу · імітація входу';

  @override
  String get loading => 'Завантаження';

  @override
  String get mascotLabel => 'Талісман Poodle';

  @override
  String get onboardingSkip => 'Пропустити';

  @override
  String get onboardingNext => 'Далі';

  @override
  String get onboardingStart => 'Почати';

  @override
  String get onboardingPrevious => 'Попередня історія';

  @override
  String get onboardingPause => 'Призупинити історії';

  @override
  String get onboardingPlay => 'Відтворити історії';

  @override
  String get onboardingManual => 'Ручне перемикання';

  @override
  String get onboardingPreview => 'Огляд можливостей';

  @override
  String onboardingPosition(int current, int total) {
    return 'Історія $current з $total';
  }

  @override
  String get onboardingPrivate => 'Лише для вас';

  @override
  String get onboardingCitation => 'Джерело · сторінка 12';

  @override
  String get onboardingReadOnly => 'Читання офлайн';

  @override
  String get onboardingPractice => 'Тренування без оцінок';

  @override
  String get onboardingSampleCourse => 'Творче мислення';

  @override
  String get onboardingSampleLesson => 'Новий погляд';

  @override
  String get onboardingSampleTask => 'Дослідіть наступний розділ';

  @override
  String get onboardingSampleFeedback => 'Відгуки для вашого розвитку';

  @override
  String get onboardingDocuments => 'Документи та зображення';

  @override
  String get onboardingLinks => 'Публічні посилання';

  @override
  String get onboardingTranscripts => 'Записи та розшифрування';

  @override
  String get onboardingToday => 'Сьогодні';

  @override
  String get onboardingMessage => 'Запитання варте уваги';

  @override
  String get onboardingInvitation => 'За запрошенням';

  @override
  String get onboardingPreferences => 'Читання та нагадування';

  @override
  String get onboardingCoursesTitle => 'Усе навчання — в одному місці.';

  @override
  String get onboardingCoursesBody =>
      'Знаходьте курси, продовжуйте навчання й стежте за прогресом.';

  @override
  String get onboardingCoursesCard => 'Ваші курси';

  @override
  String get onboardingCoursesTag => 'Продовжуйте';

  @override
  String get onboardingMaterialsTitle => 'Усе потрібне для навчання.';

  @override
  String get onboardingMaterialsBody =>
      'Переходьте між модулями, читайте матеріали й повертайтеся до занять.';

  @override
  String get onboardingMaterialsCard => 'Матеріали курсу';

  @override
  String get onboardingMaterialsTag => 'Модуль 01';

  @override
  String get onboardingNotebookTitle =>
      'Навчайтеся з відповідями, які можна перевірити.';

  @override
  String get onboardingNotebookBody =>
      'Запитуйте про джерела, перевіряйте посилання й повторюйте матеріал із підсумками, картками та тестами.';

  @override
  String get onboardingNotebookCard => 'Ваш приватний нотатник';

  @override
  String get onboardingNotebookTag => 'Відповіді з джерел';

  @override
  String get onboardingSourcesTitle => 'Збирайте джерела для навчання.';

  @override
  String get onboardingSourcesBody =>
      'Додавайте документи, зображення, публічні посилання чи записи до приватного нотатника.';

  @override
  String get onboardingSourcesCard => 'Ваші навчальні джерела';

  @override
  String get onboardingSourcesTag => 'Готово до навчання';

  @override
  String get onboardingPlanningTitle => 'Знайте, що далі.';

  @override
  String get onboardingPlanningBody =>
      'Плануйте завдання, лекції, підготовку й іспити в календарі та списку справ.';

  @override
  String get onboardingPlanningCard => 'Трохи більше готовності';

  @override
  String get onboardingPlanningTag => 'Ваші наступні кроки';

  @override
  String get onboardingAssignmentsTitle =>
      'Здавайте роботи й стежте за результатами.';

  @override
  String get onboardingAssignmentsBody =>
      'Надсилайте роботи до дедлайну, переглядайте версії, оцінки й відгуки.';

  @override
  String get onboardingAssignmentsCard => 'Кожен крок важливий';

  @override
  String get onboardingAssignmentsTag => 'Робота та відгук';

  @override
  String get onboardingConnectedTitle => 'Будьте на зв’язку з курсом.';

  @override
  String get onboardingConnectedBody =>
      'Читайте оголошення, спілкуйтеся приватно й стежте за оновленнями.';

  @override
  String get onboardingConnectedCard => 'Навчаємося разом';

  @override
  String get onboardingConnectedTag => 'Особисті розмови';

  @override
  String get onboardingTeachingTitle => 'Спільний простір для викладання.';

  @override
  String get onboardingTeachingBody =>
      'Запрошуйте студентів, публікуйте матеріали й завдання та переглядайте роботи в журналі оцінок.';

  @override
  String get onboardingTeachingCard => 'Простір для викладання';

  @override
  String get onboardingTeachingTag => 'Запрошуйте. Навчайте. Підтримуйте.';

  @override
  String get onboardingOfflineTitle => 'Читайте навіть без інтернету.';

  @override
  String get onboardingOfflineBody =>
      'Завантажуйте матеріали й повертайтеся до збереженого навчального вмісту будь-де.';

  @override
  String get onboardingOfflineCard => 'Навчайтеся будь-де';

  @override
  String get onboardingOfflineTag => 'Збережено на потім';

  @override
  String get onboardingPersonalTitle => 'Налаштуйте Poodle для себе.';

  @override
  String get onboardingPersonalBody =>
      'Керуйте профілем, файлами, читанням, сповіщеннями й сховищем та знаходьте допомогу.';

  @override
  String get onboardingPersonalCard => 'Ваш простір для зростання';

  @override
  String get onboardingPersonalTag => 'Почувайтеся як удома';

  @override
  String get homeTab => 'Головна';

  @override
  String get coursesTab => 'Курси';

  @override
  String get myCoursesTab => 'Мої курси';

  @override
  String get searchTab => 'Пошук';

  @override
  String get searchPreview => 'Перегляд пошуку';

  @override
  String get messagesTab => 'Повідомлення';

  @override
  String get compactMessagesTab => 'Чати';

  @override
  String get notificationsTab => 'Сповіщення';

  @override
  String get moreTab => 'Ще';

  @override
  String get settingsGeneral => 'Загальні';

  @override
  String get settingsSpaceUsage => 'Використання пам’яті';

  @override
  String get settingsSynchronisation => 'Синхронізація';

  @override
  String get settingsSharedFiles => 'Спільні файли';

  @override
  String get settingsAbout => 'Про застосунок';

  @override
  String get settingsLanguage => 'Мова';

  @override
  String get settingsSystem => 'Системна';

  @override
  String get settingsTextSize => 'Розмір тексту';

  @override
  String get settingsStandard => 'Стандартний';

  @override
  String get settingsLarge => 'Великий';

  @override
  String get settingsExtraLarge => 'Дуже великий';

  @override
  String get settingsSaveFailed =>
      'Не вдалося зберегти налаштування. Спробуйте ще раз.';

  @override
  String get settingsSpaceUnavailable =>
      'Дані про використання пам’яті поки недоступні.';

  @override
  String get settingsSyncUnavailable => 'Синхронізація поки недоступна.';

  @override
  String get settingsFilesUnavailable => 'Спільні файли поки недоступні.';

  @override
  String get settingsAboutDescription =>
      'Poodle — простір для курсів, завдань і навчальних інструментів.';

  @override
  String get settingsLicences => 'Ліцензії відкритого коду';

  @override
  String get settingsPrivacy => 'Політика конфіденційності';

  @override
  String get settingsAccessibility => 'Заява про доступність';

  @override
  String get settingsResourceComingSoon => 'Цей ресурс незабаром з’явиться.';

  @override
  String get settingsVersion => 'Версія';

  @override
  String get settingsVersionUnavailable => 'Версія недоступна';

  @override
  String get routeNotFoundTitle => 'Сторінку не знайдено';

  @override
  String get routeNotFoundMessage =>
      'Ця сторінка недоступна. Поверніться на головну, щоб продовжити навчання.';

  @override
  String get routeErrorTitle => 'Щось пішло не так';

  @override
  String get routeErrorMessage =>
      'Не вдалося відкрити сторінку. Поверніться на головну та спробуйте ще раз.';

  @override
  String get dashboardWelcome => 'Трохи поступу щодня';

  @override
  String get dashboardPreviewBody =>
      'Приклад навчальних даних для перегляду інтерфейсу.';

  @override
  String get dashboardUpcoming => 'Найближчі завдання';

  @override
  String get dashboardRecent => 'Недавні курси';

  @override
  String get dashboardAnnouncements => 'Оголошення';

  @override
  String get dashboardQuickLinks => 'Швидкі переходи';

  @override
  String get dashboardViewAll => 'Переглянути всі';

  @override
  String get dashboardRetry => 'Повторити';

  @override
  String get dashboardRefresh => 'Оновити';

  @override
  String get dashboardLoadError =>
      'Не вдалося завантажити головну сторінку. Спробуйте ще раз.';

  @override
  String get dashboardOffline => 'Офлайн · збережені дані могли застаріти.';

  @override
  String get dashboardEmptyTasks => 'Немає майбутніх завдань.';

  @override
  String get dashboardEmptyCourses => 'Немає нещодавніх курсів.';

  @override
  String get dashboardEmptyAnnouncements => 'Немає оголошень.';

  @override
  String get dashboardDue => 'Термін';

  @override
  String get dashboardOverdue => 'Прострочено';

  @override
  String get dashboardLastAccess => 'Відкрито';

  @override
  String get dashboardNoRequired => 'Немає обов’язкових завдань';

  @override
  String dashboardProgress(int value) {
    return 'Виконано $value%';
  }

  @override
  String dashboardUpdated(String date) {
    return 'Приклад оновлено $date';
  }

  @override
  String get dashboardCourseDesign => 'Творче мислення';

  @override
  String get dashboardCourseWriting => 'Майстерня письма';

  @override
  String get dashboardCategoryArts => 'Мистецтво й дизайн';

  @override
  String get dashboardCategoryLanguage => 'Мова';

  @override
  String get dashboardTaskReading => 'Прочитайте наступний розділ';

  @override
  String get dashboardTaskReflection => 'Надішліть роздум';

  @override
  String get dashboardAnnouncementWeek => 'Матеріали цього тижня';

  @override
  String get dashboardAnnouncementWeekExcerpt =>
      'Новий список матеріалів готовий.';

  @override
  String get dashboardAnnouncementWeekBody =>
      'Новий список матеріалів готовий. Дослідіть наступну тему, коли матимете час.';

  @override
  String get dashboardAnnouncementWelcome => 'Вітаємо на курсі';

  @override
  String get dashboardAnnouncementWelcomeExcerpt => 'Раді бачити вас тут.';

  @override
  String get dashboardAnnouncementWelcomeBody =>
      'Раді бачити вас тут. Знайдімо місце для цікавості та вдумливої праці.';

  @override
  String get dashboardSampleAuthor => 'Викладач курсу';

  @override
  String get dashboardUnread => 'Непрочитане';

  @override
  String get dashboardCoursePreview => 'Курси';

  @override
  String get dashboardMessagesPreview => 'Приватні повідомлення';

  @override
  String get dashboardNotificationsPreview => 'Сповіщення';

  @override
  String get dashboardFeaturePreview =>
      'Ця можливість з’явиться в Poodle. У цьому перегляді немає справжніх навчальних даних.';

  @override
  String get dashboardCalendar => 'Календар';

  @override
  String get calendarMonth => 'Місяць';

  @override
  String get calendarUpcoming => 'Найближчі події';

  @override
  String get calendarLoadMore => 'Завантажити наступні 30 днів';

  @override
  String get calendarOpenNow => 'Доступно зараз';

  @override
  String get calendarToday => 'Сьогодні';

  @override
  String get calendarPreviousMonth => 'Попередній місяць';

  @override
  String get calendarNextMonth => 'Наступний місяць';

  @override
  String get calendarNoEvents => 'На цю дату подій немає.';

  @override
  String get calendarOpens => 'Відкривається';

  @override
  String get calendarCloses => 'Закривається';

  @override
  String get calendarCourse => 'Курс';

  @override
  String get calendarType => 'Тип події';

  @override
  String get calendarGoToActivity => 'Перейти до матеріалу';

  @override
  String get calendarFilter => 'Фільтр календаря';

  @override
  String get calendarAllFilters => 'Очистити фільтри';

  @override
  String get calendarCached =>
      'Показано збережені дати. Оновіть, щоб перевірити зміни.';

  @override
  String get calendarAssignment => 'Завдання';

  @override
  String get calendarTest => 'Тест';

  @override
  String get studentTasksOverdue => 'Прострочені';

  @override
  String get studentTasksUpcoming => 'Майбутні';

  @override
  String get studentTasksEmpty => 'Немає завдань із кінцевим терміном.';

  @override
  String get studentTasksError => 'Не вдалося завантажити завдання.';

  @override
  String get studentGradesPending => 'Очікує оцінювання';

  @override
  String get studentGradesGraded => 'Оцінено';

  @override
  String get studentGradesEmpty => 'Оцінок поки немає';

  @override
  String get dashboardTasks => 'Завдання';

  @override
  String get dashboardDownloads => 'Завантаження';

  @override
  String get dashboardGrades => 'Оцінки';

  @override
  String get dashboardFiles => 'Файли';

  @override
  String get dashboardProfile => 'Профіль';

  @override
  String get dashboardSettings => 'Налаштування';

  @override
  String get dashboardHelp => 'Допомога';

  @override
  String get dashboardBack => 'Назад';

  @override
  String get authStorageError =>
      'Захищене сховище сеансу недоступне. Спробуйте ще раз.';

  @override
  String get authAccessDenied => 'У вас немає доступу до цієї дії.';

  @override
  String get authInvalidCode =>
      'Код недійсний або прострочений. Запросіть новий код.';

  @override
  String get authPasswordPolicy =>
      'Використайте щонайменше 8 символів без пробілів на початку й у кінці.';

  @override
  String get authUnavailable => 'Ця дія недоступна. Спробуйте ще раз.';

  @override
  String get authRecoveryTitle => 'Не вдалося відновити сеанс';

  @override
  String get authRetry => 'Спробувати знову';

  @override
  String get authBackToLogin => 'Повернутися до входу';

  @override
  String get authLogoutUnconfirmed =>
      'Вихід на цьому пристрої виконано. Не вдалося підтвердити відкликання сеансу на сервері.';

  @override
  String get authLogoutStorage =>
      'Локальний вихід виконано. Не вдалося очистити захищене сховище; повторіть вихід перед закриттям застосунку.';

  @override
  String get authRequestCode => 'Запросити код підтвердження';

  @override
  String get authCodeNotice =>
      'Якщо ця адреса відповідає умовам, код підтвердження створено. Для локальної розробки шукайте його в журналах сервера.';

  @override
  String get authVerificationCode => 'Код підтвердження';

  @override
  String get authVerifyCode => 'Підтвердити код';

  @override
  String get authNewPassword => 'Новий пароль';

  @override
  String get authConfirmPassword => 'Підтвердьте пароль';

  @override
  String get authPasswordMismatch => 'Паролі мають збігатися.';

  @override
  String get authSavePassword => 'Зберегти пароль';

  @override
  String get authCreateAccount => 'Прийняти запрошення';

  @override
  String get authResetDone => 'Пароль оновлено. Увійдіть із новим паролем.';

  @override
  String get authStartOver => 'Запросити інший код';

  @override
  String get authAccount => 'Обліковий запис';

  @override
  String get authChangeEmail => 'Змінити електронну пошту';

  @override
  String get authNewEmail => 'Нова електронна пошта';

  @override
  String get authCurrentPassword => 'Поточний пароль';

  @override
  String get authEmailChangeStart => 'Надіслати код підтвердження';

  @override
  String get authEmailChangeCode => 'Уведіть код, надісланий на нову адресу.';

  @override
  String authEmailChangePending(String email) {
    return 'Очікується підтвердження для $email.';
  }

  @override
  String get authEmailChangeConfirm => 'Підтвердити зміну пошти';

  @override
  String get authEmailChangeCancel => 'Скасувати очікувану зміну';

  @override
  String get authEmailChangeResend => 'Надіслати код ще раз';

  @override
  String get authPasswordManagedByGoogle => 'Вашим паролем керує Google.';

  @override
  String get authAdmin => 'Адміністратор';

  @override
  String get authMember => 'Обліковий запис активний';

  @override
  String get authTeacherApproved =>
      'Схвалено для майбутньої ролі викладача в курсах';

  @override
  String get authInvitations => 'Запрошення викладачів';

  @override
  String get authInvite => 'Створити запрошення';

  @override
  String get authRevoke => 'Відкликати';

  @override
  String get authAccepted => 'Прийнято';

  @override
  String get authRevoked => 'Відкликано';

  @override
  String get authExpired => 'Термін дії минув';

  @override
  String get authExpires => 'Діє до';

  @override
  String get authNoInvitations => 'На цій сторінці немає запрошень.';

  @override
  String get authNextPage => 'Наступна сторінка';

  @override
  String get authPreviousPage => 'Попередня сторінка';

  @override
  String get authInviteCreated =>
      'Запрошення створено. Попросіть одержувача вибрати «Приєднатися за запрошенням».';

  @override
  String get courseUnavailable => 'Курс або діяльність недоступні.';

  @override
  String get courseEmpty => 'Курсів поки немає.';

  @override
  String get courseContentEmpty => 'Опублікованих матеріалів поки немає.';

  @override
  String get courseSample => 'Приклад курсу';

  @override
  String get courseDraft => 'Чернетка';

  @override
  String get courseTeacherView => 'Перегляд викладача';

  @override
  String get courseSections => 'Розділи';

  @override
  String get courseOpenFile => 'Відкрити файл';

  @override
  String get courseOpenLink => 'Відкрити вебсайт';

  @override
  String get courseExternalLink => 'Відкриється всередині Poodle.';

  @override
  String get courseLinkError =>
      'Не вдалося відкрити посилання. Оновіть сторінку завдання та спробуйте ще раз.';

  @override
  String get browserReload => 'Оновити сторінку';

  @override
  String get browserClose => 'Закрити браузер';

  @override
  String get browserDismiss => 'Закрити повідомлення';

  @override
  String get browserLoading => 'Завантаження сторінки';

  @override
  String get browserLoadError =>
      'Не вдалося завантажити сторінку. Перевірте з’єднання та спробуйте ще раз.';

  @override
  String get browserBlocked =>
      'Тут можна відкривати лише захищені HTTPS-посилання.';

  @override
  String get browserUnsupported =>
      'Цей браузер не підтримує спливні вікна та завантаження файлів.';

  @override
  String get courseDocxNotice =>
      'Відкриється у застосунку для документів. Він може зберегти копію.';

  @override
  String get courseFileError =>
      'Не вдалося відкрити файл або посилання. Спробуйте знову.';

  @override
  String get courseNoHandler =>
      'Установіть застосунок для відкриття DOCX і спробуйте знову.';

  @override
  String get courseReadOnly =>
      'Лише перегляд. Спроби та надсилання робіт поки недоступні.';

  @override
  String get courseAvailable => 'Доступно';

  @override
  String get courseUpcoming => 'Ще не відкрито';

  @override
  String get courseClosed => 'Закрито';

  @override
  String get courseUnscheduled => 'Дати доступності не встановлено';

  @override
  String get courseOpens => 'Відкриття';

  @override
  String get courseCloses => 'Завершення';

  @override
  String get courseAttemptLimit => 'Дозволено спроб';

  @override
  String get courseTimeLimit => 'Обмеження часу у хвилинах';

  @override
  String get coursePrevious => 'Попередня діяльність';

  @override
  String get courseNext => 'Наступна діяльність';

  @override
  String get courseFile => 'Файл';

  @override
  String get courseLink => 'Посилання';

  @override
  String get courseAnnouncement => 'Оголошення';

  @override
  String get courseModule => 'Модуль';

  @override
  String get courseLab => 'Лабораторна робота';

  @override
  String get courseNoProgress => 'Прогресу поки немає';

  @override
  String get teachingTeaching => 'Викладання';

  @override
  String get teachingTeacherDefaults => 'Налаштування викладача';

  @override
  String get teachingAssignments => 'Завдання';

  @override
  String get teachingTests => 'Тести';

  @override
  String get teachingGradebook => 'Журнал оцінок';

  @override
  String get teachingStudents => 'Студенти';

  @override
  String get teachingCreateAssignment => 'Створити завдання';

  @override
  String get teachingCreateTest => 'Створити тест';

  @override
  String get teachingPendingGrading => 'Очікують оцінювання';

  @override
  String get teachingDrafts => 'Чернетки';

  @override
  String get teachingAwaitingRelease => 'Очікують оприлюднення';

  @override
  String get teachingNoTeachingCourses => 'Немає курсів для викладання';

  @override
  String get teachingNoActivitiesYet => 'Ще немає завдань';

  @override
  String get teachingTitle => 'Назва';

  @override
  String get teachingInstructions => 'Інструкції';

  @override
  String get teachingMaximumPoints => 'Максимальний бал';

  @override
  String get teachingRequiredActivity => 'Обов’язкове завдання';

  @override
  String get teachingAllowText => 'Дозволити текст';

  @override
  String get teachingAllowFile => 'Дозволити файл';

  @override
  String get teachingAttemptsAllowed => 'Кількість спроб';

  @override
  String get teachingTimeLimitMinutes => 'Ліміт часу (хвилини)';

  @override
  String get teachingShuffleQuestions => 'Перемішувати запитання';

  @override
  String get teachingOpens => 'Відкривається';

  @override
  String get teachingDeadline => 'Кінцевий термін';

  @override
  String get teachingSaveDraft => 'Зберегти чернетку';

  @override
  String get teachingPublish => 'Опублікувати';

  @override
  String get teachingSaveDefaults => 'Зберегти налаштування';

  @override
  String get teachingSaved => 'Збережено';

  @override
  String get teachingAddQuestion => 'Додати запитання';

  @override
  String get teachingQuestion => 'Запитання';

  @override
  String get teachingSingleChoice => 'Одна відповідь';

  @override
  String get teachingTrueOrFalse => 'Правда чи неправда';

  @override
  String get teachingOptionsOnePerLine => 'Варіанти (кожен з нового рядка)';

  @override
  String get teachingCorrectOptionNumber => 'Номер правильної відповіді';

  @override
  String get teachingPoints => 'Бали';

  @override
  String get teachingRemoveQuestion => 'Видалити запитання';

  @override
  String get teachingSection => 'Розділ';

  @override
  String get teachingEdit => 'Редагувати';

  @override
  String get teachingReleaseResults => 'Оприлюднити результати';

  @override
  String get teachingResultsHiddenUntilTeacherRelease =>
      'Результати приховано до оприлюднення викладачем';

  @override
  String get teachingStartTest => 'Почати тест';

  @override
  String get teachingSubmitTest => 'Завершити тест';

  @override
  String get teachingSaveAnswer => 'Зберегти відповідь';

  @override
  String get teachingYourResponse => 'Ваша відповідь';

  @override
  String get teachingAttachFile => 'Додати файл';

  @override
  String get teachingFileAttached => 'Файл додано';

  @override
  String get teachingSubmitAssignment => 'Надіслати завдання';

  @override
  String get teachingUnderReview => 'На перевірці';

  @override
  String get teachingPublished => 'Опубліковано';

  @override
  String get teachingDraft => 'Чернетка';

  @override
  String get teachingFeedback => 'Відгук';

  @override
  String get teachingGrade => 'Оцінка';

  @override
  String get teachingOpenFile => 'Відкрити файл';

  @override
  String get teachingReopen => 'Відкрити повторно';

  @override
  String get teachingRefresh => 'Оновити';

  @override
  String get teachingRetry => 'Повторити';

  @override
  String get teachingCancel => 'Скасувати';

  @override
  String get teachingNoSubmissionsYet => 'Ще немає робіт';

  @override
  String get teachingNoAttemptsYet => 'Ще немає спроб';

  @override
  String get teachingNotSubmitted => 'Не надіслано';

  @override
  String get teachingBestScore => 'Найкращий результат';

  @override
  String get teachingVersion => 'Версія';

  @override
  String get teachingSubmitted => 'Надіслано';

  @override
  String get teachingTimeRemaining => 'Залишилося часу';

  @override
  String get teachingNotGraded => 'Не оцінено';

  @override
  String get teachingCorrectAnswer => 'Правильна відповідь';

  @override
  String get teachingSelectASection => 'Виберіть розділ';

  @override
  String get teachingUnavailableCheckYourConnectionAndAccess =>
      'Недоступно. Перевірте з’єднання та права доступу.';

  @override
  String get teachingInvalidSettingsOrQuestionsCheckTheForm =>
      'Некоректні налаштування чи запитання. Перевірте форму.';

  @override
  String get teachingChangedElsewhereRefreshBeforeSaving =>
      'Дані змінено. Оновіть їх перед збереженням.';

  @override
  String get teachingSubmissionsAreClosedOrUnderReview =>
      'Прийом робіт завершено або робота на перевірці.';

  @override
  String get teachingCloseTheTestBeforeReleasingResults =>
      'Зачиніть тест перед оприлюдненням результатів.';

  @override
  String get teachingAttemptLimitReached => 'Вичерпано кількість спроб.';

  @override
  String get teachingUsePdfDocxJpegOrPngUpToMb =>
      'Використовуйте PDF, DOCX, JPEG або PNG до 20 МБ.';

  @override
  String get teachingCompleteTheRequiredFields => 'Заповніть обов’язкові поля.';

  @override
  String get teachingCloseTestNow => 'Завершити доступ до тесту';

  @override
  String get teachingViewWork => 'Переглянути роботу';

  @override
  String get teachingContinueTest => 'Продовжити тест';

  @override
  String get teachingNoStudentsYet => 'Ще немає студентів';

  @override
  String get teachingUploading => 'Завантаження';

  @override
  String get teachingYouHaveUnsavedChangesLeave =>
      'Є незбережені зміни. Вийти?';

  @override
  String get teachingLeave => 'Вийти';

  @override
  String get notebookSourcePassage => 'Уривок джерела';

  @override
  String get notebookVersion => 'версія';

  @override
  String get notebookConnectionUnavailableCloseAndTryAgain =>
      'Немає з’єднання. Закрийте та спробуйте ще раз.';

  @override
  String get notebookThisPassageIsNoLongerAvailableRefreshTheNotebook =>
      'Уривок більше недоступний. Оновіть блокнот.';

  @override
  String get notebookRemovePrivateFile => 'Видалити приватний файл';

  @override
  String get notebookChangingSourcesInvalidatesPreviousAnswers =>
      'Зміна джерел робить попередні відповіді неактуальними.';

  @override
  String get notebookRemove => 'Видалити';

  @override
  String get notebookSources => 'Джерела';

  @override
  String get notebookNotConfiguredYet => 'Ще не налаштовано';

  @override
  String get notebookYourTeacherHasNotConfiguredThisNotebookYet =>
      'Викладач ще не налаштував цей блокнот.';

  @override
  String get notebookAddASourceToGetStarted => 'Додайте джерело для початку';

  @override
  String get notebookChooseAPrivateFileOrWaitForCourseMaterials =>
      'Виберіть приватний файл або зачекайте на матеріали викладача.';

  @override
  String get notebookMyFiles => 'Мої файли';

  @override
  String get notebookCourseMaterials => 'Матеріали курсу';

  @override
  String get notebookReady => 'Готово';

  @override
  String
  get notebookFileScanningIsTemporarilyUnavailableTryUploadingAgainLater =>
      'Перевірка файлів тимчасово недоступна. Спробуйте завантажити пізніше.';

  @override
  String get notebookThisFileCouldNotPassTheSafetyCheckChoose =>
      'Цей файл не пройшов перевірку безпеки. Виберіть іншу копію.';

  @override
  String get notebookPasswordProtectedFilesCannotBeUsedAskYourTeacher =>
      'Захищені паролем файли не підтримуються. Попросіть викладача надати незахищену копію.';

  @override
  String get notebookNoReadableTextFoundAskYourTeacherForA =>
      'Не знайдено тексту для читання. Попросіть викладача надати текстову копію.';

  @override
  String get notebookThisFileIsTooLargeOrComplexAskYour =>
      'Цей файл завеликий або надто складний. Попросіть викладача надати меншу копію.';

  @override
  String get notebookThisDocumentContainsUnsupportedContentAskYourTeacherFor =>
      'Документ містить непідтримуваний вміст. Попросіть викладача надати звичайний документ.';

  @override
  String get notebookCouldNotPrepareSource => 'Не вдалося підготувати джерело';

  @override
  String get notebookPreparingSource => 'Підготовка джерела';

  @override
  String get notebookAddPrivateFile => 'Додати приватний файл';

  @override
  String get notebookUpTo25MiB => 'до 25 МіБ';

  @override
  String get notebookYourPrivateStudySpace =>
      'Ваш приватний простір для навчання';

  @override
  String get notebookAskAQuestionCheckTheEvidenceKeepLearning =>
      'Запитуйте. Перевіряйте джерела. Продовжуйте навчатися.';

  @override
  String get notebookSelectAReadySourceInSourcesToAskA =>
      'Виберіть готове джерело у вкладці «Джерела», щоб запитати.';

  @override
  String get notebookSummarizeSelectedSources => 'Підсумуй вибрані джерела';

  @override
  String get notebookExplainKeyConcepts => 'Поясни ключові поняття';

  @override
  String get notebookHelpMeRevise => 'Допоможи повторити матеріал';

  @override
  String get notebookPreparingYourFile => 'Підготовка файлу…';

  @override
  String get notebookWaitingToPrepareYourAnswer =>
      'Очікування підготовки відповіді…';

  @override
  String get notebookPreparingYourAnswer => 'Підготовка відповіді…';

  @override
  String get notebookNewResponse => 'Нова відповідь';

  @override
  String get notebookAskAboutYourSources => 'Запитайте про джерела';

  @override
  String get notebookAsk => 'Запитати';

  @override
  String get notebookStudyAssistant => 'Навчальний помічник';

  @override
  String get notebookSourcesChangedAskAgainForAnUpdatedAnswer =>
      'Джерела змінилися. Поставте запитання ще раз.';

  @override
  String get notebookCopyAnswer => 'Копіювати відповідь';

  @override
  String get notebookAnswerCopied => 'Відповідь скопійовано';

  @override
  String get notebookStudyNotebook => 'Навчальний блокнот';

  @override
  String get notebookRefresh => 'Оновити';

  @override
  String get notebookConnectionUnavailableYourWorkIsStillHere =>
      'Немає з’єднання. Ваші дані збережено на екрані.';

  @override
  String get notebookSelectAReadySourceFirst =>
      'Спочатку виберіть готове джерело.';

  @override
  String get notebookTheStudyAssistantHasReachedItsUsageLimit =>
      'Навчальний помічник досяг ліміту використання.';

  @override
  String get notebookSourcesChangedRefreshBeforeAskingAgain =>
      'Джерела змінилися. Оновіть перед новим запитанням.';

  @override
  String get notebookChooseAnAllowedDocumentUpTo25MB =>
      'Виберіть документ дозволеного формату до 25 МБ.';

  @override
  String get notebookFileLimitReachedRemoveAnOldPrivateFileOr =>
      'Досягнуто ліміту файлів. Видаліть старий приватний файл або спробуйте завтра.';

  @override
  String get notebookNotebookUnavailableRefreshToTryAgain =>
      'Блокнот недоступний. Спробуйте оновити.';

  @override
  String get notebookProcessingFailed =>
      'Не вдалося завершити обробку. Спробуйте ще раз.';

  @override
  String get notebookCheckAgain => 'Перевірити знову';

  @override
  String get notebookChat => 'Чат';

  @override
  String notebookEvidence(int ready, int excluded) {
    String _temp0 = intl.Intl.pluralLogic(
      ready,
      locale: localeName,
      other: '$ready готового джерела',
      many: '$ready готових джерел',
      few: '$ready готові джерела',
      one: '$ready готове джерело',
      zero: 'Немає готових джерел',
    );
    return '$_temp0 · $excluded недоступних';
  }

  @override
  String get googleUnavailable => 'Вхід через Google не налаштовано.';

  @override
  String get googleLink => 'Пов’язати Google';

  @override
  String get googleLinked => 'Google пов’язано';

  @override
  String get googleProofInvalid =>
      'Не вдалося перевірити вхід через Google. Спробуйте ще раз.';

  @override
  String get googleLinkRequired =>
      'Увійдіть наявним способом і пов’яжіть Google у профілі.';

  @override
  String get googleEmailMismatch =>
      'Оберіть Google з тією самою адресою, що й у Poodle.';

  @override
  String get googleLinkConflict =>
      'Цей обліковий запис Google неможливо пов’язати.';

  @override
  String get invitationUnavailable =>
      'Для приєднання до Poodle потрібне чинне запрошення.';

  @override
  String get searchQueryLabel => 'Пошук у матеріалах курсів';

  @override
  String get searchQueryTooLong => 'Введіть не більше ніж 500 символів.';

  @override
  String get searchQueryInvalid =>
      'Введіть запит до 500 символів без керівних символів.';

  @override
  String get searchClearQuery => 'Очистити запит';

  @override
  String get searchCourseFilter => 'Фільтр за курсом';

  @override
  String get searchFilters => 'Фільтри';

  @override
  String get searchTypeFilter => 'Тип матеріалу';

  @override
  String get searchAllCourses => 'Усі курси';

  @override
  String get searchAllKinds => 'Усі типи';

  @override
  String get searchActivities => 'Активності';

  @override
  String get searchLoading => 'Пошук у матеріалах курсів';

  @override
  String get searchOffline => 'Для пошуку потрібне підключення до інтернету.';

  @override
  String get searchFailed => 'Пошук недоступний.';

  @override
  String get searchIntro =>
      'Опишіть українською або англійською, що хочете знайти. Пошук знайде пов’язані теми у ваших курсах.';

  @override
  String get searchRecent => 'Нещодавні запити';

  @override
  String get searchNoRecent => 'Нещодавніх запитів немає. Спробуйте пошукати.';

  @override
  String searchRemoveRecent(String query) {
    return 'Видалити нещодавній запит: $query';
  }

  @override
  String get searchClearRecent => 'Очистити всі нещодавні запити';

  @override
  String get searchHistoryFailed => 'Не вдалося оновити нещодавні запити.';

  @override
  String get searchNoMatches => 'Нічого не знайдено';

  @override
  String get searchNoMatchesHint =>
      'Спробуйте інші ключові слова або змініть фільтри.';

  @override
  String get searchClearSearch => 'Очистити пошук';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count результату',
      many: '$count результатів',
      few: '$count результати',
      one: '$count результат',
    );
    return '$_temp0';
  }

  @override
  String get searchKeywordOnly =>
      'Пошук за змістом недоступний. Показано збіги за ключовими словами.';

  @override
  String get searchIncomplete =>
      'Деякі матеріали курсів можуть ще не відображатися в пошуку.';

  @override
  String get searchCapped =>
      'Показано 50 найкращих результатів. Уточніть запит, щоб звузити пошук.';

  @override
  String searchPage(int page) {
    return 'Сторінка $page';
  }

  @override
  String get searchFileExcerpt => 'Уривок із файлу';

  @override
  String get studioTitle => 'Студія';

  @override
  String get studioIntro => 'Створюйте навчальні матеріали з вибраних джерел.';

  @override
  String get studioLibrary => 'Ваші навчальні матеріали';

  @override
  String get studioEmpty => 'Навчальних матеріалів поки немає.';

  @override
  String get studioQuiz => 'Тест для практики';

  @override
  String get studioAudio => 'Аудіоогляд';

  @override
  String get studioFlashcards => 'Картки';

  @override
  String get studioLanguage => 'Мова матеріалу';

  @override
  String get studioGenerate => 'Створити';

  @override
  String get studioQueued => 'У черзі';

  @override
  String get studioProcessing => 'Створення…';

  @override
  String get studioStale => 'Джерела змінилися. Створіть матеріал повторно.';

  @override
  String get studioInsufficient =>
      'Недостатньо інформації. Спробуйте додати джерела.';

  @override
  String get studioAudioUnavailable => 'Аудіо недоступне. Спробуйте ще раз.';

  @override
  String get studioTranscript => 'Стенограма';

  @override
  String get studioShowFront => 'Показати запитання';

  @override
  String get studioShowAnswer => 'Показати відповідь';

  @override
  String get studioPrevious => 'Назад';

  @override
  String get studioNext => 'Далі';

  @override
  String studioScore(int score, int total) {
    return 'Результат: $score / $total';
  }

  @override
  String get studioRestart => 'Почати спочатку';

  @override
  String get studioYourAnswer => 'Ваша відповідь';

  @override
  String get studioCorrect => 'Правильно';

  @override
  String get studioIncorrect => 'Неправильно';

  @override
  String get studioPause => 'Призупинити';

  @override
  String get studioPlay => 'Відтворити';

  @override
  String get homeNextUp => 'Найближчі завдання';

  @override
  String get homeStudyCourses => 'Курси, які я вивчаю';

  @override
  String get homeTeachCourses => 'Курси, які я викладаю';

  @override
  String get homeCreate => 'Створити';

  @override
  String get homeChooseCourse => 'Оберіть курс';

  @override
  String get homePlatform => 'Огляд платформи';

  @override
  String get homeAccounts => 'Облікові записи';

  @override
  String get homeStudents => 'Студенти';

  @override
  String get homeTeachers => 'Викладачі';

  @override
  String get homeAdmins => 'Адміністратори';

  @override
  String get homeInvitations => 'Очікують запрошення';

  @override
  String get homeOverlap => 'Людина може належати до кількох категорій.';

  @override
  String get homeMore => 'Завантажити ще';

  @override
  String get homeEmpty => 'Тут поки нічого немає.';

  @override
  String get homeError => 'Не вдалося завантажити. Спробуйте ще раз.';

  @override
  String get homeMyCourses => 'Мої курси';

  @override
  String get institutionRequestTitle => 'Доступ університету';

  @override
  String get institutionRequestIntro =>
      'Розкажіть про університет. Підтвердьте пошту, а ми зв’яжемося з університетом, щоб перевірити ваші повноваження.';

  @override
  String get institutionName => 'Повне ім’я';

  @override
  String get institutionUniversity => 'Університет';

  @override
  String get institutionPosition => 'Посада';

  @override
  String get institutionNote => 'Примітка (необов’язково)';

  @override
  String get institutionRequired => 'Заповніть обов’язкові поля.';

  @override
  String get institutionSendCode => 'Надіслати код підтвердження';

  @override
  String get institutionVerify => 'Підтвердити пошту';

  @override
  String get institutionAwaitingReview => 'Ваш запит очікує на розгляд.';

  @override
  String get institutionLastAdmin =>
      'Додайте ще одного адміністратора, перш ніж видаляти останнього.';

  @override
  String get institutionConflict =>
      'Ця пошта вже має доступ або запрошення до іншого університету чи ролі.';

  @override
  String get institutionInvalidCode =>
      'Код недійсний або прострочений. Запросіть новий код.';

  @override
  String get institutionContactPrompt => 'Ви адміністратор університету?';

  @override
  String get institutionContactAction => 'Зв’яжіться з нами';

  @override
  String get institutionOperator => 'Запити університетів';

  @override
  String get institutionApplicant => 'Заявник';

  @override
  String get institutionReviewDecision => 'Рішення щодо запиту';

  @override
  String get institutionUniversityAssignment => 'Призначення університету';

  @override
  String get institutionReviewNoteRequired =>
      'Для будь-якого рішення потрібна примітка.';

  @override
  String get institutionRequestUnavailable => 'Цей запит більше недоступний.';

  @override
  String get institutionNewRequestAlert => 'Новий запит університету';

  @override
  String get institutionNewRequestsAlert =>
      'Нові запити університетів очікують розгляду';

  @override
  String institutionPendingCount(int count) {
    return 'Очікують розгляду: $count';
  }

  @override
  String get institutionAdmin => 'Адміністрування університету';

  @override
  String get institutionTeaching => 'Керувати моїми курсами';

  @override
  String get institutionApprove => 'Схвалити й запросити';

  @override
  String get institutionReject => 'Відхилити запит';

  @override
  String get institutionReviewNote => 'Результати перевірки / причина відмови';

  @override
  String get institutionSlug => 'Назва університету для URL';

  @override
  String get institutionNewUniversity => 'Створити новий університет';

  @override
  String get institutionReviewIntro =>
      'Перед схваленням підтвердьте повноваження представника в університеті.';

  @override
  String get institutionEmpty => 'Тут поки порожньо.';

  @override
  String get institutionMembers => 'Учасники';

  @override
  String get institutionTeacher => 'Викладач';

  @override
  String get institutionAdministrator => 'Адміністратор університету';

  @override
  String get institutionStudent => 'Студент';

  @override
  String get institutionGrantAdmin => 'Надати права адміністратора';

  @override
  String get institutionRemoveAdmin => 'Зняти права адміністратора';

  @override
  String get institutionInviteSent =>
      'Доступ оновлено або запрошення додано до черги надсилання.';

  @override
  String get institutionCreateCourse => 'Створити курс';

  @override
  String get institutionCourseTitle => 'Назва курсу';

  @override
  String get institutionPublish => 'Опублікувати курс';

  @override
  String get institutionUnpublish => 'Зробити чернеткою';

  @override
  String get institutionDraft => 'Чернетка — доступна лише викладачам';

  @override
  String get institutionPublished => 'Опубліковано';

  @override
  String get institutionInviteStudent => 'Запросити студента';

  @override
  String get institutionEditCourse => 'Редагувати вміст курсу';

  @override
  String get institutionPending => 'Очікує на розгляд';

  @override
  String get institutionApproved => 'Схвалено';

  @override
  String get institutionRejected => 'Відхилено';

  @override
  String get institutionRefresh => 'Оновити';

  @override
  String get institutionForbidden => 'У вас немає доступу до цієї дії.';

  @override
  String get messagesDrafts => 'Мої чернетки';

  @override
  String get messagesDraftsDescription =>
      'Зберігайте нотатки й повідомлення для себе';

  @override
  String get messagesNoRecipients =>
      'Поки що немає одногрупників чи викладачів, яким можна написати.';

  @override
  String get messagesNew => 'Нове повідомлення';

  @override
  String get messagesLoadError => 'Не вдалося завантажити повідомлення.';

  @override
  String get messagesRetry => 'Повторити';

  @override
  String get messagesDraftsHint => 'Збережіть нотатку на потім';

  @override
  String get messagesEmptyThread => 'Повідомлень ще немає';

  @override
  String get messagesReadOnly =>
      'Цю розмову можна лише переглядати, бо у вас більше немає спільного активного курсу.';

  @override
  String get messagesComposerHint => 'Напишіть повідомлення';

  @override
  String get messagesSend => 'Надіслати повідомлення';

  @override
  String get messagesIncomingAlert =>
      'Нове повідомлення. Натисніть, щоб переглянути.';

  @override
  String get messagesOpenError =>
      'Не вдалося відкрити повідомлення. Спробуйте ще раз.';

  @override
  String get messageToday => 'Сьогодні';

  @override
  String get messageYesterday => 'Учора';

  @override
  String get notebookSaveNote => 'Зберегти нотатку';

  @override
  String get notebookSavedNotes => 'Збережені нотатки';

  @override
  String get notebookNoteSaved => 'Нотатку збережено';

  @override
  String get notebookSaveNoteFailed => 'Не вдалося зберегти нотатку';

  @override
  String get notebookNoSavedNotes => 'Немає нотаток';

  @override
  String get notebookDeleteNote => 'Видалити нотатку';

  @override
  String get notebookDeleteNoteConfirm => 'Видалити нотатку?';

  @override
  String get notebookDeleteNoteFailed => 'Не вдалося видалити нотатку';
}
