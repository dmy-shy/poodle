import 'package:poodle_client/poodle_client.dart' show MyUpload;
import '../../../../data/repositories/my_files_repository.dart';

enum MyFilesFilter { all, notebook, assignments }

class MyFilesViewModel {
  MyFilesViewModel(this._repository) {
    reload();
  }

  final MyFilesRepository _repository;
  late Future<List<MyUpload>> _result;
  Future<List<MyUpload>> get result => _result;

  Future<List<MyUpload>> reload() => _result = _repository.listUploads();
  MyFilesFilter filter = MyFilesFilter.all;

  List<MyUpload> visibleFiles(List<MyUpload> files) => files.where((file) {
    return switch (filter) {
      MyFilesFilter.all => true,
      MyFilesFilter.notebook => file.kind == 'notebook',
      MyFilesFilter.assignments => file.kind == 'assignment',
    };
  }).toList();
}
