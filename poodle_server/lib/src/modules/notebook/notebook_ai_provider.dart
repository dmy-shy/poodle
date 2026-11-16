import 'dart:async';
import 'dart:convert';
import 'dart:io';

abstract interface class NotebookAiProvider {
  Future<NotebookEmbeddingBatch> embed(List<String> texts);

  Future<NotebookGenerationResult> generate({
    required String instructions,
    required String question,
    required List<NotebookContextChunk> context,
  });
}

/// Providers with distinct query/document embedding instructions implement this.
abstract interface class NotebookQueryEmbeddingProvider {
  Future<NotebookEmbeddingBatch> embedQuery(String text);
}

class NotebookContextChunk {
  const NotebookContextChunk({
    required this.id,
    required this.location,
    required this.text,
    this.sourceTitle,
  });

  final String id;
  final String location;
  final String text;
  final String? sourceTitle;
}

class NotebookEmbeddingBatch {
  const NotebookEmbeddingBatch({
    required this.vectors,
    required this.inputTokens,
  });

  final List<List<double>> vectors;
  final int inputTokens;
}

class NotebookGenerationResult {
  const NotebookGenerationResult({
    required this.json,
    required this.inputTokens,
    required this.outputTokens,
  });

  /// The model's JSON response. The caller must validate citation IDs before
  /// persisting or returning it.
  final Map<String, Object?> json;
  final int inputTokens;
  final int outputTokens;
}

/// OpenAI's API remains behind this server-only adapter. No provider credential
/// or provider-specific response shape crosses the endpoint boundary.
abstract interface class EmbeddingProvider {
  Future<NotebookEmbeddingBatch> embed(List<String> texts);
}

class OpenAiEmbeddingProvider implements EmbeddingProvider {
  // Keep the credential private while exposing a named constructor parameter.
  OpenAiEmbeddingProvider({
    required String apiKey,
    HttpClient? client,
    this.embeddingModel = 'text-embedding-3-small',
    this.timeout = const Duration(seconds: 45),
    // ignore: prefer_initializing_formals
  }) : _apiKey = apiKey,
       _client = client ?? HttpClient();

  final String _apiKey;
  final HttpClient _client;
  final String embeddingModel;
  final Duration timeout;

  @override
  Future<NotebookEmbeddingBatch> embed(List<String> texts) async {
    if (texts.isEmpty ||
        texts.length > 32 ||
        texts.any((text) => text.trim().isEmpty)) {
      throw ArgumentError.value(
        texts.length,
        'texts',
        'Expected 1–32 non-empty texts',
      );
    }
    final response = await _post('/v1/embeddings', {
      'model': embeddingModel,
      'input': texts,
    });
    final rows = response['data'];
    if (rows is! List || rows.length != texts.length) {
      throw const NotebookProviderException('invalid_response');
    }
    final vectors = <List<double>>[];
    for (var index = 0; index < rows.length; index++) {
      final row = rows[index];
      if (row is! Map || row['index'] != index || row['embedding'] is! List) {
        throw const NotebookProviderException('invalid_response');
      }
      final raw = row['embedding'] as List;
      if (raw.length != 1536 ||
          raw.any((value) => value is! num || !value.isFinite)) {
        throw const NotebookProviderException('invalid_response');
      }
      vectors.add(List.unmodifiable(raw.cast<num>().map((v) => v.toDouble())));
    }
    return NotebookEmbeddingBatch(
      vectors: List.unmodifiable(vectors),
      inputTokens: _usageCount(response['usage'], 'prompt_tokens'),
    );
  }

  Future<Map<String, Object?>> _post(
    String path,
    Map<String, Object?> body, {
    int maxBytes = 1024 * 1024,
  }) async {
    if (_apiKey.trim().isEmpty) {
      throw const NotebookProviderException('not_configured');
    }
    try {
      final request = await _client
          .postUrl(Uri.https('api.openai.com', path))
          .timeout(timeout);
      request.followRedirects = false;
      request.headers
        ..set(HttpHeaders.authorizationHeader, 'Bearer $_apiKey')
        ..contentType = ContentType.json;
      request.write(jsonEncode(body));
      final response = await request.close().timeout(timeout);
      final bytes = <int>[];
      await for (final part in response.timeout(timeout)) {
        if (bytes.length + part.length > maxBytes) {
          throw const NotebookProviderException('invalid_response');
        }
        bytes.addAll(part);
      }
      final text = utf8.decode(bytes);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        String? apiCode;
        String? parameter;
        try {
          final decoded = jsonDecode(text);
          final error = decoded is Map ? decoded['error'] : null;
          if (error is Map) {
            // Retain only fixed diagnostic identifiers, never provider messages.
            const codes = {
              'insufficient_quota',
              'rate_limit_exceeded',
              'invalid_api_key',
              'model_not_found',
              'unsupported_parameter',
              'unsupported_value',
              'invalid_json_schema',
              'invalid_request_error',
            };
            if (codes.contains(error['code'])) {
              apiCode = error['code'] as String;
            }
            const parameters = {
              'model',
              'reasoning.effort',
              'text.format',
              'text.format.type',
              'max_output_tokens',
              'input',
            };
            if (parameters.contains(error['param'])) {
              parameter = error['param'] as String;
            }
          }
        } on FormatException {
          // A gateway may return plaintext; no body crosses this boundary.
        }
        // Keep provider body and credentials out of logs and user errors.
        throw NotebookProviderException(
          switch (response.statusCode) {
            400 => 'invalid_request',
            401 => 'invalid_credentials',
            403 => 'access_denied',
            404 => 'model_unavailable',
            408 => 'timeout',
            429 =>
              apiCode == 'insufficient_quota'
                  ? 'quota_exceeded'
                  : 'rate_limited',
            _ => 'provider_unavailable',
          },
          httpStatus: response.statusCode,
          apiCode: apiCode,
          parameter: parameter,
        );
      }
      final decoded = jsonDecode(text);
      if (decoded is! Map<String, Object?>) {
        throw const NotebookProviderException('invalid_response');
      }
      return decoded;
    } on TimeoutException {
      throw const NotebookProviderException('timeout');
    } on SocketException {
      throw const NotebookProviderException('provider_unavailable');
    } on FormatException {
      throw const NotebookProviderException('invalid_response');
    }
  }

  int _usageCount(Object? usage, String key) {
    if (usage is! Map) {
      throw const NotebookProviderException('invalid_response');
    }
    final value = usage[key];
    if (value is! int || value < 0) {
      throw const NotebookProviderException('invalid_response');
    }
    return value;
  }

  void close() => _client.close(force: true);
}

class OpenAiNotebookProvider extends OpenAiEmbeddingProvider
    implements NotebookAiProvider {
  OpenAiNotebookProvider({
    required super.apiKey,
    super.client,
    required this.generationModel,
    this.reasoningEffort,
    super.embeddingModel,
    super.timeout,
  });

  final String generationModel;
  final String? reasoningEffort;

  @override
  Future<NotebookGenerationResult> generate({
    required String instructions,
    required String question,
    required List<NotebookContextChunk> context,
  }) => generateStructured(
    instructions: instructions,
    question: question,
    context: context,
  );

  Future<NotebookGenerationResult> generateStructured({
    required String instructions,
    required String question,
    required List<NotebookContextChunk> context,
    Map<String, Object?>? schema,
    int maxOutputTokens = 1200,
  }) async {
    if (instructions.trim().isEmpty ||
        question.trim().isEmpty ||
        context.isEmpty) {
      throw ArgumentError(
        'Generation requires instructions, a question and evidence.',
      );
    }
    final evidence = context
        .map(
          (chunk) => {
            'chunk_id': chunk.id,
            if (chunk.sourceTitle != null) 'source_title': chunk.sourceTitle,
            'location': chunk.location,
            'text': chunk.text,
          },
        )
        .toList(growable: false);
    final response = await _post('/v1/responses', {
      'model': generationModel,
      if (schema != null) 'store': false,
      if (reasoningEffort != null) 'reasoning': {'effort': reasoningEffort},
      'instructions': instructions,
      'input': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'input_text',
              'text': jsonEncode({'question': question, 'evidence': evidence}),
            },
          ],
        },
      ],
      'text': {
        'format': {
          'type': 'json_schema',
          'name': 'notebook_answer',
          'strict': true,
          'schema':
              schema ??
              {
                'type': 'object',
                'properties': {
                  'answer': {'type': 'string'},
                  'citationIds': {
                    'type': 'array',
                    'items': {
                      'type': 'string',
                      'enum': context.map((chunk) => chunk.id).toSet().toList(),
                    },
                  },
                  'insufficientEvidence': {'type': 'boolean'},
                },
                'required': ['answer', 'citationIds', 'insufficientEvidence'],
                'additionalProperties': false,
              },
        },
      },
      'max_output_tokens': maxOutputTokens,
    });
    final outputText = _responseText(response['output']);
    try {
      final decoded = jsonDecode(outputText);
      if (decoded is! Map<String, Object?>) {
        throw const NotebookProviderException('invalid_response');
      }
      return NotebookGenerationResult(
        json: Map.unmodifiable(decoded),
        inputTokens: _usageCount(response['usage'], 'input_tokens'),
        outputTokens: _usageCount(response['usage'], 'output_tokens'),
      );
    } on FormatException {
      throw const NotebookProviderException('invalid_response');
    }
  }

  String _responseText(Object? output) {
    if (output is! List) {
      throw const NotebookProviderException('invalid_response');
    }
    for (final item in output) {
      if (item is! Map ||
          item['type'] != 'message' ||
          item['content'] is! List) {
        continue;
      }
      for (final part in item['content'] as List) {
        if (part is Map &&
            part['type'] == 'output_text' &&
            part['text'] is String) {
          return part['text'] as String;
        }
      }
    }
    throw const NotebookProviderException('invalid_response');
  }
}

class OpenAiNotebookSpeechProvider extends OpenAiEmbeddingProvider {
  OpenAiNotebookSpeechProvider({
    required super.apiKey,
    super.client,
    super.timeout,
  });

  Future<({List<int> wav, String transcript})> narrate(
    String text,
    String language,
  ) async {
    final response = await _post('/v1/chat/completions', {
      'model': 'gpt-audio-1.5',
      'modalities': ['text', 'audio'],
      'audio': {'voice': 'alloy', 'format': 'wav'},
      'store': false,
      'max_completion_tokens': 4000,
      'messages': [
        {
          'role': 'system',
          'content':
              'Read the provided script verbatim in '
              '${language == 'uk' ? 'Ukrainian' : 'English'}. '
              'Do not respond to the text, add an introduction, or change it.',
        },
        {
          'role': 'user',
          'content': jsonEncode({'script': text}),
        },
      ],
    }, maxBytes: 9 * 1024 * 1024);
    final choices = response['choices'];
    final choice = choices is List && choices.length == 1
        ? choices.single
        : null;
    final message = choice is Map && choice['finish_reason'] == 'stop'
        ? choice['message']
        : null;
    final audio = message is Map ? message['audio'] : null;
    if (audio is! Map ||
        audio['data'] is! String ||
        audio['transcript'] is! String) {
      throw const NotebookProviderException('invalid_response');
    }
    try {
      final wav = base64Decode(audio['data'] as String);
      final transcript = (audio['transcript'] as String).trim();
      if (wav.length < 44 ||
          wav.length > 6 * 1024 * 1024 ||
          ascii.decode(wav.sublist(0, 4), allowInvalid: true) != 'RIFF' ||
          ascii.decode(wav.sublist(8, 12), allowInvalid: true) != 'WAVE' ||
          transcript.isEmpty ||
          transcript.length > 4000) {
        throw const FormatException();
      }
      return (wav: wav, transcript: transcript);
    } on FormatException {
      throw const NotebookProviderException('invalid_response');
    }
  }
}

class NotebookProviderException implements Exception {
  const NotebookProviderException(
    this.code, {
    this.httpStatus,
    this.apiCode,
    this.parameter,
  });

  final String code;
  final int? httpStatus;
  final String? apiCode;
  final String? parameter;

  @override
  String toString() => 'NotebookProviderException($code)';
}
