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
import 'package:poodle_client/src/protocol/modules/admin/admin_directory_row.dart'
    as _ia5bj8wh;
import 'package:poodle_client/src/protocol/modules/courses/course_summary.dart'
    as _ip3pjnpw;
import 'package:poodle_client/src/protocol/modules/identity/administrator_request_summary.dart'
    as _i31qaluo;
import 'package:poodle_client/src/protocol/modules/identity/invitation_summary.dart'
    as _i9078z8p;
import 'package:poodle_client/src/protocol/modules/identity/university_member_summary.dart'
    as _iijs4wax;
import 'package:poodle_client/src/protocol/modules/identity/university_summary.dart'
    as _i5j7k3lx;
import 'package:poodle_client/src/protocol/modules/messaging/conversation_item.dart'
    as _i8gd8qxe;
import 'package:poodle_client/src/protocol/modules/messaging/eligible_peer.dart'
    as _isrbg5p2;
import 'package:poodle_client/src/protocol/modules/messaging/message_item.dart'
    as _ilotj6jx;
import 'package:poodle_client/src/protocol/modules/my_files/my_upload.dart'
    as _iutl1srs;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_job_status.dart'
    as _iiovfcmq;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_note_view.dart'
    as _iuz9iu6p;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_studio_item.dart'
    as _irywxl2u;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_turn_view.dart'
    as _id13ccyf;
import 'package:poodle_client/src/protocol/modules/notifications/notification_item.dart'
    as _i4wyle5u;
import 'package:poodle_client/src/protocol/modules/search/search_recent.dart'
    as _ivpnxyts;
import 'package:poodle_client/src/protocol/modules/teaching/teaching_activity_view.dart'
    as _iy9mrm6d;
import 'package:poodle_client/src/protocol/modules/teaching/teaching_course_view.dart'
    as _ij0l49uv;
import 'package:poodle_client/src/protocol/modules/teaching/teaching_member_view.dart'
    as _iopdwa8s;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'modules/admin/admin_directory_row.dart' as _i7m5u5sf;
import 'modules/admin/admin_overview.dart' as _igbc6bvq;
import 'modules/course_content/course_activity.dart' as _i4d138sj;
import 'modules/course_content/course_announcement_info.dart' as _ie315swm;
import 'modules/course_content/course_assessment_info.dart' as _iz5q1xt6;
import 'modules/course_content/course_detail.dart' as _ifi4v4lp;
import 'modules/course_content/course_file_access.dart' as _i77ctelr;
import 'modules/course_content/course_file_info.dart' as _ir759m7l;
import 'modules/course_content/course_link_info.dart' as _i64ldnq9;
import 'modules/course_content/course_section.dart' as _iz2rpgu0;
import 'modules/courses/course_read_exception.dart' as _i24unjc2;
import 'modules/courses/course_summary.dart' as _iyl7g11s;
import 'modules/identity/account_snapshot.dart' as _iv9gbhnz;
import 'modules/identity/administrator_request_summary.dart' as _i1c61daw;
import 'modules/identity/identity_access_exception.dart' as _ivy7y4wo;
import 'modules/identity/invitation_summary.dart' as _iayx6x33;
import 'modules/identity/pending_email_change_summary.dart' as _infhr8r7;
import 'modules/identity/university_member_summary.dart' as _io4lp5h5;
import 'modules/identity/university_summary.dart' as _i9u2navt;
import 'modules/messaging/conversation_item.dart' as _irfgoa0i;
import 'modules/messaging/eligible_peer.dart' as _itmsc93k;
import 'modules/messaging/message_item.dart' as _iqjq4fel;
import 'modules/my_files/my_upload.dart' as _irgxli50;
import 'modules/notebook/notebook_assessment_config_input.dart' as _is07a4ho;
import 'modules/notebook/notebook_assessment_config_view.dart' as _ihd45xsw;
import 'modules/notebook/notebook_assessment_setup.dart' as _iizyiasx;
import 'modules/notebook/notebook_audio_access.dart' as _i61zjbgu;
import 'modules/notebook/notebook_chat_input.dart' as _iqdu4kxl;
import 'modules/notebook/notebook_citation.dart' as _ifnilvb1;
import 'modules/notebook/notebook_error.dart' as _i7g4cm5a;
import 'modules/notebook/notebook_job_status.dart' as _ioziuoc8;
import 'modules/notebook/notebook_material_option.dart' as _ifi9qpbh;
import 'modules/notebook/notebook_note_view.dart' as _issssupk;
import 'modules/notebook/notebook_overview.dart' as _i900zlap;
import 'modules/notebook/notebook_source_info.dart' as _i3v4x43g;
import 'modules/notebook/notebook_studio_item.dart' as _ikn9ojxd;
import 'modules/notebook/notebook_studio_request.dart' as _ibru614b;
import 'modules/notebook/notebook_turn_view.dart' as _itn9r96i;
import 'modules/notebook/notebook_upload_input.dart' as _iutecm5w;
import 'modules/notebook/notebook_upload_ticket.dart' as _ijxhmjxo;
import 'modules/notifications/notification_item.dart' as _irfpkdny;
import 'modules/search/search_error.dart' as _iu9wgju8;
import 'modules/search/search_hit.dart' as _ih8j6fen;
import 'modules/search/search_recent.dart' as _i25dmvzp;
import 'modules/search/search_response.dart' as _ixylbxq6;
import 'modules/student_learning/student_grade_course.dart' as _i7dbfqcs;
import 'modules/student_learning/student_grade_row.dart' as _igwj78dq;
import 'modules/student_learning/student_grades_response.dart' as _i38t4enu;
import 'modules/student_learning/student_task_row.dart' as _ivkp5op4;
import 'modules/student_learning/student_tasks_response.dart' as _ieh9wk3e;
import 'modules/teaching/teaching_activity_view.dart' as _i448j8qo;
import 'modules/teaching/teaching_attempt_view.dart' as _ivlau0h8;
import 'modules/teaching/teaching_course_view.dart' as _i90cap6h;
import 'modules/teaching/teaching_error.dart' as _i8oe640j;
import 'modules/teaching/teaching_member_view.dart' as _i46b132o;
import 'modules/teaching/teaching_question.dart' as _i3apebh7;
import 'modules/teaching/teaching_save_input.dart' as _iyph2036;
import 'modules/teaching/teaching_settings.dart' as _ir0clk27;
import 'modules/teaching/teaching_submission_view.dart' as _ivzwpa04;
import 'modules/teaching/teaching_upload_ticket.dart' as _idy12w3x;
export 'modules/admin/admin_directory_row.dart';
export 'modules/admin/admin_overview.dart';
export 'modules/course_content/course_activity.dart';
export 'modules/course_content/course_announcement_info.dart';
export 'modules/course_content/course_assessment_info.dart';
export 'modules/course_content/course_detail.dart';
export 'modules/course_content/course_file_access.dart';
export 'modules/course_content/course_file_info.dart';
export 'modules/course_content/course_link_info.dart';
export 'modules/course_content/course_section.dart';
export 'modules/courses/course_read_exception.dart';
export 'modules/courses/course_summary.dart';
export 'modules/identity/account_snapshot.dart';
export 'modules/identity/administrator_request_summary.dart';
export 'modules/identity/identity_access_exception.dart';
export 'modules/identity/invitation_summary.dart';
export 'modules/identity/pending_email_change_summary.dart';
export 'modules/identity/university_member_summary.dart';
export 'modules/identity/university_summary.dart';
export 'modules/messaging/conversation_item.dart';
export 'modules/messaging/eligible_peer.dart';
export 'modules/messaging/message_item.dart';
export 'modules/my_files/my_upload.dart';
export 'modules/notebook/notebook_assessment_config_input.dart';
export 'modules/notebook/notebook_assessment_config_view.dart';
export 'modules/notebook/notebook_assessment_setup.dart';
export 'modules/notebook/notebook_audio_access.dart';
export 'modules/notebook/notebook_chat_input.dart';
export 'modules/notebook/notebook_citation.dart';
export 'modules/notebook/notebook_error.dart';
export 'modules/notebook/notebook_job_status.dart';
export 'modules/notebook/notebook_material_option.dart';
export 'modules/notebook/notebook_note_view.dart';
export 'modules/notebook/notebook_overview.dart';
export 'modules/notebook/notebook_source_info.dart';
export 'modules/notebook/notebook_studio_item.dart';
export 'modules/notebook/notebook_studio_request.dart';
export 'modules/notebook/notebook_turn_view.dart';
export 'modules/notebook/notebook_upload_input.dart';
export 'modules/notebook/notebook_upload_ticket.dart';
export 'modules/notifications/notification_item.dart';
export 'modules/search/search_error.dart';
export 'modules/search/search_hit.dart';
export 'modules/search/search_recent.dart';
export 'modules/search/search_response.dart';
export 'modules/student_learning/student_grade_course.dart';
export 'modules/student_learning/student_grade_row.dart';
export 'modules/student_learning/student_grades_response.dart';
export 'modules/student_learning/student_task_row.dart';
export 'modules/student_learning/student_tasks_response.dart';
export 'modules/teaching/teaching_activity_view.dart';
export 'modules/teaching/teaching_attempt_view.dart';
export 'modules/teaching/teaching_course_view.dart';
export 'modules/teaching/teaching_error.dart';
export 'modules/teaching/teaching_member_view.dart';
export 'modules/teaching/teaching_question.dart';
export 'modules/teaching/teaching_save_input.dart';
export 'modules/teaching/teaching_settings.dart';
export 'modules/teaching/teaching_submission_view.dart';
export 'modules/teaching/teaching_upload_ticket.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

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
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _i24unjc2.CourseReadException) {
      return _i24unjc2.CourseReadException.fromJson(data) as T;
    }
    if (t == _iyl7g11s.CourseSummary) {
      return _iyl7g11s.CourseSummary.fromJson(data) as T;
    }
    if (t == _iv9gbhnz.AccountSnapshot) {
      return _iv9gbhnz.AccountSnapshot.fromJson(data) as T;
    }
    if (t == _i1c61daw.AdministratorRequestSummary) {
      return _i1c61daw.AdministratorRequestSummary.fromJson(data) as T;
    }
    if (t == _ivy7y4wo.IdentityAccessException) {
      return _ivy7y4wo.IdentityAccessException.fromJson(data) as T;
    }
    if (t == _iayx6x33.InvitationSummary) {
      return _iayx6x33.InvitationSummary.fromJson(data) as T;
    }
    if (t == _infhr8r7.PendingEmailChangeSummary) {
      return _infhr8r7.PendingEmailChangeSummary.fromJson(data) as T;
    }
    if (t == _io4lp5h5.UniversityMemberSummary) {
      return _io4lp5h5.UniversityMemberSummary.fromJson(data) as T;
    }
    if (t == _i9u2navt.UniversitySummary) {
      return _i9u2navt.UniversitySummary.fromJson(data) as T;
    }
    if (t == _irfgoa0i.ConversationItem) {
      return _irfgoa0i.ConversationItem.fromJson(data) as T;
    }
    if (t == _itmsc93k.EligiblePeer) {
      return _itmsc93k.EligiblePeer.fromJson(data) as T;
    }
    if (t == _iqjq4fel.MessageItem) {
      return _iqjq4fel.MessageItem.fromJson(data) as T;
    }
    if (t == _irgxli50.MyUpload) {
      return _irgxli50.MyUpload.fromJson(data) as T;
    }
    if (t == _is07a4ho.NotebookAssessmentConfigInput) {
      return _is07a4ho.NotebookAssessmentConfigInput.fromJson(data) as T;
    }
    if (t == _ihd45xsw.NotebookAssessmentConfigView) {
      return _ihd45xsw.NotebookAssessmentConfigView.fromJson(data) as T;
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
    if (t == _ifnilvb1.NotebookCitation) {
      return _ifnilvb1.NotebookCitation.fromJson(data) as T;
    }
    if (t == _i7g4cm5a.NotebookError) {
      return _i7g4cm5a.NotebookError.fromJson(data) as T;
    }
    if (t == _ioziuoc8.NotebookJobStatus) {
      return _ioziuoc8.NotebookJobStatus.fromJson(data) as T;
    }
    if (t == _ifi9qpbh.NotebookMaterialOption) {
      return _ifi9qpbh.NotebookMaterialOption.fromJson(data) as T;
    }
    if (t == _issssupk.NotebookNoteView) {
      return _issssupk.NotebookNoteView.fromJson(data) as T;
    }
    if (t == _i900zlap.NotebookOverview) {
      return _i900zlap.NotebookOverview.fromJson(data) as T;
    }
    if (t == _i3v4x43g.NotebookSourceInfo) {
      return _i3v4x43g.NotebookSourceInfo.fromJson(data) as T;
    }
    if (t == _ikn9ojxd.NotebookStudioItem) {
      return _ikn9ojxd.NotebookStudioItem.fromJson(data) as T;
    }
    if (t == _ibru614b.NotebookStudioRequest) {
      return _ibru614b.NotebookStudioRequest.fromJson(data) as T;
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
    if (t == _irfpkdny.NotificationItem) {
      return _irfpkdny.NotificationItem.fromJson(data) as T;
    }
    if (t == _iu9wgju8.SearchError) {
      return _iu9wgju8.SearchError.fromJson(data) as T;
    }
    if (t == _ih8j6fen.SearchHit) {
      return _ih8j6fen.SearchHit.fromJson(data) as T;
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
    if (t == _i448j8qo.TeachingActivityView) {
      return _i448j8qo.TeachingActivityView.fromJson(data) as T;
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
    if (t == _ivzwpa04.TeachingSubmissionView) {
      return _ivzwpa04.TeachingSubmissionView.fromJson(data) as T;
    }
    if (t == _idy12w3x.TeachingUploadTicket) {
      return _idy12w3x.TeachingUploadTicket.fromJson(data) as T;
    }
    if (t == _isc.getType<_i7m5u5sf.AdminDirectoryRow?>()) {
      return (data != null ? _i7m5u5sf.AdminDirectoryRow.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igbc6bvq.AdminOverview?>()) {
      return (data != null ? _igbc6bvq.AdminOverview.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4d138sj.CourseActivity?>()) {
      return (data != null ? _i4d138sj.CourseActivity.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ie315swm.CourseAnnouncementInfo?>()) {
      return (data != null
              ? _ie315swm.CourseAnnouncementInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iz5q1xt6.CourseAssessmentInfo?>()) {
      return (data != null
              ? _iz5q1xt6.CourseAssessmentInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ifi4v4lp.CourseDetail?>()) {
      return (data != null ? _ifi4v4lp.CourseDetail.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i77ctelr.CourseFileAccess?>()) {
      return (data != null ? _i77ctelr.CourseFileAccess.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ir759m7l.CourseFileInfo?>()) {
      return (data != null ? _ir759m7l.CourseFileInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i64ldnq9.CourseLinkInfo?>()) {
      return (data != null ? _i64ldnq9.CourseLinkInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iz2rpgu0.CourseSection?>()) {
      return (data != null ? _iz2rpgu0.CourseSection.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i24unjc2.CourseReadException?>()) {
      return (data != null
              ? _i24unjc2.CourseReadException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iyl7g11s.CourseSummary?>()) {
      return (data != null ? _iyl7g11s.CourseSummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iv9gbhnz.AccountSnapshot?>()) {
      return (data != null ? _iv9gbhnz.AccountSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i1c61daw.AdministratorRequestSummary?>()) {
      return (data != null
              ? _i1c61daw.AdministratorRequestSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ivy7y4wo.IdentityAccessException?>()) {
      return (data != null
              ? _ivy7y4wo.IdentityAccessException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iayx6x33.InvitationSummary?>()) {
      return (data != null ? _iayx6x33.InvitationSummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_infhr8r7.PendingEmailChangeSummary?>()) {
      return (data != null
              ? _infhr8r7.PendingEmailChangeSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_io4lp5h5.UniversityMemberSummary?>()) {
      return (data != null
              ? _io4lp5h5.UniversityMemberSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i9u2navt.UniversitySummary?>()) {
      return (data != null ? _i9u2navt.UniversitySummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_irfgoa0i.ConversationItem?>()) {
      return (data != null ? _irfgoa0i.ConversationItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_itmsc93k.EligiblePeer?>()) {
      return (data != null ? _itmsc93k.EligiblePeer.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iqjq4fel.MessageItem?>()) {
      return (data != null ? _iqjq4fel.MessageItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_irgxli50.MyUpload?>()) {
      return (data != null ? _irgxli50.MyUpload.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_is07a4ho.NotebookAssessmentConfigInput?>()) {
      return (data != null
              ? _is07a4ho.NotebookAssessmentConfigInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ihd45xsw.NotebookAssessmentConfigView?>()) {
      return (data != null
              ? _ihd45xsw.NotebookAssessmentConfigView.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iizyiasx.NotebookAssessmentSetup?>()) {
      return (data != null
              ? _iizyiasx.NotebookAssessmentSetup.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i61zjbgu.NotebookAudioAccess?>()) {
      return (data != null
              ? _i61zjbgu.NotebookAudioAccess.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iqdu4kxl.NotebookChatInput?>()) {
      return (data != null ? _iqdu4kxl.NotebookChatInput.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ifnilvb1.NotebookCitation?>()) {
      return (data != null ? _ifnilvb1.NotebookCitation.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7g4cm5a.NotebookError?>()) {
      return (data != null ? _i7g4cm5a.NotebookError.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ioziuoc8.NotebookJobStatus?>()) {
      return (data != null ? _ioziuoc8.NotebookJobStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ifi9qpbh.NotebookMaterialOption?>()) {
      return (data != null
              ? _ifi9qpbh.NotebookMaterialOption.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_issssupk.NotebookNoteView?>()) {
      return (data != null ? _issssupk.NotebookNoteView.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i900zlap.NotebookOverview?>()) {
      return (data != null ? _i900zlap.NotebookOverview.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i3v4x43g.NotebookSourceInfo?>()) {
      return (data != null ? _i3v4x43g.NotebookSourceInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ikn9ojxd.NotebookStudioItem?>()) {
      return (data != null ? _ikn9ojxd.NotebookStudioItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibru614b.NotebookStudioRequest?>()) {
      return (data != null
              ? _ibru614b.NotebookStudioRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_itn9r96i.NotebookTurnView?>()) {
      return (data != null ? _itn9r96i.NotebookTurnView.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iutecm5w.NotebookUploadInput?>()) {
      return (data != null
              ? _iutecm5w.NotebookUploadInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ijxhmjxo.NotebookUploadTicket?>()) {
      return (data != null
              ? _ijxhmjxo.NotebookUploadTicket.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_irfpkdny.NotificationItem?>()) {
      return (data != null ? _irfpkdny.NotificationItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iu9wgju8.SearchError?>()) {
      return (data != null ? _iu9wgju8.SearchError.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ih8j6fen.SearchHit?>()) {
      return (data != null ? _ih8j6fen.SearchHit.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i25dmvzp.SearchRecent?>()) {
      return (data != null ? _i25dmvzp.SearchRecent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixylbxq6.SearchResponse?>()) {
      return (data != null ? _ixylbxq6.SearchResponse.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7dbfqcs.StudentGradeCourse?>()) {
      return (data != null ? _i7dbfqcs.StudentGradeCourse.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igwj78dq.StudentGradeRow?>()) {
      return (data != null ? _igwj78dq.StudentGradeRow.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i38t4enu.StudentGradesResponse?>()) {
      return (data != null
              ? _i38t4enu.StudentGradesResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ivkp5op4.StudentTaskRow?>()) {
      return (data != null ? _ivkp5op4.StudentTaskRow.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ieh9wk3e.StudentTasksResponse?>()) {
      return (data != null
              ? _ieh9wk3e.StudentTasksResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i448j8qo.TeachingActivityView?>()) {
      return (data != null
              ? _i448j8qo.TeachingActivityView.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ivlau0h8.TeachingAttemptView?>()) {
      return (data != null
              ? _ivlau0h8.TeachingAttemptView.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i90cap6h.TeachingCourseView?>()) {
      return (data != null ? _i90cap6h.TeachingCourseView.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8oe640j.TeachingError?>()) {
      return (data != null ? _i8oe640j.TeachingError.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i46b132o.TeachingMemberView?>()) {
      return (data != null ? _i46b132o.TeachingMemberView.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i3apebh7.TeachingQuestion?>()) {
      return (data != null ? _i3apebh7.TeachingQuestion.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iyph2036.TeachingSaveInput?>()) {
      return (data != null ? _iyph2036.TeachingSaveInput.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ir0clk27.TeachingSettings?>()) {
      return (data != null ? _ir0clk27.TeachingSettings.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ivzwpa04.TeachingSubmissionView?>()) {
      return (data != null
              ? _ivzwpa04.TeachingSubmissionView.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_idy12w3x.TeachingUploadTicket?>()) {
      return (data != null
              ? _idy12w3x.TeachingUploadTicket.fromJson(data)
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
    if (t == List<_isc.UuidValue>) {
      return (data as List).map((e) => deserialize<_isc.UuidValue>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
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
    if (t == List<_ia5bj8wh.AdminDirectoryRow>) {
      return (data as List)
              .map((e) => deserialize<_ia5bj8wh.AdminDirectoryRow>(e))
              .toList()
          as T;
    }
    if (t == List<_ip3pjnpw.CourseSummary>) {
      return (data as List)
              .map((e) => deserialize<_ip3pjnpw.CourseSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i9078z8p.InvitationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i9078z8p.InvitationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i31qaluo.AdministratorRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_i31qaluo.AdministratorRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i5j7k3lx.UniversitySummary>) {
      return (data as List)
              .map((e) => deserialize<_i5j7k3lx.UniversitySummary>(e))
              .toList()
          as T;
    }
    if (t == List<_iijs4wax.UniversityMemberSummary>) {
      return (data as List)
              .map((e) => deserialize<_iijs4wax.UniversityMemberSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i8gd8qxe.ConversationItem>) {
      return (data as List)
              .map((e) => deserialize<_i8gd8qxe.ConversationItem>(e))
              .toList()
          as T;
    }
    if (t == List<_isrbg5p2.EligiblePeer>) {
      return (data as List)
              .map((e) => deserialize<_isrbg5p2.EligiblePeer>(e))
              .toList()
          as T;
    }
    if (t == List<_ilotj6jx.MessageItem>) {
      return (data as List)
              .map((e) => deserialize<_ilotj6jx.MessageItem>(e))
              .toList()
          as T;
    }
    if (t == List<_iutl1srs.MyUpload>) {
      return (data as List)
              .map((e) => deserialize<_iutl1srs.MyUpload>(e))
              .toList()
          as T;
    }
    if (t == List<_iuz9iu6p.NotebookNoteView>) {
      return (data as List)
              .map((e) => deserialize<_iuz9iu6p.NotebookNoteView>(e))
              .toList()
          as T;
    }
    if (t == List<_id13ccyf.NotebookTurnView>) {
      return (data as List)
              .map((e) => deserialize<_id13ccyf.NotebookTurnView>(e))
              .toList()
          as T;
    }
    if (t == List<_isc.UuidValue>) {
      return (data as List).map((e) => deserialize<_isc.UuidValue>(e)).toList()
          as T;
    }
    if (t == List<_iiovfcmq.NotebookJobStatus>) {
      return (data as List)
              .map((e) => deserialize<_iiovfcmq.NotebookJobStatus>(e))
              .toList()
          as T;
    }
    if (t == List<_irywxl2u.NotebookStudioItem>) {
      return (data as List)
              .map((e) => deserialize<_irywxl2u.NotebookStudioItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i4wyle5u.NotificationItem>) {
      return (data as List)
              .map((e) => deserialize<_i4wyle5u.NotificationItem>(e))
              .toList()
          as T;
    }
    if (t == List<_ivpnxyts.SearchRecent>) {
      return (data as List)
              .map((e) => deserialize<_ivpnxyts.SearchRecent>(e))
              .toList()
          as T;
    }
    if (t == List<_ij0l49uv.TeachingCourseView>) {
      return (data as List)
              .map((e) => deserialize<_ij0l49uv.TeachingCourseView>(e))
              .toList()
          as T;
    }
    if (t == List<_iopdwa8s.TeachingMemberView>) {
      return (data as List)
              .map((e) => deserialize<_iopdwa8s.TeachingMemberView>(e))
              .toList()
          as T;
    }
    if (t == List<_iy9mrm6d.TeachingActivityView>) {
      return (data as List)
              .map((e) => deserialize<_iy9mrm6d.TeachingActivityView>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i7m5u5sf.AdminDirectoryRow => 'AdminDirectoryRow',
      _igbc6bvq.AdminOverview => 'AdminOverview',
      _i4d138sj.CourseActivity => 'CourseActivity',
      _ie315swm.CourseAnnouncementInfo => 'CourseAnnouncementInfo',
      _iz5q1xt6.CourseAssessmentInfo => 'CourseAssessmentInfo',
      _ifi4v4lp.CourseDetail => 'CourseDetail',
      _i77ctelr.CourseFileAccess => 'CourseFileAccess',
      _ir759m7l.CourseFileInfo => 'CourseFileInfo',
      _i64ldnq9.CourseLinkInfo => 'CourseLinkInfo',
      _iz2rpgu0.CourseSection => 'CourseSection',
      _i24unjc2.CourseReadException => 'CourseReadException',
      _iyl7g11s.CourseSummary => 'CourseSummary',
      _iv9gbhnz.AccountSnapshot => 'AccountSnapshot',
      _i1c61daw.AdministratorRequestSummary => 'AdministratorRequestSummary',
      _ivy7y4wo.IdentityAccessException => 'IdentityAccessException',
      _iayx6x33.InvitationSummary => 'InvitationSummary',
      _infhr8r7.PendingEmailChangeSummary => 'PendingEmailChangeSummary',
      _io4lp5h5.UniversityMemberSummary => 'UniversityMemberSummary',
      _i9u2navt.UniversitySummary => 'UniversitySummary',
      _irfgoa0i.ConversationItem => 'ConversationItem',
      _itmsc93k.EligiblePeer => 'EligiblePeer',
      _iqjq4fel.MessageItem => 'MessageItem',
      _irgxli50.MyUpload => 'MyUpload',
      _is07a4ho.NotebookAssessmentConfigInput =>
        'NotebookAssessmentConfigInput',
      _ihd45xsw.NotebookAssessmentConfigView => 'NotebookAssessmentConfigView',
      _iizyiasx.NotebookAssessmentSetup => 'NotebookAssessmentSetup',
      _i61zjbgu.NotebookAudioAccess => 'NotebookAudioAccess',
      _iqdu4kxl.NotebookChatInput => 'NotebookChatInput',
      _ifnilvb1.NotebookCitation => 'NotebookCitation',
      _i7g4cm5a.NotebookError => 'NotebookError',
      _ioziuoc8.NotebookJobStatus => 'NotebookJobStatus',
      _ifi9qpbh.NotebookMaterialOption => 'NotebookMaterialOption',
      _issssupk.NotebookNoteView => 'NotebookNoteView',
      _i900zlap.NotebookOverview => 'NotebookOverview',
      _i3v4x43g.NotebookSourceInfo => 'NotebookSourceInfo',
      _ikn9ojxd.NotebookStudioItem => 'NotebookStudioItem',
      _ibru614b.NotebookStudioRequest => 'NotebookStudioRequest',
      _itn9r96i.NotebookTurnView => 'NotebookTurnView',
      _iutecm5w.NotebookUploadInput => 'NotebookUploadInput',
      _ijxhmjxo.NotebookUploadTicket => 'NotebookUploadTicket',
      _irfpkdny.NotificationItem => 'NotificationItem',
      _iu9wgju8.SearchError => 'SearchError',
      _ih8j6fen.SearchHit => 'SearchHit',
      _i25dmvzp.SearchRecent => 'SearchRecent',
      _ixylbxq6.SearchResponse => 'SearchResponse',
      _i7dbfqcs.StudentGradeCourse => 'StudentGradeCourse',
      _igwj78dq.StudentGradeRow => 'StudentGradeRow',
      _i38t4enu.StudentGradesResponse => 'StudentGradesResponse',
      _ivkp5op4.StudentTaskRow => 'StudentTaskRow',
      _ieh9wk3e.StudentTasksResponse => 'StudentTasksResponse',
      _i448j8qo.TeachingActivityView => 'TeachingActivityView',
      _ivlau0h8.TeachingAttemptView => 'TeachingAttemptView',
      _i90cap6h.TeachingCourseView => 'TeachingCourseView',
      _i8oe640j.TeachingError => 'TeachingError',
      _i46b132o.TeachingMemberView => 'TeachingMemberView',
      _i3apebh7.TeachingQuestion => 'TeachingQuestion',
      _iyph2036.TeachingSaveInput => 'TeachingSaveInput',
      _ir0clk27.TeachingSettings => 'TeachingSettings',
      _ivzwpa04.TeachingSubmissionView => 'TeachingSubmissionView',
      _idy12w3x.TeachingUploadTicket => 'TeachingUploadTicket',
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
      case _i24unjc2.CourseReadException():
        return 'CourseReadException';
      case _iyl7g11s.CourseSummary():
        return 'CourseSummary';
      case _iv9gbhnz.AccountSnapshot():
        return 'AccountSnapshot';
      case _i1c61daw.AdministratorRequestSummary():
        return 'AdministratorRequestSummary';
      case _ivy7y4wo.IdentityAccessException():
        return 'IdentityAccessException';
      case _iayx6x33.InvitationSummary():
        return 'InvitationSummary';
      case _infhr8r7.PendingEmailChangeSummary():
        return 'PendingEmailChangeSummary';
      case _io4lp5h5.UniversityMemberSummary():
        return 'UniversityMemberSummary';
      case _i9u2navt.UniversitySummary():
        return 'UniversitySummary';
      case _irfgoa0i.ConversationItem():
        return 'ConversationItem';
      case _itmsc93k.EligiblePeer():
        return 'EligiblePeer';
      case _iqjq4fel.MessageItem():
        return 'MessageItem';
      case _irgxli50.MyUpload():
        return 'MyUpload';
      case _is07a4ho.NotebookAssessmentConfigInput():
        return 'NotebookAssessmentConfigInput';
      case _ihd45xsw.NotebookAssessmentConfigView():
        return 'NotebookAssessmentConfigView';
      case _iizyiasx.NotebookAssessmentSetup():
        return 'NotebookAssessmentSetup';
      case _i61zjbgu.NotebookAudioAccess():
        return 'NotebookAudioAccess';
      case _iqdu4kxl.NotebookChatInput():
        return 'NotebookChatInput';
      case _ifnilvb1.NotebookCitation():
        return 'NotebookCitation';
      case _i7g4cm5a.NotebookError():
        return 'NotebookError';
      case _ioziuoc8.NotebookJobStatus():
        return 'NotebookJobStatus';
      case _ifi9qpbh.NotebookMaterialOption():
        return 'NotebookMaterialOption';
      case _issssupk.NotebookNoteView():
        return 'NotebookNoteView';
      case _i900zlap.NotebookOverview():
        return 'NotebookOverview';
      case _i3v4x43g.NotebookSourceInfo():
        return 'NotebookSourceInfo';
      case _ikn9ojxd.NotebookStudioItem():
        return 'NotebookStudioItem';
      case _ibru614b.NotebookStudioRequest():
        return 'NotebookStudioRequest';
      case _itn9r96i.NotebookTurnView():
        return 'NotebookTurnView';
      case _iutecm5w.NotebookUploadInput():
        return 'NotebookUploadInput';
      case _ijxhmjxo.NotebookUploadTicket():
        return 'NotebookUploadTicket';
      case _irfpkdny.NotificationItem():
        return 'NotificationItem';
      case _iu9wgju8.SearchError():
        return 'SearchError';
      case _ih8j6fen.SearchHit():
        return 'SearchHit';
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
      case _i448j8qo.TeachingActivityView():
        return 'TeachingActivityView';
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
      case _ivzwpa04.TeachingSubmissionView():
        return 'TeachingSubmissionView';
      case _idy12w3x.TeachingUploadTicket():
        return 'TeachingUploadTicket';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
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
    if (dataClassName == 'CourseReadException') {
      return deserialize<_i24unjc2.CourseReadException>(data['data']);
    }
    if (dataClassName == 'CourseSummary') {
      return deserialize<_iyl7g11s.CourseSummary>(data['data']);
    }
    if (dataClassName == 'AccountSnapshot') {
      return deserialize<_iv9gbhnz.AccountSnapshot>(data['data']);
    }
    if (dataClassName == 'AdministratorRequestSummary') {
      return deserialize<_i1c61daw.AdministratorRequestSummary>(data['data']);
    }
    if (dataClassName == 'IdentityAccessException') {
      return deserialize<_ivy7y4wo.IdentityAccessException>(data['data']);
    }
    if (dataClassName == 'InvitationSummary') {
      return deserialize<_iayx6x33.InvitationSummary>(data['data']);
    }
    if (dataClassName == 'PendingEmailChangeSummary') {
      return deserialize<_infhr8r7.PendingEmailChangeSummary>(data['data']);
    }
    if (dataClassName == 'UniversityMemberSummary') {
      return deserialize<_io4lp5h5.UniversityMemberSummary>(data['data']);
    }
    if (dataClassName == 'UniversitySummary') {
      return deserialize<_i9u2navt.UniversitySummary>(data['data']);
    }
    if (dataClassName == 'ConversationItem') {
      return deserialize<_irfgoa0i.ConversationItem>(data['data']);
    }
    if (dataClassName == 'EligiblePeer') {
      return deserialize<_itmsc93k.EligiblePeer>(data['data']);
    }
    if (dataClassName == 'MessageItem') {
      return deserialize<_iqjq4fel.MessageItem>(data['data']);
    }
    if (dataClassName == 'MyUpload') {
      return deserialize<_irgxli50.MyUpload>(data['data']);
    }
    if (dataClassName == 'NotebookAssessmentConfigInput') {
      return deserialize<_is07a4ho.NotebookAssessmentConfigInput>(data['data']);
    }
    if (dataClassName == 'NotebookAssessmentConfigView') {
      return deserialize<_ihd45xsw.NotebookAssessmentConfigView>(data['data']);
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
    if (dataClassName == 'NotebookCitation') {
      return deserialize<_ifnilvb1.NotebookCitation>(data['data']);
    }
    if (dataClassName == 'NotebookError') {
      return deserialize<_i7g4cm5a.NotebookError>(data['data']);
    }
    if (dataClassName == 'NotebookJobStatus') {
      return deserialize<_ioziuoc8.NotebookJobStatus>(data['data']);
    }
    if (dataClassName == 'NotebookMaterialOption') {
      return deserialize<_ifi9qpbh.NotebookMaterialOption>(data['data']);
    }
    if (dataClassName == 'NotebookNoteView') {
      return deserialize<_issssupk.NotebookNoteView>(data['data']);
    }
    if (dataClassName == 'NotebookOverview') {
      return deserialize<_i900zlap.NotebookOverview>(data['data']);
    }
    if (dataClassName == 'NotebookSourceInfo') {
      return deserialize<_i3v4x43g.NotebookSourceInfo>(data['data']);
    }
    if (dataClassName == 'NotebookStudioItem') {
      return deserialize<_ikn9ojxd.NotebookStudioItem>(data['data']);
    }
    if (dataClassName == 'NotebookStudioRequest') {
      return deserialize<_ibru614b.NotebookStudioRequest>(data['data']);
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
    if (dataClassName == 'NotificationItem') {
      return deserialize<_irfpkdny.NotificationItem>(data['data']);
    }
    if (dataClassName == 'SearchError') {
      return deserialize<_iu9wgju8.SearchError>(data['data']);
    }
    if (dataClassName == 'SearchHit') {
      return deserialize<_ih8j6fen.SearchHit>(data['data']);
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
    if (dataClassName == 'TeachingActivityView') {
      return deserialize<_i448j8qo.TeachingActivityView>(data['data']);
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
    if (dataClassName == 'TeachingSubmissionView') {
      return deserialize<_ivzwpa04.TeachingSubmissionView>(data['data']);
    }
    if (dataClassName == 'TeachingUploadTicket') {
      return deserialize<_idy12w3x.TeachingUploadTicket>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('poodle', this);
    _iacc.Protocol().registerHostProtocol('poodle', this);
  }

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
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
