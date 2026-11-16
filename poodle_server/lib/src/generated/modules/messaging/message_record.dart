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

abstract class MessageRecord
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  MessageRecord._({
    this.id,
    required this.conversationId,
    required this.senderId,
    required this.clientSendId,
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory MessageRecord({
    int? id,
    required _is.UuidValue conversationId,
    required _is.UuidValue senderId,
    required _is.UuidValue clientSendId,
    required String text,
    DateTime? createdAt,
  }) = _MessageRecordImpl;

  factory MessageRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return MessageRecord(
      id: jsonSerialization['id'] as int?,
      conversationId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['conversationId'],
      ),
      senderId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['senderId'],
      ),
      clientSendId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clientSendId'],
      ),
      text: jsonSerialization['text'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = MessageRecordTable();

  static const db = MessageRecordRepository._();

  @override
  int? id;

  _is.UuidValue conversationId;

  _is.UuidValue senderId;

  _is.UuidValue clientSendId;

  String text;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [MessageRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MessageRecord copyWith({
    int? id,
    _is.UuidValue? conversationId,
    _is.UuidValue? senderId,
    _is.UuidValue? clientSendId,
    String? text,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MessageRecord',
      if (id != null) 'id': id,
      'conversationId': conversationId.toJson(),
      'senderId': senderId.toJson(),
      'clientSendId': clientSendId.toJson(),
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static MessageRecordInclude include() {
    return MessageRecordInclude._();
  }

  static MessageRecordIncludeList includeList({
    _is.WhereExpressionBuilder<MessageRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MessageRecordTable>? orderBy,
    _is.OrderByListBuilder<MessageRecordTable>? orderByList,
    MessageRecordInclude? include,
  }) {
    return MessageRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MessageRecord.t),
      orderByList: orderByList?.call(MessageRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MessageRecordImpl extends MessageRecord {
  _MessageRecordImpl({
    int? id,
    required _is.UuidValue conversationId,
    required _is.UuidValue senderId,
    required _is.UuidValue clientSendId,
    required String text,
    DateTime? createdAt,
  }) : super._(
         id: id,
         conversationId: conversationId,
         senderId: senderId,
         clientSendId: clientSendId,
         text: text,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MessageRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MessageRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? conversationId,
    _is.UuidValue? senderId,
    _is.UuidValue? clientSendId,
    String? text,
    DateTime? createdAt,
  }) {
    return MessageRecord(
      id: id is int? ? id : this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      clientSendId: clientSendId ?? this.clientSendId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class MessageRecordUpdateTable extends _is.UpdateTable<MessageRecordTable> {
  MessageRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> conversationId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.conversationId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> senderId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.senderId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> clientSendId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.clientSendId,
    value,
  );

  _is.ColumnValue<String, String> text(String value) => _is.ColumnValue(
    table.text,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class MessageRecordTable extends _is.Table<int?> {
  MessageRecordTable({super.tableRelation})
    : super(tableName: 'poodle_message') {
    updateTable = MessageRecordUpdateTable(this);
    conversationId = _is.ColumnUuid(
      'conversationId',
      this,
    );
    senderId = _is.ColumnUuid(
      'senderId',
      this,
    );
    clientSendId = _is.ColumnUuid(
      'clientSendId',
      this,
    );
    text = _is.ColumnString(
      'text',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final MessageRecordUpdateTable updateTable;

  late final _is.ColumnUuid conversationId;

  late final _is.ColumnUuid senderId;

  late final _is.ColumnUuid clientSendId;

  late final _is.ColumnString text;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    conversationId,
    senderId,
    clientSendId,
    text,
    createdAt,
  ];
}

class MessageRecordInclude extends _is.IncludeObject {
  MessageRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => MessageRecord.t;
}

class MessageRecordIncludeList extends _is.IncludeList {
  MessageRecordIncludeList._({
    _is.WhereExpressionBuilder<MessageRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MessageRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => MessageRecord.t;
}

class MessageRecordRepository {
  const MessageRecordRepository._();

  /// Returns a list of [MessageRecord]s matching the given query parameters.
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
  Future<List<MessageRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MessageRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MessageRecordTable>? orderBy,
    _is.OrderByListBuilder<MessageRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MessageRecord>(
      where: where?.call(MessageRecord.t),
      orderBy: orderBy?.call(MessageRecord.t),
      orderByList: orderByList?.call(MessageRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MessageRecord] matching the given query parameters.
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
  Future<MessageRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MessageRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<MessageRecordTable>? orderBy,
    _is.OrderByListBuilder<MessageRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MessageRecord>(
      where: where?.call(MessageRecord.t),
      orderBy: orderBy?.call(MessageRecord.t),
      orderByList: orderByList?.call(MessageRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MessageRecord] by its [id] or null if no such row exists.
  Future<MessageRecord?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MessageRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MessageRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [MessageRecord]s will have their `id` fields set.
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
  Future<List<MessageRecord>> insert(
    _is.DatabaseSession session,
    List<MessageRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<MessageRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [MessageRecord] and returns the inserted row.
  ///
  /// The returned [MessageRecord] will have its `id` field set.
  Future<MessageRecord> insertRow(
    _is.DatabaseSession session,
    MessageRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<MessageRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [MessageRecord]s in the list and returns the resulting rows.
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
  /// The returned [MessageRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MessageRecord>> upsert(
    _is.DatabaseSession session,
    List<MessageRecord> rows, {
    required _is.ColumnSelections<MessageRecordTable> conflictColumns,
    _is.ColumnSelections<MessageRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<MessageRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<MessageRecord>(
      rows,
      conflictColumns: conflictColumns(MessageRecord.t),
      updateColumns: updateColumns?.call(MessageRecord.t),
      updateWhere: updateWhere?.call(MessageRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [MessageRecord] and returns the resulting row.
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
  /// The returned [MessageRecord] will have its `id` field set.
  Future<MessageRecord?> upsertRow(
    _is.DatabaseSession session,
    MessageRecord row, {
    required _is.ColumnSelections<MessageRecordTable> conflictColumns,
    _is.ColumnSelections<MessageRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<MessageRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<MessageRecord>(
      row,
      conflictColumns: conflictColumns(MessageRecord.t),
      updateColumns: updateColumns?.call(MessageRecord.t),
      updateWhere: updateWhere?.call(MessageRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [MessageRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MessageRecord>> update(
    _is.DatabaseSession session,
    List<MessageRecord> rows, {
    _is.ColumnSelections<MessageRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<MessageRecord>(
      rows,
      columns: columns?.call(MessageRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [MessageRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MessageRecord> updateRow(
    _is.DatabaseSession session,
    MessageRecord row, {
    _is.ColumnSelections<MessageRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<MessageRecord>(
      row,
      columns: columns?.call(MessageRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MessageRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MessageRecord?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MessageRecordUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<MessageRecord>(
      id,
      columnValues: columnValues(MessageRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MessageRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MessageRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MessageRecordUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<MessageRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MessageRecordTable>? orderBy,
    _is.OrderByListBuilder<MessageRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<MessageRecord>(
      columnValues: columnValues(MessageRecord.t.updateTable),
      where: where(MessageRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MessageRecord.t),
      orderByList: orderByList?.call(MessageRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [MessageRecord]s in the list and returns the deleted rows.
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
  Future<List<MessageRecord>> delete(
    _is.DatabaseSession session,
    List<MessageRecord> rows, {
    _is.OrderByBuilder<MessageRecordTable>? orderBy,
    _is.OrderByListBuilder<MessageRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<MessageRecord>(
      rows,
      orderBy: orderBy?.call(MessageRecord.t),
      orderByList: orderByList?.call(MessageRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [MessageRecord].
  Future<MessageRecord> deleteRow(
    _is.DatabaseSession session,
    MessageRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MessageRecord>(
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
  Future<List<MessageRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MessageRecordTable> where,
    _is.OrderByBuilder<MessageRecordTable>? orderBy,
    _is.OrderByListBuilder<MessageRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<MessageRecord>(
      where: where(MessageRecord.t),
      orderBy: orderBy?.call(MessageRecord.t),
      orderByList: orderByList?.call(MessageRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MessageRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<MessageRecord>(
      where: where?.call(MessageRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MessageRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MessageRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MessageRecord>(
      where: where(MessageRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
