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

/// A short-lived, server-only proof to replace a Poodle account email.
abstract class PendingEmailChange
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PendingEmailChange._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.requestedEmail,
    required this.verificationCodeHash,
    required this.credentialVersion,
    required this.expiresAt,
    required this.resendAvailableAt,
    int? verificationAttempts,
    String? locale,
    DateTime? createdAt,
  }) : verificationAttempts = verificationAttempts ?? 0,
       locale = locale ?? 'en',
       createdAt = createdAt ?? DateTime.now();

  factory PendingEmailChange({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String requestedEmail,
    required String verificationCodeHash,
    required int credentialVersion,
    required DateTime expiresAt,
    required DateTime resendAvailableAt,
    int? verificationAttempts,
    String? locale,
    DateTime? createdAt,
  }) = _PendingEmailChangeImpl;

  factory PendingEmailChange.fromJson(Map<String, dynamic> jsonSerialization) {
    return PendingEmailChange(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      requestedEmail: jsonSerialization['requestedEmail'] as String,
      verificationCodeHash: jsonSerialization['verificationCodeHash'] as String,
      credentialVersion: jsonSerialization['credentialVersion'] as int,
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      resendAvailableAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['resendAvailableAt'],
      ),
      verificationAttempts: jsonSerialization['verificationAttempts'] as int?,
      locale: jsonSerialization['locale'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = PendingEmailChangeTable();

  static const db = PendingEmailChangeRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  _iacs.AuthUser? authUser;

  String requestedEmail;

  String verificationCodeHash;

  int credentialVersion;

  DateTime expiresAt;

  DateTime resendAvailableAt;

  int verificationAttempts;

  String locale;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PendingEmailChange]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PendingEmailChange copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    String? requestedEmail,
    String? verificationCodeHash,
    int? credentialVersion,
    DateTime? expiresAt,
    DateTime? resendAvailableAt,
    int? verificationAttempts,
    String? locale,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PendingEmailChange',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'requestedEmail': requestedEmail,
      'verificationCodeHash': verificationCodeHash,
      'credentialVersion': credentialVersion,
      'expiresAt': expiresAt.toJson(),
      'resendAvailableAt': resendAvailableAt.toJson(),
      'verificationAttempts': verificationAttempts,
      'locale': locale,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PendingEmailChangeInclude include({_iacs.AuthUserInclude? authUser}) {
    return PendingEmailChangeInclude._(authUser: authUser);
  }

  static PendingEmailChangeIncludeList includeList({
    _is.WhereExpressionBuilder<PendingEmailChangeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PendingEmailChangeTable>? orderBy,
    _is.OrderByListBuilder<PendingEmailChangeTable>? orderByList,
    PendingEmailChangeInclude? include,
  }) {
    return PendingEmailChangeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PendingEmailChange.t),
      orderByList: orderByList?.call(PendingEmailChange.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PendingEmailChangeImpl extends PendingEmailChange {
  _PendingEmailChangeImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String requestedEmail,
    required String verificationCodeHash,
    required int credentialVersion,
    required DateTime expiresAt,
    required DateTime resendAvailableAt,
    int? verificationAttempts,
    String? locale,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         requestedEmail: requestedEmail,
         verificationCodeHash: verificationCodeHash,
         credentialVersion: credentialVersion,
         expiresAt: expiresAt,
         resendAvailableAt: resendAvailableAt,
         verificationAttempts: verificationAttempts,
         locale: locale,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PendingEmailChange]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PendingEmailChange copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? requestedEmail,
    String? verificationCodeHash,
    int? credentialVersion,
    DateTime? expiresAt,
    DateTime? resendAvailableAt,
    int? verificationAttempts,
    String? locale,
    DateTime? createdAt,
  }) {
    return PendingEmailChange(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      requestedEmail: requestedEmail ?? this.requestedEmail,
      verificationCodeHash: verificationCodeHash ?? this.verificationCodeHash,
      credentialVersion: credentialVersion ?? this.credentialVersion,
      expiresAt: expiresAt ?? this.expiresAt,
      resendAvailableAt: resendAvailableAt ?? this.resendAvailableAt,
      verificationAttempts: verificationAttempts ?? this.verificationAttempts,
      locale: locale ?? this.locale,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PendingEmailChangeUpdateTable
    extends _is.UpdateTable<PendingEmailChangeTable> {
  PendingEmailChangeUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> requestedEmail(String value) =>
      _is.ColumnValue(
        table.requestedEmail,
        value,
      );

  _is.ColumnValue<String, String> verificationCodeHash(String value) =>
      _is.ColumnValue(
        table.verificationCodeHash,
        value,
      );

  _is.ColumnValue<int, int> credentialVersion(int value) => _is.ColumnValue(
    table.credentialVersion,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> resendAvailableAt(DateTime value) =>
      _is.ColumnValue(
        table.resendAvailableAt,
        value,
      );

  _is.ColumnValue<int, int> verificationAttempts(int value) => _is.ColumnValue(
    table.verificationAttempts,
    value,
  );

  _is.ColumnValue<String, String> locale(String value) => _is.ColumnValue(
    table.locale,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class PendingEmailChangeTable extends _is.Table<_is.UuidValue?> {
  PendingEmailChangeTable({super.tableRelation})
    : super(tableName: 'poodle_pending_email_change') {
    updateTable = PendingEmailChangeUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    requestedEmail = _is.ColumnString(
      'requestedEmail',
      this,
    );
    verificationCodeHash = _is.ColumnString(
      'verificationCodeHash',
      this,
    );
    credentialVersion = _is.ColumnInt(
      'credentialVersion',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    resendAvailableAt = _is.ColumnDateTime(
      'resendAvailableAt',
      this,
    );
    verificationAttempts = _is.ColumnInt(
      'verificationAttempts',
      this,
      hasDefault: true,
    );
    locale = _is.ColumnString(
      'locale',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final PendingEmailChangeUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  _iacs.AuthUserTable? _authUser;

  late final _is.ColumnString requestedEmail;

  late final _is.ColumnString verificationCodeHash;

  late final _is.ColumnInt credentialVersion;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime resendAvailableAt;

  late final _is.ColumnInt verificationAttempts;

  late final _is.ColumnString locale;

  late final _is.ColumnDateTime createdAt;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: PendingEmailChange.t.authUserId,
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
    authUserId,
    requestedEmail,
    verificationCodeHash,
    credentialVersion,
    expiresAt,
    resendAvailableAt,
    verificationAttempts,
    locale,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class PendingEmailChangeInclude extends _is.IncludeObject {
  PendingEmailChangeInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<_is.UuidValue?> get table => PendingEmailChange.t;
}

class PendingEmailChangeIncludeList extends _is.IncludeList {
  PendingEmailChangeIncludeList._({
    _is.WhereExpressionBuilder<PendingEmailChangeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PendingEmailChange.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PendingEmailChange.t;
}

class PendingEmailChangeRepository {
  const PendingEmailChangeRepository._();

  final attachRow = const PendingEmailChangeAttachRowRepository._();

  /// Returns a list of [PendingEmailChange]s matching the given query parameters.
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
  Future<List<PendingEmailChange>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PendingEmailChangeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PendingEmailChangeTable>? orderBy,
    _is.OrderByListBuilder<PendingEmailChangeTable>? orderByList,
    _is.Transaction? transaction,
    PendingEmailChangeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PendingEmailChange>(
      where: where?.call(PendingEmailChange.t),
      orderBy: orderBy?.call(PendingEmailChange.t),
      orderByList: orderByList?.call(PendingEmailChange.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PendingEmailChange] matching the given query parameters.
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
  Future<PendingEmailChange?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PendingEmailChangeTable>? where,
    int? offset,
    _is.OrderByBuilder<PendingEmailChangeTable>? orderBy,
    _is.OrderByListBuilder<PendingEmailChangeTable>? orderByList,
    _is.Transaction? transaction,
    PendingEmailChangeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PendingEmailChange>(
      where: where?.call(PendingEmailChange.t),
      orderBy: orderBy?.call(PendingEmailChange.t),
      orderByList: orderByList?.call(PendingEmailChange.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PendingEmailChange] by its [id] or null if no such row exists.
  Future<PendingEmailChange?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    PendingEmailChangeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PendingEmailChange>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PendingEmailChange]s in the list and returns the inserted rows.
  ///
  /// The returned [PendingEmailChange]s will have their `id` fields set.
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
  Future<List<PendingEmailChange>> insert(
    _is.DatabaseSession session,
    List<PendingEmailChange> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PendingEmailChange>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PendingEmailChange] and returns the inserted row.
  ///
  /// The returned [PendingEmailChange] will have its `id` field set.
  Future<PendingEmailChange> insertRow(
    _is.DatabaseSession session,
    PendingEmailChange row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PendingEmailChange>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PendingEmailChange]s in the list and returns the resulting rows.
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
  /// The returned [PendingEmailChange]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PendingEmailChange>> upsert(
    _is.DatabaseSession session,
    List<PendingEmailChange> rows, {
    required _is.ColumnSelections<PendingEmailChangeTable> conflictColumns,
    _is.ColumnSelections<PendingEmailChangeTable>? updateColumns,
    _is.WhereExpressionBuilder<PendingEmailChangeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PendingEmailChange>(
      rows,
      conflictColumns: conflictColumns(PendingEmailChange.t),
      updateColumns: updateColumns?.call(PendingEmailChange.t),
      updateWhere: updateWhere?.call(PendingEmailChange.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PendingEmailChange] and returns the resulting row.
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
  /// The returned [PendingEmailChange] will have its `id` field set.
  Future<PendingEmailChange?> upsertRow(
    _is.DatabaseSession session,
    PendingEmailChange row, {
    required _is.ColumnSelections<PendingEmailChangeTable> conflictColumns,
    _is.ColumnSelections<PendingEmailChangeTable>? updateColumns,
    _is.WhereExpressionBuilder<PendingEmailChangeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PendingEmailChange>(
      row,
      conflictColumns: conflictColumns(PendingEmailChange.t),
      updateColumns: updateColumns?.call(PendingEmailChange.t),
      updateWhere: updateWhere?.call(PendingEmailChange.t),
      transaction: transaction,
    );
  }

  /// Updates all [PendingEmailChange]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PendingEmailChange>> update(
    _is.DatabaseSession session,
    List<PendingEmailChange> rows, {
    _is.ColumnSelections<PendingEmailChangeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PendingEmailChange>(
      rows,
      columns: columns?.call(PendingEmailChange.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PendingEmailChange]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PendingEmailChange> updateRow(
    _is.DatabaseSession session,
    PendingEmailChange row, {
    _is.ColumnSelections<PendingEmailChangeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PendingEmailChange>(
      row,
      columns: columns?.call(PendingEmailChange.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PendingEmailChange] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PendingEmailChange?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PendingEmailChangeUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PendingEmailChange>(
      id,
      columnValues: columnValues(PendingEmailChange.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PendingEmailChange]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PendingEmailChange>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PendingEmailChangeUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<PendingEmailChangeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PendingEmailChangeTable>? orderBy,
    _is.OrderByListBuilder<PendingEmailChangeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PendingEmailChange>(
      columnValues: columnValues(PendingEmailChange.t.updateTable),
      where: where(PendingEmailChange.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PendingEmailChange.t),
      orderByList: orderByList?.call(PendingEmailChange.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PendingEmailChange]s in the list and returns the deleted rows.
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
  Future<List<PendingEmailChange>> delete(
    _is.DatabaseSession session,
    List<PendingEmailChange> rows, {
    _is.OrderByBuilder<PendingEmailChangeTable>? orderBy,
    _is.OrderByListBuilder<PendingEmailChangeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PendingEmailChange>(
      rows,
      orderBy: orderBy?.call(PendingEmailChange.t),
      orderByList: orderByList?.call(PendingEmailChange.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PendingEmailChange].
  Future<PendingEmailChange> deleteRow(
    _is.DatabaseSession session,
    PendingEmailChange row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PendingEmailChange>(
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
  Future<List<PendingEmailChange>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PendingEmailChangeTable> where,
    _is.OrderByBuilder<PendingEmailChangeTable>? orderBy,
    _is.OrderByListBuilder<PendingEmailChangeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PendingEmailChange>(
      where: where(PendingEmailChange.t),
      orderBy: orderBy?.call(PendingEmailChange.t),
      orderByList: orderByList?.call(PendingEmailChange.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PendingEmailChangeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PendingEmailChange>(
      where: where?.call(PendingEmailChange.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PendingEmailChange] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PendingEmailChangeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PendingEmailChange>(
      where: where(PendingEmailChange.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PendingEmailChangeAttachRowRepository {
  const PendingEmailChangeAttachRowRepository._();

  /// Creates a relation between the given [PendingEmailChange] and [AuthUser]
  /// by setting the [PendingEmailChange]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    PendingEmailChange pendingEmailChange,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (pendingEmailChange.id == null) {
      throw ArgumentError.notNull('pendingEmailChange.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $pendingEmailChange = pendingEmailChange.copyWith(
      authUserId: authUser.id,
    );
    await session.db.updateRow<PendingEmailChange>(
      $pendingEmailChange,
      columns: [PendingEmailChange.t.authUserId],
      transaction: transaction,
    );
  }
}
