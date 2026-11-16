import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:poodle_server/notebook_worker.dart';
import 'package:test/test.dart';

class _Headers implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _Response extends Stream<List<int>> implements HttpClientResponse {
  _Response(this.body, this.statusCode);
  final String body;
  @override
  final int statusCode;
  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => Stream.value(utf8.encode(body)).listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Request implements HttpClientRequest {
  _Request(this.response);
  final _Response response;
  final content = StringBuffer();
  @override
  final HttpHeaders headers = _Headers();
  @override
  bool followRedirects = true;
  @override
  void write(Object? object) => content.write(object);
  @override
  Future<HttpClientResponse> close() async => response;
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _Client implements HttpClient {
  String response = '{}';
  int status = 200;
  late _Request request;
  Uri? url;
  @override
  Future<HttpClientRequest> postUrl(Uri value) async {
    url = value;
    request = _Request(_Response(response, status));
    return request;
  }

  @override
  void close({bool force = false}) {}
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  late _Client transport;
  late OpenAiNotebookProvider provider;
  setUp(() {
    transport = _Client();
    provider = OpenAiNotebookProvider(
      apiKey: 'fake-test-credential',
      generationModel: 'configured-model',
      reasoningEffort: 'none',
      client: transport,
    );
    addTearDown(provider.close);
  });
  Future<NotebookGenerationResult> generate() => provider.generate(
    instructions: 'Return JSON from evidence',
    question: 'What is retrieval?',
    context: [
      const NotebookContextChunk(
        id: 'chunk-1',
        location: 'block-1',
        text: 'Evidence',
        sourceTitle: 'Course notes',
      ),
    ],
  );
  Matcher code(String value) => isA<NotebookProviderException>().having(
    (e) => e.code,
    'safe code',
    value,
  );
  test('embedding request pins model and rejects redirects', () async {
    transport.response = jsonEncode({
      'data': [
        {'index': 0, 'embedding': List.filled(1536, 0.1)},
      ],
      'usage': {'prompt_tokens': 3},
    });
    final batch = await provider.embed(['Evidence']);
    expect(batch.vectors.single, hasLength(1536));
    expect(batch.inputTokens, 3);
    expect(transport.url.toString(), 'https://api.openai.com/v1/embeddings');
    expect(transport.request.followRedirects, false);
    expect(
      jsonDecode(transport.request.content.toString())['model'],
      'text-embedding-3-small',
    );
  });
  test('generation maps structured output and usage', () async {
    transport.response = jsonEncode({
      'output': [
        {
          'type': 'message',
          'content': [
            {
              'type': 'output_text',
              'text': jsonEncode({
                'answer': 'Answer',
                'citationIds': ['chunk-1'],
                'insufficientEvidence': false,
              }),
            },
          ],
        },
      ],
      'usage': {'input_tokens': 20, 'output_tokens': 8},
    });
    final result = await generate();
    expect(result.json['citationIds'], ['chunk-1']);
    expect(result.inputTokens, 20);
    final format = jsonDecode(
      transport.request.content.toString(),
    )['text']['format'];
    expect(format['type'], 'json_schema');
    expect(format['strict'], true);
    expect(format['schema']['additionalProperties'], false);
    expect(format['schema']['properties']['citationIds']['items']['enum'], [
      'chunk-1',
    ]);
    final request = jsonDecode(transport.request.content.toString());
    final input = jsonDecode(
      request['input'][0]['content'][0]['text'] as String,
    );
    expect(input['evidence'][0]['source_title'], 'Course notes');
    expect(format['schema']['required'], [
      'answer',
      'citationIds',
      'insufficientEvidence',
    ]);
    expect(transport.url!.path, '/v1/responses');
    expect(jsonDecode(transport.request.content.toString())['reasoning'], {
      'effort': 'none',
    });
    expect(
      jsonDecode(transport.request.content.toString())['model'],
      'configured-model',
    );
  });
  test('invalid vectors, row order and missing usage are rejected', () async {
    for (final response in [
      {
        'data': [
          {
            'index': 0,
            'embedding': [0.1],
          },
        ],
        'usage': {'prompt_tokens': 1},
      },
      {
        'data': [
          {'index': 1, 'embedding': List.filled(1536, 0.1)},
        ],
        'usage': {'prompt_tokens': 1},
      },
      {
        'data': [
          {'index': 0, 'embedding': List.filled(1536, 0.1)},
        ],
      },
    ]) {
      transport.response = jsonEncode(response);
      await expectLater(
        provider.embed(['Evidence']),
        throwsA(code('invalid_response')),
      );
    }
  });
  test('throttled and failed requests expose safe codes only', () async {
    transport.response = 'Private provider diagnostic';
    transport.status = 429;
    await expectLater(
      provider.embed(['Evidence']),
      throwsA(code('rate_limited')),
    );
    transport.status = 503;
    await expectLater(
      provider.embed(['Evidence']),
      throwsA(code('provider_unavailable')),
    );
  });
  test(
    'permanent HTTP failures are classified without private messages',
    () async {
      for (final entry in {
        400: 'invalid_request',
        401: 'invalid_credentials',
        403: 'access_denied',
        404: 'model_unavailable',
        408: 'timeout',
        429: 'quota_exceeded',
      }.entries) {
        transport.status = entry.key;
        transport.response = jsonEncode({
          'error': {
            'code': 'insufficient_quota',
            'param': 'input',
            'message': 'private credential and evidence',
          },
        });
        await expectLater(
          generate(),
          throwsA(
            isA<NotebookProviderException>()
                .having((e) => e.code, 'code', entry.value)
                .having((e) => e.httpStatus, 'status', entry.key)
                .having((e) => e.parameter, 'parameter', 'input')
                .having(
                  (e) => e.toString(),
                  'safe diagnostic',
                  isNot(contains('private')),
                ),
          ),
        );
      }
    },
  );
  test('malformed and oversized responses are bounded', () async {
    for (final body in ['not JSON', '[]', 'x' * (1024 * 1024 + 1)]) {
      transport.response = body;
      await expectLater(generate(), throwsA(code('invalid_response')));
    }
  });
  test('missing output or invalid generated JSON is rejected', () async {
    for (final output in [
      [],
      [
        {
          'type': 'message',
          'content': [
            {'type': 'output_text', 'text': 'not JSON'},
          ],
        },
      ],
    ]) {
      transport.response = jsonEncode({
        'output': output,
        'usage': {'input_tokens': 2, 'output_tokens': 1},
      });
      await expectLater(generate(), throwsA(code('invalid_response')));
    }
  });
}
