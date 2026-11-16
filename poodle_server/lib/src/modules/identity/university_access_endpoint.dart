import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import 'university_access_service.dart';

class UniversityAccessEndpoint extends Endpoint {
  final _service = UniversityAccessService();
  @override
  bool get requireLogin => true;

  Future<void> invite(
    Session session, {
    required String email,
    required String purpose,
    UuidValue? courseId,
  }) => _service.invite(
    session,
    email: email,
    purpose: purpose,
    courseId: courseId,
  );
  Future<List<InvitationSummary>> invitations(
    Session session, {
    int offset = 0,
  }) => _service.invitations(session, offset: offset);
  Future<void> revoke(Session session, UuidValue invitationId) =>
      _service.revoke(session, invitationId);
  Future<List<UniversityMemberSummary>> members(
    Session session, {
    int offset = 0,
  }) => _service.members(session, offset: offset);
  Future<void> setAdministrator(
    Session session, {
    required UuidValue userId,
    required bool enabled,
  }) => _service.setAdministrator(session, userId: userId, enabled: enabled);
}
