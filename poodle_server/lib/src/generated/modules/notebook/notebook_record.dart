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

abstract class NotebookRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookRecord._({
    this.id,
    required this.courseId,
    required this.assessmentActivityId,
    required this.ownerUserId,
    int? configRevision,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : configRevision = configRevision ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory NotebookRecord({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    required _is.UuidValue assessmentActivityId,
    required _is.UuidValue ownerUserId,
    int? configRevision,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NotebookRecordImpl;

  factory NotebookRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      assessmentActivityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['assessmentActivityId'],
      ),
      ownerUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerUserId'],
      ),
      configRevision: jsonSerialization['configRevision'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = NotebookRecordTable();

  static const db = NotebookRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue courseId;

  _is.UuidValue assessmentActivityId;

  _is.UuidValue ownerUserId;

  int configRevision;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? courseId,
    _is.UuidValue? assessmentActivityId,
    _is.UuidValue? ownerUserId,
    int? configRevision,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookRecord',
      if (id != null) 'id': id?.toJson(),
      'courseId': courseId.toJson(),
      'assessmentActivityId': assessmentActivityId.toJson(),
      'ownerUserId': ownerUserId.toJson(),
      'configRevision': configRevision,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookRecordInclude include() {
    return NotebookRecordInclude._();
  }

  static NotebookRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookRecordTable>? orderByList,
    NotebookRecordInclude? include,
  }) {
    return NotebookRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookRecord.t),
      orderByList: orderByList?.call(NotebookRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookRecordImpl extends NotebookRecord {
  _NotebookRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    required _is.UuidValue assessmentActivityId,
    required _is.UuidValue ownerUserId,
    int? configRevision,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         courseId: courseId,
         assessmentActivityId: assessmentActivityId,
         ownerUserId: ownerUserId,
         configRevision: configRevision,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotebookRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? courseId,
    _is.UuidValue? assessmentActivityId,
    _is.UuidValue? ownerUserId,
    int? configRevision,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotebookRecord(
      id: id is _is.UuidValue? ? id : this.id,
      courseId: courseId ?? this.courseId,
      assessmentActivityId: assessmentActivityId ?? this.assessmentActivityId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      configRevision: configRevision ?? this.configRevision,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotebookRecordUpdateTable extends _is.UpdateTable<NotebookRecordTable> {
  NotebookRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> courseId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.courseId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> assessmentActivityId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.assessmentActivityId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.ownerUserId,
    value,
  );

  _is.ColumnValue<int, int> configRevision(int value) => _is.ColumnValue(
    table.configRevision,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class NotebookRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook') {
    updateTable = NotebookRecordUpdateTable(this);
    courseId = _is.ColumnUuid(
      'courseId',
      this,
    );
    assessmentActivityId = _is.ColumnUuid(
      'assessmentActivityId',
      this,
    );
    ownerUserId = _is.ColumnUuid(
      'ownerUserId',
      this,
    );
    configRevision = _is.ColumnInt(
      'configRevision',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final NotebookRecordUpdateTable updateTable;

  late final _is.ColumnUuid courseId;

  late final _is.ColumnUuid assessmentActivityId;

  late final _is.ColumnUuid ownerUserId;

  late final _is.ColumnInt configRevision;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    courseId,
    assessmentActivityId,
    ownerUserId,
    configRevision,
    createdAt,
    updatedAt,
  ];
}

class NotebookRecordInclude extends _is.IncludeObject {
  NotebookRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookRecord.t;
}

class NotebookRecordIncludeList extends _is.IncludeList {
  NotebookRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookRecord.t;
}

class NotebookRecordRepository {
  const NotebookRecordRepository._();

  /// Returns a list of [NotebookRecord]s matching the given query parameters.
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
  Future<List<NotebookRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookRecord>(
      where: where?.call(NotebookRecord.t),
      orderBy: orderBy?.call(NotebookRecord.t),
      orderByList: orderByList?.call(NotebookRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookRecord] matching the given query parameters.
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
  Future<NotebookRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookRecord>(
      where: where?.call(NotebookRecord.t),
      orderBy: orderBy?.call(NotebookRecord.t),
      orderByList: orderByList?.call(NotebookRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookRecord] by its [id] or null if no such row exists.
  Future<NotebookRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookRecord]s will have their `id` fields set.
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
  Future<List<NotebookRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookRecord] and returns the inserted row.
  ///
  /// The returned [NotebookRecord] will have its `id` field set.
  Future<NotebookRecord> insertRow(
    _is.DatabaseSession session,
    NotebookRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookRecord> rows, {
    required _is.ColumnSelections<NotebookRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookRecord.t),
      updateColumns: updateColumns?.call(NotebookRecord.t),
      updateWhere: updateWhere?.call(NotebookRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookRecord] and returns the resulting row.
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
  /// The returned [NotebookRecord] will have its `id` field set.
  Future<NotebookRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookRecord row, {
    required _is.ColumnSelections<NotebookRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookRecord>(
      row,
      conflictColumns: conflictColumns(NotebookRecord.t),
      updateColumns: updateColumns?.call(NotebookRecord.t),
      updateWhere: updateWhere?.call(NotebookRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookRecord>> update(
    _is.DatabaseSession session,
    List<NotebookRecord> rows, {
    _is.ColumnSelections<NotebookRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookRecord>(
      rows,
      columns: columns?.call(NotebookRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookRecord> updateRow(
    _is.DatabaseSession session,
    NotebookRecord row, {
    _is.ColumnSelections<NotebookRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookRecord>(
      row,
      columns: columns?.call(NotebookRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NotebookRecordUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookRecord>(
      id,
      columnValues: columnValues(NotebookRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotebookRecordUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<NotebookRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookRecord>(
      columnValues: columnValues(NotebookRecord.t.updateTable),
      where: where(NotebookRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookRecord.t),
      orderByList: orderByList?.call(NotebookRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookRecord> rows, {
    _is.OrderByBuilder<NotebookRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookRecord>(
      rows,
      orderBy: orderBy?.call(NotebookRecord.t),
      orderByList: orderByList?.call(NotebookRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookRecord].
  Future<NotebookRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookRecord>(
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
  Future<List<NotebookRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookRecordTable> where,
    _is.OrderByBuilder<NotebookRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookRecord>(
      where: where(NotebookRecord.t),
      orderBy: orderBy?.call(NotebookRecord.t),
      orderByList: orderByList?.call(NotebookRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookRecord>(
      where: where?.call(NotebookRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookRecord>(
      where: where(NotebookRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
