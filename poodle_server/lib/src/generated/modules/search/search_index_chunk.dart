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
import '../../modules/search/search_index_job.dart' as _izi9x1gr;

abstract class SearchIndexChunk
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SearchIndexChunk._({
    this.id,
    required this.jobId,
    this.job,
    required this.ordinal,
    required this.content,
    this.page,
    this.location,
    required this.embeddingSpace,
    this.embedding,
  });

  factory SearchIndexChunk({
    int? id,
    required int jobId,
    _izi9x1gr.SearchIndexJob? job,
    required int ordinal,
    required String content,
    int? page,
    String? location,
    required String embeddingSpace,
    _is.Vector? embedding,
  }) = _SearchIndexChunkImpl;

  factory SearchIndexChunk.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchIndexChunk(
      id: jsonSerialization['id'] as int?,
      jobId: jsonSerialization['jobId'] as int,
      job: jsonSerialization['job'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_izi9x1gr.SearchIndexJob>(
              jsonSerialization['job'],
            ),
      ordinal: jsonSerialization['ordinal'] as int,
      content: jsonSerialization['content'] as String,
      page: jsonSerialization['page'] as int?,
      location: jsonSerialization['location'] as String?,
      embeddingSpace: jsonSerialization['embeddingSpace'] as String,
      embedding: jsonSerialization['embedding'] == null
          ? null
          : _is.VectorJsonExtension.fromJson(jsonSerialization['embedding']),
    );
  }

  static final t = SearchIndexChunkTable();

  static const db = SearchIndexChunkRepository._();

  @override
  int? id;

  int jobId;

  _izi9x1gr.SearchIndexJob? job;

  int ordinal;

  String content;

  int? page;

  String? location;

  String embeddingSpace;

  _is.Vector? embedding;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SearchIndexChunk]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SearchIndexChunk copyWith({
    int? id,
    int? jobId,
    _izi9x1gr.SearchIndexJob? job,
    int? ordinal,
    String? content,
    int? page,
    String? location,
    String? embeddingSpace,
    _is.Vector? embedding,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SearchIndexChunk',
      if (id != null) 'id': id,
      'jobId': jobId,
      if (job != null) 'job': job?.toJson(),
      'ordinal': ordinal,
      'content': content,
      if (page != null) 'page': page,
      if (location != null) 'location': location,
      'embeddingSpace': embeddingSpace,
      if (embedding != null) 'embedding': embedding?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SearchIndexChunkInclude include({
    _izi9x1gr.SearchIndexJobInclude? job,
  }) {
    return SearchIndexChunkInclude._(job: job);
  }

  static SearchIndexChunkIncludeList includeList({
    _is.WhereExpressionBuilder<SearchIndexChunkTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SearchIndexChunkTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexChunkTable>? orderByList,
    SearchIndexChunkInclude? include,
  }) {
    return SearchIndexChunkIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SearchIndexChunk.t),
      orderByList: orderByList?.call(SearchIndexChunk.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SearchIndexChunkImpl extends SearchIndexChunk {
  _SearchIndexChunkImpl({
    int? id,
    required int jobId,
    _izi9x1gr.SearchIndexJob? job,
    required int ordinal,
    required String content,
    int? page,
    String? location,
    required String embeddingSpace,
    _is.Vector? embedding,
  }) : super._(
         id: id,
         jobId: jobId,
         job: job,
         ordinal: ordinal,
         content: content,
         page: page,
         location: location,
         embeddingSpace: embeddingSpace,
         embedding: embedding,
       );

  /// Returns a shallow copy of this [SearchIndexChunk]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SearchIndexChunk copyWith({
    Object? id = _Undefined,
    int? jobId,
    Object? job = _Undefined,
    int? ordinal,
    String? content,
    Object? page = _Undefined,
    Object? location = _Undefined,
    String? embeddingSpace,
    Object? embedding = _Undefined,
  }) {
    return SearchIndexChunk(
      id: id is int? ? id : this.id,
      jobId: jobId ?? this.jobId,
      job: job is _izi9x1gr.SearchIndexJob? ? job : this.job?.copyWith(),
      ordinal: ordinal ?? this.ordinal,
      content: content ?? this.content,
      page: page is int? ? page : this.page,
      location: location is String? ? location : this.location,
      embeddingSpace: embeddingSpace ?? this.embeddingSpace,
      embedding: embedding is _is.Vector? ? embedding : this.embedding?.clone(),
    );
  }
}

class SearchIndexChunkUpdateTable
    extends _is.UpdateTable<SearchIndexChunkTable> {
  SearchIndexChunkUpdateTable(super.table);

  _is.ColumnValue<int, int> jobId(int value) => _is.ColumnValue(
    table.jobId,
    value,
  );

  _is.ColumnValue<int, int> ordinal(int value) => _is.ColumnValue(
    table.ordinal,
    value,
  );

  _is.ColumnValue<String, String> content(String value) => _is.ColumnValue(
    table.content,
    value,
  );

  _is.ColumnValue<int, int> page(int? value) => _is.ColumnValue(
    table.page,
    value,
  );

  _is.ColumnValue<String, String> location(String? value) => _is.ColumnValue(
    table.location,
    value,
  );

  _is.ColumnValue<String, String> embeddingSpace(String value) =>
      _is.ColumnValue(
        table.embeddingSpace,
        value,
      );

  _is.ColumnValue<_is.Vector, _is.Vector> embedding(_is.Vector? value) =>
      _is.ColumnValue(
        table.embedding,
        value,
      );
}

class SearchIndexChunkTable extends _is.Table<int?> {
  SearchIndexChunkTable({super.tableRelation})
    : super(tableName: 'poodle_search_index_chunk') {
    updateTable = SearchIndexChunkUpdateTable(this);
    jobId = _is.ColumnInt(
      'jobId',
      this,
    );
    ordinal = _is.ColumnInt(
      'ordinal',
      this,
    );
    content = _is.ColumnString(
      'content',
      this,
    );
    page = _is.ColumnInt(
      'page',
      this,
    );
    location = _is.ColumnString(
      'location',
      this,
    );
    embeddingSpace = _is.ColumnString(
      'embeddingSpace',
      this,
    );
    embedding = _is.ColumnVector(
      'embedding',
      this,
      dimension: 1536,
    );
  }

  late final SearchIndexChunkUpdateTable updateTable;

  late final _is.ColumnInt jobId;

  _izi9x1gr.SearchIndexJobTable? _job;

  late final _is.ColumnInt ordinal;

  late final _is.ColumnString content;

  late final _is.ColumnInt page;

  late final _is.ColumnString location;

  late final _is.ColumnString embeddingSpace;

  late final _is.ColumnVector embedding;

  _izi9x1gr.SearchIndexJobTable get job {
    if (_job != null) return _job!;
    _job = _is.createRelationTable(
      relationFieldName: 'job',
      field: SearchIndexChunk.t.jobId,
      foreignField: _izi9x1gr.SearchIndexJob.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _izi9x1gr.SearchIndexJobTable(tableRelation: foreignTableRelation),
    );
    return _job!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    jobId,
    ordinal,
    content,
    page,
    location,
    embeddingSpace,
    embedding,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'job') {
      return job;
    }
    return null;
  }
}

class SearchIndexChunkInclude extends _is.IncludeObject {
  SearchIndexChunkInclude._({_izi9x1gr.SearchIndexJobInclude? job}) {
    _job = job;
  }

  _izi9x1gr.SearchIndexJobInclude? _job;

  @override
  Map<String, _is.Include?> get includes => {'job': _job};

  @override
  _is.Table<int?> get table => SearchIndexChunk.t;
}

class SearchIndexChunkIncludeList extends _is.IncludeList {
  SearchIndexChunkIncludeList._({
    _is.WhereExpressionBuilder<SearchIndexChunkTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SearchIndexChunk.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SearchIndexChunk.t;
}

class SearchIndexChunkRepository {
  const SearchIndexChunkRepository._();

  final attachRow = const SearchIndexChunkAttachRowRepository._();

  /// Returns a list of [SearchIndexChunk]s matching the given query parameters.
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
  Future<List<SearchIndexChunk>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SearchIndexChunkTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SearchIndexChunkTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexChunkTable>? orderByList,
    _is.Transaction? transaction,
    SearchIndexChunkInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SearchIndexChunk>(
      where: where?.call(SearchIndexChunk.t),
      orderBy: orderBy?.call(SearchIndexChunk.t),
      orderByList: orderByList?.call(SearchIndexChunk.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SearchIndexChunk] matching the given query parameters.
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
  Future<SearchIndexChunk?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SearchIndexChunkTable>? where,
    int? offset,
    _is.OrderByBuilder<SearchIndexChunkTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexChunkTable>? orderByList,
    _is.Transaction? transaction,
    SearchIndexChunkInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SearchIndexChunk>(
      where: where?.call(SearchIndexChunk.t),
      orderBy: orderBy?.call(SearchIndexChunk.t),
      orderByList: orderByList?.call(SearchIndexChunk.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SearchIndexChunk] by its [id] or null if no such row exists.
  Future<SearchIndexChunk?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    SearchIndexChunkInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SearchIndexChunk>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SearchIndexChunk]s in the list and returns the inserted rows.
  ///
  /// The returned [SearchIndexChunk]s will have their `id` fields set.
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
  Future<List<SearchIndexChunk>> insert(
    _is.DatabaseSession session,
    List<SearchIndexChunk> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SearchIndexChunk>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SearchIndexChunk] and returns the inserted row.
  ///
  /// The returned [SearchIndexChunk] will have its `id` field set.
  Future<SearchIndexChunk> insertRow(
    _is.DatabaseSession session,
    SearchIndexChunk row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SearchIndexChunk>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SearchIndexChunk]s in the list and returns the resulting rows.
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
  /// The returned [SearchIndexChunk]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SearchIndexChunk>> upsert(
    _is.DatabaseSession session,
    List<SearchIndexChunk> rows, {
    required _is.ColumnSelections<SearchIndexChunkTable> conflictColumns,
    _is.ColumnSelections<SearchIndexChunkTable>? updateColumns,
    _is.WhereExpressionBuilder<SearchIndexChunkTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SearchIndexChunk>(
      rows,
      conflictColumns: conflictColumns(SearchIndexChunk.t),
      updateColumns: updateColumns?.call(SearchIndexChunk.t),
      updateWhere: updateWhere?.call(SearchIndexChunk.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SearchIndexChunk] and returns the resulting row.
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
  /// The returned [SearchIndexChunk] will have its `id` field set.
  Future<SearchIndexChunk?> upsertRow(
    _is.DatabaseSession session,
    SearchIndexChunk row, {
    required _is.ColumnSelections<SearchIndexChunkTable> conflictColumns,
    _is.ColumnSelections<SearchIndexChunkTable>? updateColumns,
    _is.WhereExpressionBuilder<SearchIndexChunkTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SearchIndexChunk>(
      row,
      conflictColumns: conflictColumns(SearchIndexChunk.t),
      updateColumns: updateColumns?.call(SearchIndexChunk.t),
      updateWhere: updateWhere?.call(SearchIndexChunk.t),
      transaction: transaction,
    );
  }

  /// Updates all [SearchIndexChunk]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SearchIndexChunk>> update(
    _is.DatabaseSession session,
    List<SearchIndexChunk> rows, {
    _is.ColumnSelections<SearchIndexChunkTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SearchIndexChunk>(
      rows,
      columns: columns?.call(SearchIndexChunk.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SearchIndexChunk]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SearchIndexChunk> updateRow(
    _is.DatabaseSession session,
    SearchIndexChunk row, {
    _is.ColumnSelections<SearchIndexChunkTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SearchIndexChunk>(
      row,
      columns: columns?.call(SearchIndexChunk.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SearchIndexChunk] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SearchIndexChunk?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SearchIndexChunkUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SearchIndexChunk>(
      id,
      columnValues: columnValues(SearchIndexChunk.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SearchIndexChunk]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SearchIndexChunk>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SearchIndexChunkUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<SearchIndexChunkTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SearchIndexChunkTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexChunkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SearchIndexChunk>(
      columnValues: columnValues(SearchIndexChunk.t.updateTable),
      where: where(SearchIndexChunk.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SearchIndexChunk.t),
      orderByList: orderByList?.call(SearchIndexChunk.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SearchIndexChunk]s in the list and returns the deleted rows.
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
  Future<List<SearchIndexChunk>> delete(
    _is.DatabaseSession session,
    List<SearchIndexChunk> rows, {
    _is.OrderByBuilder<SearchIndexChunkTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexChunkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SearchIndexChunk>(
      rows,
      orderBy: orderBy?.call(SearchIndexChunk.t),
      orderByList: orderByList?.call(SearchIndexChunk.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SearchIndexChunk].
  Future<SearchIndexChunk> deleteRow(
    _is.DatabaseSession session,
    SearchIndexChunk row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SearchIndexChunk>(
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
  Future<List<SearchIndexChunk>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SearchIndexChunkTable> where,
    _is.OrderByBuilder<SearchIndexChunkTable>? orderBy,
    _is.OrderByListBuilder<SearchIndexChunkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SearchIndexChunk>(
      where: where(SearchIndexChunk.t),
      orderBy: orderBy?.call(SearchIndexChunk.t),
      orderByList: orderByList?.call(SearchIndexChunk.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SearchIndexChunkTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SearchIndexChunk>(
      where: where?.call(SearchIndexChunk.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SearchIndexChunk] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SearchIndexChunkTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SearchIndexChunk>(
      where: where(SearchIndexChunk.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class SearchIndexChunkAttachRowRepository {
  const SearchIndexChunkAttachRowRepository._();

  /// Creates a relation between the given [SearchIndexChunk] and [SearchIndexJob]
  /// by setting the [SearchIndexChunk]'s foreign key `jobId` to refer to the [SearchIndexJob].
  Future<void> job(
    _is.DatabaseSession session,
    SearchIndexChunk searchIndexChunk,
    _izi9x1gr.SearchIndexJob job, {
    _is.Transaction? transaction,
  }) async {
    if (searchIndexChunk.id == null) {
      throw ArgumentError.notNull('searchIndexChunk.id');
    }
    if (job.id == null) {
      throw ArgumentError.notNull('job.id');
    }

    var $searchIndexChunk = searchIndexChunk.copyWith(jobId: job.id);
    await session.db.updateRow<SearchIndexChunk>(
      $searchIndexChunk,
      columns: [SearchIndexChunk.t.jobId],
      transaction: transaction,
    );
  }
}
