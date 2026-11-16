part of 'ingestion_worker.dart';

/// Wire schema and semantic checks shared by generation and worker tests.
class NotebookStudioFormat {
  const NotebookStudioFormat(this.kind);

  final String kind;
  String get collection => switch (kind) {
    'quiz' => 'items',
    'flashcards' => 'cards',
    _ => 'sections',
  };
  String get prompt => switch (kind) {
    'quiz' =>
      'Make 6 multipleChoice questions, each with 4 distinct options, '
          'a zero-based correctIndex, and answer matching that option. Then make '
          '2 shortAnswer questions with null options and correctIndex. Explain each answer.',
    'flashcards' =>
      'Make 12 distinct flashcards, each with one short prompt and answer.',
    _ =>
      'Write 3 consecutive narration sections, about 140–185 words each, '
          'for a 3–5 minute overview. Use spoken prose, no markup, headings, '
          'citation markers, or speaker labels. Put citations in citationIds.',
  };

  Map<String, Object?> schema(Set<String> ids) {
    const string = {'type': 'string'};
    Map<String, Object?> object(Map<String, Object?> props) => {
      'type': 'object',
      'properties': props,
      'required': props.keys.toList(),
      'additionalProperties': false,
    };
    return object({
      'title': string,
      'insufficientEvidence': {'type': 'boolean'},
      collection: {
        'type': 'array',
        'items': object({
          if (kind == 'quiz') ...{
            'type': {
              'type': 'string',
              'enum': ['multipleChoice', 'shortAnswer'],
            },
            'prompt': string,
            'options': {
              'type': ['array', 'null'],
              'items': string,
            },
            'correctIndex': {
              'type': ['integer', 'null'],
            },
            'answer': string,
            'explanation': string,
          } else if (kind == 'flashcards') ...{
            'front': string,
            'back': string,
          } else
            'text': string,
          'citationIds': {
            'type': 'array',
            'items': {'type': 'string', 'enum': ids.toList()},
          },
        }),
      },
    });
  }

  Map<String, Object?> validate(Map<String, Object?> json, Set<String> ids) {
    const invalid = NotebookIngestionException('invalid_response');
    String checked(Object? value, int max) {
      if (value is! String || value.trim().isEmpty || value.length > max) {
        throw invalid;
      }
      return value.trim();
    }

    if (json['insufficientEvidence'] == true) {
      throw const NotebookIngestionException('insufficient_evidence');
    }
    final rows = json[collection];
    if (json['insufficientEvidence'] != false ||
        rows is! List ||
        rows.length !=
            (kind == 'quiz'
                ? 8
                : kind == 'flashcards'
                ? 12
                : 3)) {
      throw invalid;
    }
    final seen = <String>{};
    final entries = <Map<String, Object?>>[];
    for (final (i, value) in rows.indexed) {
      if (value is! Map) throw invalid;
      final refs = value['citationIds'];
      if (refs is! List ||
          refs.isEmpty ||
          refs.length > 8 ||
          refs.any((id) => id is! String || !ids.contains(id))) {
        throw invalid;
      }
      final key = kind == 'quiz'
          ? 'prompt'
          : kind == 'flashcards'
          ? 'front'
          : 'text';
      final front = checked(value[key], kind == 'audio' ? 2500 : 500);
      if (!seen.add(front.toLowerCase())) throw invalid;
      final entry = <String, Object?>{
        key: front,
        'citationIds': refs.toSet().toList(),
      };
      if (kind == 'quiz') {
        final multiple = i < 6;
        final type = multiple ? 'multipleChoice' : 'shortAnswer';
        if (value['type'] != type) throw invalid;
        final answer = checked(value['answer'], 700);
        final options = value['options'];
        final index = value['correctIndex'];
        if (multiple) {
          if (options is! List ||
              options.length != 4 ||
              index is! int ||
              index < 0 ||
              index > 3) {
            throw invalid;
          }
          final choices = options.map((o) => checked(o, 350)).toList();
          if (choices.map((o) => o.toLowerCase()).toSet().length != 4 ||
              choices[index] != answer) {
            throw invalid;
          }
          entry.addAll({'options': choices, 'correctIndex': index});
        } else if (options != null || index != null) {
          throw invalid;
        }
        entry.addAll({
          'type': type,
          'answer': answer,
          'explanation': checked(value['explanation'], 1000),
        });
      } else if (kind == 'flashcards') {
        entry['back'] = checked(value['back'], 1000);
      }
      entries.add(entry);
    }
    return {
      'schemaVersion': 1,
      'title': checked(json['title'], 150),
      collection: entries,
    };
  }
}
