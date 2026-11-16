import 'package:flutter/foundation.dart';
import '../../../../data/repositories/admin_overview_repository.dart';

class AdminDirectoryViewModel extends ChangeNotifier {
  AdminDirectoryViewModel(this.repository, this.category);
  final AdminOverviewRepository repository;
  final String category;
  final _rows = <AdminDirectoryRow>[];
  List<AdminDirectoryRow> get rows => List.unmodifiable(_rows);
  bool busy = false, failed = false, more = true, _disposed = false;
  Future<void> load() async {
    if (busy || _disposed) return;
    busy = true;
    failed = false;
    notifyListeners();
    try {
      final page = await repository.list(category, _rows.length);
      if (_disposed) return;
      _rows.addAll(page);
      more = page.length == 50;
    } catch (_) {
      if (!_disposed) failed = true;
    } finally {
      if (!_disposed) {
        busy = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
