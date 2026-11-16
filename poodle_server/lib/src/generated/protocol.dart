/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:poodle_server/src/generated/modules/admin/admin_directory_row.dart'
    as _igozwii5;
import 'package:poodle_server/src/generated/modules/courses/course_summary.dart'
    as _ittv3y4z;
import 'package:poodle_server/src/generated/modules/identity/administrator_request_summary.dart'
    as _ihee96mj;
import 'package:poodle_server/src/generated/modules/identity/invitation_summary.dart'
    as _iaj1deq7;
import 'package:poodle_server/src/generated/modules/identity/university_member_summary.dart'
    as _i9y39pis;
import 'package:poodle_server/src/generated/modules/identity/university_summary.dart'
    as _ighao0f1;
import 'package:poodle_server/src/generated/modules/messaging/conversation_item.dart'
    as _ioi3raon;
import 'package:poodle_server/src/generated/modules/messaging/eligible_peer.dart'
    as _iodjvxbh;
import 'package:poodle_server/src/generated/modules/messaging/message_item.dart'
    as _iw88u6c6;
import 'package:poodle_server/src/generated/modules/my_files/my_upload.dart'
    as _i136jmjd;
import 'package:poodle_server/src/generated/modules/notebook/notebook_job_status.dart'
    as _ih317ylu;
import 'package:poodle_server/src/generated/modules/notebook/notebook_note_view.dart'
    as _iw83hlmr;
import 'package:poodle_server/src/generated/modules/notebook/notebook_studio_item.dart'
    as _i9s4xz0t;
import 'package:poodle_server/src/generated/modules/notebook/notebook_turn_view.dart'
    as _ixkyvt7w;
import 'package:poodle_server/src/generated/modules/notifications/notification_item.dart'
    as _iuehrapu;
import 'package:poodle_server/src/generated/modules/search/search_recent.dart'
    as _ighx7soh;
import 'package:poodle_server/src/generated/modules/teaching/teaching_activity_view.dart'
    as _ic46rxfm;
import 'package:poodle_server/src/generated/modules/teaching/teaching_course_view.dart'
    as _iel9ouer;
import 'package:poodle_server/src/generated/modules/teaching/teaching_member_view.dart'
    as _idn1qcra;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'modules/admin/admin_directory_row.dart' as _i7m5u5sf;
import 'modules/admin/admin_overview.dart' as _igbc6bvq;
import 'modules/course_content/course_activity.dart' as _i4d138sj;
import 'modules/course_content/course_activity_record.dart' as _ifcq2lyb;
import 'modules/course_content/course_announcement_info.dart' as _ie315swm;
import 'modules/course_content/course_assessment_info.dart' as _iz5q1xt6;
import 'modules/course_content/course_detail.dart' as _ifi4v4lp;
import 'modules/course_content/course_file_access.dart' as _i77ctelr;
import 'modules/course_content/course_file_info.dart' as _ir759m7l;
import 'modules/course_content/course_link_info.dart' as _i64ldnq9;
import 'modules/course_content/course_section.dart' as _iz2rpgu0;
import 'modules/course_content/course_section_record.dart' as _i0m1c2n7;
import 'modules/courses/course_membership.dart' as _ifz8yomu;
import 'modules/courses/course_preference.dart' as _iomyaqit;
import 'modules/courses/course_read_exception.dart' as _i24unjc2;
import 'modules/courses/course_record.dart' as _i5vt3bwt;
import 'modules/courses/course_summary.dart' as _iyl7g11s;
import 'modules/identity/access_grant_audit.dart' as _ikaa37of;
import 'modules/identity/account_access.dart' as _i9rvlh42;
import 'modules/identity/account_invitation.dart' as _is8ljmcy;
import 'modules/identity/account_snapshot.dart' as _iv9gbhnz;
import 'modules/identity/administrator_request_record.dart' as _id3azvrd;
import 'modules/identity/administrator_request_summary.dart' as _i1c61daw;
import 'modules/identity/identity_access_exception.dart' as _ivy7y4wo;
import 'modules/identity/institution_mail_record.dart' as _iod5qrkf;
import 'modules/identity/invitation_summary.dart' as _iayx6x33;
import 'modules/identity/pending_email_change.dart' as _ild8fjog;
import 'modules/identity/pending_email_change_summary.dart' as _infhr8r7;
import 'modules/identity/university_member_summary.dart' as _io4lp5h5;
import 'modules/identity/university_record.dart' as _iukke2qa;
import 'modules/identity/university_summary.dart' as _i9u2navt;
import 'modules/messaging/conversation_item.dart' as _irfgoa0i;
import 'modules/messaging/conversation_record.dart' as _iep6ikt9;
import 'modules/messaging/eligible_peer.dart' as _itmsc93k;
import 'modules/messaging/message_item.dart' as _iqjq4fel;
import 'modules/messaging/message_record.dart' as _i6gbxsoc;
import 'modules/messaging/read_cursor_record.dart' as _ipm374v1;
import 'modules/my_files/my_upload.dart' as _irgxli50;
import 'modules/notebook/notebook_artifact.dart' as _ikm5gnnf;
import 'modules/notebook/notebook_assessment_config.dart' as _iyqh99ur;
import 'modules/notebook/notebook_assessment_config_input.dart' as _is07a4ho;
import 'modules/notebook/notebook_assessment_config_view.dart' as _ihd45xsw;
import 'modules/notebook/notebook_assessment_material.dart' as _ipjv14xm;
import 'modules/notebook/notebook_assessment_setup.dart' as _iizyiasx;
import 'modules/notebook/notebook_audio_access.dart' as _i61zjbgu;
import 'modules/notebook/notebook_chat_input.dart' as _iqdu4kxl;
import 'modules/notebook/notebook_chunk.dart' as _ikcpghjp;
import 'modules/notebook/notebook_citation.dart' as _ifnilvb1;
import 'modules/notebook/notebook_error.dart' as _i7g4cm5a;
import 'modules/notebook/notebook_job.dart' as _i2g9bvo0;
import 'modules/notebook/notebook_job_status.dart' as _ioziuoc8;
import 'modules/notebook/notebook_material_option.dart' as _ifi9qpbh;
import 'modules/notebook/notebook_note_record.dart' as _iz9cuk95;
import 'modules/notebook/notebook_note_view.dart' as _issssupk;
import 'modules/notebook/notebook_overview.dart' as _i900zlap;
import 'modules/notebook/notebook_record.dart' as _inb7o9hq;
import 'modules/notebook/notebook_source.dart' as _ikcceymu;
import 'modules/notebook/notebook_source_info.dart' as _i3v4x43g;
import 'modules/notebook/notebook_source_selection.dart' as _ik9egh2v;
import 'modules/notebook/notebook_source_version.dart' as _i24at178;
import 'modules/notebook/notebook_studio_item.dart' as _ikn9ojxd;
import 'modules/notebook/notebook_studio_request.dart' as _ibru614b;
import 'modules/notebook/notebook_turn.dart' as _id2bmit0;
import 'modules/notebook/notebook_turn_view.dart' as _itn9r96i;
import 'modules/notebook/notebook_upload_input.dart' as _iutecm5w;
import 'modules/notebook/notebook_upload_ticket.dart' as _ijxhmjxo;
import 'modules/notebook/notebook_usage_month.dart' as _ihblw25m;
import 'modules/notifications/notification_item.dart' as _irfpkdny;
import 'modules/notifications/notification_record.dart' as _imzzqvl0;
import 'modules/notifications/push_device_record.dart' as _iqdipyx1;
import 'modules/search/search_error.dart' as _iu9wgju8;
import 'modules/search/search_history_record.dart' as _innntee6;
import 'modules/search/search_hit.dart' as _ih8j6fen;
import 'modules/search/search_index_chunk.dart' as _isq81kdq;
import 'modules/search/search_index_job.dart' as _i878ch8m;
import 'modules/search/search_recent.dart' as _i25dmvzp;
import 'modules/search/search_response.dart' as _ixylbxq6;
import 'modules/student_learning/student_grade_course.dart' as _i7dbfqcs;
import 'modules/student_learning/student_grade_row.dart' as _igwj78dq;
import 'modules/student_learning/student_grades_response.dart' as _i38t4enu;
import 'modules/student_learning/student_task_row.dart' as _ivkp5op4;
import 'modules/student_learning/student_tasks_response.dart' as _ieh9wk3e;
import 'modules/teaching/teacher_defaults_record.dart' as _is0010g7;
import 'modules/teaching/teaching_activity_record.dart' as _i6h3uxby;
import 'modules/teaching/teaching_activity_view.dart' as _i448j8qo;
import 'modules/teaching/teaching_attempt_record.dart' as _iavkgh93;
import 'modules/teaching/teaching_attempt_view.dart' as _ivlau0h8;
import 'modules/teaching/teaching_course_view.dart' as _i90cap6h;
import 'modules/teaching/teaching_error.dart' as _i8oe640j;
import 'modules/teaching/teaching_member_view.dart' as _i46b132o;
import 'modules/teaching/teaching_question.dart' as _i3apebh7;
import 'modules/teaching/teaching_save_input.dart' as _iyph2036;
import 'modules/teaching/teaching_settings.dart' as _ir0clk27;
import 'modules/teaching/teaching_submission_record.dart' as _iurppijx;
import 'modules/teaching/teaching_submission_view.dart' as _ivzwpa04;
import 'modules/teaching/teaching_upload_record.dart' as _ipqd5xy1;
import 'modules/teaching/teaching_upload_ticket.dart' as _idy12w3x;
import 'modules/teaching/teaching_version_record.dart' as _isbp4gyn;
export 'modules/admin/admin_directory_row.dart';
export 'modules/admin/admin_overview.dart';
export 'modules/course_content/course_activity.dart';
export 'modules/course_content/course_activity_record.dart';
export 'modules/course_content/course_announcement_info.dart';
export 'modules/course_content/course_assessment_info.dart';
export 'modules/course_content/course_detail.dart';
export 'modules/course_content/course_file_access.dart';
export 'modules/course_content/course_file_info.dart';
export 'modules/course_content/course_link_info.dart';
export 'modules/course_content/course_section.dart';
export 'modules/course_content/course_section_record.dart';
export 'modules/courses/course_membership.dart';
export 'modules/courses/course_preference.dart';
export 'modules/courses/course_read_exception.dart';
export 'modules/courses/course_record.dart';
export 'modules/courses/course_summary.dart';
export 'modules/identity/access_grant_audit.dart';
export 'modules/identity/account_access.dart';
export 'modules/identity/account_invitation.dart';
export 'modules/identity/account_snapshot.dart';
export 'modules/identity/administrator_request_record.dart';
export 'modules/identity/administrator_request_summary.dart';
export 'modules/identity/identity_access_exception.dart';
export 'modules/identity/institution_mail_record.dart';
export 'modules/identity/invitation_summary.dart';
export 'modules/identity/pending_email_change.dart';
export 'modules/identity/pending_email_change_summary.dart';
export 'modules/identity/university_member_summary.dart';
export 'modules/identity/university_record.dart';
export 'modules/identity/university_summary.dart';
export 'modules/messaging/conversation_item.dart';
export 'modules/messaging/conversation_record.dart';
export 'modules/messaging/eligible_peer.dart';
export 'modules/messaging/message_item.dart';
export 'modules/messaging/message_record.dart';
export 'modules/messaging/read_cursor_record.dart';
export 'modules/my_files/my_upload.dart';
export 'modules/notebook/notebook_artifact.dart';
export 'modules/notebook/notebook_assessment_config.dart';
export 'modules/notebook/notebook_assessment_config_input.dart';
export 'modules/notebook/notebook_assessment_config_view.dart';
export 'modules/notebook/notebook_assessment_material.dart';
export 'modules/notebook/notebook_assessment_setup.dart';
export 'modules/notebook/notebook_audio_access.dart';
export 'modules/notebook/notebook_chat_input.dart';
export 'modules/notebook/notebook_chunk.dart';
export 'modules/notebook/notebook_citation.dart';
export 'modules/notebook/notebook_error.dart';
export 'modules/notebook/notebook_job.dart';
export 'modules/notebook/notebook_job_status.dart';
export 'modules/notebook/notebook_material_option.dart';
export 'modules/notebook/notebook_note_record.dart';
export 'modules/notebook/notebook_note_view.dart';
export 'modules/notebook/notebook_overview.dart';
export 'modules/notebook/notebook_record.dart';
export 'modules/notebook/notebook_source.dart';
export 'modules/notebook/notebook_source_info.dart';
export 'modules/notebook/notebook_source_selection.dart';
export 'modules/notebook/notebook_source_version.dart';
export 'modules/notebook/notebook_studio_item.dart';
export 'modules/notebook/notebook_studio_request.dart';
export 'modules/notebook/notebook_turn.dart';
export 'modules/notebook/notebook_turn_view.dart';
export 'modules/notebook/notebook_upload_input.dart';
export 'modules/notebook/notebook_upload_ticket.dart';
export 'modules/notebook/notebook_usage_month.dart';
export 'modules/notifications/notification_item.dart';
export 'modules/notifications/notification_record.dart';
export 'modules/notifications/push_device_record.dart';
export 'modules/search/search_error.dart';
export 'modules/search/search_history_record.dart';
export 'modules/search/search_hit.dart';
export 'modules/search/search_index_chunk.dart';
export 'modules/search/search_index_job.dart';
export 'modules/search/search_recent.dart';
export 'modules/search/search_response.dart';
export 'modules/student_learning/student_grade_course.dart';
export 'modules/student_learning/student_grade_row.dart';
export 'modules/student_learning/student_grades_response.dart';
export 'modules/student_learning/student_task_row.dart';
export 'modules/student_learning/student_tasks_response.dart';
export 'modules/teaching/teacher_defaults_record.dart';
export 'modules/teaching/teaching_activity_record.dart';
export 'modules/teaching/teaching_activity_view.dart';
export 'modules/teaching/teaching_attempt_record.dart';
export 'modules/teaching/teaching_attempt_view.dart';
export 'modules/teaching/teaching_course_view.dart';
export 'modules/teaching/teaching_error.dart';
export 'modules/teaching/teaching_member_view.dart';
export 'modules/teaching/teaching_question.dart';
export 'modules/teaching/teaching_save_input.dart';
export 'modules/teaching/teaching_settings.dart';
export 'modules/teaching/teaching_submission_record.dart';
export 'modules/teaching/teaching_submission_view.dart';
export 'modules/teaching/teaching_upload_record.dart';
export 'modules/teaching/teaching_upload_ticket.dart';
export 'modules/teaching/teaching_version_record.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'poodle_access_grant_audit',
      dartName: 'AccessGrantAudit',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'actorId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'subjectEmail',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'universityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_account_access',
      dartName: 'AccountAccess',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'isAdmin',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'universityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'isUniversityAdmin',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'teacherApproved',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'developmentBootstrap',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'developmentPersona',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'verifiedEmail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'credentialVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_account_access_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_account_access_fk_1',
          columns: ['universityId'],
          referenceTable: 'poodle_university',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_account_access_user_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_account_access_persona_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'developmentPersona',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_account_invitation',
      dartName: 'AccountInvitation',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'purpose',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'universityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'courseId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'issuerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'acceptedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'acceptedById',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'revokedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_account_invitation_fk_0',
          columns: ['universityId'],
          referenceTable: 'poodle_university',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_account_invitation_fk_1',
          columns: ['courseId'],
          referenceTable: 'poodle_course',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_account_invitation_fk_2',
          columns: ['issuerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_account_invitation_fk_3',
          columns: ['acceptedById'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_account_invitation_email',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_account_invitation_created',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_administrator_request',
      dartName: 'AdministratorRequestRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'university',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'position',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'note',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'locale',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'unverified\'',
        ),
        _isp.ColumnDefinition(
          name: 'codeHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'attempts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'verifiedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'reviewedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'reviewerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'reviewNote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'approvedUniversityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_administrator_request_fk_0',
          columns: ['reviewerId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_administrator_request_fk_1',
          columns: ['approvedUniversityId'],
          referenceTable: 'poodle_university',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_admin_request_email',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_admin_request_status',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_conversation',
      dartName: 'ConversationRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'firstParticipantId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'secondParticipantId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_conversation_pair_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'firstParticipantId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'secondParticipantId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_conversation_first',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'firstParticipantId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_conversation_second',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'secondParticipantId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_course',
      dartName: 'CourseRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'universityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'summary',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'teacherName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'seedOwned',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'published',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_course_fk_0',
          columns: ['universityId'],
          referenceTable: 'poodle_university',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_course_activity',
      dartName: 'CourseActivityRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'sectionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sortOrder',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'published',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'file',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:CourseFileInfo?',
        ),
        _isp.ColumnDefinition(
          name: 'storageId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'storagePath',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'link',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:CourseLinkInfo?',
        ),
        _isp.ColumnDefinition(
          name: 'announcement',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:CourseAnnouncementInfo?',
        ),
        _isp.ColumnDefinition(
          name: 'assessment',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:CourseAssessmentInfo?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_course_activity_fk_0',
          columns: ['sectionId'],
          referenceTable: 'poodle_course_section',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_activity_order',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sectionId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sortOrder',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_course_membership',
      dartName: 'CourseMembership',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'courseId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_course_membership_fk_0',
          columns: ['courseId'],
          referenceTable: 'poodle_course',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_course_membership_fk_1',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_membership_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'courseId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_course_preference',
      dartName: 'CoursePreference',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'courseId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'starred',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'hidden',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_course_preference_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'courseId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_course_section',
      dartName: 'CourseSectionRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'courseId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sortOrder',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'published',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_course_section_fk_0',
          columns: ['courseId'],
          referenceTable: 'poodle_course',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_section_order',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'courseId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sortOrder',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_institution_mail',
      dartName: 'InstitutionMailRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'key',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'subject',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'body',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'attempts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'availableAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'deliveredAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_institution_mail_key',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'key',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_institution_mail_pending',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deliveredAt',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'availableAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_message',
      dartName: 'MessageRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'conversationId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'senderId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'clientSendId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'text',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_message_sender_send_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'conversationId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'senderId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clientSendId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_message_history',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'conversationId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_message_read_cursor',
      dartName: 'ReadCursorRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'conversationId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'participantId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'readThroughId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_message_read_cursor_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'conversationId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'participantId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook',
      dartName: 'NotebookRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'courseId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'assessmentActivityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ownerUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'configRevision',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_owner_assessment',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'assessmentActivityId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_course',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'courseId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook_artifact',
      dartName: 'NotebookArtifactRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'notebookId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ownerUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'contentJson',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sourceRevision',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'jobId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'language',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sourceSnapshotJson',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'audioStoragePath',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'stale',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_artifact_list',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'notebookId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_artifact_job',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'jobId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook_assessment_config',
      dartName: 'NotebookAssessmentConfigRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'courseId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'assessmentActivityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'teacherUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'revision',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'allowedFormats',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_config_assessment',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'assessmentActivityId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_config_course',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'courseId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook_assessment_material',
      dartName: 'NotebookAssessmentMaterialRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'configId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'activityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'sortOrder',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_material_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'configId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'activityId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook_chunk',
      dartName: 'NotebookChunkRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'sourceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'sourceVersionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'blockId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'pageNumber',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'locationLabel',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'content',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'embedding',
          columnType: _isp.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(1536)',
          vectorDimension: 1536,
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_chunk_version',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sourceVersionId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_chunk_source',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sourceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook_job',
      dartName: 'NotebookJobRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'notebookId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'sourceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'jobType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'queued\'',
        ),
        _isp.ColumnDefinition(
          name: 'attempts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'leaseToken',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'leaseExpiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'requestKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'privatePayload',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'failureCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_job_request',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'requestKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_job_queue',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook_note',
      dartName: 'NotebookNoteRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'notebookId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ownerUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'turnId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'content',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sourceRevision',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_note_turn',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'notebookId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'turnId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook_source',
      dartName: 'NotebookSourceRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'courseId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'notebookId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'ownerUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'activityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'fileName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'format',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'storageId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'storagePath',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'queued\'',
        ),
        _isp.ColumnDefinition(
          name: 'currentVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'failureCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_source_activity',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'activityId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_source_owner',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'courseId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_source_status',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook_source_selection',
      dartName: 'NotebookSourceSelectionRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'notebookId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'sourceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'selected',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'selectedVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_selection_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'notebookId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sourceId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_selection_lookup',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'notebookId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'selected',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook_source_version',
      dartName: 'NotebookSourceVersionRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'sourceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'version',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'checksum',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'extractedText',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'embeddingSpace',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'legacy-unidentified\'',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_version_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sourceId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'version',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_version_checksum',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'checksum',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook_turn',
      dartName: 'NotebookTurnRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'notebookId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ownerUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'requestKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'turnIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'content',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'citationsJson',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'[]\'',
        ),
        _isp.ColumnDefinition(
          name: 'insufficientEvidence',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'sourceRevision',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_turn_order',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'notebookId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'turnIndex',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_turn_request',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'requestKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notebook_usage_month',
      dartName: 'NotebookUsageMonthRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'monthUtc',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'spentMicros',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'reservedMicros',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'capMicros',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '10000000',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notebook_usage_month_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'monthUtc',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_notification',
      dartName: 'NotificationRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'recipientId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'eventKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'courseId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'activityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'requestId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'readAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_notification_event_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'recipientId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'eventKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_notification_recipient_time',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'recipientId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_pending_email_change',
      dartName: 'PendingEmailChange',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'requestedEmail',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'verificationCodeHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'credentialVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'resendAvailableAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'verificationAttempts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'locale',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'en\'',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_pending_email_change_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_pending_email_change_user_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_push_device',
      dartName: 'PushDeviceRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'installationId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'registrationId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'platform',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'token',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_push_installation_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'installationId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_push_token_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'token',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_push_owner',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_search_history',
      dartName: 'SearchHistoryRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'query',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'normalized',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'lastUsed',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_search_history_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_search_history_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'normalized',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_search_history_expiry',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lastUsed',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_search_index_chunk',
      dartName: 'SearchIndexChunk',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'jobId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'ordinal',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'content',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'page',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'location',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'embeddingSpace',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'embedding',
          columnType: _isp.ColumnType.vector,
          isNullable: true,
          dartType: 'Vector(1536)?',
          vectorDimension: 1536,
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'poodle_search_index_chunk_fk_0',
          columns: ['jobId'],
          referenceTable: 'poodle_search_index_job',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_search_chunk_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'jobId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ordinal',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_search_index_job',
      dartName: 'SearchIndexJob',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'fingerprint',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'targetId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'attempts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'state',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'queued\'',
        ),
        _isp.ColumnDefinition(
          name: 'availableAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'leaseUntil',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_search_job_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'fingerprint',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'poodle_search_job_pending',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'state',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'availableAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_teacher_defaults',
      dartName: 'TeacherDefaultsRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'settings',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:TeachingSettings',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_teacher_defaults_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_teaching_activity',
      dartName: 'TeachingActivityRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'courseId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'activityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'revision',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'published',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'released',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'settings',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:TeachingSettings',
        ),
        _isp.ColumnDefinition(
          name: 'questions',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TeachingQuestion>',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_teaching_activity_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'activityId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_teaching_attempt',
      dartName: 'TeachingAttemptRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'activityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'versionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'questions',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TeachingQuestion>',
        ),
        _isp.ColumnDefinition(
          name: 'answers',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<int>',
        ),
        _isp.ColumnDefinition(
          name: 'startedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'submittedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'score',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'maxPoints',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_teaching_submission',
      dartName: 'TeachingSubmissionRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'activityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'requestKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'text',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'uploadId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'submittedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'reopenUntil',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'grade',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'feedback',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'gradedBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'published',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_teaching_submission_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ownerId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'requestKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_teaching_upload',
      dartName: 'TeachingUploadRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'activityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ownerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'fileName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sizeBytes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'path',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_teaching_version',
      dartName: 'TeachingVersionRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'activityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'revision',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'settings',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:TeachingSettings',
        ),
        _isp.ColumnDefinition(
          name: 'questions',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TeachingQuestion>',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_teaching_version_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'activityId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'revision',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'poodle_university',
      dartName: 'UniversityRecord',
      schema: 'public',
      module: 'poodle',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'slug',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'poodle_university_slug_unique',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i7m5u5sf.AdminDirectoryRow) {
      return _i7m5u5sf.AdminDirectoryRow.fromJson(data) as T;
    }
    if (t == _igbc6bvq.AdminOverview) {
      return _igbc6bvq.AdminOverview.fromJson(data) as T;
    }
    if (t == _i4d138sj.CourseActivity) {
      return _i4d138sj.CourseActivity.fromJson(data) as T;
    }
    if (t == _ifcq2lyb.CourseActivityRecord) {
      return _ifcq2lyb.CourseActivityRecord.fromJson(data) as T;
    }
    if (t == _ie315swm.CourseAnnouncementInfo) {
      return _ie315swm.CourseAnnouncementInfo.fromJson(data) as T;
    }
    if (t == _iz5q1xt6.CourseAssessmentInfo) {
      return _iz5q1xt6.CourseAssessmentInfo.fromJson(data) as T;
    }
    if (t == _ifi4v4lp.CourseDetail) {
      return _ifi4v4lp.CourseDetail.fromJson(data) as T;
    }
    if (t == _i77ctelr.CourseFileAccess) {
      return _i77ctelr.CourseFileAccess.fromJson(data) as T;
    }
    if (t == _ir759m7l.CourseFileInfo) {
      return _ir759m7l.CourseFileInfo.fromJson(data) as T;
    }
    if (t == _i64ldnq9.CourseLinkInfo) {
      return _i64ldnq9.CourseLinkInfo.fromJson(data) as T;
    }
    if (t == _iz2rpgu0.CourseSection) {
      return _iz2rpgu0.CourseSection.fromJson(data) as T;
    }
    if (t == _i0m1c2n7.CourseSectionRecord) {
      return _i0m1c2n7.CourseSectionRecord.fromJson(data) as T;
    }
    if (t == _ifz8yomu.CourseMembership) {
      return _ifz8yomu.CourseMembership.fromJson(data) as T;
    }
    if (t == _iomyaqit.CoursePreference) {
      return _iomyaqit.CoursePreference.fromJson(data) as T;
    }
    if (t == _i24unjc2.CourseReadException) {
      return _i24unjc2.CourseReadException.fromJson(data) as T;
    }
    if (t == _i5vt3bwt.CourseRecord) {
      return _i5vt3bwt.CourseRecord.fromJson(data) as T;
    }
    if (t == _iyl7g11s.CourseSummary) {
      return _iyl7g11s.CourseSummary.fromJson(data) as T;
    }
    if (t == _ikaa37of.AccessGrantAudit) {
      return _ikaa37of.AccessGrantAudit.fromJson(data) as T;
    }
    if (t == _i9rvlh42.AccountAccess) {
      return _i9rvlh42.AccountAccess.fromJson(data) as T;
    }
    if (t == _is8ljmcy.AccountInvitation) {
      return _is8ljmcy.AccountInvitation.fromJson(data) as T;
    }
    if (t == _iv9gbhnz.AccountSnapshot) {
      return _iv9gbhnz.AccountSnapshot.fromJson(data) as T;
    }
    if (t == _id3azvrd.AdministratorRequestRecord) {
      return _id3azvrd.AdministratorRequestRecord.fromJson(data) as T;
    }
    if (t == _i1c61daw.AdministratorRequestSummary) {
      return _i1c61daw.AdministratorRequestSummary.fromJson(data) as T;
    }
    if (t == _ivy7y4wo.IdentityAccessException) {
      return _ivy7y4wo.IdentityAccessException.fromJson(data) as T;
    }
    if (t == _iod5qrkf.InstitutionMailRecord) {
      return _iod5qrkf.InstitutionMailRecord.fromJson(data) as T;
    }
    if (t == _iayx6x33.InvitationSummary) {
      return _iayx6x33.InvitationSummary.fromJson(data) as T;
    }
    if (t == _ild8fjog.PendingEmailChange) {
      return _ild8fjog.PendingEmailChange.fromJson(data) as T;
    }
    if (t == _infhr8r7.PendingEmailChangeSummary) {
      return _infhr8r7.PendingEmailChangeSummary.fromJson(data) as T;
    }
    if (t == _io4lp5h5.UniversityMemberSummary) {
      return _io4lp5h5.UniversityMemberSummary.fromJson(data) as T;
    }
    if (t == _iukke2qa.UniversityRecord) {
      return _iukke2qa.UniversityRecord.fromJson(data) as T;
    }
    if (t == _i9u2navt.UniversitySummary) {
      return _i9u2navt.UniversitySummary.fromJson(data) as T;
    }
    if (t == _irfgoa0i.ConversationItem) {
      return _irfgoa0i.ConversationItem.fromJson(data) as T;
    }
    if (t == _iep6ikt9.ConversationRecord) {
      return _iep6ikt9.ConversationRecord.fromJson(data) as T;
    }
    if (t == _itmsc93k.EligiblePeer) {
      return _itmsc93k.EligiblePeer.fromJson(data) as T;
    }
    if (t == _iqjq4fel.MessageItem) {
      return _iqjq4fel.MessageItem.fromJson(data) as T;
    }
    if (t == _i6gbxsoc.MessageRecord) {
      return _i6gbxsoc.MessageRecord.fromJson(data) as T;
    }
    if (t == _ipm374v1.ReadCursorRecord) {
      return _ipm374v1.ReadCursorRecord.fromJson(data) as T;
    }
    if (t == _irgxli50.MyUpload) {
      return _irgxli50.MyUpload.fromJson(data) as T;
    }
    if (t == _ikm5gnnf.NotebookArtifactRecord) {
      return _ikm5gnnf.NotebookArtifactRecord.fromJson(data) as T;
    }
    if (t == _iyqh99ur.NotebookAssessmentConfigRecord) {
      return _iyqh99ur.NotebookAssessmentConfigRecord.fromJson(data) as T;
    }
    if (t == _is07a4ho.NotebookAssessmentConfigInput) {
      return _is07a4ho.NotebookAssessmentConfigInput.fromJson(data) as T;
    }
    if (t == _ihd45xsw.NotebookAssessmentConfigView) {
      return _ihd45xsw.NotebookAssessmentConfigView.fromJson(data) as T;
    }
    if (t == _ipjv14xm.NotebookAssessmentMaterialRecord) {
      return _ipjv14xm.NotebookAssessmentMaterialRecord.fromJson(data) as T;
    }
    if (t == _iizyiasx.NotebookAssessmentSetup) {
      return _iizyiasx.NotebookAssessmentSetup.fromJson(data) as T;
    }
    if (t == _i61zjbgu.NotebookAudioAccess) {
      return _i61zjbgu.NotebookAudioAccess.fromJson(data) as T;
    }
    if (t == _iqdu4kxl.NotebookChatInput) {
      return _iqdu4kxl.NotebookChatInput.fromJson(data) as T;
    }
    if (t == _ikcpghjp.NotebookChunkRecord) {
      return _ikcpghjp.NotebookChunkRecord.fromJson(data) as T;
    }
    if (t == _ifnilvb1.NotebookCitation) {
      return _ifnilvb1.NotebookCitation.fromJson(data) as T;
    }
    if (t == _i7g4cm5a.NotebookError) {
      return _i7g4cm5a.NotebookError.fromJson(data) as T;
    }
    if (t == _i2g9bvo0.NotebookJobRecord) {
      return _i2g9bvo0.NotebookJobRecord.fromJson(data) as T;
    }
    if (t == _ioziuoc8.NotebookJobStatus) {
      return _ioziuoc8.NotebookJobStatus.fromJson(data) as T;
    }
    if (t == _ifi9qpbh.NotebookMaterialOption) {
      return _ifi9qpbh.NotebookMaterialOption.fromJson(data) as T;
    }
    if (t == _iz9cuk95.NotebookNoteRecord) {
      return _iz9cuk95.NotebookNoteRecord.fromJson(data) as T;
    }
    if (t == _issssupk.NotebookNoteView) {
      return _issssupk.NotebookNoteView.fromJson(data) as T;
    }
    if (t == _i900zlap.NotebookOverview) {
      return _i900zlap.NotebookOverview.fromJson(data) as T;
    }
    if (t == _inb7o9hq.NotebookRecord) {
      return _inb7o9hq.NotebookRecord.fromJson(data) as T;
    }
    if (t == _ikcceymu.NotebookSourceRecord) {
      return _ikcceymu.NotebookSourceRecord.fromJson(data) as T;
    }
    if (t == _i3v4x43g.NotebookSourceInfo) {
      return _i3v4x43g.NotebookSourceInfo.fromJson(data) as T;
    }
    if (t == _ik9egh2v.NotebookSourceSelectionRecord) {
      return _ik9egh2v.NotebookSourceSelectionRecord.fromJson(data) as T;
    }
    if (t == _i24at178.NotebookSourceVersionRecord) {
      return _i24at178.NotebookSourceVersionRecord.fromJson(data) as T;
    }
    if (t == _ikn9ojxd.NotebookStudioItem) {
      return _ikn9ojxd.NotebookStudioItem.fromJson(data) as T;
    }
    if (t == _ibru614b.NotebookStudioRequest) {
      return _ibru614b.NotebookStudioRequest.fromJson(data) as T;
    }
    if (t == _id2bmit0.NotebookTurnRecord) {
      return _id2bmit0.NotebookTurnRecord.fromJson(data) as T;
    }
    if (t == _itn9r96i.NotebookTurnView) {
      return _itn9r96i.NotebookTurnView.fromJson(data) as T;
    }
    if (t == _iutecm5w.NotebookUploadInput) {
      return _iutecm5w.NotebookUploadInput.fromJson(data) as T;
    }
    if (t == _ijxhmjxo.NotebookUploadTicket) {
      return _ijxhmjxo.NotebookUploadTicket.fromJson(data) as T;
    }
    if (t == _ihblw25m.NotebookUsageMonthRecord) {
      return _ihblw25m.NotebookUsageMonthRecord.fromJson(data) as T;
    }
    if (t == _irfpkdny.NotificationItem) {
      return _irfpkdny.NotificationItem.fromJson(data) as T;
    }
    if (t == _imzzqvl0.NotificationRecord) {
      return _imzzqvl0.NotificationRecord.fromJson(data) as T;
    }
    if (t == _iqdipyx1.PushDeviceRecord) {
      return _iqdipyx1.PushDeviceRecord.fromJson(data) as T;
    }
    if (t == _iu9wgju8.SearchError) {
      return _iu9wgju8.SearchError.fromJson(data) as T;
    }
    if (t == _innntee6.SearchHistoryRecord) {
      return _innntee6.SearchHistoryRecord.fromJson(data) as T;
    }
    if (t == _ih8j6fen.SearchHit) {
      return _ih8j6fen.SearchHit.fromJson(data) as T;
    }
    if (t == _isq81kdq.SearchIndexChunk) {
      return _isq81kdq.SearchIndexChunk.fromJson(data) as T;
    }
    if (t == _i878ch8m.SearchIndexJob) {
      return _i878ch8m.SearchIndexJob.fromJson(data) as T;
    }
    if (t == _i25dmvzp.SearchRecent) {
      return _i25dmvzp.SearchRecent.fromJson(data) as T;
    }
    if (t == _ixylbxq6.SearchResponse) {
      return _ixylbxq6.SearchResponse.fromJson(data) as T;
    }
    if (t == _i7dbfqcs.StudentGradeCourse) {
      return _i7dbfqcs.StudentGradeCourse.fromJson(data) as T;
    }
    if (t == _igwj78dq.StudentGradeRow) {
      return _igwj78dq.StudentGradeRow.fromJson(data) as T;
    }
    if (t == _i38t4enu.StudentGradesResponse) {
      return _i38t4enu.StudentGradesResponse.fromJson(data) as T;
    }
    if (t == _ivkp5op4.StudentTaskRow) {
      return _ivkp5op4.StudentTaskRow.fromJson(data) as T;
    }
    if (t == _ieh9wk3e.StudentTasksResponse) {
      return _ieh9wk3e.StudentTasksResponse.fromJson(data) as T;
    }
    if (t == _is0010g7.TeacherDefaultsRecord) {
      return _is0010g7.TeacherDefaultsRecord.fromJson(data) as T;
    }
    if (t == _i6h3uxby.TeachingActivityRecord) {
      return _i6h3uxby.TeachingActivityRecord.fromJson(data) as T;
    }
    if (t == _i448j8qo.TeachingActivityView) {
      return _i448j8qo.TeachingActivityView.fromJson(data) as T;
    }
    if (t == _iavkgh93.TeachingAttemptRecord) {
      return _iavkgh93.TeachingAttemptRecord.fromJson(data) as T;
    }
    if (t == _ivlau0h8.TeachingAttemptView) {
      return _ivlau0h8.TeachingAttemptView.fromJson(data) as T;
    }
    if (t == _i90cap6h.TeachingCourseView) {
      return _i90cap6h.TeachingCourseView.fromJson(data) as T;
    }
    if (t == _i8oe640j.TeachingError) {
      return _i8oe640j.TeachingError.fromJson(data) as T;
    }
    if (t == _i46b132o.TeachingMemberView) {
      return _i46b132o.TeachingMemberView.fromJson(data) as T;
    }
    if (t == _i3apebh7.TeachingQuestion) {
      return _i3apebh7.TeachingQuestion.fromJson(data) as T;
    }
    if (t == _iyph2036.TeachingSaveInput) {
      return _iyph2036.TeachingSaveInput.fromJson(data) as T;
    }
    if (t == _ir0clk27.TeachingSettings) {
      return _ir0clk27.TeachingSettings.fromJson(data) as T;
    }
    if (t == _iurppijx.TeachingSubmissionRecord) {
      return _iurppijx.TeachingSubmissionRecord.fromJson(data) as T;
    }
    if (t == _ivzwpa04.TeachingSubmissionView) {
      return _ivzwpa04.TeachingSubmissionView.fromJson(data) as T;
    }
    if (t == _ipqd5xy1.TeachingUploadRecord) {
      return _ipqd5xy1.TeachingUploadRecord.fromJson(data) as T;
    }
    if (t == _idy12w3x.TeachingUploadTicket) {
      return _idy12w3x.TeachingUploadTicket.fromJson(data) as T;
    }
    if (t == _isbp4gyn.TeachingVersionRecord) {
      return _isbp4gyn.TeachingVersionRecord.fromJson(data) as T;
    }
    if (t == _is.getType<_i7m5u5sf.AdminDirectoryRow?>()) {
      return (data != null ? _i7m5u5sf.AdminDirectoryRow.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igbc6bvq.AdminOverview?>()) {
      return (data != null ? _igbc6bvq.AdminOverview.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i4d138sj.CourseActivity?>()) {
      return (data != null ? _i4d138sj.CourseActivity.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ifcq2lyb.CourseActivityRecord?>()) {
      return (data != null
              ? _ifcq2lyb.CourseActivityRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ie315swm.CourseAnnouncementInfo?>()) {
      return (data != null
              ? _ie315swm.CourseAnnouncementInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iz5q1xt6.CourseAssessmentInfo?>()) {
      return (data != null
              ? _iz5q1xt6.CourseAssessmentInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ifi4v4lp.CourseDetail?>()) {
      return (data != null ? _ifi4v4lp.CourseDetail.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i77ctelr.CourseFileAccess?>()) {
      return (data != null ? _i77ctelr.CourseFileAccess.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ir759m7l.CourseFileInfo?>()) {
      return (data != null ? _ir759m7l.CourseFileInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i64ldnq9.CourseLinkInfo?>()) {
      return (data != null ? _i64ldnq9.CourseLinkInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iz2rpgu0.CourseSection?>()) {
      return (data != null ? _iz2rpgu0.CourseSection.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i0m1c2n7.CourseSectionRecord?>()) {
      return (data != null
              ? _i0m1c2n7.CourseSectionRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ifz8yomu.CourseMembership?>()) {
      return (data != null ? _ifz8yomu.CourseMembership.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iomyaqit.CoursePreference?>()) {
      return (data != null ? _iomyaqit.CoursePreference.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i24unjc2.CourseReadException?>()) {
      return (data != null
              ? _i24unjc2.CourseReadException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i5vt3bwt.CourseRecord?>()) {
      return (data != null ? _i5vt3bwt.CourseRecord.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyl7g11s.CourseSummary?>()) {
      return (data != null ? _iyl7g11s.CourseSummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikaa37of.AccessGrantAudit?>()) {
      return (data != null ? _ikaa37of.AccessGrantAudit.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i9rvlh42.AccountAccess?>()) {
      return (data != null ? _i9rvlh42.AccountAccess.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_is8ljmcy.AccountInvitation?>()) {
      return (data != null ? _is8ljmcy.AccountInvitation.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iv9gbhnz.AccountSnapshot?>()) {
      return (data != null ? _iv9gbhnz.AccountSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_id3azvrd.AdministratorRequestRecord?>()) {
      return (data != null
              ? _id3azvrd.AdministratorRequestRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i1c61daw.AdministratorRequestSummary?>()) {
      return (data != null
              ? _i1c61daw.AdministratorRequestSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ivy7y4wo.IdentityAccessException?>()) {
      return (data != null
              ? _ivy7y4wo.IdentityAccessException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iod5qrkf.InstitutionMailRecord?>()) {
      return (data != null
              ? _iod5qrkf.InstitutionMailRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iayx6x33.InvitationSummary?>()) {
      return (data != null ? _iayx6x33.InvitationSummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ild8fjog.PendingEmailChange?>()) {
      return (data != null ? _ild8fjog.PendingEmailChange.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_infhr8r7.PendingEmailChangeSummary?>()) {
      return (data != null
              ? _infhr8r7.PendingEmailChangeSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_io4lp5h5.UniversityMemberSummary?>()) {
      return (data != null
              ? _io4lp5h5.UniversityMemberSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iukke2qa.UniversityRecord?>()) {
      return (data != null ? _iukke2qa.UniversityRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i9u2navt.UniversitySummary?>()) {
      return (data != null ? _i9u2navt.UniversitySummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_irfgoa0i.ConversationItem?>()) {
      return (data != null ? _irfgoa0i.ConversationItem.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iep6ikt9.ConversationRecord?>()) {
      return (data != null ? _iep6ikt9.ConversationRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itmsc93k.EligiblePeer?>()) {
      return (data != null ? _itmsc93k.EligiblePeer.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iqjq4fel.MessageItem?>()) {
      return (data != null ? _iqjq4fel.MessageItem.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6gbxsoc.MessageRecord?>()) {
      return (data != null ? _i6gbxsoc.MessageRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ipm374v1.ReadCursorRecord?>()) {
      return (data != null ? _ipm374v1.ReadCursorRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_irgxli50.MyUpload?>()) {
      return (data != null ? _irgxli50.MyUpload.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikm5gnnf.NotebookArtifactRecord?>()) {
      return (data != null
              ? _ikm5gnnf.NotebookArtifactRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iyqh99ur.NotebookAssessmentConfigRecord?>()) {
      return (data != null
              ? _iyqh99ur.NotebookAssessmentConfigRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_is07a4ho.NotebookAssessmentConfigInput?>()) {
      return (data != null
              ? _is07a4ho.NotebookAssessmentConfigInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihd45xsw.NotebookAssessmentConfigView?>()) {
      return (data != null
              ? _ihd45xsw.NotebookAssessmentConfigView.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ipjv14xm.NotebookAssessmentMaterialRecord?>()) {
      return (data != null
              ? _ipjv14xm.NotebookAssessmentMaterialRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iizyiasx.NotebookAssessmentSetup?>()) {
      return (data != null
              ? _iizyiasx.NotebookAssessmentSetup.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i61zjbgu.NotebookAudioAccess?>()) {
      return (data != null
              ? _i61zjbgu.NotebookAudioAccess.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iqdu4kxl.NotebookChatInput?>()) {
      return (data != null ? _iqdu4kxl.NotebookChatInput.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikcpghjp.NotebookChunkRecord?>()) {
      return (data != null
              ? _ikcpghjp.NotebookChunkRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ifnilvb1.NotebookCitation?>()) {
      return (data != null ? _ifnilvb1.NotebookCitation.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i7g4cm5a.NotebookError?>()) {
      return (data != null ? _i7g4cm5a.NotebookError.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i2g9bvo0.NotebookJobRecord?>()) {
      return (data != null ? _i2g9bvo0.NotebookJobRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ioziuoc8.NotebookJobStatus?>()) {
      return (data != null ? _ioziuoc8.NotebookJobStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ifi9qpbh.NotebookMaterialOption?>()) {
      return (data != null
              ? _ifi9qpbh.NotebookMaterialOption.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iz9cuk95.NotebookNoteRecord?>()) {
      return (data != null ? _iz9cuk95.NotebookNoteRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_issssupk.NotebookNoteView?>()) {
      return (data != null ? _issssupk.NotebookNoteView.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i900zlap.NotebookOverview?>()) {
      return (data != null ? _i900zlap.NotebookOverview.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_inb7o9hq.NotebookRecord?>()) {
      return (data != null ? _inb7o9hq.NotebookRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikcceymu.NotebookSourceRecord?>()) {
      return (data != null
              ? _ikcceymu.NotebookSourceRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i3v4x43g.NotebookSourceInfo?>()) {
      return (data != null ? _i3v4x43g.NotebookSourceInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ik9egh2v.NotebookSourceSelectionRecord?>()) {
      return (data != null
              ? _ik9egh2v.NotebookSourceSelectionRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i24at178.NotebookSourceVersionRecord?>()) {
      return (data != null
              ? _i24at178.NotebookSourceVersionRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ikn9ojxd.NotebookStudioItem?>()) {
      return (data != null ? _ikn9ojxd.NotebookStudioItem.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ibru614b.NotebookStudioRequest?>()) {
      return (data != null
              ? _ibru614b.NotebookStudioRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_id2bmit0.NotebookTurnRecord?>()) {
      return (data != null ? _id2bmit0.NotebookTurnRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itn9r96i.NotebookTurnView?>()) {
      return (data != null ? _itn9r96i.NotebookTurnView.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iutecm5w.NotebookUploadInput?>()) {
      return (data != null
              ? _iutecm5w.NotebookUploadInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ijxhmjxo.NotebookUploadTicket?>()) {
      return (data != null
              ? _ijxhmjxo.NotebookUploadTicket.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihblw25m.NotebookUsageMonthRecord?>()) {
      return (data != null
              ? _ihblw25m.NotebookUsageMonthRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_irfpkdny.NotificationItem?>()) {
      return (data != null ? _irfpkdny.NotificationItem.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imzzqvl0.NotificationRecord?>()) {
      return (data != null ? _imzzqvl0.NotificationRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iqdipyx1.PushDeviceRecord?>()) {
      return (data != null ? _iqdipyx1.PushDeviceRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iu9wgju8.SearchError?>()) {
      return (data != null ? _iu9wgju8.SearchError.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_innntee6.SearchHistoryRecord?>()) {
      return (data != null
              ? _innntee6.SearchHistoryRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ih8j6fen.SearchHit?>()) {
      return (data != null ? _ih8j6fen.SearchHit.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_isq81kdq.SearchIndexChunk?>()) {
      return (data != null ? _isq81kdq.SearchIndexChunk.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i878ch8m.SearchIndexJob?>()) {
      return (data != null ? _i878ch8m.SearchIndexJob.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i25dmvzp.SearchRecent?>()) {
      return (data != null ? _i25dmvzp.SearchRecent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixylbxq6.SearchResponse?>()) {
      return (data != null ? _ixylbxq6.SearchResponse.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i7dbfqcs.StudentGradeCourse?>()) {
      return (data != null ? _i7dbfqcs.StudentGradeCourse.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igwj78dq.StudentGradeRow?>()) {
      return (data != null ? _igwj78dq.StudentGradeRow.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i38t4enu.StudentGradesResponse?>()) {
      return (data != null
              ? _i38t4enu.StudentGradesResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ivkp5op4.StudentTaskRow?>()) {
      return (data != null ? _ivkp5op4.StudentTaskRow.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ieh9wk3e.StudentTasksResponse?>()) {
      return (data != null
              ? _ieh9wk3e.StudentTasksResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_is0010g7.TeacherDefaultsRecord?>()) {
      return (data != null
              ? _is0010g7.TeacherDefaultsRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i6h3uxby.TeachingActivityRecord?>()) {
      return (data != null
              ? _i6h3uxby.TeachingActivityRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i448j8qo.TeachingActivityView?>()) {
      return (data != null
              ? _i448j8qo.TeachingActivityView.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iavkgh93.TeachingAttemptRecord?>()) {
      return (data != null
              ? _iavkgh93.TeachingAttemptRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ivlau0h8.TeachingAttemptView?>()) {
      return (data != null
              ? _ivlau0h8.TeachingAttemptView.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i90cap6h.TeachingCourseView?>()) {
      return (data != null ? _i90cap6h.TeachingCourseView.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8oe640j.TeachingError?>()) {
      return (data != null ? _i8oe640j.TeachingError.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i46b132o.TeachingMemberView?>()) {
      return (data != null ? _i46b132o.TeachingMemberView.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i3apebh7.TeachingQuestion?>()) {
      return (data != null ? _i3apebh7.TeachingQuestion.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iyph2036.TeachingSaveInput?>()) {
      return (data != null ? _iyph2036.TeachingSaveInput.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ir0clk27.TeachingSettings?>()) {
      return (data != null ? _ir0clk27.TeachingSettings.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iurppijx.TeachingSubmissionRecord?>()) {
      return (data != null
              ? _iurppijx.TeachingSubmissionRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ivzwpa04.TeachingSubmissionView?>()) {
      return (data != null
              ? _ivzwpa04.TeachingSubmissionView.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ipqd5xy1.TeachingUploadRecord?>()) {
      return (data != null
              ? _ipqd5xy1.TeachingUploadRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_idy12w3x.TeachingUploadTicket?>()) {
      return (data != null
              ? _idy12w3x.TeachingUploadTicket.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_isbp4gyn.TeachingVersionRecord?>()) {
      return (data != null
              ? _isbp4gyn.TeachingVersionRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == List<_iz2rpgu0.CourseSection>) {
      return (data as List)
              .map((e) => deserialize<_iz2rpgu0.CourseSection>(e))
              .toList()
          as T;
    }
    if (t == List<_i4d138sj.CourseActivity>) {
      return (data as List)
              .map((e) => deserialize<_i4d138sj.CourseActivity>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_is.UuidValue>) {
      return (data as List).map((e) => deserialize<_is.UuidValue>(e)).toList()
          as T;
    }
    if (t == List<_ifi9qpbh.NotebookMaterialOption>) {
      return (data as List)
              .map((e) => deserialize<_ifi9qpbh.NotebookMaterialOption>(e))
              .toList()
          as T;
    }
    if (t == List<_i3v4x43g.NotebookSourceInfo>) {
      return (data as List)
              .map((e) => deserialize<_i3v4x43g.NotebookSourceInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_ifnilvb1.NotebookCitation>) {
      return (data as List)
              .map((e) => deserialize<_ifnilvb1.NotebookCitation>(e))
              .toList()
          as T;
    }
    if (t == List<_ih8j6fen.SearchHit>) {
      return (data as List)
              .map((e) => deserialize<_ih8j6fen.SearchHit>(e))
              .toList()
          as T;
    }
    if (t == List<_igwj78dq.StudentGradeRow>) {
      return (data as List)
              .map((e) => deserialize<_igwj78dq.StudentGradeRow>(e))
              .toList()
          as T;
    }
    if (t == List<_i7dbfqcs.StudentGradeCourse>) {
      return (data as List)
              .map((e) => deserialize<_i7dbfqcs.StudentGradeCourse>(e))
              .toList()
          as T;
    }
    if (t == List<_ivkp5op4.StudentTaskRow>) {
      return (data as List)
              .map((e) => deserialize<_ivkp5op4.StudentTaskRow>(e))
              .toList()
          as T;
    }
    if (t == List<_i3apebh7.TeachingQuestion>) {
      return (data as List)
              .map((e) => deserialize<_i3apebh7.TeachingQuestion>(e))
              .toList()
          as T;
    }
    if (t == List<_ivzwpa04.TeachingSubmissionView>) {
      return (data as List)
              .map((e) => deserialize<_ivzwpa04.TeachingSubmissionView>(e))
              .toList()
          as T;
    }
    if (t == List<_ivlau0h8.TeachingAttemptView>) {
      return (data as List)
              .map((e) => deserialize<_ivlau0h8.TeachingAttemptView>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList() as T;
    }
    if (t == List<_igozwii5.AdminDirectoryRow>) {
      return (data as List)
              .map((e) => deserialize<_igozwii5.AdminDirectoryRow>(e))
              .toList()
          as T;
    }
    if (t == List<_ittv3y4z.CourseSummary>) {
      return (data as List)
              .map((e) => deserialize<_ittv3y4z.CourseSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_iaj1deq7.InvitationSummary>) {
      return (data as List)
              .map((e) => deserialize<_iaj1deq7.InvitationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_ihee96mj.AdministratorRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_ihee96mj.AdministratorRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_ighao0f1.UniversitySummary>) {
      return (data as List)
              .map((e) => deserialize<_ighao0f1.UniversitySummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i9y39pis.UniversityMemberSummary>) {
      return (data as List)
              .map((e) => deserialize<_i9y39pis.UniversityMemberSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_ioi3raon.ConversationItem>) {
      return (data as List)
              .map((e) => deserialize<_ioi3raon.ConversationItem>(e))
              .toList()
          as T;
    }
    if (t == List<_iodjvxbh.EligiblePeer>) {
      return (data as List)
              .map((e) => deserialize<_iodjvxbh.EligiblePeer>(e))
              .toList()
          as T;
    }
    if (t == List<_iw88u6c6.MessageItem>) {
      return (data as List)
              .map((e) => deserialize<_iw88u6c6.MessageItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i136jmjd.MyUpload>) {
      return (data as List)
              .map((e) => deserialize<_i136jmjd.MyUpload>(e))
              .toList()
          as T;
    }
    if (t == List<_iw83hlmr.NotebookNoteView>) {
      return (data as List)
              .map((e) => deserialize<_iw83hlmr.NotebookNoteView>(e))
              .toList()
          as T;
    }
    if (t == List<_ixkyvt7w.NotebookTurnView>) {
      return (data as List)
              .map((e) => deserialize<_ixkyvt7w.NotebookTurnView>(e))
              .toList()
          as T;
    }
    if (t == List<_is.UuidValue>) {
      return (data as List).map((e) => deserialize<_is.UuidValue>(e)).toList()
          as T;
    }
    if (t == List<_ih317ylu.NotebookJobStatus>) {
      return (data as List)
              .map((e) => deserialize<_ih317ylu.NotebookJobStatus>(e))
              .toList()
          as T;
    }
    if (t == List<_i9s4xz0t.NotebookStudioItem>) {
      return (data as List)
              .map((e) => deserialize<_i9s4xz0t.NotebookStudioItem>(e))
              .toList()
          as T;
    }
    if (t == List<_iuehrapu.NotificationItem>) {
      return (data as List)
              .map((e) => deserialize<_iuehrapu.NotificationItem>(e))
              .toList()
          as T;
    }
    if (t == List<_ighx7soh.SearchRecent>) {
      return (data as List)
              .map((e) => deserialize<_ighx7soh.SearchRecent>(e))
              .toList()
          as T;
    }
    if (t == List<_iel9ouer.TeachingCourseView>) {
      return (data as List)
              .map((e) => deserialize<_iel9ouer.TeachingCourseView>(e))
              .toList()
          as T;
    }
    if (t == List<_idn1qcra.TeachingMemberView>) {
      return (data as List)
              .map((e) => deserialize<_idn1qcra.TeachingMemberView>(e))
              .toList()
          as T;
    }
    if (t == List<_ic46rxfm.TeachingActivityView>) {
      return (data as List)
              .map((e) => deserialize<_ic46rxfm.TeachingActivityView>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i7m5u5sf.AdminDirectoryRow => 'AdminDirectoryRow',
      _igbc6bvq.AdminOverview => 'AdminOverview',
      _i4d138sj.CourseActivity => 'CourseActivity',
      _ifcq2lyb.CourseActivityRecord => 'CourseActivityRecord',
      _ie315swm.CourseAnnouncementInfo => 'CourseAnnouncementInfo',
      _iz5q1xt6.CourseAssessmentInfo => 'CourseAssessmentInfo',
      _ifi4v4lp.CourseDetail => 'CourseDetail',
      _i77ctelr.CourseFileAccess => 'CourseFileAccess',
      _ir759m7l.CourseFileInfo => 'CourseFileInfo',
      _i64ldnq9.CourseLinkInfo => 'CourseLinkInfo',
      _iz2rpgu0.CourseSection => 'CourseSection',
      _i0m1c2n7.CourseSectionRecord => 'CourseSectionRecord',
      _ifz8yomu.CourseMembership => 'CourseMembership',
      _iomyaqit.CoursePreference => 'CoursePreference',
      _i24unjc2.CourseReadException => 'CourseReadException',
      _i5vt3bwt.CourseRecord => 'CourseRecord',
      _iyl7g11s.CourseSummary => 'CourseSummary',
      _ikaa37of.AccessGrantAudit => 'AccessGrantAudit',
      _i9rvlh42.AccountAccess => 'AccountAccess',
      _is8ljmcy.AccountInvitation => 'AccountInvitation',
      _iv9gbhnz.AccountSnapshot => 'AccountSnapshot',
      _id3azvrd.AdministratorRequestRecord => 'AdministratorRequestRecord',
      _i1c61daw.AdministratorRequestSummary => 'AdministratorRequestSummary',
      _ivy7y4wo.IdentityAccessException => 'IdentityAccessException',
      _iod5qrkf.InstitutionMailRecord => 'InstitutionMailRecord',
      _iayx6x33.InvitationSummary => 'InvitationSummary',
      _ild8fjog.PendingEmailChange => 'PendingEmailChange',
      _infhr8r7.PendingEmailChangeSummary => 'PendingEmailChangeSummary',
      _io4lp5h5.UniversityMemberSummary => 'UniversityMemberSummary',
      _iukke2qa.UniversityRecord => 'UniversityRecord',
      _i9u2navt.UniversitySummary => 'UniversitySummary',
      _irfgoa0i.ConversationItem => 'ConversationItem',
      _iep6ikt9.ConversationRecord => 'ConversationRecord',
      _itmsc93k.EligiblePeer => 'EligiblePeer',
      _iqjq4fel.MessageItem => 'MessageItem',
      _i6gbxsoc.MessageRecord => 'MessageRecord',
      _ipm374v1.ReadCursorRecord => 'ReadCursorRecord',
      _irgxli50.MyUpload => 'MyUpload',
      _ikm5gnnf.NotebookArtifactRecord => 'NotebookArtifactRecord',
      _iyqh99ur.NotebookAssessmentConfigRecord =>
        'NotebookAssessmentConfigRecord',
      _is07a4ho.NotebookAssessmentConfigInput =>
        'NotebookAssessmentConfigInput',
      _ihd45xsw.NotebookAssessmentConfigView => 'NotebookAssessmentConfigView',
      _ipjv14xm.NotebookAssessmentMaterialRecord =>
        'NotebookAssessmentMaterialRecord',
      _iizyiasx.NotebookAssessmentSetup => 'NotebookAssessmentSetup',
      _i61zjbgu.NotebookAudioAccess => 'NotebookAudioAccess',
      _iqdu4kxl.NotebookChatInput => 'NotebookChatInput',
      _ikcpghjp.NotebookChunkRecord => 'NotebookChunkRecord',
      _ifnilvb1.NotebookCitation => 'NotebookCitation',
      _i7g4cm5a.NotebookError => 'NotebookError',
      _i2g9bvo0.NotebookJobRecord => 'NotebookJobRecord',
      _ioziuoc8.NotebookJobStatus => 'NotebookJobStatus',
      _ifi9qpbh.NotebookMaterialOption => 'NotebookMaterialOption',
      _iz9cuk95.NotebookNoteRecord => 'NotebookNoteRecord',
      _issssupk.NotebookNoteView => 'NotebookNoteView',
      _i900zlap.NotebookOverview => 'NotebookOverview',
      _inb7o9hq.NotebookRecord => 'NotebookRecord',
      _ikcceymu.NotebookSourceRecord => 'NotebookSourceRecord',
      _i3v4x43g.NotebookSourceInfo => 'NotebookSourceInfo',
      _ik9egh2v.NotebookSourceSelectionRecord =>
        'NotebookSourceSelectionRecord',
      _i24at178.NotebookSourceVersionRecord => 'NotebookSourceVersionRecord',
      _ikn9ojxd.NotebookStudioItem => 'NotebookStudioItem',
      _ibru614b.NotebookStudioRequest => 'NotebookStudioRequest',
      _id2bmit0.NotebookTurnRecord => 'NotebookTurnRecord',
      _itn9r96i.NotebookTurnView => 'NotebookTurnView',
      _iutecm5w.NotebookUploadInput => 'NotebookUploadInput',
      _ijxhmjxo.NotebookUploadTicket => 'NotebookUploadTicket',
      _ihblw25m.NotebookUsageMonthRecord => 'NotebookUsageMonthRecord',
      _irfpkdny.NotificationItem => 'NotificationItem',
      _imzzqvl0.NotificationRecord => 'NotificationRecord',
      _iqdipyx1.PushDeviceRecord => 'PushDeviceRecord',
      _iu9wgju8.SearchError => 'SearchError',
      _innntee6.SearchHistoryRecord => 'SearchHistoryRecord',
      _ih8j6fen.SearchHit => 'SearchHit',
      _isq81kdq.SearchIndexChunk => 'SearchIndexChunk',
      _i878ch8m.SearchIndexJob => 'SearchIndexJob',
      _i25dmvzp.SearchRecent => 'SearchRecent',
      _ixylbxq6.SearchResponse => 'SearchResponse',
      _i7dbfqcs.StudentGradeCourse => 'StudentGradeCourse',
      _igwj78dq.StudentGradeRow => 'StudentGradeRow',
      _i38t4enu.StudentGradesResponse => 'StudentGradesResponse',
      _ivkp5op4.StudentTaskRow => 'StudentTaskRow',
      _ieh9wk3e.StudentTasksResponse => 'StudentTasksResponse',
      _is0010g7.TeacherDefaultsRecord => 'TeacherDefaultsRecord',
      _i6h3uxby.TeachingActivityRecord => 'TeachingActivityRecord',
      _i448j8qo.TeachingActivityView => 'TeachingActivityView',
      _iavkgh93.TeachingAttemptRecord => 'TeachingAttemptRecord',
      _ivlau0h8.TeachingAttemptView => 'TeachingAttemptView',
      _i90cap6h.TeachingCourseView => 'TeachingCourseView',
      _i8oe640j.TeachingError => 'TeachingError',
      _i46b132o.TeachingMemberView => 'TeachingMemberView',
      _i3apebh7.TeachingQuestion => 'TeachingQuestion',
      _iyph2036.TeachingSaveInput => 'TeachingSaveInput',
      _ir0clk27.TeachingSettings => 'TeachingSettings',
      _iurppijx.TeachingSubmissionRecord => 'TeachingSubmissionRecord',
      _ivzwpa04.TeachingSubmissionView => 'TeachingSubmissionView',
      _ipqd5xy1.TeachingUploadRecord => 'TeachingUploadRecord',
      _idy12w3x.TeachingUploadTicket => 'TeachingUploadTicket',
      _isbp4gyn.TeachingVersionRecord => 'TeachingVersionRecord',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('poodle.', '');
    }

    switch (data) {
      case _i7m5u5sf.AdminDirectoryRow():
        return 'AdminDirectoryRow';
      case _igbc6bvq.AdminOverview():
        return 'AdminOverview';
      case _i4d138sj.CourseActivity():
        return 'CourseActivity';
      case _ifcq2lyb.CourseActivityRecord():
        return 'CourseActivityRecord';
      case _ie315swm.CourseAnnouncementInfo():
        return 'CourseAnnouncementInfo';
      case _iz5q1xt6.CourseAssessmentInfo():
        return 'CourseAssessmentInfo';
      case _ifi4v4lp.CourseDetail():
        return 'CourseDetail';
      case _i77ctelr.CourseFileAccess():
        return 'CourseFileAccess';
      case _ir759m7l.CourseFileInfo():
        return 'CourseFileInfo';
      case _i64ldnq9.CourseLinkInfo():
        return 'CourseLinkInfo';
      case _iz2rpgu0.CourseSection():
        return 'CourseSection';
      case _i0m1c2n7.CourseSectionRecord():
        return 'CourseSectionRecord';
      case _ifz8yomu.CourseMembership():
        return 'CourseMembership';
      case _iomyaqit.CoursePreference():
        return 'CoursePreference';
      case _i24unjc2.CourseReadException():
        return 'CourseReadException';
      case _i5vt3bwt.CourseRecord():
        return 'CourseRecord';
      case _iyl7g11s.CourseSummary():
        return 'CourseSummary';
      case _ikaa37of.AccessGrantAudit():
        return 'AccessGrantAudit';
      case _i9rvlh42.AccountAccess():
        return 'AccountAccess';
      case _is8ljmcy.AccountInvitation():
        return 'AccountInvitation';
      case _iv9gbhnz.AccountSnapshot():
        return 'AccountSnapshot';
      case _id3azvrd.AdministratorRequestRecord():
        return 'AdministratorRequestRecord';
      case _i1c61daw.AdministratorRequestSummary():
        return 'AdministratorRequestSummary';
      case _ivy7y4wo.IdentityAccessException():
        return 'IdentityAccessException';
      case _iod5qrkf.InstitutionMailRecord():
        return 'InstitutionMailRecord';
      case _iayx6x33.InvitationSummary():
        return 'InvitationSummary';
      case _ild8fjog.PendingEmailChange():
        return 'PendingEmailChange';
      case _infhr8r7.PendingEmailChangeSummary():
        return 'PendingEmailChangeSummary';
      case _io4lp5h5.UniversityMemberSummary():
        return 'UniversityMemberSummary';
      case _iukke2qa.UniversityRecord():
        return 'UniversityRecord';
      case _i9u2navt.UniversitySummary():
        return 'UniversitySummary';
      case _irfgoa0i.ConversationItem():
        return 'ConversationItem';
      case _iep6ikt9.ConversationRecord():
        return 'ConversationRecord';
      case _itmsc93k.EligiblePeer():
        return 'EligiblePeer';
      case _iqjq4fel.MessageItem():
        return 'MessageItem';
      case _i6gbxsoc.MessageRecord():
        return 'MessageRecord';
      case _ipm374v1.ReadCursorRecord():
        return 'ReadCursorRecord';
      case _irgxli50.MyUpload():
        return 'MyUpload';
      case _ikm5gnnf.NotebookArtifactRecord():
        return 'NotebookArtifactRecord';
      case _iyqh99ur.NotebookAssessmentConfigRecord():
        return 'NotebookAssessmentConfigRecord';
      case _is07a4ho.NotebookAssessmentConfigInput():
        return 'NotebookAssessmentConfigInput';
      case _ihd45xsw.NotebookAssessmentConfigView():
        return 'NotebookAssessmentConfigView';
      case _ipjv14xm.NotebookAssessmentMaterialRecord():
        return 'NotebookAssessmentMaterialRecord';
      case _iizyiasx.NotebookAssessmentSetup():
        return 'NotebookAssessmentSetup';
      case _i61zjbgu.NotebookAudioAccess():
        return 'NotebookAudioAccess';
      case _iqdu4kxl.NotebookChatInput():
        return 'NotebookChatInput';
      case _ikcpghjp.NotebookChunkRecord():
        return 'NotebookChunkRecord';
      case _ifnilvb1.NotebookCitation():
        return 'NotebookCitation';
      case _i7g4cm5a.NotebookError():
        return 'NotebookError';
      case _i2g9bvo0.NotebookJobRecord():
        return 'NotebookJobRecord';
      case _ioziuoc8.NotebookJobStatus():
        return 'NotebookJobStatus';
      case _ifi9qpbh.NotebookMaterialOption():
        return 'NotebookMaterialOption';
      case _iz9cuk95.NotebookNoteRecord():
        return 'NotebookNoteRecord';
      case _issssupk.NotebookNoteView():
        return 'NotebookNoteView';
      case _i900zlap.NotebookOverview():
        return 'NotebookOverview';
      case _inb7o9hq.NotebookRecord():
        return 'NotebookRecord';
      case _ikcceymu.NotebookSourceRecord():
        return 'NotebookSourceRecord';
      case _i3v4x43g.NotebookSourceInfo():
        return 'NotebookSourceInfo';
      case _ik9egh2v.NotebookSourceSelectionRecord():
        return 'NotebookSourceSelectionRecord';
      case _i24at178.NotebookSourceVersionRecord():
        return 'NotebookSourceVersionRecord';
      case _ikn9ojxd.NotebookStudioItem():
        return 'NotebookStudioItem';
      case _ibru614b.NotebookStudioRequest():
        return 'NotebookStudioRequest';
      case _id2bmit0.NotebookTurnRecord():
        return 'NotebookTurnRecord';
      case _itn9r96i.NotebookTurnView():
        return 'NotebookTurnView';
      case _iutecm5w.NotebookUploadInput():
        return 'NotebookUploadInput';
      case _ijxhmjxo.NotebookUploadTicket():
        return 'NotebookUploadTicket';
      case _ihblw25m.NotebookUsageMonthRecord():
        return 'NotebookUsageMonthRecord';
      case _irfpkdny.NotificationItem():
        return 'NotificationItem';
      case _imzzqvl0.NotificationRecord():
        return 'NotificationRecord';
      case _iqdipyx1.PushDeviceRecord():
        return 'PushDeviceRecord';
      case _iu9wgju8.SearchError():
        return 'SearchError';
      case _innntee6.SearchHistoryRecord():
        return 'SearchHistoryRecord';
      case _ih8j6fen.SearchHit():
        return 'SearchHit';
      case _isq81kdq.SearchIndexChunk():
        return 'SearchIndexChunk';
      case _i878ch8m.SearchIndexJob():
        return 'SearchIndexJob';
      case _i25dmvzp.SearchRecent():
        return 'SearchRecent';
      case _ixylbxq6.SearchResponse():
        return 'SearchResponse';
      case _i7dbfqcs.StudentGradeCourse():
        return 'StudentGradeCourse';
      case _igwj78dq.StudentGradeRow():
        return 'StudentGradeRow';
      case _i38t4enu.StudentGradesResponse():
        return 'StudentGradesResponse';
      case _ivkp5op4.StudentTaskRow():
        return 'StudentTaskRow';
      case _ieh9wk3e.StudentTasksResponse():
        return 'StudentTasksResponse';
      case _is0010g7.TeacherDefaultsRecord():
        return 'TeacherDefaultsRecord';
      case _i6h3uxby.TeachingActivityRecord():
        return 'TeachingActivityRecord';
      case _i448j8qo.TeachingActivityView():
        return 'TeachingActivityView';
      case _iavkgh93.TeachingAttemptRecord():
        return 'TeachingAttemptRecord';
      case _ivlau0h8.TeachingAttemptView():
        return 'TeachingAttemptView';
      case _i90cap6h.TeachingCourseView():
        return 'TeachingCourseView';
      case _i8oe640j.TeachingError():
        return 'TeachingError';
      case _i46b132o.TeachingMemberView():
        return 'TeachingMemberView';
      case _i3apebh7.TeachingQuestion():
        return 'TeachingQuestion';
      case _iyph2036.TeachingSaveInput():
        return 'TeachingSaveInput';
      case _ir0clk27.TeachingSettings():
        return 'TeachingSettings';
      case _iurppijx.TeachingSubmissionRecord():
        return 'TeachingSubmissionRecord';
      case _ivzwpa04.TeachingSubmissionView():
        return 'TeachingSubmissionView';
      case _ipqd5xy1.TeachingUploadRecord():
        return 'TeachingUploadRecord';
      case _idy12w3x.TeachingUploadTicket():
        return 'TeachingUploadTicket';
      case _isbp4gyn.TeachingVersionRecord():
        return 'TeachingVersionRecord';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AdminDirectoryRow') {
      return deserialize<_i7m5u5sf.AdminDirectoryRow>(data['data']);
    }
    if (dataClassName == 'AdminOverview') {
      return deserialize<_igbc6bvq.AdminOverview>(data['data']);
    }
    if (dataClassName == 'CourseActivity') {
      return deserialize<_i4d138sj.CourseActivity>(data['data']);
    }
    if (dataClassName == 'CourseActivityRecord') {
      return deserialize<_ifcq2lyb.CourseActivityRecord>(data['data']);
    }
    if (dataClassName == 'CourseAnnouncementInfo') {
      return deserialize<_ie315swm.CourseAnnouncementInfo>(data['data']);
    }
    if (dataClassName == 'CourseAssessmentInfo') {
      return deserialize<_iz5q1xt6.CourseAssessmentInfo>(data['data']);
    }
    if (dataClassName == 'CourseDetail') {
      return deserialize<_ifi4v4lp.CourseDetail>(data['data']);
    }
    if (dataClassName == 'CourseFileAccess') {
      return deserialize<_i77ctelr.CourseFileAccess>(data['data']);
    }
    if (dataClassName == 'CourseFileInfo') {
      return deserialize<_ir759m7l.CourseFileInfo>(data['data']);
    }
    if (dataClassName == 'CourseLinkInfo') {
      return deserialize<_i64ldnq9.CourseLinkInfo>(data['data']);
    }
    if (dataClassName == 'CourseSection') {
      return deserialize<_iz2rpgu0.CourseSection>(data['data']);
    }
    if (dataClassName == 'CourseSectionRecord') {
      return deserialize<_i0m1c2n7.CourseSectionRecord>(data['data']);
    }
    if (dataClassName == 'CourseMembership') {
      return deserialize<_ifz8yomu.CourseMembership>(data['data']);
    }
    if (dataClassName == 'CoursePreference') {
      return deserialize<_iomyaqit.CoursePreference>(data['data']);
    }
    if (dataClassName == 'CourseReadException') {
      return deserialize<_i24unjc2.CourseReadException>(data['data']);
    }
    if (dataClassName == 'CourseRecord') {
      return deserialize<_i5vt3bwt.CourseRecord>(data['data']);
    }
    if (dataClassName == 'CourseSummary') {
      return deserialize<_iyl7g11s.CourseSummary>(data['data']);
    }
    if (dataClassName == 'AccessGrantAudit') {
      return deserialize<_ikaa37of.AccessGrantAudit>(data['data']);
    }
    if (dataClassName == 'AccountAccess') {
      return deserialize<_i9rvlh42.AccountAccess>(data['data']);
    }
    if (dataClassName == 'AccountInvitation') {
      return deserialize<_is8ljmcy.AccountInvitation>(data['data']);
    }
    if (dataClassName == 'AccountSnapshot') {
      return deserialize<_iv9gbhnz.AccountSnapshot>(data['data']);
    }
    if (dataClassName == 'AdministratorRequestRecord') {
      return deserialize<_id3azvrd.AdministratorRequestRecord>(data['data']);
    }
    if (dataClassName == 'AdministratorRequestSummary') {
      return deserialize<_i1c61daw.AdministratorRequestSummary>(data['data']);
    }
    if (dataClassName == 'IdentityAccessException') {
      return deserialize<_ivy7y4wo.IdentityAccessException>(data['data']);
    }
    if (dataClassName == 'InstitutionMailRecord') {
      return deserialize<_iod5qrkf.InstitutionMailRecord>(data['data']);
    }
    if (dataClassName == 'InvitationSummary') {
      return deserialize<_iayx6x33.InvitationSummary>(data['data']);
    }
    if (dataClassName == 'PendingEmailChange') {
      return deserialize<_ild8fjog.PendingEmailChange>(data['data']);
    }
    if (dataClassName == 'PendingEmailChangeSummary') {
      return deserialize<_infhr8r7.PendingEmailChangeSummary>(data['data']);
    }
    if (dataClassName == 'UniversityMemberSummary') {
      return deserialize<_io4lp5h5.UniversityMemberSummary>(data['data']);
    }
    if (dataClassName == 'UniversityRecord') {
      return deserialize<_iukke2qa.UniversityRecord>(data['data']);
    }
    if (dataClassName == 'UniversitySummary') {
      return deserialize<_i9u2navt.UniversitySummary>(data['data']);
    }
    if (dataClassName == 'ConversationItem') {
      return deserialize<_irfgoa0i.ConversationItem>(data['data']);
    }
    if (dataClassName == 'ConversationRecord') {
      return deserialize<_iep6ikt9.ConversationRecord>(data['data']);
    }
    if (dataClassName == 'EligiblePeer') {
      return deserialize<_itmsc93k.EligiblePeer>(data['data']);
    }
    if (dataClassName == 'MessageItem') {
      return deserialize<_iqjq4fel.MessageItem>(data['data']);
    }
    if (dataClassName == 'MessageRecord') {
      return deserialize<_i6gbxsoc.MessageRecord>(data['data']);
    }
    if (dataClassName == 'ReadCursorRecord') {
      return deserialize<_ipm374v1.ReadCursorRecord>(data['data']);
    }
    if (dataClassName == 'MyUpload') {
      return deserialize<_irgxli50.MyUpload>(data['data']);
    }
    if (dataClassName == 'NotebookArtifactRecord') {
      return deserialize<_ikm5gnnf.NotebookArtifactRecord>(data['data']);
    }
    if (dataClassName == 'NotebookAssessmentConfigRecord') {
      return deserialize<_iyqh99ur.NotebookAssessmentConfigRecord>(
        data['data'],
      );
    }
    if (dataClassName == 'NotebookAssessmentConfigInput') {
      return deserialize<_is07a4ho.NotebookAssessmentConfigInput>(data['data']);
    }
    if (dataClassName == 'NotebookAssessmentConfigView') {
      return deserialize<_ihd45xsw.NotebookAssessmentConfigView>(data['data']);
    }
    if (dataClassName == 'NotebookAssessmentMaterialRecord') {
      return deserialize<_ipjv14xm.NotebookAssessmentMaterialRecord>(
        data['data'],
      );
    }
    if (dataClassName == 'NotebookAssessmentSetup') {
      return deserialize<_iizyiasx.NotebookAssessmentSetup>(data['data']);
    }
    if (dataClassName == 'NotebookAudioAccess') {
      return deserialize<_i61zjbgu.NotebookAudioAccess>(data['data']);
    }
    if (dataClassName == 'NotebookChatInput') {
      return deserialize<_iqdu4kxl.NotebookChatInput>(data['data']);
    }
    if (dataClassName == 'NotebookChunkRecord') {
      return deserialize<_ikcpghjp.NotebookChunkRecord>(data['data']);
    }
    if (dataClassName == 'NotebookCitation') {
      return deserialize<_ifnilvb1.NotebookCitation>(data['data']);
    }
    if (dataClassName == 'NotebookError') {
      return deserialize<_i7g4cm5a.NotebookError>(data['data']);
    }
    if (dataClassName == 'NotebookJobRecord') {
      return deserialize<_i2g9bvo0.NotebookJobRecord>(data['data']);
    }
    if (dataClassName == 'NotebookJobStatus') {
      return deserialize<_ioziuoc8.NotebookJobStatus>(data['data']);
    }
    if (dataClassName == 'NotebookMaterialOption') {
      return deserialize<_ifi9qpbh.NotebookMaterialOption>(data['data']);
    }
    if (dataClassName == 'NotebookNoteRecord') {
      return deserialize<_iz9cuk95.NotebookNoteRecord>(data['data']);
    }
    if (dataClassName == 'NotebookNoteView') {
      return deserialize<_issssupk.NotebookNoteView>(data['data']);
    }
    if (dataClassName == 'NotebookOverview') {
      return deserialize<_i900zlap.NotebookOverview>(data['data']);
    }
    if (dataClassName == 'NotebookRecord') {
      return deserialize<_inb7o9hq.NotebookRecord>(data['data']);
    }
    if (dataClassName == 'NotebookSourceRecord') {
      return deserialize<_ikcceymu.NotebookSourceRecord>(data['data']);
    }
    if (dataClassName == 'NotebookSourceInfo') {
      return deserialize<_i3v4x43g.NotebookSourceInfo>(data['data']);
    }
    if (dataClassName == 'NotebookSourceSelectionRecord') {
      return deserialize<_ik9egh2v.NotebookSourceSelectionRecord>(data['data']);
    }
    if (dataClassName == 'NotebookSourceVersionRecord') {
      return deserialize<_i24at178.NotebookSourceVersionRecord>(data['data']);
    }
    if (dataClassName == 'NotebookStudioItem') {
      return deserialize<_ikn9ojxd.NotebookStudioItem>(data['data']);
    }
    if (dataClassName == 'NotebookStudioRequest') {
      return deserialize<_ibru614b.NotebookStudioRequest>(data['data']);
    }
    if (dataClassName == 'NotebookTurnRecord') {
      return deserialize<_id2bmit0.NotebookTurnRecord>(data['data']);
    }
    if (dataClassName == 'NotebookTurnView') {
      return deserialize<_itn9r96i.NotebookTurnView>(data['data']);
    }
    if (dataClassName == 'NotebookUploadInput') {
      return deserialize<_iutecm5w.NotebookUploadInput>(data['data']);
    }
    if (dataClassName == 'NotebookUploadTicket') {
      return deserialize<_ijxhmjxo.NotebookUploadTicket>(data['data']);
    }
    if (dataClassName == 'NotebookUsageMonthRecord') {
      return deserialize<_ihblw25m.NotebookUsageMonthRecord>(data['data']);
    }
    if (dataClassName == 'NotificationItem') {
      return deserialize<_irfpkdny.NotificationItem>(data['data']);
    }
    if (dataClassName == 'NotificationRecord') {
      return deserialize<_imzzqvl0.NotificationRecord>(data['data']);
    }
    if (dataClassName == 'PushDeviceRecord') {
      return deserialize<_iqdipyx1.PushDeviceRecord>(data['data']);
    }
    if (dataClassName == 'SearchError') {
      return deserialize<_iu9wgju8.SearchError>(data['data']);
    }
    if (dataClassName == 'SearchHistoryRecord') {
      return deserialize<_innntee6.SearchHistoryRecord>(data['data']);
    }
    if (dataClassName == 'SearchHit') {
      return deserialize<_ih8j6fen.SearchHit>(data['data']);
    }
    if (dataClassName == 'SearchIndexChunk') {
      return deserialize<_isq81kdq.SearchIndexChunk>(data['data']);
    }
    if (dataClassName == 'SearchIndexJob') {
      return deserialize<_i878ch8m.SearchIndexJob>(data['data']);
    }
    if (dataClassName == 'SearchRecent') {
      return deserialize<_i25dmvzp.SearchRecent>(data['data']);
    }
    if (dataClassName == 'SearchResponse') {
      return deserialize<_ixylbxq6.SearchResponse>(data['data']);
    }
    if (dataClassName == 'StudentGradeCourse') {
      return deserialize<_i7dbfqcs.StudentGradeCourse>(data['data']);
    }
    if (dataClassName == 'StudentGradeRow') {
      return deserialize<_igwj78dq.StudentGradeRow>(data['data']);
    }
    if (dataClassName == 'StudentGradesResponse') {
      return deserialize<_i38t4enu.StudentGradesResponse>(data['data']);
    }
    if (dataClassName == 'StudentTaskRow') {
      return deserialize<_ivkp5op4.StudentTaskRow>(data['data']);
    }
    if (dataClassName == 'StudentTasksResponse') {
      return deserialize<_ieh9wk3e.StudentTasksResponse>(data['data']);
    }
    if (dataClassName == 'TeacherDefaultsRecord') {
      return deserialize<_is0010g7.TeacherDefaultsRecord>(data['data']);
    }
    if (dataClassName == 'TeachingActivityRecord') {
      return deserialize<_i6h3uxby.TeachingActivityRecord>(data['data']);
    }
    if (dataClassName == 'TeachingActivityView') {
      return deserialize<_i448j8qo.TeachingActivityView>(data['data']);
    }
    if (dataClassName == 'TeachingAttemptRecord') {
      return deserialize<_iavkgh93.TeachingAttemptRecord>(data['data']);
    }
    if (dataClassName == 'TeachingAttemptView') {
      return deserialize<_ivlau0h8.TeachingAttemptView>(data['data']);
    }
    if (dataClassName == 'TeachingCourseView') {
      return deserialize<_i90cap6h.TeachingCourseView>(data['data']);
    }
    if (dataClassName == 'TeachingError') {
      return deserialize<_i8oe640j.TeachingError>(data['data']);
    }
    if (dataClassName == 'TeachingMemberView') {
      return deserialize<_i46b132o.TeachingMemberView>(data['data']);
    }
    if (dataClassName == 'TeachingQuestion') {
      return deserialize<_i3apebh7.TeachingQuestion>(data['data']);
    }
    if (dataClassName == 'TeachingSaveInput') {
      return deserialize<_iyph2036.TeachingSaveInput>(data['data']);
    }
    if (dataClassName == 'TeachingSettings') {
      return deserialize<_ir0clk27.TeachingSettings>(data['data']);
    }
    if (dataClassName == 'TeachingSubmissionRecord') {
      return deserialize<_iurppijx.TeachingSubmissionRecord>(data['data']);
    }
    if (dataClassName == 'TeachingSubmissionView') {
      return deserialize<_ivzwpa04.TeachingSubmissionView>(data['data']);
    }
    if (dataClassName == 'TeachingUploadRecord') {
      return deserialize<_ipqd5xy1.TeachingUploadRecord>(data['data']);
    }
    if (dataClassName == 'TeachingUploadTicket') {
      return deserialize<_idy12w3x.TeachingUploadTicket>(data['data']);
    }
    if (dataClassName == 'TeachingVersionRecord') {
      return deserialize<_isbp4gyn.TeachingVersionRecord>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('poodle', this);
    _iacs.Protocol().registerHostProtocol('poodle', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ifcq2lyb.CourseActivityRecord:
        return _ifcq2lyb.CourseActivityRecord.t;
      case _i0m1c2n7.CourseSectionRecord:
        return _i0m1c2n7.CourseSectionRecord.t;
      case _ifz8yomu.CourseMembership:
        return _ifz8yomu.CourseMembership.t;
      case _iomyaqit.CoursePreference:
        return _iomyaqit.CoursePreference.t;
      case _i5vt3bwt.CourseRecord:
        return _i5vt3bwt.CourseRecord.t;
      case _ikaa37of.AccessGrantAudit:
        return _ikaa37of.AccessGrantAudit.t;
      case _i9rvlh42.AccountAccess:
        return _i9rvlh42.AccountAccess.t;
      case _is8ljmcy.AccountInvitation:
        return _is8ljmcy.AccountInvitation.t;
      case _id3azvrd.AdministratorRequestRecord:
        return _id3azvrd.AdministratorRequestRecord.t;
      case _iod5qrkf.InstitutionMailRecord:
        return _iod5qrkf.InstitutionMailRecord.t;
      case _ild8fjog.PendingEmailChange:
        return _ild8fjog.PendingEmailChange.t;
      case _iukke2qa.UniversityRecord:
        return _iukke2qa.UniversityRecord.t;
      case _iep6ikt9.ConversationRecord:
        return _iep6ikt9.ConversationRecord.t;
      case _i6gbxsoc.MessageRecord:
        return _i6gbxsoc.MessageRecord.t;
      case _ipm374v1.ReadCursorRecord:
        return _ipm374v1.ReadCursorRecord.t;
      case _ikm5gnnf.NotebookArtifactRecord:
        return _ikm5gnnf.NotebookArtifactRecord.t;
      case _iyqh99ur.NotebookAssessmentConfigRecord:
        return _iyqh99ur.NotebookAssessmentConfigRecord.t;
      case _ipjv14xm.NotebookAssessmentMaterialRecord:
        return _ipjv14xm.NotebookAssessmentMaterialRecord.t;
      case _ikcpghjp.NotebookChunkRecord:
        return _ikcpghjp.NotebookChunkRecord.t;
      case _i2g9bvo0.NotebookJobRecord:
        return _i2g9bvo0.NotebookJobRecord.t;
      case _iz9cuk95.NotebookNoteRecord:
        return _iz9cuk95.NotebookNoteRecord.t;
      case _inb7o9hq.NotebookRecord:
        return _inb7o9hq.NotebookRecord.t;
      case _ikcceymu.NotebookSourceRecord:
        return _ikcceymu.NotebookSourceRecord.t;
      case _ik9egh2v.NotebookSourceSelectionRecord:
        return _ik9egh2v.NotebookSourceSelectionRecord.t;
      case _i24at178.NotebookSourceVersionRecord:
        return _i24at178.NotebookSourceVersionRecord.t;
      case _id2bmit0.NotebookTurnRecord:
        return _id2bmit0.NotebookTurnRecord.t;
      case _ihblw25m.NotebookUsageMonthRecord:
        return _ihblw25m.NotebookUsageMonthRecord.t;
      case _imzzqvl0.NotificationRecord:
        return _imzzqvl0.NotificationRecord.t;
      case _iqdipyx1.PushDeviceRecord:
        return _iqdipyx1.PushDeviceRecord.t;
      case _innntee6.SearchHistoryRecord:
        return _innntee6.SearchHistoryRecord.t;
      case _isq81kdq.SearchIndexChunk:
        return _isq81kdq.SearchIndexChunk.t;
      case _i878ch8m.SearchIndexJob:
        return _i878ch8m.SearchIndexJob.t;
      case _is0010g7.TeacherDefaultsRecord:
        return _is0010g7.TeacherDefaultsRecord.t;
      case _i6h3uxby.TeachingActivityRecord:
        return _i6h3uxby.TeachingActivityRecord.t;
      case _iavkgh93.TeachingAttemptRecord:
        return _iavkgh93.TeachingAttemptRecord.t;
      case _iurppijx.TeachingSubmissionRecord:
        return _iurppijx.TeachingSubmissionRecord.t;
      case _ipqd5xy1.TeachingUploadRecord:
        return _ipqd5xy1.TeachingUploadRecord.t;
      case _isbp4gyn.TeachingVersionRecord:
        return _isbp4gyn.TeachingVersionRecord.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'poodle';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
