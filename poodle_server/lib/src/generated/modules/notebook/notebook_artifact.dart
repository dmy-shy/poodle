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

abstract class NotebookArtifactRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NotebookArtifactRecord._({
    this.id,
    required this.notebookId,
    required this.ownerUserId,
    required this.kind,
    required this.title,
    required this.contentJson,
    required this.sourceRevision,
    this.jobId,
    this.language,
    this.sourceSnapshotJson,
    this.audioStoragePath,
    bool? stale,
    DateTime? createdAt,
  }) : stale = stale ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory NotebookArtifactRecord({
    _is.UuidValue? id,
    required _is.UuidValue notebookId,
    required _is.UuidValue ownerUserId,
    required String kind,
    required String title,
    required String contentJson,
    required int sourceRevision,
    _is.UuidValue? jobId,
    String? language,
    String? sourceSnapshotJson,
    String? audioStoragePath,
    bool? stale,
    DateTime? createdAt,
  }) = _NotebookArtifactRecordImpl;

  factory NotebookArtifactRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotebookArtifactRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      notebookId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['notebookId'],
      ),
      ownerUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerUserId'],
      ),
      kind: jsonSerialization['kind'] as String,
      title: jsonSerialization['title'] as String,
      contentJson: jsonSerialization['contentJson'] as String,
      sourceRevision: jsonSerialization['sourceRevision'] as int,
      jobId: jsonSerialization['jobId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['jobId']),
      language: jsonSerialization['language'] as String?,
      sourceSnapshotJson: jsonSerialization['sourceSnapshotJson'] as String?,
      audioStoragePath: jsonSerialization['audioStoragePath'] as String?,
      stale: jsonSerialization['stale'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['stale']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = NotebookArtifactRecordTable();

  static const db = NotebookArtifactRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue notebookId;

  _is.UuidValue ownerUserId;

  String kind;

  String title;

  String contentJson;

  int sourceRevision;

  _is.UuidValue? jobId;

  String? language;

  String? sourceSnapshotJson;

  String? audioStoragePath;

  bool stale;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NotebookArtifactRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotebookArtifactRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? notebookId,
    _is.UuidValue? ownerUserId,
    String? kind,
    String? title,
    String? contentJson,
    int? sourceRevision,
    _is.UuidValue? jobId,
    String? language,
    String? sourceSnapshotJson,
    String? audioStoragePath,
    bool? stale,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotebookArtifactRecord',
      if (id != null) 'id': id?.toJson(),
      'notebookId': notebookId.toJson(),
      'ownerUserId': ownerUserId.toJson(),
      'kind': kind,
      'title': title,
      'contentJson': contentJson,
      'sourceRevision': sourceRevision,
      if (jobId != null) 'jobId': jobId?.toJson(),
      if (language != null) 'language': language,
      if (sourceSnapshotJson != null) 'sourceSnapshotJson': sourceSnapshotJson,
      if (audioStoragePath != null) 'audioStoragePath': audioStoragePath,
      'stale': stale,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static NotebookArtifactRecordInclude include() {
    return NotebookArtifactRecordInclude._();
  }

  static NotebookArtifactRecordIncludeList includeList({
    _is.WhereExpressionBuilder<NotebookArtifactRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookArtifactRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookArtifactRecordTable>? orderByList,
    NotebookArtifactRecordInclude? include,
  }) {
    return NotebookArtifactRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookArtifactRecord.t),
      orderByList: orderByList?.call(NotebookArtifactRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotebookArtifactRecordImpl extends NotebookArtifactRecord {
  _NotebookArtifactRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue notebookId,
    required _is.UuidValue ownerUserId,
    required String kind,
    required String title,
    required String contentJson,
    required int sourceRevision,
    _is.UuidValue? jobId,
    String? language,
    String? sourceSnapshotJson,
    String? audioStoragePath,
    bool? stale,
    DateTime? createdAt,
  }) : super._(
         id: id,
         notebookId: notebookId,
         ownerUserId: ownerUserId,
         kind: kind,
         title: title,
         contentJson: contentJson,
         sourceRevision: sourceRevision,
         jobId: jobId,
         language: language,
         sourceSnapshotJson: sourceSnapshotJson,
         audioStoragePath: audioStoragePath,
         stale: stale,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotebookArtifactRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotebookArtifactRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? notebookId,
    _is.UuidValue? ownerUserId,
    String? kind,
    String? title,
    String? contentJson,
    int? sourceRevision,
    Object? jobId = _Undefined,
    Object? language = _Undefined,
    Object? sourceSnapshotJson = _Undefined,
    Object? audioStoragePath = _Undefined,
    bool? stale,
    DateTime? createdAt,
  }) {
    return NotebookArtifactRecord(
      id: id is _is.UuidValue? ? id : this.id,
      notebookId: notebookId ?? this.notebookId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      contentJson: contentJson ?? this.contentJson,
      sourceRevision: sourceRevision ?? this.sourceRevision,
      jobId: jobId is _is.UuidValue? ? jobId : this.jobId,
      language: language is String? ? language : this.language,
      sourceSnapshotJson: sourceSnapshotJson is String?
          ? sourceSnapshotJson
          : this.sourceSnapshotJson,
      audioStoragePath: audioStoragePath is String?
          ? audioStoragePath
          : this.audioStoragePath,
      stale: stale ?? this.stale,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotebookArtifactRecordUpdateTable
    extends _is.UpdateTable<NotebookArtifactRecordTable> {
  NotebookArtifactRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> notebookId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.notebookId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ownerUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.ownerUserId,
    value,
  );

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> contentJson(String value) => _is.ColumnValue(
    table.contentJson,
    value,
  );

  _is.ColumnValue<int, int> sourceRevision(int value) => _is.ColumnValue(
    table.sourceRevision,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> jobId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.jobId,
        value,
      );

  _is.ColumnValue<String, String> language(String? value) => _is.ColumnValue(
    table.language,
    value,
  );

  _is.ColumnValue<String, String> sourceSnapshotJson(String? value) =>
      _is.ColumnValue(
        table.sourceSnapshotJson,
        value,
      );

  _is.ColumnValue<String, String> audioStoragePath(String? value) =>
      _is.ColumnValue(
        table.audioStoragePath,
        value,
      );

  _is.ColumnValue<bool, bool> stale(bool value) => _is.ColumnValue(
    table.stale,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class NotebookArtifactRecordTable extends _is.Table<_is.UuidValue?> {
  NotebookArtifactRecordTable({super.tableRelation})
    : super(tableName: 'poodle_notebook_artifact') {
    updateTable = NotebookArtifactRecordUpdateTable(this);
    notebookId = _is.ColumnUuid(
      'notebookId',
      this,
    );
    ownerUserId = _is.ColumnUuid(
      'ownerUserId',
      this,
    );
    kind = _is.ColumnString(
      'kind',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    contentJson = _is.ColumnString(
      'contentJson',
      this,
    );
    sourceRevision = _is.ColumnInt(
      'sourceRevision',
      this,
    );
    jobId = _is.ColumnUuid(
      'jobId',
      this,
    );
    language = _is.ColumnString(
      'language',
      this,
    );
    sourceSnapshotJson = _is.ColumnString(
      'sourceSnapshotJson',
      this,
    );
    audioStoragePath = _is.ColumnString(
      'audioStoragePath',
      this,
    );
    stale = _is.ColumnBool(
      'stale',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final NotebookArtifactRecordUpdateTable updateTable;

  late final _is.ColumnUuid notebookId;

  late final _is.ColumnUuid ownerUserId;

  late final _is.ColumnString kind;

  late final _is.ColumnString title;

  late final _is.ColumnString contentJson;

  late final _is.ColumnInt sourceRevision;

  late final _is.ColumnUuid jobId;

  late final _is.ColumnString language;

  late final _is.ColumnString sourceSnapshotJson;

  late final _is.ColumnString audioStoragePath;

  late final _is.ColumnBool stale;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    notebookId,
    ownerUserId,
    kind,
    title,
    contentJson,
    sourceRevision,
    jobId,
    language,
    sourceSnapshotJson,
    audioStoragePath,
    stale,
    createdAt,
  ];
}

class NotebookArtifactRecordInclude extends _is.IncludeObject {
  NotebookArtifactRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookArtifactRecord.t;
}

class NotebookArtifactRecordIncludeList extends _is.IncludeList {
  NotebookArtifactRecordIncludeList._({
    _is.WhereExpressionBuilder<NotebookArtifactRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotebookArtifactRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NotebookArtifactRecord.t;
}

class NotebookArtifactRecordRepository {
  const NotebookArtifactRecordRepository._();

  /// Returns a list of [NotebookArtifactRecord]s matching the given query parameters.
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
  Future<List<NotebookArtifactRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookArtifactRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookArtifactRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookArtifactRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotebookArtifactRecord>(
      where: where?.call(NotebookArtifactRecord.t),
      orderBy: orderBy?.call(NotebookArtifactRecord.t),
      orderByList: orderByList?.call(NotebookArtifactRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotebookArtifactRecord] matching the given query parameters.
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
  Future<NotebookArtifactRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookArtifactRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<NotebookArtifactRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookArtifactRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotebookArtifactRecord>(
      where: where?.call(NotebookArtifactRecord.t),
      orderBy: orderBy?.call(NotebookArtifactRecord.t),
      orderByList: orderByList?.call(NotebookArtifactRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotebookArtifactRecord] by its [id] or null if no such row exists.
  Future<NotebookArtifactRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotebookArtifactRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotebookArtifactRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotebookArtifactRecord]s will have their `id` fields set.
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
  Future<List<NotebookArtifactRecord>> insert(
    _is.DatabaseSession session,
    List<NotebookArtifactRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotebookArtifactRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotebookArtifactRecord] and returns the inserted row.
  ///
  /// The returned [NotebookArtifactRecord] will have its `id` field set.
  Future<NotebookArtifactRecord> insertRow(
    _is.DatabaseSession session,
    NotebookArtifactRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotebookArtifactRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotebookArtifactRecord]s in the list and returns the resulting rows.
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
  /// The returned [NotebookArtifactRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookArtifactRecord>> upsert(
    _is.DatabaseSession session,
    List<NotebookArtifactRecord> rows, {
    required _is.ColumnSelections<NotebookArtifactRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookArtifactRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookArtifactRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotebookArtifactRecord>(
      rows,
      conflictColumns: conflictColumns(NotebookArtifactRecord.t),
      updateColumns: updateColumns?.call(NotebookArtifactRecord.t),
      updateWhere: updateWhere?.call(NotebookArtifactRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotebookArtifactRecord] and returns the resulting row.
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
  /// The returned [NotebookArtifactRecord] will have its `id` field set.
  Future<NotebookArtifactRecord?> upsertRow(
    _is.DatabaseSession session,
    NotebookArtifactRecord row, {
    required _is.ColumnSelections<NotebookArtifactRecordTable> conflictColumns,
    _is.ColumnSelections<NotebookArtifactRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<NotebookArtifactRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotebookArtifactRecord>(
      row,
      conflictColumns: conflictColumns(NotebookArtifactRecord.t),
      updateColumns: updateColumns?.call(NotebookArtifactRecord.t),
      updateWhere: updateWhere?.call(NotebookArtifactRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookArtifactRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookArtifactRecord>> update(
    _is.DatabaseSession session,
    List<NotebookArtifactRecord> rows, {
    _is.ColumnSelections<NotebookArtifactRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotebookArtifactRecord>(
      rows,
      columns: columns?.call(NotebookArtifactRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotebookArtifactRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotebookArtifactRecord> updateRow(
    _is.DatabaseSession session,
    NotebookArtifactRecord row, {
    _is.ColumnSelections<NotebookArtifactRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotebookArtifactRecord>(
      row,
      columns: columns?.call(NotebookArtifactRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotebookArtifactRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotebookArtifactRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NotebookArtifactRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotebookArtifactRecord>(
      id,
      columnValues: columnValues(NotebookArtifactRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotebookArtifactRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotebookArtifactRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotebookArtifactRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NotebookArtifactRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotebookArtifactRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookArtifactRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotebookArtifactRecord>(
      columnValues: columnValues(NotebookArtifactRecord.t.updateTable),
      where: where(NotebookArtifactRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotebookArtifactRecord.t),
      orderByList: orderByList?.call(NotebookArtifactRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotebookArtifactRecord]s in the list and returns the deleted rows.
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
  Future<List<NotebookArtifactRecord>> delete(
    _is.DatabaseSession session,
    List<NotebookArtifactRecord> rows, {
    _is.OrderByBuilder<NotebookArtifactRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookArtifactRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotebookArtifactRecord>(
      rows,
      orderBy: orderBy?.call(NotebookArtifactRecord.t),
      orderByList: orderByList?.call(NotebookArtifactRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotebookArtifactRecord].
  Future<NotebookArtifactRecord> deleteRow(
    _is.DatabaseSession session,
    NotebookArtifactRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotebookArtifactRecord>(
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
  Future<List<NotebookArtifactRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookArtifactRecordTable> where,
    _is.OrderByBuilder<NotebookArtifactRecordTable>? orderBy,
    _is.OrderByListBuilder<NotebookArtifactRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotebookArtifactRecord>(
      where: where(NotebookArtifactRecord.t),
      orderBy: orderBy?.call(NotebookArtifactRecord.t),
      orderByList: orderByList?.call(NotebookArtifactRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotebookArtifactRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotebookArtifactRecord>(
      where: where?.call(NotebookArtifactRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotebookArtifactRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotebookArtifactRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotebookArtifactRecord>(
      where: where(NotebookArtifactRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
