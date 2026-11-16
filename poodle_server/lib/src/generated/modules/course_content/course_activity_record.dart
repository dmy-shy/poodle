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
import '../../modules/course_content/course_announcement_info.dart'
    as _inglaeaf;
import '../../modules/course_content/course_assessment_info.dart' as _ivadimum;
import '../../modules/course_content/course_file_info.dart' as _ithyh9y5;
import '../../modules/course_content/course_link_info.dart' as _iwi7no9w;
import '../../modules/course_content/course_section_record.dart' as _ihafy62q;

abstract class CourseActivityRecord
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  CourseActivityRecord._({
    this.id,
    required this.sectionId,
    this.section,
    required this.title,
    this.description,
    required this.kind,
    required this.sortOrder,
    bool? published,
    this.file,
    this.storageId,
    this.storagePath,
    this.link,
    this.announcement,
    this.assessment,
  }) : published = published ?? false;

  factory CourseActivityRecord({
    _is.UuidValue? id,
    required _is.UuidValue sectionId,
    _ihafy62q.CourseSectionRecord? section,
    required String title,
    String? description,
    required String kind,
    required int sortOrder,
    bool? published,
    _ithyh9y5.CourseFileInfo? file,
    String? storageId,
    String? storagePath,
    _iwi7no9w.CourseLinkInfo? link,
    _inglaeaf.CourseAnnouncementInfo? announcement,
    _ivadimum.CourseAssessmentInfo? assessment,
  }) = _CourseActivityRecordImpl;

  factory CourseActivityRecord.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CourseActivityRecord(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      sectionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['sectionId'],
      ),
      section: jsonSerialization['section'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_ihafy62q.CourseSectionRecord>(
              jsonSerialization['section'],
            ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      kind: jsonSerialization['kind'] as String,
      sortOrder: jsonSerialization['sortOrder'] as int,
      published: jsonSerialization['published'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['published']),
      file: jsonSerialization['file'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_ithyh9y5.CourseFileInfo>(
              jsonSerialization['file'],
            ),
      storageId: jsonSerialization['storageId'] as String?,
      storagePath: jsonSerialization['storagePath'] as String?,
      link: jsonSerialization['link'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_iwi7no9w.CourseLinkInfo>(
              jsonSerialization['link'],
            ),
      announcement: jsonSerialization['announcement'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_inglaeaf.CourseAnnouncementInfo>(
              jsonSerialization['announcement'],
            ),
      assessment: jsonSerialization['assessment'] == null
          ? null
          : _ikm1kaos.Protocol().deserialize<_ivadimum.CourseAssessmentInfo>(
              jsonSerialization['assessment'],
            ),
    );
  }

  static final t = CourseActivityRecordTable();

  static const db = CourseActivityRecordRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue sectionId;

  _ihafy62q.CourseSectionRecord? section;

  String title;

  String? description;

  String kind;

  int sortOrder;

  bool published;

  _ithyh9y5.CourseFileInfo? file;

  String? storageId;

  String? storagePath;

  _iwi7no9w.CourseLinkInfo? link;

  _inglaeaf.CourseAnnouncementInfo? announcement;

  _ivadimum.CourseAssessmentInfo? assessment;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CourseActivityRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CourseActivityRecord copyWith({
    _is.UuidValue? id,
    _is.UuidValue? sectionId,
    _ihafy62q.CourseSectionRecord? section,
    String? title,
    String? description,
    String? kind,
    int? sortOrder,
    bool? published,
    _ithyh9y5.CourseFileInfo? file,
    String? storageId,
    String? storagePath,
    _iwi7no9w.CourseLinkInfo? link,
    _inglaeaf.CourseAnnouncementInfo? announcement,
    _ivadimum.CourseAssessmentInfo? assessment,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CourseActivityRecord',
      if (id != null) 'id': id?.toJson(),
      'sectionId': sectionId.toJson(),
      if (section != null) 'section': section?.toJson(),
      'title': title,
      if (description != null) 'description': description,
      'kind': kind,
      'sortOrder': sortOrder,
      'published': published,
      if (file != null) 'file': file?.toJson(),
      if (storageId != null) 'storageId': storageId,
      if (storagePath != null) 'storagePath': storagePath,
      if (link != null) 'link': link?.toJson(),
      if (announcement != null) 'announcement': announcement?.toJson(),
      if (assessment != null) 'assessment': assessment?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static CourseActivityRecordInclude include({
    _ihafy62q.CourseSectionRecordInclude? section,
  }) {
    return CourseActivityRecordInclude._(section: section);
  }

  static CourseActivityRecordIncludeList includeList({
    _is.WhereExpressionBuilder<CourseActivityRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseActivityRecordTable>? orderByList,
    CourseActivityRecordInclude? include,
  }) {
    return CourseActivityRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CourseActivityRecord.t),
      orderByList: orderByList?.call(CourseActivityRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseActivityRecordImpl extends CourseActivityRecord {
  _CourseActivityRecordImpl({
    _is.UuidValue? id,
    required _is.UuidValue sectionId,
    _ihafy62q.CourseSectionRecord? section,
    required String title,
    String? description,
    required String kind,
    required int sortOrder,
    bool? published,
    _ithyh9y5.CourseFileInfo? file,
    String? storageId,
    String? storagePath,
    _iwi7no9w.CourseLinkInfo? link,
    _inglaeaf.CourseAnnouncementInfo? announcement,
    _ivadimum.CourseAssessmentInfo? assessment,
  }) : super._(
         id: id,
         sectionId: sectionId,
         section: section,
         title: title,
         description: description,
         kind: kind,
         sortOrder: sortOrder,
         published: published,
         file: file,
         storageId: storageId,
         storagePath: storagePath,
         link: link,
         announcement: announcement,
         assessment: assessment,
       );

  /// Returns a shallow copy of this [CourseActivityRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CourseActivityRecord copyWith({
    Object? id = _Undefined,
    _is.UuidValue? sectionId,
    Object? section = _Undefined,
    String? title,
    Object? description = _Undefined,
    String? kind,
    int? sortOrder,
    bool? published,
    Object? file = _Undefined,
    Object? storageId = _Undefined,
    Object? storagePath = _Undefined,
    Object? link = _Undefined,
    Object? announcement = _Undefined,
    Object? assessment = _Undefined,
  }) {
    return CourseActivityRecord(
      id: id is _is.UuidValue? ? id : this.id,
      sectionId: sectionId ?? this.sectionId,
      section: section is _ihafy62q.CourseSectionRecord?
          ? section
          : this.section?.copyWith(),
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      kind: kind ?? this.kind,
      sortOrder: sortOrder ?? this.sortOrder,
      published: published ?? this.published,
      file: file is _ithyh9y5.CourseFileInfo? ? file : this.file?.copyWith(),
      storageId: storageId is String? ? storageId : this.storageId,
      storagePath: storagePath is String? ? storagePath : this.storagePath,
      link: link is _iwi7no9w.CourseLinkInfo? ? link : this.link?.copyWith(),
      announcement: announcement is _inglaeaf.CourseAnnouncementInfo?
          ? announcement
          : this.announcement?.copyWith(),
      assessment: assessment is _ivadimum.CourseAssessmentInfo?
          ? assessment
          : this.assessment?.copyWith(),
    );
  }
}

class CourseActivityRecordUpdateTable
    extends _is.UpdateTable<CourseActivityRecordTable> {
  CourseActivityRecordUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> sectionId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.sectionId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<int, int> sortOrder(int value) => _is.ColumnValue(
    table.sortOrder,
    value,
  );

  _is.ColumnValue<bool, bool> published(bool value) => _is.ColumnValue(
    table.published,
    value,
  );

  _is.ColumnValue<_ithyh9y5.CourseFileInfo, _ithyh9y5.CourseFileInfo> file(
    _ithyh9y5.CourseFileInfo? value,
  ) => _is.ColumnValue(
    table.file,
    value,
  );

  _is.ColumnValue<String, String> storageId(String? value) => _is.ColumnValue(
    table.storageId,
    value,
  );

  _is.ColumnValue<String, String> storagePath(String? value) => _is.ColumnValue(
    table.storagePath,
    value,
  );

  _is.ColumnValue<_iwi7no9w.CourseLinkInfo, _iwi7no9w.CourseLinkInfo> link(
    _iwi7no9w.CourseLinkInfo? value,
  ) => _is.ColumnValue(
    table.link,
    value,
  );

  _is.ColumnValue<
    _inglaeaf.CourseAnnouncementInfo,
    _inglaeaf.CourseAnnouncementInfo
  >
  announcement(_inglaeaf.CourseAnnouncementInfo? value) => _is.ColumnValue(
    table.announcement,
    value,
  );

  _is.ColumnValue<
    _ivadimum.CourseAssessmentInfo,
    _ivadimum.CourseAssessmentInfo
  >
  assessment(_ivadimum.CourseAssessmentInfo? value) => _is.ColumnValue(
    table.assessment,
    value,
  );
}

class CourseActivityRecordTable extends _is.Table<_is.UuidValue?> {
  CourseActivityRecordTable({super.tableRelation})
    : super(tableName: 'poodle_course_activity') {
    updateTable = CourseActivityRecordUpdateTable(this);
    sectionId = _is.ColumnUuid(
      'sectionId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    kind = _is.ColumnString(
      'kind',
      this,
    );
    sortOrder = _is.ColumnInt(
      'sortOrder',
      this,
    );
    published = _is.ColumnBool(
      'published',
      this,
      hasDefault: true,
    );
    file = _is.ColumnSerializable<_ithyh9y5.CourseFileInfo>(
      'file',
      this,
    );
    storageId = _is.ColumnString(
      'storageId',
      this,
    );
    storagePath = _is.ColumnString(
      'storagePath',
      this,
    );
    link = _is.ColumnSerializable<_iwi7no9w.CourseLinkInfo>(
      'link',
      this,
    );
    announcement = _is.ColumnSerializable<_inglaeaf.CourseAnnouncementInfo>(
      'announcement',
      this,
    );
    assessment = _is.ColumnSerializable<_ivadimum.CourseAssessmentInfo>(
      'assessment',
      this,
    );
  }

  late final CourseActivityRecordUpdateTable updateTable;

  late final _is.ColumnUuid sectionId;

  _ihafy62q.CourseSectionRecordTable? _section;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  late final _is.ColumnString kind;

  late final _is.ColumnInt sortOrder;

  late final _is.ColumnBool published;

  late final _is.ColumnSerializable<_ithyh9y5.CourseFileInfo> file;

  late final _is.ColumnString storageId;

  late final _is.ColumnString storagePath;

  late final _is.ColumnSerializable<_iwi7no9w.CourseLinkInfo> link;

  late final _is.ColumnSerializable<_inglaeaf.CourseAnnouncementInfo>
  announcement;

  late final _is.ColumnSerializable<_ivadimum.CourseAssessmentInfo> assessment;

  _ihafy62q.CourseSectionRecordTable get section {
    if (_section != null) return _section!;
    _section = _is.createRelationTable(
      relationFieldName: 'section',
      field: CourseActivityRecord.t.sectionId,
      foreignField: _ihafy62q.CourseSectionRecord.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _ihafy62q.CourseSectionRecordTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return _section!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    sectionId,
    title,
    description,
    kind,
    sortOrder,
    published,
    file,
    storageId,
    storagePath,
    link,
    announcement,
    assessment,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'section') {
      return section;
    }
    return null;
  }
}

class CourseActivityRecordInclude extends _is.IncludeObject {
  CourseActivityRecordInclude._({
    _ihafy62q.CourseSectionRecordInclude? section,
  }) {
    _section = section;
  }

  _ihafy62q.CourseSectionRecordInclude? _section;

  @override
  Map<String, _is.Include?> get includes => {'section': _section};

  @override
  _is.Table<_is.UuidValue?> get table => CourseActivityRecord.t;
}

class CourseActivityRecordIncludeList extends _is.IncludeList {
  CourseActivityRecordIncludeList._({
    _is.WhereExpressionBuilder<CourseActivityRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CourseActivityRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => CourseActivityRecord.t;
}

class CourseActivityRecordRepository {
  const CourseActivityRecordRepository._();

  final attachRow = const CourseActivityRecordAttachRowRepository._();

  /// Returns a list of [CourseActivityRecord]s matching the given query parameters.
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
  Future<List<CourseActivityRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseActivityRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseActivityRecordTable>? orderByList,
    _is.Transaction? transaction,
    CourseActivityRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CourseActivityRecord>(
      where: where?.call(CourseActivityRecord.t),
      orderBy: orderBy?.call(CourseActivityRecord.t),
      orderByList: orderByList?.call(CourseActivityRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CourseActivityRecord] matching the given query parameters.
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
  Future<CourseActivityRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseActivityRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<CourseActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseActivityRecordTable>? orderByList,
    _is.Transaction? transaction,
    CourseActivityRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CourseActivityRecord>(
      where: where?.call(CourseActivityRecord.t),
      orderBy: orderBy?.call(CourseActivityRecord.t),
      orderByList: orderByList?.call(CourseActivityRecord.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CourseActivityRecord] by its [id] or null if no such row exists.
  Future<CourseActivityRecord?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    CourseActivityRecordInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CourseActivityRecord>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CourseActivityRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [CourseActivityRecord]s will have their `id` fields set.
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
  Future<List<CourseActivityRecord>> insert(
    _is.DatabaseSession session,
    List<CourseActivityRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CourseActivityRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CourseActivityRecord] and returns the inserted row.
  ///
  /// The returned [CourseActivityRecord] will have its `id` field set.
  Future<CourseActivityRecord> insertRow(
    _is.DatabaseSession session,
    CourseActivityRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CourseActivityRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CourseActivityRecord]s in the list and returns the resulting rows.
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
  /// The returned [CourseActivityRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseActivityRecord>> upsert(
    _is.DatabaseSession session,
    List<CourseActivityRecord> rows, {
    required _is.ColumnSelections<CourseActivityRecordTable> conflictColumns,
    _is.ColumnSelections<CourseActivityRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<CourseActivityRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CourseActivityRecord>(
      rows,
      conflictColumns: conflictColumns(CourseActivityRecord.t),
      updateColumns: updateColumns?.call(CourseActivityRecord.t),
      updateWhere: updateWhere?.call(CourseActivityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CourseActivityRecord] and returns the resulting row.
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
  /// The returned [CourseActivityRecord] will have its `id` field set.
  Future<CourseActivityRecord?> upsertRow(
    _is.DatabaseSession session,
    CourseActivityRecord row, {
    required _is.ColumnSelections<CourseActivityRecordTable> conflictColumns,
    _is.ColumnSelections<CourseActivityRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<CourseActivityRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CourseActivityRecord>(
      row,
      conflictColumns: conflictColumns(CourseActivityRecord.t),
      updateColumns: updateColumns?.call(CourseActivityRecord.t),
      updateWhere: updateWhere?.call(CourseActivityRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [CourseActivityRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseActivityRecord>> update(
    _is.DatabaseSession session,
    List<CourseActivityRecord> rows, {
    _is.ColumnSelections<CourseActivityRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CourseActivityRecord>(
      rows,
      columns: columns?.call(CourseActivityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CourseActivityRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CourseActivityRecord> updateRow(
    _is.DatabaseSession session,
    CourseActivityRecord row, {
    _is.ColumnSelections<CourseActivityRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CourseActivityRecord>(
      row,
      columns: columns?.call(CourseActivityRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CourseActivityRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CourseActivityRecord?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CourseActivityRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CourseActivityRecord>(
      id,
      columnValues: columnValues(CourseActivityRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CourseActivityRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CourseActivityRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CourseActivityRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CourseActivityRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CourseActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseActivityRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CourseActivityRecord>(
      columnValues: columnValues(CourseActivityRecord.t.updateTable),
      where: where(CourseActivityRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CourseActivityRecord.t),
      orderByList: orderByList?.call(CourseActivityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CourseActivityRecord]s in the list and returns the deleted rows.
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
  Future<List<CourseActivityRecord>> delete(
    _is.DatabaseSession session,
    List<CourseActivityRecord> rows, {
    _is.OrderByBuilder<CourseActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseActivityRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CourseActivityRecord>(
      rows,
      orderBy: orderBy?.call(CourseActivityRecord.t),
      orderByList: orderByList?.call(CourseActivityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CourseActivityRecord].
  Future<CourseActivityRecord> deleteRow(
    _is.DatabaseSession session,
    CourseActivityRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CourseActivityRecord>(
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
  Future<List<CourseActivityRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CourseActivityRecordTable> where,
    _is.OrderByBuilder<CourseActivityRecordTable>? orderBy,
    _is.OrderByListBuilder<CourseActivityRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CourseActivityRecord>(
      where: where(CourseActivityRecord.t),
      orderBy: orderBy?.call(CourseActivityRecord.t),
      orderByList: orderByList?.call(CourseActivityRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CourseActivityRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CourseActivityRecord>(
      where: where?.call(CourseActivityRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CourseActivityRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CourseActivityRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CourseActivityRecord>(
      where: where(CourseActivityRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CourseActivityRecordAttachRowRepository {
  const CourseActivityRecordAttachRowRepository._();

  /// Creates a relation between the given [CourseActivityRecord] and [CourseSectionRecord]
  /// by setting the [CourseActivityRecord]'s foreign key `sectionId` to refer to the [CourseSectionRecord].
  Future<void> section(
    _is.DatabaseSession session,
    CourseActivityRecord courseActivityRecord,
    _ihafy62q.CourseSectionRecord section, {
    _is.Transaction? transaction,
  }) async {
    if (courseActivityRecord.id == null) {
      throw ArgumentError.notNull('courseActivityRecord.id');
    }
    if (section.id == null) {
      throw ArgumentError.notNull('section.id');
    }

    var $courseActivityRecord = courseActivityRecord.copyWith(
      sectionId: section.id,
    );
    await session.db.updateRow<CourseActivityRecord>(
      $courseActivityRecord,
      columns: [CourseActivityRecord.t.sectionId],
      transaction: transaction,
    );
  }
}
