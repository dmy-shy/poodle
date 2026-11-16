import '../../../../ui/components/confirmation_actions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../../../data/repositories/course_repository.dart';
import '../../../../data/services/course_download_service.dart';
import '../../../../data/services/course_file_service.dart';

class SpaceUsageScreen extends StatefulWidget {
  const SpaceUsageScreen({
    super.key,
    required this.downloads,
    required this.files,
    this.downloadsPage = false,
  });
  final CourseDownloadService downloads;
  final CourseFileService files;
  final bool downloadsPage;
  @override
  State<SpaceUsageScreen> createState() => _SpaceUsageScreenState();
}

class _SpaceUsageScreenState extends State<SpaceUsageScreen> {
  late Future<List<DownloadedCourseFile>> _items;
  String? _refreshing, _failure;
  String? _failedCourse;
  int _done = 0, _total = 0;
  @override
  void initState() {
    super.initState();
    _items = widget.downloads.list();
    widget.downloads.addListener(_reload);
  }

  @override
  void dispose() {
    widget.downloads.removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    if (mounted) {
      setState(() {
        _items = widget.downloads.list();
      });
    }
  }

  String _size(int bytes) => bytes >= 1024 * 1024
      ? '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB'
      : '${(bytes / 1024).ceil()} KB';

  Future<void> _refresh(String courseId) async {
    final account = widget.downloads.currentAccount;
    final generation = widget.downloads.generation;
    setState(() {
      _refreshing = courseId;
      _failure = null;
      _failedCourse = courseId;
      _done = _total = 0;
    });
    try {
      await widget.downloads.refreshDownloadedFiles(
        courseId,
        onProgress: (done, total) {
          if (mounted &&
              widget.downloads.currentAccount == account &&
              widget.downloads.generation == generation) {
            setState(() {
              _done = done;
              _total = total;
            });
          }
        },
      );
      if (mounted &&
          widget.downloads.currentAccount == account &&
          widget.downloads.generation == generation) {
        _reload();
      }
    } on CourseFailure catch (error) {
      if (mounted && widget.downloads.currentAccount == account) {
        setState(() => _failure = error.name);
      }
    } catch (_) {
      if (mounted && widget.downloads.currentAccount == account) {
        setState(() => _failure = 'file');
      }
    } finally {
      if (mounted) setState(() => _refreshing = null);
    }
  }

  Future<void> _remove(String courseId) async {
    final account = widget.downloads.currentAccount;
    final generation = widget.downloads.generation;
    final uk = Localizations.localeOf(context).languageCode == 'uk';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(uk ? 'Видалити офлайн-копії?' : 'Remove offline copies?'),
        content: Text(
          uk
              ? 'Збережені файли цього курсу буде видалено з пристрою.'
              : 'Saved files for this course will be removed from this device.',
        ),
        actions: [
          ConfirmationActions(
            cancel: uk ? 'Скасувати' : 'Cancel',
            confirm: uk ? 'Видалити' : 'Remove',
            destructive: true,
          ),
        ],
      ),
    );
    if (confirmed != true ||
        !mounted ||
        widget.downloads.generation != generation) {
      return;
    }
    try {
      await widget.downloads.removeCourse(courseId);
      if (mounted && widget.downloads.currentAccount == account) _reload();
    } catch (_) {
      if (mounted && widget.downloads.currentAccount == account) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              uk
                  ? 'Не вдалося видалити файли.'
                  : 'Could not remove saved files.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _open(DownloadedCourseFile item) async {
    final uk = Localizations.localeOf(context).languageCode == 'uk';
    final account = widget.downloads.currentAccount;
    final generation = widget.downloads.generation;
    final path = await widget.downloads.validatedPath(item);
    if (!mounted ||
        widget.downloads.currentAccount != account ||
        widget.downloads.generation != generation) {
      return;
    }
    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            uk
                ? 'Файл відсутній або пошкоджений. Оновіть збережені файли.'
                : 'File is missing or damaged. Refresh saved files.',
          ),
        ),
      );
      return;
    }
    try {
      if (path.endsWith('.pdf')) {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              appBar: AppBar(title: Text(item.title)),
              body: PdfViewer.file(path),
            ),
          ),
        );
      } else {
        await widget.files.openDocument(path);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              uk ? 'Не вдалося відкрити файл.' : 'Could not open file.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uk = Localizations.localeOf(context).languageCode == 'uk';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.downloadsPage
              ? (uk ? 'Завантаження' : 'Downloads')
              : (uk ? 'Використання пам’яті' : 'Space usage'),
        ),
      ),
      body: FutureBuilder<List<DownloadedCourseFile>>(
        key: ValueKey(widget.downloads.currentAccount),
        future: _items,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: snapshot.hasError
                  ? Text(
                      uk
                          ? 'Не вдалося відкрити завантаження.'
                          : 'Could not open downloads.',
                    )
                  : const CircularProgressIndicator(),
            );
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.download_outlined, size: 56),
                  const SizedBox(height: 12),
                  Text(
                    uk ? 'Немає завантажених файлів.' : 'No downloaded files.',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    uk
                        ? 'Збережіть файли на сторінці курсу.'
                        : 'Save files from a course to use them offline.',
                  ),
                  TextButton(
                    onPressed: () => context.go('/courses'),
                    child: Text(uk ? 'Перейти до курсів' : 'Go to Courses'),
                  ),
                ],
              ),
            );
          }
          final grouped = <String, List<DownloadedCourseFile>>{};
          for (final item in items) {
            grouped.putIfAbsent(item.courseId, () => []).add(item);
          }
          final bytes = items.fold<int>(0, (sum, item) => sum + item.sizeBytes);
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${uk ? 'Загалом збережено' : 'Total storage'}: ${_size(bytes)}',
                ),
              ),
              for (final entry in grouped.entries) ...[
                ListTile(
                  title: Text(
                    entry.value.first.courseTitle.isNotEmpty
                        ? entry.value.first.courseTitle
                        : entry.key,
                  ),
                  subtitle: Text(
                    '${entry.value.length} ${uk ? 'файлів' : 'files'} · '
                    '${_size(entry.value.fold<int>(0, (sum, item) => sum + item.sizeBytes))}',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _refreshing == null
                            ? () => _refresh(entry.key)
                            : null,
                        icon: const Icon(Icons.refresh),
                        label: Text(
                          uk
                              ? 'Оновити збережені файли'
                              : 'Refresh saved files',
                        ),
                      ),
                      IconButton(
                        tooltip: uk
                            ? 'Видалити локальне завантаження'
                            : 'Remove local download',
                        onPressed: _refreshing == null
                            ? () => _remove(entry.key)
                            : null,
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
                if (_refreshing == entry.key) ...[
                  LinearProgressIndicator(
                    value: _total == 0 ? null : _done / _total,
                  ),
                  Text('${uk ? 'Оновлено' : 'Updated'}: $_done / $_total'),
                  TextButton(
                    onPressed: widget.downloads.cancel,
                    child: Text(uk ? 'Скасувати' : 'Cancel'),
                  ),
                ],
                if (_refreshing == null &&
                    _failure != null &&
                    _failedCourse == entry.key) ...[
                  Text(
                    _failure == CourseFailure.wifiRequired.name
                        ? (uk
                              ? 'Потрібен Wi-Fi для оновлення.'
                              : 'Wi-Fi is required to refresh.')
                        : (uk
                              ? 'Не вдалося оновити файли. Спробуйте ще раз.'
                              : 'Could not refresh files. Try again.'),
                  ),
                  TextButton(
                    onPressed: () => _refresh(entry.key),
                    child: Text(uk ? 'Повторити' : 'Retry'),
                  ),
                ],
                for (final item in entry.value)
                  ListTile(
                    leading: Icon(
                      item.path.endsWith('.pdf')
                          ? Icons.picture_as_pdf
                          : Icons.description,
                    ),
                    title: Text(item.title),
                    subtitle: Text(_size(item.sizeBytes)),
                    onTap: () => _open(item),
                  ),
                const Divider(),
              ],
            ],
          );
        },
      ),
    );
  }
}

class DownloadsUnavailableScreen extends StatelessWidget {
  const DownloadsUnavailableScreen({super.key, required this.preview});
  final bool preview;
  @override
  Widget build(BuildContext context) {
    final uk = Localizations.localeOf(context).languageCode == 'uk';
    return Scaffold(
      appBar: AppBar(title: Text(uk ? 'Завантаження' : 'Downloads')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            preview
                ? (uk
                      ? 'Офлайн-завантаження недоступні.'
                      : 'Offline downloads are unavailable.')
                : (uk
                      ? 'Офлайн-завантаження недоступні у браузері. Скористайтеся мобільним застосунком.'
                      : 'Offline downloads are unavailable on web. Use the mobile app.'),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
