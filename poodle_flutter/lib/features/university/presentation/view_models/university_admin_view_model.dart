import 'package:flutter/foundation.dart';
import '../../../../data/repositories/institution_repository.dart';

class UniversityAdminViewModel extends ChangeNotifier {
  UniversityAdminViewModel(this._repository);
  final InstitutionRepository _repository;
  List<UniversityMember> members = [];
  List<UniversityInvitation> invitations = [];
  int memberOffset = 0, invitationOffset = 0;
  bool busy = false, sent = false, _disposed = false;
  String? error;
  Future<void> _load() async {
    members = await _repository.members(memberOffset);
    invitations = await _repository.invitations(invitationOffset);
  }

  Future<void> load() => _run(_load);
  Future<void> pageMembers(int delta) async {
    memberOffset = (memberOffset + delta * 50).clamp(0, 100000);
    await load();
  }

  Future<void> pageInvitations(int delta) async {
    invitationOffset = (invitationOffset + delta * 20).clamp(0, 100000);
    await load();
  }

  Future<void> invite(String email, String purpose) => _run(() async {
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim())) {
      throw const InstitutionProblem('invalid_input');
    }
    await _repository.invite(email.trim(), purpose);
    sent = true;
    await _load();
  });
  Future<void> revoke(String id) => _run(() async {
    await _repository.revoke(id);
    await _load();
  });
  Future<void> administrator(String id, bool enabled) => _run(() async {
    await _repository.setAdministrator(id, enabled);
    await _load();
  });
  Future<void> _run(Future<void> Function() action) async {
    if (busy || _disposed) return;
    busy = true;
    error = null;
    sent = false;
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
