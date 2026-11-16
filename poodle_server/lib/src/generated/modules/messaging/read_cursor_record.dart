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

abstract class ReadCursorRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ReadCursorRecord._({
    this.id,
    required this.conversationId,
    required this.participantId,
    int? readThroughId,
    DateTime? updatedAt,
  }) : readThroughId = readThroughId ?? 0,
       updatedAt = updatedAt ?? DateTime.now();

  factory ReadCursorRecord({
    _is.UuidValue? id,
    required _is.UuidValue conversationId,
    required _is.UuidValue participantId,
    int? readThroughId,
    DateTime? updatedAt,
  }) = _ReadCursorRecordImpl;

  factory ReadCursorRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReadCursorRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      conversationId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['conversationId'],
      ),
      participantId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['participantId'],
      ),
      readThroughId: jsonSerialization['readThroughId'] as int?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ReadCursorRecordTable();

  static const db = ReadCursorRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue conversationId;

  _is.UuidValue participantId;

  int readThroughId;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ReadCursorRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReadCursorRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? conversationId,
    _is.UuidValue? participantId,
    int? readThroughId,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReadCursorRecord',
      if (id != null) 'id': id?.toJson(),
      'conversationId': conversationId.toJson(),
      'participantId': participantId.toJson(),
      'readThroughId': readThroughId,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ReadCursorRecordInclude include() {
    return ReadCursorRecordInclude._();
  }

  static ReadCursorRecordIncludeList includeList({
    _is.WhereExpressionBuilder<ReadCursorRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReadCursorRecordTable>? orderBy,
    _is.OrderByListBuilder<ReadCursorRecordTable>? orderByList,
    ReadCursorRecordInclude? include,
  }) {
    return ReadCursorRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReadCursorRecord.t),
      orderByList: orderByList?.call(ReadCursorRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReadCursorRecordImpl extends ReadCursorRecord {
  _ReadCursorRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue conversationId,
    required _is.UuidValue participantId,
    int? readThroughId,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         conversationId: conversationId,
         participantId: participantId,
         readThroughId: readThroughId,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ReadCursorRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReadCursorRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? conversationId,
    _is.UuidValue? participantId,
    int? readThroughId,
    DateTime? updatedAt,
  }) {
    return ReadCursorRecord(
      id: id is _is.UuidValue? ? id : this.id,
      conversationId: conversationId ?? this.conversationId,
      participantId: participantId ?? this.participantId,
      readThroughId: readThroughId ?? this.readThroughId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ReadCursorRecordUpdateTable
    extends _is.UpdateTable<ReadCursorRecordTable> {
  ReadCursorRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> conversationId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.conversationId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> participantId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.participantId,
    value,
  );

  _is.ColumnValue<int, int> readThroughId(int value) => _is.ColumnValue(
    table.readThroughId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ReadCursorRecordTable extends _is.Table<_is.UuidValue?> {
  ReadCursorRecordTable({super.tableRelation})
    : super(tableName: 'poodle_message_read_cursor') {
    updateTable = ReadCursorRecordUpdateTable(this);
    conversationId = _is.ColumnUuid(
      'conversationId',
      this,
    );
    participantId = _is.ColumnUuid(
      'participantId',
      this,
    );
    readThroughId = _is.ColumnInt(
      'readThroughId',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final ReadCursorRecordUpdateTable updateTable;

  late final _is.ColumnUuid conversationId;

  late final _is.ColumnUuid participantId;

  late final _is.ColumnInt readThroughId;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    conversationId,
    participantId,
    readThroughId,
    updatedAt,
  ];
}

class ReadCursorRecordInclude extends _is.IncludeObject {
  ReadCursorRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ReadCursorRecord.t;
}

class ReadCursorRecordIncludeList extends _is.IncludeList {
  ReadCursorRecordIncludeList._({
    _is.WhereExpressionBuilder<ReadCursorRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReadCursorRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ReadCursorRecord.t;
}

class ReadCursorRecordRepository {
  const ReadCursorRecordRepository._();

  /// Returns a list of [ReadCursorRecord]s matching the given query parameters.
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
  Future<List<ReadCursorRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReadCursorRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReadCursorRecordTable>? orderBy,
    _is.OrderByListBuilder<ReadCursorRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReadCursorRecord>(
      where: where?.call(ReadCursorRecord.t),
      orderBy: orderBy?.call(ReadCursorRecord.t),
      orderByList: orderByList?.call(ReadCursorRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReadCursorRecord] matching the given query parameters.
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
  Future<ReadCursorRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReadCursorRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<ReadCursorRecordTable>? orderBy,
    _is.OrderByListBuilder<ReadCursorRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReadCursorRecord>(
      where: where?.call(ReadCursorRecord.t),
      orderBy: orderBy?.call(ReadCursorRecord.t),
      orderByList: orderByList?.call(ReadCursorRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReadCursorRecord] by its [id] or null if no such row exists.
  Future<ReadCursorRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReadCursorRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReadCursorRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [ReadCursorRecord]s will have their `id` fields set.
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
  Future<List<ReadCursorRecord>> insert(
    _is.DatabaseSession session,
    List<ReadCursorRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ReadCursorRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ReadCursorRecord] and returns the inserted row.
  ///
  /// The returned [ReadCursorRecord] will have its `id` field set.
  Future<ReadCursorRecord> insertRow(
    _is.DatabaseSession session,
    ReadCursorRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReadCursorRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReadCursorRecord]s in the list and returns the resulting rows.
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
  /// The returned [ReadCursorRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReadCursorRecord>> upsert(
    _is.DatabaseSession session,
    List<ReadCursorRecord> rows, {
    required _is.ColumnSelections<ReadCursorRecordTable> conflictColumns,
    _is.ColumnSelections<ReadCursorRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<ReadCursorRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ReadCursorRecord>(
      rows,
      conflictColumns: conflictColumns(ReadCursorRecord.t),
      updateColumns: updateColumns?.call(ReadCursorRecord.t),
      updateWhere: updateWhere?.call(ReadCursorRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ReadCursorRecord] and returns the resulting row.
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
  /// The returned [ReadCursorRecord] will have its `id` field set.
  Future<ReadCursorRecord?> upsertRow(
    _is.DatabaseSession session,
    ReadCursorRecord row, {
    required _is.ColumnSelections<ReadCursorRecordTable> conflictColumns,
    _is.ColumnSelections<ReadCursorRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<ReadCursorRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReadCursorRecord>(
      row,
      conflictColumns: conflictColumns(ReadCursorRecord.t),
      updateColumns: updateColumns?.call(ReadCursorRecord.t),
      updateWhere: updateWhere?.call(ReadCursorRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReadCursorRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReadCursorRecord>> update(
    _is.DatabaseSession session,
    List<ReadCursorRecord> rows, {
    _is.ColumnSelections<ReadCursorRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ReadCursorRecord>(
      rows,
      columns: columns?.call(ReadCursorRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ReadCursorRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReadCursorRecord> updateRow(
    _is.DatabaseSession session,
    ReadCursorRecord row, {
    _is.ColumnSelections<ReadCursorRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReadCursorRecord>(
      row,
      columns: columns?.call(ReadCursorRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReadCursorRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReadCursorRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ReadCursorRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ReadCursorRecord>(
      id,
      columnValues: columnValues(ReadCursorRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReadCursorRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReadCursorRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReadCursorRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ReadCursorRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReadCursorRecordTable>? orderBy,
    _is.OrderByListBuilder<ReadCursorRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ReadCursorRecord>(
      columnValues: columnValues(ReadCursorRecord.t.updateTable),
      where: where(ReadCursorRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReadCursorRecord.t),
      orderByList: orderByList?.call(ReadCursorRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ReadCursorRecord]s in the list and returns the deleted rows.
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
  Future<List<ReadCursorRecord>> delete(
    _is.DatabaseSession session,
    List<ReadCursorRecord> rows, {
    _is.OrderByBuilder<ReadCursorRecordTable>? orderBy,
    _is.OrderByListBuilder<ReadCursorRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ReadCursorRecord>(
      rows,
      orderBy: orderBy?.call(ReadCursorRecord.t),
      orderByList: orderByList?.call(ReadCursorRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ReadCursorRecord].
  Future<ReadCursorRecord> deleteRow(
    _is.DatabaseSession session,
    ReadCursorRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReadCursorRecord>(
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
  Future<List<ReadCursorRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReadCursorRecordTable> where,
    _is.OrderByBuilder<ReadCursorRecordTable>? orderBy,
    _is.OrderByListBuilder<ReadCursorRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ReadCursorRecord>(
      where: where(ReadCursorRecord.t),
      orderBy: orderBy?.call(ReadCursorRecord.t),
      orderByList: orderByList?.call(ReadCursorRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReadCursorRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ReadCursorRecord>(
      where: where?.call(ReadCursorRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReadCursorRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReadCursorRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReadCursorRecord>(
      where: where(ReadCursorRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
