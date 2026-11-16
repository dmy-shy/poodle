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
import '../../modules/identity/university_record.dart' as _ig96r09j;

/// Platform and university authority; teacher/student roles remain course-scoped.
abstract class AccountAccess
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AccountAccess._({
    this.id,
    required this.authUserId,
    this.authUser,
    bool? isAdmin,
    this.universityId,
    this.university,
    bool? isUniversityAdmin,
    bool? teacherApproved,
    bool? developmentBootstrap,
    this.developmentPersona,
    this.verifiedEmail,
    int? credentialVersion,
    DateTime? createdAt,
  }) : isAdmin = isAdmin ?? false,
       isUniversityAdmin = isUniversityAdmin ?? false,
       teacherApproved = teacherApproved ?? false,
       developmentBootstrap = developmentBootstrap ?? false,
       credentialVersion = credentialVersion ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory AccountAccess({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    bool? isAdmin,
    _is.UuidValue? universityId,
    _ig96r09j.UniversityRecord? university,
    bool? isUniversityAdmin,
    bool? teacherApproved,
    bool? developmentBootstrap,
    String? developmentPersona,
    String? verifiedEmail,
    int? credentialVersion,
    DateTime? createdAt,
  }) = _AccountAccessImpl;

  factory AccountAccess.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountAccess(
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
      isAdmin: jsonSerialization['isAdmin'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isAdmin']),
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
      isUniversityAdmin: jsonSerialization['isUniversityAdmin'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['isUniversityAdmin'],
            ),
      teacherApproved: jsonSerialization['teacherApproved'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['teacherApproved'],
            ),
      developmentBootstrap: jsonSerialization['developmentBootstrap'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['developmentBootstrap'],
            ),
      developmentPersona: jsonSerialization['developmentPersona'] as String?,
      verifiedEmail: jsonSerialization['verifiedEmail'] as String?,
      credentialVersion: jsonSerialization['credentialVersion'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AccountAccessTable();

  static const db = AccountAccessRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  _iacs.AuthUser? authUser;

  bool isAdmin;

  _is.UuidValue? universityId;

  _ig96r09j.UniversityRecord? university;

  bool isUniversityAdmin;

  bool teacherApproved;

  bool developmentBootstrap;

  String? developmentPersona;

  /// Canonical address shown by Poodle. Provider addresses may change independently.
  String? verifiedEmail;

  /// Invalidates pending account-security operations after a credential change.
  int credentialVersion;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AccountAccess]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AccountAccess copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    bool? isAdmin,
    _is.UuidValue? universityId,
    _ig96r09j.UniversityRecord? university,
    bool? isUniversityAdmin,
    bool? teacherApproved,
    bool? developmentBootstrap,
    String? developmentPersona,
    String? verifiedEmail,
    int? credentialVersion,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountAccess',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'isAdmin': isAdmin,
      if (universityId != null) 'universityId': universityId?.toJson(),
      if (university != null) 'university': university?.toJson(),
      'isUniversityAdmin': isUniversityAdmin,
      'teacherApproved': teacherApproved,
      'developmentBootstrap': developmentBootstrap,
      if (developmentPersona != null) 'developmentPersona': developmentPersona,
      if (verifiedEmail != null) 'verifiedEmail': verifiedEmail,
      'credentialVersion': credentialVersion,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AccountAccessInclude include({
    _iacs.AuthUserInclude? authUser,
    _ig96r09j.UniversityRecordInclude? university,
  }) {
    return AccountAccessInclude._(
      authUser: authUser,
      university: university,
    );
  }

  static AccountAccessIncludeList includeList({
    _is.WhereExpressionBuilder<AccountAccessTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    AccountAccessInclude? include,
  }) {
    return AccountAccessIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountAccessImpl extends AccountAccess {
  _AccountAccessImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    bool? isAdmin,
    _is.UuidValue? universityId,
    _ig96r09j.UniversityRecord? university,
    bool? isUniversityAdmin,
    bool? teacherApproved,
    bool? developmentBootstrap,
    String? developmentPersona,
    String? verifiedEmail,
    int? credentialVersion,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         isAdmin: isAdmin,
         universityId: universityId,
         university: university,
         isUniversityAdmin: isUniversityAdmin,
         teacherApproved: teacherApproved,
         developmentBootstrap: developmentBootstrap,
         developmentPersona: developmentPersona,
         verifiedEmail: verifiedEmail,
         credentialVersion: credentialVersion,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AccountAccess]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AccountAccess copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    bool? isAdmin,
    Object? universityId = _Undefined,
    Object? university = _Undefined,
    bool? isUniversityAdmin,
    bool? teacherApproved,
    bool? developmentBootstrap,
    Object? developmentPersona = _Undefined,
    Object? verifiedEmail = _Undefined,
    int? credentialVersion,
    DateTime? createdAt,
  }) {
    return AccountAccess(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      isAdmin: isAdmin ?? this.isAdmin,
      universityId: universityId is _is.UuidValue?
          ? universityId
          : this.universityId,
      university: university is _ig96r09j.UniversityRecord?
          ? university
          : this.university?.copyWith(),
      isUniversityAdmin: isUniversityAdmin ?? this.isUniversityAdmin,
      teacherApproved: teacherApproved ?? this.teacherApproved,
      developmentBootstrap: developmentBootstrap ?? this.developmentBootstrap,
      developmentPersona: developmentPersona is String?
          ? developmentPersona
          : this.developmentPersona,
      verifiedEmail: verifiedEmail is String?
          ? verifiedEmail
          : this.verifiedEmail,
      credentialVersion: credentialVersion ?? this.credentialVersion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AccountAccessUpdateTable extends _is.UpdateTable<AccountAccessTable> {
  AccountAccessUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<bool, bool> isAdmin(bool value) => _is.ColumnValue(
    table.isAdmin,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> universityId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.universityId,
    value,
  );

  _is.ColumnValue<bool, bool> isUniversityAdmin(bool value) => _is.ColumnValue(
    table.isUniversityAdmin,
    value,
  );

  _is.ColumnValue<bool, bool> teacherApproved(bool value) => _is.ColumnValue(
    table.teacherApproved,
    value,
  );

  _is.ColumnValue<bool, bool> developmentBootstrap(bool value) =>
      _is.ColumnValue(
        table.developmentBootstrap,
        value,
      );

  _is.ColumnValue<String, String> developmentPersona(String? value) =>
      _is.ColumnValue(
        table.developmentPersona,
        value,
      );

  _is.ColumnValue<String, String> verifiedEmail(String? value) =>
      _is.ColumnValue(
        table.verifiedEmail,
        value,
      );

  _is.ColumnValue<int, int> credentialVersion(int value) => _is.ColumnValue(
    table.credentialVersion,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AccountAccessTable extends _is.Table<_is.UuidValue?> {
  AccountAccessTable({super.tableRelation})
    : super(tableName: 'poodle_account_access') {
    updateTable = AccountAccessUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    isAdmin = _is.ColumnBool(
      'isAdmin',
      this,
      hasDefault: true,
    );
    universityId = _is.ColumnUuid(
      'universityId',
      this,
    );
    isUniversityAdmin = _is.ColumnBool(
      'isUniversityAdmin',
      this,
      hasDefault: true,
    );
    teacherApproved = _is.ColumnBool(
      'teacherApproved',
      this,
      hasDefault: true,
    );
    developmentBootstrap = _is.ColumnBool(
      'developmentBootstrap',
      this,
      hasDefault: true,
    );
    developmentPersona = _is.ColumnString(
      'developmentPersona',
      this,
    );
    verifiedEmail = _is.ColumnString(
      'verifiedEmail',
      this,
    );
    credentialVersion = _is.ColumnInt(
      'credentialVersion',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AccountAccessUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  _iacs.AuthUserTable? _authUser;

  late final _is.ColumnBool isAdmin;

  late final _is.ColumnUuid universityId;

  _ig96r09j.UniversityRecordTable? _university;

  late final _is.ColumnBool isUniversityAdmin;

  late final _is.ColumnBool teacherApproved;

  late final _is.ColumnBool developmentBootstrap;

  late final _is.ColumnString developmentPersona;

  /// Canonical address shown by Poodle. Provider addresses may change independently.
  late final _is.ColumnString verifiedEmail;

  /// Invalidates pending account-security operations after a credential change.
  late final _is.ColumnInt credentialVersion;

  late final _is.ColumnDateTime createdAt;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: AccountAccess.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  _ig96r09j.UniversityRecordTable get university {
    if (_university != null) return _university!;
    _university = _is.createRelationTable(
      relationFieldName: 'university',
      field: AccountAccess.t.universityId,
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
    authUserId,
    isAdmin,
    universityId,
    isUniversityAdmin,
    teacherApproved,
    developmentBootstrap,
    developmentPersona,
    verifiedEmail,
    credentialVersion,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    if (relationField == 'university') {
      return university;
    }
    return null;
  }
}

class AccountAccessInclude extends _is.IncludeObject {
  AccountAccessInclude._({
    _iacs.AuthUserInclude? authUser,
    _ig96r09j.UniversityRecordInclude? university,
  }) {
    _authUser = authUser;
    _university = university;
  }

  _iacs.AuthUserInclude? _authUser;

  _ig96r09j.UniversityRecordInclude? _university;

  @override
  Map<String, _is.Include?> get includes => {
    'authUser': _authUser,
    'university': _university,
  };

  @override
  _is.Table<_is.UuidValue?> get table => AccountAccess.t;
}

class AccountAccessIncludeList extends _is.IncludeList {
  AccountAccessIncludeList._({
    _is.WhereExpressionBuilder<AccountAccessTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountAccess.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AccountAccess.t;
}

class AccountAccessRepository {
  const AccountAccessRepository._();

  final attachRow = const AccountAccessAttachRowRepository._();

  final detachRow = const AccountAccessDetachRowRepository._();

  /// Returns a list of [AccountAccess]s matching the given query parameters.
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
  Future<List<AccountAccess>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountAccessTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    _is.Transaction? transaction,
    AccountAccessInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountAccess>(
      where: where?.call(AccountAccess.t),
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountAccess] matching the given query parameters.
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
  Future<AccountAccess?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountAccessTable>? where,
    int? offset,
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    _is.Transaction? transaction,
    AccountAccessInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountAccess>(
      where: where?.call(AccountAccess.t),
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountAccess] by its [id] or null if no such row exists.
  Future<AccountAccess?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    AccountAccessInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountAccess>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountAccess]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountAccess]s will have their `id` fields set.
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
  Future<List<AccountAccess>> insert(
    _is.DatabaseSession session,
    List<AccountAccess> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AccountAccess>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AccountAccess] and returns the inserted row.
  ///
  /// The returned [AccountAccess] will have its `id` field set.
  Future<AccountAccess> insertRow(
    _is.DatabaseSession session,
    AccountAccess row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountAccess>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AccountAccess]s in the list and returns the resulting rows.
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
  /// The returned [AccountAccess]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountAccess>> upsert(
    _is.DatabaseSession session,
    List<AccountAccess> rows, {
    required _is.ColumnSelections<AccountAccessTable> conflictColumns,
    _is.ColumnSelections<AccountAccessTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountAccessTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AccountAccess>(
      rows,
      conflictColumns: conflictColumns(AccountAccess.t),
      updateColumns: updateColumns?.call(AccountAccess.t),
      updateWhere: updateWhere?.call(AccountAccess.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AccountAccess] and returns the resulting row.
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
  /// The returned [AccountAccess] will have its `id` field set.
  Future<AccountAccess?> upsertRow(
    _is.DatabaseSession session,
    AccountAccess row, {
    required _is.ColumnSelections<AccountAccessTable> conflictColumns,
    _is.ColumnSelections<AccountAccessTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountAccessTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AccountAccess>(
      row,
      conflictColumns: conflictColumns(AccountAccess.t),
      updateColumns: updateColumns?.call(AccountAccess.t),
      updateWhere: updateWhere?.call(AccountAccess.t),
      transaction: transaction,
    );
  }

  /// Updates all [AccountAccess]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountAccess>> update(
    _is.DatabaseSession session,
    List<AccountAccess> rows, {
    _is.ColumnSelections<AccountAccessTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AccountAccess>(
      rows,
      columns: columns?.call(AccountAccess.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AccountAccess]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountAccess> updateRow(
    _is.DatabaseSession session,
    AccountAccess row, {
    _is.ColumnSelections<AccountAccessTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountAccess>(
      row,
      columns: columns?.call(AccountAccess.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountAccess] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountAccess?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AccountAccessUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountAccess>(
      id,
      columnValues: columnValues(AccountAccess.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountAccess]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountAccess>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AccountAccessUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AccountAccessTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AccountAccess>(
      columnValues: columnValues(AccountAccess.t.updateTable),
      where: where(AccountAccess.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AccountAccess]s in the list and returns the deleted rows.
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
  Future<List<AccountAccess>> delete(
    _is.DatabaseSession session,
    List<AccountAccess> rows, {
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AccountAccess>(
      rows,
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AccountAccess].
  Future<AccountAccess> deleteRow(
    _is.DatabaseSession session,
    AccountAccess row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountAccess>(
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
  Future<List<AccountAccess>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountAccessTable> where,
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AccountAccess>(
      where: where(AccountAccess.t),
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountAccessTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AccountAccess>(
      where: where?.call(AccountAccess.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountAccess] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountAccessTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountAccess>(
      where: where(AccountAccess.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AccountAccessAttachRowRepository {
  const AccountAccessAttachRowRepository._();

  /// Creates a relation between the given [AccountAccess] and [AuthUser]
  /// by setting the [AccountAccess]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    AccountAccess accountAccess,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (accountAccess.id == null) {
      throw ArgumentError.notNull('accountAccess.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $accountAccess = accountAccess.copyWith(authUserId: authUser.id);
    await session.db.updateRow<AccountAccess>(
      $accountAccess,
      columns: [AccountAccess.t.authUserId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AccountAccess] and [UniversityRecord]
  /// by setting the [AccountAccess]'s foreign key `universityId` to refer to the [UniversityRecord].
  Future<void> university(
    _is.DatabaseSession session,
    AccountAccess accountAccess,
    _ig96r09j.UniversityRecord university, {
    _is.Transaction? transaction,
  }) async {
    if (accountAccess.id == null) {
      throw ArgumentError.notNull('accountAccess.id');
    }
    if (university.id == null) {
      throw ArgumentError.notNull('university.id');
    }

    var $accountAccess = accountAccess.copyWith(universityId: university.id);
    await session.db.updateRow<AccountAccess>(
      $accountAccess,
      columns: [AccountAccess.t.universityId],
      transaction: transaction,
    );
  }
}

class AccountAccessDetachRowRepository {
  const AccountAccessDetachRowRepository._();

  /// Detaches the relation between this [AccountAccess] and the [UniversityRecord] set in `university`
  /// by setting the [AccountAccess]'s foreign key `universityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> university(
    _is.DatabaseSession session,
    AccountAccess accountAccess, {
    _is.Transaction? transaction,
  }) async {
    if (accountAccess.id == null) {
      throw ArgumentError.notNull('accountAccess.id');
    }

    var $accountAccess = accountAccess.copyWith(universityId: null);
    await session.db.updateRow<AccountAccess>(
      $accountAccess,
      columns: [AccountAccess.t.universityId],
      transaction: transaction,
    );
  }
}
