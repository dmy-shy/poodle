import 'package:poodle_client/poodle_client.dart';
import '../services/serverpod_auth_gateway.dart';

abstract interface class MyFilesRepository {
  Future<List<MyUpload>> listUploads();
}

class ServerpodMyFilesRepository implements MyFilesRepository {
  const ServerpodMyFilesRepository(this._gateway);
  final ServerpodAuthGateway _gateway;

  @override
  Future<List<MyUpload>> listUploads() =>
      _gateway.withClient((client) => client.myFiles.listUploads());
}
