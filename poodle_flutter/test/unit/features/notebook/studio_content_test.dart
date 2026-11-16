import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/notebook_repository.dart';
import 'package:poodle_flutter/features/notebook/studio_content.dart';

void main() {
  test('decodes the three existing Studio variants', () {
    expect(
      StudioContent.decode(
        StudioKind.quiz,
        '{"schemaVersion":1,"items":[{"type":"shortAnswer","prompt":"Question","answer":"Answer","explanation":"Why"}]}',
      ),
      isA<StudioQuiz>(),
    );
    expect(
      StudioContent.decode(
        StudioKind.flashcards,
        '{"schemaVersion":1,"cards":[{"front":"Question","back":"Answer"}]}',
      ),
      isA<StudioFlashcards>(),
    );
    expect(
      StudioContent.decode(
        StudioKind.audio,
        '{"schemaVersion":1,"sections":[{"text":"Transcript"}]}',
      ),
      isA<StudioAudio>(),
    );
  });

  test('rejects malformed envelopes, unsupported versions and mixed rows', () {
    for (final source in [
      'not JSON',
      '{}',
      '{"schemaVersion":null,"items":[]}',
      '{"schemaVersion":2,"items":[]}',
      '{"schemaVersion":1,"items":null}',
      '{"schemaVersion":1,"items":[{},3]}',
    ]) {
      expect(StudioContent.decode(StudioKind.quiz, source), isNull);
    }
  });
  test('rejects invalid row fields and multiple-choice metadata', () {
    for (final source in [
      '{"schemaVersion":1,"items":[{"type":"shortAnswer","answer":"A","explanation":"E"}]}',
      '{"schemaVersion":1,"items":[{"type":"shortAnswer","prompt":"Q","answer":1,"explanation":"E"}]}',
      '{"schemaVersion":1,"items":[{"type":"multipleChoice","prompt":"Q","answer":"A","explanation":"E","options":["A",2],"correctIndex":0}]}',
      '{"schemaVersion":1,"items":[{"type":"multipleChoice","prompt":"Q","answer":"A","explanation":"E","options":["A"],"correctIndex":1}]}',
    ]) {
      expect(StudioContent.decode(StudioKind.quiz, source), isNull);
    }
    expect(
      StudioContent.decode(
        StudioKind.flashcards,
        '{"schemaVersion":1,"cards":[{"front":"Q"}]}',
      ),
      isNull,
    );
    expect(
      StudioContent.decode(
        StudioKind.audio,
        '{"schemaVersion":1,"sections":[{"text":42}]}',
      ),
      isNull,
    );
    expect(
      StudioContent.decode(
        StudioKind.audio,
        '{"schemaVersion":1,"sections":[{"text":"T","citationIds":[42]}]}',
      ),
      isNull,
    );
  });
}
