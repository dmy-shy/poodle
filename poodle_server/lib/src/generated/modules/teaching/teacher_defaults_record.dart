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
import 'package:poodle_server/src/generated/protocol.dart' as _ikm1kaos;
import 'package:serverpod/serverpod.dart' as _is;
import '../../modules/teaching/teaching_settings.dart' as _i9l8jupr;

abstract class TeacherDefaultsRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  TeacherDefaultsRecord._({
    this.id,
    required this.ownerId,
    required this.settings,
  });

  factory TeacherDefaultsRecord({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _i9l8jupr.TeachingSettings settings,
  }) = _TeacherDefaultsRecordImpl;

  factory TeacherDefaultsRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeacherDefaultsRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      settings: _ikm1kaos.Protocol().deserialize<_i9l8jupr.TeachingSettings>(
        jsonSerialization['settings'],
      ),
    );
  }

  static final t = TeacherDefaultsRecordTable();

  static const db = TeacherDefaultsRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ownerId;

  _i9l8jupr.TeachingSettings settings;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [TeacherDefaultsRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeacherDefaultsRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ownerId,
    _i9l8jupr.TeachingSettings? settings,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeacherDefaultsRecord',
      if (id != null) 'id': id?.toJson(),
      'ownerId': ownerId.toJson(),
      'settings': settings.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static TeacherDefaultsRecordInclude include() {
    return TeacherDefaultsRecordInclude._();
  }

  static TeacherDefaultsRecordIncludeList includeList({
    _is.WhereExpressionBuilder<TeacherDefaultsRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeacherDefaultsRecordTable>? orderBy,
    _is.OrderByListBuilder<TeacherDefaultsRecordTable>? orderByList,
    TeacherDefaultsRecordInclude? include,
  }) {
    return TeacherDefaultsRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeacherDefaultsRecord.t),
      orderByList: orderByList?.call(TeacherDefaultsRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeacherDefaultsRecordImpl extends TeacherDefaultsRecord {
  _TeacherDefaultsRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue ownerId,
    required _i9l8jupr.TeachingSettings settings,
  }) : super._(
         id: id,
         ownerId: ownerId,
         settings: settings,
       );

  /// Returns a shallow copy of this [TeacherDefaultsRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeacherDefaultsRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ownerId,
    _i9l8jupr.TeachingSettings? settings,
  }) {
    return TeacherDefaultsRecord(
      id: id is _is.UuidValue? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      settings: settings ?? this.settings.copyWith(),
    );
  }
}

class TeacherDefaultsRecordUpdateTable
    extends _is.UpdateTable<TeacherDefaultsRecordTable> {
  TeacherDefaultsRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<_i9l8jupr.TeachingSettings, _i9l8jupr.TeachingSettings>
  settings(_i9l8jupr.TeachingSettings value) => _is.ColumnValue(
    table.settings,
    value,
  );
}

class TeacherDefaultsRecordTable extends _is.Table<_is.UuidValue?> {
  TeacherDefaultsRecordTable({super.tableRelation})
    : super(tableName: 'poodle_teacher_defaults') {
    updateTable = TeacherDefaultsRecordUpdateTable(this);
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    settings = _is.ColumnSerializable<_i9l8jupr.TeachingSettings>(
      'settings',
      this,
    );
  }

  late final TeacherDefaultsRecordUpdateTable updateTable;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnSerializable<_i9l8jupr.TeachingSettings> settings;

  @override
  List<_is.Column> get columns => [
    id,
    ownerId,
    settings,
  ];
}

class TeacherDefaultsRecordInclude extends _is.IncludeObject {
  TeacherDefaultsRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => TeacherDefaultsRecord.t;
}

class TeacherDefaultsRecordIncludeList extends _is.IncludeList {
  TeacherDefaultsRecordIncludeList._({
    _is.WhereExpressionBuilder<TeacherDefaultsRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TeacherDefaultsRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => TeacherDefaultsRecord.t;
}

class TeacherDefaultsRecordRepository {
  const TeacherDefaultsRecordRepository._();

  /// Returns a list of [TeacherDefaultsRecord]s matching the given query parameters.
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
  Future<List<TeacherDefaultsRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeacherDefaultsRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeacherDefaultsRecordTable>? orderBy,
    _is.OrderByListBuilder<TeacherDefaultsRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TeacherDefaultsRecord>(
      where: where?.call(TeacherDefaultsRecord.t),
      orderBy: orderBy?.call(TeacherDefaultsRecord.t),
      orderByList: orderByList?.call(TeacherDefaultsRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TeacherDefaultsRecord] matching the given query parameters.
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
  Future<TeacherDefaultsRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeacherDefaultsRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<TeacherDefaultsRecordTable>? orderBy,
    _is.OrderByListBuilder<TeacherDefaultsRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TeacherDefaultsRecord>(
      where: where?.call(TeacherDefaultsRecord.t),
      orderBy: orderBy?.call(TeacherDefaultsRecord.t),
      orderByList: orderByList?.call(TeacherDefaultsRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TeacherDefaultsRecord] by its [id] or null if no such row exists.
  Future<TeacherDefaultsRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TeacherDefaultsRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TeacherDefaultsRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [TeacherDefaultsRecord]s will have their `id` fields set.
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
  Future<List<TeacherDefaultsRecord>> insert(
    _is.DatabaseSession session,
    List<TeacherDefaultsRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TeacherDefaultsRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TeacherDefaultsRecord] and returns the inserted row.
  ///
  /// The returned [TeacherDefaultsRecord] will have its `id` field set.
  Future<TeacherDefaultsRecord> insertRow(
    _is.DatabaseSession session,
    TeacherDefaultsRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TeacherDefaultsRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TeacherDefaultsRecord]s in the list and returns the resulting rows.
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
  /// The returned [TeacherDefaultsRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeacherDefaultsRecord>> upsert(
    _is.DatabaseSession session,
    List<TeacherDefaultsRecord> rows, {
    required _is.ColumnSelections<TeacherDefaultsRecordTable> conflictColumns,
    _is.ColumnSelections<TeacherDefaultsRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeacherDefaultsRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TeacherDefaultsRecord>(
      rows,
      conflictColumns: conflictColumns(TeacherDefaultsRecord.t),
      updateColumns: updateColumns?.call(TeacherDefaultsRecord.t),
      updateWhere: updateWhere?.call(TeacherDefaultsRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TeacherDefaultsRecord] and returns the resulting row.
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
  /// The returned [TeacherDefaultsRecord] will have its `id` field set.
  Future<TeacherDefaultsRecord?> upsertRow(
    _is.DatabaseSession session,
    TeacherDefaultsRecord row, {
    required _is.ColumnSelections<TeacherDefaultsRecordTable> conflictColumns,
    _is.ColumnSelections<TeacherDefaultsRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeacherDefaultsRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TeacherDefaultsRecord>(
      row,
      conflictColumns: conflictColumns(TeacherDefaultsRecord.t),
      updateColumns: updateColumns?.call(TeacherDefaultsRecord.t),
      updateWhere: updateWhere?.call(TeacherDefaultsRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [TeacherDefaultsRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeacherDefaultsRecord>> update(
    _is.DatabaseSession session,
    List<TeacherDefaultsRecord> rows, {
    _is.ColumnSelections<TeacherDefaultsRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TeacherDefaultsRecord>(
      rows,
      columns: columns?.call(TeacherDefaultsRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TeacherDefaultsRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TeacherDefaultsRecord> updateRow(
    _is.DatabaseSession session,
    TeacherDefaultsRecord row, {
    _is.ColumnSelections<TeacherDefaultsRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TeacherDefaultsRecord>(
      row,
      columns: columns?.call(TeacherDefaultsRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TeacherDefaultsRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TeacherDefaultsRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TeacherDefaultsRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TeacherDefaultsRecord>(
      id,
      columnValues: columnValues(TeacherDefaultsRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TeacherDefaultsRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeacherDefaultsRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TeacherDefaultsRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TeacherDefaultsRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeacherDefaultsRecordTable>? orderBy,
    _is.OrderByListBuilder<TeacherDefaultsRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TeacherDefaultsRecord>(
      columnValues: columnValues(TeacherDefaultsRecord.t.updateTable),
      where: where(TeacherDefaultsRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeacherDefaultsRecord.t),
      orderByList: orderByList?.call(TeacherDefaultsRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TeacherDefaultsRecord]s in the list and returns the deleted rows.
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
  Future<List<TeacherDefaultsRecord>> delete(
    _is.DatabaseSession session,
    List<TeacherDefaultsRecord> rows, {
    _is.OrderByBuilder<TeacherDefaultsRecordTable>? orderBy,
    _is.OrderByListBuilder<TeacherDefaultsRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TeacherDefaultsRecord>(
      rows,
      orderBy: orderBy?.call(TeacherDefaultsRecord.t),
      orderByList: orderByList?.call(TeacherDefaultsRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TeacherDefaultsRecord].
  Future<TeacherDefaultsRecord> deleteRow(
    _is.DatabaseSession session,
    TeacherDefaultsRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TeacherDefaultsRecord>(
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
  Future<List<TeacherDefaultsRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeacherDefaultsRecordTable> where,
    _is.OrderByBuilder<TeacherDefaultsRecordTable>? orderBy,
    _is.OrderByListBuilder<TeacherDefaultsRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TeacherDefaultsRecord>(
      where: where(TeacherDefaultsRecord.t),
      orderBy: orderBy?.call(TeacherDefaultsRecord.t),
      orderByList: orderByList?.call(TeacherDefaultsRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeacherDefaultsRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TeacherDefaultsRecord>(
      where: where?.call(TeacherDefaultsRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TeacherDefaultsRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeacherDefaultsRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TeacherDefaultsRecord>(
      where: where(TeacherDefaultsRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
