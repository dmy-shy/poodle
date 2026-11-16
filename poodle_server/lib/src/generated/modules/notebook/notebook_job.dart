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

abstract class NotebookJobRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookJobRecord._({
    this.id,
    required this.ownerUserId,
    this.notebookId,
    this.sourceId,
    required this.jobType,
    String? status,
    int? attempts,
    this.leaseToken,
    this.leaseExpiresAt,
    required this.requestKey,
    this.privatePayload,
    this.failureCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? 'queued',
       attempts = attempts ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory NotebookJobRecord({
    _is.UuidValue? id,
    required _is.UuidValue ownerUserId,
    _is.UuidValue? notebookId,
    _is.UuidValue? sourceId,
    required String jobType,
    String? status,
    int? attempts,
    String? leaseToken,
    DateTime? leaseExpiresAt,
    required String requestKey,
    String? privatePayload,
    String? failureCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NotebookJobRecordImpl;

  factory NotebookJobRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookJobRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerUserId'],
      ),
      notebookId: jsonSerialization['notebookId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['notebookId'],
            ),
      sourceId: jsonSerialization['sourceId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['sourceId']),
      jobType: jsonSerialization['jobType'] as String,
      status: jsonSerialization['status'] as String?,
      attempts: jsonSerialization['attempts'] as int?,
      leaseToken: jsonSerialization['leaseToken'] as String?,
      leaseExpiresAt: jsonSerialization['leaseExpiresAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['leaseExpiresAt'],
            ),
      requestKey: jsonSerialization['requestKey'] as String,
      privatePayload: jsonSerialization['privatePayload'] as String?,
      failureCode: jsonSerialization['failureCode'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = NotebookJobRecordTable();

  static const db = NotebookJobRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerUserId;

  _is.UuidValue? notebookId;

  _is.UuidValue? sourceId;

  String jobType;

  String status;

  int attempts;

  String? leaseToken;

  DateTime? leaseExpiresAt;

  String requestKey;

  String? privatePayload;

  String? failureCode;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookJobRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookJobRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerUserId,
    _is.UuidValue? notebookId,
    _is.UuidValue? sourceId,
    String? jobType,
    String? status,
    int? attempts,
    String? leaseToken,
    DateTime? leaseExpiresAt,
    String? requestKey,
    String? privatePayload,
    String? failureCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookJobRecord',
      if (id != null) 'id': id?.toJson(),
      'ownerUserId': ownerUserId.toJson(),
      if (notebookId != null) 'notebookId': notebookId?.toJson(),
      if (sourceId != null) 'sourceId': sourceId?.toJson(),
      'jobType': jobType,
      'status': status,
      'attempts': attempts,
      if (leaseToken != null) 'leaseToken': leaseToken,
      if (leaseExpiresAt != null) 'leaseExpiresAt': leaseExpiresAt?.toJson(),
      'requestKey': requestKey,
      if (privatePayload != null) 'privatePayload': privatePayload,
      if (failureCode != null) 'failureCode': failureCode,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookJobRecordInclude include() {
    return NotebookJobRecordInclude._();
  }

  static NotebookJobRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookJobRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookJobRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookJobRecordTable>? orderByList,
    NotebookJobRecordInclude? include,
  }) {
    return NotebookJobRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookJobRecord.t),
      orderByList: orderByList?.call(NotebookJobRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookJobRecordImpl extends NotebookJobRecord {
  _NotebookJobRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerUserId,
    _is.UuidValue? notebookId,
    _is.UuidValue? sourceId,
    required String jobType,
    String? status,
    int? attempts,
    String? leaseToken,
    DateTime? leaseExpiresAt,
    required String requestKey,
    String? privatePayload,
    String? failureCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         ownerUserId: ownerUserId,
         notebookId: notebookId,
         sourceId: sourceId,
         jobType: jobType,
         status: status,
         attempts: attempts,
         leaseToken: leaseToken,
         leaseExpiresAt: leaseExpiresAt,
         requestKey: requestKey,
         privatePayload: privatePayload,
         failureCode: failureCode,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotebookJobRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookJobRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerUserId,
    Object? notebookId = _Undefined,
    Object? sourceId = _Undefined,
    String? jobType,
    String? status,
    int? attempts,
    Object? leaseToken = _Undefined,
    Object? leaseExpiresAt = _Undefined,
    String? requestKey,
    Object? privatePayload = _Undefined,
    Object? failureCode = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotebookJobRecord(
      id: id is _is.UuidValue? ? id : this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      notebookId: notebookId is _is.UuidValue? ? notebookId : this.notebookId,
      sourceId: sourceId is _is.UuidValue? ? sourceId : this.sourceId,
      jobType: jobType ?? this.jobType,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      leaseToken: leaseToken is String? ? leaseToken : this.leaseToken,
      leaseExpiresAt: leaseExpiresAt is DateTime?
          ? leaseExpiresAt
          : this.leaseExpiresAt,
      requestKey: requestKey ?? this.requestKey,
      privatePayload: privatePayload is String?
          ? privatePayload
          : this.privatePayload,
      failureCode: failureCode is String? ? failureCode : this.failureCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotebookJobRecordUpdateTable
    extends _is.UpdateTable<NotebookJobRecordTable> {
  NotebookJobRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.ownerUserId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> notebookId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.notebookId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sourceId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.sourceId,
    value,
  );

  _is.ColumnValue<String, String> jobType(String value) => _is.ColumnValue(
    table.jobType,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> attempts(int value) => _is.ColumnValue(
    table.attempts,
    value,
  );

  _is.ColumnValue<String, String> leaseToken(String? value) => _is.ColumnValue(
    table.leaseToken,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> leaseExpiresAt(DateTime? value) =>
      _is.ColumnValue(
        table.leaseExpiresAt,
        value,
      );

  _is.ColumnValue<String, String> requestKey(String value) => _is.ColumnValue(
    table.requestKey,
    value,
  );

  _is.ColumnValue<String, String> privatePayload(String? value) =>
      _is.ColumnValue(
        table.privatePayload,
        value,
      );

  _is.ColumnValue<String, String> failureCode(String? value) => _is.ColumnValue(
    table.failureCode,
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

class NotebookJobRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookJobRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook_job') {
    updateTable = NotebookJobRecordUpdateTable(this);
    ownerUserId = _is.ColumnUuid(
      'ownerUserId',
      this,
    );
    notebookId = _is.ColumnUuid(
      'notebookId',
      this,
    );
    sourceId = _is.ColumnUuid(
      'sourceId',
      this,
    );
    jobType = _is.ColumnString(
      'jobType',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    attempts = _is.ColumnInt(
      'attempts',
      this,
      hasDefault: true,
    );
    leaseToken = _is.ColumnString(
      'leaseToken',
      this,
    );
    leaseExpiresAt = _is.ColumnDateTime(
      'leaseExpiresAt',
      this,
    );
    requestKey = _is.ColumnString(
      'requestKey',
      this,
    );
    privatePayload = _is.ColumnString(
      'privatePayload',
      this,
    );
    failureCode = _is.ColumnString(
      'failureCode',
      this,
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

  late final NotebookJobRecordUpdateTable updateTable;

  late final _is.ColumnUuid ownerUserId;

  late final _is.ColumnUuid notebookId;

  late final _is.ColumnUuid sourceId;

  late final _is.ColumnString jobType;

  late final _is.ColumnString status;

  late final _is.ColumnInt attempts;

  late final _is.ColumnString leaseToken;

  late final _is.ColumnDateTime leaseExpiresAt;

  late final _is.ColumnString requestKey;

  late final _is.ColumnString privatePayload;

  late final _is.ColumnString failureCode;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    ownerUserId,
    notebookId,
    sourceId,
    jobType,
    status,
    attempts,
    leaseToken,
    leaseExpiresAt,
    requestKey,
    privatePayload,
    failureCode,
    createdAt,
    updatedAt,
  ];
}

class NotebookJobRecordInclude extends _is.IncludeObject {
  NotebookJobRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookJobRecord.t;
}

class NotebookJobRecordIncludeList extends _is.IncludeList {
  NotebookJobRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookJobRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookJobRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookJobRecord.t;
}

class NotebookJobRecordRepository {
  const NotebookJobRecordRepository._();

  /// Returns a list of [NotebookJobRecord]s matching the given query parameters.
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
  Future<List<NotebookJobRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookJobRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookJobRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookJobRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookJobRecord>(
      where: where?.call(NotebookJobRecord.t),
      orderBy: orderBy?.call(NotebookJobRecord.t),
      orderByList: orderByList?.call(NotebookJobRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookJobRecord] matching the given query parameters.
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
  Future<NotebookJobRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookJobRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookJobRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookJobRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookJobRecord>(
      where: where?.call(NotebookJobRecord.t),
      orderBy: orderBy?.call(NotebookJobRecord.t),
      orderByList: orderByList?.call(NotebookJobRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookJobRecord] by its [id] or null if no such row exists.
  Future<NotebookJobRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookJobRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookJobRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookJobRecord]s will have their `id` fields set.
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
  Future<List<NotebookJobRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookJobRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookJobRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookJobRecord] and returns the inserted row.
  ///
  /// The returned [NotebookJobRecord] will have its `id` field set.
  Future<NotebookJobRecord> insertRow(
    _is.DatabaseSession session,
    NotebookJobRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookJobRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookJobRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookJobRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookJobRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookJobRecord> rows, {
    required _is.ColumnSelections<NotebookJobRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookJobRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookJobRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookJobRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookJobRecord.t),
      updateColumns: updateColumns?.call(NotebookJobRecord.t),
      updateWhere: updateWhere?.call(NotebookJobRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookJobRecord] and returns the resulting row.
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
  /// The returned [NotebookJobRecord] will have its `id` field set.
  Future<NotebookJobRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookJobRecord row, {
    required _is.ColumnSelections<NotebookJobRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookJobRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookJobRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookJobRecord>(
      row,
      conflictColumns: conflictColumns(NotebookJobRecord.t),
      updateColumns: updateColumns?.call(NotebookJobRecord.t),
      updateWhere: updateWhere?.call(NotebookJobRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookJobRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookJobRecord>> update(
    _is.DatabaseSession session,
    List<NotebookJobRecord> rows, {
    _is.ColumnSelections<NotebookJobRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookJobRecord>(
      rows,
      columns: columns?.call(NotebookJobRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookJobRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookJobRecord> updateRow(
    _is.DatabaseSession session,
    NotebookJobRecord row, {
    _is.ColumnSelections<NotebookJobRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookJobRecord>(
      row,
      columns: columns?.call(NotebookJobRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookJobRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookJobRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NotebookJobRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookJobRecord>(
      id,
      columnValues: columnValues(NotebookJobRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookJobRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookJobRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotebookJobRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NotebookJobRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookJobRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookJobRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookJobRecord>(
      columnValues: columnValues(NotebookJobRecord.t.updateTable),
      where: where(NotebookJobRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookJobRecord.t),
      orderByList: orderByList?.call(NotebookJobRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookJobRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookJobRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookJobRecord> rows, {
    _is.OrderByBuilder<NotebookJobRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookJobRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookJobRecord>(
      rows,
      orderBy: orderBy?.call(NotebookJobRecord.t),
      orderByList: orderByList?.call(NotebookJobRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookJobRecord].
  Future<NotebookJobRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookJobRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookJobRecord>(
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
  Future<List<NotebookJobRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookJobRecordTable> where,
    _is.OrderByBuilder<NotebookJobRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookJobRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookJobRecord>(
      where: where(NotebookJobRecord.t),
      orderBy: orderBy?.call(NotebookJobRecord.t),
      orderByList: orderByList?.call(NotebookJobRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookJobRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookJobRecord>(
      where: where?.call(NotebookJobRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookJobRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookJobRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookJobRecord>(
      where: where(NotebookJobRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
