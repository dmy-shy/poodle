import 'dart:convert';
import 'dart:io';

import 'package:poodle_server/notebook_worker.dart';
import 'package:poodle_server/src/auth/identity_auth_config.dart';
import 'package:poodle_server/src/generated/protocol.dart';
import 'package:poodle_server/src/modules/course_content/development_course_seed.dart';
import 'package:poodle_server/src/modules/notebook/development_notebook_seed.dart';
import 'package:poodle_worker/poodle_worker.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/server.dart' show ServerInternalMethods;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../../../poodle_server/test/integration/test_tools/serverpod_test_tools.dart';

class _ObservedProvider implements NotebookAiProvider {
  _ObservedProvider(this.delegate);
  final OpenAiNotebookProvider delegate;
  final failures = <Map<String, Object?>>[];
  Future<T> _observe<T>(String operation, Future<T> Function() request) async {
    try {
      return await request();
    } on NotebookProviderException catch (error) {
      failures.add({
        'operation': operation,
        'code': error.code,
        'httpStatus': error.httpStatus,
        'apiCode': error.apiCode,
        'parameter': error.parameter,
      });
      rethrow;
    }
  }

  @override
  Future<NotebookEmbeddingBatch> embed(List<String> texts) =>
      _observe('embed', () => delegate.embed(texts));
  @override
  Future<NotebookGenerationResult> generate({
    required String instructions,
    required String question,
    required List<NotebookContextChunk> context,
  }) => _observe(
    'generate',
    () => delegate.generate(
      instructions: instructions,
      question: question,
      context: context,
    ),
  );
}

/// Explicitly opt-in: routine tests never use a developer's credential or incur
/// provider charges. Only the original public bilingual demo notes are sent.
void main() {
  if (Platform.environment['NOTEBOOK_LIVE_TEST'] != '1') {
    test(
      'live OpenAI notebook demo (opt-in)',
      () {},
      skip:
          'Set NOTEBOOK_LIVE_TEST=1 and supply the demo environment explicitly.',
    );
    return;
  }
  withServerpod(
    'Live GPT-6 Luna notebook demo',
    (builder, endpoints) {
      test(
        'real bytes → embeddings → JWT question → cited bilingual answers and refusal',
        () async {
          final key = Platform.environment['OPENAI_API_KEY'];
          expect(
            key != null && key.trim().isNotEmpty,
            true,
            reason:
                'A locally configured API key is required; never paste it into test output.',
          );
          final session = builder.build();
          addTearDown(session.close);
          session.serverpod.initializeAuthServices(
            tokenManagerBuilders: [
              JwtConfig(
                algorithm: JwtAlgorithm.hmacSha512(
                  SecretKey('isolated-notebook-demo-signing-key'),
                ),
                refreshTokenHashPepper: 'isolated-demo-refresh-pepper',
                issuer: 'poodle',
              ),
            ],
            identityProviderBuilders: [
              identityEmailConfig(
                pepper: 'isolated-demo-email-pepper',
                runMode: ServerpodRunMode.test,
              ),
            ],
          );
          session.serverpod.server.setAuthenticationHandlerForTesting(
            AuthServices.instance.authenticationHandler,
          );
          final http = HttpClient()
            ..connectionTimeout = const Duration(seconds: 15);
          addTearDown(() => http.close(force: true));
          Future<dynamic> request(
            String endpoint,
            String method,
            Map<String, Object?> body, {
            String? token,
          }) async {
            final request = await http.postUrl(
              Uri.parse(
                'http://127.0.0.1:${session.serverpod.server.port}/$endpoint/$method',
              ),
            );
            request.headers.contentType = ContentType.json;
            if (token != null) {
              request.headers.set(
                HttpHeaders.authorizationHeader,
                'Bearer $token',
              );
            }
            request.write(jsonEncode(body));
            final response = await request.close();
            final text = await utf8.decoder.bind(response).join();
            expect(
              response.statusCode,
              200,
              reason: 'Local demo endpoint $endpoint/$method failed.',
            );
            return text.isEmpty ? null : jsonDecode(text);
          }

          final teacher = await AuthUser.db.insertRow(
            session,
            AuthUser(scopeNames: <String>{}, blocked: false),
          );
          await AccountAccess.db.insertRow(
            session,
            AccountAccess(authUserId: teacher.id!, developmentBootstrap: true),
          );
          await DevelopmentCourseSeed.ensure(session, testFixture: true);
          await DevelopmentNotebookSeed.ensure(session, testFixture: true);
          final courseId = UuidValue.withValidation(
            DevelopmentCourseSeed.courseIds.first,
          );
          final config = (await NotebookAssessmentConfigRecord.db.find(
            session,
            where: (t) => t.courseId.equals(courseId),
          )).single;
          final source = (await NotebookSourceRecord.db.find(
            session,
            where: (t) => t.courseId.equals(courseId),
          )).single;
          final adapter = OpenAiNotebookProvider(
            apiKey: key!,
            generationModel: 'gpt-6-luna',
            reasoningEffort: 'none',
            timeout: const Duration(seconds: 45),
          );
          addTearDown(adapter.close);
          final provider = _ObservedProvider(adapter);
          const space = 'openai:text-embedding-3-small:1536:v1';
          final embeddingPrice = int.parse(
            Platform
                .environment['NOTEBOOK_EMBEDDING_MICROS_PER_MILLION_TOKENS']!,
          );
          final inputPrice = int.parse(
            Platform.environment['NOTEBOOK_INPUT_MICROS_PER_MILLION_TOKENS']!,
          );
          final outputPrice = int.parse(
            Platform.environment['NOTEBOOK_OUTPUT_MICROS_PER_MILLION_TOKENS']!,
          );
          final ingestion = NotebookIngestionWorker(
            provider: provider,
            embeddingSpace: space,
            embeddingMicrosPerMillionTokens: embeddingPrice,
          );
          expect(await ingestion.runOnce(session), true);
          final ingestionJob = (await NotebookJobRecord.db.findFirstRow(
            session,
            where: (t) =>
                t.sourceId.equals(source.id) & t.jobType.equals('ingest'),
          ))!;
          expect(
            ingestionJob.status,
            'complete',
            reason: 'Ingestion safe failure code: ${ingestionJob.failureCode}',
          );
          final ready = (await NotebookSourceRecord.db.findById(
            session,
            source.id!,
          ))!;
          expect(ready.status, 'ready');
          final chunks = await NotebookChunkRecord.db.find(
            session,
            where: (t) => t.sourceId.equals(source.id),
          );
          expect(chunks, isNotEmpty);
          final student = await AuthServices.instance.authUsers.create(session);
          await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
            session,
            authUserId: student.id,
            email: 'notebook-live-student@example.test',
            password: 'Demo-only-password-123',
          );
          await AccountAccess.db.insertRow(
            session,
            AccountAccess(authUserId: student.id),
          );
          await CourseMembership.db.insertRow(
            session,
            CourseMembership(
              courseId: courseId,
              authUserId: student.id,
              role: 'student',
            ),
          );
          final login = await request('emailIdp', 'login', {
            'email': 'notebook-live-student@example.test',
            'password': 'Demo-only-password-123',
          });
          final token = AuthSuccess.fromJson(
            Map<String, dynamic>.from(login as Map),
          ).token;
          final opened = await request('notebook', 'openNotebook', {
            'courseId': courseId.toString(),
            'assessmentActivityId': config.assessmentActivityId.toString(),
          }, token: token);
          final notebookId = UuidValue.withValidation(
            opened['notebookId'] as String,
          );
          final worker = NotebookChatWorker(
            provider: provider,
            embeddingSpace: space,
            embeddingMicrosPerMillionTokens: embeddingPrice,
            generationInputMicrosPerMillionTokens: inputPrice,
            generationOutputMicrosPerMillionTokens: outputPrice,
          );
          final answers = <Map<String, Object?>>[];
          final cases = [
            (
              question: 'What does a citation identify?',
              language: 'en',
              insufficient: false,
            ),
            (
              question: 'Що визначає посилання?',
              language: 'uk',
              insufficient: false,
            ),
            (
              question:
                  'What is the exact launch date of the imaginary spacecraft Starflower 99?',
              language: 'en',
              insufficient: true,
            ),
          ];
          for (var i = 0; i < cases.length; i++) {
            final scenario = cases[i];
            final job = await request('notebook', 'ask', {
              'input': {
                '__className__': 'NotebookChatInput',
                'notebookId': notebookId.toString(),
                'question': scenario.question,
                'requestKey': 'live-demo-$i',
              },
            }, token: token);
            dynamic status;
            for (var attempt = 0; attempt < 3; attempt++) {
              if (attempt > 0) {
                final stored = (await NotebookJobRecord.db.findById(
                  session,
                  UuidValue.withValidation(job['id'] as String),
                ))!;
                final delay = stored.leaseExpiresAt!.difference(
                  DateTime.now().toUtc(),
                );
                if (!delay.isNegative) {
                  await Future<void>.delayed(
                    delay + const Duration(milliseconds: 100),
                  );
                }
              }
              expect(await worker.runOnce(session), true);
              status = await request('notebook', 'getJobStatus', {
                'notebookId': notebookId.toString(),
                'jobId': job['id'],
              }, token: token);
              if (status['status'] != 'queued') break;
            }
            expect(
              status['status'],
              'complete',
              reason:
                  'Chat safe failure code: ${status['failureCode']}; diagnostics: ${provider.failures}',
            );
            final history =
                await request('notebook', 'getTurns', {
                      'notebookId': notebookId.toString(),
                    }, token: token)
                    as List;
            expect(history, hasLength((i + 1) * 2));
            final answer = Map<String, dynamic>.from(history.last as Map);
            expect(answer['stale'], false);
            expect(answer['insufficientEvidence'], scenario.insufficient);
            final citations = answer['citations'] as List;
            if (scenario.insufficient) {
              expect(citations, isEmpty);
            } else {
              expect(citations, isNotEmpty);
              for (final citation in citations.cast<Map>()) {
                expect(citation['sourceId'], source.id.toString());
                expect(
                  chunks.any((c) => c.id.toString() == citation['chunkId']),
                  true,
                );
              }
              expect(
                (answer['content'] as String).toLowerCase(),
                contains(scenario.language == 'uk' ? 'верс' : 'version'),
              );
              if (scenario.language == 'uk') {
                expect(
                  RegExp('[ІіЇїЄєҐґ]').hasMatch(answer['content'] as String),
                  true,
                );
              }
            }
            answers.add({
              'language': scenario.language,
              'question': scenario.question,
              'answer': answer['content'],
              'citations': citations,
              'insufficientEvidence': scenario.insufficient,
            });
          }
          final usage = (await NotebookUsageMonthRecord.db.findFirstRow(
            session,
          ))!;
          expect(usage.reservedMicros, 0);
          expect(usage.spentMicros, greaterThan(0));
          final reportPath = Platform.environment['NOTEBOOK_LIVE_REPORT'];
          if (reportPath != null) {
            await File(reportPath).writeAsString(
              const JsonEncoder.withIndent('  ').convert({
                'testedAtUtc': DateTime.now().toUtc().toIso8601String(),
                'generationModel': 'gpt-6-luna',
                'reasoningEffort': 'none',
                'embeddingSpace': space,
                'database': 'isolated Serverpod test database',
                'ingestionStatus': ingestionJob.status,
                'chunks': chunks.length,
                'accountedSpentMicros': usage.spentMicros,
                'reservedMicros': usage.reservedMicros,
                'answers': answers,
                'providerFailures': provider.failures,
              }),
            );
          }
        },
        timeout: const Timeout(Duration(minutes: 5)),
      );
    },
    serverDirectory: Directory('../poodle_server').absolute,
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
