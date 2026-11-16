import 'dart:convert';

import '../../data/repositories/notebook_repository.dart';

typedef StudioQuizRow = ({
  String prompt,
  String answer,
  String explanation,
  List<String>? options,
  int? correctIndex,
  List<String> citationIds,
});
typedef StudioCardRow = (String front, String back, List<String> citationIds);
typedef StudioAudioRow = (String text, List<String> citationIds);

sealed class StudioContent<T> {
  const StudioContent(this.rows);

  final List<T> rows;

  static StudioContent<Object>? decode(StudioKind kind, String source) {
    final Object? value;
    try {
      value = jsonDecode(source);
    } on FormatException {
      return null;
    }
    if (value case {'schemaVersion': 1} && final Map<String, dynamic> data) {
      return switch (kind) {
        StudioKind.quiz => _decodeRows<StudioQuizRow>(
          data['items'],
          _quizRow,
          StudioQuiz.new,
        ),
        StudioKind.flashcards => _decodeRows<StudioCardRow>(
          data['cards'],
          _cardRow,
          StudioFlashcards.new,
        ),
        StudioKind.audio => _decodeRows<StudioAudioRow>(
          data['sections'],
          _audioRow,
          StudioAudio.new,
        ),
      };
    }
    return null;
  }

  static StudioContent<T>? _decodeRows<T>(
    Object? raw,
    T? Function(Map<String, dynamic>, List<String>) decode,
    StudioContent<T> Function(List<T>) create,
  ) {
    if (raw is! List) return null;
    final rows = <T>[];
    for (final value in raw) {
      if (value is! Map<String, dynamic>) return null;
      final ids = value['citationIds'];
      final citations = ids == null ? const <String>[] : _strings(ids);
      if (citations == null) return null;
      final row = decode(value, citations);
      if (row == null) return null;
      rows.add(row);
    }
    return create(List<T>.unmodifiable(rows));
  }

  static List<String>? _strings(Object? value) =>
      value is List && value.every((entry) => entry is String)
      ? List<String>.unmodifiable(value.cast<String>())
      : null;

  static StudioQuizRow? _quizRow(
    Map<String, dynamic> data,
    List<String> citations,
  ) {
    if (data case {
      'type': final String type,
      'prompt': final String prompt,
      'answer': final String answer,
      'explanation': final String explanation,
    }) {
      final choices = _strings(data['options']);
      final index = data['correctIndex'];
      if (type == 'multipleChoice') {
        if (choices == null ||
            index is! int ||
            index < 0 ||
            index >= choices.length) {
          return null;
        }
        return (
          prompt: prompt,
          answer: answer,
          explanation: explanation,
          options: choices,
          correctIndex: index,
          citationIds: citations,
        );
      }
      if (type == 'shortAnswer' && data['options'] == null && index == null) {
        return (
          prompt: prompt,
          answer: answer,
          explanation: explanation,
          options: null,
          correctIndex: null,
          citationIds: citations,
        );
      }
    }
    return null;
  }

  static StudioCardRow? _cardRow(
    Map<String, dynamic> data,
    List<String> citations,
  ) => switch (data) {
    {'front': final String front, 'back': final String back} => (
      front,
      back,
      citations,
    ),
    _ => null,
  };

  static StudioAudioRow? _audioRow(
    Map<String, dynamic> data,
    List<String> citations,
  ) => switch (data) {
    {'text': final String text} => (text, citations),
    _ => null,
  };
}

final class StudioQuiz extends StudioContent<StudioQuizRow> {
  const StudioQuiz(super.rows);
}

final class StudioFlashcards extends StudioContent<StudioCardRow> {
  const StudioFlashcards(super.rows);
}

final class StudioAudio extends StudioContent<StudioAudioRow> {
  const StudioAudio(super.rows);
}
