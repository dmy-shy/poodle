import '../../core/course_tenancy.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import '../courses/course_policy.dart';
import '../notebook/notebook_ai_provider.dart';
import 'search_document.dart';
import 'search_configuration.dart';

class SearchService {
  SearchService({
    EmbeddingProvider? embeddings,
    DateTime Function()? clock,
    bool? semanticEnabled,
    double? minimumSimilarity,
    // Public injection names keep callers independent of private fields.
    // ignore: prefer_initializing_formals
  }) : _embeddings = embeddings,
       _clock = clock ?? DateTime.now,
       // ignore: prefer_initializing_formals
       _semanticEnabled = semanticEnabled,
       _minimumSimilarity = _threshold(
         minimumSimilarity ??
             double.tryParse(
               Platform.environment['POODLE_SEARCH_MIN_SIMILARITY'] ?? '',
             ),
       );

  static double _threshold(double? value) =>
      value != null && value.isFinite && value >= 0 && value <= 1
      ? value
      : 0.30;

  final EmbeddingProvider? _embeddings;
  final DateTime Function() _clock;
  final bool? _semanticEnabled;
  final double _minimumSimilarity;
  final _requests = <UuidValue, List<DateTime>>{};

  String _query(String raw) {
    final value = raw.trim().replaceAll(RegExp(r'\s+', unicode: true), ' ');
    if (value.isEmpty ||
        value.runes.length > 500 ||
        RegExp(r'[\x00-\x1f\x7f-\x9f]').hasMatch(value)) {
      throw SearchError(code: 'invalid_query');
    }
    return value;
  }

  bool _allowEmbedding(UuidValue user) {
    final now = _clock();
    final cutoff = now.subtract(const Duration(minutes: 1));
    for (final times in _requests.values) {
      times.removeWhere((time) => !time.isAfter(cutoff));
    }
    _requests.removeWhere((_, times) => times.isEmpty);
    final times = _requests.putIfAbsent(user, () => []);
    if (times.length >= 30) return false;
    times.add(now);
    return true;
  }

  Future<Map<String, SearchDocument>> _eligible(
    Session session,
    UuidValue user,
    UuidValue? course,
    String? kind,
  ) async {
    final members = await CourseTenancy.filter(
      session,
      await CourseMembership.db.find(
        session,
        where: (t) => t.authUserId.equals(user) & t.active.equals(true),
      ),
    );
    final roles = {
      for (final m in members)
        if ((course == null || m.courseId == course) &&
            CoursePolicy.canRead(active: m.active, role: m.role))
          m.courseId: m.role,
    };
    return {
      for (final doc in await SearchDocument.catalog(
        session,
        roles: roles,
        courseId: course,
      ))
        if (kind == null || doc.hit.kind == kind) doc.fingerprint: doc,
    };
  }

  Future<SearchResponse> search(
    Session session,
    String raw, {
    UuidValue? courseId,
    String? kind,
  }) async {
    final timer = Stopwatch()..start();
    final user = (await AccountAuthorization.requireAccount(
      session,
    )).authUserId;
    final query = _query(raw);
    if (kind != null &&
        !const {'course', 'section', 'activity'}.contains(kind)) {
      throw SearchError(code: 'invalid_kind');
    }
    var docs = await _eligible(session, user, courseId, kind);
    List<double>? vector;
    var embeddingTokens = 0;
    final config = SearchConfiguration(
      environment: Platform.environment,
      password: (name) => session.passwords[name],
    );
    final enabled =
        _semanticEnabled ?? (_embeddings != null || config.available);
    OpenAiEmbeddingProvider? ownedProvider;
    if (docs.isNotEmpty && enabled && _allowEmbedding(user)) {
      final provider =
          _embeddings ??
          (ownedProvider = OpenAiEmbeddingProvider(
            apiKey: config.apiKey ?? '',
            timeout: const Duration(seconds: 7),
          ));

      try {
        final batch = await provider
            .embed([query])
            .timeout(const Duration(seconds: 8));
        final candidate = batch.vectors.single;
        if (candidate.length == 1536 &&
            candidate.every((x) => x.isFinite) &&
            candidate.any((x) => x != 0)) {
          vector = candidate;
          embeddingTokens = batch.inputTokens;
        }
      } on NotebookProviderException {
        // The response still contains lexical matches.
      } on TimeoutException {
        // The response still contains lexical matches.
      } on StateError {
        // Invalid provider response.
      } finally {
        ownedProvider?.close();
      }
      await AccountAuthorization.requireAccount(session);
      docs = await _eligible(session, user, courseId, kind);
    }
    if (docs.isEmpty) {
      return SearchResponse(
        results: [],
        keywordOnly: vector == null,
        incomplete: false,
        capped: false,
      );
    }

    // Match only current, authorized fingerprints, including metadata for
    // targets whose asynchronous embedding or file extraction is unfinished.
    // PostgreSQL initialized with a C locale may not case-fold Ukrainian.
    // The explicit Ukrainian fold and substring fallback also cover that case.
    final rows = await session.db.unsafeQuery(
      r'''
      WITH targets AS (
        SELECT * FROM jsonb_to_recordset(CAST(@targets AS jsonb))
          AS t(fingerprint text, title text, content text)
      ), indexed AS (
        SELECT t.fingerprint, c.content, c.page, c.location, c.ordinal,
          CASE WHEN c."embeddingSpace" = @space THEN c.embedding END AS embedding
        FROM targets t JOIN poodle_search_index_job j ON j.fingerprint = t.fingerprint
          AND j.state = 'ready'
        JOIN poodle_search_index_chunk c ON c."jobId" = j.id
      ), candidates AS (
        SELECT fingerprint, content, page, location, ordinal, embedding FROM indexed
        UNION ALL
        SELECT fingerprint, content, NULL, NULL, -1, NULL FROM targets
      ), query_input AS (
        SELECT lower(translate(normalize(CAST(@query AS text), NFC),
          'АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ', 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюя')) AS folded
      ), scored AS (
        SELECT c.*,
          ts_rank_cd(to_tsvector('simple', c.content), plainto_tsquery('simple', @query))
            + CASE WHEN lower(translate(normalize(t.title, NFC), 'АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ', 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюя'))
              = q.folded AND c.ordinal = -1 THEN 2 ELSE 0 END
            + CASE WHEN q.folded ~ '[а-яіїєґ]' AND NOT EXISTS (
              SELECT 1 FROM unnest(regexp_split_to_array(q.folded, '[^а-яіїєґa-z0-9]+')) term
              WHERE term <> '' AND strpos(lower(translate(normalize(c.content, NFC),
                'АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ', 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюя')), term) = 0
            ) THEN 0.1 ELSE 0 END AS lexical,
          1 - (c.embedding <=> CAST(@vector AS vector)) AS similarity
        FROM candidates c JOIN targets t USING (fingerprint) CROSS JOIN query_input q
      ), lexical AS (
        SELECT DISTINCT ON (fingerprint) * FROM scored WHERE lexical > 0
        ORDER BY fingerprint, lexical DESC, ordinal
      ), semantic AS (
        SELECT DISTINCT ON (fingerprint) * FROM scored WHERE similarity >= @minimumSimilarity
        ORDER BY fingerprint, similarity DESC, ordinal
      ), lr AS (
        SELECT *, row_number() OVER (ORDER BY lexical DESC, fingerprint) AS rank
        FROM lexical
      ), sr AS (
        SELECT *, row_number() OVER (ORDER BY similarity DESC, fingerprint) AS rank
        FROM semantic
      )
      SELECT fingerprint, coalesce(lr.content, sr.content),
        CASE WHEN lr.fingerprint IS NOT NULL THEN lr.page ELSE sr.page END,
        CASE WHEN lr.fingerprint IS NOT NULL THEN lr.location ELSE sr.location END
      FROM lr FULL OUTER JOIN sr USING (fingerprint)
      ORDER BY coalesce(1.0 / (60 + lr.rank), 0)
        + coalesce(1.0 / (60 + sr.rank), 0) DESC, fingerprint
      LIMIT 51
    ''',
      parameters: QueryParameters.named({
        'targets': jsonEncode([
          for (final d in docs.values)
            {
              'fingerprint': d.fingerprint,
              'title': d.hit.title,
              'content': d.content,
            },
        ]),
        'query': query,
        'space': searchEmbeddingSpace,
        'minimumSimilarity': _minimumSimilarity,
        'vector': vector == null ? null : '[${vector.join(',')}]',
      }),
    );
    final ready = await SearchIndexJob.db.count(
      session,
      where: (t) =>
          t.fingerprint.inSet(docs.keys.toSet()) & t.state.equals('ready'),
    );
    await AccountAuthorization.requireAccount(session);
    final current = await _eligible(session, user, courseId, kind);
    final results = [
      for (final row in rows)
        if (current[row[0]] case final doc?)
          doc.hit.copyWith(
            excerpt: _excerpt(row[1] as String, query),
            page: row[2] as int?,
            location: row[3] as String?,
          ),
    ];
    session.log(
      'search latency_ms=${timer.elapsedMilliseconds} keyword_only=${vector == null} embedding_tokens=$embeddingTokens incomplete=${ready < docs.length}',
    );
    return SearchResponse(
      results: results.take(50).toList(),
      keywordOnly: vector == null,
      incomplete: ready < docs.length,
      capped: results.length > 50,
    );
  }

  String _excerpt(String content, String query) {
    final flat = content.replaceAll(RegExp(r'\s+'), ' ').trim();
    final words = query
        .toLowerCase()
        .split(' ')
        .where((word) => word.length > 2);
    final lower = flat.toLowerCase();
    var match = -1;
    for (final word in words) {
      match = lower.indexOf(word);
      if (match >= 0) break;
    }
    final start = match > 60 ? match - 60 : 0;
    final prefix = start == 0 ? '' : '…';
    final excerpt = String.fromCharCodes(flat.substring(start).runes.take(240));
    return '$prefix$excerpt${start + excerpt.length < flat.length ? '…' : ''}';
  }

  Future<List<SearchRecent>> history(
    Session session, {
    String? query,
    int? deleteId,
    bool clear = false,
  }) async {
    final user = (await AccountAuthorization.requireAccount(
      session,
    )).authUserId;
    final normalized = query == null ? null : _query(query);
    final now = _clock().toUtc();
    final cutoff = now.subtract(const Duration(days: 90));
    return session.db.transaction((tx) async {
      // Serialize save/clear/prune for one account, including concurrent devices.
      await session.db.unsafeQuery(
        'SELECT pg_advisory_xact_lock(hashtextextended(@key, 0))',
        parameters: QueryParameters.named({
          'key': 'poodle.search.history:$user',
        }),
        transaction: tx,
      );
      await SearchHistoryRecord.db.deleteWhere(
        session,
        where: (t) =>
            t.authUserId.equals(user) &
            (clear
                ? Constant.bool(true)
                : (t.lastUsed <= cutoff) |
                      (deleteId == null
                          ? Constant.bool(false)
                          : t.id.equals(deleteId))),
        transaction: tx,
      );
      if (normalized != null) {
        await session.db.unsafeExecute(
          r'''
          INSERT INTO poodle_search_history ("authUserId", query, normalized, "lastUsed")
          VALUES (CAST(@user AS uuid), @query, lower(translate(normalize(CAST(@normalized AS text), NFC),
            'АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ', 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюя')), @now)
          ON CONFLICT ("authUserId", normalized) DO UPDATE
            SET query = EXCLUDED.query, "lastUsed" = EXCLUDED."lastUsed"
        ''',
          parameters: QueryParameters.named({
            'user': user.toString(),
            'query': normalized,
            'normalized': normalized,
            'now': now,
          }),
          transaction: tx,
        );
      }
      final rows = await SearchHistoryRecord.db.find(
        session,
        where: (t) => t.authUserId.equals(user),
        orderByList: (t) => [t.lastUsed.desc(), t.id.desc()],
        transaction: tx,
      );
      if (rows.length > 20) {
        await SearchHistoryRecord.db.deleteWhere(
          session,
          where: (t) =>
              t.authUserId.equals(user) &
              t.id.inSet(rows.skip(20).map((r) => r.id!).toSet()),
          transaction: tx,
        );
      }
      return [
        for (final row in rows.take(20))
          SearchRecent(id: row.id!, query: row.query, lastUsed: row.lastUsed),
      ];
    });
  }
}
