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

abstract class TeachingSubmissionRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  TeachingSubmissionRecord._({
    this.id,
    required this.activityId,
    required this.ownerId,
    required this.requestKey,
    required this.text,
    this.uploadId,
    required this.submittedAt,
    this.reopenUntil,
    this.grade,
    String? feedback,
    this.gradedBy,
    bool? published,
  }) : feedback = feedback ?? '',
       published = published ?? false;

  factory TeachingSubmissionRecord({
    _is.UuidValue? id,
    required _is.UuidValue activityId,
    required _is.UuidValue ownerId,
    required String requestKey,
    required String text,
    _is.UuidValue? uploadId,
    required DateTime submittedAt,
    DateTime? reopenUntil,
    double? grade,
    String? feedback,
    _is.UuidValue? gradedBy,
    bool? published,
  }) = _TeachingSubmissionRecordImpl;

  factory TeachingSubmissionRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeachingSubmissionRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      activityId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['activityId'],
      ),
      ownerId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      requestKey: jsonSerialization['requestKey'] as String,
      text: jsonSerialization['text'] as String,
      uploadId: jsonSerialization['uploadId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['uploadId']),
      submittedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['submittedAt'],
      ),
      reopenUntil: jsonSerialization['reopenUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['reopenUntil'],
            ),
      grade: (jsonSerialization['grade'] as num?)?.toDouble(),
      feedback: jsonSerialization['feedback'] as String?,
      gradedBy: jsonSerialization['gradedBy'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['gradedBy']),
      published: jsonSerialization['published'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['published']),
    );
  }

  static final t = TeachingSubmissionRecordTable();

  static const db = TeachingSubmissionRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue activityId;

  _is.UuidValue ownerId;

  String requestKey;

  String text;

  _is.UuidValue? uploadId;

  DateTime submittedAt;

  DateTime? reopenUntil;

  double? grade;

  String feedback;

  _is.UuidValue? gradedBy;

  bool published;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [TeachingSubmissionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeachingSubmissionRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? activityId,
    _is.UuidValue? ownerId,
    String? requestKey,
    String? text,
    _is.UuidValue? uploadId,
    DateTime? submittedAt,
    DateTime? reopenUntil,
    double? grade,
    String? feedback,
    _is.UuidValue? gradedBy,
    bool? published,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeachingSubmissionRecord',
      if (id != null) 'id': id?.toJson(),
      'activityId': activityId.toJson(),
      'ownerId': ownerId.toJson(),
      'requestKey': requestKey,
      'text': text,
      if (uploadId != null) 'uploadId': uploadId?.toJson(),
      'submittedAt': submittedAt.toJson(),
      if (reopenUntil != null) 'reopenUntil': reopenUntil?.toJson(),
      if (grade != null) 'grade': grade,
      'feedback': feedback,
      if (gradedBy != null) 'gradedBy': gradedBy?.toJson(),
      'published': published,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static TeachingSubmissionRecordInclude include() {
    return TeachingSubmissionRecordInclude._();
  }

  static TeachingSubmissionRecordIncludeList includeList({
    _is.WhereExpressionBuilder<TeachingSubmissionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingSubmissionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingSubmissionRecordTable>? orderByList,
    TeachingSubmissionRecordInclude? include,
  }) {
    return TeachingSubmissionRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeachingSubmissionRecord.t),
      orderByList: orderByList?.call(TeachingSubmissionRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeachingSubmissionRecordImpl extends TeachingSubmissionRecord {
  _TeachingSubmissionRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue activityId,
    required _is.UuidValue ownerId,
    required String requestKey,
    required String text,
    _is.UuidValue? uploadId,
    required DateTime submittedAt,
    DateTime? reopenUntil,
    double? grade,
    String? feedback,
    _is.UuidValue? gradedBy,
    bool? published,
  }) : super._(
         id: id,
         activityId: activityId,
         ownerId: ownerId,
         requestKey: requestKey,
         text: text,
         uploadId: uploadId,
         submittedAt: submittedAt,
         reopenUntil: reopenUntil,
         grade: grade,
         feedback: feedback,
         gradedBy: gradedBy,
         published: published,
       );

  /// Returns a shallow copy of this [TeachingSubmissionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeachingSubmissionRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? activityId,
    _is.UuidValue? ownerId,
    String? requestKey,
    String? text,
    Object? uploadId = _Undefined,
    DateTime? submittedAt,
    Object? reopenUntil = _Undefined,
    Object? grade = _Undefined,
    String? feedback,
    Object? gradedBy = _Undefined,
    bool? published,
  }) {
    return TeachingSubmissionRecord(
      id: id is _is.UuidValue? ? id : this.id,
      activityId: activityId ?? this.activityId,
      ownerId: ownerId ?? this.ownerId,
      requestKey: requestKey ?? this.requestKey,
      text: text ?? this.text,
      uploadId: uploadId is _is.UuidValue? ? uploadId : this.uploadId,
      submittedAt: submittedAt ?? this.submittedAt,
      reopenUntil: reopenUntil is DateTime? ? reopenUntil : this.reopenUntil,
      grade: grade is double? ? grade : this.grade,
      feedback: feedback ?? this.feedback,
      gradedBy: gradedBy is _is.UuidValue? ? gradedBy : this.gradedBy,
      published: published ?? this.published,
    );
  }
}

class TeachingSubmissionRecordUpdateTable
    extends _is.UpdateTable<TeachingSubmissionRecordTable> {
  TeachingSubmissionRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> activityId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.activityId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ownerId,
        value,
      );

  _is.ColumnValue<String, String> requestKey(String value) => _is.ColumnValue(
    table.requestKey,
    value,
  );

  _is.ColumnValue<String, String> text(String value) => _is.ColumnValue(
    table.text,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uploadId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.uploadId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> submittedAt(DateTime value) =>
      _is.ColumnValue(
        table.submittedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> reopenUntil(DateTime? value) =>
      _is.ColumnValue(
        table.reopenUntil,
        value,
      );

  _is.ColumnValue<double, double> grade(double? value) => _is.ColumnValue(
    table.grade,
    value,
  );

  _is.ColumnValue<String, String> feedback(String value) => _is.ColumnValue(
    table.feedback,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> gradedBy(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.gradedBy,
    value,
  );

  _is.ColumnValue<bool, bool> published(bool value) => _is.ColumnValue(
    table.published,
    value,
  );
}

class TeachingSubmissionRecordTable extends _is.Table<_is.UuidValue?> {
  TeachingSubmissionRecordTable({super.tableRelation})
    : super(tableName: 'poodle_teaching_submission') {
    updateTable = TeachingSubmissionRecordUpdateTable(this);
    activityId = _is.ColumnUuid(
      'activityId',
      this,
    );
    ownerId = _is.ColumnUuid(
      'ownerId',
      this,
    );
    requestKey = _is.ColumnString(
      'requestKey',
      this,
    );
    text = _is.ColumnString(
      'text',
      this,
    );
    uploadId = _is.ColumnUuid(
      'uploadId',
      this,
    );
    submittedAt = _is.ColumnDateTime(
      'submittedAt',
      this,
    );
    reopenUntil = _is.ColumnDateTime(
      'reopenUntil',
      this,
    );
    grade = _is.ColumnDouble(
      'grade',
      this,
    );
    feedback = _is.ColumnString(
      'feedback',
      this,
      hasDefault: true,
    );
    gradedBy = _is.ColumnUuid(
      'gradedBy',
      this,
    );
    published = _is.ColumnBool(
      'published',
      this,
      hasDefault: true,
    );
  }

  late final TeachingSubmissionRecordUpdateTable updateTable;

  late final _is.ColumnUuid activityId;

  late final _is.ColumnUuid ownerId;

  late final _is.ColumnString requestKey;

  late final _is.ColumnString text;

  late final _is.ColumnUuid uploadId;

  late final _is.ColumnDateTime submittedAt;

  late final _is.ColumnDateTime reopenUntil;

  late final _is.ColumnDouble grade;

  late final _is.ColumnString feedback;

  late final _is.ColumnUuid gradedBy;

  late final _is.ColumnBool published;

  @override
  List<_is.Column> get columns => [
    id,
    activityId,
    ownerId,
    requestKey,
    text,
    uploadId,
    submittedAt,
    reopenUntil,
    grade,
    feedback,
    gradedBy,
    published,
  ];
}

class TeachingSubmissionRecordInclude extends _is.IncludeObject {
  TeachingSubmissionRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => TeachingSubmissionRecord.t;
}

class TeachingSubmissionRecordIncludeList extends _is.IncludeList {
  TeachingSubmissionRecordIncludeList._({
    _is.WhereExpressionBuilder<TeachingSubmissionRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TeachingSubmissionRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => TeachingSubmissionRecord.t;
}

class TeachingSubmissionRecordRepository {
  const TeachingSubmissionRecordRepository._();

  /// Returns a list of [TeachingSubmissionRecord]s matching the given query parameters.
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
  Future<List<TeachingSubmissionRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingSubmissionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingSubmissionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingSubmissionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TeachingSubmissionRecord>(
      where: where?.call(TeachingSubmissionRecord.t),
      orderBy: orderBy?.call(TeachingSubmissionRecord.t),
      orderByList: orderByList?.call(TeachingSubmissionRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TeachingSubmissionRecord] matching the given query parameters.
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
  Future<TeachingSubmissionRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingSubmissionRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<TeachingSubmissionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingSubmissionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TeachingSubmissionRecord>(
      where: where?.call(TeachingSubmissionRecord.t),
      orderBy: orderBy?.call(TeachingSubmissionRecord.t),
      orderByList: orderByList?.call(TeachingSubmissionRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TeachingSubmissionRecord] by its [id] or null if no such row exists.
  Future<TeachingSubmissionRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TeachingSubmissionRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TeachingSubmissionRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [TeachingSubmissionRecord]s will have their `id` fields set.
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
  Future<List<TeachingSubmissionRecord>> insert(
    _is.DatabaseSession session,
    List<TeachingSubmissionRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TeachingSubmissionRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TeachingSubmissionRecord] and returns the inserted row.
  ///
  /// The returned [TeachingSubmissionRecord] will have its `id` field set.
  Future<TeachingSubmissionRecord> insertRow(
    _is.DatabaseSession session,
    TeachingSubmissionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TeachingSubmissionRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TeachingSubmissionRecord]s in the list and returns the resulting rows.
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
  /// The returned [TeachingSubmissionRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingSubmissionRecord>> upsert(
    _is.DatabaseSession session,
    List<TeachingSubmissionRecord> rows, {
    required _is.ColumnSelections<TeachingSubmissionRecordTable>
    conflictColumns,
    _is.ColumnSelections<TeachingSubmissionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeachingSubmissionRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TeachingSubmissionRecord>(
      rows,
      conflictColumns: conflictColumns(TeachingSubmissionRecord.t),
      updateColumns: updateColumns?.call(TeachingSubmissionRecord.t),
      updateWhere: updateWhere?.call(TeachingSubmissionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TeachingSubmissionRecord] and returns the resulting row.
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
  /// The returned [TeachingSubmissionRecord] will have its `id` field set.
  Future<TeachingSubmissionRecord?> upsertRow(
    _is.DatabaseSession session,
    TeachingSubmissionRecord row, {
    required _is.ColumnSelections<TeachingSubmissionRecordTable>
    conflictColumns,
    _is.ColumnSelections<TeachingSubmissionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<TeachingSubmissionRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TeachingSubmissionRecord>(
      row,
      conflictColumns: conflictColumns(TeachingSubmissionRecord.t),
      updateColumns: updateColumns?.call(TeachingSubmissionRecord.t),
      updateWhere: updateWhere?.call(TeachingSubmissionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [TeachingSubmissionRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingSubmissionRecord>> update(
    _is.DatabaseSession session,
    List<TeachingSubmissionRecord> rows, {
    _is.ColumnSelections<TeachingSubmissionRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TeachingSubmissionRecord>(
      rows,
      columns: columns?.call(TeachingSubmissionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TeachingSubmissionRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TeachingSubmissionRecord> updateRow(
    _is.DatabaseSession session,
    TeachingSubmissionRecord row, {
    _is.ColumnSelections<TeachingSubmissionRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TeachingSubmissionRecord>(
      row,
      columns: columns?.call(TeachingSubmissionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TeachingSubmissionRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TeachingSubmissionRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TeachingSubmissionRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TeachingSubmissionRecord>(
      id,
      columnValues: columnValues(TeachingSubmissionRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TeachingSubmissionRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TeachingSubmissionRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TeachingSubmissionRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TeachingSubmissionRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeachingSubmissionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingSubmissionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TeachingSubmissionRecord>(
      columnValues: columnValues(TeachingSubmissionRecord.t.updateTable),
      where: where(TeachingSubmissionRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TeachingSubmissionRecord.t),
      orderByList: orderByList?.call(TeachingSubmissionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TeachingSubmissionRecord]s in the list and returns the deleted rows.
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
  Future<List<TeachingSubmissionRecord>> delete(
    _is.DatabaseSession session,
    List<TeachingSubmissionRecord> rows, {
    _is.OrderByBuilder<TeachingSubmissionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingSubmissionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TeachingSubmissionRecord>(
      rows,
      orderBy: orderBy?.call(TeachingSubmissionRecord.t),
      orderByList: orderByList?.call(TeachingSubmissionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TeachingSubmissionRecord].
  Future<TeachingSubmissionRecord> deleteRow(
    _is.DatabaseSession session,
    TeachingSubmissionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TeachingSubmissionRecord>(
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
  Future<List<TeachingSubmissionRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeachingSubmissionRecordTable> where,
    _is.OrderByBuilder<TeachingSubmissionRecordTable>? orderBy,
    _is.OrderByListBuilder<TeachingSubmissionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TeachingSubmissionRecord>(
      where: where(TeachingSubmissionRecord.t),
      orderBy: orderBy?.call(TeachingSubmissionRecord.t),
      orderByList: orderByList?.call(TeachingSubmissionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeachingSubmissionRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TeachingSubmissionRecord>(
      where: where?.call(TeachingSubmissionRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TeachingSubmissionRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeachingSubmissionRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TeachingSubmissionRecord>(
      where: where(TeachingSubmissionRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
