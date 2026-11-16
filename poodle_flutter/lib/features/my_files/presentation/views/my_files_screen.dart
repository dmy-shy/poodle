import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_client/poodle_client.dart' show MyUpload;
import '../../../../data/repositories/my_files_repository.dart';
import '../view_models/my_files_view_model.dart';

export '../view_models/my_files_view_model.dart' show MyFilesFilter;

class MyFilesScreen extends StatefulWidget {
  const MyFilesScreen({super.key, required this.repository});
  final MyFilesRepository repository;

  @override
  State<MyFilesScreen> createState() => _MyFilesScreenState();
}

class _MyFilesScreenState extends State<MyFilesScreen> {
  late final MyFilesViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = MyFilesViewModel(widget.repository);
  }

  void _retry() {
    setState(() {
      _model.reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    final uk = Localizations.localeOf(context).languageCode == 'uk';
    String label(MyFilesFilter filter) => switch (filter) {
      MyFilesFilter.all => uk ? 'Усі' : 'All',
      MyFilesFilter.notebook => uk ? 'Нотатник' : 'Notebook',
      MyFilesFilter.assignments => uk ? 'Завдання' : 'Assignments',
    };
    return Scaffold(
      appBar: AppBar(title: Text(uk ? 'Мої файли' : 'My files')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<MyFilesFilter>(
              segments: [
                for (final filter in MyFilesFilter.values)
                  ButtonSegment(value: filter, label: Text(label(filter))),
              ],
              selected: {_model.filter},
              onSelectionChanged: (value) =>
                  setState(() => _model.filter = value.first),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MyUpload>>(
              future: _model.result,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: TextButton(
                      onPressed: _retry,
                      child: Text(uk ? 'Повторити' : 'Retry'),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final files = _model.visibleFiles(snapshot.data!);
                if (files.isEmpty) {
                  return Center(
                    child: Text(uk ? 'Файлів немає' : 'No files yet'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    _retry();
                    await _model.result;
                  },
                  child: ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      final date = MaterialLocalizations.of(
                        context,
                      ).formatMediumDate(file.uploadedAt.toLocal());
                      final kind = file.kind == 'notebook'
                          ? (uk ? 'Нотатник' : 'Notebook')
                          : (uk ? 'Завдання' : 'Assignment');
                      return ListTile(
                        key: ValueKey(file.id.toString()),
                        leading: Icon(
                          file.kind == 'notebook'
                              ? Icons.auto_stories_outlined
                              : Icons.attach_file,
                        ),
                        title: Text(file.fileName),
                        subtitle: Text(
                          [
                            '$kind · $date',
                            '${file.courseTitle} · ${file.activityTitle}',
                            ?file.processingStatus,
                          ].join('\n'),
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(
                          '/courses/${file.courseId}/activity/${file.activityId}/${file.kind == 'notebook' ? 'notebook' : 'work'}',
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
