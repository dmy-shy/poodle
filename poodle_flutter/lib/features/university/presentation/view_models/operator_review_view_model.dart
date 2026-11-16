import 'package:flutter/foundation.dart';
import '../../../../data/repositories/institution_repository.dart';

class OperatorReviewViewModel extends ChangeNotifier {
  OperatorReviewViewModel(this._repository, {this.focusId, this.onReviewed});
  final InstitutionRepository _repository;
  final String? focusId;
  final VoidCallback? onReviewed;
  bool focusUnavailable = false;
  List<AdministratorRequest> requests = [];
  List<UniversityOption> universities = [];
  bool busy = false, _disposed = false;
  String? error;
  int offset = 0;
  Future<void> load() => _run(_load);
  Future<void> _load() async {
    final page = await _repository.requests(offset);
    final focused = focusId == null
        ? null
        : await _repository.request(focusId!);
    focusUnavailable = focusId != null && focused == null;
    requests = [
      ?focused,
      ...page.where((item) => item.id != focused?.id),
    ];
    universities = await _repository.universities();
  }

  Future<void> page(int delta) async {
    offset = (offset + 20 * delta).clamp(0, 100000);
    await load();
  }

  Future<void> reject(String id, String reason) => _run(() async {
    if (reason.trim().isEmpty) throw const InstitutionProblem('invalid_input');
    await _repository.reject(id, reason.trim());
    await _load();
    onReviewed?.call();
  });
  Future<void> approve(
    AdministratorRequest request, {
    String? universityId,
    required String name,
    required String slug,
    required String note,
  }) => _run(() async {
    if (note.trim().isEmpty ||
        (universityId == null &&
            (name.trim().isEmpty ||
                !RegExp(r'^[a-z0-9][a-z0-9-]{1,79}$').hasMatch(slug.trim())))) {
      throw const InstitutionProblem('invalid_input');
    }
    await _repository.approve(
      request,
      universityId: universityId,
      name: name.trim(),
      slug: slug.trim(),
      note: note.trim(),
    );
    await _load();
    onReviewed?.call();
  });
  Future<void> _run(Future<void> Function() action) async {
    if (busy || _disposed) return;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } on InstitutionProblem catch (e) {
      error = e.code;
    } catch (_) {
      error = 'unavailable';
    }
    if (!_disposed) {
      busy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
