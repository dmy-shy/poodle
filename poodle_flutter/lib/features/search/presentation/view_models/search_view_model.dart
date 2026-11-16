import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:poodle_client/poodle_client.dart';

import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/course_repository.dart';
import '../../../../data/repositories/search_repository.dart';

class SearchViewModel extends ChangeNotifier {
  SearchViewModel(this._repository, this._courses, this._auth) {
    _account = _accountId;
    _auth.addListener(_accountChanged);
    unawaited(load());
  }

  final SearchRepository _repository;
  final CourseRepository _courses;
  final AuthRepository _auth;
  String? _account;
  int _generation = 0, _request = 0, _historyRequest = 0;
  bool _disposed = false;
  bool busy = false,
      historyBusy = false,
      historyFailed = false,
      invalid = false;
  String? submitted, courseId, kind;
  Object? failure;
  SearchResponse? response;
  List<SearchRecent> recent = [];
  List<CourseInfo> courses = [];

  String? get _accountId => _auth.session?.userId ?? _auth.session?.email;

  void _accountChanged() {
    if (_account == _accountId) return;
    _account = _accountId;
    _generation++;
    submitted = courseId = kind = null;
    failure = response = null;
    busy = historyBusy = historyFailed = invalid = false;
    recent = [];
    courses = [];
    notifyListeners();
    if (_account != null) unawaited(load());
  }

  bool _current(int generation) => !_disposed && generation == _generation;

  Future<void> load() async {
    final generation = _generation;
    await Future.wait([
      _history(_repository.listRecent),
      () async {
        try {
          final value = await _courses.list();
          if (!_current(generation)) return;
          courses = value;
          notifyListeners();
        } catch (_) {
          // Course filtering is optional; search remains available.
        }
      }(),
    ]);
  }

  Future<void> _history(Future<List<SearchRecent>> Function() action) async {
    final generation = _generation;
    final request = ++_historyRequest;
    historyBusy = true;
    historyFailed = false;
    notifyListeners();
    try {
      final value = await action();
      if (_current(generation) && request == _historyRequest) recent = value;
    } catch (_) {
      if (_current(generation) && request == _historyRequest) {
        historyFailed = true;
      }
    } finally {
      if (_current(generation) && request == _historyRequest) {
        historyBusy = false;
        notifyListeners();
      }
    }
  }

  Future<void> reloadHistory() => _history(_repository.listRecent);
  Future<void> deleteRecent(int id) =>
      _history(() => _repository.deleteRecent(id));
  Future<void> clearRecent() => _history(_repository.clearRecent);

  void clearQuery() {
    _request++;
    submitted = null;
    response = null;
    failure = null;
    invalid = busy = false;
    notifyListeners();
  }

  Future<void> submit(String raw) async {
    final value = raw.trim().replaceAll(RegExp(r'\s+', unicode: true), ' ');
    if (value.isEmpty ||
        value.runes.length > 500 ||
        RegExp(r'[\x00-\x1f\x7f-\x9f]').hasMatch(value)) {
      clearQuery();
      invalid = value.isNotEmpty;
      notifyListeners();
      return;
    }
    submitted = value;
    await _search(save: true);
  }

  Future<void> filter({required String? course, required String? type}) async {
    courseId = course;
    kind = type;
    notifyListeners();
    if (submitted != null) await _search();
  }

  Future<void> retry() async {
    if (submitted != null) await _search();
  }

  Future<void> _search({bool save = false}) async {
    final query = submitted!;
    final generation = _generation;
    final request = ++_request;
    busy = true;
    invalid = false;
    response = null;
    failure = null;
    notifyListeners();
    try {
      final value = await _repository.search(
        query,
        courseId: courseId,
        kind: kind,
      );
      if (!_current(generation) || request != _request) return;
      response = value;
      if (save) unawaited(_history(() => _repository.saveRecent(query)));
    } catch (error) {
      if (_current(generation) && request == _request) failure = error;
    } finally {
      if (_current(generation) && request == _request) {
        busy = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _auth.removeListener(_accountChanged);
    super.dispose();
  }
}
