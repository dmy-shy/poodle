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

abstract class AdministratorRequestRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AdministratorRequestRecord._({
    _is.UuidValue? id,
    required this.name,
    required this.email,
    required this.university,
    required this.position,
    required this.note,
    required this.locale,
    String? status,
    required this.codeHash,
    int? attempts,
    required this.expiresAt,
    DateTime? createdAt,
    this.verifiedAt,
    this.reviewedAt,
    this.reviewerId,
    this.reviewer,
    this.reviewNote,
    this.approvedUniversityId,
    this.approvedUniversity,
  }) : id = id ?? const _is.Uuid().v7obj(),
       status = status ?? 'unverified',
       attempts = attempts ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory AdministratorRequestRecord({
    _is.UuidValue? id,
    required String name,
    required String email,
    required String university,
    required String position,
    required String note,
    required String locale,
    String? status,
    required String codeHash,
    int? attempts,
    required DateTime expiresAt,
    DateTime? createdAt,
    DateTime? verifiedAt,
    DateTime? reviewedAt,
    _is.UuidValue? reviewerId,
    _iacs.AuthUser? reviewer,
    String? reviewNote,
    _is.UuidValue? approvedUniversityId,
    _ig96r09j.UniversityRecord? approvedUniversity,
  }) = _AdministratorRequestRecordImpl;

  factory AdministratorRequestRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdministratorRequestRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String,
      university: jsonSerialization['university'] as String,
      position: jsonSerialization['position'] as String,
      note: jsonSerialization['note'] as String,
      locale: jsonSerialization['locale'] as String,
      status: jsonSerialization['status'] as String?,
      codeHash: jsonSerialization['codeHash'] as String,
      attempts: jsonSerialization['attempts'] as int?,
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['verifiedAt']),
      reviewedAt: jsonSerialization['reviewedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['reviewedAt']),
      reviewerId: jsonSerialization['reviewerId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['reviewerId'],
            ),
      reviewer: jsonSerialization['reviewer'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['reviewer'],
            ),
      reviewNote: jsonSerialization['reviewNote'] as String?,
      approvedUniversityId: jsonSerialization['approvedUniversityId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['approvedUniversityId'],
            ),
      approvedUniversity: jsonSerialization['approvedUniversity'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_ig96r09j.UniversityRecord>(
              jsonSerialization['approvedUniversity'],
            ),
    );
  }

  static final t = AdministratorRequestRecordTable();

  static const db = AdministratorRequestRecordRepository._();

  @override
  _is.UuidValue? id;

  String name;

  String email;

  String university;

  String position;

  String note;

  String locale;

  String status;

  String codeHash;

  int attempts;

  DateTime expiresAt;

  DateTime createdAt;

  DateTime? verifiedAt;

  DateTime? reviewedAt;

  _is.UuidValue? reviewerId;

  _iacs.AuthUser? reviewer;

  String? reviewNote;

  _is.UuidValue? approvedUniversityId;

  _ig96r09j.UniversityRecord? approvedUniversity;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AdministratorRequestRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdministratorRequestRecord copyWith({
    _is.UuidValue? id,
    String? name,
    String? email,
    String? university,
    String? position,
    String? note,
    String? locale,
    String? status,
    String? codeHash,
    int? attempts,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? verifiedAt,
    DateTime? reviewedAt,
    _is.UuidValue? reviewerId,
    _iacs.AuthUser? reviewer,
    String? reviewNote,
    _is.UuidValue? approvedUniversityId,
    _ig96r09j.UniversityRecord? approvedUniversity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdministratorRequestRecord',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'email': email,
      'university': university,
      'position': position,
      'note': note,
      'locale': locale,
      'status': status,
      'codeHash': codeHash,
      'attempts': attempts,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      if (reviewedAt != null) 'reviewedAt': reviewedAt?.toJson(),
      if (reviewerId != null) 'reviewerId': reviewerId?.toJson(),
      if (reviewer != null) 'reviewer': reviewer?.toJson(),
      if (reviewNote != null) 'reviewNote': reviewNote,
      if (approvedUniversityId != null)
        'approvedUniversityId': approvedUniversityId?.toJson(),
      if (approvedUniversity != null)
        'approvedUniversity': approvedUniversity?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AdministratorRequestRecordInclude include({
    _iacs.AuthUserInclude? reviewer,
    _ig96r09j.UniversityRecordInclude? approvedUniversity,
  }) {
    return AdministratorRequestRecordInclude._(
      reviewer: reviewer,
      approvedUniversity: approvedUniversity,
    );
  }

  static AdministratorRequestRecordIncludeList includeList({
    _is.WhereExpressionBuilder<AdministratorRequestRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdministratorRequestRecordTable>? orderBy,
    _is.OrderByListBuilder<AdministratorRequestRecordTable>? orderByList,
    AdministratorRequestRecordInclude? include,
  }) {
    return AdministratorRequestRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdministratorRequestRecord.t),
      orderByList: orderByList?.call(AdministratorRequestRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdministratorRequestRecordImpl extends AdministratorRequestRecord {
  _AdministratorRequestRecordImpl({
    _is.UuidValue? id,
    required String name,
    required String email,
    required String university,
    required String position,
    required String note,
    required String locale,
    String? status,
    required String codeHash,
    int? attempts,
    required DateTime expiresAt,
    DateTime? createdAt,
    DateTime? verifiedAt,
    DateTime? reviewedAt,
    _is.UuidValue? reviewerId,
    _iacs.AuthUser? reviewer,
    String? reviewNote,
    _is.UuidValue? approvedUniversityId,
    _ig96r09j.UniversityRecord? approvedUniversity,
  }) : super._(
         id: id,
         name: name,
         email: email,
         university: university,
         position: position,
         note: note,
         locale: locale,
         status: status,
         codeHash: codeHash,
         attempts: attempts,
         expiresAt: expiresAt,
         createdAt: createdAt,
         verifiedAt: verifiedAt,
         reviewedAt: reviewedAt,
         reviewerId: reviewerId,
         reviewer: reviewer,
         reviewNote: reviewNote,
         approvedUniversityId: approvedUniversityId,
         approvedUniversity: approvedUniversity,
       );

  /// Returns a shallow copy of this [AdministratorRequestRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdministratorRequestRecord copyWith({
    Object? id = _Undefined,
    String? name,
    String? email,
    String? university,
    String? position,
    String? note,
    String? locale,
    String? status,
    String? codeHash,
    int? attempts,
    DateTime? expiresAt,
    DateTime? createdAt,
    Object? verifiedAt = _Undefined,
    Object? reviewedAt = _Undefined,
    Object? reviewerId = _Undefined,
    Object? reviewer = _Undefined,
    Object? reviewNote = _Undefined,
    Object? approvedUniversityId = _Undefined,
    Object? approvedUniversity = _Undefined,
  }) {
    return AdministratorRequestRecord(
      id: id is _is.UuidValue? ? id : this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      university: university ?? this.university,
      position: position ?? this.position,
      note: note ?? this.note,
      locale: locale ?? this.locale,
      status: status ?? this.status,
      codeHash: codeHash ?? this.codeHash,
      attempts: attempts ?? this.attempts,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      verifiedAt: verifiedAt is DateTime? ? verifiedAt : this.verifiedAt,
      reviewedAt: reviewedAt is DateTime? ? reviewedAt : this.reviewedAt,
      reviewerId: reviewerId is _is.UuidValue? ? reviewerId : this.reviewerId,
      reviewer: reviewer is _iacs.AuthUser?
          ? reviewer
          : this.reviewer?.copyWith(),
      reviewNote: reviewNote is String? ? reviewNote : this.reviewNote,
      approvedUniversityId: approvedUniversityId is _is.UuidValue?
          ? approvedUniversityId
          : this.approvedUniversityId,
      approvedUniversity: approvedUniversity is _ig96r09j.UniversityRecord?
          ? approvedUniversity
          : this.approvedUniversity?.copyWith(),
    );
  }
}

class AdministratorRequestRecordUpdateTable
    extends _is.UpdateTable<AdministratorRequestRecordTable> {
  AdministratorRequestRecordUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> university(String value) => _is.ColumnValue(
    table.university,
    value,
  );

  _is.ColumnValue<String, String> position(String value) => _is.ColumnValue(
    table.position,
    value,
  );

  _is.ColumnValue<String, String> note(String value) => _is.ColumnValue(
    table.note,
    value,
  );

  _is.ColumnValue<String, String> locale(String value) => _is.ColumnValue(
    table.locale,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> codeHash(String value) => _is.ColumnValue(
    table.codeHash,
    value,
  );

  _is.ColumnValue<int, int> attempts(int value) => _is.ColumnValue(
    table.attempts,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> verifiedAt(DateTime? value) =>
      _is.ColumnValue(
        table.verifiedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> reviewedAt(DateTime? value) =>
      _is.ColumnValue(
        table.reviewedAt,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> reviewerId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.reviewerId,
    value,
  );

  _is.ColumnValue<String, String> reviewNote(String? value) => _is.ColumnValue(
    table.reviewNote,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> approvedUniversityId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.approvedUniversityId,
    value,
  );
}

class AdministratorRequestRecordTable extends _is.Table<_is.UuidValue?> {
  AdministratorRequestRecordTable({super.tableRelation})
    : super(tableName: 'poodle_administrator_request') {
    updateTable = AdministratorRequestRecordUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    university = _is.ColumnString(
      'university',
      this,
    );
    position = _is.ColumnString(
      'position',
      this,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
    locale = _is.ColumnString(
      'locale',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    codeHash = _is.ColumnString(
      'codeHash',
      this,
    );
    attempts = _is.ColumnInt(
      'attempts',
      this,
      hasDefault: true,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    verifiedAt = _is.ColumnDateTime(
      'verifiedAt',
      this,
    );
    reviewedAt = _is.ColumnDateTime(
      'reviewedAt',
      this,
    );
    reviewerId = _is.ColumnUuid(
      'reviewerId',
      this,
    );
    reviewNote = _is.ColumnString(
      'reviewNote',
      this,
    );
    approvedUniversityId = _is.ColumnUuid(
      'approvedUniversityId',
      this,
    );
  }

  late final AdministratorRequestRecordUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString email;

  late final _is.ColumnString university;

  late final _is.ColumnString position;

  late final _is.ColumnString note;

  late final _is.ColumnString locale;

  late final _is.ColumnString status;

  late final _is.ColumnString codeHash;

  late final _is.ColumnInt attempts;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime verifiedAt;

  late final _is.ColumnDateTime reviewedAt;

  late final _is.ColumnUuid reviewerId;

  _iacs.AuthUserTable? _reviewer;

  late final _is.ColumnString reviewNote;

  late final _is.ColumnUuid approvedUniversityId;

  _ig96r09j.UniversityRecordTable? _approvedUniversity;

  _iacs.AuthUserTable get reviewer {
    if (_reviewer != null) return _reviewer!;
    _reviewer = _is.createRelationTable(
      relationFieldName: 'reviewer',
      field: AdministratorRequestRecord.t.reviewerId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _reviewer!;
  }

  _ig96r09j.UniversityRecordTable get approvedUniversity {
    if (_approvedUniversity != null) return _approvedUniversity!;
    _approvedUniversity = _is.createRelationTable(
      relationFieldName: 'approvedUniversity',
      field: AdministratorRequestRecord.t.approvedUniversityId,
      foreignField: _ig96r09j.UniversityRecord.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ig96r09j.UniversityRecordTable(tableRelation: foreignTableRelation),
    );
    return _approvedUniversity!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    email,
    university,
    position,
    note,
    locale,
    status,
    codeHash,
    attempts,
    expiresAt,
    createdAt,
    verifiedAt,
    reviewedAt,
    reviewerId,
    reviewNote,
    approvedUniversityId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'reviewer') {
      return reviewer;
    }
    if (relationField == 'approvedUniversity') {
      return approvedUniversity;
    }
    return null;
  }
}

class AdministratorRequestRecordInclude extends _is.IncludeObject {
  AdministratorRequestRecordInclude._({
    _iacs.AuthUserInclude? reviewer,
    _ig96r09j.UniversityRecordInclude? approvedUniversity,
  }) {
    _reviewer = reviewer;
    _approvedUniversity = approvedUniversity;
  }

  _iacs.AuthUserInclude? _reviewer;

  _ig96r09j.UniversityRecordInclude? _approvedUniversity;

  @override
  Map<String, _is.Include?> get includes => {
    'reviewer': _reviewer,
    'approvedUniversity': _approvedUniversity,
  };

  @override
  _is.Table<_is.UuidValue?> get table => AdministratorRequestRecord.t;
}

class AdministratorRequestRecordIncludeList extends _is.IncludeList {
  AdministratorRequestRecordIncludeList._({
    _is.WhereExpressionBuilder<AdministratorRequestRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AdministratorRequestRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AdministratorRequestRecord.t;
}

class AdministratorRequestRecordRepository {
  const AdministratorRequestRecordRepository._();

  final attachRow = const AdministratorRequestRecordAttachRowRepository._();

  final detachRow = const AdministratorRequestRecordDetachRowRepository._();

  /// Returns a list of [AdministratorRequestRecord]s matching the given query parameters.
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
  Future<List<AdministratorRequestRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdministratorRequestRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdministratorRequestRecordTable>? orderBy,
    _is.OrderByListBuilder<AdministratorRequestRecordTable>? orderByList,
    _is.Transaction? transaction,
    AdministratorRequestRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AdministratorRequestRecord>(
      where: where?.call(AdministratorRequestRecord.t),
      orderBy: orderBy?.call(AdministratorRequestRecord.t),
      orderByList: orderByList?.call(AdministratorRequestRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AdministratorRequestRecord] matching the given query parameters.
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
  Future<AdministratorRequestRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdministratorRequestRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<AdministratorRequestRecordTable>? orderBy,
    _is.OrderByListBuilder<AdministratorRequestRecordTable>? orderByList,
    _is.Transaction? transaction,
    AdministratorRequestRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AdministratorRequestRecord>(
      where: where?.call(AdministratorRequestRecord.t),
      orderBy: orderBy?.call(AdministratorRequestRecord.t),
      orderByList: orderByList?.call(AdministratorRequestRecord.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AdministratorRequestRecord] by its [id] or null if no such row exists.
  Future<AdministratorRequestRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    AdministratorRequestRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AdministratorRequestRecord>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AdministratorRequestRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [AdministratorRequestRecord]s will have their `id` fields set.
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
  Future<List<AdministratorRequestRecord>> insert(
    _is.DatabaseSession session,
    List<AdministratorRequestRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AdministratorRequestRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AdministratorRequestRecord] and returns the inserted row.
  ///
  /// The returned [AdministratorRequestRecord] will have its `id` field set.
  Future<AdministratorRequestRecord> insertRow(
    _is.DatabaseSession session,
    AdministratorRequestRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AdministratorRequestRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AdministratorRequestRecord]s in the list and returns the resulting rows.
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
  /// The returned [AdministratorRequestRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdministratorRequestRecord>> upsert(
    _is.DatabaseSession session,
    List<AdministratorRequestRecord> rows, {
    required _is.ColumnSelections<AdministratorRequestRecordTable>
    conflictColumns,
    _is.ColumnSelections<AdministratorRequestRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<AdministratorRequestRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AdministratorRequestRecord>(
      rows,
      conflictColumns: conflictColumns(AdministratorRequestRecord.t),
      updateColumns: updateColumns?.call(AdministratorRequestRecord.t),
      updateWhere: updateWhere?.call(AdministratorRequestRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AdministratorRequestRecord] and returns the resulting row.
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
  /// The returned [AdministratorRequestRecord] will have its `id` field set.
  Future<AdministratorRequestRecord?> upsertRow(
    _is.DatabaseSession session,
    AdministratorRequestRecord row, {
    required _is.ColumnSelections<AdministratorRequestRecordTable>
    conflictColumns,
    _is.ColumnSelections<AdministratorRequestRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<AdministratorRequestRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AdministratorRequestRecord>(
      row,
      conflictColumns: conflictColumns(AdministratorRequestRecord.t),
      updateColumns: updateColumns?.call(AdministratorRequestRecord.t),
      updateWhere: updateWhere?.call(AdministratorRequestRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [AdministratorRequestRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdministratorRequestRecord>> update(
    _is.DatabaseSession session,
    List<AdministratorRequestRecord> rows, {
    _is.ColumnSelections<AdministratorRequestRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AdministratorRequestRecord>(
      rows,
      columns: columns?.call(AdministratorRequestRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AdministratorRequestRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AdministratorRequestRecord> updateRow(
    _is.DatabaseSession session,
    AdministratorRequestRecord row, {
    _is.ColumnSelections<AdministratorRequestRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AdministratorRequestRecord>(
      row,
      columns: columns?.call(AdministratorRequestRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdministratorRequestRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AdministratorRequestRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AdministratorRequestRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AdministratorRequestRecord>(
      id,
      columnValues: columnValues(AdministratorRequestRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AdministratorRequestRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdministratorRequestRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AdministratorRequestRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AdministratorRequestRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdministratorRequestRecordTable>? orderBy,
    _is.OrderByListBuilder<AdministratorRequestRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AdministratorRequestRecord>(
      columnValues: columnValues(AdministratorRequestRecord.t.updateTable),
      where: where(AdministratorRequestRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdministratorRequestRecord.t),
      orderByList: orderByList?.call(AdministratorRequestRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AdministratorRequestRecord]s in the list and returns the deleted rows.
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
  Future<List<AdministratorRequestRecord>> delete(
    _is.DatabaseSession session,
    List<AdministratorRequestRecord> rows, {
    _is.OrderByBuilder<AdministratorRequestRecordTable>? orderBy,
    _is.OrderByListBuilder<AdministratorRequestRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AdministratorRequestRecord>(
      rows,
      orderBy: orderBy?.call(AdministratorRequestRecord.t),
      orderByList: orderByList?.call(AdministratorRequestRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AdministratorRequestRecord].
  Future<AdministratorRequestRecord> deleteRow(
    _is.DatabaseSession session,
    AdministratorRequestRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AdministratorRequestRecord>(
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
  Future<List<AdministratorRequestRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdministratorRequestRecordTable> where,
    _is.OrderByBuilder<AdministratorRequestRecordTable>? orderBy,
    _is.OrderByListBuilder<AdministratorRequestRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AdministratorRequestRecord>(
      where: where(AdministratorRequestRecord.t),
      orderBy: orderBy?.call(AdministratorRequestRecord.t),
      orderByList: orderByList?.call(AdministratorRequestRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdministratorRequestRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AdministratorRequestRecord>(
      where: where?.call(AdministratorRequestRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AdministratorRequestRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdministratorRequestRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AdministratorRequestRecord>(
      where: where(AdministratorRequestRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AdministratorRequestRecordAttachRowRepository {
  const AdministratorRequestRecordAttachRowRepository._();

  /// Creates a relation between the given [AdministratorRequestRecord] and [AuthUser]
  /// by setting the [AdministratorRequestRecord]'s foreign key `reviewerId` to refer to the [AuthUser].
  Future<void> reviewer(
    _is.DatabaseSession session,
    AdministratorRequestRecord administratorRequestRecord,
    _iacs.AuthUser reviewer, {
    _is.Transaction? transaction,
  }) async {
    if (administratorRequestRecord.id == null) {
      throw ArgumentError.notNull('administratorRequestRecord.id');
    }
    if (reviewer.id == null) {
      throw ArgumentError.notNull('reviewer.id');
    }

    var $administratorRequestRecord = administratorRequestRecord.copyWith(
      reviewerId: reviewer.id,
    );
    await session.db.updateRow<AdministratorRequestRecord>(
      $administratorRequestRecord,
      columns: [AdministratorRequestRecord.t.reviewerId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AdministratorRequestRecord] and [UniversityRecord]
  /// by setting the [AdministratorRequestRecord]'s foreign key `approvedUniversityId` to refer to the [UniversityRecord].
  Future<void> approvedUniversity(
    _is.DatabaseSession session,
    AdministratorRequestRecord administratorRequestRecord,
    _ig96r09j.UniversityRecord approvedUniversity, {
    _is.Transaction? transaction,
  }) async {
    if (administratorRequestRecord.id == null) {
      throw ArgumentError.notNull('administratorRequestRecord.id');
    }
    if (approvedUniversity.id == null) {
      throw ArgumentError.notNull('approvedUniversity.id');
    }

    var $administratorRequestRecord = administratorRequestRecord.copyWith(
      approvedUniversityId: approvedUniversity.id,
    );
    await session.db.updateRow<AdministratorRequestRecord>(
      $administratorRequestRecord,
      columns: [AdministratorRequestRecord.t.approvedUniversityId],
      transaction: transaction,
    );
  }
}

class AdministratorRequestRecordDetachRowRepository {
  const AdministratorRequestRecordDetachRowRepository._();

  /// Detaches the relation between this [AdministratorRequestRecord] and the [AuthUser] set in `reviewer`
  /// by setting the [AdministratorRequestRecord]'s foreign key `reviewerId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> reviewer(
    _is.DatabaseSession session,
    AdministratorRequestRecord administratorRequestRecord, {
    _is.Transaction? transaction,
  }) async {
    if (administratorRequestRecord.id == null) {
      throw ArgumentError.notNull('administratorRequestRecord.id');
    }

    var $administratorRequestRecord = administratorRequestRecord.copyWith(
      reviewerId: null,
    );
    await session.db.updateRow<AdministratorRequestRecord>(
      $administratorRequestRecord,
      columns: [AdministratorRequestRecord.t.reviewerId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [AdministratorRequestRecord] and the [UniversityRecord] set in `approvedUniversity`
  /// by setting the [AdministratorRequestRecord]'s foreign key `approvedUniversityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> approvedUniversity(
    _is.DatabaseSession session,
    AdministratorRequestRecord administratorRequestRecord, {
    _is.Transaction? transaction,
  }) async {
    if (administratorRequestRecord.id == null) {
      throw ArgumentError.notNull('administratorRequestRecord.id');
    }

    var $administratorRequestRecord = administratorRequestRecord.copyWith(
      approvedUniversityId: null,
    );
    await session.db.updateRow<AdministratorRequestRecord>(
      $administratorRequestRecord,
      columns: [AdministratorRequestRecord.t.approvedUniversityId],
      transaction: transaction,
    );
  }
}
