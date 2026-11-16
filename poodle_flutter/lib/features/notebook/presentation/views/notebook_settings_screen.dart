import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/notebook_repository.dart';
import '../view_models/notebook_settings_view_model.dart';

class NotebookSettingsScreen extends StatelessWidget {
  const NotebookSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final model = context.watch<NotebookSettingsViewModel>();
    final uk = Localizations.localeOf(context).languageCode == 'uk';
    String text(String en, String ua) => uk ? ua : en;
    final setup = model.setup;
    return Scaffold(
      appBar: AppBar(
        title: Text(text('Notebook settings', 'Налаштування блокнота')),
        actions: [
          IconButton(
            tooltip: text('Refresh', 'Оновити'),
            onPressed: model.busy ? null : model.load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              20 + MediaQuery.paddingOf(context).bottom,
            ),
            children: [
              if (model.busy) const LinearProgressIndicator(),
              if (model.error != null) ...[
                Text(
                  model.error == NotebookFailure.changed
                      ? text(
                          'Another teacher changed these settings. Refresh before saving again.',
                          'Інший викладач змінив налаштування. Оновіть їх перед збереженням.',
                        )
                      : model.error == NotebookFailure.network
                      ? text(
                          'Connection unavailable. Refresh before trying again.',
                          'Немає з’єднання. Оновіть перед повторною спробою.',
                        )
                      : text(
                          'Settings unavailable. Refresh to check your access.',
                          'Налаштування недоступні. Оновіть, щоб перевірити доступ.',
                        ),
                ),
                TextButton(
                  onPressed: model.busy ? null : model.load,
                  child: Text(text('Refresh settings', 'Оновити налаштування')),
                ),
              ],
              if (setup != null) ...[
                Text(
                  text(
                    'Choose course materials students can use to prepare for this module or test.',
                    'Виберіть матеріали курсу для підготовки студентів до цього модуля або тесту.',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  text('Shared materials', 'Спільні матеріали'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  text(
                    'Published PDF, DOCX, TXT and Markdown files up to 25 MB are available here.',
                    'Тут доступні опубліковані PDF, DOCX, TXT і Markdown файли до 25 МБ.',
                  ),
                ),
                if (setup.materials.isEmpty)
                  Text(
                    text(
                      'Publish a supported course file first.',
                      'Спочатку опублікуйте файл курсу підтримуваного формату.',
                    ),
                  ),
                for (final material in setup.materials)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(material.title),
                    subtitle: Text(material.format.toUpperCase()),
                    value: model.materials.contains(material.id),
                    onChanged: model.busy || model.needsReload
                        ? null
                        : (v) => model.material(material.id, v ?? false),
                  ),
                for (final missing in model.materials.where(
                  (id) => !setup.materials.any((m) => m.id == id),
                ))
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      text(
                        'Previously selected material is no longer available. Uncheck it to continue.',
                        'Раніше вибраний матеріал більше недоступний. Зніміть позначку, щоб продовжити.',
                      ),
                    ),
                    value: true,
                    onChanged: model.busy || model.needsReload
                        ? null
                        : (_) => model.material(missing, false),
                  ),
                const SizedBox(height: 16),
                Text(
                  text(
                    'Allowed private-upload formats',
                    'Дозволені формати приватних файлів',
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  text(
                    'Leave all formats unselected to use only shared course materials. Student notebooks stay private.',
                    'Не вибирайте жодного формату, щоб використовувати лише спільні матеріали курсу. Блокноти студентів залишаються приватними.',
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final format in ['pdf', 'docx', 'txt', 'md'])
                      FilterChip(
                        label: Text(format.toUpperCase()),
                        selected: model.formats.contains(format),
                        onSelected: model.busy || model.needsReload
                            ? null
                            : (v) => model.format(format, v),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  text(
                    'Select at least one shared material. Changes make earlier answers out of date.',
                    'Виберіть хоча б один спільний матеріал. Після змін попередні відповіді стануть застарілими.',
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: model.canSave ? model.save : null,
                  child: Text(
                    text(
                      'Save notebook settings',
                      'Зберегти налаштування блокнота',
                    ),
                  ),
                ),
                if (model.saved)
                  Text(
                    text(
                      'Notebook settings saved.',
                      'Налаштування блокнота збережено.',
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
