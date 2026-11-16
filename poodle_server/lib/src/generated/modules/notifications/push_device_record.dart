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

abstract class PushDeviceRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PushDeviceRecord._({
    this.id,
    required this.installationId,
    required this.registrationId,
    required this.ownerId,
    required this.platform,
    required this.token,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory PushDeviceRecord({
    _is.UuidValue? id,
    required _is.UuidValue installationId,
    required _is.UuidValue registrationId,
    required _is.UuidValue ownerId,
    required String platform,
    required String token,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PushDeviceRecordImpl;

  factory PushDeviceRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushDeviceRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      installationId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['installationId'],
      ),
      registrationId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['registrationId'],
      ),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      platform: jsonSerialization['platform'] as String,
      token: jsonSerialization['token'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = PushDeviceRecordTable();

  static const db = PushDeviceRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue installationId;

  _is.UuidValue registrationId;

  _is.UuidValue ownerId;

  String platform;

  String token;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PushDeviceRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PushDeviceRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? installationId,
    _is.UuidValue? registrationId,
    _is.UuidValue? ownerId,
    String? platform,
    String? token,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushDeviceRecord',
      if (id != null) 'id': id?.toJson(),
      'installationId': installationId.toJson(),
      'registrationId': registrationId.toJson(),
      'ownerId': ownerId.toJson(),
      'platform': platform,
      'token': token,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PushDeviceRecordInclude include() {
    return PushDeviceRecordInclude._();
  }

  static PushDeviceRecordIncludeList includeList({
    _is.WhereExpressionBuilder<PushDeviceRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeviceRecordTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceRecordTable>? orderByList,
    PushDeviceRecordInclude? include,
  }) {
    return PushDeviceRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushDeviceRecord.t),
      orderByList: orderByList?.call(PushDeviceRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushDeviceRecordImpl extends PushDeviceRecord {
  _PushDeviceRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue installationId,
    required _is.UuidValue registrationId,
    required _is.UuidValue ownerId,
    required String platform,
    required String token,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         installationId: installationId,
         registrationId: registrationId,
         ownerId: ownerId,
         platform: platform,
         token: token,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PushDeviceRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PushDeviceRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? installationId,
    _is.UuidValue? registrationId,
    _is.UuidValue? ownerId,
    String? platform,
    String? token,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PushDeviceRecord(
      id: id is _is.UuidValue? ? id : this.id,
      installationId: installationId ?? this.installationId,
      registrationId: registrationId ?? this.registrationId,
      ownerId: ownerId ?? this.ownerId,
      platform: platform ?? this.platform,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PushDeviceRecordUpdateTable
    extends _is.UpdateTable<PushDeviceRecordTable> {
  PushDeviceRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> installationId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.installationId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> registrationId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.registrationId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<String, String> platform(String value) => _is.ColumnValue(
    table.platform,
    value,
  );

  _is.ColumnValue<String, String> token(String value) => _is.ColumnValue(
    table.token,
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

class PushDeviceRecordTable extends _is.Table<_is.UuidValue?> {
  PushDeviceRecordTable({super.tableRelation})
    : super(tableName: 'poodle_push_device') {
    updateTable = PushDeviceRecordUpdateTable(this);
    installationId = _is.ColumnUuid(
      'installationId',
      this,
    );
    registrationId = _is.ColumnUuid(
      'registrationId',
      this,
    );
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    platform = _is.ColumnString(
      'platform',
      this,
    );
    token = _is.ColumnString(
      'token',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final PushDeviceRecordUpdateTable updateTable;

  late final _is.ColumnUuid installationId;

  late final _is.ColumnUuid registrationId;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnString platform;

  late final _is.ColumnString token;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    installationId,
    registrationId,
    ownerId,
    platform,
    token,
    createdAt,
    updatedAt,
  ];
}

class PushDeviceRecordInclude extends _is.IncludeObject {
  PushDeviceRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => PushDeviceRecord.t;
}

class PushDeviceRecordIncludeList extends _is.IncludeList {
  PushDeviceRecordIncludeList._({
    _is.WhereExpressionBuilder<PushDeviceRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PushDeviceRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PushDeviceRecord.t;
}

class PushDeviceRecordRepository {
  const PushDeviceRecordRepository._();

  /// Returns a list of [PushDeviceRecord]s matching the given query parameters.
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
  Future<List<PushDeviceRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeviceRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeviceRecordTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PushDeviceRecord>(
      where: where?.call(PushDeviceRecord.t),
      orderBy: orderBy?.call(PushDeviceRecord.t),
      orderByList: orderByList?.call(PushDeviceRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PushDeviceRecord] matching the given query parameters.
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
  Future<PushDeviceRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeviceRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<PushDeviceRecordTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PushDeviceRecord>(
      where: where?.call(PushDeviceRecord.t),
      orderBy: orderBy?.call(PushDeviceRecord.t),
      orderByList: orderByList?.call(PushDeviceRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PushDeviceRecord] by its [id] or null if no such row exists.
  Future<PushDeviceRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PushDeviceRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PushDeviceRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [PushDeviceRecord]s will have their `id` fields set.
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
  Future<List<PushDeviceRecord>> insert(
    _is.DatabaseSession session,
    List<PushDeviceRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PushDeviceRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PushDeviceRecord] and returns the inserted row.
  ///
  /// The returned [PushDeviceRecord] will have its `id` field set.
  Future<PushDeviceRecord> insertRow(
    _is.DatabaseSession session,
    PushDeviceRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PushDeviceRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PushDeviceRecord]s in the list and returns the resulting rows.
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
  /// The returned [PushDeviceRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDeviceRecord>> upsert(
    _is.DatabaseSession session,
    List<PushDeviceRecord> rows, {
    required _is.ColumnSelections<PushDeviceRecordTable> conflictColumns,
    _is.ColumnSelections<PushDeviceRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<PushDeviceRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PushDeviceRecord>(
      rows,
      conflictColumns: conflictColumns(PushDeviceRecord.t),
      updateColumns: updateColumns?.call(PushDeviceRecord.t),
      updateWhere: updateWhere?.call(PushDeviceRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PushDeviceRecord] and returns the resulting row.
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
  /// The returned [PushDeviceRecord] will have its `id` field set.
  Future<PushDeviceRecord?> upsertRow(
    _is.DatabaseSession session,
    PushDeviceRecord row, {
    required _is.ColumnSelections<PushDeviceRecordTable> conflictColumns,
    _is.ColumnSelections<PushDeviceRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<PushDeviceRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PushDeviceRecord>(
      row,
      conflictColumns: conflictColumns(PushDeviceRecord.t),
      updateColumns: updateColumns?.call(PushDeviceRecord.t),
      updateWhere: updateWhere?.call(PushDeviceRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [PushDeviceRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDeviceRecord>> update(
    _is.DatabaseSession session,
    List<PushDeviceRecord> rows, {
    _is.ColumnSelections<PushDeviceRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PushDeviceRecord>(
      rows,
      columns: columns?.call(PushDeviceRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PushDeviceRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PushDeviceRecord> updateRow(
    _is.DatabaseSession session,
    PushDeviceRecord row, {
    _is.ColumnSelections<PushDeviceRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PushDeviceRecord>(
      row,
      columns: columns?.call(PushDeviceRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PushDeviceRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PushDeviceRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PushDeviceRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PushDeviceRecord>(
      id,
      columnValues: columnValues(PushDeviceRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PushDeviceRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDeviceRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PushDeviceRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<PushDeviceRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeviceRecordTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PushDeviceRecord>(
      columnValues: columnValues(PushDeviceRecord.t.updateTable),
      where: where(PushDeviceRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushDeviceRecord.t),
      orderByList: orderByList?.call(PushDeviceRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PushDeviceRecord]s in the list and returns the deleted rows.
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
  Future<List<PushDeviceRecord>> delete(
    _is.DatabaseSession session,
    List<PushDeviceRecord> rows, {
    _is.OrderByBuilder<PushDeviceRecordTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PushDeviceRecord>(
      rows,
      orderBy: orderBy?.call(PushDeviceRecord.t),
      orderByList: orderByList?.call(PushDeviceRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PushDeviceRecord].
  Future<PushDeviceRecord> deleteRow(
    _is.DatabaseSession session,
    PushDeviceRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PushDeviceRecord>(
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
  Future<List<PushDeviceRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushDeviceRecordTable> where,
    _is.OrderByBuilder<PushDeviceRecordTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PushDeviceRecord>(
      where: where(PushDeviceRecord.t),
      orderBy: orderBy?.call(PushDeviceRecord.t),
      orderByList: orderByList?.call(PushDeviceRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeviceRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PushDeviceRecord>(
      where: where?.call(PushDeviceRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PushDeviceRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushDeviceRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PushDeviceRecord>(
      where: where(PushDeviceRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
