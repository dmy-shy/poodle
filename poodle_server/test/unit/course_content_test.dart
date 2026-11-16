import 'package:poodle_server/src/generated/protocol.dart';
import 'package:poodle_server/src/modules/courses/course_service.dart';
import 'package:poodle_server/src/modules/course_content/course_content_repository.dart';
import 'package:poodle_server/src/modules/course_content/course_content_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

UuidValue id(int value) => UuidValue.withValidation(
  '019a0acf-0000-7000-8000-${value.toString().padLeft(12, '0')}',
);

class UnusedSession implements Session {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('Unexpected session access');
}

class AuthorizedCourse extends CourseService {
  AuthorizedCourse(this.role, {this.denied = false});
  final String role;
  final bool denied;
  @override
  Future<CourseSummary> get(Session session, UuidValue courseId) async {
    final access = await requireMember(session, courseId);
    return CourseSummary(
      id: courseId,
      title: access.course.title,
      role: role,
      sample: false,
      starred: false,
      hidden: false,
    );
  }

  @override
  Future<({CourseRecord course, CourseMembership membership})> requireMember(
    Session session,
    UuidValue courseId,
  ) async {
    if (denied || courseId != id(1)) {
      throw CourseReadException(code: 'unavailable');
    }
    return (
      course: CourseRecord(id: id(1), title: 'Course'),
      membership: CourseMembership(
        courseId: id(1),
        authUserId: id(99),
        role: role,
      ),
    );
  }
}

class ContentRows extends CourseContentRepository {
  @override
  Future<Set<UuidValue>> managedAssessments(
    Session session,
    UuidValue courseId,
  ) async => {id(7)};
  int reads = 0;
  @override
  Future<List<CourseSectionRecord>> sections(
    Session session,
    UuidValue courseId,
  ) async {
    reads++;
    return [
      CourseSectionRecord(
        id: id(3),
        courseId: courseId,
        title: 'Draft section',
        sortOrder: 1,
      ),
      CourseSectionRecord(
        id: id(2),
        courseId: courseId,
        title: 'Published',
        sortOrder: 0,
        published: true,
      ),
    ];
  }

  @override
  Future<List<CourseActivityRecord>> activities(
    Session session,
    UuidValue sectionId,
  ) async => [
    CourseActivityRecord(
      id: id(5),
      sectionId: sectionId,
      title: 'Draft',
      kind: 'announcement',
      sortOrder: 0,
      announcement: CourseAnnouncementInfo(body: 'Draft body'),
    ),
    CourseActivityRecord(
      id: id(4),
      sectionId: sectionId,
      title: 'Module',
      kind: 'module',
      sortOrder: 2,
      published: true,
      assessment: CourseAssessmentInfo(
        instructions: 'Read',
        opensAt: DateTime.utc(2026, 10, 22),
      ),
    ),
    CourseActivityRecord(
      id: id(6),
      sectionId: sectionId,
      title: 'Unsafe link',
      kind: 'link',
      sortOrder: 1,
      published: true,
      link: CourseLinkInfo(url: 'javascript:alert(1)'),
    ),
    CourseActivityRecord(
      id: id(7),
      sectionId: sectionId,
      title: 'Semester test',
      kind: 'test',
      sortOrder: 3,
      published: true,
      assessment: CourseAssessmentInfo(instructions: 'Prepare'),
    ),
  ];
}

void main() {
  final session = UnusedSession();
  test(
    'students get only published sections and valid activities with filtered navigation',
    () async {
      final service = CourseContentService(
        courses: AuthorizedCourse('student'),
        repository: ContentRows(),
        clock: () => DateTime.utc(2026, 10, 22),
      );
      final result = await service.getContent(session, id(1));
      expect(result.sections, hasLength(1));
      final activities = result.sections.single.activities;
      expect(activities, hasLength(2));
      expect(activities.last.managedAssessment, isTrue);
      expect(activities.map((activity) => activity.title), [
        'Module',
        'Semester test',
      ]);
      expect(activities.first.availability, 'available');
      expect(activities.first.previousId, isNull);
      expect(activities.first.nextId, id(7));
      expect(activities.last.kind, 'test');
      expect(activities.last.previousId, id(4));
      expect(activities.last.nextId, isNull);
      await expectLater(
        service.getActivity(session, id(1), id(5)),
        throwsA(isA<CourseReadException>()),
      );
      await expectLater(
        service.getFileUrl(session, id(1), id(5)),
        throwsA(isA<CourseReadException>()),
      );
    },
  );
  test(
    'teachers retain draft markers, stable ordering and the authorized sequence',
    () async {
      final result = await CourseContentService(
        courses: AuthorizedCourse('teacher'),
        repository: ContentRows(),
      ).getContent(session, id(1));
      expect(result.teacherView, true);
      expect(result.sections, hasLength(2));
      expect(result.sections.last.draft, true);
      expect(result.sections.first.activities.map((a) => a.title), [
        'Draft',
        'Module',
        'Semester test',
      ]);
      expect(result.sections.first.activities.first.draft, true);
      expect(result.sections.last.activities.every((a) => a.draft), true);
      expect(result.sections.first.activities.first.nextId, id(4));
      expect(result.sections.first.activities[1].nextId, id(7));
      expect(result.sections.first.activities.last.previousId, id(4));
    },
  );
  test(
    'denied membership prevents reading content rows or file storage',
    () async {
      final rows = ContentRows();
      final service = CourseContentService(
        courses: AuthorizedCourse('student', denied: true),
        repository: rows,
      );
      await expectLater(
        service.getContent(session, id(1)),
        throwsA(isA<CourseReadException>()),
      );
      await expectLater(
        service.getFileUrl(session, id(1), id(4)),
        throwsA(isA<CourseReadException>()),
      );
      expect(rows.reads, 0);
    },
  );
}
