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

abstract class SearchIndexJob
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SearchIndexJob._({
    this.id,
    required this.fingerprint,
    required this.targetId,
    int? attempts,
    String? state,
    DateTime? availableAt,
    this.leaseUntil,
  }) : attempts = attempts ?? 0,
       state = state ?? 'queued',
       availableAt = availableAt ?? DateTime.now();

  factory SearchIndexJob({
    int? id,
    required String fingerprint,
    required _is.UuidValue targetId,
    int? attempts,
    String? state,
    DateTime? availableAt,
    DateTime? leaseUntil,
  }) = _SearchIndexJobImpl;

  factory SearchIndexJob.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchIndexJob(
      id: jsonSerialization['id'] as int?,
      fingerprint: jsonSerialization['fingerprint'] as String,
      targetId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['targetId'],
      ),
      attempts: jsonSerialization['attempts'] as int?,
      state: jsonSerialization['state'] as String?,
      availableAt: jsonSerialization['availableAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['availableAt'],
            ),
      leaseUntil: jsonSerialization['leaseUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['leaseUntil']),
    );
  }

  static final t = SearchIndexJobTable();

  static const db = SearchIndexJobRepository._();

  @override
  int? id;

  String fingerprint;

  _is.UuidValue targetId;

  int attempts;

  String state;

  DateTime availableAt;

  DateTime? leaseUntil;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SearchIndexJob]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SearchIndexJob copyWith({
    int? id,
    String? fingerprint,
    _is.UuidValue? targetId,
    int? attempts,
    String? state,
    DateTime? availableAt,
    DateTime? leaseUntil,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SearchIndexJob',
      if (id != null) 'id': id,
      'fingerprint': fingerprint,
      'targetId': targetId.toJson(),
      'attempts': attempts,
      'state': state,
      'availableAt': availableAt.toJson(),
      if (leaseUntil != null) 'leaseUntil': leaseUntil?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SearchIndexJobInclude include() {
    return SearchIndexJobInclude._();
  }

  static SearchIndexJobIncludeList includeList({
    _is.WhereExpressionBuilder<SearchIndexJobTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SearchIndexJobTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexJobTable>? orderByList,
    SearchIndexJobInclude? include,
  }) {
    return SearchIndexJobIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SearchIndexJob.t),
      orderByList: orderByList?.call(SearchIndexJob.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SearchIndexJobImpl extends SearchIndexJob {
  _SearchIndexJobImpl({
    int? id,
    required String fingerprint,
    required _is.UuidValue targetId,
    int? attempts,
    String? state,
    DateTime? availableAt,
    DateTime? leaseUntil,
  }) : super._(
         id: id,
         fingerprint: fingerprint,
         targetId: targetId,
         attempts: attempts,
         state: state,
         availableAt: availableAt,
         leaseUntil: leaseUntil,
       );

  /// Returns a shallow copy of this [SearchIndexJob]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SearchIndexJob copyWith({
    Object? id = _Undefined,
    String? fingerprint,
    _is.UuidValue? targetId,
    int? attempts,
    String? state,
    DateTime? availableAt,
    Object? leaseUntil = _Undefined,
  }) {
    return SearchIndexJob(
      id: id is int? ? id : this.id,
      fingerprint: fingerprint ?? this.fingerprint,
      targetId: targetId ?? this.targetId,
      attempts: attempts ?? this.attempts,
      state: state ?? this.state,
      availableAt: availableAt ?? this.availableAt,
      leaseUntil: leaseUntil is DateTime? ? leaseUntil : this.leaseUntil,
    );
  }
}

class SearchIndexJobUpdateTable extends _is.UpdateTable<SearchIndexJobTable> {
  SearchIndexJobUpdateTable(super.table);

  _is.ColumnValue<String, String> fingerprint(String value) => _is.ColumnValue(
    table.fingerprint,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> targetId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.targetId,
        value,
      );

  _is.ColumnValue<int, int> attempts(int value) => _is.ColumnValue(
    table.attempts,
    value,
  );

  _is.ColumnValue<String, String> state(String value) => _is.ColumnValue(
    table.state,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> availableAt(DateTime value) =>
      _is.ColumnValue(
        table.availableAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> leaseUntil(DateTime? value) =>
      _is.ColumnValue(
        table.leaseUntil,
        value,
      );
}

class SearchIndexJobTable extends _is.Table<int?> {
  SearchIndexJobTable({super.tableRelation})
    : super(tableName: 'poodle_search_index_job') {
    updateTable = SearchIndexJobUpdateTable(this);
    fingerprint = _is.ColumnString(
      'fingerprint',
      this,
    );
    targetId = _is.ColumnUuid(
      'targetId',
      this,
    );
    attempts = _is.ColumnInt(
      'attempts',
      this,
      hasDefault: true,
    );
    state = _is.ColumnString(
      'state',
      this,
      hasDefault: true,
    );
    availableAt = _is.ColumnDateTime(
      'availableAt',
      this,
      hasDefault: true,
    );
    leaseUntil = _is.ColumnDateTime(
      'leaseUntil',
      this,
    );
  }

  late final SearchIndexJobUpdateTable updateTable;

  late final _is.ColumnString fingerprint;

  late final _is.ColumnUuid targetId;

  late final _is.ColumnInt attempts;

  late final _is.ColumnString state;

  late final _is.ColumnDateTime availableAt;

  late final _is.ColumnDateTime leaseUntil;

  @override
  List<_is.Column> get columns => [
    id,
    fingerprint,
    targetId,
    attempts,
    state,
    availableAt,
    leaseUntil,
  ];
}

class SearchIndexJobInclude extends _is.IncludeObject {
  SearchIndexJobInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SearchIndexJob.t;
}

class SearchIndexJobIncludeList extends _is.IncludeList {
  SearchIndexJobIncludeList._({
    _is.WhereExpressionBuilder<SearchIndexJobTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SearchIndexJob.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SearchIndexJob.t;
}

class SearchIndexJobRepository {
  const SearchIndexJobRepository._();

  /// Returns a list of [SearchIndexJob]s matching the given query parameters.
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
  Future<List<SearchIndexJob>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SearchIndexJobTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SearchIndexJobTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexJobTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SearchIndexJob>(
      where: where?.call(SearchIndexJob.t),
      orderBy: orderBy?.call(SearchIndexJob.t),
      orderByList: orderByList?.call(SearchIndexJob.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SearchIndexJob] matching the given query parameters.
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
  Future<SearchIndexJob?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SearchIndexJobTable>? where,
    int? offset,
    _is.OrderByBuilder<SearchIndexJobTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexJobTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SearchIndexJob>(
      where: where?.call(SearchIndexJob.t),
      orderBy: orderBy?.call(SearchIndexJob.t),
      orderByList: orderByList?.call(SearchIndexJob.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SearchIndexJob] by its [id] or null if no such row exists.
  Future<SearchIndexJob?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SearchIndexJob>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SearchIndexJob]s in the list and returns the inserted rows.
  ///
  /// The returned [SearchIndexJob]s will have their `id` fields set.
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
  Future<List<SearchIndexJob>> insert(
    _is.DatabaseSession session,
    List<SearchIndexJob> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SearchIndexJob>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SearchIndexJob] and returns the inserted row.
  ///
  /// The returned [SearchIndexJob] will have its `id` field set.
  Future<SearchIndexJob> insertRow(
    _is.DatabaseSession session,
    SearchIndexJob row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SearchIndexJob>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SearchIndexJob]s in the list and returns the resulting rows.
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
  /// The returned [SearchIndexJob]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SearchIndexJob>> upsert(
    _is.DatabaseSession session,
    List<SearchIndexJob> rows, {
    required _is.ColumnSelections<SearchIndexJobTable> conflictColumns,
    _is.ColumnSelections<SearchIndexJobTable>? updateColumns,
    _is.WhereExpressionBuilder<SearchIndexJobTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SearchIndexJob>(
      rows,
      conflictColumns: conflictColumns(SearchIndexJob.t),
      updateColumns: updateColumns?.call(SearchIndexJob.t),
      updateWhere: updateWhere?.call(SearchIndexJob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SearchIndexJob] and returns the resulting row.
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
  /// The returned [SearchIndexJob] will have its `id` field set.
  Future<SearchIndexJob?> upsertRow(
    _is.DatabaseSession session,
    SearchIndexJob row, {
    required _is.ColumnSelections<SearchIndexJobTable> conflictColumns,
    _is.ColumnSelections<SearchIndexJobTable>? updateColumns,
    _is.WhereExpressionBuilder<SearchIndexJobTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SearchIndexJob>(
      row,
      conflictColumns: conflictColumns(SearchIndexJob.t),
      updateColumns: updateColumns?.call(SearchIndexJob.t),
      updateWhere: updateWhere?.call(SearchIndexJob.t),
      transaction: transaction,
    );
  }

  /// Updates all [SearchIndexJob]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SearchIndexJob>> update(
    _is.DatabaseSession session,
    List<SearchIndexJob> rows, {
    _is.ColumnSelections<SearchIndexJobTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SearchIndexJob>(
      rows,
      columns: columns?.call(SearchIndexJob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SearchIndexJob]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SearchIndexJob> updateRow(
    _is.DatabaseSession session,
    SearchIndexJob row, {
    _is.ColumnSelections<SearchIndexJobTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SearchIndexJob>(
      row,
      columns: columns?.call(SearchIndexJob.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SearchIndexJob] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SearchIndexJob?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SearchIndexJobUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SearchIndexJob>(
      id,
      columnValues: columnValues(SearchIndexJob.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SearchIndexJob]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SearchIndexJob>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SearchIndexJobUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SearchIndexJobTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SearchIndexJobTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexJobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SearchIndexJob>(
      columnValues: columnValues(SearchIndexJob.t.updateTable),
      where: where(SearchIndexJob.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SearchIndexJob.t),
      orderByList: orderByList?.call(SearchIndexJob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SearchIndexJob]s in the list and returns the deleted rows.
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
  Future<List<SearchIndexJob>> delete(
    _is.DatabaseSession session,
    List<SearchIndexJob> rows, {
    _is.OrderByBuilder<SearchIndexJobTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexJobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SearchIndexJob>(
      rows,
      orderBy: orderBy?.call(SearchIndexJob.t),
      orderByList: orderByList?.call(SearchIndexJob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SearchIndexJob].
  Future<SearchIndexJob> deleteRow(
    _is.DatabaseSession session,
    SearchIndexJob row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SearchIndexJob>(
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
  Future<List<SearchIndexJob>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SearchIndexJobTable> where,
    _is.OrderByBuilder<SearchIndexJobTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexJobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SearchIndexJob>(
      where: where(SearchIndexJob.t),
      orderBy: orderBy?.call(SearchIndexJob.t),
      orderByList: orderByList?.call(SearchIndexJob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SearchIndexJobTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SearchIndexJob>(
      where: where?.call(SearchIndexJob.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SearchIndexJob] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SearchIndexJobTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SearchIndexJob>(
      where: where(SearchIndexJob.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
