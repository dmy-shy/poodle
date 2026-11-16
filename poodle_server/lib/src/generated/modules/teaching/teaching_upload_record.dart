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

abstract class TeachingUploadRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  TeachingUploadRecord._({
    this.id,
    required this.activityId,
    required this.ownerId,
    required this.fileName,
    required this.sizeBytes,
    required this.path,
    required this.createdAt,
  });

  factory TeachingUploadRecord({
    _is.UuidValue? id,
    required _is.UuidValue activityId,
    required _is.UuidValue ownerId,
    required String fileName,
    required int sizeBytes,
    required String path,
    required DateTime createdAt,
  }) = _TeachingUploadRecordImpl;

  factory TeachingUploadRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeachingUploadRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      activityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['activityId'],
      ),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      fileName: jsonSerialization['fileName'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      path: jsonSerialization['path'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = TeachingUploadRecordTable();

  static const db = TeachingUploadRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue activityId;

  _is.UuidValue ownerId;

  String fileName;

  int sizeBytes;

  String path;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [TeachingUploadRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeachingUploadRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? activityId,
    _is.UuidValue? ownerId,
    String? fileName,
    int? sizeBytes,
    String? path,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingUploadRecord',
      if (id != null) 'id': id?.toJson(),
      'activityId': activityId.toJson(),
      'ownerId': ownerId.toJson(),
      'fileName': fileName,
      'sizeBytes': sizeBytes,
      'path': path,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static TeachingUploadRecordInclude include() {
    return TeachingUploadRecordInclude._();
  }

  static TeachingUploadRecordIncludeList includeList({
    _is.WhereExpressionBuilder<TeachingUploadRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingUploadRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingUploadRecordTable>? orderByList,
    TeachingUploadRecordInclude? include,
  }) {
    return TeachingUploadRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeachingUploadRecord.t),
      orderByList: orderByList?.call(TeachingUploadRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeachingUploadRecordImpl extends TeachingUploadRecord {
  _TeachingUploadRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue activityId,
    required _is.UuidValue ownerId,
    required String fileName,
    required int sizeBytes,
    required String path,
    required DateTime createdAt,
  }) : super._(
         id: id,
         activityId: activityId,
         ownerId: ownerId,
         fileName: fileName,
         sizeBytes: sizeBytes,
         path: path,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TeachingUploadRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeachingUploadRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? activityId,
    _is.UuidValue? ownerId,
    String? fileName,
    int? sizeBytes,
    String? path,
    DateTime? createdAt,
  }) {
    return TeachingUploadRecord(
      id: id is _is.UuidValue? ? id : this.id,
      activityId: activityId ?? this.activityId,
      ownerId: ownerId ?? this.ownerId,
      fileName: fileName ?? this.fileName,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TeachingUploadRecordUpdateTable
    extends _is.UpdateTable<TeachingUploadRecordTable> {
  TeachingUploadRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> activityId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.activityId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<String, String> fileName(String value) => _is.ColumnValue(
    table.fileName,
    value,
  );

  _is.ColumnValue<int, int> sizeBytes(int value) => _is.ColumnValue(
    table.sizeBytes,
    value,
  );

  _is.ColumnValue<String, String> path(String value) => _is.ColumnValue(
    table.path,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class TeachingUploadRecordTable extends _is.Table<_is.UuidValue?> {
  TeachingUploadRecordTable({super.tableRelation})
    : super(tableName: 'poodle_teaching_upload') {
    updateTable = TeachingUploadRecordUpdateTable(this);
    activityId = _is.ColumnUuid(
      'activityId',
      this,
    );
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    fileName = _is.ColumnString(
      'fileName',
      this,
    );
    sizeBytes = _is.ColumnInt(
      'sizeBytes',
      this,
    );
    path = _is.ColumnString(
      'path',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final TeachingUploadRecordUpdateTable updateTable;

  late final _is.ColumnUuid activityId;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnString fileName;

  late final _is.ColumnInt sizeBytes;

  late final _is.ColumnString path;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    activityId,
    ownerId,
    fileName,
    sizeBytes,
    path,
    createdAt,
  ];
}

class TeachingUploadRecordInclude extends _is.IncludeObject {
  TeachingUploadRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => TeachingUploadRecord.t;
}

class TeachingUploadRecordIncludeList extends _is.IncludeList {
  TeachingUploadRecordIncludeList._({
    _is.WhereExpressionBuilder<TeachingUploadRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TeachingUploadRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => TeachingUploadRecord.t;
}

class TeachingUploadRecordRepository {
  const TeachingUploadRecordRepository._();

  /// Returns a list of [TeachingUploadRecord]s matching the given query parameters.
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
  Future<List<TeachingUploadRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingUploadRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingUploadRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingUploadRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TeachingUploadRecord>(
      where: where?.call(TeachingUploadRecord.t),
      orderBy: orderBy?.call(TeachingUploadRecord.t),
      orderByList: orderByList?.call(TeachingUploadRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TeachingUploadRecord] matching the given query parameters.
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
  Future<TeachingUploadRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingUploadRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<TeachingUploadRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingUploadRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TeachingUploadRecord>(
      where: where?.call(TeachingUploadRecord.t),
      orderBy: orderBy?.call(TeachingUploadRecord.t),
      orderByList: orderByList?.call(TeachingUploadRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TeachingUploadRecord] by its [id] or null if no such row exists.
  Future<TeachingUploadRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TeachingUploadRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TeachingUploadRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [TeachingUploadRecord]s will have their `id` fields set.
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
  Future<List<TeachingUploadRecord>> insert(
    _is.DatabaseSession session,
    List<TeachingUploadRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TeachingUploadRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TeachingUploadRecord] and returns the inserted row.
  ///
  /// The returned [TeachingUploadRecord] will have its `id` field set.
  Future<TeachingUploadRecord> insertRow(
    _is.DatabaseSession session,
    TeachingUploadRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TeachingUploadRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TeachingUploadRecord]s in the list and returns the resulting rows.
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
  /// The returned [TeachingUploadRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingUploadRecord>> upsert(
    _is.DatabaseSession session,
    List<TeachingUploadRecord> rows, {
    required _is.ColumnSelections<TeachingUploadRecordTable> conflictColumns,
    _is.ColumnSelections<TeachingUploadRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeachingUploadRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TeachingUploadRecord>(
      rows,
      conflictColumns: conflictColumns(TeachingUploadRecord.t),
      updateColumns: updateColumns?.call(TeachingUploadRecord.t),
      updateWhere: updateWhere?.call(TeachingUploadRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TeachingUploadRecord] and returns the resulting row.
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
  /// The returned [TeachingUploadRecord] will have its `id` field set.
  Future<TeachingUploadRecord?> upsertRow(
    _is.DatabaseSession session,
    TeachingUploadRecord row, {
    required _is.ColumnSelections<TeachingUploadRecordTable> conflictColumns,
    _is.ColumnSelections<TeachingUploadRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeachingUploadRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TeachingUploadRecord>(
      row,
      conflictColumns: conflictColumns(TeachingUploadRecord.t),
      updateColumns: updateColumns?.call(TeachingUploadRecord.t),
      updateWhere: updateWhere?.call(TeachingUploadRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [TeachingUploadRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingUploadRecord>> update(
    _is.DatabaseSession session,
    List<TeachingUploadRecord> rows, {
    _is.ColumnSelections<TeachingUploadRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TeachingUploadRecord>(
      rows,
      columns: columns?.call(TeachingUploadRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TeachingUploadRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TeachingUploadRecord> updateRow(
    _is.DatabaseSession session,
    TeachingUploadRecord row, {
    _is.ColumnSelections<TeachingUploadRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TeachingUploadRecord>(
      row,
      columns: columns?.call(TeachingUploadRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TeachingUploadRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TeachingUploadRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TeachingUploadRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TeachingUploadRecord>(
      id,
      columnValues: columnValues(TeachingUploadRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TeachingUploadRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingUploadRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TeachingUploadRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TeachingUploadRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingUploadRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingUploadRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TeachingUploadRecord>(
      columnValues: columnValues(TeachingUploadRecord.t.updateTable),
      where: where(TeachingUploadRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeachingUploadRecord.t),
      orderByList: orderByList?.call(TeachingUploadRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TeachingUploadRecord]s in the list and returns the deleted rows.
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
  Future<List<TeachingUploadRecord>> delete(
    _is.DatabaseSession session,
    List<TeachingUploadRecord> rows, {
    _is.OrderByBuilder<TeachingUploadRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingUploadRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TeachingUploadRecord>(
      rows,
      orderBy: orderBy?.call(TeachingUploadRecord.t),
      orderByList: orderByList?.call(TeachingUploadRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TeachingUploadRecord].
  Future<TeachingUploadRecord> deleteRow(
    _is.DatabaseSession session,
    TeachingUploadRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TeachingUploadRecord>(
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
  Future<List<TeachingUploadRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeachingUploadRecordTable> where,
    _is.OrderByBuilder<TeachingUploadRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingUploadRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TeachingUploadRecord>(
      where: where(TeachingUploadRecord.t),
      orderBy: orderBy?.call(TeachingUploadRecord.t),
      orderByList: orderByList?.call(TeachingUploadRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingUploadRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TeachingUploadRecord>(
      where: where?.call(TeachingUploadRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TeachingUploadRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeachingUploadRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TeachingUploadRecord>(
      where: where(TeachingUploadRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
