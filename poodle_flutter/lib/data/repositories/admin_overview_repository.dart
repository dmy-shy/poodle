import 'package:poodle_client/poodle_client.dart';
import '../services/serverpod_auth_gateway.dart';
export 'package:poodle_client/poodle_client.dart'
    show AdminOverview, AdminDirectoryRow;

abstract interface class AdminOverviewRepository {
  Future<AdminOverview> summary();
  Future<List<AdminDirectoryRow>> list(String category, int offset);
}

class ServerpodAdminOverviewRepository implements AdminOverviewRepository {
  const ServerpodAdminOverviewRepository(this.gateway);
  final ServerpodAuthGateway gateway;
  @override
  Future<AdminOverview> summary() =>
      gateway.withClient((c) => c.adminOverview.summary());
  @override
  Future<List<AdminDirectoryRow>> list(String category, int offset) =>
      gateway.withClient((c) => c.adminOverview.list(category, offset));
}
