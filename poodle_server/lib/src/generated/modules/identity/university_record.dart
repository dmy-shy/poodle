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

/// University boundary for institutional accounts and courses.
abstract class UniversityRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  UniversityRecord._({
    this.id,
    required this.name,
    required this.slug,
    bool? active,
  }) : active = active ?? true;

  factory UniversityRecord({
    _is.UuidValue? id,
    required String name,
    required String slug,
    bool? active,
  }) = _UniversityRecordImpl;

  factory UniversityRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return UniversityRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String,
      active: jsonSerialization['active'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['active']),
    );
  }

  static final t = UniversityRecordTable();

  static const db = UniversityRecordRepository._();

  @override
  _is.UuidValue? id;

  String name;

  String slug;

  bool active;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UniversityRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UniversityRecord copyWith({
    _is.UuidValue? id,
    String? name,
    String? slug,
    bool? active,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UniversityRecord',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'slug': slug,
      'active': active,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static UniversityRecordInclude include() {
    return UniversityRecordInclude._();
  }

  static UniversityRecordIncludeList includeList({
    _is.WhereExpressionBuilder<UniversityRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UniversityRecordTable>? orderBy,
    _is.OrderByListBuilder<UniversityRecordTable>? orderByList,
    UniversityRecordInclude? include,
  }) {
    return UniversityRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UniversityRecord.t),
      orderByList: orderByList?.call(UniversityRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UniversityRecordImpl extends UniversityRecord {
  _UniversityRecordImpl({
    _is.UuidValue? id,
    required String name,
    required String slug,
    bool? active,
  }) : super._(
         id: id,
         name: name,
         slug: slug,
         active: active,
       );

  /// Returns a shallow copy of this [UniversityRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UniversityRecord copyWith({
    Object? id = _Undefined,
    String? name,
    String? slug,
    bool? active,
  }) {
    return UniversityRecord(
      id: id is _is.UuidValue? ? id : this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      active: active ?? this.active,
    );
  }
}

class UniversityRecordUpdateTable
    extends _is.UpdateTable<UniversityRecordTable> {
  UniversityRecordUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> slug(String value) => _is.ColumnValue(
    table.slug,
    value,
  );

  _is.ColumnValue<bool, bool> active(bool value) => _is.ColumnValue(
    table.active,
    value,
  );
}

class UniversityRecordTable extends _is.Table<_is.UuidValue?> {
  UniversityRecordTable({super.tableRelation})
    : super(tableName: 'poodle_university') {
    updateTable = UniversityRecordUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    slug = _is.ColumnString(
      'slug',
      this,
    );
    active = _is.ColumnBool(
      'active',
      this,
      hasDefault: true,
    );
  }

  late final UniversityRecordUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString slug;

  late final _is.ColumnBool active;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    slug,
    active,
  ];
}

class UniversityRecordInclude extends _is.IncludeObject {
  UniversityRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => UniversityRecord.t;
}

class UniversityRecordIncludeList extends _is.IncludeList {
  UniversityRecordIncludeList._({
    _is.WhereExpressionBuilder<UniversityRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UniversityRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => UniversityRecord.t;
}

class UniversityRecordRepository {
  const UniversityRecordRepository._();

  /// Returns a list of [UniversityRecord]s matching the given query parameters.
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
  Future<List<UniversityRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UniversityRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UniversityRecordTable>? orderBy,
    _is.OrderByListBuilder<UniversityRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UniversityRecord>(
      where: where?.call(UniversityRecord.t),
      orderBy: orderBy?.call(UniversityRecord.t),
      orderByList: orderByList?.call(UniversityRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UniversityRecord] matching the given query parameters.
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
  Future<UniversityRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UniversityRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<UniversityRecordTable>? orderBy,
    _is.OrderByListBuilder<UniversityRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UniversityRecord>(
      where: where?.call(UniversityRecord.t),
      orderBy: orderBy?.call(UniversityRecord.t),
      orderByList: orderByList?.call(UniversityRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UniversityRecord] by its [id] or null if no such row exists.
  Future<UniversityRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UniversityRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UniversityRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [UniversityRecord]s will have their `id` fields set.
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
  Future<List<UniversityRecord>> insert(
    _is.DatabaseSession session,
    List<UniversityRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UniversityRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UniversityRecord] and returns the inserted row.
  ///
  /// The returned [UniversityRecord] will have its `id` field set.
  Future<UniversityRecord> insertRow(
    _is.DatabaseSession session,
    UniversityRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UniversityRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UniversityRecord]s in the list and returns the resulting rows.
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
  /// The returned [UniversityRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UniversityRecord>> upsert(
    _is.DatabaseSession session,
    List<UniversityRecord> rows, {
    required _is.ColumnSelections<UniversityRecordTable> conflictColumns,
    _is.ColumnSelections<UniversityRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<UniversityRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UniversityRecord>(
      rows,
      conflictColumns: conflictColumns(UniversityRecord.t),
      updateColumns: updateColumns?.call(UniversityRecord.t),
      updateWhere: updateWhere?.call(UniversityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UniversityRecord] and returns the resulting row.
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
  /// The returned [UniversityRecord] will have its `id` field set.
  Future<UniversityRecord?> upsertRow(
    _is.DatabaseSession session,
    UniversityRecord row, {
    required _is.ColumnSelections<UniversityRecordTable> conflictColumns,
    _is.ColumnSelections<UniversityRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<UniversityRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UniversityRecord>(
      row,
      conflictColumns: conflictColumns(UniversityRecord.t),
      updateColumns: updateColumns?.call(UniversityRecord.t),
      updateWhere: updateWhere?.call(UniversityRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [UniversityRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UniversityRecord>> update(
    _is.DatabaseSession session,
    List<UniversityRecord> rows, {
    _is.ColumnSelections<UniversityRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UniversityRecord>(
      rows,
      columns: columns?.call(UniversityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UniversityRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UniversityRecord> updateRow(
    _is.DatabaseSession session,
    UniversityRecord row, {
    _is.ColumnSelections<UniversityRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UniversityRecord>(
      row,
      columns: columns?.call(UniversityRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UniversityRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UniversityRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<UniversityRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UniversityRecord>(
      id,
      columnValues: columnValues(UniversityRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UniversityRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UniversityRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UniversityRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<UniversityRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UniversityRecordTable>? orderBy,
    _is.OrderByListBuilder<UniversityRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UniversityRecord>(
      columnValues: columnValues(UniversityRecord.t.updateTable),
      where: where(UniversityRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UniversityRecord.t),
      orderByList: orderByList?.call(UniversityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UniversityRecord]s in the list and returns the deleted rows.
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
  Future<List<UniversityRecord>> delete(
    _is.DatabaseSession session,
    List<UniversityRecord> rows, {
    _is.OrderByBuilder<UniversityRecordTable>? orderBy,
    _is.OrderByListBuilder<UniversityRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UniversityRecord>(
      rows,
      orderBy: orderBy?.call(UniversityRecord.t),
      orderByList: orderByList?.call(UniversityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UniversityRecord].
  Future<UniversityRecord> deleteRow(
    _is.DatabaseSession session,
    UniversityRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UniversityRecord>(
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
  Future<List<UniversityRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UniversityRecordTable> where,
    _is.OrderByBuilder<UniversityRecordTable>? orderBy,
    _is.OrderByListBuilder<UniversityRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UniversityRecord>(
      where: where(UniversityRecord.t),
      orderBy: orderBy?.call(UniversityRecord.t),
      orderByList: orderByList?.call(UniversityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UniversityRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UniversityRecord>(
      where: where?.call(UniversityRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UniversityRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UniversityRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UniversityRecord>(
      where: where(UniversityRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
