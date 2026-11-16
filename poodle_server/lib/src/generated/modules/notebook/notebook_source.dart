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

abstract class NotebookSourceRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookSourceRecord._({
    this.id,
    required this.courseId,
    this.notebookId,
    this.ownerUserId,
    this.activityId,
    required this.fileName,
    required this.format,
    required this.storageId,
    required this.storagePath,
    String? status,
    int? currentVersion,
    this.failureCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? 'queued',
       currentVersion = currentVersion ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory NotebookSourceRecord({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    _is.UuidValue? notebookId,
    _is.UuidValue? ownerUserId,
    _is.UuidValue? activityId,
    required String fileName,
    required String format,
    required String storageId,
    required String storagePath,
    String? status,
    int? currentVersion,
    String? failureCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NotebookSourceRecordImpl;

  factory NotebookSourceRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookSourceRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      notebookId: jsonSerialization['notebookId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['notebookId'],
            ),
      ownerUserId: jsonSerialization['ownerUserId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['ownerUserId'],
            ),
      activityId: jsonSerialization['activityId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['activityId'],
            ),
      fileName: jsonSerialization['fileName'] as String,
      format: jsonSerialization['format'] as String,
      storageId: jsonSerialization['storageId'] as String,
      storagePath: jsonSerialization['storagePath'] as String,
      status: jsonSerialization['status'] as String?,
      currentVersion: jsonSerialization['currentVersion'] as int?,
      failureCode: jsonSerialization['failureCode'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = NotebookSourceRecordTable();

  static const db = NotebookSourceRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue courseId;

  _is.UuidValue? notebookId;

  _is.UuidValue? ownerUserId;

  _is.UuidValue? activityId;

  String fileName;

  String format;

  String storageId;

  String storagePath;

  String status;

  int currentVersion;

  String? failureCode;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookSourceRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookSourceRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? courseId,
    _is.UuidValue? notebookId,
    _is.UuidValue? ownerUserId,
    _is.UuidValue? activityId,
    String? fileName,
    String? format,
    String? storageId,
    String? storagePath,
    String? status,
    int? currentVersion,
    String? failureCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookSourceRecord',
      if (id != null) 'id': id?.toJson(),
      'courseId': courseId.toJson(),
      if (notebookId != null) 'notebookId': notebookId?.toJson(),
      if (ownerUserId != null) 'ownerUserId': ownerUserId?.toJson(),
      if (activityId != null) 'activityId': activityId?.toJson(),
      'fileName': fileName,
      'format': format,
      'storageId': storageId,
      'storagePath': storagePath,
      'status': status,
      'currentVersion': currentVersion,
      if (failureCode != null) 'failureCode': failureCode,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookSourceRecordInclude include() {
    return NotebookSourceRecordInclude._();
  }

  static NotebookSourceRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookSourceRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookSourceRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceRecordTable>? orderByList,
    NotebookSourceRecordInclude? include,
  }) {
    return NotebookSourceRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookSourceRecord.t),
      orderByList: orderByList?.call(NotebookSourceRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookSourceRecordImpl extends NotebookSourceRecord {
  _NotebookSourceRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    _is.UuidValue? notebookId,
    _is.UuidValue? ownerUserId,
    _is.UuidValue? activityId,
    required String fileName,
    required String format,
    required String storageId,
    required String storagePath,
    String? status,
    int? currentVersion,
    String? failureCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         courseId: courseId,
         notebookId: notebookId,
         ownerUserId: ownerUserId,
         activityId: activityId,
         fileName: fileName,
         format: format,
         storageId: storageId,
         storagePath: storagePath,
         status: status,
         currentVersion: currentVersion,
         failureCode: failureCode,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotebookSourceRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookSourceRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? courseId,
    Object? notebookId = _Undefined,
    Object? ownerUserId = _Undefined,
    Object? activityId = _Undefined,
    String? fileName,
    String? format,
    String? storageId,
    String? storagePath,
    String? status,
    int? currentVersion,
    Object? failureCode = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotebookSourceRecord(
      id: id is _is.UuidValue? ? id : this.id,
      courseId: courseId ?? this.courseId,
      notebookId: notebookId is _is.UuidValue? ? notebookId : this.notebookId,
      ownerUserId: ownerUserId is _is.UuidValue?
          ? ownerUserId
          : this.ownerUserId,
      activityId: activityId is _is.UuidValue? ? activityId : this.activityId,
      fileName: fileName ?? this.fileName,
      format: format ?? this.format,
      storageId: storageId ?? this.storageId,
      storagePath: storagePath ?? this.storagePath,
      status: status ?? this.status,
      currentVersion: currentVersion ?? this.currentVersion,
      failureCode: failureCode is String? ? failureCode : this.failureCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotebookSourceRecordUpdateTable
    extends _is.UpdateTable<NotebookSourceRecordTable> {
  NotebookSourceRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> courseId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.courseId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> notebookId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.notebookId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerUserId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.ownerUserId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> activityId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.activityId,
    value,
  );

  _is.ColumnValue<String, String> fileName(String value) => _is.ColumnValue(
    table.fileName,
    value,
  );

  _is.ColumnValue<String, String> format(String value) => _is.ColumnValue(
    table.format,
    value,
  );

  _is.ColumnValue<String, String> storageId(String value) => _is.ColumnValue(
    table.storageId,
    value,
  );

  _is.ColumnValue<String, String> storagePath(String value) => _is.ColumnValue(
    table.storagePath,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> currentVersion(int value) => _is.ColumnValue(
    table.currentVersion,
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

class NotebookSourceRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookSourceRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook_source') {
    updateTable = NotebookSourceRecordUpdateTable(this);
    courseId = _is.ColumnUuid(
      'courseId',
      this,
    );
    notebookId = _is.ColumnUuid(
      'notebookId',
      this,
    );
    ownerUserId = _is.ColumnUuid(
      'ownerUserId',
      this,
    );
    activityId = _is.ColumnUuid(
      'activityId',
      this,
    );
    fileName = _is.ColumnString(
      'fileName',
      this,
    );
    format = _is.ColumnString(
      'format',
      this,
    );
    storageId = _is.ColumnString(
      'storageId',
      this,
    );
    storagePath = _is.ColumnString(
      'storagePath',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    currentVersion = _is.ColumnInt(
      'currentVersion',
      this,
      hasDefault: true,
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

  late final NotebookSourceRecordUpdateTable updateTable;

  late final _is.ColumnUuid courseId;

  late final _is.ColumnUuid notebookId;

  late final _is.ColumnUuid ownerUserId;

  late final _is.ColumnUuid activityId;

  late final _is.ColumnString fileName;

  late final _is.ColumnString format;

  late final _is.ColumnString storageId;

  late final _is.ColumnString storagePath;

  late final _is.ColumnString status;

  late final _is.ColumnInt currentVersion;

  late final _is.ColumnString failureCode;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    courseId,
    notebookId,
    ownerUserId,
    activityId,
    fileName,
    format,
    storageId,
    storagePath,
    status,
    currentVersion,
    failureCode,
    createdAt,
    updatedAt,
  ];
}

class NotebookSourceRecordInclude extends _is.IncludeObject {
  NotebookSourceRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookSourceRecord.t;
}

class NotebookSourceRecordIncludeList extends _is.IncludeList {
  NotebookSourceRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookSourceRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookSourceRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookSourceRecord.t;
}

class NotebookSourceRecordRepository {
  const NotebookSourceRecordRepository._();

  /// Returns a list of [NotebookSourceRecord]s matching the given query parameters.
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
  Future<List<NotebookSourceRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookSourceRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookSourceRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookSourceRecord>(
      where: where?.call(NotebookSourceRecord.t),
      orderBy: orderBy?.call(NotebookSourceRecord.t),
      orderByList: orderByList?.call(NotebookSourceRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookSourceRecord] matching the given query parameters.
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
  Future<NotebookSourceRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookSourceRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookSourceRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookSourceRecord>(
      where: where?.call(NotebookSourceRecord.t),
      orderBy: orderBy?.call(NotebookSourceRecord.t),
      orderByList: orderByList?.call(NotebookSourceRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookSourceRecord] by its [id] or null if no such row exists.
  Future<NotebookSourceRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookSourceRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookSourceRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookSourceRecord]s will have their `id` fields set.
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
  Future<List<NotebookSourceRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookSourceRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookSourceRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookSourceRecord] and returns the inserted row.
  ///
  /// The returned [NotebookSourceRecord] will have its `id` field set.
  Future<NotebookSourceRecord> insertRow(
    _is.DatabaseSession session,
    NotebookSourceRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookSourceRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookSourceRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookSourceRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookSourceRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookSourceRecord> rows, {
    required _is.ColumnSelections<NotebookSourceRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookSourceRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookSourceRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookSourceRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookSourceRecord.t),
      updateColumns: updateColumns?.call(NotebookSourceRecord.t),
      updateWhere: updateWhere?.call(NotebookSourceRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookSourceRecord] and returns the resulting row.
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
  /// The returned [NotebookSourceRecord] will have its `id` field set.
  Future<NotebookSourceRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookSourceRecord row, {
    required _is.ColumnSelections<NotebookSourceRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookSourceRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookSourceRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookSourceRecord>(
      row,
      conflictColumns: conflictColumns(NotebookSourceRecord.t),
      updateColumns: updateColumns?.call(NotebookSourceRecord.t),
      updateWhere: updateWhere?.call(NotebookSourceRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookSourceRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookSourceRecord>> update(
    _is.DatabaseSession session,
    List<NotebookSourceRecord> rows, {
    _is.ColumnSelections<NotebookSourceRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookSourceRecord>(
      rows,
      columns: columns?.call(NotebookSourceRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookSourceRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookSourceRecord> updateRow(
    _is.DatabaseSession session,
    NotebookSourceRecord row, {
    _is.ColumnSelections<NotebookSourceRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookSourceRecord>(
      row,
      columns: columns?.call(NotebookSourceRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookSourceRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookSourceRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NotebookSourceRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookSourceRecord>(
      id,
      columnValues: columnValues(NotebookSourceRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookSourceRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookSourceRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotebookSourceRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NotebookSourceRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookSourceRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookSourceRecord>(
      columnValues: columnValues(NotebookSourceRecord.t.updateTable),
      where: where(NotebookSourceRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookSourceRecord.t),
      orderByList: orderByList?.call(NotebookSourceRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookSourceRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookSourceRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookSourceRecord> rows, {
    _is.OrderByBuilder<NotebookSourceRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookSourceRecord>(
      rows,
      orderBy: orderBy?.call(NotebookSourceRecord.t),
      orderByList: orderByList?.call(NotebookSourceRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookSourceRecord].
  Future<NotebookSourceRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookSourceRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookSourceRecord>(
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
  Future<List<NotebookSourceRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookSourceRecordTable> where,
    _is.OrderByBuilder<NotebookSourceRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookSourceRecord>(
      where: where(NotebookSourceRecord.t),
      orderBy: orderBy?.call(NotebookSourceRecord.t),
      orderByList: orderByList?.call(NotebookSourceRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookSourceRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookSourceRecord>(
      where: where?.call(NotebookSourceRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookSourceRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookSourceRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookSourceRecord>(
      where: where(NotebookSourceRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
