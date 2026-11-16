import 'dart:async';
import 'dart:io';

import 'package:poodle_server/notebook_worker.dart';
import 'package:poodle_server/search_worker.dart';
import 'package:serverpod/serverpod.dart' show Session;
import 'package:poodle_server/notebook_worker_runtime.dart';
import 'package:poodle_worker/poodle_worker.dart';
import 'package:poodle_worker/src/jobs/search_index_worker.dart';

Future<void> main(List<String> args) async {
  if (args.any((arg) => !{'--once', '--search-only'}.contains(arg))) {
    stderr.writeln('Usage: dart run bin/main.dart [--once] [--search-only]');
    exitCode = 64;
    return;
  }
  final env = Platform.environment;
  final searchOnly = args.contains('--search-only');

  final model = env['NOTEBOOK_GENERATION_MODEL']?.trim();
  final reasoningEffort = env['NOTEBOOK_REASONING_EFFORT']?.trim();
  final mode = env['NOTEBOOK_SERVER_MODE'] ?? 'development';
  int? price(String name) => int.tryParse(env[name] ?? '');
  final embeddingPrice = price('NOTEBOOK_EMBEDDING_MICROS_PER_MILLION_TOKENS');
  final inputPrice = price('NOTEBOOK_INPUT_MICROS_PER_MILLION_TOKENS');
  final outputPrice = price('NOTEBOOK_OUTPUT_MICROS_PER_MILLION_TOKENS');
  final audioReservation = price('NOTEBOOK_AUDIO_RESERVATION_MICROS') ?? 800000;
  final serverDirectory = Directory(
    env['NOTEBOOK_SERVER_DIRECTORY'] ?? '../poodle_server',
  );
  if (!File('${serverDirectory.path}/pubspec.yaml').existsSync()) {
    stderr.writeln('NOTEBOOK_SERVER_DIRECTORY must point to poodle_server.');
    exitCode = 64;
    return;
  }
  if (!searchOnly &&
      (model == null ||
          model.isEmpty ||
          (reasoningEffort != null &&
              !{
                'none',
                'low',
                'medium',
                'high',
                'xhigh',
                'max',
              }.contains(reasoningEffort)) ||
          [
            embeddingPrice,
            inputPrice,
            outputPrice,
          ].any((value) => value == null || value <= 0))) {
    stderr.writeln(
      'Configure OPENAI_API_KEY or Serverpod openAiApiKey, NOTEBOOK_GENERATION_MODEL and positive '
      'NOTEBOOK_EMBEDDING_MICROS_PER_MILLION_TOKENS, '
      'NOTEBOOK_INPUT_MICROS_PER_MILLION_TOKENS, '
      'NOTEBOOK_OUTPUT_MICROS_PER_MILLION_TOKENS. '
      'NOTEBOOK_SERVER_MODE must be development, staging or production.',
    );
    exitCode = 64;
    return;
  }
  NotebookWorkerRuntime runtime;
  try {
    runtime = await NotebookWorkerRuntime.open(
      serverDirectory: serverDirectory,
      mode: mode,
    );
  } catch (_) {
    stderr.writeln('Worker configuration could not be loaded.');
    exitCode = 1;
    return;
  }
  final searchConfiguration = SearchConfiguration(
    environment: env,
    password: runtime.getPassword,
  );
  final key = searchConfiguration.apiKey;
  if (key == null ||
      key.isEmpty ||
      (!searchOnly &&
          (model == null ||
              model.isEmpty ||
              (reasoningEffort != null &&
                  !{
                    'none',
                    'low',
                    'medium',
                    'high',
                    'xhigh',
                    'max',
                  }.contains(reasoningEffort)) ||
              [
                embeddingPrice,
                inputPrice,
                outputPrice,
              ].any((p) => p == null || p <= 0))) ||
      !{'development', 'staging', 'production'}.contains(mode)) {
    stderr.writeln(
      searchOnly
          ? 'Configure OPENAI_API_KEY or Serverpod openAiApiKey and a valid NOTEBOOK_SERVER_MODE.'
          : 'Configure OPENAI_API_KEY or Serverpod openAiApiKey, NOTEBOOK_GENERATION_MODEL and positive '
                'NOTEBOOK_EMBEDDING_MICROS_PER_MILLION_TOKENS, '
                'NOTEBOOK_INPUT_MICROS_PER_MILLION_TOKENS, '
                'NOTEBOOK_OUTPUT_MICROS_PER_MILLION_TOKENS. '
                'NOTEBOOK_SERVER_MODE must be development, staging or production.',
    );
    exitCode = 64;
    await runtime.close();
    return;
  }
  final embedding = OpenAiEmbeddingProvider(apiKey: key);
  final provider = searchOnly
      ? null
      : OpenAiNotebookProvider(
          apiKey: key,
          generationModel: model!,
          reasoningEffort: reasoningEffort,
        );
  final extractor = NotebookDocumentExtractor(
    pythonExecutable: env['NOTEBOOK_PYTHON_EXECUTABLE'] ?? 'python3',
    pdfInfoExecutable: env['NOTEBOOK_PDFINFO_EXECUTABLE'] ?? 'pdfinfo',
    pdfTextExecutable: env['NOTEBOOK_PDFTOTEXT_EXECUTABLE'] ?? 'pdftotext',
    pdfRasterExecutable: env['NOTEBOOK_PDFTOPPM_EXECUTABLE'] ?? 'pdftoppm',
    tesseractExecutable: env['NOTEBOOK_TESSERACT_EXECUTABLE'] ?? 'tesseract',
  );
  final search = SearchIndexWorker(provider: embedding, extractor: extractor);
  final speech = provider == null
      ? null
      : OpenAiNotebookSpeechProvider(apiKey: key);
  final workers = <Future<bool> Function(Session)>[
    if (provider != null)
      NotebookIngestionWorker(
        provider: provider,
        extractor: extractor,
        embeddingSpace: 'openai:text-embedding-3-small:1536:v1',
        embeddingMicrosPerMillionTokens: embeddingPrice!,
      ).runOnce,
    if (provider != null)
      NotebookChatWorker(
        provider: provider,
        embeddingSpace: 'openai:text-embedding-3-small:1536:v1',
        embeddingMicrosPerMillionTokens: embeddingPrice!,
        generationInputMicrosPerMillionTokens: inputPrice!,
        generationOutputMicrosPerMillionTokens: outputPrice!,
      ).runOnce,
    if (provider != null && speech != null)
      NotebookStudioWorker(
        provider: provider,
        embeddingSpace: 'openai:text-embedding-3-small:1536:v1',
        embeddingMicrosPerMillionTokens: embeddingPrice!,
        generationInputMicrosPerMillionTokens: inputPrice!,
        generationOutputMicrosPerMillionTokens: outputPrice!,
        narrate: speech.narrate,
        audioReservationMicros: audioReservation,
        ffmpeg: env['NOTEBOOK_FFMPEG'] ?? 'ffmpeg',
        ffprobe: env['NOTEBOOK_FFPROBE'] ?? 'ffprobe',
      ).runOnce,
    if (searchConfiguration.enabled) search.runOnce,
  ];
  final stopped = Completer<void>();
  void stop(ProcessSignal _) {
    if (!stopped.isCompleted) stopped.complete();
  }

  final signals = [
    ProcessSignal.sigint.watch().listen(stop),
    ProcessSignal.sigterm.watch().listen(stop),
  ];
  try {
    do {
      var didWork = false;
      for (final worker in workers) {
        if (stopped.isCompleted) break;
        final session = await runtime.createSession();
        try {
          didWork = await worker(session) || didWork;
        } finally {
          await session.close();
        }
      }
      if (args.contains('--once') || stopped.isCompleted) break;
      if (!didWork) {
        await Future.any([
          stopped.future,
          Future<void>.delayed(const Duration(seconds: 2)),
        ]);
      }
    } while (!stopped.isCompleted);
  } catch (_) {
    // Database/provider exceptions may carry private SQL or request bodies.
    stderr.writeln(
      'Notebook worker stopped. Check database, migrations and local configuration.',
    );
    exitCode = 1;
  } finally {
    for (final signal in signals) {
      await signal.cancel();
    }
    provider?.close();
    speech?.close();
    embedding.close();
    await runtime.close();
  }
}
