import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/institution_repository.dart';
import 'presentation/views/teacher_courses_screen.dart';
import 'presentation/view_models/teacher_courses_view_model.dart';
import 'presentation/views/administrator_request_screen.dart';
import 'presentation/view_models/administrator_request_view_model.dart';
import 'presentation/views/operator_review_screen.dart';
import 'presentation/view_models/operator_review_view_model.dart';
import 'presentation/views/university_admin_screen.dart';
import 'presentation/view_models/university_admin_view_model.dart';

List<RouteBase> universityRoutes({
  required AuthRepository auth,
  required InstitutionRepository? institutions,
  required VoidCallback onCoursesChanged,
  required bool courseEditingAvailable,
  VoidCallback? onRequestReviewed,
}) => [
  GoRoute(
    path: '/university/request',
    builder: (_, _) => ChangeNotifierProvider(
      create: (_) => AdministratorRequestViewModel(
        institutions ?? _UnavailableInstitution(),
      ),
      child: const AdministratorRequestScreen(),
    ),
  ),
  GoRoute(
    path: '/more/teaching-courses',
    redirect: (_, _) =>
        auth.session?.teacherApproved == true &&
            auth.session?.universityId != null &&
            institutions != null
        ? null
        : '/profile',
    builder: (context, _) => ChangeNotifierProvider(
      create: (_) => TeacherCoursesViewModel(
        institutions!,
        onChanged: onCoursesChanged,
      )..load(),
      child: TeacherCoursesScreen(
        onEdit: !courseEditingAvailable
            ? null
            : (id) => context.push('/courses/$id/teaching'),
      ),
    ),
  ),
  GoRoute(
    path: '/more/university-requests',
    redirect: (_, _) => auth.session?.isAdmin == true && institutions != null
        ? null
        : '/profile',
    builder: (_, state) => ChangeNotifierProvider(
      create: (_) => OperatorReviewViewModel(
        institutions!,
        focusId: state.uri.queryParameters['requestId'],
        onReviewed: onRequestReviewed,
      )..load(),
      child: const OperatorReviewScreen(),
    ),
  ),
  GoRoute(
    path: '/more/university',
    redirect: (_, _) =>
        auth.session?.isUniversityAdmin == true && institutions != null
        ? null
        : '/profile',
    builder: (_, _) => ChangeNotifierProvider(
      create: (_) => UniversityAdminViewModel(institutions!)..load(),
      child: const UniversityAdminScreen(),
    ),
  ),
];

class _UnavailableInstitution extends InstitutionRepository {}
