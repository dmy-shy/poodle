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
import '../../modules/identity/university_record.dart' as _ig96r09j;

/// Single-use, email-bound invitation for platform, university or course access.
abstract class AccountInvitation
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AccountInvitation._({
    this.id,
    required this.email,
    required this.purpose,
    this.universityId,
    this.university,
    this.courseId,
    this.course,
    this.issuerId,
    this.issuer,
    DateTime? createdAt,
    required this.expiresAt,
    this.acceptedAt,
    this.acceptedById,
    this.acceptedBy,
    this.revokedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AccountInvitation({
    _is.UuidValue? id,
    required String email,
    required String purpose,
    _is.UuidValue? universityId,
    _ig96r09j.UniversityRecord? university,
    _is.UuidValue? courseId,
    _i7rr55u6.CourseRecord? course,
    _is.UuidValue? issuerId,
    _iacs.AuthUser? issuer,
    DateTime? createdAt,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    _is.UuidValue? acceptedById,
    _iacs.AuthUser? acceptedBy,
    DateTime? revokedAt,
  }) = _AccountInvitationImpl;

  factory AccountInvitation.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountInvitation(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      email: jsonSerialization['email'] as String,
      purpose: jsonSerialization['purpose'] as String,
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
      courseId: jsonSerialization['courseId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['courseId']),
      course: jsonSerialization['course'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_i7rr55u6.CourseRecord>(
              jsonSerialization['course'],
            ),
      issuerId: jsonSerialization['issuerId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['issuerId']),
      issuer: jsonSerialization['issuer'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['issuer'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
      acceptedById: jsonSerialization['acceptedById'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['acceptedById'],
            ),
      acceptedBy: jsonSerialization['acceptedBy'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['acceptedBy'],
            ),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
    );
  }

  static final t = AccountInvitationTable();

  static const db = AccountInvitationRepository._();

  @override
  _is.UuidValue? id;

  String email;

  String purpose;

  _is.UuidValue? universityId;

  _ig96r09j.UniversityRecord? university;

  _is.UuidValue? courseId;

  _i7rr55u6.CourseRecord? course;

  _is.UuidValue? issuerId;

  _iacs.AuthUser? issuer;

  DateTime createdAt;

  DateTime expiresAt;

  DateTime? acceptedAt;

  _is.UuidValue? acceptedById;

  _iacs.AuthUser? acceptedBy;

  DateTime? revokedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AccountInvitation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AccountInvitation copyWith({
    _is.UuidValue? id,
    String? email,
    String? purpose,
    _is.UuidValue? universityId,
    _ig96r09j.UniversityRecord? university,
    _is.UuidValue? courseId,
    _i7rr55u6.CourseRecord? course,
    _is.UuidValue? issuerId,
    _iacs.AuthUser? issuer,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    _is.UuidValue? acceptedById,
    _iacs.AuthUser? acceptedBy,
    DateTime? revokedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountInvitation',
      if (id != null) 'id': id?.toJson(),
      'email': email,
      'purpose': purpose,
      if (universityId != null) 'universityId': universityId?.toJson(),
      if (university != null) 'university': university?.toJson(),
      if (courseId != null) 'courseId': courseId?.toJson(),
      if (course != null) 'course': course?.toJson(),
      if (issuerId != null) 'issuerId': issuerId?.toJson(),
      if (issuer != null) 'issuer': issuer?.toJson(),
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (acceptedById != null) 'acceptedById': acceptedById?.toJson(),
      if (acceptedBy != null) 'acceptedBy': acceptedBy?.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AccountInvitationInclude include({
    _ig96r09j.UniversityRecordInclude? university,
    _i7rr55u6.CourseRecordInclude? course,
    _iacs.AuthUserInclude? issuer,
    _iacs.AuthUserInclude? acceptedBy,
  }) {
    return AccountInvitationInclude._(
      university: university,
      course: course,
      issuer: issuer,
      acceptedBy: acceptedBy,
    );
  }

  static AccountInvitationIncludeList includeList({
    _is.WhereExpressionBuilder<AccountInvitationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountInvitationTable>? orderBy,
    _is.OrderByListBuilder<AccountInvitationTable>? orderByList,
    AccountInvitationInclude? include,
  }) {
    return AccountInvitationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountInvitation.t),
      orderByList: orderByList?.call(AccountInvitation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountInvitationImpl extends AccountInvitation {
  _AccountInvitationImpl({
    _is.UuidValue? id,
    required String email,
    required String purpose,
    _is.UuidValue? universityId,
    _ig96r09j.UniversityRecord? university,
    _is.UuidValue? courseId,
    _i7rr55u6.CourseRecord? course,
    _is.UuidValue? issuerId,
    _iacs.AuthUser? issuer,
    DateTime? createdAt,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    _is.UuidValue? acceptedById,
    _iacs.AuthUser? acceptedBy,
    DateTime? revokedAt,
  }) : super._(
         id: id,
         email: email,
         purpose: purpose,
         universityId: universityId,
         university: university,
         courseId: courseId,
         course: course,
         issuerId: issuerId,
         issuer: issuer,
         createdAt: createdAt,
         expiresAt: expiresAt,
         acceptedAt: acceptedAt,
         acceptedById: acceptedById,
         acceptedBy: acceptedBy,
         revokedAt: revokedAt,
       );

  /// Returns a shallow copy of this [AccountInvitation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AccountInvitation copyWith({
    Object? id = _Undefined,
    String? email,
    String? purpose,
    Object? universityId = _Undefined,
    Object? university = _Undefined,
    Object? courseId = _Undefined,
    Object? course = _Undefined,
    Object? issuerId = _Undefined,
    Object? issuer = _Undefined,
    DateTime? createdAt,
    DateTime? expiresAt,
    Object? acceptedAt = _Undefined,
    Object? acceptedById = _Undefined,
    Object? acceptedBy = _Undefined,
    Object? revokedAt = _Undefined,
  }) {
    return AccountInvitation(
      id: id is _is.UuidValue? ? id : this.id,
      email: email ?? this.email,
      purpose: purpose ?? this.purpose,
      universityId: universityId is _is.UuidValue?
          ? universityId
          : this.universityId,
      university: university is _ig96r09j.UniversityRecord?
          ? university
          : this.university?.copyWith(),
      courseId: courseId is _is.UuidValue? ? courseId : this.courseId,
      course: course is _i7rr55u6.CourseRecord?
          ? course
          : this.course?.copyWith(),
      issuerId: issuerId is _is.UuidValue? ? issuerId : this.issuerId,
      issuer: issuer is _iacs.AuthUser? ? issuer : this.issuer?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
      acceptedById: acceptedById is _is.UuidValue?
          ? acceptedById
          : this.acceptedById,
      acceptedBy: acceptedBy is _iacs.AuthUser?
          ? acceptedBy
          : this.acceptedBy?.copyWith(),
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
    );
  }
}

class AccountInvitationUpdateTable
    extends _is.UpdateTable<AccountInvitationTable> {
  AccountInvitationUpdateTable(super.table);

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> purpose(String value) => _is.ColumnValue(
    table.purpose,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> universityId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.universityId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> courseId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.courseId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> issuerId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.issuerId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> acceptedAt(DateTime? value) =>
      _is.ColumnValue(
        table.acceptedAt,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> acceptedById(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.acceptedById,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> revokedAt(DateTime? value) =>
      _is.ColumnValue(
        table.revokedAt,
        value,
      );
}

class AccountInvitationTable extends _is.Table<_is.UuidValue?> {
  AccountInvitationTable({super.tableRelation})
    : super(tableName: 'poodle_account_invitation') {
    updateTable = AccountInvitationUpdateTable(this);
    email = _is.ColumnString(
      'email',
      this,
    );
    purpose = _is.ColumnString(
      'purpose',
      this,
    );
    universityId = _is.ColumnUuid(
      'universityId',
      this,
    );
    courseId = _is.ColumnUuid(
      'courseId',
      this,
    );
    issuerId = _is.ColumnUuid(
      'issuerId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    acceptedAt = _is.ColumnDateTime(
      'acceptedAt',
      this,
    );
    acceptedById = _is.ColumnUuid(
      'acceptedById',
      this,
    );
    revokedAt = _is.ColumnDateTime(
      'revokedAt',
      this,
    );
  }

  late final AccountInvitationUpdateTable updateTable;

  late final _is.ColumnString email;

  late final _is.ColumnString purpose;

  late final _is.ColumnUuid universityId;

  _ig96r09j.UniversityRecordTable? _university;

  late final _is.ColumnUuid courseId;

  _i7rr55u6.CourseRecordTable? _course;

  late final _is.ColumnUuid issuerId;

  _iacs.AuthUserTable? _issuer;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime acceptedAt;

  late final _is.ColumnUuid acceptedById;

  _iacs.AuthUserTable? _acceptedBy;

  late final _is.ColumnDateTime revokedAt;

  _ig96r09j.UniversityRecordTable get university {
    if (_university != null) return _university!;
    _university = _is.createRelationTable(
      relationFieldName: 'university',
      field: AccountInvitation.t.universityId,
      foreignField: _ig96r09j.UniversityRecord.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ig96r09j.UniversityRecordTable(tableRelation: foreignTableRelation),
    );
    return _university!;
  }

  _i7rr55u6.CourseRecordTable get course {
    if (_course != null) return _course!;
    _course = _is.createRelationTable(
      relationFieldName: 'course',
      field: AccountInvitation.t.courseId,
      foreignField: _i7rr55u6.CourseRecord.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7rr55u6.CourseRecordTable(tableRelation: foreignTableRelation),
    );
    return _course!;
  }

  _iacs.AuthUserTable get issuer {
    if (_issuer != null) return _issuer!;
    _issuer = _is.createRelationTable(
      relationFieldName: 'issuer',
      field: AccountInvitation.t.issuerId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _issuer!;
  }

  _iacs.AuthUserTable get acceptedBy {
    if (_acceptedBy != null) return _acceptedBy!;
    _acceptedBy = _is.createRelationTable(
      relationFieldName: 'acceptedBy',
      field: AccountInvitation.t.acceptedById,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _acceptedBy!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    email,
    purpose,
    universityId,
    courseId,
    issuerId,
    createdAt,
    expiresAt,
    acceptedAt,
    acceptedById,
    revokedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'university') {
      return university;
    }
    if (relationField == 'course') {
      return course;
    }
    if (relationField == 'issuer') {
      return issuer;
    }
    if (relationField == 'acceptedBy') {
      return acceptedBy;
    }
    return null;
  }
}

class AccountInvitationInclude extends _is.IncludeObject {
  AccountInvitationInclude._({
    _ig96r09j.UniversityRecordInclude? university,
    _i7rr55u6.CourseRecordInclude? course,
    _iacs.AuthUserInclude? issuer,
    _iacs.AuthUserInclude? acceptedBy,
  }) {
    _university = university;
    _course = course;
    _issuer = issuer;
    _acceptedBy = acceptedBy;
  }

  _ig96r09j.UniversityRecordInclude? _university;

  _i7rr55u6.CourseRecordInclude? _course;

  _iacs.AuthUserInclude? _issuer;

  _iacs.AuthUserInclude? _acceptedBy;

  @override
  Map<String, _is.Include?> get includes => {
    'university': _university,
    'course': _course,
    'issuer': _issuer,
    'acceptedBy': _acceptedBy,
  };

  @override
  _is.Table<_is.UuidValue?> get table => AccountInvitation.t;
}

class AccountInvitationIncludeList extends _is.IncludeList {
  AccountInvitationIncludeList._({
    _is.WhereExpressionBuilder<AccountInvitationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountInvitation.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AccountInvitation.t;
}

class AccountInvitationRepository {
  const AccountInvitationRepository._();

  final attachRow = const AccountInvitationAttachRowRepository._();

  final detachRow = const AccountInvitationDetachRowRepository._();

  /// Returns a list of [AccountInvitation]s matching the given query parameters.
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
  Future<List<AccountInvitation>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountInvitationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountInvitationTable>? orderBy,
    _is.OrderByListBuilder<AccountInvitationTable>? orderByList,
    _is.Transaction? transaction,
    AccountInvitationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountInvitation>(
      where: where?.call(AccountInvitation.t),
      orderBy: orderBy?.call(AccountInvitation.t),
      orderByList: orderByList?.call(AccountInvitation.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountInvitation] matching the given query parameters.
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
  Future<AccountInvitation?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountInvitationTable>? where,
    int? offset,
    _is.OrderByBuilder<AccountInvitationTable>? orderBy,
    _is.OrderByListBuilder<AccountInvitationTable>? orderByList,
    _is.Transaction? transaction,
    AccountInvitationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountInvitation>(
      where: where?.call(AccountInvitation.t),
      orderBy: orderBy?.call(AccountInvitation.t),
      orderByList: orderByList?.call(AccountInvitation.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountInvitation] by its [id] or null if no such row exists.
  Future<AccountInvitation?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    AccountInvitationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountInvitation>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountInvitation]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountInvitation]s will have their `id` fields set.
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
  Future<List<AccountInvitation>> insert(
    _is.DatabaseSession session,
    List<AccountInvitation> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AccountInvitation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AccountInvitation] and returns the inserted row.
  ///
  /// The returned [AccountInvitation] will have its `id` field set.
  Future<AccountInvitation> insertRow(
    _is.DatabaseSession session,
    AccountInvitation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountInvitation>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AccountInvitation]s in the list and returns the resulting rows.
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
  /// The returned [AccountInvitation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountInvitation>> upsert(
    _is.DatabaseSession session,
    List<AccountInvitation> rows, {
    required _is.ColumnSelections<AccountInvitationTable> conflictColumns,
    _is.ColumnSelections<AccountInvitationTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountInvitationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AccountInvitation>(
      rows,
      conflictColumns: conflictColumns(AccountInvitation.t),
      updateColumns: updateColumns?.call(AccountInvitation.t),
      updateWhere: updateWhere?.call(AccountInvitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AccountInvitation] and returns the resulting row.
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
  /// The returned [AccountInvitation] will have its `id` field set.
  Future<AccountInvitation?> upsertRow(
    _is.DatabaseSession session,
    AccountInvitation row, {
    required _is.ColumnSelections<AccountInvitationTable> conflictColumns,
    _is.ColumnSelections<AccountInvitationTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountInvitationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AccountInvitation>(
      row,
      conflictColumns: conflictColumns(AccountInvitation.t),
      updateColumns: updateColumns?.call(AccountInvitation.t),
      updateWhere: updateWhere?.call(AccountInvitation.t),
      transaction: transaction,
    );
  }

  /// Updates all [AccountInvitation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountInvitation>> update(
    _is.DatabaseSession session,
    List<AccountInvitation> rows, {
    _is.ColumnSelections<AccountInvitationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AccountInvitation>(
      rows,
      columns: columns?.call(AccountInvitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AccountInvitation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountInvitation> updateRow(
    _is.DatabaseSession session,
    AccountInvitation row, {
    _is.ColumnSelections<AccountInvitationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountInvitation>(
      row,
      columns: columns?.call(AccountInvitation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountInvitation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountInvitation?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AccountInvitationUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountInvitation>(
      id,
      columnValues: columnValues(AccountInvitation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountInvitation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountInvitation>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AccountInvitationUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AccountInvitationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountInvitationTable>? orderBy,
    _is.OrderByListBuilder<AccountInvitationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AccountInvitation>(
      columnValues: columnValues(AccountInvitation.t.updateTable),
      where: where(AccountInvitation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountInvitation.t),
      orderByList: orderByList?.call(AccountInvitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AccountInvitation]s in the list and returns the deleted rows.
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
  Future<List<AccountInvitation>> delete(
    _is.DatabaseSession session,
    List<AccountInvitation> rows, {
    _is.OrderByBuilder<AccountInvitationTable>? orderBy,
    _is.OrderByListBuilder<AccountInvitationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AccountInvitation>(
      rows,
      orderBy: orderBy?.call(AccountInvitation.t),
      orderByList: orderByList?.call(AccountInvitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AccountInvitation].
  Future<AccountInvitation> deleteRow(
    _is.DatabaseSession session,
    AccountInvitation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountInvitation>(
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
  Future<List<AccountInvitation>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountInvitationTable> where,
    _is.OrderByBuilder<AccountInvitationTable>? orderBy,
    _is.OrderByListBuilder<AccountInvitationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AccountInvitation>(
      where: where(AccountInvitation.t),
      orderBy: orderBy?.call(AccountInvitation.t),
      orderByList: orderByList?.call(AccountInvitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountInvitationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AccountInvitation>(
      where: where?.call(AccountInvitation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountInvitation] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountInvitationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountInvitation>(
      where: where(AccountInvitation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AccountInvitationAttachRowRepository {
  const AccountInvitationAttachRowRepository._();

  /// Creates a relation between the given [AccountInvitation] and [UniversityRecord]
  /// by setting the [AccountInvitation]'s foreign key `universityId` to refer to the [UniversityRecord].
  Future<void> university(
    _is.DatabaseSession session,
    AccountInvitation accountInvitation,
    _ig96r09j.UniversityRecord university, {
    _is.Transaction? transaction,
  }) async {
    if (accountInvitation.id == null) {
      throw ArgumentError.notNull('accountInvitation.id');
    }
    if (university.id == null) {
      throw ArgumentError.notNull('university.id');
    }

    var $accountInvitation = accountInvitation.copyWith(
      universityId: university.id,
    );
    await session.db.updateRow<AccountInvitation>(
      $accountInvitation,
      columns: [AccountInvitation.t.universityId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AccountInvitation] and [CourseRecord]
  /// by setting the [AccountInvitation]'s foreign key `courseId` to refer to the [CourseRecord].
  Future<void> course(
    _is.DatabaseSession session,
    AccountInvitation accountInvitation,
    _i7rr55u6.CourseRecord course, {
    _is.Transaction? transaction,
  }) async {
    if (accountInvitation.id == null) {
      throw ArgumentError.notNull('accountInvitation.id');
    }
    if (course.id == null) {
      throw ArgumentError.notNull('course.id');
    }

    var $accountInvitation = accountInvitation.copyWith(courseId: course.id);
    await session.db.updateRow<AccountInvitation>(
      $accountInvitation,
      columns: [AccountInvitation.t.courseId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AccountInvitation] and [AuthUser]
  /// by setting the [AccountInvitation]'s foreign key `issuerId` to refer to the [AuthUser].
  Future<void> issuer(
    _is.DatabaseSession session,
    AccountInvitation accountInvitation,
    _iacs.AuthUser issuer, {
    _is.Transaction? transaction,
  }) async {
    if (accountInvitation.id == null) {
      throw ArgumentError.notNull('accountInvitation.id');
    }
    if (issuer.id == null) {
      throw ArgumentError.notNull('issuer.id');
    }

    var $accountInvitation = accountInvitation.copyWith(issuerId: issuer.id);
    await session.db.updateRow<AccountInvitation>(
      $accountInvitation,
      columns: [AccountInvitation.t.issuerId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AccountInvitation] and [AuthUser]
  /// by setting the [AccountInvitation]'s foreign key `acceptedById` to refer to the [AuthUser].
  Future<void> acceptedBy(
    _is.DatabaseSession session,
    AccountInvitation accountInvitation,
    _iacs.AuthUser acceptedBy, {
    _is.Transaction? transaction,
  }) async {
    if (accountInvitation.id == null) {
      throw ArgumentError.notNull('accountInvitation.id');
    }
    if (acceptedBy.id == null) {
      throw ArgumentError.notNull('acceptedBy.id');
    }

    var $accountInvitation = accountInvitation.copyWith(
      acceptedById: acceptedBy.id,
    );
    await session.db.updateRow<AccountInvitation>(
      $accountInvitation,
      columns: [AccountInvitation.t.acceptedById],
      transaction: transaction,
    );
  }
}

class AccountInvitationDetachRowRepository {
  const AccountInvitationDetachRowRepository._();

  /// Detaches the relation between this [AccountInvitation] and the [UniversityRecord] set in `university`
  /// by setting the [AccountInvitation]'s foreign key `universityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> university(
    _is.DatabaseSession session,
    AccountInvitation accountInvitation, {
    _is.Transaction? transaction,
  }) async {
    if (accountInvitation.id == null) {
      throw ArgumentError.notNull('accountInvitation.id');
    }

    var $accountInvitation = accountInvitation.copyWith(universityId: null);
    await session.db.updateRow<AccountInvitation>(
      $accountInvitation,
      columns: [AccountInvitation.t.universityId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [AccountInvitation] and the [CourseRecord] set in `course`
  /// by setting the [AccountInvitation]'s foreign key `courseId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> course(
    _is.DatabaseSession session,
    AccountInvitation accountInvitation, {
    _is.Transaction? transaction,
  }) async {
    if (accountInvitation.id == null) {
      throw ArgumentError.notNull('accountInvitation.id');
    }

    var $accountInvitation = accountInvitation.copyWith(courseId: null);
    await session.db.updateRow<AccountInvitation>(
      $accountInvitation,
      columns: [AccountInvitation.t.courseId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [AccountInvitation] and the [AuthUser] set in `issuer`
  /// by setting the [AccountInvitation]'s foreign key `issuerId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> issuer(
    _is.DatabaseSession session,
    AccountInvitation accountInvitation, {
    _is.Transaction? transaction,
  }) async {
    if (accountInvitation.id == null) {
      throw ArgumentError.notNull('accountInvitation.id');
    }

    var $accountInvitation = accountInvitation.copyWith(issuerId: null);
    await session.db.updateRow<AccountInvitation>(
      $accountInvitation,
      columns: [AccountInvitation.t.issuerId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [AccountInvitation] and the [AuthUser] set in `acceptedBy`
  /// by setting the [AccountInvitation]'s foreign key `acceptedById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> acceptedBy(
    _is.DatabaseSession session,
    AccountInvitation accountInvitation, {
    _is.Transaction? transaction,
  }) async {
    if (accountInvitation.id == null) {
      throw ArgumentError.notNull('accountInvitation.id');
    }

    var $accountInvitation = accountInvitation.copyWith(acceptedById: null);
    await session.db.updateRow<AccountInvitation>(
      $accountInvitation,
      columns: [AccountInvitation.t.acceptedById],
      transaction: transaction,
    );
  }
}
