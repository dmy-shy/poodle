import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import 'admin_overview_service.dart';

class AdminOverviewEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;
  final _service = AdminOverviewService();
  Future<AdminOverview> summary(Session session) => _service.summary(session);
  Future<List<AdminDirectoryRow>> list(
    Session session,
    String category,
    int offset,
  ) => _service.list(session, category, offset);
}
