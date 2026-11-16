import 'package:poodle_client/poodle_client.dart';

import '../services/serverpod_auth_gateway.dart';
import 'course_repository.dart' show CourseRepository;

abstract interface class SearchRepository {
  Future<SearchResponse> search(String query, {String? courseId, String? kind});
  Future<List<SearchRecent>> listRecent();
  Future<List<SearchRecent>> saveRecent(String query);
  Future<List<SearchRecent>> deleteRecent(int id);
  Future<List<SearchRecent>> clearRecent();
}

class ServerpodSearchRepository implements SearchRepository {
  const ServerpodSearchRepository(this._gateway);
  final ServerpodAuthGateway _gateway;

  @override
  Future<SearchResponse> search(
    String query, {
    String? courseId,
    String? kind,
  }) => _gateway.withClient(
    (client) => client.search.search(
      query,
      courseId: courseId == null ? null : UuidValue.withValidation(courseId),
      kind: kind,
    ),
  );

  @override
  Future<List<SearchRecent>> listRecent() =>
      _gateway.withClient((client) => client.search.listRecent());
  @override
  Future<List<SearchRecent>> saveRecent(String query) =>
      _gateway.withClient((client) => client.search.saveRecent(query));
  @override
  Future<List<SearchRecent>> deleteRecent(int id) =>
      _gateway.withClient((client) => client.search.deleteRecent(id));
  @override
  Future<List<SearchRecent>> clearRecent() =>
      _gateway.withClient((client) => client.search.clearRecent());
}

class PreviewSearchRepository implements SearchRepository {
  PreviewSearchRepository([this._courses]);
  final CourseRepository? _courses;
  final _recent = <SearchRecent>[];
  var _next = 0;

  @override
  Future<SearchResponse> search(
    String query, {
    String? courseId,
    String? kind,
  }) async {
    final results = <SearchHit>[];
    final value = query.trim().toLowerCase();
    final courses = await _courses?.list() ?? [];
    for (final course in courses) {
      if (courseId != null && course.id != courseId) continue;
      final id = UuidValue.withValidation(course.id);
      if ((kind == null || kind == 'course') &&
          '${course.title} ${course.summary ?? ''}'.toLowerCase().contains(
            value,
          )) {
        results.add(
          SearchHit(
            targetId: id,
            courseId: id,
            kind: 'course',
            title: course.title,
            breadcrumb: '',
            excerpt: course.summary ?? '',
            draft: false,
          ),
        );
      }
      final detail = await _courses!.content(course.id);
      for (final section in detail.sections) {
        final sectionId = UuidValue.withValidation(section.id);
        if ((kind == null || kind == 'section') &&
            section.title.toLowerCase().contains(value)) {
          results.add(
            SearchHit(
              targetId: sectionId,
              courseId: id,
              sectionId: sectionId,
              kind: 'section',
              title: section.title,
              breadcrumb: course.title,
              excerpt: section.description ?? '',
              draft: section.draft,
            ),
          );
        }
        if (kind != null && kind != 'activity') continue;
        for (final activity in section.activities) {
          if (!activity.title.toLowerCase().contains(value)) continue;
          final activityId = UuidValue.withValidation(activity.id);
          results.add(
            SearchHit(
              targetId: activityId,
              courseId: id,
              sectionId: sectionId,
              activityId: activityId,
              kind: 'activity',
              title: activity.title,
              breadcrumb: '${course.title} / ${section.title}',
              excerpt: activity.description ?? activity.body ?? '',
              draft: activity.draft,
            ),
          );
        }
      }
    }
    return SearchResponse(
      results: results,
      keywordOnly: false,
      incomplete: false,
      capped: false,
    );
  }

  @override
  Future<List<SearchRecent>> listRecent() async => List.unmodifiable(_recent);
  @override
  Future<List<SearchRecent>> saveRecent(String query) async {
    _recent.removeWhere(
      (item) => item.query.toLowerCase() == query.toLowerCase(),
    );
    _recent.insert(
      0,
      SearchRecent(id: ++_next, query: query, lastUsed: DateTime.utc(2026)),
    );
    if (_recent.length > 20) _recent.removeLast();
    return listRecent();
  }

  @override
  Future<List<SearchRecent>> deleteRecent(int id) async {
    _recent.removeWhere((item) => item.id == id);
    return listRecent();
  }

  @override
  Future<List<SearchRecent>> clearRecent() async {
    _recent.clear();
    return listRecent();
  }
}
