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

abstract class NotebookSourceSelectionRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookSourceSelectionRecord._({
    this.id,
    required this.notebookId,
    required this.sourceId,
    bool? selected,
    required this.selectedVersion,
    DateTime? createdAt,
  }) : selected = selected ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory NotebookSourceSelectionRecord({
    _is.UuidValue? id,
    required _is.UuidValue notebookId,
    required _is.UuidValue sourceId,
    bool? selected,
    required int selectedVersion,
    DateTime? createdAt,
  }) = _NotebookSourceSelectionRecordImpl;

  factory NotebookSourceSelectionRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookSourceSelectionRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      notebookId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['notebookId'],
      ),
      sourceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sourceId'],
      ),
      selected: jsonSerialization['selected'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['selected']),
      selectedVersion: jsonSerialization['selectedVersion'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = NotebookSourceSelectionRecordTable();

  static const db = NotebookSourceSelectionRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue notebookId;

  _is.UuidValue sourceId;

  bool selected;

  int selectedVersion;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookSourceSelectionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookSourceSelectionRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? notebookId,
    _is.UuidValue? sourceId,
    bool? selected,
    int? selectedVersion,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookSourceSelectionRecord',
      if (id != null) 'id': id?.toJson(),
      'notebookId': notebookId.toJson(),
      'sourceId': sourceId.toJson(),
      'selected': selected,
      'selectedVersion': selectedVersion,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookSourceSelectionRecordInclude include() {
    return NotebookSourceSelectionRecordInclude._();
  }

  static NotebookSourceSelectionRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookSourceSelectionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookSourceSelectionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceSelectionRecordTable>? orderByList,
    NotebookSourceSelectionRecordInclude? include,
  }) {
    return NotebookSourceSelectionRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookSourceSelectionRecord.t),
      orderByList: orderByList?.call(NotebookSourceSelectionRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookSourceSelectionRecordImpl extends NotebookSourceSelectionRecord {
  _NotebookSourceSelectionRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue notebookId,
    required _is.UuidValue sourceId,
    bool? selected,
    required int selectedVersion,
    DateTime? createdAt,
  }) : super._(
         id: id,
         notebookId: notebookId,
         sourceId: sourceId,
         selected: selected,
         selectedVersion: selectedVersion,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotebookSourceSelectionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookSourceSelectionRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? notebookId,
    _is.UuidValue? sourceId,
    bool? selected,
    int? selectedVersion,
    DateTime? createdAt,
  }) {
    return NotebookSourceSelectionRecord(
      id: id is _is.UuidValue? ? id : this.id,
      notebookId: notebookId ?? this.notebookId,
      sourceId: sourceId ?? this.sourceId,
      selected: selected ?? this.selected,
      selectedVersion: selectedVersion ?? this.selectedVersion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotebookSourceSelectionRecordUpdateTable
    extends _is.UpdateTable<NotebookSourceSelectionRecordTable> {
  NotebookSourceSelectionRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> notebookId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.notebookId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sourceId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.sourceId,
        value,
      );

  _is.ColumnValue<bool, bool> selected(bool value) => _is.ColumnValue(
    table.selected,
    value,
  );

  _is.ColumnValue<int, int> selectedVersion(int value) => _is.ColumnValue(
    table.selectedVersion,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class NotebookSourceSelectionRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookSourceSelectionRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook_source_selection') {
    updateTable = NotebookSourceSelectionRecordUpdateTable(this);
    notebookId = _is.ColumnUuid(
      'notebookId',
      this,
    );
    sourceId = _is.ColumnUuid(
      'sourceId',
      this,
    );
    selected = _is.ColumnBool(
      'selected',
      this,
      hasDefault: true,
    );
    selectedVersion = _is.ColumnInt(
      'selectedVersion',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final NotebookSourceSelectionRecordUpdateTable updateTable;

  late final _is.ColumnUuid notebookId;

  late final _is.ColumnUuid sourceId;

  late final _is.ColumnBool selected;

  late final _is.ColumnInt selectedVersion;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    notebookId,
    sourceId,
    selected,
    selectedVersion,
    createdAt,
  ];
}

class NotebookSourceSelectionRecordInclude extends _is.IncludeObject {
  NotebookSourceSelectionRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookSourceSelectionRecord.t;
}

class NotebookSourceSelectionRecordIncludeList extends _is.IncludeList {
  NotebookSourceSelectionRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookSourceSelectionRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookSourceSelectionRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookSourceSelectionRecord.t;
}

class NotebookSourceSelectionRecordRepository {
  const NotebookSourceSelectionRecordRepository._();

  /// Returns a list of [NotebookSourceSelectionRecord]s matching the given query parameters.
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
  Future<List<NotebookSourceSelectionRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookSourceSelectionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookSourceSelectionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceSelectionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookSourceSelectionRecord>(
      where: where?.call(NotebookSourceSelectionRecord.t),
      orderBy: orderBy?.call(NotebookSourceSelectionRecord.t),
      orderByList: orderByList?.call(NotebookSourceSelectionRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookSourceSelectionRecord] matching the given query parameters.
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
  Future<NotebookSourceSelectionRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookSourceSelectionRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookSourceSelectionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceSelectionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookSourceSelectionRecord>(
      where: where?.call(NotebookSourceSelectionRecord.t),
      orderBy: orderBy?.call(NotebookSourceSelectionRecord.t),
      orderByList: orderByList?.call(NotebookSourceSelectionRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookSourceSelectionRecord] by its [id] or null if no such row exists.
  Future<NotebookSourceSelectionRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookSourceSelectionRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookSourceSelectionRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookSourceSelectionRecord]s will have their `id` fields set.
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
  Future<List<NotebookSourceSelectionRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookSourceSelectionRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookSourceSelectionRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookSourceSelectionRecord] and returns the inserted row.
  ///
  /// The returned [NotebookSourceSelectionRecord] will have its `id` field set.
  Future<NotebookSourceSelectionRecord> insertRow(
    _is.DatabaseSession session,
    NotebookSourceSelectionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookSourceSelectionRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookSourceSelectionRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookSourceSelectionRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookSourceSelectionRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookSourceSelectionRecord> rows, {
    required _is.ColumnSelections<NotebookSourceSelectionRecordTable>
    conflictColumns,
    _is.ColumnSelections<NotebookSourceSelectionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookSourceSelectionRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookSourceSelectionRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookSourceSelectionRecord.t),
      updateColumns: updateColumns?.call(NotebookSourceSelectionRecord.t),
      updateWhere: updateWhere?.call(NotebookSourceSelectionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookSourceSelectionRecord] and returns the resulting row.
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
  /// The returned [NotebookSourceSelectionRecord] will have its `id` field set.
  Future<NotebookSourceSelectionRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookSourceSelectionRecord row, {
    required _is.ColumnSelections<NotebookSourceSelectionRecordTable>
    conflictColumns,
    _is.ColumnSelections<NotebookSourceSelectionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookSourceSelectionRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookSourceSelectionRecord>(
      row,
      conflictColumns: conflictColumns(NotebookSourceSelectionRecord.t),
      updateColumns: updateColumns?.call(NotebookSourceSelectionRecord.t),
      updateWhere: updateWhere?.call(NotebookSourceSelectionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookSourceSelectionRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookSourceSelectionRecord>> update(
    _is.DatabaseSession session,
    List<NotebookSourceSelectionRecord> rows, {
    _is.ColumnSelections<NotebookSourceSelectionRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookSourceSelectionRecord>(
      rows,
      columns: columns?.call(NotebookSourceSelectionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookSourceSelectionRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookSourceSelectionRecord> updateRow(
    _is.DatabaseSession session,
    NotebookSourceSelectionRecord row, {
    _is.ColumnSelections<NotebookSourceSelectionRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookSourceSelectionRecord>(
      row,
      columns: columns?.call(NotebookSourceSelectionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookSourceSelectionRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookSourceSelectionRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<
      NotebookSourceSelectionRecordUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookSourceSelectionRecord>(
      id,
      columnValues: columnValues(NotebookSourceSelectionRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookSourceSelectionRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookSourceSelectionRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      NotebookSourceSelectionRecordUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<NotebookSourceSelectionRecordTable>
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookSourceSelectionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceSelectionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookSourceSelectionRecord>(
      columnValues: columnValues(NotebookSourceSelectionRecord.t.updateTable),
      where: where(NotebookSourceSelectionRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookSourceSelectionRecord.t),
      orderByList: orderByList?.call(NotebookSourceSelectionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookSourceSelectionRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookSourceSelectionRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookSourceSelectionRecord> rows, {
    _is.OrderByBuilder<NotebookSourceSelectionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceSelectionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookSourceSelectionRecord>(
      rows,
      orderBy: orderBy?.call(NotebookSourceSelectionRecord.t),
      orderByList: orderByList?.call(NotebookSourceSelectionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookSourceSelectionRecord].
  Future<NotebookSourceSelectionRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookSourceSelectionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookSourceSelectionRecord>(
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
  Future<List<NotebookSourceSelectionRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookSourceSelectionRecordTable>
    where,
    _is.OrderByBuilder<NotebookSourceSelectionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceSelectionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookSourceSelectionRecord>(
      where: where(NotebookSourceSelectionRecord.t),
      orderBy: orderBy?.call(NotebookSourceSelectionRecord.t),
      orderByList: orderByList?.call(NotebookSourceSelectionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookSourceSelectionRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookSourceSelectionRecord>(
      where: where?.call(NotebookSourceSelectionRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookSourceSelectionRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookSourceSelectionRecordTable>
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookSourceSelectionRecord>(
      where: where(NotebookSourceSelectionRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
