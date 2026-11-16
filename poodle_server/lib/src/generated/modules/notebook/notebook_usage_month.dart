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

abstract class NotebookUsageMonthRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookUsageMonthRecord._({
    this.id,
    required this.monthUtc,
    int? spentMicros,
    int? reservedMicros,
    int? capMicros,
    DateTime? updatedAt,
  }) : spentMicros = spentMicros ?? 0,
       reservedMicros = reservedMicros ?? 0,
       capMicros = capMicros ?? 10000000,
       updatedAt = updatedAt ?? DateTime.now();

  factory NotebookUsageMonthRecord({
    _is.UuidValue? id,
    required DateTime monthUtc,
    int? spentMicros,
    int? reservedMicros,
    int? capMicros,
    DateTime? updatedAt,
  }) = _NotebookUsageMonthRecordImpl;

  factory NotebookUsageMonthRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookUsageMonthRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      monthUtc: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['monthUtc'],
      ),
      spentMicros: jsonSerialization['spentMicros'] as int?,
      reservedMicros: jsonSerialization['reservedMicros'] as int?,
      capMicros: jsonSerialization['capMicros'] as int?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = NotebookUsageMonthRecordTable();

  static const db = NotebookUsageMonthRecordRepository._();

  @override
  _is.UuidValue? id;

  DateTime monthUtc;

  int spentMicros;

  int reservedMicros;

  int capMicros;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookUsageMonthRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookUsageMonthRecord copyWith({
    _is.UuidValue? id,
    DateTime? monthUtc,
    int? spentMicros,
    int? reservedMicros,
    int? capMicros,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookUsageMonthRecord',
      if (id != null) 'id': id?.toJson(),
      'monthUtc': monthUtc.toJson(),
      'spentMicros': spentMicros,
      'reservedMicros': reservedMicros,
      'capMicros': capMicros,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookUsageMonthRecordInclude include() {
    return NotebookUsageMonthRecordInclude._();
  }

  static NotebookUsageMonthRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookUsageMonthRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookUsageMonthRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookUsageMonthRecordTable>? orderByList,
    NotebookUsageMonthRecordInclude? include,
  }) {
    return NotebookUsageMonthRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookUsageMonthRecord.t),
      orderByList: orderByList?.call(NotebookUsageMonthRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookUsageMonthRecordImpl extends NotebookUsageMonthRecord {
  _NotebookUsageMonthRecordImpl({
    _is.UuidValue? id,
    required DateTime monthUtc,
    int? spentMicros,
    int? reservedMicros,
    int? capMicros,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         monthUtc: monthUtc,
         spentMicros: spentMicros,
         reservedMicros: reservedMicros,
         capMicros: capMicros,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotebookUsageMonthRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookUsageMonthRecord copyWith({
    Object? id = _Undefined,
    DateTime? monthUtc,
    int? spentMicros,
    int? reservedMicros,
    int? capMicros,
    DateTime? updatedAt,
  }) {
    return NotebookUsageMonthRecord(
      id: id is _is.UuidValue? ? id : this.id,
      monthUtc: monthUtc ?? this.monthUtc,
      spentMicros: spentMicros ?? this.spentMicros,
      reservedMicros: reservedMicros ?? this.reservedMicros,
      capMicros: capMicros ?? this.capMicros,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotebookUsageMonthRecordUpdateTable
    extends _is.UpdateTable<NotebookUsageMonthRecordTable> {
  NotebookUsageMonthRecordUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> monthUtc(DateTime value) =>
      _is.ColumnValue(
        table.monthUtc,
        value,
      );

  _is.ColumnValue<int, int> spentMicros(int value) => _is.ColumnValue(
    table.spentMicros,
    value,
  );

  _is.ColumnValue<int, int> reservedMicros(int value) => _is.ColumnValue(
    table.reservedMicros,
    value,
  );

  _is.ColumnValue<int, int> capMicros(int value) => _is.ColumnValue(
    table.capMicros,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class NotebookUsageMonthRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookUsageMonthRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook_usage_month') {
    updateTable = NotebookUsageMonthRecordUpdateTable(this);
    monthUtc = _is.ColumnDateTime(
      'monthUtc',
      this,
    );
    spentMicros = _is.ColumnInt(
      'spentMicros',
      this,
      hasDefault: true,
    );
    reservedMicros = _is.ColumnInt(
      'reservedMicros',
      this,
      hasDefault: true,
    );
    capMicros = _is.ColumnInt(
      'capMicros',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final NotebookUsageMonthRecordUpdateTable updateTable;

  late final _is.ColumnDateTime monthUtc;

  late final _is.ColumnInt spentMicros;

  late final _is.ColumnInt reservedMicros;

  late final _is.ColumnInt capMicros;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    monthUtc,
    spentMicros,
    reservedMicros,
    capMicros,
    updatedAt,
  ];
}

class NotebookUsageMonthRecordInclude extends _is.IncludeObject {
  NotebookUsageMonthRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookUsageMonthRecord.t;
}

class NotebookUsageMonthRecordIncludeList extends _is.IncludeList {
  NotebookUsageMonthRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookUsageMonthRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookUsageMonthRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookUsageMonthRecord.t;
}

class NotebookUsageMonthRecordRepository {
  const NotebookUsageMonthRecordRepository._();

  /// Returns a list of [NotebookUsageMonthRecord]s matching the given query parameters.
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
  Future<List<NotebookUsageMonthRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookUsageMonthRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookUsageMonthRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookUsageMonthRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookUsageMonthRecord>(
      where: where?.call(NotebookUsageMonthRecord.t),
      orderBy: orderBy?.call(NotebookUsageMonthRecord.t),
      orderByList: orderByList?.call(NotebookUsageMonthRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookUsageMonthRecord] matching the given query parameters.
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
  Future<NotebookUsageMonthRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookUsageMonthRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookUsageMonthRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookUsageMonthRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookUsageMonthRecord>(
      where: where?.call(NotebookUsageMonthRecord.t),
      orderBy: orderBy?.call(NotebookUsageMonthRecord.t),
      orderByList: orderByList?.call(NotebookUsageMonthRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookUsageMonthRecord] by its [id] or null if no such row exists.
  Future<NotebookUsageMonthRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookUsageMonthRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookUsageMonthRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookUsageMonthRecord]s will have their `id` fields set.
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
  Future<List<NotebookUsageMonthRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookUsageMonthRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookUsageMonthRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookUsageMonthRecord] and returns the inserted row.
  ///
  /// The returned [NotebookUsageMonthRecord] will have its `id` field set.
  Future<NotebookUsageMonthRecord> insertRow(
    _is.DatabaseSession session,
    NotebookUsageMonthRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookUsageMonthRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookUsageMonthRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookUsageMonthRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookUsageMonthRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookUsageMonthRecord> rows, {
    required _is.ColumnSelections<NotebookUsageMonthRecordTable>
    conflictColumns,
    _is.ColumnSelections<NotebookUsageMonthRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookUsageMonthRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookUsageMonthRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookUsageMonthRecord.t),
      updateColumns: updateColumns?.call(NotebookUsageMonthRecord.t),
      updateWhere: updateWhere?.call(NotebookUsageMonthRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookUsageMonthRecord] and returns the resulting row.
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
  /// The returned [NotebookUsageMonthRecord] will have its `id` field set.
  Future<NotebookUsageMonthRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookUsageMonthRecord row, {
    required _is.ColumnSelections<NotebookUsageMonthRecordTable>
    conflictColumns,
    _is.ColumnSelections<NotebookUsageMonthRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookUsageMonthRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookUsageMonthRecord>(
      row,
      conflictColumns: conflictColumns(NotebookUsageMonthRecord.t),
      updateColumns: updateColumns?.call(NotebookUsageMonthRecord.t),
      updateWhere: updateWhere?.call(NotebookUsageMonthRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookUsageMonthRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookUsageMonthRecord>> update(
    _is.DatabaseSession session,
    List<NotebookUsageMonthRecord> rows, {
    _is.ColumnSelections<NotebookUsageMonthRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookUsageMonthRecord>(
      rows,
      columns: columns?.call(NotebookUsageMonthRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookUsageMonthRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookUsageMonthRecord> updateRow(
    _is.DatabaseSession session,
    NotebookUsageMonthRecord row, {
    _is.ColumnSelections<NotebookUsageMonthRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookUsageMonthRecord>(
      row,
      columns: columns?.call(NotebookUsageMonthRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookUsageMonthRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookUsageMonthRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NotebookUsageMonthRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookUsageMonthRecord>(
      id,
      columnValues: columnValues(NotebookUsageMonthRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookUsageMonthRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookUsageMonthRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotebookUsageMonthRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NotebookUsageMonthRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookUsageMonthRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookUsageMonthRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookUsageMonthRecord>(
      columnValues: columnValues(NotebookUsageMonthRecord.t.updateTable),
      where: where(NotebookUsageMonthRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookUsageMonthRecord.t),
      orderByList: orderByList?.call(NotebookUsageMonthRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookUsageMonthRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookUsageMonthRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookUsageMonthRecord> rows, {
    _is.OrderByBuilder<NotebookUsageMonthRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookUsageMonthRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookUsageMonthRecord>(
      rows,
      orderBy: orderBy?.call(NotebookUsageMonthRecord.t),
      orderByList: orderByList?.call(NotebookUsageMonthRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookUsageMonthRecord].
  Future<NotebookUsageMonthRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookUsageMonthRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookUsageMonthRecord>(
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
  Future<List<NotebookUsageMonthRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookUsageMonthRecordTable> where,
    _is.OrderByBuilder<NotebookUsageMonthRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookUsageMonthRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookUsageMonthRecord>(
      where: where(NotebookUsageMonthRecord.t),
      orderBy: orderBy?.call(NotebookUsageMonthRecord.t),
      orderByList: orderByList?.call(NotebookUsageMonthRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookUsageMonthRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookUsageMonthRecord>(
      where: where?.call(NotebookUsageMonthRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookUsageMonthRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookUsageMonthRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookUsageMonthRecord>(
      where: where(NotebookUsageMonthRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
