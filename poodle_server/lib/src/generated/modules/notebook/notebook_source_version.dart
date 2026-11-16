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

abstract class NotebookSourceVersionRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookSourceVersionRecord._({
    this.id,
    required this.sourceId,
    required this.version,
    required this.checksum,
    required this.title,
    required this.extractedText,
    required this.status,
    String? embeddingSpace,
    DateTime? createdAt,
  }) : embeddingSpace = embeddingSpace ?? 'legacy-unidentified',
       createdAt = createdAt ?? DateTime.now();

  factory NotebookSourceVersionRecord({
    _is.UuidValue? id,
    required _is.UuidValue sourceId,
    required int version,
    required String checksum,
    required String title,
    required String extractedText,
    required String status,
    String? embeddingSpace,
    DateTime? createdAt,
  }) = _NotebookSourceVersionRecordImpl;

  factory NotebookSourceVersionRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookSourceVersionRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      sourceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sourceId'],
      ),
      version: jsonSerialization['version'] as int,
      checksum: jsonSerialization['checksum'] as String,
      title: jsonSerialization['title'] as String,
      extractedText: jsonSerialization['extractedText'] as String,
      status: jsonSerialization['status'] as String,
      embeddingSpace: jsonSerialization['embeddingSpace'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = NotebookSourceVersionRecordTable();

  static const db = NotebookSourceVersionRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue sourceId;

  int version;

  String checksum;

  String title;

  String extractedText;

  String status;

  String embeddingSpace;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookSourceVersionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookSourceVersionRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? sourceId,
    int? version,
    String? checksum,
    String? title,
    String? extractedText,
    String? status,
    String? embeddingSpace,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookSourceVersionRecord',
      if (id != null) 'id': id?.toJson(),
      'sourceId': sourceId.toJson(),
      'version': version,
      'checksum': checksum,
      'title': title,
      'extractedText': extractedText,
      'status': status,
      'embeddingSpace': embeddingSpace,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookSourceVersionRecordInclude include() {
    return NotebookSourceVersionRecordInclude._();
  }

  static NotebookSourceVersionRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookSourceVersionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookSourceVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceVersionRecordTable>? orderByList,
    NotebookSourceVersionRecordInclude? include,
  }) {
    return NotebookSourceVersionRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookSourceVersionRecord.t),
      orderByList: orderByList?.call(NotebookSourceVersionRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookSourceVersionRecordImpl extends NotebookSourceVersionRecord {
  _NotebookSourceVersionRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue sourceId,
    required int version,
    required String checksum,
    required String title,
    required String extractedText,
    required String status,
    String? embeddingSpace,
    DateTime? createdAt,
  }) : super._(
         id: id,
         sourceId: sourceId,
         version: version,
         checksum: checksum,
         title: title,
         extractedText: extractedText,
         status: status,
         embeddingSpace: embeddingSpace,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotebookSourceVersionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookSourceVersionRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? sourceId,
    int? version,
    String? checksum,
    String? title,
    String? extractedText,
    String? status,
    String? embeddingSpace,
    DateTime? createdAt,
  }) {
    return NotebookSourceVersionRecord(
      id: id is _is.UuidValue? ? id : this.id,
      sourceId: sourceId ?? this.sourceId,
      version: version ?? this.version,
      checksum: checksum ?? this.checksum,
      title: title ?? this.title,
      extractedText: extractedText ?? this.extractedText,
      status: status ?? this.status,
      embeddingSpace: embeddingSpace ?? this.embeddingSpace,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotebookSourceVersionRecordUpdateTable
    extends _is.UpdateTable<NotebookSourceVersionRecordTable> {
  NotebookSourceVersionRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sourceId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.sourceId,
        value,
      );

  _is.ColumnValue<int, int> version(int value) => _is.ColumnValue(
    table.version,
    value,
  );

  _is.ColumnValue<String, String> checksum(String value) => _is.ColumnValue(
    table.checksum,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> extractedText(String value) =>
      _is.ColumnValue(
        table.extractedText,
        value,
      );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> embeddingSpace(String value) =>
      _is.ColumnValue(
        table.embeddingSpace,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class NotebookSourceVersionRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookSourceVersionRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook_source_version') {
    updateTable = NotebookSourceVersionRecordUpdateTable(this);
    sourceId = _is.ColumnUuid(
      'sourceId',
      this,
    );
    version = _is.ColumnInt(
      'version',
      this,
    );
    checksum = _is.ColumnString(
      'checksum',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    extractedText = _is.ColumnString(
      'extractedText',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    embeddingSpace = _is.ColumnString(
      'embeddingSpace',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final NotebookSourceVersionRecordUpdateTable updateTable;

  late final _is.ColumnUuid sourceId;

  late final _is.ColumnInt version;

  late final _is.ColumnString checksum;

  late final _is.ColumnString title;

  late final _is.ColumnString extractedText;

  late final _is.ColumnString status;

  late final _is.ColumnString embeddingSpace;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    sourceId,
    version,
    checksum,
    title,
    extractedText,
    status,
    embeddingSpace,
    createdAt,
  ];
}

class NotebookSourceVersionRecordInclude extends _is.IncludeObject {
  NotebookSourceVersionRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookSourceVersionRecord.t;
}

class NotebookSourceVersionRecordIncludeList extends _is.IncludeList {
  NotebookSourceVersionRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookSourceVersionRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookSourceVersionRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookSourceVersionRecord.t;
}

class NotebookSourceVersionRecordRepository {
  const NotebookSourceVersionRecordRepository._();

  /// Returns a list of [NotebookSourceVersionRecord]s matching the given query parameters.
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
  Future<List<NotebookSourceVersionRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookSourceVersionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookSourceVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceVersionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookSourceVersionRecord>(
      where: where?.call(NotebookSourceVersionRecord.t),
      orderBy: orderBy?.call(NotebookSourceVersionRecord.t),
      orderByList: orderByList?.call(NotebookSourceVersionRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookSourceVersionRecord] matching the given query parameters.
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
  Future<NotebookSourceVersionRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookSourceVersionRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookSourceVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceVersionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookSourceVersionRecord>(
      where: where?.call(NotebookSourceVersionRecord.t),
      orderBy: orderBy?.call(NotebookSourceVersionRecord.t),
      orderByList: orderByList?.call(NotebookSourceVersionRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookSourceVersionRecord] by its [id] or null if no such row exists.
  Future<NotebookSourceVersionRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookSourceVersionRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookSourceVersionRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookSourceVersionRecord]s will have their `id` fields set.
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
  Future<List<NotebookSourceVersionRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookSourceVersionRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookSourceVersionRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookSourceVersionRecord] and returns the inserted row.
  ///
  /// The returned [NotebookSourceVersionRecord] will have its `id` field set.
  Future<NotebookSourceVersionRecord> insertRow(
    _is.DatabaseSession session,
    NotebookSourceVersionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookSourceVersionRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookSourceVersionRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookSourceVersionRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookSourceVersionRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookSourceVersionRecord> rows, {
    required _is.ColumnSelections<NotebookSourceVersionRecordTable>
    conflictColumns,
    _is.ColumnSelections<NotebookSourceVersionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookSourceVersionRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookSourceVersionRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookSourceVersionRecord.t),
      updateColumns: updateColumns?.call(NotebookSourceVersionRecord.t),
      updateWhere: updateWhere?.call(NotebookSourceVersionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookSourceVersionRecord] and returns the resulting row.
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
  /// The returned [NotebookSourceVersionRecord] will have its `id` field set.
  Future<NotebookSourceVersionRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookSourceVersionRecord row, {
    required _is.ColumnSelections<NotebookSourceVersionRecordTable>
    conflictColumns,
    _is.ColumnSelections<NotebookSourceVersionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookSourceVersionRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookSourceVersionRecord>(
      row,
      conflictColumns: conflictColumns(NotebookSourceVersionRecord.t),
      updateColumns: updateColumns?.call(NotebookSourceVersionRecord.t),
      updateWhere: updateWhere?.call(NotebookSourceVersionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookSourceVersionRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookSourceVersionRecord>> update(
    _is.DatabaseSession session,
    List<NotebookSourceVersionRecord> rows, {
    _is.ColumnSelections<NotebookSourceVersionRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookSourceVersionRecord>(
      rows,
      columns: columns?.call(NotebookSourceVersionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookSourceVersionRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookSourceVersionRecord> updateRow(
    _is.DatabaseSession session,
    NotebookSourceVersionRecord row, {
    _is.ColumnSelections<NotebookSourceVersionRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookSourceVersionRecord>(
      row,
      columns: columns?.call(NotebookSourceVersionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookSourceVersionRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookSourceVersionRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NotebookSourceVersionRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookSourceVersionRecord>(
      id,
      columnValues: columnValues(NotebookSourceVersionRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookSourceVersionRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookSourceVersionRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotebookSourceVersionRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NotebookSourceVersionRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookSourceVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceVersionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookSourceVersionRecord>(
      columnValues: columnValues(NotebookSourceVersionRecord.t.updateTable),
      where: where(NotebookSourceVersionRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookSourceVersionRecord.t),
      orderByList: orderByList?.call(NotebookSourceVersionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookSourceVersionRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookSourceVersionRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookSourceVersionRecord> rows, {
    _is.OrderByBuilder<NotebookSourceVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceVersionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookSourceVersionRecord>(
      rows,
      orderBy: orderBy?.call(NotebookSourceVersionRecord.t),
      orderByList: orderByList?.call(NotebookSourceVersionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookSourceVersionRecord].
  Future<NotebookSourceVersionRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookSourceVersionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookSourceVersionRecord>(
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
  Future<List<NotebookSourceVersionRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookSourceVersionRecordTable> where,
    _is.OrderByBuilder<NotebookSourceVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookSourceVersionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookSourceVersionRecord>(
      where: where(NotebookSourceVersionRecord.t),
      orderBy: orderBy?.call(NotebookSourceVersionRecord.t),
      orderByList: orderByList?.call(NotebookSourceVersionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookSourceVersionRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookSourceVersionRecord>(
      where: where?.call(NotebookSourceVersionRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookSourceVersionRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookSourceVersionRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookSourceVersionRecord>(
      where: where(NotebookSourceVersionRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
