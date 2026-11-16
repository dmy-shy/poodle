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
import '../../modules/identity/university_record.dart' as _ig96r09j;

abstract class CourseRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  CourseRecord._({
    this.id,
    required this.title,
    this.universityId,
    this.university,
    this.category,
    this.summary,
    this.teacherName,
    bool? seedOwned,
    bool? published,
  }) : seedOwned = seedOwned ?? false,
       published = published ?? true;

  factory CourseRecord({
    _is.UuidValue? id,
    required String title,
    _is.UuidValue? universityId,
    _ig96r09j.UniversityRecord? university,
    String? category,
    String? summary,
    String? teacherName,
    bool? seedOwned,
    bool? published,
  }) = _CourseRecordImpl;

  factory CourseRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return CourseRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      title: jsonSerialization['title'] as String,
      universityId: jsonSerialization['universityId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['universityId'],
            ),
      university: jsonSerialization['university'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_ig96r09j.UniversityRecord>(
              jsonSerialization['university'],
            ),
      category: jsonSerialization['category'] as String?,
      summary: jsonSerialization['summary'] as String?,
      teacherName: jsonSerialization['teacherName'] as String?,
      seedOwned: jsonSerialization['seedOwned'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['seedOwned']),
      published: jsonSerialization['published'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['published']),
    );
  }

  static final t = CourseRecordTable();

  static const db = CourseRecordRepository._();

  @override
  _is.UuidValue? id;

  String title;

  _is.UuidValue? universityId;

  _ig96r09j.UniversityRecord? university;

  String? category;

  String? summary;

  String? teacherName;

  bool seedOwned;

  bool published;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CourseRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CourseRecord copyWith({
    _is.UuidValue? id,
    String? title,
    _is.UuidValue? universityId,
    _ig96r09j.UniversityRecord? university,
    String? category,
    String? summary,
    String? teacherName,
    bool? seedOwned,
    bool? published,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseRecord',
      if (id != null) 'id': id?.toJson(),
      'title': title,
      if (universityId != null) 'universityId': universityId?.toJson(),
      if (university != null) 'university': university?.toJson(),
      if (category != null) 'category': category,
      if (summary != null) 'summary': summary,
      if (teacherName != null) 'teacherName': teacherName,
      'seedOwned': seedOwned,
      'published': published,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CourseRecordInclude include({
    _ig96r09j.UniversityRecordInclude? university,
  }) {
    return CourseRecordInclude._(university: university);
  }

  static CourseRecordIncludeList includeList({
    _is.WhereExpressionBuilder<CourseRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseRecordTable>? orderByList,
    CourseRecordInclude? include,
  }) {
    return CourseRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CourseRecord.t),
      orderByList: orderByList?.call(CourseRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseRecordImpl extends CourseRecord {
  _CourseRecordImpl({
    _is.UuidValue? id,
    required String title,
    _is.UuidValue? universityId,
    _ig96r09j.UniversityRecord? university,
    String? category,
    String? summary,
    String? teacherName,
    bool? seedOwned,
    bool? published,
  }) : super._(
         id: id,
         title: title,
         universityId: universityId,
         university: university,
         category: category,
         summary: summary,
         teacherName: teacherName,
         seedOwned: seedOwned,
         published: published,
       );

  /// Returns a shallow copy of this [CourseRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CourseRecord copyWith({
    Object? id = _Undefined,
    String? title,
    Object? universityId = _Undefined,
    Object? university = _Undefined,
    Object? category = _Undefined,
    Object? summary = _Undefined,
    Object? teacherName = _Undefined,
    bool? seedOwned,
    bool? published,
  }) {
    return CourseRecord(
      id: id is _is.UuidValue? ? id : this.id,
      title: title ?? this.title,
      universityId: universityId is _is.UuidValue?
          ? universityId
          : this.universityId,
      university: university is _ig96r09j.UniversityRecord?
          ? university
          : this.university?.copyWith(),
      category: category is String? ? category : this.category,
      summary: summary is String? ? summary : this.summary,
      teacherName: teacherName is String? ? teacherName : this.teacherName,
      seedOwned: seedOwned ?? this.seedOwned,
      published: published ?? this.published,
    );
  }
}

class CourseRecordUpdateTable extends _is.UpdateTable<CourseRecordTable> {
  CourseRecordUpdateTable(super.table);

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> universityId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.universityId,
    value,
  );

  _is.ColumnValue<String, String> category(String? value) => _is.ColumnValue(
    table.category,
    value,
  );

  _is.ColumnValue<String, String> summary(String? value) => _is.ColumnValue(
    table.summary,
    value,
  );

  _is.ColumnValue<String, String> teacherName(String? value) => _is.ColumnValue(
    table.teacherName,
    value,
  );

  _is.ColumnValue<bool, bool> seedOwned(bool value) => _is.ColumnValue(
    table.seedOwned,
    value,
  );

  _is.ColumnValue<bool, bool> published(bool value) => _is.ColumnValue(
    table.published,
    value,
  );
}

class CourseRecordTable extends _is.Table<_is.UuidValue?> {
  CourseRecordTable({super.tableRelation}) : super(tableName: 'poodle_course') {
    updateTable = CourseRecordUpdateTable(this);
    title = _is.ColumnString(
      'title',
      this,
    );
    universityId = _is.ColumnUuid(
      'universityId',
      this,
    );
    category = _is.ColumnString(
      'category',
      this,
    );
    summary = _is.ColumnString(
      'summary',
      this,
    );
    teacherName = _is.ColumnString(
      'teacherName',
      this,
    );
    seedOwned = _is.ColumnBool(
      'seedOwned',
      this,
      hasDefault: true,
    );
    published = _is.ColumnBool(
      'published',
      this,
      hasDefault: true,
    );
  }

  late final CourseRecordUpdateTable updateTable;

  late final _is.ColumnString title;

  late final _is.ColumnUuid universityId;

  _ig96r09j.UniversityRecordTable? _university;

  late final _is.ColumnString category;

  late final _is.ColumnString summary;

  late final _is.ColumnString teacherName;

  late final _is.ColumnBool seedOwned;

  late final _is.ColumnBool published;

  _ig96r09j.UniversityRecordTable get university {
    if (_university != null) return _university!;
    _university = _is.createRelationTable(
      relationFieldName: 'university',
      field: CourseRecord.t.universityId,
      foreignField: _ig96r09j.UniversityRecord.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ig96r09j.UniversityRecordTable(tableRelation: foreignTableRelation),
    );
    return _university!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    title,
    universityId,
    category,
    summary,
    teacherName,
    seedOwned,
    published,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'university') {
      return university;
    }
    return null;
  }
}

class CourseRecordInclude extends _is.IncludeObject {
  CourseRecordInclude._({_ig96r09j.UniversityRecordInclude? university}) {
    _university = university;
  }

  _ig96r09j.UniversityRecordInclude? _university;

  @override
  Map<String, _is.Include?> get includes => {'university': _university};

  @override
  _is.Table<_is.UuidValue?> get table => CourseRecord.t;
}

class CourseRecordIncludeList extends _is.IncludeList {
  CourseRecordIncludeList._({
    _is.WhereExpressionBuilder<CourseRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CourseRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => CourseRecord.t;
}

class CourseRecordRepository {
  const CourseRecordRepository._();

  final attachRow = const CourseRecordAttachRowRepository._();

  final detachRow = const CourseRecordDetachRowRepository._();

  /// Returns a list of [CourseRecord]s matching the given query parameters.
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
  Future<List<CourseRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseRecordTable>? orderByList,
    _is.Transaction? transaction,
    CourseRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CourseRecord>(
      where: where?.call(CourseRecord.t),
      orderBy: orderBy?.call(CourseRecord.t),
      orderByList: orderByList?.call(CourseRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CourseRecord] matching the given query parameters.
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
  Future<CourseRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<CourseRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseRecordTable>? orderByList,
    _is.Transaction? transaction,
    CourseRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CourseRecord>(
      where: where?.call(CourseRecord.t),
      orderBy: orderBy?.call(CourseRecord.t),
      orderByList: orderByList?.call(CourseRecord.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CourseRecord] by its [id] or null if no such row exists.
  Future<CourseRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    CourseRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CourseRecord>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CourseRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [CourseRecord]s will have their `id` fields set.
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
  Future<List<CourseRecord>> insert(
    _is.DatabaseSession session,
    List<CourseRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CourseRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CourseRecord] and returns the inserted row.
  ///
  /// The returned [CourseRecord] will have its `id` field set.
  Future<CourseRecord> insertRow(
    _is.DatabaseSession session,
    CourseRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CourseRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CourseRecord]s in the list and returns the resulting rows.
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
  /// The returned [CourseRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseRecord>> upsert(
    _is.DatabaseSession session,
    List<CourseRecord> rows, {
    required _is.ColumnSelections<CourseRecordTable> conflictColumns,
    _is.ColumnSelections<CourseRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<CourseRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CourseRecord>(
      rows,
      conflictColumns: conflictColumns(CourseRecord.t),
      updateColumns: updateColumns?.call(CourseRecord.t),
      updateWhere: updateWhere?.call(CourseRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CourseRecord] and returns the resulting row.
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
  /// The returned [CourseRecord] will have its `id` field set.
  Future<CourseRecord?> upsertRow(
    _is.DatabaseSession session,
    CourseRecord row, {
    required _is.ColumnSelections<CourseRecordTable> conflictColumns,
    _is.ColumnSelections<CourseRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<CourseRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CourseRecord>(
      row,
      conflictColumns: conflictColumns(CourseRecord.t),
      updateColumns: updateColumns?.call(CourseRecord.t),
      updateWhere: updateWhere?.call(CourseRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [CourseRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseRecord>> update(
    _is.DatabaseSession session,
    List<CourseRecord> rows, {
    _is.ColumnSelections<CourseRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CourseRecord>(
      rows,
      columns: columns?.call(CourseRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CourseRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CourseRecord> updateRow(
    _is.DatabaseSession session,
    CourseRecord row, {
    _is.ColumnSelections<CourseRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CourseRecord>(
      row,
      columns: columns?.call(CourseRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CourseRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CourseRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CourseRecordUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CourseRecord>(
      id,
      columnValues: columnValues(CourseRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CourseRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CourseRecordUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CourseRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CourseRecord>(
      columnValues: columnValues(CourseRecord.t.updateTable),
      where: where(CourseRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CourseRecord.t),
      orderByList: orderByList?.call(CourseRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CourseRecord]s in the list and returns the deleted rows.
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
  Future<List<CourseRecord>> delete(
    _is.DatabaseSession session,
    List<CourseRecord> rows, {
    _is.OrderByBuilder<CourseRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CourseRecord>(
      rows,
      orderBy: orderBy?.call(CourseRecord.t),
      orderByList: orderByList?.call(CourseRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CourseRecord].
  Future<CourseRecord> deleteRow(
    _is.DatabaseSession session,
    CourseRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CourseRecord>(
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
  Future<List<CourseRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CourseRecordTable> where,
    _is.OrderByBuilder<CourseRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CourseRecord>(
      where: where(CourseRecord.t),
      orderBy: orderBy?.call(CourseRecord.t),
      orderByList: orderByList?.call(CourseRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CourseRecord>(
      where: where?.call(CourseRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CourseRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CourseRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CourseRecord>(
      where: where(CourseRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CourseRecordAttachRowRepository {
  const CourseRecordAttachRowRepository._();

  /// Creates a relation between the given [CourseRecord] and [UniversityRecord]
  /// by setting the [CourseRecord]'s foreign key `universityId` to refer to the [UniversityRecord].
  Future<void> university(
    _is.DatabaseSession session,
    CourseRecord courseRecord,
    _ig96r09j.UniversityRecord university, {
    _is.Transaction? transaction,
  }) async {
    if (courseRecord.id == null) {
      throw ArgumentError.notNull('courseRecord.id');
    }
    if (university.id == null) {
      throw ArgumentError.notNull('university.id');
    }

    var $courseRecord = courseRecord.copyWith(universityId: university.id);
    await session.db.updateRow<CourseRecord>(
      $courseRecord,
      columns: [CourseRecord.t.universityId],
      transaction: transaction,
    );
  }
}

class CourseRecordDetachRowRepository {
  const CourseRecordDetachRowRepository._();

  /// Detaches the relation between this [CourseRecord] and the [UniversityRecord] set in `university`
  /// by setting the [CourseRecord]'s foreign key `universityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> university(
    _is.DatabaseSession session,
    CourseRecord courseRecord, {
    _is.Transaction? transaction,
  }) async {
    if (courseRecord.id == null) {
      throw ArgumentError.notNull('courseRecord.id');
    }

    var $courseRecord = courseRecord.copyWith(universityId: null);
    await session.db.updateRow<CourseRecord>(
      $courseRecord,
      columns: [CourseRecord.t.universityId],
      transaction: transaction,
    );
  }
}
