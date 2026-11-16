import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'search_service.dart';

class SearchEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = SearchService();

  Future<SearchResponse> search(
    Session session,
    String query, {
    UuidValue? courseId,
    String? kind,
  }) => _service.search(session, query, courseId: courseId, kind: kind);

  Future<List<SearchRecent>> listRecent(Session session) =>
      _service.history(session);

  Future<List<SearchRecent>> saveRecent(Session session, String query) =>
      _service.history(session, query: query);

  Future<List<SearchRecent>> deleteRecent(Session session, int id) =>
      _service.history(session, deleteId: id);

  Future<List<SearchRecent>> clearRecent(Session session) =>
      _service.history(session, clear: true);
}
