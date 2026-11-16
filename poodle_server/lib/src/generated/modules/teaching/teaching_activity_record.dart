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

abstract class TeachingActivityRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  TeachingActivityRecord._({
    this.id,
    required this.courseId,
    required this.activityId,
    required this.kind,
    int? revision,
    bool? published,
    bool? released,
    required this.settings,
    required this.questions,
  }) : revision = revision ?? 1,
       published = published ?? false,
       released = released ?? false;

  factory TeachingActivityRecord({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    required _is.UuidValue activityId,
    required String kind,
    int? revision,
    bool? published,
    bool? released,
    required _i9l8jupr.TeachingSettings settings,
    required List<_i3iex35i.TeachingQuestion> questions,
  }) = _TeachingActivityRecordImpl;

  factory TeachingActivityRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeachingActivityRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      activityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['activityId'],
      ),
      kind: jsonSerialization['kind'] as String,
      revision: jsonSerialization['revision'] as int?,
      published: jsonSerialization['published'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['published']),
      released: jsonSerialization['released'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['released']),
      settings: _ikm1kaos.Protocol().deserialize<_i9l8jupr.TeachingSettings>(
        jsonSerialization['settings'],
      ),
      questions: _ikm1kaos.Protocol()
          .deserialize<List<_i3iex35i.TeachingQuestion>>(
            jsonSerialization['questions'],
          ),
    );
  }

  static final t = TeachingActivityRecordTable();

  static const db = TeachingActivityRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue courseId;

  _is.UuidValue activityId;

  String kind;

  int revision;

  bool published;

  bool released;

  _i9l8jupr.TeachingSettings settings;

  List<_i3iex35i.TeachingQuestion> questions;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [TeachingActivityRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeachingActivityRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? courseId,
    _is.UuidValue? activityId,
    String? kind,
    int? revision,
    bool? published,
    bool? released,
    _i9l8jupr.TeachingSettings? settings,
    List<_i3iex35i.TeachingQuestion>? questions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingActivityRecord',
      if (id != null) 'id': id?.toJson(),
      'courseId': courseId.toJson(),
      'activityId': activityId.toJson(),
      'kind': kind,
      'revision': revision,
      'published': published,
      'released': released,
      'settings': settings.toJson(),
      'questions': questions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static TeachingActivityRecordInclude include() {
    return TeachingActivityRecordInclude._();
  }

  static TeachingActivityRecordIncludeList includeList({
    _is.WhereExpressionBuilder<TeachingActivityRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingActivityRecordTable>? orderByList,
    TeachingActivityRecordInclude? include,
  }) {
    return TeachingActivityRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeachingActivityRecord.t),
      orderByList: orderByList?.call(TeachingActivityRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeachingActivityRecordImpl extends TeachingActivityRecord {
  _TeachingActivityRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    required _is.UuidValue activityId,
    required String kind,
    int? revision,
    bool? published,
    bool? released,
    required _i9l8jupr.TeachingSettings settings,
    required List<_i3iex35i.TeachingQuestion> questions,
  }) : super._(
         id: id,
         courseId: courseId,
         activityId: activityId,
         kind: kind,
         revision: revision,
         published: published,
         released: released,
         settings: settings,
         questions: questions,
       );

  /// Returns a shallow copy of this [TeachingActivityRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeachingActivityRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? courseId,
    _is.UuidValue? activityId,
    String? kind,
    int? revision,
    bool? published,
    bool? released,
    _i9l8jupr.TeachingSettings? settings,
    List<_i3iex35i.TeachingQuestion>? questions,
  }) {
    return TeachingActivityRecord(
      id: id is _is.UuidValue? ? id : this.id,
      courseId: courseId ?? this.courseId,
      activityId: activityId ?? this.activityId,
      kind: kind ?? this.kind,
      revision: revision ?? this.revision,
      published: published ?? this.published,
      released: released ?? this.released,
      settings: settings ?? this.settings.copyWith(),
      questions:
          questions ?? this.questions.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class TeachingActivityRecordUpdateTable
    extends _is.UpdateTable<TeachingActivityRecordTable> {
  TeachingActivityRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> courseId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.courseId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> activityId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.activityId,
    value,
  );

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<int, int> revision(int value) => _is.ColumnValue(
    table.revision,
    value,
  );

  _is.ColumnValue<bool, bool> published(bool value) => _is.ColumnValue(
    table.published,
    value,
  );

  _is.ColumnValue<bool, bool> released(bool value) => _is.ColumnValue(
    table.released,
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

class TeachingActivityRecordTable extends _is.Table<_is.UuidValue?> {
  TeachingActivityRecordTable({super.tableRelation})
    : super(tableName: 'poodle_teaching_activity') {
    updateTable = TeachingActivityRecordUpdateTable(this);
    courseId = _is.ColumnUuid(
      'courseId',
      this,
    );
    activityId = _is.ColumnUuid(
      'activityId',
      this,
    );
    kind = _is.ColumnString(
      'kind',
      this,
    );
    revision = _is.ColumnInt(
      'revision',
      this,
      hasDefault: true,
    );
    published = _is.ColumnBool(
      'published',
      this,
      hasDefault: true,
    );
    released = _is.ColumnBool(
      'released',
      this,
      hasDefault: true,
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

  late final TeachingActivityRecordUpdateTable updateTable;

  late final _is.ColumnUuid courseId;

  late final _is.ColumnUuid activityId;

  late final _is.ColumnString kind;

  late final _is.ColumnInt revision;

  late final _is.ColumnBool published;

  late final _is.ColumnBool released;

  late final _is.ColumnSerializable<_i9l8jupr.TeachingSettings> settings;

  late final _is.ColumnSerializable<List<_i3iex35i.TeachingQuestion>> questions;

  @override
  List<_is.Column> get columns => [
    id,
    courseId,
    activityId,
    kind,
    revision,
    published,
    released,
    settings,
    questions,
  ];
}

class TeachingActivityRecordInclude extends _is.IncludeObject {
  TeachingActivityRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => TeachingActivityRecord.t;
}

class TeachingActivityRecordIncludeList extends _is.IncludeList {
  TeachingActivityRecordIncludeList._({
    _is.WhereExpressionBuilder<TeachingActivityRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TeachingActivityRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => TeachingActivityRecord.t;
}

class TeachingActivityRecordRepository {
  const TeachingActivityRecordRepository._();

  /// Returns a list of [TeachingActivityRecord]s matching the given query parameters.
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
  Future<List<TeachingActivityRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingActivityRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingActivityRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TeachingActivityRecord>(
      where: where?.call(TeachingActivityRecord.t),
      orderBy: orderBy?.call(TeachingActivityRecord.t),
      orderByList: orderByList?.call(TeachingActivityRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TeachingActivityRecord] matching the given query parameters.
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
  Future<TeachingActivityRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingActivityRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<TeachingActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingActivityRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TeachingActivityRecord>(
      where: where?.call(TeachingActivityRecord.t),
      orderBy: orderBy?.call(TeachingActivityRecord.t),
      orderByList: orderByList?.call(TeachingActivityRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TeachingActivityRecord] by its [id] or null if no such row exists.
  Future<TeachingActivityRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TeachingActivityRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TeachingActivityRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [TeachingActivityRecord]s will have their `id` fields set.
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
  Future<List<TeachingActivityRecord>> insert(
    _is.DatabaseSession session,
    List<TeachingActivityRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TeachingActivityRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TeachingActivityRecord] and returns the inserted row.
  ///
  /// The returned [TeachingActivityRecord] will have its `id` field set.
  Future<TeachingActivityRecord> insertRow(
    _is.DatabaseSession session,
    TeachingActivityRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TeachingActivityRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TeachingActivityRecord]s in the list and returns the resulting rows.
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
  /// The returned [TeachingActivityRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingActivityRecord>> upsert(
    _is.DatabaseSession session,
    List<TeachingActivityRecord> rows, {
    required _is.ColumnSelections<TeachingActivityRecordTable> conflictColumns,
    _is.ColumnSelections<TeachingActivityRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeachingActivityRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TeachingActivityRecord>(
      rows,
      conflictColumns: conflictColumns(TeachingActivityRecord.t),
      updateColumns: updateColumns?.call(TeachingActivityRecord.t),
      updateWhere: updateWhere?.call(TeachingActivityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TeachingActivityRecord] and returns the resulting row.
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
  /// The returned [TeachingActivityRecord] will have its `id` field set.
  Future<TeachingActivityRecord?> upsertRow(
    _is.DatabaseSession session,
    TeachingActivityRecord row, {
    required _is.ColumnSelections<TeachingActivityRecordTable> conflictColumns,
    _is.ColumnSelections<TeachingActivityRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeachingActivityRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TeachingActivityRecord>(
      row,
      conflictColumns: conflictColumns(TeachingActivityRecord.t),
      updateColumns: updateColumns?.call(TeachingActivityRecord.t),
      updateWhere: updateWhere?.call(TeachingActivityRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [TeachingActivityRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingActivityRecord>> update(
    _is.DatabaseSession session,
    List<TeachingActivityRecord> rows, {
    _is.ColumnSelections<TeachingActivityRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TeachingActivityRecord>(
      rows,
      columns: columns?.call(TeachingActivityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TeachingActivityRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TeachingActivityRecord> updateRow(
    _is.DatabaseSession session,
    TeachingActivityRecord row, {
    _is.ColumnSelections<TeachingActivityRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TeachingActivityRecord>(
      row,
      columns: columns?.call(TeachingActivityRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TeachingActivityRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TeachingActivityRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TeachingActivityRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TeachingActivityRecord>(
      id,
      columnValues: columnValues(TeachingActivityRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TeachingActivityRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingActivityRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TeachingActivityRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TeachingActivityRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingActivityRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TeachingActivityRecord>(
      columnValues: columnValues(TeachingActivityRecord.t.updateTable),
      where: where(TeachingActivityRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeachingActivityRecord.t),
      orderByList: orderByList?.call(TeachingActivityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TeachingActivityRecord]s in the list and returns the deleted rows.
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
  Future<List<TeachingActivityRecord>> delete(
    _is.DatabaseSession session,
    List<TeachingActivityRecord> rows, {
    _is.OrderByBuilder<TeachingActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingActivityRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TeachingActivityRecord>(
      rows,
      orderBy: orderBy?.call(TeachingActivityRecord.t),
      orderByList: orderByList?.call(TeachingActivityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TeachingActivityRecord].
  Future<TeachingActivityRecord> deleteRow(
    _is.DatabaseSession session,
    TeachingActivityRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TeachingActivityRecord>(
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
  Future<List<TeachingActivityRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeachingActivityRecordTable> where,
    _is.OrderByBuilder<TeachingActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingActivityRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TeachingActivityRecord>(
      where: where(TeachingActivityRecord.t),
      orderBy: orderBy?.call(TeachingActivityRecord.t),
      orderByList: orderByList?.call(TeachingActivityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingActivityRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TeachingActivityRecord>(
      where: where?.call(TeachingActivityRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TeachingActivityRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeachingActivityRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TeachingActivityRecord>(
      where: where(TeachingActivityRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
