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
import '../../modules/courses/course_record.dart' as _i7rr55u6;

abstract class CourseSectionRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  CourseSectionRecord._({
    this.id,
    required this.courseId,
    this.course,
    required this.title,
    this.description,
    required this.sortOrder,
    bool? published,
  }) : published = published ?? false;

  factory CourseSectionRecord({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    _i7rr55u6.CourseRecord? course,
    required String title,
    String? description,
    required int sortOrder,
    bool? published,
  }) = _CourseSectionRecordImpl;

  factory CourseSectionRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return CourseSectionRecord(
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
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      sortOrder: jsonSerialization['sortOrder'] as int,
      published: jsonSerialization['published'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['published']),
    );
  }

  static final t = CourseSectionRecordTable();

  static const db = CourseSectionRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue courseId;

  _i7rr55u6.CourseRecord? course;

  String title;

  String? description;

  int sortOrder;

  bool published;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CourseSectionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CourseSectionRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? courseId,
    _i7rr55u6.CourseRecord? course,
    String? title,
    String? description,
    int? sortOrder,
    bool? published,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseSectionRecord',
      if (id != null) 'id': id?.toJson(),
      'courseId': courseId.toJson(),
      if (course != null) 'course': course?.toJson(),
      'title': title,
      if (description != null) 'description': description,
      'sortOrder': sortOrder,
      'published': published,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CourseSectionRecordInclude include({
    _i7rr55u6.CourseRecordInclude? course,
  }) {
    return CourseSectionRecordInclude._(course: course);
  }

  static CourseSectionRecordIncludeList includeList({
    _is.WhereExpressionBuilder<CourseSectionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseSectionRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseSectionRecordTable>? orderByList,
    CourseSectionRecordInclude? include,
  }) {
    return CourseSectionRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CourseSectionRecord.t),
      orderByList: orderByList?.call(CourseSectionRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseSectionRecordImpl extends CourseSectionRecord {
  _CourseSectionRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue courseId,
    _i7rr55u6.CourseRecord? course,
    required String title,
    String? description,
    required int sortOrder,
    bool? published,
  }) : super._(
         id: id,
         courseId: courseId,
         course: course,
         title: title,
         description: description,
         sortOrder: sortOrder,
         published: published,
       );

  /// Returns a shallow copy of this [CourseSectionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CourseSectionRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? courseId,
    Object? course = _Undefined,
    String? title,
    Object? description = _Undefined,
    int? sortOrder,
    bool? published,
  }) {
    return CourseSectionRecord(
      id: id is _is.UuidValue? ? id : this.id,
      courseId: courseId ?? this.courseId,
      course: course is _i7rr55u6.CourseRecord?
          ? course
          : this.course?.copyWith(),
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      published: published ?? this.published,
    );
  }
}

class CourseSectionRecordUpdateTable
    extends _is.UpdateTable<CourseSectionRecordTable> {
  CourseSectionRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> courseId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.courseId,
        value,
      );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<int, int> sortOrder(int value) => _is.ColumnValue(
    table.sortOrder,
    value,
  );

  _is.ColumnValue<bool, bool> published(bool value) => _is.ColumnValue(
    table.published,
    value,
  );
}

class CourseSectionRecordTable extends _is.Table<_is.UuidValue?> {
  CourseSectionRecordTable({super.tableRelation})
    : super(tableName: 'poodle_course_section') {
    updateTable = CourseSectionRecordUpdateTable(this);
    courseId = _is.ColumnUuid(
      'courseId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    sortOrder = _is.ColumnInt(
      'sortOrder',
      this,
    );
    published = _is.ColumnBool(
      'published',
      this,
      hasDefault: true,
    );
  }

  late final CourseSectionRecordUpdateTable updateTable;

  late final _is.ColumnUuid courseId;

  _i7rr55u6.CourseRecordTable? _course;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  late final _is.ColumnInt sortOrder;

  late final _is.ColumnBool published;

  _i7rr55u6.CourseRecordTable get course {
    if (_course != null) return _course!;
    _course = _is.createRelationTable(
      relationFieldName: 'course',
      field: CourseSectionRecord.t.courseId,
      foreignField: _i7rr55u6.CourseRecord.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7rr55u6.CourseRecordTable(tableRelation: foreignTableRelation),
    );
    return _course!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    courseId,
    title,
    description,
    sortOrder,
    published,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'course') {
      return course;
    }
    return null;
  }
}

class CourseSectionRecordInclude extends _is.IncludeObject {
  CourseSectionRecordInclude._({_i7rr55u6.CourseRecordInclude? course}) {
    _course = course;
  }

  _i7rr55u6.CourseRecordInclude? _course;

  @override
  Map<String, _is.Include?> get includes => {'course': _course};

  @override
  _is.Table<_is.UuidValue?> get table => CourseSectionRecord.t;
}

class CourseSectionRecordIncludeList extends _is.IncludeList {
  CourseSectionRecordIncludeList._({
    _is.WhereExpressionBuilder<CourseSectionRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CourseSectionRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => CourseSectionRecord.t;
}

class CourseSectionRecordRepository {
  const CourseSectionRecordRepository._();

  final attachRow = const CourseSectionRecordAttachRowRepository._();

  /// Returns a list of [CourseSectionRecord]s matching the given query parameters.
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
  Future<List<CourseSectionRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseSectionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseSectionRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseSectionRecordTable>? orderByList,
    _is.Transaction? transaction,
    CourseSectionRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CourseSectionRecord>(
      where: where?.call(CourseSectionRecord.t),
      orderBy: orderBy?.call(CourseSectionRecord.t),
      orderByList: orderByList?.call(CourseSectionRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CourseSectionRecord] matching the given query parameters.
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
  Future<CourseSectionRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseSectionRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<CourseSectionRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseSectionRecordTable>? orderByList,
    _is.Transaction? transaction,
    CourseSectionRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CourseSectionRecord>(
      where: where?.call(CourseSectionRecord.t),
      orderBy: orderBy?.call(CourseSectionRecord.t),
      orderByList: orderByList?.call(CourseSectionRecord.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CourseSectionRecord] by its [id] or null if no such row exists.
  Future<CourseSectionRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    CourseSectionRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CourseSectionRecord>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CourseSectionRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [CourseSectionRecord]s will have their `id` fields set.
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
  Future<List<CourseSectionRecord>> insert(
    _is.DatabaseSession session,
    List<CourseSectionRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CourseSectionRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CourseSectionRecord] and returns the inserted row.
  ///
  /// The returned [CourseSectionRecord] will have its `id` field set.
  Future<CourseSectionRecord> insertRow(
    _is.DatabaseSession session,
    CourseSectionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CourseSectionRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CourseSectionRecord]s in the list and returns the resulting rows.
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
  /// The returned [CourseSectionRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseSectionRecord>> upsert(
    _is.DatabaseSession session,
    List<CourseSectionRecord> rows, {
    required _is.ColumnSelections<CourseSectionRecordTable> conflictColumns,
    _is.ColumnSelections<CourseSectionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<CourseSectionRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CourseSectionRecord>(
      rows,
      conflictColumns: conflictColumns(CourseSectionRecord.t),
      updateColumns: updateColumns?.call(CourseSectionRecord.t),
      updateWhere: updateWhere?.call(CourseSectionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CourseSectionRecord] and returns the resulting row.
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
  /// The returned [CourseSectionRecord] will have its `id` field set.
  Future<CourseSectionRecord?> upsertRow(
    _is.DatabaseSession session,
    CourseSectionRecord row, {
    required _is.ColumnSelections<CourseSectionRecordTable> conflictColumns,
    _is.ColumnSelections<CourseSectionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<CourseSectionRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CourseSectionRecord>(
      row,
      conflictColumns: conflictColumns(CourseSectionRecord.t),
      updateColumns: updateColumns?.call(CourseSectionRecord.t),
      updateWhere: updateWhere?.call(CourseSectionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [CourseSectionRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseSectionRecord>> update(
    _is.DatabaseSession session,
    List<CourseSectionRecord> rows, {
    _is.ColumnSelections<CourseSectionRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CourseSectionRecord>(
      rows,
      columns: columns?.call(CourseSectionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CourseSectionRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CourseSectionRecord> updateRow(
    _is.DatabaseSession session,
    CourseSectionRecord row, {
    _is.ColumnSelections<CourseSectionRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CourseSectionRecord>(
      row,
      columns: columns?.call(CourseSectionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CourseSectionRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CourseSectionRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CourseSectionRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CourseSectionRecord>(
      id,
      columnValues: columnValues(CourseSectionRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CourseSectionRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseSectionRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CourseSectionRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CourseSectionRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseSectionRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseSectionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CourseSectionRecord>(
      columnValues: columnValues(CourseSectionRecord.t.updateTable),
      where: where(CourseSectionRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CourseSectionRecord.t),
      orderByList: orderByList?.call(CourseSectionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CourseSectionRecord]s in the list and returns the deleted rows.
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
  Future<List<CourseSectionRecord>> delete(
    _is.DatabaseSession session,
    List<CourseSectionRecord> rows, {
    _is.OrderByBuilder<CourseSectionRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseSectionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CourseSectionRecord>(
      rows,
      orderBy: orderBy?.call(CourseSectionRecord.t),
      orderByList: orderByList?.call(CourseSectionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CourseSectionRecord].
  Future<CourseSectionRecord> deleteRow(
    _is.DatabaseSession session,
    CourseSectionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CourseSectionRecord>(
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
  Future<List<CourseSectionRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CourseSectionRecordTable> where,
    _is.OrderByBuilder<CourseSectionRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseSectionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CourseSectionRecord>(
      where: where(CourseSectionRecord.t),
      orderBy: orderBy?.call(CourseSectionRecord.t),
      orderByList: orderByList?.call(CourseSectionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseSectionRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CourseSectionRecord>(
      where: where?.call(CourseSectionRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CourseSectionRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CourseSectionRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CourseSectionRecord>(
      where: where(CourseSectionRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CourseSectionRecordAttachRowRepository {
  const CourseSectionRecordAttachRowRepository._();

  /// Creates a relation between the given [CourseSectionRecord] and [CourseRecord]
  /// by setting the [CourseSectionRecord]'s foreign key `courseId` to refer to the [CourseRecord].
  Future<void> course(
    _is.DatabaseSession session,
    CourseSectionRecord courseSectionRecord,
    _i7rr55u6.CourseRecord course, {
    _is.Transaction? transaction,
  }) async {
    if (courseSectionRecord.id == null) {
      throw ArgumentError.notNull('courseSectionRecord.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $courseSectionRecord = courseSectionRecord.copyWith(
      courseId: course.id,
    );
    await session.db.updateRow<CourseSectionRecord>(
      $courseSectionRecord,
      columns: [CourseSectionRecord.t.courseId],
      transaction: transaction,
    );
  }
}
