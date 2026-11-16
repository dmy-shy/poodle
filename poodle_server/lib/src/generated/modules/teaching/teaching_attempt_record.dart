/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:poodle_server/src/generated/protocol.dart' as _ikm1kaos;
import 'package:serverpod/serverpod.dart' as _is;
import '../../modules/teaching/teaching_question.dart' as _i3iex35i;

abstract class TeachingAttemptRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  TeachingAttemptRecord._({
    this.id,
    required this.activityId,
    required this.ownerId,
    required this.versionId,
    required this.questions,
    required this.answers,
    required this.startedAt,
    required this.expiresAt,
    this.submittedAt,
    this.score,
    required this.maxPoints,
  });

  factory TeachingAttemptRecord({
    _is.UuidValue? id,
    required _is.UuidValue activityId,
    required _is.UuidValue ownerId,
    required _is.UuidValue versionId,
    required List<_i3iex35i.TeachingQuestion> questions,
    required List<int> answers,
    required DateTime startedAt,
    required DateTime expiresAt,
    DateTime? submittedAt,
    double? score,
    required double maxPoints,
  }) = _TeachingAttemptRecordImpl;

  factory TeachingAttemptRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeachingAttemptRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      activityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['activityId'],
      ),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      versionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['versionId'],
      ),
      questions: _ikm1kaos.Protocol()
          .deserialize<List<_i3iex35i.TeachingQuestion>>(
            jsonSerialization['questions'],
          ),
      answers: _ikm1kaos.Protocol().deserialize<List<int>>(
        jsonSerialization['answers'],
      ),
      startedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      submittedAt: jsonSerialization['submittedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['submittedAt'],
            ),
      score: (jsonSerialization['score'] as num?)?.toDouble(),
      maxPoints: (jsonSerialization['maxPoints'] as num).toDouble(),
    );
  }

  static final t = TeachingAttemptRecordTable();

  static const db = TeachingAttemptRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue activityId;

  _is.UuidValue ownerId;

  _is.UuidValue versionId;

  List<_i3iex35i.TeachingQuestion> questions;

  List<int> answers;

  DateTime startedAt;

  DateTime expiresAt;

  DateTime? submittedAt;

  double? score;

  double maxPoints;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [TeachingAttemptRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeachingAttemptRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? activityId,
    _is.UuidValue? ownerId,
    _is.UuidValue? versionId,
    List<_i3iex35i.TeachingQuestion>? questions,
    List<int>? answers,
    DateTime? startedAt,
    DateTime? expiresAt,
    DateTime? submittedAt,
    double? score,
    double? maxPoints,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingAttemptRecord',
      if (id != null) 'id': id?.toJson(),
      'activityId': activityId.toJson(),
      'ownerId': ownerId.toJson(),
      'versionId': versionId.toJson(),
      'questions': questions.toJson(valueToJson: (v) => v.toJson()),
      'answers': answers.toJson(),
      'startedAt': startedAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (submittedAt != null) 'submittedAt': submittedAt?.toJson(),
      if (score != null) 'score': score,
      'maxPoints': maxPoints,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static TeachingAttemptRecordInclude include() {
    return TeachingAttemptRecordInclude._();
  }

  static TeachingAttemptRecordIncludeList includeList({
    _is.WhereExpressionBuilder<TeachingAttemptRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingAttemptRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingAttemptRecordTable>? orderByList,
    TeachingAttemptRecordInclude? include,
  }) {
    return TeachingAttemptRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeachingAttemptRecord.t),
      orderByList: orderByList?.call(TeachingAttemptRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeachingAttemptRecordImpl extends TeachingAttemptRecord {
  _TeachingAttemptRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue activityId,
    required _is.UuidValue ownerId,
    required _is.UuidValue versionId,
    required List<_i3iex35i.TeachingQuestion> questions,
    required List<int> answers,
    required DateTime startedAt,
    required DateTime expiresAt,
    DateTime? submittedAt,
    double? score,
    required double maxPoints,
  }) : super._(
         id: id,
         activityId: activityId,
         ownerId: ownerId,
         versionId: versionId,
         questions: questions,
         answers: answers,
         startedAt: startedAt,
         expiresAt: expiresAt,
         submittedAt: submittedAt,
         score: score,
         maxPoints: maxPoints,
       );

  /// Returns a shallow copy of this [TeachingAttemptRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeachingAttemptRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? activityId,
    _is.UuidValue? ownerId,
    _is.UuidValue? versionId,
    List<_i3iex35i.TeachingQuestion>? questions,
    List<int>? answers,
    DateTime? startedAt,
    DateTime? expiresAt,
    Object? submittedAt = _Undefined,
    Object? score = _Undefined,
    double? maxPoints,
  }) {
    return TeachingAttemptRecord(
      id: id is _is.UuidValue? ? id : this.id,
      activityId: activityId ?? this.activityId,
      ownerId: ownerId ?? this.ownerId,
      versionId: versionId ?? this.versionId,
      questions:
          questions ?? this.questions.map((e0) => e0.copyWith()).toList(),
      answers: answers ?? this.answers.map((e0) => e0).toList(),
      startedAt: startedAt ?? this.startedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      submittedAt: submittedAt is DateTime? ? submittedAt : this.submittedAt,
      score: score is double? ? score : this.score,
      maxPoints: maxPoints ?? this.maxPoints,
    );
  }
}

class TeachingAttemptRecordUpdateTable
    extends _is.UpdateTable<TeachingAttemptRecordTable> {
  TeachingAttemptRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> activityId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.activityId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> versionId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.versionId,
    value,
  );

  _is.ColumnValue<
    List<_i3iex35i.TeachingQuestion>,
    List<_i3iex35i.TeachingQuestion>
  >
  questions(List<_i3iex35i.TeachingQuestion> value) => _is.ColumnValue(
    table.questions,
    value,
  );

  _is.ColumnValue<List<int>, List<int>> answers(List<int> value) =>
      _is.ColumnValue(
        table.answers,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> startedAt(DateTime value) =>
      _is.ColumnValue(
        table.startedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> submittedAt(DateTime? value) =>
      _is.ColumnValue(
        table.submittedAt,
        value,
      );

  _is.ColumnValue<double, double> score(double? value) => _is.ColumnValue(
    table.score,
    value,
  );

  _is.ColumnValue<double, double> maxPoints(double value) => _is.ColumnValue(
    table.maxPoints,
    value,
  );
}

class TeachingAttemptRecordTable extends _is.Table<_is.UuidValue?> {
  TeachingAttemptRecordTable({super.tableRelation})
    : super(tableName: 'poodle_teaching_attempt') {
    updateTable = TeachingAttemptRecordUpdateTable(this);
    activityId = _is.ColumnUuid(
      'activityId',
      this,
    );
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    versionId = _is.ColumnUuid(
      'versionId',
      this,
    );
    questions = _is.ColumnSerializable<List<_i3iex35i.TeachingQuestion>>(
      'questions',
      this,
    );
    answers = _is.ColumnSerializable<List<int>>(
      'answers',
      this,
    );
    startedAt = _is.ColumnDateTime(
      'startedAt',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    submittedAt = _is.ColumnDateTime(
      'submittedAt',
      this,
    );
    score = _is.ColumnDouble(
      'score',
      this,
    );
    maxPoints = _is.ColumnDouble(
      'maxPoints',
      this,
    );
  }

  late final TeachingAttemptRecordUpdateTable updateTable;

  late final _is.ColumnUuid activityId;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnUuid versionId;

  late final _is.ColumnSerializable<List<_i3iex35i.TeachingQuestion>> questions;

  late final _is.ColumnSerializable<List<int>> answers;

  late final _is.ColumnDateTime startedAt;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime submittedAt;

  late final _is.ColumnDouble score;

  late final _is.ColumnDouble maxPoints;

  @override
  List<_is.Column> get columns => [
    id,
    activityId,
    ownerId,
    versionId,
    questions,
    answers,
    startedAt,
    expiresAt,
    submittedAt,
    score,
    maxPoints,
  ];
}

class TeachingAttemptRecordInclude extends _is.IncludeObject {
  TeachingAttemptRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => TeachingAttemptRecord.t;
}

class TeachingAttemptRecordIncludeList extends _is.IncludeList {
  TeachingAttemptRecordIncludeList._({
    _is.WhereExpressionBuilder<TeachingAttemptRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TeachingAttemptRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => TeachingAttemptRecord.t;
}

class TeachingAttemptRecordRepository {
  const TeachingAttemptRecordRepository._();

  /// Returns a list of [TeachingAttemptRecord]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<TeachingAttemptRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingAttemptRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingAttemptRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingAttemptRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TeachingAttemptRecord>(
      where: where?.call(TeachingAttemptRecord.t),
      orderBy: orderBy?.call(TeachingAttemptRecord.t),
      orderByList: orderByList?.call(TeachingAttemptRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TeachingAttemptRecord] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<TeachingAttemptRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingAttemptRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<TeachingAttemptRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingAttemptRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TeachingAttemptRecord>(
      where: where?.call(TeachingAttemptRecord.t),
      orderBy: orderBy?.call(TeachingAttemptRecord.t),
      orderByList: orderByList?.call(TeachingAttemptRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TeachingAttemptRecord] by its [id] or null if no such row exists.
  Future<TeachingAttemptRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TeachingAttemptRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TeachingAttemptRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [TeachingAttemptRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingAttemptRecord>> insert(
    _is.DatabaseSession session,
    List<TeachingAttemptRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TeachingAttemptRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TeachingAttemptRecord] and returns the inserted row.
  ///
  /// The returned [TeachingAttemptRecord] will have its `id` field set.
  Future<TeachingAttemptRecord> insertRow(
    _is.DatabaseSession session,
    TeachingAttemptRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TeachingAttemptRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TeachingAttemptRecord]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [TeachingAttemptRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingAttemptRecord>> upsert(
    _is.DatabaseSession session,
    List<TeachingAttemptRecord> rows, {
    required _is.ColumnSelections<TeachingAttemptRecordTable> conflictColumns,
    _is.ColumnSelections<TeachingAttemptRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeachingAttemptRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TeachingAttemptRecord>(
      rows,
      conflictColumns: conflictColumns(TeachingAttemptRecord.t),
      updateColumns: updateColumns?.call(TeachingAttemptRecord.t),
      updateWhere: updateWhere?.call(TeachingAttemptRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TeachingAttemptRecord] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [TeachingAttemptRecord] will have its `id` field set.
  Future<TeachingAttemptRecord?> upsertRow(
    _is.DatabaseSession session,
    TeachingAttemptRecord row, {
    required _is.ColumnSelections<TeachingAttemptRecordTable> conflictColumns,
    _is.ColumnSelections<TeachingAttemptRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeachingAttemptRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TeachingAttemptRecord>(
      row,
      conflictColumns: conflictColumns(TeachingAttemptRecord.t),
      updateColumns: updateColumns?.call(TeachingAttemptRecord.t),
      updateWhere: updateWhere?.call(TeachingAttemptRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [TeachingAttemptRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingAttemptRecord>> update(
    _is.DatabaseSession session,
    List<TeachingAttemptRecord> rows, {
    _is.ColumnSelections<TeachingAttemptRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TeachingAttemptRecord>(
      rows,
      columns: columns?.call(TeachingAttemptRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TeachingAttemptRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TeachingAttemptRecord> updateRow(
    _is.DatabaseSession session,
    TeachingAttemptRecord row, {
    _is.ColumnSelections<TeachingAttemptRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TeachingAttemptRecord>(
      row,
      columns: columns?.call(TeachingAttemptRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TeachingAttemptRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TeachingAttemptRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TeachingAttemptRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TeachingAttemptRecord>(
      id,
      columnValues: columnValues(TeachingAttemptRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TeachingAttemptRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingAttemptRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TeachingAttemptRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TeachingAttemptRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingAttemptRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingAttemptRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TeachingAttemptRecord>(
      columnValues: columnValues(TeachingAttemptRecord.t.updateTable),
      where: where(TeachingAttemptRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeachingAttemptRecord.t),
      orderByList: orderByList?.call(TeachingAttemptRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TeachingAttemptRecord]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingAttemptRecord>> delete(
    _is.DatabaseSession session,
    List<TeachingAttemptRecord> rows, {
    _is.OrderByBuilder<TeachingAttemptRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingAttemptRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TeachingAttemptRecord>(
      rows,
      orderBy: orderBy?.call(TeachingAttemptRecord.t),
      orderByList: orderByList?.call(TeachingAttemptRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TeachingAttemptRecord].
  Future<TeachingAttemptRecord> deleteRow(
    _is.DatabaseSession session,
    TeachingAttemptRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TeachingAttemptRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingAttemptRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeachingAttemptRecordTable> where,
    _is.OrderByBuilder<TeachingAttemptRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingAttemptRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TeachingAttemptRecord>(
      where: where(TeachingAttemptRecord.t),
      orderBy: orderBy?.call(TeachingAttemptRecord.t),
      orderByList: orderByList?.call(TeachingAttemptRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingAttemptRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TeachingAttemptRecord>(
      where: where?.call(TeachingAttemptRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TeachingAttemptRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeachingAttemptRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TeachingAttemptRecord>(
      where: where(TeachingAttemptRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
