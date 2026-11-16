part of 'ingestion_worker.dart';

extension _NotebookBudget on NotebookIngestionWorker {
  int _cost(int tokens) =>
      (tokens * embeddingMicrosPerMillionTokens + 999999) ~/ 1000000;

  Future<void> _reserveBudget(
    Session session,
    NotebookJobRecord job,
    int tokens,
  ) => _reserveMicros(session, job, _cost(tokens));

  Future<void> _reserveMicros(
    Session session,
    NotebookJobRecord job,
    int amount,
  ) async {
    await session.db.transaction((tx) async {
      await _lock(session, tx);
      final current = await _fenced(session, job, tx);
      if (current == null) throw const NotebookIngestionException('lease_lost');
      await _validateWork(session, current, tx);
      final now = await _now(session, tx);
      final month = DateTime.utc(now.year, now.month);
      var usage = await NotebookUsageMonthRecord.db.findFirstRow(
        session,
        where: (t) => t.monthUtc.equals(month),
        transaction: tx,
      );
      usage ??= await NotebookUsageMonthRecord.db.insertRow(
        session,
        NotebookUsageMonthRecord(monthUtc: month),
        transaction: tx,
      );
      if (!NotebookPolicy.canReserveMicros(
        spentMicros: usage.spentMicros,
        reservedMicros: usage.reservedMicros,
        requestMicros: amount,
        configuredCapMicros: usage.capMicros,
      )) {
        throw const NotebookIngestionException('monthly_budget_exceeded');
      }
      await NotebookUsageMonthRecord.db.updateRow(
        session,
        usage.copyWith(
          reservedMicros: usage.reservedMicros + amount,
          updatedAt: now,
        ),
        transaction: tx,
      );
      final payload = _payload(current)
        ..['budget'] = {'month': month.toIso8601String(), 'micros': amount};
      await NotebookJobRecord.db.updateRow(
        session,
        current.copyWith(privatePayload: jsonEncode(payload)),
        transaction: tx,
      );
    });
  }

  Future<void> _settleBudget(
    Session session,
    NotebookJobRecord job,
    Transaction tx, {
    int? actualTokens,
    int? actualMicros,
  }) async {
    final Map<String, dynamic> payload;
    try {
      payload = _payload(job);
    } on NotebookIngestionException {
      return;
    }
    final budget = payload['budget'];
    if (budget is! Map) return;
    final month = DateTime.parse(budget['month'] as String);
    final amount = budget['micros'] as int;
    final usage = await NotebookUsageMonthRecord.db.findFirstRow(
      session,
      where: (t) => t.monthUtc.equals(month),
      transaction: tx,
    );
    if (usage == null || usage.reservedMicros < amount) {
      throw StateError('Notebook budget reservation is inconsistent.');
    }
    await NotebookUsageMonthRecord.db.updateRow(
      session,
      usage.copyWith(
        reservedMicros: usage.reservedMicros - amount,
        spentMicros:
            usage.spentMicros +
            (actualMicros ??
                (actualTokens == null ? amount : _cost(actualTokens))),
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: tx,
    );
  }
}
