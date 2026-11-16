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

abstract class NotebookAssessmentMaterialRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookAssessmentMaterialRecord._({
    this.id,
    required this.configId,
    required this.activityId,
    required this.sortOrder,
  });

  factory NotebookAssessmentMaterialRecord({
    _is.UuidValue? id,
    required _is.UuidValue configId,
    required _is.UuidValue activityId,
    required int sortOrder,
  }) = _NotebookAssessmentMaterialRecordImpl;

  factory NotebookAssessmentMaterialRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookAssessmentMaterialRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      configId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['configId'],
      ),
      activityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['activityId'],
      ),
      sortOrder: jsonSerialization['sortOrder'] as int,
    );
  }

  static final t = NotebookAssessmentMaterialRecordTable();

  static const db = NotebookAssessmentMaterialRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue configId;

  _is.UuidValue activityId;

  int sortOrder;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookAssessmentMaterialRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookAssessmentMaterialRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? configId,
    _is.UuidValue? activityId,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookAssessmentMaterialRecord',
      if (id != null) 'id': id?.toJson(),
      'configId': configId.toJson(),
      'activityId': activityId.toJson(),
      'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookAssessmentMaterialRecordInclude include() {
    return NotebookAssessmentMaterialRecordInclude._();
  }

  static NotebookAssessmentMaterialRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookAssessmentMaterialRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookAssessmentMaterialRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentMaterialRecordTable>? orderByList,
    NotebookAssessmentMaterialRecordInclude? include,
  }) {
    return NotebookAssessmentMaterialRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookAssessmentMaterialRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentMaterialRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookAssessmentMaterialRecordImpl
    extends NotebookAssessmentMaterialRecord {
  _NotebookAssessmentMaterialRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue configId,
    required _is.UuidValue activityId,
    required int sortOrder,
  }) : super._(
         id: id,
         configId: configId,
         activityId: activityId,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [NotebookAssessmentMaterialRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookAssessmentMaterialRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? configId,
    _is.UuidValue? activityId,
    int? sortOrder,
  }) {
    return NotebookAssessmentMaterialRecord(
      id: id is _is.UuidValue? ? id : this.id,
      configId: configId ?? this.configId,
      activityId: activityId ?? this.activityId,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class NotebookAssessmentMaterialRecordUpdateTable
    extends _is.UpdateTable<NotebookAssessmentMaterialRecordTable> {
  NotebookAssessmentMaterialRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> configId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.configId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> activityId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.activityId,
    value,
  );

  _is.ColumnValue<int, int> sortOrder(int value) => _is.ColumnValue(
    table.sortOrder,
    value,
  );
}

class NotebookAssessmentMaterialRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookAssessmentMaterialRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook_assessment_material') {
    updateTable = NotebookAssessmentMaterialRecordUpdateTable(this);
    configId = _is.ColumnUuid(
      'configId',
      this,
    );
    activityId = _is.ColumnUuid(
      'activityId',
      this,
    );
    sortOrder = _is.ColumnInt(
      'sortOrder',
      this,
    );
  }

  late final NotebookAssessmentMaterialRecordUpdateTable updateTable;

  late final _is.ColumnUuid configId;

  late final _is.ColumnUuid activityId;

  late final _is.ColumnInt sortOrder;

  @override
  List<_is.Column> get columns => [
    id,
    configId,
    activityId,
    sortOrder,
  ];
}

class NotebookAssessmentMaterialRecordInclude extends _is.IncludeObject {
  NotebookAssessmentMaterialRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookAssessmentMaterialRecord.t;
}

class NotebookAssessmentMaterialRecordIncludeList extends _is.IncludeList {
  NotebookAssessmentMaterialRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookAssessmentMaterialRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookAssessmentMaterialRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookAssessmentMaterialRecord.t;
}

class NotebookAssessmentMaterialRecordRepository {
  const NotebookAssessmentMaterialRecordRepository._();

  /// Returns a list of [NotebookAssessmentMaterialRecord]s matching the given query parameters.
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
  Future<List<NotebookAssessmentMaterialRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookAssessmentMaterialRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookAssessmentMaterialRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentMaterialRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookAssessmentMaterialRecord>(
      where: where?.call(NotebookAssessmentMaterialRecord.t),
      orderBy: orderBy?.call(NotebookAssessmentMaterialRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentMaterialRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookAssessmentMaterialRecord] matching the given query parameters.
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
  Future<NotebookAssessmentMaterialRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookAssessmentMaterialRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookAssessmentMaterialRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentMaterialRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookAssessmentMaterialRecord>(
      where: where?.call(NotebookAssessmentMaterialRecord.t),
      orderBy: orderBy?.call(NotebookAssessmentMaterialRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentMaterialRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookAssessmentMaterialRecord] by its [id] or null if no such row exists.
  Future<NotebookAssessmentMaterialRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookAssessmentMaterialRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookAssessmentMaterialRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookAssessmentMaterialRecord]s will have their `id` fields set.
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
  Future<List<NotebookAssessmentMaterialRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookAssessmentMaterialRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookAssessmentMaterialRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookAssessmentMaterialRecord] and returns the inserted row.
  ///
  /// The returned [NotebookAssessmentMaterialRecord] will have its `id` field set.
  Future<NotebookAssessmentMaterialRecord> insertRow(
    _is.DatabaseSession session,
    NotebookAssessmentMaterialRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookAssessmentMaterialRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookAssessmentMaterialRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookAssessmentMaterialRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookAssessmentMaterialRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookAssessmentMaterialRecord> rows, {
    required _is.ColumnSelections<NotebookAssessmentMaterialRecordTable>
    conflictColumns,
    _is.ColumnSelections<NotebookAssessmentMaterialRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookAssessmentMaterialRecordTable>?
    updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookAssessmentMaterialRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookAssessmentMaterialRecord.t),
      updateColumns: updateColumns?.call(NotebookAssessmentMaterialRecord.t),
      updateWhere: updateWhere?.call(NotebookAssessmentMaterialRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookAssessmentMaterialRecord] and returns the resulting row.
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
  /// The returned [NotebookAssessmentMaterialRecord] will have its `id` field set.
  Future<NotebookAssessmentMaterialRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookAssessmentMaterialRecord row, {
    required _is.ColumnSelections<NotebookAssessmentMaterialRecordTable>
    conflictColumns,
    _is.ColumnSelections<NotebookAssessmentMaterialRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookAssessmentMaterialRecordTable>?
    updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookAssessmentMaterialRecord>(
      row,
      conflictColumns: conflictColumns(NotebookAssessmentMaterialRecord.t),
      updateColumns: updateColumns?.call(NotebookAssessmentMaterialRecord.t),
      updateWhere: updateWhere?.call(NotebookAssessmentMaterialRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookAssessmentMaterialRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookAssessmentMaterialRecord>> update(
    _is.DatabaseSession session,
    List<NotebookAssessmentMaterialRecord> rows, {
    _is.ColumnSelections<NotebookAssessmentMaterialRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookAssessmentMaterialRecord>(
      rows,
      columns: columns?.call(NotebookAssessmentMaterialRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookAssessmentMaterialRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookAssessmentMaterialRecord> updateRow(
    _is.DatabaseSession session,
    NotebookAssessmentMaterialRecord row, {
    _is.ColumnSelections<NotebookAssessmentMaterialRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookAssessmentMaterialRecord>(
      row,
      columns: columns?.call(NotebookAssessmentMaterialRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookAssessmentMaterialRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookAssessmentMaterialRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<
      NotebookAssessmentMaterialRecordUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookAssessmentMaterialRecord>(
      id,
      columnValues: columnValues(
        NotebookAssessmentMaterialRecord.t.updateTable,
      ),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookAssessmentMaterialRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookAssessmentMaterialRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      NotebookAssessmentMaterialRecordUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<NotebookAssessmentMaterialRecordTable>
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookAssessmentMaterialRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentMaterialRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookAssessmentMaterialRecord>(
      columnValues: columnValues(
        NotebookAssessmentMaterialRecord.t.updateTable,
      ),
      where: where(NotebookAssessmentMaterialRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookAssessmentMaterialRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentMaterialRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookAssessmentMaterialRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookAssessmentMaterialRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookAssessmentMaterialRecord> rows, {
    _is.OrderByBuilder<NotebookAssessmentMaterialRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentMaterialRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookAssessmentMaterialRecord>(
      rows,
      orderBy: orderBy?.call(NotebookAssessmentMaterialRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentMaterialRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookAssessmentMaterialRecord].
  Future<NotebookAssessmentMaterialRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookAssessmentMaterialRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookAssessmentMaterialRecord>(
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
  Future<List<NotebookAssessmentMaterialRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookAssessmentMaterialRecordTable>
    where,
    _is.OrderByBuilder<NotebookAssessmentMaterialRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentMaterialRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookAssessmentMaterialRecord>(
      where: where(NotebookAssessmentMaterialRecord.t),
      orderBy: orderBy?.call(NotebookAssessmentMaterialRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentMaterialRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookAssessmentMaterialRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookAssessmentMaterialRecord>(
      where: where?.call(NotebookAssessmentMaterialRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookAssessmentMaterialRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookAssessmentMaterialRecordTable>
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookAssessmentMaterialRecord>(
      where: where(NotebookAssessmentMaterialRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
