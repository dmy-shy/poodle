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

abstract class InstitutionMailRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  InstitutionMailRecord._({
    _is.UuidValue? id,
    required this.key,
    required this.email,
    required this.subject,
    required this.body,
    int? attempts,
    DateTime? availableAt,
    this.deliveredAt,
  }) : id = id ?? const _is.Uuid().v7obj(),
       attempts = attempts ?? 0,
       availableAt = availableAt ?? DateTime.now();

  factory InstitutionMailRecord({
    _is.UuidValue? id,
    required String key,
    required String email,
    required String subject,
    required String body,
    int? attempts,
    DateTime? availableAt,
    DateTime? deliveredAt,
  }) = _InstitutionMailRecordImpl;

  factory InstitutionMailRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return InstitutionMailRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      key: jsonSerialization['key'] as String,
      email: jsonSerialization['email'] as String,
      subject: jsonSerialization['subject'] as String,
      body: jsonSerialization['body'] as String,
      attempts: jsonSerialization['attempts'] as int?,
      availableAt: jsonSerialization['availableAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['availableAt'],
            ),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt'],
            ),
    );
  }

  static final t = InstitutionMailRecordTable();

  static const db = InstitutionMailRecordRepository._();

  @override
  _is.UuidValue? id;

  String key;

  String email;

  String subject;

  String body;

  int attempts;

  DateTime availableAt;

  DateTime? deliveredAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [InstitutionMailRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InstitutionMailRecord copyWith({
    _is.UuidValue? id,
    String? key,
    String? email,
    String? subject,
    String? body,
    int? attempts,
    DateTime? availableAt,
    DateTime? deliveredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InstitutionMailRecord',
      if (id != null) 'id': id?.toJson(),
      'key': key,
      'email': email,
      'subject': subject,
      'body': body,
      'attempts': attempts,
      'availableAt': availableAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static InstitutionMailRecordInclude include() {
    return InstitutionMailRecordInclude._();
  }

  static InstitutionMailRecordIncludeList includeList({
    _is.WhereExpressionBuilder<InstitutionMailRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InstitutionMailRecordTable>? orderBy,
    _is.OrderByListBuilder<InstitutionMailRecordTable>? orderByList,
    InstitutionMailRecordInclude? include,
  }) {
    return InstitutionMailRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InstitutionMailRecord.t),
      orderByList: orderByList?.call(InstitutionMailRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InstitutionMailRecordImpl extends InstitutionMailRecord {
  _InstitutionMailRecordImpl({
    _is.UuidValue? id,
    required String key,
    required String email,
    required String subject,
    required String body,
    int? attempts,
    DateTime? availableAt,
    DateTime? deliveredAt,
  }) : super._(
         id: id,
         key: key,
         email: email,
         subject: subject,
         body: body,
         attempts: attempts,
         availableAt: availableAt,
         deliveredAt: deliveredAt,
       );

  /// Returns a shallow copy of this [InstitutionMailRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  InstitutionMailRecord copyWith({
    Object? id = _Undefined,
    String? key,
    String? email,
    String? subject,
    String? body,
    int? attempts,
    DateTime? availableAt,
    Object? deliveredAt = _Undefined,
  }) {
    return InstitutionMailRecord(
      id: id is _is.UuidValue? ? id : this.id,
      key: key ?? this.key,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      attempts: attempts ?? this.attempts,
      availableAt: availableAt ?? this.availableAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
    );
  }
}

class InstitutionMailRecordUpdateTable
    extends _is.UpdateTable<InstitutionMailRecordTable> {
  InstitutionMailRecordUpdateTable(super.table);

  _is.ColumnValue<String, String> key(String value) => _is.ColumnValue(
    table.key,
    value,
  );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> subject(String value) => _is.ColumnValue(
    table.subject,
    value,
  );

  _is.ColumnValue<String, String> body(String value) => _is.ColumnValue(
    table.body,
    value,
  );

  _is.ColumnValue<int, int> attempts(int value) => _is.ColumnValue(
    table.attempts,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> availableAt(DateTime value) =>
      _is.ColumnValue(
        table.availableAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> deliveredAt(DateTime? value) =>
      _is.ColumnValue(
        table.deliveredAt,
        value,
      );
}

class InstitutionMailRecordTable extends _is.Table<_is.UuidValue?> {
  InstitutionMailRecordTable({super.tableRelation})
    : super(tableName: 'poodle_institution_mail') {
    updateTable = InstitutionMailRecordUpdateTable(this);
    key = _is.ColumnString(
      'key',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    subject = _is.ColumnString(
      'subject',
      this,
    );
    body = _is.ColumnString(
      'body',
      this,
    );
    attempts = _is.ColumnInt(
      'attempts',
      this,
      hasDefault: true,
    );
    availableAt = _is.ColumnDateTime(
      'availableAt',
      this,
    );
    deliveredAt = _is.ColumnDateTime(
      'deliveredAt',
      this,
    );
  }

  late final InstitutionMailRecordUpdateTable updateTable;

  late final _is.ColumnString key;

  late final _is.ColumnString email;

  late final _is.ColumnString subject;

  late final _is.ColumnString body;

  late final _is.ColumnInt attempts;

  late final _is.ColumnDateTime availableAt;

  late final _is.ColumnDateTime deliveredAt;

  @override
  List<_is.Column> get columns => [
    id,
    key,
    email,
    subject,
    body,
    attempts,
    availableAt,
    deliveredAt,
  ];
}

class InstitutionMailRecordInclude extends _is.IncludeObject {
  InstitutionMailRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => InstitutionMailRecord.t;
}

class InstitutionMailRecordIncludeList extends _is.IncludeList {
  InstitutionMailRecordIncludeList._({
    _is.WhereExpressionBuilder<InstitutionMailRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(InstitutionMailRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => InstitutionMailRecord.t;
}

class InstitutionMailRecordRepository {
  const InstitutionMailRecordRepository._();

  /// Returns a list of [InstitutionMailRecord]s matching the given query parameters.
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
  Future<List<InstitutionMailRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InstitutionMailRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InstitutionMailRecordTable>? orderBy,
    _is.OrderByListBuilder<InstitutionMailRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<InstitutionMailRecord>(
      where: where?.call(InstitutionMailRecord.t),
      orderBy: orderBy?.call(InstitutionMailRecord.t),
      orderByList: orderByList?.call(InstitutionMailRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [InstitutionMailRecord] matching the given query parameters.
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
  Future<InstitutionMailRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InstitutionMailRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<InstitutionMailRecordTable>? orderBy,
    _is.OrderByListBuilder<InstitutionMailRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<InstitutionMailRecord>(
      where: where?.call(InstitutionMailRecord.t),
      orderBy: orderBy?.call(InstitutionMailRecord.t),
      orderByList: orderByList?.call(InstitutionMailRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [InstitutionMailRecord] by its [id] or null if no such row exists.
  Future<InstitutionMailRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<InstitutionMailRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [InstitutionMailRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [InstitutionMailRecord]s will have their `id` fields set.
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
  Future<List<InstitutionMailRecord>> insert(
    _is.DatabaseSession session,
    List<InstitutionMailRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<InstitutionMailRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [InstitutionMailRecord] and returns the inserted row.
  ///
  /// The returned [InstitutionMailRecord] will have its `id` field set.
  Future<InstitutionMailRecord> insertRow(
    _is.DatabaseSession session,
    InstitutionMailRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<InstitutionMailRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [InstitutionMailRecord]s in the list and returns the resulting rows.
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
  /// The returned [InstitutionMailRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<InstitutionMailRecord>> upsert(
    _is.DatabaseSession session,
    List<InstitutionMailRecord> rows, {
    required _is.ColumnSelections<InstitutionMailRecordTable> conflictColumns,
    _is.ColumnSelections<InstitutionMailRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<InstitutionMailRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<InstitutionMailRecord>(
      rows,
      conflictColumns: conflictColumns(InstitutionMailRecord.t),
      updateColumns: updateColumns?.call(InstitutionMailRecord.t),
      updateWhere: updateWhere?.call(InstitutionMailRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [InstitutionMailRecord] and returns the resulting row.
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
  /// The returned [InstitutionMailRecord] will have its `id` field set.
  Future<InstitutionMailRecord?> upsertRow(
    _is.DatabaseSession session,
    InstitutionMailRecord row, {
    required _is.ColumnSelections<InstitutionMailRecordTable> conflictColumns,
    _is.ColumnSelections<InstitutionMailRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<InstitutionMailRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<InstitutionMailRecord>(
      row,
      conflictColumns: conflictColumns(InstitutionMailRecord.t),
      updateColumns: updateColumns?.call(InstitutionMailRecord.t),
      updateWhere: updateWhere?.call(InstitutionMailRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [InstitutionMailRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<InstitutionMailRecord>> update(
    _is.DatabaseSession session,
    List<InstitutionMailRecord> rows, {
    _is.ColumnSelections<InstitutionMailRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<InstitutionMailRecord>(
      rows,
      columns: columns?.call(InstitutionMailRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [InstitutionMailRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<InstitutionMailRecord> updateRow(
    _is.DatabaseSession session,
    InstitutionMailRecord row, {
    _is.ColumnSelections<InstitutionMailRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<InstitutionMailRecord>(
      row,
      columns: columns?.call(InstitutionMailRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [InstitutionMailRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<InstitutionMailRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<InstitutionMailRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<InstitutionMailRecord>(
      id,
      columnValues: columnValues(InstitutionMailRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [InstitutionMailRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<InstitutionMailRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<InstitutionMailRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<InstitutionMailRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InstitutionMailRecordTable>? orderBy,
    _is.OrderByListBuilder<InstitutionMailRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<InstitutionMailRecord>(
      columnValues: columnValues(InstitutionMailRecord.t.updateTable),
      where: where(InstitutionMailRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InstitutionMailRecord.t),
      orderByList: orderByList?.call(InstitutionMailRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [InstitutionMailRecord]s in the list and returns the deleted rows.
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
  Future<List<InstitutionMailRecord>> delete(
    _is.DatabaseSession session,
    List<InstitutionMailRecord> rows, {
    _is.OrderByBuilder<InstitutionMailRecordTable>? orderBy,
    _is.OrderByListBuilder<InstitutionMailRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<InstitutionMailRecord>(
      rows,
      orderBy: orderBy?.call(InstitutionMailRecord.t),
      orderByList: orderByList?.call(InstitutionMailRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [InstitutionMailRecord].
  Future<InstitutionMailRecord> deleteRow(
    _is.DatabaseSession session,
    InstitutionMailRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<InstitutionMailRecord>(
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
  Future<List<InstitutionMailRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<InstitutionMailRecordTable> where,
    _is.OrderByBuilder<InstitutionMailRecordTable>? orderBy,
    _is.OrderByListBuilder<InstitutionMailRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<InstitutionMailRecord>(
      where: where(InstitutionMailRecord.t),
      orderBy: orderBy?.call(InstitutionMailRecord.t),
      orderByList: orderByList?.call(InstitutionMailRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InstitutionMailRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<InstitutionMailRecord>(
      where: where?.call(InstitutionMailRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [InstitutionMailRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<InstitutionMailRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<InstitutionMailRecord>(
      where: where(InstitutionMailRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
