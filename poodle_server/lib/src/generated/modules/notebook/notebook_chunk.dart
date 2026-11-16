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

abstract class NotebookChunkRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookChunkRecord._({
    this.id,
    required this.sourceId,
    required this.sourceVersionId,
    required this.blockId,
    this.pageNumber,
    this.locationLabel,
    required this.content,
    required this.embedding,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory NotebookChunkRecord({
    _is.UuidValue? id,
    required _is.UuidValue sourceId,
    required _is.UuidValue sourceVersionId,
    required String blockId,
    int? pageNumber,
    String? locationLabel,
    required String content,
    required _is.Vector embedding,
    DateTime? createdAt,
  }) = _NotebookChunkRecordImpl;

  factory NotebookChunkRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotebookChunkRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      sourceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sourceId'],
      ),
      sourceVersionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sourceVersionId'],
      ),
      blockId: jsonSerialization['blockId'] as String,
      pageNumber: jsonSerialization['pageNumber'] as int?,
      locationLabel: jsonSerialization['locationLabel'] as String?,
      content: jsonSerialization['content'] as String,
      embedding: _is.VectorJsonExtension.fromJson(
        jsonSerialization['embedding'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = NotebookChunkRecordTable();

  static const db = NotebookChunkRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue sourceId;

  _is.UuidValue sourceVersionId;

  String blockId;

  int? pageNumber;

  String? locationLabel;

  String content;

  _is.Vector embedding;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookChunkRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookChunkRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? sourceId,
    _is.UuidValue? sourceVersionId,
    String? blockId,
    int? pageNumber,
    String? locationLabel,
    String? content,
    _is.Vector? embedding,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookChunkRecord',
      if (id != null) 'id': id?.toJson(),
      'sourceId': sourceId.toJson(),
      'sourceVersionId': sourceVersionId.toJson(),
      'blockId': blockId,
      if (pageNumber != null) 'pageNumber': pageNumber,
      if (locationLabel != null) 'locationLabel': locationLabel,
      'content': content,
      'embedding': embedding.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookChunkRecordInclude include() {
    return NotebookChunkRecordInclude._();
  }

  static NotebookChunkRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookChunkRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookChunkRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookChunkRecordTable>? orderByList,
    NotebookChunkRecordInclude? include,
  }) {
    return NotebookChunkRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookChunkRecord.t),
      orderByList: orderByList?.call(NotebookChunkRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookChunkRecordImpl extends NotebookChunkRecord {
  _NotebookChunkRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue sourceId,
    required _is.UuidValue sourceVersionId,
    required String blockId,
    int? pageNumber,
    String? locationLabel,
    required String content,
    required _is.Vector embedding,
    DateTime? createdAt,
  }) : super._(
         id: id,
         sourceId: sourceId,
         sourceVersionId: sourceVersionId,
         blockId: blockId,
         pageNumber: pageNumber,
         locationLabel: locationLabel,
         content: content,
         embedding: embedding,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotebookChunkRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookChunkRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? sourceId,
    _is.UuidValue? sourceVersionId,
    String? blockId,
    Object? pageNumber = _Undefined,
    Object? locationLabel = _Undefined,
    String? content,
    _is.Vector? embedding,
    DateTime? createdAt,
  }) {
    return NotebookChunkRecord(
      id: id is _is.UuidValue? ? id : this.id,
      sourceId: sourceId ?? this.sourceId,
      sourceVersionId: sourceVersionId ?? this.sourceVersionId,
      blockId: blockId ?? this.blockId,
      pageNumber: pageNumber is int? ? pageNumber : this.pageNumber,
      locationLabel: locationLabel is String?
          ? locationLabel
          : this.locationLabel,
      content: content ?? this.content,
      embedding: embedding ?? this.embedding.clone(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotebookChunkRecordUpdateTable
    extends _is.UpdateTable<NotebookChunkRecordTable> {
  NotebookChunkRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sourceId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.sourceId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sourceVersionId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.sourceVersionId,
    value,
  );

  _is.ColumnValue<String, String> blockId(String value) => _is.ColumnValue(
    table.blockId,
    value,
  );

  _is.ColumnValue<int, int> pageNumber(int? value) => _is.ColumnValue(
    table.pageNumber,
    value,
  );

  _is.ColumnValue<String, String> locationLabel(String? value) =>
      _is.ColumnValue(
        table.locationLabel,
        value,
      );

  _is.ColumnValue<String, String> content(String value) => _is.ColumnValue(
    table.content,
    value,
  );

  _is.ColumnValue<_is.Vector, _is.Vector> embedding(_is.Vector value) =>
      _is.ColumnValue(
        table.embedding,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class NotebookChunkRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookChunkRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook_chunk') {
    updateTable = NotebookChunkRecordUpdateTable(this);
    sourceId = _is.ColumnUuid(
      'sourceId',
      this,
    );
    sourceVersionId = _is.ColumnUuid(
      'sourceVersionId',
      this,
    );
    blockId = _is.ColumnString(
      'blockId',
      this,
    );
    pageNumber = _is.ColumnInt(
      'pageNumber',
      this,
    );
    locationLabel = _is.ColumnString(
      'locationLabel',
      this,
    );
    content = _is.ColumnString(
      'content',
      this,
    );
    embedding = _is.ColumnVector(
      'embedding',
      this,
      dimension: 1536,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final NotebookChunkRecordUpdateTable updateTable;

  late final _is.ColumnUuid sourceId;

  late final _is.ColumnUuid sourceVersionId;

  late final _is.ColumnString blockId;

  late final _is.ColumnInt pageNumber;

  late final _is.ColumnString locationLabel;

  late final _is.ColumnString content;

  late final _is.ColumnVector embedding;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    sourceId,
    sourceVersionId,
    blockId,
    pageNumber,
    locationLabel,
    content,
    embedding,
    createdAt,
  ];
}

class NotebookChunkRecordInclude extends _is.IncludeObject {
  NotebookChunkRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookChunkRecord.t;
}

class NotebookChunkRecordIncludeList extends _is.IncludeList {
  NotebookChunkRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookChunkRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookChunkRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookChunkRecord.t;
}

class NotebookChunkRecordRepository {
  const NotebookChunkRecordRepository._();

  /// Returns a list of [NotebookChunkRecord]s matching the given query parameters.
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
  Future<List<NotebookChunkRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookChunkRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookChunkRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookChunkRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookChunkRecord>(
      where: where?.call(NotebookChunkRecord.t),
      orderBy: orderBy?.call(NotebookChunkRecord.t),
      orderByList: orderByList?.call(NotebookChunkRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookChunkRecord] matching the given query parameters.
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
  Future<NotebookChunkRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookChunkRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookChunkRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookChunkRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookChunkRecord>(
      where: where?.call(NotebookChunkRecord.t),
      orderBy: orderBy?.call(NotebookChunkRecord.t),
      orderByList: orderByList?.call(NotebookChunkRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookChunkRecord] by its [id] or null if no such row exists.
  Future<NotebookChunkRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookChunkRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookChunkRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookChunkRecord]s will have their `id` fields set.
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
  Future<List<NotebookChunkRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookChunkRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookChunkRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookChunkRecord] and returns the inserted row.
  ///
  /// The returned [NotebookChunkRecord] will have its `id` field set.
  Future<NotebookChunkRecord> insertRow(
    _is.DatabaseSession session,
    NotebookChunkRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookChunkRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookChunkRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookChunkRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookChunkRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookChunkRecord> rows, {
    required _is.ColumnSelections<NotebookChunkRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookChunkRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookChunkRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookChunkRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookChunkRecord.t),
      updateColumns: updateColumns?.call(NotebookChunkRecord.t),
      updateWhere: updateWhere?.call(NotebookChunkRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookChunkRecord] and returns the resulting row.
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
  /// The returned [NotebookChunkRecord] will have its `id` field set.
  Future<NotebookChunkRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookChunkRecord row, {
    required _is.ColumnSelections<NotebookChunkRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookChunkRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookChunkRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookChunkRecord>(
      row,
      conflictColumns: conflictColumns(NotebookChunkRecord.t),
      updateColumns: updateColumns?.call(NotebookChunkRecord.t),
      updateWhere: updateWhere?.call(NotebookChunkRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookChunkRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookChunkRecord>> update(
    _is.DatabaseSession session,
    List<NotebookChunkRecord> rows, {
    _is.ColumnSelections<NotebookChunkRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookChunkRecord>(
      rows,
      columns: columns?.call(NotebookChunkRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookChunkRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookChunkRecord> updateRow(
    _is.DatabaseSession session,
    NotebookChunkRecord row, {
    _is.ColumnSelections<NotebookChunkRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookChunkRecord>(
      row,
      columns: columns?.call(NotebookChunkRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookChunkRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookChunkRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NotebookChunkRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookChunkRecord>(
      id,
      columnValues: columnValues(NotebookChunkRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookChunkRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookChunkRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotebookChunkRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NotebookChunkRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookChunkRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookChunkRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookChunkRecord>(
      columnValues: columnValues(NotebookChunkRecord.t.updateTable),
      where: where(NotebookChunkRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookChunkRecord.t),
      orderByList: orderByList?.call(NotebookChunkRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookChunkRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookChunkRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookChunkRecord> rows, {
    _is.OrderByBuilder<NotebookChunkRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookChunkRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookChunkRecord>(
      rows,
      orderBy: orderBy?.call(NotebookChunkRecord.t),
      orderByList: orderByList?.call(NotebookChunkRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookChunkRecord].
  Future<NotebookChunkRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookChunkRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookChunkRecord>(
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
  Future<List<NotebookChunkRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookChunkRecordTable> where,
    _is.OrderByBuilder<NotebookChunkRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookChunkRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookChunkRecord>(
      where: where(NotebookChunkRecord.t),
      orderBy: orderBy?.call(NotebookChunkRecord.t),
      orderByList: orderByList?.call(NotebookChunkRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookChunkRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookChunkRecord>(
      where: where?.call(NotebookChunkRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookChunkRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookChunkRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookChunkRecord>(
      where: where(NotebookChunkRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
