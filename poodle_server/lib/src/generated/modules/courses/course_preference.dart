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

abstract class CoursePreference
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  CoursePreference._({
    this.id,
    required this.authUserId,
    required this.courseId,
    bool? starred,
    bool? hidden,
  }) : starred = starred ?? false,
       hidden = hidden ?? false;

  factory CoursePreference({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    required _is.UuidValue courseId,
    bool? starred,
    bool? hidden,
  }) = _CoursePreferenceImpl;

  factory CoursePreference.fromJson(Map<String, dynamic> jsonSerialization) {
    return CoursePreference(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      starred: jsonSerialization['starred'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['starred']),
      hidden: jsonSerialization['hidden'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['hidden']),
    );
  }

  static final t = CoursePreferenceTable();

  static const db = CoursePreferenceRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  _is.UuidValue courseId;

  bool starred;

  bool hidden;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CoursePreference]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CoursePreference copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _is.UuidValue? courseId,
    bool? starred,
    bool? hidden,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CoursePreference',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      'courseId': courseId.toJson(),
      'starred': starred,
      'hidden': hidden,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CoursePreferenceInclude include() {
    return CoursePreferenceInclude._();
  }

  static CoursePreferenceIncludeList includeList({
    _is.WhereExpressionBuilder<CoursePreferenceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CoursePreferenceTable>? orderBy,
    _is.OrderByListBuilder<CoursePreferenceTable>? orderByList,
    CoursePreferenceInclude? include,
  }) {
    return CoursePreferenceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CoursePreference.t),
      orderByList: orderByList?.call(CoursePreference.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CoursePreferenceImpl extends CoursePreference {
  _CoursePreferenceImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    required _is.UuidValue courseId,
    bool? starred,
    bool? hidden,
  }) : super._(
         id: id,
         authUserId: authUserId,
         courseId: courseId,
         starred: starred,
         hidden: hidden,
       );

  /// Returns a shallow copy of this [CoursePreference]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CoursePreference copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    _is.UuidValue? courseId,
    bool? starred,
    bool? hidden,
  }) {
    return CoursePreference(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      courseId: courseId ?? this.courseId,
      starred: starred ?? this.starred,
      hidden: hidden ?? this.hidden,
    );
  }
}

class CoursePreferenceUpdateTable
    extends _is.UpdateTable<CoursePreferenceTable> {
  CoursePreferenceUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> courseId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.courseId,
        value,
      );

  _is.ColumnValue<bool, bool> starred(bool value) => _is.ColumnValue(
    table.starred,
    value,
  );

  _is.ColumnValue<bool, bool> hidden(bool value) => _is.ColumnValue(
    table.hidden,
    value,
  );
}

class CoursePreferenceTable extends _is.Table<_is.UuidValue?> {
  CoursePreferenceTable({super.tableRelation})
    : super(tableName: 'poodle_course_preference') {
    updateTable = CoursePreferenceUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    courseId = _is.ColumnUuid(
      'courseId',
      this,
    );
    starred = _is.ColumnBool(
      'starred',
      this,
      hasDefault: true,
    );
    hidden = _is.ColumnBool(
      'hidden',
      this,
      hasDefault: true,
    );
  }

  late final CoursePreferenceUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnUuid courseId;

  late final _is.ColumnBool starred;

  late final _is.ColumnBool hidden;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    courseId,
    starred,
    hidden,
  ];
}

class CoursePreferenceInclude extends _is.IncludeObject {
  CoursePreferenceInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => CoursePreference.t;
}

class CoursePreferenceIncludeList extends _is.IncludeList {
  CoursePreferenceIncludeList._({
    _is.WhereExpressionBuilder<CoursePreferenceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CoursePreference.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => CoursePreference.t;
}

class CoursePreferenceRepository {
  const CoursePreferenceRepository._();

  /// Returns a list of [CoursePreference]s matching the given query parameters.
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
  Future<List<CoursePreference>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CoursePreferenceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CoursePreferenceTable>? orderBy,
    _is.OrderByListBuilder<CoursePreferenceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CoursePreference>(
      where: where?.call(CoursePreference.t),
      orderBy: orderBy?.call(CoursePreference.t),
      orderByList: orderByList?.call(CoursePreference.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CoursePreference] matching the given query parameters.
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
  Future<CoursePreference?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CoursePreferenceTable>? where,
    int? offset,
    _is.OrderByBuilder<CoursePreferenceTable>? orderBy,
    _is.OrderByListBuilder<CoursePreferenceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CoursePreference>(
      where: where?.call(CoursePreference.t),
      orderBy: orderBy?.call(CoursePreference.t),
      orderByList: orderByList?.call(CoursePreference.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CoursePreference] by its [id] or null if no such row exists.
  Future<CoursePreference?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CoursePreference>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CoursePreference]s in the list and returns the inserted rows.
  ///
  /// The returned [CoursePreference]s will have their `id` fields set.
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
  Future<List<CoursePreference>> insert(
    _is.DatabaseSession session,
    List<CoursePreference> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CoursePreference>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CoursePreference] and returns the inserted row.
  ///
  /// The returned [CoursePreference] will have its `id` field set.
  Future<CoursePreference> insertRow(
    _is.DatabaseSession session,
    CoursePreference row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CoursePreference>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CoursePreference]s in the list and returns the resulting rows.
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
  /// The returned [CoursePreference]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CoursePreference>> upsert(
    _is.DatabaseSession session,
    List<CoursePreference> rows, {
    required _is.ColumnSelections<CoursePreferenceTable> conflictColumns,
    _is.ColumnSelections<CoursePreferenceTable>? updateColumns,
    _is.WhereExpressionBuilder<CoursePreferenceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CoursePreference>(
      rows,
      conflictColumns: conflictColumns(CoursePreference.t),
      updateColumns: updateColumns?.call(CoursePreference.t),
      updateWhere: updateWhere?.call(CoursePreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CoursePreference] and returns the resulting row.
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
  /// The returned [CoursePreference] will have its `id` field set.
  Future<CoursePreference?> upsertRow(
    _is.DatabaseSession session,
    CoursePreference row, {
    required _is.ColumnSelections<CoursePreferenceTable> conflictColumns,
    _is.ColumnSelections<CoursePreferenceTable>? updateColumns,
    _is.WhereExpressionBuilder<CoursePreferenceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CoursePreference>(
      row,
      conflictColumns: conflictColumns(CoursePreference.t),
      updateColumns: updateColumns?.call(CoursePreference.t),
      updateWhere: updateWhere?.call(CoursePreference.t),
      transaction: transaction,
    );
  }

  /// Updates all [CoursePreference]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CoursePreference>> update(
    _is.DatabaseSession session,
    List<CoursePreference> rows, {
    _is.ColumnSelections<CoursePreferenceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CoursePreference>(
      rows,
      columns: columns?.call(CoursePreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CoursePreference]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CoursePreference> updateRow(
    _is.DatabaseSession session,
    CoursePreference row, {
    _is.ColumnSelections<CoursePreferenceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CoursePreference>(
      row,
      columns: columns?.call(CoursePreference.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CoursePreference] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CoursePreference?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CoursePreferenceUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CoursePreference>(
      id,
      columnValues: columnValues(CoursePreference.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CoursePreference]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CoursePreference>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CoursePreferenceUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CoursePreferenceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CoursePreferenceTable>? orderBy,
    _is.OrderByListBuilder<CoursePreferenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CoursePreference>(
      columnValues: columnValues(CoursePreference.t.updateTable),
      where: where(CoursePreference.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CoursePreference.t),
      orderByList: orderByList?.call(CoursePreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CoursePreference]s in the list and returns the deleted rows.
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
  Future<List<CoursePreference>> delete(
    _is.DatabaseSession session,
    List<CoursePreference> rows, {
    _is.OrderByBuilder<CoursePreferenceTable>? orderBy,
    _is.OrderByListBuilder<CoursePreferenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CoursePreference>(
      rows,
      orderBy: orderBy?.call(CoursePreference.t),
      orderByList: orderByList?.call(CoursePreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CoursePreference].
  Future<CoursePreference> deleteRow(
    _is.DatabaseSession session,
    CoursePreference row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CoursePreference>(
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
  Future<List<CoursePreference>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CoursePreferenceTable> where,
    _is.OrderByBuilder<CoursePreferenceTable>? orderBy,
    _is.OrderByListBuilder<CoursePreferenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CoursePreference>(
      where: where(CoursePreference.t),
      orderBy: orderBy?.call(CoursePreference.t),
      orderByList: orderByList?.call(CoursePreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CoursePreferenceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CoursePreference>(
      where: where?.call(CoursePreference.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CoursePreference] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CoursePreferenceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CoursePreference>(
      where: where(CoursePreference.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
