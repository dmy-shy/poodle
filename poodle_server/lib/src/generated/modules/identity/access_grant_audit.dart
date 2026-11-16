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

abstract class AccessGrantAudit
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AccessGrantAudit._({
    this.id,
    this.actorId,
    required this.subjectEmail,
    this.universityId,
    required this.action,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AccessGrantAudit({
    _is.UuidValue? id,
    _is.UuidValue? actorId,
    required String subjectEmail,
    _is.UuidValue? universityId,
    required String action,
    DateTime? createdAt,
  }) = _AccessGrantAuditImpl;

  factory AccessGrantAudit.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccessGrantAudit(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      actorId: jsonSerialization['actorId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['actorId']),
      subjectEmail: jsonSerialization['subjectEmail'] as String,
      universityId: jsonSerialization['universityId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['universityId'],
            ),
      action: jsonSerialization['action'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AccessGrantAuditTable();

  static const db = AccessGrantAuditRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue? actorId;

  String subjectEmail;

  _is.UuidValue? universityId;

  String action;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AccessGrantAudit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AccessGrantAudit copyWith({
    _is.UuidValue? id,
    _is.UuidValue? actorId,
    String? subjectEmail,
    _is.UuidValue? universityId,
    String? action,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccessGrantAudit',
      if (id != null) 'id': id?.toJson(),
      if (actorId != null) 'actorId': actorId?.toJson(),
      'subjectEmail': subjectEmail,
      if (universityId != null) 'universityId': universityId?.toJson(),
      'action': action,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AccessGrantAuditInclude include() {
    return AccessGrantAuditInclude._();
  }

  static AccessGrantAuditIncludeList includeList({
    _is.WhereExpressionBuilder<AccessGrantAuditTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessGrantAuditTable>? orderBy,
    _is.OrderByListBuilder<AccessGrantAuditTable>? orderByList,
    AccessGrantAuditInclude? include,
  }) {
    return AccessGrantAuditIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccessGrantAudit.t),
      orderByList: orderByList?.call(AccessGrantAudit.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccessGrantAuditImpl extends AccessGrantAudit {
  _AccessGrantAuditImpl({
    _is.UuidValue? id,
    _is.UuidValue? actorId,
    required String subjectEmail,
    _is.UuidValue? universityId,
    required String action,
    DateTime? createdAt,
  }) : super._(
         id: id,
         actorId: actorId,
         subjectEmail: subjectEmail,
         universityId: universityId,
         action: action,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AccessGrantAudit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AccessGrantAudit copyWith({
    Object? id = _Undefined,
    Object? actorId = _Undefined,
    String? subjectEmail,
    Object? universityId = _Undefined,
    String? action,
    DateTime? createdAt,
  }) {
    return AccessGrantAudit(
      id: id is _is.UuidValue? ? id : this.id,
      actorId: actorId is _is.UuidValue? ? actorId : this.actorId,
      subjectEmail: subjectEmail ?? this.subjectEmail,
      universityId: universityId is _is.UuidValue?
          ? universityId
          : this.universityId,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AccessGrantAuditUpdateTable
    extends _is.UpdateTable<AccessGrantAuditTable> {
  AccessGrantAuditUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> actorId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.actorId,
        value,
      );

  _is.ColumnValue<String, String> subjectEmail(String value) => _is.ColumnValue(
    table.subjectEmail,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> universityId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.universityId,
    value,
  );

  _is.ColumnValue<String, String> action(String value) => _is.ColumnValue(
    table.action,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AccessGrantAuditTable extends _is.Table<_is.UuidValue?> {
  AccessGrantAuditTable({super.tableRelation})
    : super(tableName: 'poodle_access_grant_audit') {
    updateTable = AccessGrantAuditUpdateTable(this);
    actorId = _is.ColumnUuid(
      'actorId',
      this,
    );
    subjectEmail = _is.ColumnString(
      'subjectEmail',
      this,
    );
    universityId = _is.ColumnUuid(
      'universityId',
      this,
    );
    action = _is.ColumnString(
      'action',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final AccessGrantAuditUpdateTable updateTable;

  late final _is.ColumnUuid actorId;

  late final _is.ColumnString subjectEmail;

  late final _is.ColumnUuid universityId;

  late final _is.ColumnString action;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    actorId,
    subjectEmail,
    universityId,
    action,
    createdAt,
  ];
}

class AccessGrantAuditInclude extends _is.IncludeObject {
  AccessGrantAuditInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => AccessGrantAudit.t;
}

class AccessGrantAuditIncludeList extends _is.IncludeList {
  AccessGrantAuditIncludeList._({
    _is.WhereExpressionBuilder<AccessGrantAuditTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccessGrantAudit.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AccessGrantAudit.t;
}

class AccessGrantAuditRepository {
  const AccessGrantAuditRepository._();

  /// Returns a list of [AccessGrantAudit]s matching the given query parameters.
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
  Future<List<AccessGrantAudit>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessGrantAuditTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessGrantAuditTable>? orderBy,
    _is.OrderByListBuilder<AccessGrantAuditTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccessGrantAudit>(
      where: where?.call(AccessGrantAudit.t),
      orderBy: orderBy?.call(AccessGrantAudit.t),
      orderByList: orderByList?.call(AccessGrantAudit.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccessGrantAudit] matching the given query parameters.
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
  Future<AccessGrantAudit?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessGrantAuditTable>? where,
    int? offset,
    _is.OrderByBuilder<AccessGrantAuditTable>? orderBy,
    _is.OrderByListBuilder<AccessGrantAuditTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccessGrantAudit>(
      where: where?.call(AccessGrantAudit.t),
      orderBy: orderBy?.call(AccessGrantAudit.t),
      orderByList: orderByList?.call(AccessGrantAudit.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccessGrantAudit] by its [id] or null if no such row exists.
  Future<AccessGrantAudit?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccessGrantAudit>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccessGrantAudit]s in the list and returns the inserted rows.
  ///
  /// The returned [AccessGrantAudit]s will have their `id` fields set.
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
  Future<List<AccessGrantAudit>> insert(
    _is.DatabaseSession session,
    List<AccessGrantAudit> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AccessGrantAudit>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AccessGrantAudit] and returns the inserted row.
  ///
  /// The returned [AccessGrantAudit] will have its `id` field set.
  Future<AccessGrantAudit> insertRow(
    _is.DatabaseSession session,
    AccessGrantAudit row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccessGrantAudit>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AccessGrantAudit]s in the list and returns the resulting rows.
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
  /// The returned [AccessGrantAudit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessGrantAudit>> upsert(
    _is.DatabaseSession session,
    List<AccessGrantAudit> rows, {
    required _is.ColumnSelections<AccessGrantAuditTable> conflictColumns,
    _is.ColumnSelections<AccessGrantAuditTable>? updateColumns,
    _is.WhereExpressionBuilder<AccessGrantAuditTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AccessGrantAudit>(
      rows,
      conflictColumns: conflictColumns(AccessGrantAudit.t),
      updateColumns: updateColumns?.call(AccessGrantAudit.t),
      updateWhere: updateWhere?.call(AccessGrantAudit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AccessGrantAudit] and returns the resulting row.
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
  /// The returned [AccessGrantAudit] will have its `id` field set.
  Future<AccessGrantAudit?> upsertRow(
    _is.DatabaseSession session,
    AccessGrantAudit row, {
    required _is.ColumnSelections<AccessGrantAuditTable> conflictColumns,
    _is.ColumnSelections<AccessGrantAuditTable>? updateColumns,
    _is.WhereExpressionBuilder<AccessGrantAuditTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AccessGrantAudit>(
      row,
      conflictColumns: conflictColumns(AccessGrantAudit.t),
      updateColumns: updateColumns?.call(AccessGrantAudit.t),
      updateWhere: updateWhere?.call(AccessGrantAudit.t),
      transaction: transaction,
    );
  }

  /// Updates all [AccessGrantAudit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessGrantAudit>> update(
    _is.DatabaseSession session,
    List<AccessGrantAudit> rows, {
    _is.ColumnSelections<AccessGrantAuditTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AccessGrantAudit>(
      rows,
      columns: columns?.call(AccessGrantAudit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AccessGrantAudit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccessGrantAudit> updateRow(
    _is.DatabaseSession session,
    AccessGrantAudit row, {
    _is.ColumnSelections<AccessGrantAuditTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccessGrantAudit>(
      row,
      columns: columns?.call(AccessGrantAudit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccessGrantAudit] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccessGrantAudit?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AccessGrantAuditUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AccessGrantAudit>(
      id,
      columnValues: columnValues(AccessGrantAudit.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccessGrantAudit]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessGrantAudit>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AccessGrantAuditUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AccessGrantAuditTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessGrantAuditTable>? orderBy,
    _is.OrderByListBuilder<AccessGrantAuditTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AccessGrantAudit>(
      columnValues: columnValues(AccessGrantAudit.t.updateTable),
      where: where(AccessGrantAudit.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccessGrantAudit.t),
      orderByList: orderByList?.call(AccessGrantAudit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AccessGrantAudit]s in the list and returns the deleted rows.
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
  Future<List<AccessGrantAudit>> delete(
    _is.DatabaseSession session,
    List<AccessGrantAudit> rows, {
    _is.OrderByBuilder<AccessGrantAuditTable>? orderBy,
    _is.OrderByListBuilder<AccessGrantAuditTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AccessGrantAudit>(
      rows,
      orderBy: orderBy?.call(AccessGrantAudit.t),
      orderByList: orderByList?.call(AccessGrantAudit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AccessGrantAudit].
  Future<AccessGrantAudit> deleteRow(
    _is.DatabaseSession session,
    AccessGrantAudit row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccessGrantAudit>(
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
  Future<List<AccessGrantAudit>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccessGrantAuditTable> where,
    _is.OrderByBuilder<AccessGrantAuditTable>? orderBy,
    _is.OrderByListBuilder<AccessGrantAuditTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AccessGrantAudit>(
      where: where(AccessGrantAudit.t),
      orderBy: orderBy?.call(AccessGrantAudit.t),
      orderByList: orderByList?.call(AccessGrantAudit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessGrantAuditTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AccessGrantAudit>(
      where: where?.call(AccessGrantAudit.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccessGrantAudit] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccessGrantAuditTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccessGrantAudit>(
      where: where(AccessGrantAudit.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
