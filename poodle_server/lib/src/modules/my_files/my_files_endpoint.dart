import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import 'my_files_service.dart';

class MyFilesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<MyUpload>> listUploads(Session session) =>
      MyFilesService().listUploads(session);
}
