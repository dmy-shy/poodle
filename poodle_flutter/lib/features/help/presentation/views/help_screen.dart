import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Local help content; opening an answer never needs a connection.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uk = Localizations.localeOf(context).languageCode == 'uk';
    final entries = uk ? _uk : _en;
    return Scaffold(
      appBar: AppBar(
        title: Text(uk ? 'Допомога' : 'Help'),
        leading: BackButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/more'),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              uk ? 'Поширені запитання' : 'Frequently asked questions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          for (final (question, answer) in entries)
            ExpansionTile(
              title: Text(question),
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              expandedAlignment: Alignment.centerLeft,
              children: [Text(answer)],
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(uk ? 'Профіль' : 'Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: Text(uk ? 'Синхронізація' : 'Synchronisation'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/more/feature/settings/synchronisation'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(uk ? 'Про застосунок' : 'About'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/more/feature/settings/about'),
          ),
        ],
      ),
    );
  }
}

const _en = <(String, String)>[
  (
    'Where can I find my work and grades?',
    'Open Tasks or Grades from More. Your course activities can also show assigned work. Refresh when you reconnect to see recent changes.',
  ),
  (
    'How do offline copies work?',
    'Open a course and download available files while connected. Saved copies remain available offline on this device. Changes made elsewhere appear after you reconnect and synchronise.',
  ),
  (
    'Who can see my uploads?',
    'Uploads belong to the course activity where you submit them. Check the activity instructions before uploading private material. Do not share sensitive information unless the activity requires it.',
  ),
  (
    'How can I recover my account?',
    'On the sign-in screen, choose Forgot password to request a recovery code for your email. If you use Google sign-in, use the same Google account. Your Profile shows your account email.',
  ),
  (
    'Why are my changes not syncing?',
    'Check your connection, then open Settings → Synchronisation to review pending work and retry. Keep the app open while it syncs. If a download is missing, reconnect and open the course again.',
  ),
];

const _uk = <(String, String)>[
  (
    'Де знайти завдання й оцінки?',
    'Відкрийте «Завдання» або «Оцінки» в розділі «Ще». Призначені завдання також можуть бути в курсі. Після відновлення зв’язку оновіть дані.',
  ),
  (
    'Як працюють офлайн-копії?',
    'Відкрийте курс і завантажте доступні файли за наявності з’єднання. Збережені копії доступні офлайн на цьому пристрої. Зміни з інших пристроїв з’являться після синхронізації.',
  ),
  (
    'Хто бачить мої завантаження?',
    'Завантажені файли належать до завдання курсу, у якому їх подано. Перед завантаженням приватних матеріалів перевірте інструкції. Не додавайте чутливі дані без потреби.',
  ),
  (
    'Як відновити доступ до облікового запису?',
    'На екрані входу виберіть «Забули пароль?», щоб отримати код відновлення на електронну пошту. Для входу через Google використовуйте той самий обліковий запис. Адресу пошти видно в профілі.',
  ),
  (
    'Чому зміни не синхронізуються?',
    'Перевірте з’єднання, потім відкрийте «Налаштування → Синхронізація», щоб переглянути очікувані зміни й повторити спробу. Не закривайте застосунок під час синхронізації. Якщо файлу немає, підключіться до мережі та знову відкрийте курс.',
  ),
];
