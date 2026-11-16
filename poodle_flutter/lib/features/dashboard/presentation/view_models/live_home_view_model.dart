import 'package:flutter/foundation.dart';
import '../../../../data/repositories/course_repository.dart';
import '../../../../data/repositories/student_tasks_repository.dart';
import '../../../../data/repositories/teaching_repository.dart';
import '../../../../data/repositories/admin_overview_repository.dart';
import 'package:poodle_client/poodle_client.dart' show StudentTasksResponse;

class LiveHomeViewModel extends ChangeNotifier {
  LiveHomeViewModel(this.courses, this.tasks, this.teaching, this.admin);
  final CourseRepository courses;
  final StudentTasksRepository? tasks;
  final TeachingRepository? teaching;
  final AdminOverviewRepository? admin;
  late Future<List<CourseInfo>> courseLoad;
  late Future<StudentTasksResponse?> taskLoad;
  late Future<List<TeachingCourseView>> teachingLoad;
  late Future<AdminOverview?> adminLoad;
  List<TeachingCourseView> taught = [];
  int _epoch = 0;
  bool _disposed = false;
  Future<void> refresh() async {
    if (_disposed) return;
    final epoch = ++_epoch;
    courseLoad = courses.list();
    taskLoad = tasks?.listTasks() ?? Future.value();
    teachingLoad = teaching?.dashboard() ?? Future.value([]);
    adminLoad = admin?.summary() ?? Future.value();
    // Attach observers immediately, including failures from independently loaded areas.
    final loads = <Future<Object?>>[
      courseLoad,
      taskLoad,
      teachingLoad,
      adminLoad,
    ];
    for (final load in loads) {
      load.then((_) {}, onError: (Object _) {});
    }
    teachingLoad.then((value) {
      if (!_disposed && epoch == _epoch) {
        taught = value;
        notifyListeners();
      }
    }, onError: (Object _) {});
    notifyListeners();
    await Future.wait(
      loads.map((f) => f.then<void>((_) {}, onError: (Object _) {})),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _epoch++;
    super.dispose();
  }
}
