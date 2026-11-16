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
import 'package:serverpod/serverpod.dart' as _is;

abstract class NotebookTurnRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookTurnRecord._({
    this.id,
    required this.notebookId,
    required this.ownerUserId,
    required this.requestKey,
    required this.turnIndex,
    required this.role,
    required this.content,
    String? citationsJson,
    bool? insufficientEvidence,
    required this.sourceRevision,
    DateTime? createdAt,
  }) : citationsJson = citationsJson ?? '[]',
       insufficientEvidence = insufficientEvidence ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory NotebookTurnRecord({
    _is.UuidValue? id,
    required _is.UuidValue notebookId,
    required _is.UuidValue ownerUserId,
    required String requestKey,
    required int turnIndex,
    required String role,
    required String content,
    String? citationsJson,
    bool? insufficientEvidence,
    required int sourceRevision,
    DateTime? createdAt,
  }) = _NotebookTurnRecordImpl;

  factory NotebookTurnRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookTurnRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      notebookId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['notebookId'],
      ),
      ownerUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerUserId'],
      ),
      requestKey: jsonSerialization['requestKey'] as String,
      turnIndex: jsonSerialization['turnIndex'] as int,
      role: jsonSerialization['role'] as String,
      content: jsonSerialization['content'] as String,
      citationsJson: jsonSerialization['citationsJson'] as String?,
      insufficientEvidence: jsonSerialization['insufficientEvidence'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['insufficientEvidence'],
            ),
      sourceRevision: jsonSerialization['sourceRevision'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = NotebookTurnRecordTable();

  static const db = NotebookTurnRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue notebookId;

  _is.UuidValue ownerUserId;

  String requestKey;

  int turnIndex;

  String role;

  String content;

  String citationsJson;

  bool insufficientEvidence;

  int sourceRevision;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookTurnRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookTurnRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? notebookId,
    _is.UuidValue? ownerUserId,
    String? requestKey,
    int? turnIndex,
    String? role,
    String? content,
    String? citationsJson,
    bool? insufficientEvidence,
    int? sourceRevision,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookTurnRecord',
      if (id != null) 'id': id?.toJson(),
      'notebookId': notebookId.toJson(),
      'ownerUserId': ownerUserId.toJson(),
      'requestKey': requestKey,
      'turnIndex': turnIndex,
      'role': role,
      'content': content,
      'citationsJson': citationsJson,
      'insufficientEvidence': insufficientEvidence,
      'sourceRevision': sourceRevision,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookTurnRecordInclude include() {
    return NotebookTurnRecordInclude._();
  }

  static NotebookTurnRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookTurnRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookTurnRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookTurnRecordTable>? orderByList,
    NotebookTurnRecordInclude? include,
  }) {
    return NotebookTurnRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookTurnRecord.t),
      orderByList: orderByList?.call(NotebookTurnRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookTurnRecordImpl extends NotebookTurnRecord {
  _NotebookTurnRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue notebookId,
    required _is.UuidValue ownerUserId,
    required String requestKey,
    required int turnIndex,
    required String role,
    required String content,
    String? citationsJson,
    bool? insufficientEvidence,
    required int sourceRevision,
    DateTime? createdAt,
  }) : super._(
         id: id,
         notebookId: notebookId,
         ownerUserId: ownerUserId,
         requestKey: requestKey,
         turnIndex: turnIndex,
         role: role,
         content: content,
         citationsJson: citationsJson,
         insufficientEvidence: insufficientEvidence,
         sourceRevision: sourceRevision,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotebookTurnRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookTurnRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? notebookId,
    _is.UuidValue? ownerUserId,
    String? requestKey,
    int? turnIndex,
    String? role,
    String? content,
    String? citationsJson,
    bool? insufficientEvidence,
    int? sourceRevision,
    DateTime? createdAt,
  }) {
    return NotebookTurnRecord(
      id: id is _is.UuidValue? ? id : this.id,
      notebookId: notebookId ?? this.notebookId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      requestKey: requestKey ?? this.requestKey,
      turnIndex: turnIndex ?? this.turnIndex,
      role: role ?? this.role,
      content: content ?? this.content,
      citationsJson: citationsJson ?? this.citationsJson,
      insufficientEvidence: insufficientEvidence ?? this.insufficientEvidence,
      sourceRevision: sourceRevision ?? this.sourceRevision,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotebookTurnRecordUpdateTable
    extends _is.UpdateTable<NotebookTurnRecordTable> {
  NotebookTurnRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> notebookId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.notebookId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.ownerUserId,
    value,
  );

  _is.ColumnValue<String, String> requestKey(String value) => _is.ColumnValue(
    table.requestKey,
    value,
  );

  _is.ColumnValue<int, int> turnIndex(int value) => _is.ColumnValue(
    table.turnIndex,
    value,
  );

  _is.ColumnValue<String, String> role(String value) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<String, String> content(String value) => _is.ColumnValue(
    table.content,
    value,
  );

  _is.ColumnValue<String, String> citationsJson(String value) =>
      _is.ColumnValue(
        table.citationsJson,
        value,
      );

  _is.ColumnValue<bool, bool> insufficientEvidence(bool value) =>
      _is.ColumnValue(
        table.insufficientEvidence,
        value,
      );

  _is.ColumnValue<int, int> sourceRevision(int value) => _is.ColumnValue(
    table.sourceRevision,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class NotebookTurnRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookTurnRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook_turn') {
    updateTable = NotebookTurnRecordUpdateTable(this);
    notebookId = _is.ColumnUuid(
      'notebookId',
      this,
    );
    ownerUserId = _is.ColumnUuid(
      'ownerUserId',
      this,
    );
    requestKey = _is.ColumnString(
      'requestKey',
      this,
    );
    turnIndex = _is.ColumnInt(
      'turnIndex',
      this,
    );
    role = _is.ColumnString(
      'role',
      this,
    );
    content = _is.ColumnString(
      'content',
      this,
    );
    citationsJson = _is.ColumnString(
      'citationsJson',
      this,
      hasDefault: true,
    );
    insufficientEvidence = _is.ColumnBool(
      'insufficientEvidence',
      this,
      hasDefault: true,
    );
    sourceRevision = _is.ColumnInt(
      'sourceRevision',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final NotebookTurnRecordUpdateTable updateTable;

  late final _is.ColumnUuid notebookId;

  late final _is.ColumnUuid ownerUserId;

  late final _is.ColumnString requestKey;

  late final _is.ColumnInt turnIndex;

  late final _is.ColumnString role;

  late final _is.ColumnString content;

  late final _is.ColumnString citationsJson;

  late final _is.ColumnBool insufficientEvidence;

  late final _is.ColumnInt sourceRevision;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    notebookId,
    ownerUserId,
    requestKey,
    turnIndex,
    role,
    content,
    citationsJson,
    insufficientEvidence,
    sourceRevision,
    createdAt,
  ];
}

class NotebookTurnRecordInclude extends _is.IncludeObject {
  NotebookTurnRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookTurnRecord.t;
}

class NotebookTurnRecordIncludeList extends _is.IncludeList {
  NotebookTurnRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookTurnRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookTurnRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookTurnRecord.t;
}

class NotebookTurnRecordRepository {
  const NotebookTurnRecordRepository._();

  /// Returns a list of [NotebookTurnRecord]s matching the given query parameters.
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
  Future<List<NotebookTurnRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookTurnRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookTurnRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookTurnRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookTurnRecord>(
      where: where?.call(NotebookTurnRecord.t),
      orderBy: orderBy?.call(NotebookTurnRecord.t),
      orderByList: orderByList?.call(NotebookTurnRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookTurnRecord] matching the given query parameters.
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
  Future<NotebookTurnRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookTurnRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookTurnRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookTurnRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookTurnRecord>(
      where: where?.call(NotebookTurnRecord.t),
      orderBy: orderBy?.call(NotebookTurnRecord.t),
      orderByList: orderByList?.call(NotebookTurnRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookTurnRecord] by its [id] or null if no such row exists.
  Future<NotebookTurnRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookTurnRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookTurnRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookTurnRecord]s will have their `id` fields set.
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
  Future<List<NotebookTurnRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookTurnRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookTurnRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookTurnRecord] and returns the inserted row.
  ///
  /// The returned [NotebookTurnRecord] will have its `id` field set.
  Future<NotebookTurnRecord> insertRow(
    _is.DatabaseSession session,
    NotebookTurnRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookTurnRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookTurnRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookTurnRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookTurnRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookTurnRecord> rows, {
    required _is.ColumnSelections<NotebookTurnRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookTurnRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookTurnRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookTurnRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookTurnRecord.t),
      updateColumns: updateColumns?.call(NotebookTurnRecord.t),
      updateWhere: updateWhere?.call(NotebookTurnRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookTurnRecord] and returns the resulting row.
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
  /// The returned [NotebookTurnRecord] will have its `id` field set.
  Future<NotebookTurnRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookTurnRecord row, {
    required _is.ColumnSelections<NotebookTurnRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookTurnRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookTurnRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookTurnRecord>(
      row,
      conflictColumns: conflictColumns(NotebookTurnRecord.t),
      updateColumns: updateColumns?.call(NotebookTurnRecord.t),
      updateWhere: updateWhere?.call(NotebookTurnRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookTurnRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookTurnRecord>> update(
    _is.DatabaseSession session,
    List<NotebookTurnRecord> rows, {
    _is.ColumnSelections<NotebookTurnRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookTurnRecord>(
      rows,
      columns: columns?.call(NotebookTurnRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookTurnRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookTurnRecord> updateRow(
    _is.DatabaseSession session,
    NotebookTurnRecord row, {
    _is.ColumnSelections<NotebookTurnRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookTurnRecord>(
      row,
      columns: columns?.call(NotebookTurnRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookTurnRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookTurnRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NotebookTurnRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookTurnRecord>(
      id,
      columnValues: columnValues(NotebookTurnRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookTurnRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookTurnRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotebookTurnRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NotebookTurnRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookTurnRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookTurnRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookTurnRecord>(
      columnValues: columnValues(NotebookTurnRecord.t.updateTable),
      where: where(NotebookTurnRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookTurnRecord.t),
      orderByList: orderByList?.call(NotebookTurnRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookTurnRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookTurnRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookTurnRecord> rows, {
    _is.OrderByBuilder<NotebookTurnRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookTurnRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookTurnRecord>(
      rows,
      orderBy: orderBy?.call(NotebookTurnRecord.t),
      orderByList: orderByList?.call(NotebookTurnRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookTurnRecord].
  Future<NotebookTurnRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookTurnRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookTurnRecord>(
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
  Future<List<NotebookTurnRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookTurnRecordTable> where,
    _is.OrderByBuilder<NotebookTurnRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookTurnRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookTurnRecord>(
      where: where(NotebookTurnRecord.t),
      orderBy: orderBy?.call(NotebookTurnRecord.t),
      orderByList: orderByList?.call(NotebookTurnRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookTurnRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookTurnRecord>(
      where: where?.call(NotebookTurnRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookTurnRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookTurnRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookTurnRecord>(
      where: where(NotebookTurnRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
