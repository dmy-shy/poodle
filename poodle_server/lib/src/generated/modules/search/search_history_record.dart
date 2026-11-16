/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:poodle_server/src/generated/protocol.dart' as _ikm1kaos;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;

abstract class SearchHistoryRecord
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SearchHistoryRecord._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.query,
    required this.normalized,
    required this.lastUsed,
  });

  factory SearchHistoryRecord({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String query,
    required String normalized,
    required DateTime lastUsed,
  }) = _SearchHistoryRecordImpl;

  factory SearchHistoryRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchHistoryRecord(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      query: jsonSerialization['query'] as String,
      normalized: jsonSerialization['normalized'] as String,
      lastUsed: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastUsed'],
      ),
    );
  }

  static final t = SearchHistoryRecordTable();

  static const db = SearchHistoryRecordRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  _iacs.AuthUser? authUser;

  String query;

  String normalized;

  DateTime lastUsed;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SearchHistoryRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SearchHistoryRecord copyWith({
    int? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    String? query,
    String? normalized,
    DateTime? lastUsed,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SearchHistoryRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'query': query,
      'normalized': normalized,
      'lastUsed': lastUsed.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SearchHistoryRecordInclude include({_iacs.AuthUserInclude? authUser}) {
    return SearchHistoryRecordInclude._(authUser: authUser);
  }

  static SearchHistoryRecordIncludeList includeList({
    _is.WhereExpressionBuilder<SearchHistoryRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SearchHistoryRecordTable>? orderBy,
    _is.OrderByListBuilder<SearchHistoryRecordTable>? orderByList,
    SearchHistoryRecordInclude? include,
  }) {
    return SearchHistoryRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SearchHistoryRecord.t),
      orderByList: orderByList?.call(SearchHistoryRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SearchHistoryRecordImpl extends SearchHistoryRecord {
  _SearchHistoryRecordImpl({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String query,
    required String normalized,
    required DateTime lastUsed,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         query: query,
         normalized: normalized,
         lastUsed: lastUsed,
       );

  /// Returns a shallow copy of this [SearchHistoryRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SearchHistoryRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? query,
    String? normalized,
    DateTime? lastUsed,
  }) {
    return SearchHistoryRecord(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      query: query ?? this.query,
      normalized: normalized ?? this.normalized,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }
}

class SearchHistoryRecordUpdateTable
    extends _is.UpdateTable<SearchHistoryRecordTable> {
  SearchHistoryRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> query(String value) => _is.ColumnValue(
    table.query,
    value,
  );

  _is.ColumnValue<String, String> normalized(String value) => _is.ColumnValue(
    table.normalized,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastUsed(DateTime value) =>
      _is.ColumnValue(
        table.lastUsed,
        value,
      );
}

class SearchHistoryRecordTable extends _is.Table<int?> {
  SearchHistoryRecordTable({super.tableRelation})
    : super(tableName: 'poodle_search_history') {
    updateTable = SearchHistoryRecordUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    query = _is.ColumnString(
      'query',
      this,
    );
    normalized = _is.ColumnString(
      'normalized',
      this,
    );
    lastUsed = _is.ColumnDateTime(
      'lastUsed',
      this,
    );
  }

  late final SearchHistoryRecordUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  _iacs.AuthUserTable? _authUser;

  late final _is.ColumnString query;

  late final _is.ColumnString normalized;

  late final _is.ColumnDateTime lastUsed;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: SearchHistoryRecord.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    query,
    normalized,
    lastUsed,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class SearchHistoryRecordInclude extends _is.IncludeObject {
  SearchHistoryRecordInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<int?> get table => SearchHistoryRecord.t;
}

class SearchHistoryRecordIncludeList extends _is.IncludeList {
  SearchHistoryRecordIncludeList._({
    _is.WhereExpressionBuilder<SearchHistoryRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SearchHistoryRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SearchHistoryRecord.t;
}

class SearchHistoryRecordRepository {
  const SearchHistoryRecordRepository._();

  final attachRow = const SearchHistoryRecordAttachRowRepository._();

  /// Returns a list of [SearchHistoryRecord]s matching the given query parameters.
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
  Future<List<SearchHistoryRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SearchHistoryRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SearchHistoryRecordTable>? orderBy,
    _is.OrderByListBuilder<SearchHistoryRecordTable>? orderByList,
    _is.Transaction? transaction,
    SearchHistoryRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SearchHistoryRecord>(
      where: where?.call(SearchHistoryRecord.t),
      orderBy: orderBy?.call(SearchHistoryRecord.t),
      orderByList: orderByList?.call(SearchHistoryRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SearchHistoryRecord] matching the given query parameters.
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
  Future<SearchHistoryRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SearchHistoryRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<SearchHistoryRecordTable>? orderBy,
    _is.OrderByListBuilder<SearchHistoryRecordTable>? orderByList,
    _is.Transaction? transaction,
    SearchHistoryRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SearchHistoryRecord>(
      where: where?.call(SearchHistoryRecord.t),
      orderBy: orderBy?.call(SearchHistoryRecord.t),
      orderByList: orderByList?.call(SearchHistoryRecord.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SearchHistoryRecord] by its [id] or null if no such row exists.
  Future<SearchHistoryRecord?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    SearchHistoryRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SearchHistoryRecord>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SearchHistoryRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [SearchHistoryRecord]s will have their `id` fields set.
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
  Future<List<SearchHistoryRecord>> insert(
    _is.DatabaseSession session,
    List<SearchHistoryRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SearchHistoryRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SearchHistoryRecord] and returns the inserted row.
  ///
  /// The returned [SearchHistoryRecord] will have its `id` field set.
  Future<SearchHistoryRecord> insertRow(
    _is.DatabaseSession session,
    SearchHistoryRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SearchHistoryRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SearchHistoryRecord]s in the list and returns the resulting rows.
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
  /// The returned [SearchHistoryRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SearchHistoryRecord>> upsert(
    _is.DatabaseSession session,
    List<SearchHistoryRecord> rows, {
    required _is.ColumnSelections<SearchHistoryRecordTable> conflictColumns,
    _is.ColumnSelections<SearchHistoryRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<SearchHistoryRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SearchHistoryRecord>(
      rows,
      conflictColumns: conflictColumns(SearchHistoryRecord.t),
      updateColumns: updateColumns?.call(SearchHistoryRecord.t),
      updateWhere: updateWhere?.call(SearchHistoryRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SearchHistoryRecord] and returns the resulting row.
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
  /// The returned [SearchHistoryRecord] will have its `id` field set.
  Future<SearchHistoryRecord?> upsertRow(
    _is.DatabaseSession session,
    SearchHistoryRecord row, {
    required _is.ColumnSelections<SearchHistoryRecordTable> conflictColumns,
    _is.ColumnSelections<SearchHistoryRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<SearchHistoryRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SearchHistoryRecord>(
      row,
      conflictColumns: conflictColumns(SearchHistoryRecord.t),
      updateColumns: updateColumns?.call(SearchHistoryRecord.t),
      updateWhere: updateWhere?.call(SearchHistoryRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [SearchHistoryRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SearchHistoryRecord>> update(
    _is.DatabaseSession session,
    List<SearchHistoryRecord> rows, {
    _is.ColumnSelections<SearchHistoryRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SearchHistoryRecord>(
      rows,
      columns: columns?.call(SearchHistoryRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SearchHistoryRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SearchHistoryRecord> updateRow(
    _is.DatabaseSession session,
    SearchHistoryRecord row, {
    _is.ColumnSelections<SearchHistoryRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SearchHistoryRecord>(
      row,
      columns: columns?.call(SearchHistoryRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SearchHistoryRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SearchHistoryRecord?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SearchHistoryRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SearchHistoryRecord>(
      id,
      columnValues: columnValues(SearchHistoryRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SearchHistoryRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SearchHistoryRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SearchHistoryRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<SearchHistoryRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SearchHistoryRecordTable>? orderBy,
    _is.OrderByListBuilder<SearchHistoryRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SearchHistoryRecord>(
      columnValues: columnValues(SearchHistoryRecord.t.updateTable),
      where: where(SearchHistoryRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SearchHistoryRecord.t),
      orderByList: orderByList?.call(SearchHistoryRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SearchHistoryRecord]s in the list and returns the deleted rows.
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
  Future<List<SearchHistoryRecord>> delete(
    _is.DatabaseSession session,
    List<SearchHistoryRecord> rows, {
    _is.OrderByBuilder<SearchHistoryRecordTable>? orderBy,
    _is.OrderByListBuilder<SearchHistoryRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SearchHistoryRecord>(
      rows,
      orderBy: orderBy?.call(SearchHistoryRecord.t),
      orderByList: orderByList?.call(SearchHistoryRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SearchHistoryRecord].
  Future<SearchHistoryRecord> deleteRow(
    _is.DatabaseSession session,
    SearchHistoryRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SearchHistoryRecord>(
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
  Future<List<SearchHistoryRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SearchHistoryRecordTable> where,
    _is.OrderByBuilder<SearchHistoryRecordTable>? orderBy,
    _is.OrderByListBuilder<SearchHistoryRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SearchHistoryRecord>(
      where: where(SearchHistoryRecord.t),
      orderBy: orderBy?.call(SearchHistoryRecord.t),
      orderByList: orderByList?.call(SearchHistoryRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SearchHistoryRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SearchHistoryRecord>(
      where: where?.call(SearchHistoryRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SearchHistoryRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SearchHistoryRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SearchHistoryRecord>(
      where: where(SearchHistoryRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class SearchHistoryRecordAttachRowRepository {
  const SearchHistoryRecordAttachRowRepository._();

  /// Creates a relation between the given [SearchHistoryRecord] and [AuthUser]
  /// by setting the [SearchHistoryRecord]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    SearchHistoryRecord searchHistoryRecord,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (searchHistoryRecord.id == null) {
      throw ArgumentError.notNull('searchHistoryRecord.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $searchHistoryRecord = searchHistoryRecord.copyWith(
      authUserId: authUser.id,
    );
    await session.db.updateRow<SearchHistoryRecord>(
      $searchHistoryRecord,
      columns: [SearchHistoryRecord.t.authUserId],
      transaction: transaction,
    );
  }
}
