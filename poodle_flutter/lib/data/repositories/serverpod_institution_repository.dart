import 'package:poodle_client/poodle_client.dart' as api;
import '../services/serverpod_auth_gateway.dart';
import 'auth_repository.dart';
import 'institution_repository.dart';

class ServerpodInstitutionRepository implements InstitutionRepository {
  ServerpodInstitutionRepository(this.gateway);
  final ServerpodAuthGateway gateway;
  api.UuidValue _id(String value) => api.UuidValue.withValidation(value);
  Future<T> _run<T>(Future<T> Function(api.Client) action) async {
    try {
      return await gateway.withClient((client) async {
        try {
          return await action(client);
        } on api.IdentityAccessException catch (e) {
          throw InstitutionProblem(e.code);
        }
      });
    } on AuthFailure catch (e) {
      throw InstitutionProblem(
        e == AuthFailure.forbidden ? 'forbidden' : 'unavailable',
      );
    }
  }

  @override
  Future<String> requestAdministrator(Map<String, String> fields) => _run(
    (c) async => (await c.administratorRequests.begin(
      name: fields['name']!,
      email: fields['email']!,
      university: fields['university']!,
      position: fields['position']!,
      note: fields['note'] ?? '',
      locale: fields['locale'] ?? 'en',
    )).toString(),
  );
  @override
  Future<void> verifyAdministrator(String id, String code) => _run(
    (c) => c.administratorRequests.verify(requestId: _id(id), code: code),
  );
  @override
  Future<List<AdministratorRequest>> requests(int offset) => _run(
    (c) async => (await c.administratorRequests.list(
      offset: offset,
    )).map(_request).toList(),
  );
  AdministratorRequest _request(api.AdministratorRequestSummary r) =>
      AdministratorRequest(
        id: r.id.toString(),
        name: r.name,
        email: r.email,
        university: r.university,
        position: r.position,
        note: r.note,
        status: r.status,
        reviewNote: r.reviewNote,
      );
  @override
  Future<AdministratorRequest?> request(String id) => _run((c) async {
    final value = await c.administratorRequests.get(_id(id));
    return value == null ? null : _request(value);
  });
  @override
  Future<int> pendingRequestCount() =>
      _run((c) => c.administratorRequests.pendingCount());
  @override
  Future<List<UniversityOption>> universities() => _run(
    (c) async => (await c.administratorRequests.universities())
        .map((u) => UniversityOption(u.id.toString(), u.name))
        .toList(),
  );
  @override
  Future<void> approve(
    AdministratorRequest request, {
    String? universityId,
    required String name,
    required String slug,
    required String note,
  }) => _run((c) async {
    await c.administratorRequests.approve(
      requestId: _id(request.id),
      universityId: universityId == null ? null : _id(universityId),
      universityName: name,
      slug: slug,
      reviewNote: note,
    );
  });
  @override
  Future<void> reject(String id, String reason) => _run(
    (c) => c.administratorRequests.reject(requestId: _id(id), reason: reason),
  );
  @override
  Future<List<UniversityMember>> members(int offset) => _run(
    (c) async => (await c.universityAccess.members(offset: offset))
        .map(
          (m) => UniversityMember(
            m.userId.toString(),
            m.email,
            m.administrator,
            m.teacherApproved,
          ),
        )
        .toList(),
  );
  @override
  Future<List<UniversityInvitation>> invitations(int offset) => _run(
    (c) async => (await c.universityAccess.invitations(offset: offset))
        .map(
          (i) => UniversityInvitation(
            i.id.toString(),
            i.email,
            i.purpose,
            i.expiresAt,
            i.acceptedAt != null,
            i.revokedAt != null,
          ),
        )
        .toList(),
  );
  @override
  Future<void> invite(String email, String purpose, {String? courseId}) => _run(
    (c) => c.universityAccess.invite(
      email: email,
      purpose: purpose,
      courseId: courseId == null ? null : _id(courseId),
    ),
  );
  @override
  Future<void> revoke(String id) =>
      _run((c) => c.universityAccess.revoke(_id(id)));
  @override
  Future<void> setAdministrator(String userId, bool enabled) => _run(
    (c) => c.universityAccess.setAdministrator(
      userId: _id(userId),
      enabled: enabled,
    ),
  );
  @override
  Future<List<ManagedCourse>> courses() => _run(
    (c) async => (await c.course.listMyCourses())
        .where((r) => r.role == 'teacher')
        .map((r) => ManagedCourse(r.id.toString(), r.title, r.published))
        .toList(),
  );
  @override
  Future<String> createCourse(String title) =>
      _run((c) async => (await c.course.create(title)).id.toString());
  @override
  Future<void> publish(String id, bool published) => _run((c) async {
    await c.course.setPublished(_id(id), published);
  });
}
