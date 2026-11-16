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

abstract class NotebookNoteRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookNoteRecord._({
    this.id,
    required this.notebookId,
    required this.ownerUserId,
    required this.turnId,
    required this.content,
    required this.sourceRevision,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory NotebookNoteRecord({
    _is.UuidValue? id,
    required _is.UuidValue notebookId,
    required _is.UuidValue ownerUserId,
    required _is.UuidValue turnId,
    required String content,
    required int sourceRevision,
    DateTime? createdAt,
  }) = _NotebookNoteRecordImpl;

  factory NotebookNoteRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookNoteRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      notebookId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['notebookId'],
      ),
      ownerUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerUserId'],
      ),
      turnId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['turnId']),
      content: jsonSerialization['content'] as String,
      sourceRevision: jsonSerialization['sourceRevision'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = NotebookNoteRecordTable();

  static const db = NotebookNoteRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue notebookId;

  _is.UuidValue ownerUserId;

  _is.UuidValue turnId;

  String content;

  int sourceRevision;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookNoteRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookNoteRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? notebookId,
    _is.UuidValue? ownerUserId,
    _is.UuidValue? turnId,
    String? content,
    int? sourceRevision,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookNoteRecord',
      if (id != null) 'id': id?.toJson(),
      'notebookId': notebookId.toJson(),
      'ownerUserId': ownerUserId.toJson(),
      'turnId': turnId.toJson(),
      'content': content,
      'sourceRevision': sourceRevision,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookNoteRecordInclude include() {
    return NotebookNoteRecordInclude._();
  }

  static NotebookNoteRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookNoteRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookNoteRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookNoteRecordTable>? orderByList,
    NotebookNoteRecordInclude? include,
  }) {
    return NotebookNoteRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookNoteRecord.t),
      orderByList: orderByList?.call(NotebookNoteRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookNoteRecordImpl extends NotebookNoteRecord {
  _NotebookNoteRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue notebookId,
    required _is.UuidValue ownerUserId,
    required _is.UuidValue turnId,
    required String content,
    required int sourceRevision,
    DateTime? createdAt,
  }) : super._(
         id: id,
         notebookId: notebookId,
         ownerUserId: ownerUserId,
         turnId: turnId,
         content: content,
         sourceRevision: sourceRevision,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotebookNoteRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookNoteRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? notebookId,
    _is.UuidValue? ownerUserId,
    _is.UuidValue? turnId,
    String? content,
    int? sourceRevision,
    DateTime? createdAt,
  }) {
    return NotebookNoteRecord(
      id: id is _is.UuidValue? ? id : this.id,
      notebookId: notebookId ?? this.notebookId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      turnId: turnId ?? this.turnId,
      content: content ?? this.content,
      sourceRevision: sourceRevision ?? this.sourceRevision,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotebookNoteRecordUpdateTable
    extends _is.UpdateTable<NotebookNoteRecordTable> {
  NotebookNoteRecordUpdateTable(super.table);

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

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> turnId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.turnId,
        value,
      );

  _is.ColumnValue<String, String> content(String value) => _is.ColumnValue(
    table.content,
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

class NotebookNoteRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookNoteRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook_note') {
    updateTable = NotebookNoteRecordUpdateTable(this);
    notebookId = _is.ColumnUuid(
      'notebookId',
      this,
    );
    ownerUserId = _is.ColumnUuid(
      'ownerUserId',
      this,
    );
    turnId = _is.ColumnUuid(
      'turnId',
      this,
    );
    content = _is.ColumnString(
      'content',
      this,
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

  late final NotebookNoteRecordUpdateTable updateTable;

  late final _is.ColumnUuid notebookId;

  late final _is.ColumnUuid ownerUserId;

  late final _is.ColumnUuid turnId;

  late final _is.ColumnString content;

  late final _is.ColumnInt sourceRevision;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    notebookId,
    ownerUserId,
    turnId,
    content,
    sourceRevision,
    createdAt,
  ];
}

class NotebookNoteRecordInclude extends _is.IncludeObject {
  NotebookNoteRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookNoteRecord.t;
}

class NotebookNoteRecordIncludeList extends _is.IncludeList {
  NotebookNoteRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookNoteRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookNoteRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookNoteRecord.t;
}

class NotebookNoteRecordRepository {
  const NotebookNoteRecordRepository._();

  /// Returns a list of [NotebookNoteRecord]s matching the given query parameters.
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
  Future<List<NotebookNoteRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookNoteRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookNoteRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookNoteRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookNoteRecord>(
      where: where?.call(NotebookNoteRecord.t),
      orderBy: orderBy?.call(NotebookNoteRecord.t),
      orderByList: orderByList?.call(NotebookNoteRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookNoteRecord] matching the given query parameters.
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
  Future<NotebookNoteRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookNoteRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookNoteRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookNoteRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookNoteRecord>(
      where: where?.call(NotebookNoteRecord.t),
      orderBy: orderBy?.call(NotebookNoteRecord.t),
      orderByList: orderByList?.call(NotebookNoteRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookNoteRecord] by its [id] or null if no such row exists.
  Future<NotebookNoteRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookNoteRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookNoteRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookNoteRecord]s will have their `id` fields set.
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
  Future<List<NotebookNoteRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookNoteRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookNoteRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookNoteRecord] and returns the inserted row.
  ///
  /// The returned [NotebookNoteRecord] will have its `id` field set.
  Future<NotebookNoteRecord> insertRow(
    _is.DatabaseSession session,
    NotebookNoteRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookNoteRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookNoteRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookNoteRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookNoteRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookNoteRecord> rows, {
    required _is.ColumnSelections<NotebookNoteRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookNoteRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookNoteRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookNoteRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookNoteRecord.t),
      updateColumns: updateColumns?.call(NotebookNoteRecord.t),
      updateWhere: updateWhere?.call(NotebookNoteRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookNoteRecord] and returns the resulting row.
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
  /// The returned [NotebookNoteRecord] will have its `id` field set.
  Future<NotebookNoteRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookNoteRecord row, {
    required _is.ColumnSelections<NotebookNoteRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookNoteRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookNoteRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookNoteRecord>(
      row,
      conflictColumns: conflictColumns(NotebookNoteRecord.t),
      updateColumns: updateColumns?.call(NotebookNoteRecord.t),
      updateWhere: updateWhere?.call(NotebookNoteRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookNoteRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookNoteRecord>> update(
    _is.DatabaseSession session,
    List<NotebookNoteRecord> rows, {
    _is.ColumnSelections<NotebookNoteRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookNoteRecord>(
      rows,
      columns: columns?.call(NotebookNoteRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookNoteRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookNoteRecord> updateRow(
    _is.DatabaseSession session,
    NotebookNoteRecord row, {
    _is.ColumnSelections<NotebookNoteRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookNoteRecord>(
      row,
      columns: columns?.call(NotebookNoteRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookNoteRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookNoteRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NotebookNoteRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookNoteRecord>(
      id,
      columnValues: columnValues(NotebookNoteRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookNoteRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookNoteRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotebookNoteRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NotebookNoteRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookNoteRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookNoteRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookNoteRecord>(
      columnValues: columnValues(NotebookNoteRecord.t.updateTable),
      where: where(NotebookNoteRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookNoteRecord.t),
      orderByList: orderByList?.call(NotebookNoteRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookNoteRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookNoteRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookNoteRecord> rows, {
    _is.OrderByBuilder<NotebookNoteRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookNoteRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookNoteRecord>(
      rows,
      orderBy: orderBy?.call(NotebookNoteRecord.t),
      orderByList: orderByList?.call(NotebookNoteRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookNoteRecord].
  Future<NotebookNoteRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookNoteRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookNoteRecord>(
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
  Future<List<NotebookNoteRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookNoteRecordTable> where,
    _is.OrderByBuilder<NotebookNoteRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookNoteRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookNoteRecord>(
      where: where(NotebookNoteRecord.t),
      orderBy: orderBy?.call(NotebookNoteRecord.t),
      orderByList: orderByList?.call(NotebookNoteRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookNoteRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookNoteRecord>(
      where: where?.call(NotebookNoteRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookNoteRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookNoteRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookNoteRecord>(
      where: where(NotebookNoteRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
