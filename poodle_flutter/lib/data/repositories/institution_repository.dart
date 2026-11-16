import '../../domain/models/institution.dart';
export '../../domain/models/institution.dart';

/// University onboarding and access boundary. All authorization remains on the server.
abstract class InstitutionRepository {
  Future<String> requestAdministrator(Map<String, String> fields) async =>
      throw const InstitutionProblem('unavailable');
  Future<void> verifyAdministrator(String id, String code) async =>
      throw const InstitutionProblem('unavailable');
  Future<List<AdministratorRequest>> requests(int offset) async =>
      throw const InstitutionProblem('unavailable');
  Future<AdministratorRequest?> request(String id) async =>
      throw const InstitutionProblem('unavailable');
  Future<int> pendingRequestCount() async =>
      throw const InstitutionProblem('unavailable');
  Future<List<UniversityOption>> universities() async =>
      throw const InstitutionProblem('unavailable');
  Future<void> approve(
    AdministratorRequest request, {
    String? universityId,
    required String name,
    required String slug,
    required String note,
  }) async => throw const InstitutionProblem('unavailable');
  Future<void> reject(String id, String reason) async =>
      throw const InstitutionProblem('unavailable');
  Future<List<UniversityMember>> members(int offset) async =>
      throw const InstitutionProblem('unavailable');
  Future<List<UniversityInvitation>> invitations(int offset) async =>
      throw const InstitutionProblem('unavailable');
  Future<void> invite(String email, String purpose, {String? courseId}) async =>
      throw const InstitutionProblem('unavailable');
  Future<void> revoke(String id) async =>
      throw const InstitutionProblem('unavailable');
  Future<void> setAdministrator(String userId, bool enabled) async =>
      throw const InstitutionProblem('unavailable');
  Future<List<ManagedCourse>> courses() async =>
      throw const InstitutionProblem('unavailable');
  Future<String> createCourse(String title) async =>
      throw const InstitutionProblem('unavailable');
  Future<void> publish(String id, bool published) async =>
      throw const InstitutionProblem('unavailable');
}
