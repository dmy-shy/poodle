/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:poodle_server/src/generated/protocol.dart' as _ikm1kaos;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import '../../modules/courses/course_record.dart' as _i7rr55u6;

abstract class CourseMembership
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  CourseMembership._({
    this.id,
    required this.courseId,
    this.course,
    required this.authUserId,
    this.authUser,
    required this.role,
    bool? active,
  }) : active = active ?? true;

  factory CourseMembership({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    _i7rr55u6.CourseRecord? course,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String role,
    bool? active,
  }) = _CourseMembershipImpl;

  factory CourseMembership.fromJson(Map<String, dynamic> jsonSerialization) {
    return CourseMembership(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      courseId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      course: jsonSerialization['course'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_i7rr55u6.CourseRecord>(
              jsonSerialization['course'],
            ),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      role: jsonSerialization['role'] as String,
      active: jsonSerialization['active'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['active']),
    );
  }

  static final t = CourseMembershipTable();

  static const db = CourseMembershipRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue courseId;

  _i7rr55u6.CourseRecord? course;

  _is.UuidValue authUserId;

  _iacs.AuthUser? authUser;

  String role;

  bool active;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CourseMembership]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CourseMembership copyWith({
    _is.UuidValue? id,
    _is.UuidValue? courseId,
    _i7rr55u6.CourseRecord? course,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    String? role,
    bool? active,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseMembership',
      if (id != null) 'id': id?.toJson(),
      'courseId': courseId.toJson(),
      if (course != null) 'course': course?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'role': role,
      'active': active,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CourseMembershipInclude include({
    _i7rr55u6.CourseRecordInclude? course,
    _iacs.AuthUserInclude? authUser,
  }) {
    return CourseMembershipInclude._(
      course: course,
      authUser: authUser,
    );
  }

  static CourseMembershipIncludeList includeList({
    _is.WhereExpressionBuilder<CourseMembershipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseMembershipTable>? orderBy,
    _is.OrderByListBuilder<CourseMembershipTable>? orderByList,
    CourseMembershipInclude? include,
  }) {
    return CourseMembershipIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CourseMembership.t),
      orderByList: orderByList?.call(CourseMembership.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseMembershipImpl extends CourseMembership {
  _CourseMembershipImpl({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    _i7rr55u6.CourseRecord? course,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String role,
    bool? active,
  }) : super._(
         id: id,
         courseId: courseId,
         course: course,
         authUserId: authUserId,
         authUser: authUser,
         role: role,
         active: active,
       );

  /// Returns a shallow copy of this [CourseMembership]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CourseMembership copyWith({
    Object? id = _Undefined,
    _is.UuidValue? courseId,
    Object? course = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? role,
    bool? active,
  }) {
    return CourseMembership(
      id: id is _is.UuidValue? ? id : this.id,
      courseId: courseId ?? this.courseId,
      course: course is _i7rr55u6.CourseRecord?
          ? course
          : this.course?.copyWith(),
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      role: role ?? this.role,
      active: active ?? this.active,
    );
  }
}

class CourseMembershipUpdateTable
    extends _is.UpdateTable<CourseMembershipTable> {
  CourseMembershipUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> courseId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.courseId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> role(String value) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<bool, bool> active(bool value) => _is.ColumnValue(
    table.active,
    value,
  );
}

class CourseMembershipTable extends _is.Table<_is.UuidValue?> {
  CourseMembershipTable({super.tableRelation})
    : super(tableName: 'poodle_course_membership') {
    updateTable = CourseMembershipUpdateTable(this);
    courseId = _is.ColumnUuid(
      'courseId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    role = _is.ColumnString(
      'role',
      this,
    );
    active = _is.ColumnBool(
      'active',
      this,
      hasDefault: true,
    );
  }

  late final CourseMembershipUpdateTable updateTable;

  late final _is.ColumnUuid courseId;

  _i7rr55u6.CourseRecordTable? _course;

  late final _is.ColumnUuid authUserId;

  _iacs.AuthUserTable? _authUser;

  late final _is.ColumnString role;

  late final _is.ColumnBool active;

  _i7rr55u6.CourseRecordTable get course {
    if (_course != null) return _course!;
    _course = _is.createRelationTable(
      relationFieldName: 'course',
      field: CourseMembership.t.courseId,
      foreignField: _i7rr55u6.CourseRecord.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7rr55u6.CourseRecordTable(tableRelation: foreignTableRelation),
    );
    return _course!;
  }

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: CourseMembership.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    courseId,
    authUserId,
    role,
    active,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'course') {
      return course;
    }
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class CourseMembershipInclude extends _is.IncludeObject {
  CourseMembershipInclude._({
    _i7rr55u6.CourseRecordInclude? course,
    _iacs.AuthUserInclude? authUser,
  }) {
    _course = course;
    _authUser = authUser;
  }

  _i7rr55u6.CourseRecordInclude? _course;

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {
    'course': _course,
    'authUser': _authUser,
  };

  @override
  _is.Table<_is.UuidValue?> get table => CourseMembership.t;
}

class CourseMembershipIncludeList extends _is.IncludeList {
  CourseMembershipIncludeList._({
    _is.WhereExpressionBuilder<CourseMembershipTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CourseMembership.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => CourseMembership.t;
}

class CourseMembershipRepository {
  const CourseMembershipRepository._();

  final attachRow = const CourseMembershipAttachRowRepository._();

  /// Returns a list of [CourseMembership]s matching the given query parameters.
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
  Future<List<CourseMembership>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseMembershipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseMembershipTable>? orderBy,
    _is.OrderByListBuilder<CourseMembershipTable>? orderByList,
    _is.Transaction? transaction,
    CourseMembershipInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CourseMembership>(
      where: where?.call(CourseMembership.t),
      orderBy: orderBy?.call(CourseMembership.t),
      orderByList: orderByList?.call(CourseMembership.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CourseMembership] matching the given query parameters.
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
  Future<CourseMembership?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseMembershipTable>? where,
    int? offset,
    _is.OrderByBuilder<CourseMembershipTable>? orderBy,
    _is.OrderByListBuilder<CourseMembershipTable>? orderByList,
    _is.Transaction? transaction,
    CourseMembershipInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CourseMembership>(
      where: where?.call(CourseMembership.t),
      orderBy: orderBy?.call(CourseMembership.t),
      orderByList: orderByList?.call(CourseMembership.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CourseMembership] by its [id] or null if no such row exists.
  Future<CourseMembership?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    CourseMembershipInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CourseMembership>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CourseMembership]s in the list and returns the inserted rows.
  ///
  /// The returned [CourseMembership]s will have their `id` fields set.
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
  Future<List<CourseMembership>> insert(
    _is.DatabaseSession session,
    List<CourseMembership> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CourseMembership>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CourseMembership] and returns the inserted row.
  ///
  /// The returned [CourseMembership] will have its `id` field set.
  Future<CourseMembership> insertRow(
    _is.DatabaseSession session,
    CourseMembership row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CourseMembership>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CourseMembership]s in the list and returns the resulting rows.
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
  /// The returned [CourseMembership]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseMembership>> upsert(
    _is.DatabaseSession session,
    List<CourseMembership> rows, {
    required _is.ColumnSelections<CourseMembershipTable> conflictColumns,
    _is.ColumnSelections<CourseMembershipTable>? updateColumns,
    _is.WhereExpressionBuilder<CourseMembershipTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CourseMembership>(
      rows,
      conflictColumns: conflictColumns(CourseMembership.t),
      updateColumns: updateColumns?.call(CourseMembership.t),
      updateWhere: updateWhere?.call(CourseMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CourseMembership] and returns the resulting row.
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
  /// The returned [CourseMembership] will have its `id` field set.
  Future<CourseMembership?> upsertRow(
    _is.DatabaseSession session,
    CourseMembership row, {
    required _is.ColumnSelections<CourseMembershipTable> conflictColumns,
    _is.ColumnSelections<CourseMembershipTable>? updateColumns,
    _is.WhereExpressionBuilder<CourseMembershipTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CourseMembership>(
      row,
      conflictColumns: conflictColumns(CourseMembership.t),
      updateColumns: updateColumns?.call(CourseMembership.t),
      updateWhere: updateWhere?.call(CourseMembership.t),
      transaction: transaction,
    );
  }

  /// Updates all [CourseMembership]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseMembership>> update(
    _is.DatabaseSession session,
    List<CourseMembership> rows, {
    _is.ColumnSelections<CourseMembershipTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CourseMembership>(
      rows,
      columns: columns?.call(CourseMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CourseMembership]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CourseMembership> updateRow(
    _is.DatabaseSession session,
    CourseMembership row, {
    _is.ColumnSelections<CourseMembershipTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CourseMembership>(
      row,
      columns: columns?.call(CourseMembership.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CourseMembership] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CourseMembership?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CourseMembershipUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CourseMembership>(
      id,
      columnValues: columnValues(CourseMembership.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CourseMembership]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseMembership>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CourseMembershipUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CourseMembershipTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseMembershipTable>? orderBy,
    _is.OrderByListBuilder<CourseMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CourseMembership>(
      columnValues: columnValues(CourseMembership.t.updateTable),
      where: where(CourseMembership.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CourseMembership.t),
      orderByList: orderByList?.call(CourseMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CourseMembership]s in the list and returns the deleted rows.
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
  Future<List<CourseMembership>> delete(
    _is.DatabaseSession session,
    List<CourseMembership> rows, {
    _is.OrderByBuilder<CourseMembershipTable>? orderBy,
    _is.OrderByListBuilder<CourseMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CourseMembership>(
      rows,
      orderBy: orderBy?.call(CourseMembership.t),
      orderByList: orderByList?.call(CourseMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CourseMembership].
  Future<CourseMembership> deleteRow(
    _is.DatabaseSession session,
    CourseMembership row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CourseMembership>(
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
  Future<List<CourseMembership>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CourseMembershipTable> where,
    _is.OrderByBuilder<CourseMembershipTable>? orderBy,
    _is.OrderByListBuilder<CourseMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CourseMembership>(
      where: where(CourseMembership.t),
      orderBy: orderBy?.call(CourseMembership.t),
      orderByList: orderByList?.call(CourseMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseMembershipTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CourseMembership>(
      where: where?.call(CourseMembership.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CourseMembership] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CourseMembershipTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CourseMembership>(
      where: where(CourseMembership.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CourseMembershipAttachRowRepository {
  const CourseMembershipAttachRowRepository._();

  /// Creates a relation between the given [CourseMembership] and [CourseRecord]
  /// by setting the [CourseMembership]'s foreign key `courseId` to refer to the [CourseRecord].
  Future<void> course(
    _is.DatabaseSession session,
    CourseMembership courseMembership,
    _i7rr55u6.CourseRecord course, {
    _is.Transaction? transaction,
  }) async {
    if (courseMembership.id == null) {
      throw ArgumentError.notNull('courseMembership.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $courseMembership = courseMembership.copyWith(courseId: course.id);
    await session.db.updateRow<CourseMembership>(
      $courseMembership,
      columns: [CourseMembership.t.courseId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [CourseMembership] and [AuthUser]
  /// by setting the [CourseMembership]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    CourseMembership courseMembership,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (courseMembership.id == null) {
      throw ArgumentError.notNull('courseMembership.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $courseMembership = courseMembership.copyWith(authUserId: authUser.id);
    await session.db.updateRow<CourseMembership>(
      $courseMembership,
      columns: [CourseMembership.t.authUserId],
      transaction: transaction,
    );
  }
}
