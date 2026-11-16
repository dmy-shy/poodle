import 'package:test/test.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:poodle_server/src/modules/teaching/teaching_policy.dart';

void main() {
  final questions = [
    TeachingQuestion(
      prompt: 'A',
      kind: 'choice',
      options: ['one', 'two'],
      correctIndex: 0,
      points: 1,
    ),
    TeachingQuestion(
      prompt: 'B',
      kind: 'trueFalse',
      options: ['true', 'false'],
      correctIndex: 1,
      points: 3,
    ),
  ];
  test(
    'weighted scoring normalizes across test versions and counts unanswered as zero',
    () {
      expect(TeachingPolicy.score(questions, [0, -1], 100), 25);
      expect(TeachingPolicy.score(questions, [0, 1], 100), 100);
      expect(TeachingPolicy.score(questions, [1, 0], 50), 0);
    },
  );
  test('server availability includes opening and excludes closing', () {
    final start = DateTime.utc(2026, 1, 1), end = DateTime.utc(2026, 1, 2);
    final settings = TeachingSettings(
      title: 'A',
      instructions: '',
      opensAt: start,
      closesAt: end,
    );
    expect(TeachingPolicy.available(settings, start), isTrue);
    expect(TeachingPolicy.available(settings, end), isFalse);
    expect(
      TeachingPolicy.available(
        settings,
        start.subtract(const Duration(microseconds: 1)),
      ),
      isFalse,
    );
  });
  test('invalid settings and invalid answer indices cannot be published', () {
    final s = TeachingSettings(title: 'Test', instructions: '');
    expect(
      () => TeachingPolicy.validate(s, 'test', questions, publish: true),
      throwsA(isA<TeachingError>()),
    );
    expect(
      () => TeachingPolicy.validate(
        s.copyWith(maxPoints: double.nan),
        'assignment',
        [],
      ),
      throwsA(isA<TeachingError>()),
    );
    expect(
      () => TeachingPolicy.answers(questions, [2, 0]),
      throwsA(isA<TeachingError>()),
    );
    expect(
      () => TeachingPolicy.answers(questions, [0]),
      throwsA(isA<TeachingError>()),
    );
    expect(() => TeachingPolicy.validate(s, 'assignment', []), returnsNormally);
  });
}
