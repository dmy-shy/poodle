class InstitutionProblem implements Exception {
  const InstitutionProblem(this.code);
  final String code;
}

class AdministratorRequest {
  const AdministratorRequest({
    required this.id,
    required this.name,
    required this.email,
    required this.university,
    required this.position,
    required this.note,
    required this.status,
    this.reviewNote,
  });
  final String id, name, email, university, position, note, status;
  final String? reviewNote;
}

class UniversityOption {
  const UniversityOption(this.id, this.name);
  final String id, name;
}

class UniversityMember {
  const UniversityMember(this.id, this.email, this.administrator, this.teacher);
  final String id, email;
  final bool administrator, teacher;
}

class UniversityInvitation {
  const UniversityInvitation(
    this.id,
    this.email,
    this.purpose,
    this.expiresAt,
    this.accepted,
    this.revoked,
  );
  final String id, email, purpose;
  final DateTime expiresAt;
  final bool accepted, revoked;
}

class ManagedCourse {
  const ManagedCourse(this.id, this.title, this.published);
  final String id, title;
  final bool published;
}
