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
import '../../modules/teaching/teaching_question.dart' as _i3iex35i;
import '../../modules/teaching/teaching_settings.dart' as _i9l8jupr;

abstract class TeachingVersionRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  TeachingVersionRecord._({
    this.id,
    required this.activityId,
    required this.revision,
    required this.settings,
    required this.questions,
  });

  factory TeachingVersionRecord({
    _is.UuidValue? id,
    required _is.UuidValue activityId,
    required int revision,
    required _i9l8jupr.TeachingSettings settings,
    required List<_i3iex35i.TeachingQuestion> questions,
  }) = _TeachingVersionRecordImpl;

  factory TeachingVersionRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeachingVersionRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      activityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['activityId'],
      ),
      revision: jsonSerialization['revision'] as int,
      settings: _ikm1kaos.Protocol().deserialize<_i9l8jupr.TeachingSettings>(
        jsonSerialization['settings'],
      ),
      questions: _ikm1kaos.Protocol()
          .deserialize<List<_i3iex35i.TeachingQuestion>>(
            jsonSerialization['questions'],
          ),
    );
  }

  static final t = TeachingVersionRecordTable();

  static const db = TeachingVersionRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue activityId;

  int revision;

  _i9l8jupr.TeachingSettings settings;

  List<_i3iex35i.TeachingQuestion> questions;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [TeachingVersionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeachingVersionRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? activityId,
    int? revision,
    _i9l8jupr.TeachingSettings? settings,
    List<_i3iex35i.TeachingQuestion>? questions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingVersionRecord',
      if (id != null) 'id': id?.toJson(),
      'activityId': activityId.toJson(),
      'revision': revision,
      'settings': settings.toJson(),
      'questions': questions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static TeachingVersionRecordInclude include() {
    return TeachingVersionRecordInclude._();
  }

  static TeachingVersionRecordIncludeList includeList({
    _is.WhereExpressionBuilder<TeachingVersionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingVersionRecordTable>? orderByList,
    TeachingVersionRecordInclude? include,
  }) {
    return TeachingVersionRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeachingVersionRecord.t),
      orderByList: orderByList?.call(TeachingVersionRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeachingVersionRecordImpl extends TeachingVersionRecord {
  _TeachingVersionRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue activityId,
    required int revision,
    required _i9l8jupr.TeachingSettings settings,
    required List<_i3iex35i.TeachingQuestion> questions,
  }) : super._(
         id: id,
         activityId: activityId,
         revision: revision,
         settings: settings,
         questions: questions,
       );

  /// Returns a shallow copy of this [TeachingVersionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeachingVersionRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? activityId,
    int? revision,
    _i9l8jupr.TeachingSettings? settings,
    List<_i3iex35i.TeachingQuestion>? questions,
  }) {
    return TeachingVersionRecord(
      id: id is _is.UuidValue? ? id : this.id,
      activityId: activityId ?? this.activityId,
      revision: revision ?? this.revision,
      settings: settings ?? this.settings.copyWith(),
      questions:
          questions ?? this.questions.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class TeachingVersionRecordUpdateTable
    extends _is.UpdateTable<TeachingVersionRecordTable> {
  TeachingVersionRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> activityId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.activityId,
    value,
  );

  _is.ColumnValue<int, int> revision(int value) => _is.ColumnValue(
    table.revision,
    value,
  );

  _is.ColumnValue<_i9l8jupr.TeachingSettings, _i9l8jupr.TeachingSettings>
  settings(_i9l8jupr.TeachingSettings value) => _is.ColumnValue(
    table.settings,
    value,
  );

  _is.ColumnValue<
    List<_i3iex35i.TeachingQuestion>,
    List<_i3iex35i.TeachingQuestion>
  >
  questions(List<_i3iex35i.TeachingQuestion> value) => _is.ColumnValue(
    table.questions,
    value,
  );
}

class TeachingVersionRecordTable extends _is.Table<_is.UuidValue?> {
  TeachingVersionRecordTable({super.tableRelation})
    : super(tableName: 'poodle_teaching_version') {
    updateTable = TeachingVersionRecordUpdateTable(this);
    activityId = _is.ColumnUuid(
      'activityId',
      this,
    );
    revision = _is.ColumnInt(
      'revision',
      this,
    );
    settings = _is.ColumnSerializable<_i9l8jupr.TeachingSettings>(
      'settings',
      this,
    );
    questions = _is.ColumnSerializable<List<_i3iex35i.TeachingQuestion>>(
      'questions',
      this,
    );
  }

  late final TeachingVersionRecordUpdateTable updateTable;

  late final _is.ColumnUuid activityId;

  late final _is.ColumnInt revision;

  late final _is.ColumnSerializable<_i9l8jupr.TeachingSettings> settings;

  late final _is.ColumnSerializable<List<_i3iex35i.TeachingQuestion>> questions;

  @override
  List<_is.Column> get columns => [
    id,
    activityId,
    revision,
    settings,
    questions,
  ];
}

class TeachingVersionRecordInclude extends _is.IncludeObject {
  TeachingVersionRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => TeachingVersionRecord.t;
}

class TeachingVersionRecordIncludeList extends _is.IncludeList {
  TeachingVersionRecordIncludeList._({
    _is.WhereExpressionBuilder<TeachingVersionRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TeachingVersionRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => TeachingVersionRecord.t;
}

class TeachingVersionRecordRepository {
  const TeachingVersionRecordRepository._();

  /// Returns a list of [TeachingVersionRecord]s matching the given query parameters.
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
  Future<List<TeachingVersionRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingVersionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingVersionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TeachingVersionRecord>(
      where: where?.call(TeachingVersionRecord.t),
      orderBy: orderBy?.call(TeachingVersionRecord.t),
      orderByList: orderByList?.call(TeachingVersionRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TeachingVersionRecord] matching the given query parameters.
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
  Future<TeachingVersionRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingVersionRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<TeachingVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingVersionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TeachingVersionRecord>(
      where: where?.call(TeachingVersionRecord.t),
      orderBy: orderBy?.call(TeachingVersionRecord.t),
      orderByList: orderByList?.call(TeachingVersionRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TeachingVersionRecord] by its [id] or null if no such row exists.
  Future<TeachingVersionRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TeachingVersionRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TeachingVersionRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [TeachingVersionRecord]s will have their `id` fields set.
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
  Future<List<TeachingVersionRecord>> insert(
    _is.DatabaseSession session,
    List<TeachingVersionRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TeachingVersionRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TeachingVersionRecord] and returns the inserted row.
  ///
  /// The returned [TeachingVersionRecord] will have its `id` field set.
  Future<TeachingVersionRecord> insertRow(
    _is.DatabaseSession session,
    TeachingVersionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TeachingVersionRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TeachingVersionRecord]s in the list and returns the resulting rows.
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
  /// The returned [TeachingVersionRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingVersionRecord>> upsert(
    _is.DatabaseSession session,
    List<TeachingVersionRecord> rows, {
    required _is.ColumnSelections<TeachingVersionRecordTable> conflictColumns,
    _is.ColumnSelections<TeachingVersionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeachingVersionRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TeachingVersionRecord>(
      rows,
      conflictColumns: conflictColumns(TeachingVersionRecord.t),
      updateColumns: updateColumns?.call(TeachingVersionRecord.t),
      updateWhere: updateWhere?.call(TeachingVersionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TeachingVersionRecord] and returns the resulting row.
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
  /// The returned [TeachingVersionRecord] will have its `id` field set.
  Future<TeachingVersionRecord?> upsertRow(
    _is.DatabaseSession session,
    TeachingVersionRecord row, {
    required _is.ColumnSelections<TeachingVersionRecordTable> conflictColumns,
    _is.ColumnSelections<TeachingVersionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeachingVersionRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TeachingVersionRecord>(
      row,
      conflictColumns: conflictColumns(TeachingVersionRecord.t),
      updateColumns: updateColumns?.call(TeachingVersionRecord.t),
      updateWhere: updateWhere?.call(TeachingVersionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [TeachingVersionRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingVersionRecord>> update(
    _is.DatabaseSession session,
    List<TeachingVersionRecord> rows, {
    _is.ColumnSelections<TeachingVersionRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TeachingVersionRecord>(
      rows,
      columns: columns?.call(TeachingVersionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TeachingVersionRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TeachingVersionRecord> updateRow(
    _is.DatabaseSession session,
    TeachingVersionRecord row, {
    _is.ColumnSelections<TeachingVersionRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TeachingVersionRecord>(
      row,
      columns: columns?.call(TeachingVersionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TeachingVersionRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TeachingVersionRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TeachingVersionRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TeachingVersionRecord>(
      id,
      columnValues: columnValues(TeachingVersionRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TeachingVersionRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingVersionRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TeachingVersionRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TeachingVersionRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingVersionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TeachingVersionRecord>(
      columnValues: columnValues(TeachingVersionRecord.t.updateTable),
      where: where(TeachingVersionRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeachingVersionRecord.t),
      orderByList: orderByList?.call(TeachingVersionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TeachingVersionRecord]s in the list and returns the deleted rows.
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
  Future<List<TeachingVersionRecord>> delete(
    _is.DatabaseSession session,
    List<TeachingVersionRecord> rows, {
    _is.OrderByBuilder<TeachingVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingVersionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TeachingVersionRecord>(
      rows,
      orderBy: orderBy?.call(TeachingVersionRecord.t),
      orderByList: orderByList?.call(TeachingVersionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TeachingVersionRecord].
  Future<TeachingVersionRecord> deleteRow(
    _is.DatabaseSession session,
    TeachingVersionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TeachingVersionRecord>(
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
  Future<List<TeachingVersionRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeachingVersionRecordTable> where,
    _is.OrderByBuilder<TeachingVersionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingVersionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TeachingVersionRecord>(
      where: where(TeachingVersionRecord.t),
      orderBy: orderBy?.call(TeachingVersionRecord.t),
      orderByList: orderByList?.call(TeachingVersionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingVersionRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TeachingVersionRecord>(
      where: where?.call(TeachingVersionRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TeachingVersionRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeachingVersionRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TeachingVersionRecord>(
      where: where(TeachingVersionRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
