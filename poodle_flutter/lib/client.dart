import 'data/repositories/institution_repository.dart';
import 'data/repositories/serverpod_institution_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'data/repositories/course_repository.dart';
import 'data/repositories/admin_overview_repository.dart';
import 'data/repositories/live_auth_repository.dart';
import 'data/repositories/live_course_repository.dart';
import 'data/repositories/live_notebook_repository.dart';
import 'data/repositories/notebook_repository.dart';
import 'data/repositories/notifications_repository.dart';
import 'data/repositories/teaching_repository.dart';
import 'data/repositories/student_tasks_repository.dart';
import 'data/repositories/student_grades_repository.dart';
import 'data/repositories/my_files_repository.dart';
import 'data/repositories/messaging_repository.dart';
import 'data/repositories/search_repository.dart';
import 'data/services/serverpod_auth_gateway.dart';
import 'data/services/session_credential_store.dart';
import 'server_url.dart';

class LiveAppDependencies {
  LiveAppDependencies(ServerpodAuthGateway gateway)
    : institutions = ServerpodInstitutionRepository(gateway),
      adminOverview = ServerpodAdminOverviewRepository(gateway),
      auth = LiveAuthRepository(gateway),
      courses = ServerpodCourseRepository(gateway),
      notebooks = ServerpodNotebookRepository(gateway),
      notifications = ServerpodNotificationsRepository(gateway),
      teaching = ServerpodTeachingRepository(gateway),
      search = ServerpodSearchRepository(gateway),
      studentTasks = ServerpodStudentTasksRepository(gateway),
      studentGrades = ServerpodStudentGradesRepository(gateway),
      myFiles = ServerpodMyFilesRepository(gateway),
      messaging = ServerpodMessagingRepository(gateway);

  final InstitutionRepository institutions;
  final AdminOverviewRepository adminOverview;
  final LiveAuthRepository auth;
  final CourseRepository courses;
  final NotebookRepository notebooks;
  final NotificationsRepository notifications;
  final TeachingRepository teaching;
  final SearchRepository search;
  final StudentTasksRepository studentTasks;
  final StudentGradesRepository studentGrades;
  final MyFilesRepository myFiles;
  final MessagingRepository messaging;

  void dispose() {
    teaching.dispose();
    notebooks.dispose();
    courses.dispose();
    auth.dispose();
  }
}

Future<LiveAppDependencies> createLiveAppDependencies() async =>
    LiveAppDependencies(await _createGateway());

Future<LiveAuthRepository> createLiveAuthRepository() async =>
    LiveAuthRepository(await _createGateway());

Future<ServerpodAuthGateway> _createGateway() async {
  const explicitUrl = String.fromEnvironment('SERVER_URL');
  final url = resolveServerUrl(
    bundledUrl: await getServerUrl(),
    explicitUrl: explicitUrl,
    isAndroidNative: !kIsWeb && defaultTargetPlatform == TargetPlatform.android,
  );
  final uri = Uri.parse(url);
  final loopback = [
    'localhost',
    '127.0.0.1',
    '::1',
    '10.0.2.2',
  ].contains(uri.host);
  const allowInsecure = bool.fromEnvironment(
    'ALLOW_INSECURE_DEVELOPMENT_SERVER',
  );
  if (uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      (uri.scheme != 'https' &&
          !(kDebugMode &&
              uri.scheme == 'http' &&
              (loopback || allowInsecure)))) {
    throw const FormatException(
      'Use HTTPS, or explicitly allow an insecure development host.',
    );
  }
  final storage = SessionCredentialStore(SecureClientAuthSuccessStorage());
  return ServerpodAuthGateway(url, storage);
}
