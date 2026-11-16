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

abstract class NotebookAssessmentConfigRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookAssessmentConfigRecord._({
    this.id,
    required this.courseId,
    required this.assessmentActivityId,
    required this.teacherUserId,
    int? revision,
    required this.allowedFormats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : revision = revision ?? 1,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory NotebookAssessmentConfigRecord({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    required _is.UuidValue assessmentActivityId,
    required _is.UuidValue teacherUserId,
    int? revision,
    required List<String> allowedFormats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NotebookAssessmentConfigRecordImpl;

  factory NotebookAssessmentConfigRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookAssessmentConfigRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      assessmentActivityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['assessmentActivityId'],
      ),
      teacherUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['teacherUserId'],
      ),
      revision: jsonSerialization['revision'] as int?,
      allowedFormats: _ikm1kaos.Protocol().deserialize<List<String>>(
        jsonSerialization['allowedFormats'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = NotebookAssessmentConfigRecordTable();

  static const db = NotebookAssessmentConfigRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue courseId;

  _is.UuidValue assessmentActivityId;

  _is.UuidValue teacherUserId;

  int revision;

  List<String> allowedFormats;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookAssessmentConfigRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookAssessmentConfigRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? courseId,
    _is.UuidValue? assessmentActivityId,
    _is.UuidValue? teacherUserId,
    int? revision,
    List<String>? allowedFormats,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookAssessmentConfigRecord',
      if (id != null) 'id': id?.toJson(),
      'courseId': courseId.toJson(),
      'assessmentActivityId': assessmentActivityId.toJson(),
      'teacherUserId': teacherUserId.toJson(),
      'revision': revision,
      'allowedFormats': allowedFormats.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookAssessmentConfigRecordInclude include() {
    return NotebookAssessmentConfigRecordInclude._();
  }

  static NotebookAssessmentConfigRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookAssessmentConfigRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookAssessmentConfigRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentConfigRecordTable>? orderByList,
    NotebookAssessmentConfigRecordInclude? include,
  }) {
    return NotebookAssessmentConfigRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookAssessmentConfigRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentConfigRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookAssessmentConfigRecordImpl
    extends NotebookAssessmentConfigRecord {
  _NotebookAssessmentConfigRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    required _is.UuidValue assessmentActivityId,
    required _is.UuidValue teacherUserId,
    int? revision,
    required List<String> allowedFormats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         courseId: courseId,
         assessmentActivityId: assessmentActivityId,
         teacherUserId: teacherUserId,
         revision: revision,
         allowedFormats: allowedFormats,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotebookAssessmentConfigRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookAssessmentConfigRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? courseId,
    _is.UuidValue? assessmentActivityId,
    _is.UuidValue? teacherUserId,
    int? revision,
    List<String>? allowedFormats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotebookAssessmentConfigRecord(
      id: id is _is.UuidValue? ? id : this.id,
      courseId: courseId ?? this.courseId,
      assessmentActivityId: assessmentActivityId ?? this.assessmentActivityId,
      teacherUserId: teacherUserId ?? this.teacherUserId,
      revision: revision ?? this.revision,
      allowedFormats:
          allowedFormats ?? this.allowedFormats.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotebookAssessmentConfigRecordUpdateTable
    extends _is.UpdateTable<NotebookAssessmentConfigRecordTable> {
  NotebookAssessmentConfigRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> courseId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.courseId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> assessmentActivityId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.assessmentActivityId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> teacherUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.teacherUserId,
    value,
  );

  _is.ColumnValue<int, int> revision(int value) => _is.ColumnValue(
    table.revision,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> allowedFormats(
    List<String> value,
  ) => _is.ColumnValue(
    table.allowedFormats,
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

class NotebookAssessmentConfigRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookAssessmentConfigRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook_assessment_config') {
    updateTable = NotebookAssessmentConfigRecordUpdateTable(this);
    courseId = _is.ColumnUuid(
      'courseId',
      this,
    );
    assessmentActivityId = _is.ColumnUuid(
      'assessmentActivityId',
      this,
    );
    teacherUserId = _is.ColumnUuid(
      'teacherUserId',
      this,
    );
    revision = _is.ColumnInt(
      'revision',
      this,
      hasDefault: true,
    );
    allowedFormats = _is.ColumnSerializable<List<String>>(
      'allowedFormats',
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

  late final NotebookAssessmentConfigRecordUpdateTable updateTable;

  late final _is.ColumnUuid courseId;

  late final _is.ColumnUuid assessmentActivityId;

  late final _is.ColumnUuid teacherUserId;

  late final _is.ColumnInt revision;

  late final _is.ColumnSerializable<List<String>> allowedFormats;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    courseId,
    assessmentActivityId,
    teacherUserId,
    revision,
    allowedFormats,
    createdAt,
    updatedAt,
  ];
}

class NotebookAssessmentConfigRecordInclude extends _is.IncludeObject {
  NotebookAssessmentConfigRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookAssessmentConfigRecord.t;
}

class NotebookAssessmentConfigRecordIncludeList extends _is.IncludeList {
  NotebookAssessmentConfigRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookAssessmentConfigRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookAssessmentConfigRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookAssessmentConfigRecord.t;
}

class NotebookAssessmentConfigRecordRepository {
  const NotebookAssessmentConfigRecordRepository._();

  /// Returns a list of [NotebookAssessmentConfigRecord]s matching the given query parameters.
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
  Future<List<NotebookAssessmentConfigRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookAssessmentConfigRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookAssessmentConfigRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentConfigRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookAssessmentConfigRecord>(
      where: where?.call(NotebookAssessmentConfigRecord.t),
      orderBy: orderBy?.call(NotebookAssessmentConfigRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentConfigRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookAssessmentConfigRecord] matching the given query parameters.
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
  Future<NotebookAssessmentConfigRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookAssessmentConfigRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookAssessmentConfigRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentConfigRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookAssessmentConfigRecord>(
      where: where?.call(NotebookAssessmentConfigRecord.t),
      orderBy: orderBy?.call(NotebookAssessmentConfigRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentConfigRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookAssessmentConfigRecord] by its [id] or null if no such row exists.
  Future<NotebookAssessmentConfigRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookAssessmentConfigRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookAssessmentConfigRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookAssessmentConfigRecord]s will have their `id` fields set.
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
  Future<List<NotebookAssessmentConfigRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookAssessmentConfigRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookAssessmentConfigRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookAssessmentConfigRecord] and returns the inserted row.
  ///
  /// The returned [NotebookAssessmentConfigRecord] will have its `id` field set.
  Future<NotebookAssessmentConfigRecord> insertRow(
    _is.DatabaseSession session,
    NotebookAssessmentConfigRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookAssessmentConfigRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookAssessmentConfigRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookAssessmentConfigRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookAssessmentConfigRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookAssessmentConfigRecord> rows, {
    required _is.ColumnSelections<NotebookAssessmentConfigRecordTable>
    conflictColumns,
    _is.ColumnSelections<NotebookAssessmentConfigRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookAssessmentConfigRecordTable>?
    updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookAssessmentConfigRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookAssessmentConfigRecord.t),
      updateColumns: updateColumns?.call(NotebookAssessmentConfigRecord.t),
      updateWhere: updateWhere?.call(NotebookAssessmentConfigRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookAssessmentConfigRecord] and returns the resulting row.
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
  /// The returned [NotebookAssessmentConfigRecord] will have its `id` field set.
  Future<NotebookAssessmentConfigRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookAssessmentConfigRecord row, {
    required _is.ColumnSelections<NotebookAssessmentConfigRecordTable>
    conflictColumns,
    _is.ColumnSelections<NotebookAssessmentConfigRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookAssessmentConfigRecordTable>?
    updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookAssessmentConfigRecord>(
      row,
      conflictColumns: conflictColumns(NotebookAssessmentConfigRecord.t),
      updateColumns: updateColumns?.call(NotebookAssessmentConfigRecord.t),
      updateWhere: updateWhere?.call(NotebookAssessmentConfigRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookAssessmentConfigRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookAssessmentConfigRecord>> update(
    _is.DatabaseSession session,
    List<NotebookAssessmentConfigRecord> rows, {
    _is.ColumnSelections<NotebookAssessmentConfigRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookAssessmentConfigRecord>(
      rows,
      columns: columns?.call(NotebookAssessmentConfigRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookAssessmentConfigRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookAssessmentConfigRecord> updateRow(
    _is.DatabaseSession session,
    NotebookAssessmentConfigRecord row, {
    _is.ColumnSelections<NotebookAssessmentConfigRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookAssessmentConfigRecord>(
      row,
      columns: columns?.call(NotebookAssessmentConfigRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookAssessmentConfigRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookAssessmentConfigRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<
      NotebookAssessmentConfigRecordUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookAssessmentConfigRecord>(
      id,
      columnValues: columnValues(NotebookAssessmentConfigRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookAssessmentConfigRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookAssessmentConfigRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      NotebookAssessmentConfigRecordUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<NotebookAssessmentConfigRecordTable>
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookAssessmentConfigRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentConfigRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookAssessmentConfigRecord>(
      columnValues: columnValues(NotebookAssessmentConfigRecord.t.updateTable),
      where: where(NotebookAssessmentConfigRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookAssessmentConfigRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentConfigRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookAssessmentConfigRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookAssessmentConfigRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookAssessmentConfigRecord> rows, {
    _is.OrderByBuilder<NotebookAssessmentConfigRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentConfigRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookAssessmentConfigRecord>(
      rows,
      orderBy: orderBy?.call(NotebookAssessmentConfigRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentConfigRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookAssessmentConfigRecord].
  Future<NotebookAssessmentConfigRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookAssessmentConfigRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookAssessmentConfigRecord>(
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
  Future<List<NotebookAssessmentConfigRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookAssessmentConfigRecordTable>
    where,
    _is.OrderByBuilder<NotebookAssessmentConfigRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookAssessmentConfigRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookAssessmentConfigRecord>(
      where: where(NotebookAssessmentConfigRecord.t),
      orderBy: orderBy?.call(NotebookAssessmentConfigRecord.t),
      orderByList: orderByList?.call(NotebookAssessmentConfigRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookAssessmentConfigRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookAssessmentConfigRecord>(
      where: where?.call(NotebookAssessmentConfigRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookAssessmentConfigRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookAssessmentConfigRecordTable>
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookAssessmentConfigRecord>(
      where: where(NotebookAssessmentConfigRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
