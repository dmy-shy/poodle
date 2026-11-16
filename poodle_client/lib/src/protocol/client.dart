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
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:poodle_client/src/protocol/modules/admin/admin_directory_row.dart'
    as _ia5bj8wh;
import 'package:poodle_client/src/protocol/modules/admin/admin_overview.dart'
    as _i5irv79u;
import 'package:poodle_client/src/protocol/modules/course_content/course_activity.dart'
    as _i1uyt7np;
import 'package:poodle_client/src/protocol/modules/course_content/course_detail.dart'
    as _ipiih5y5;
import 'package:poodle_client/src/protocol/modules/course_content/course_file_access.dart'
    as _i4i4so7h;
import 'package:poodle_client/src/protocol/modules/courses/course_summary.dart'
    as _ip3pjnpw;
import 'package:poodle_client/src/protocol/modules/identity/account_snapshot.dart'
    as _iuyrsnts;
import 'package:poodle_client/src/protocol/modules/identity/administrator_request_summary.dart'
    as _i31qaluo;
import 'package:poodle_client/src/protocol/modules/identity/invitation_summary.dart'
    as _i9078z8p;
import 'package:poodle_client/src/protocol/modules/identity/pending_email_change_summary.dart'
    as _i4agt7qy;
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
import 'package:poodle_client/src/protocol/modules/notebook/notebook_assessment_config_input.dart'
    as _iq1ufyg4;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_assessment_config_view.dart'
    as _ipsbqoy1;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_assessment_setup.dart'
    as _ijcpnvpu;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_audio_access.dart'
    as _ijjzb9sz;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_chat_input.dart'
    as _idfiduog;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_job_status.dart'
    as _iiovfcmq;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_note_view.dart'
    as _iuz9iu6p;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_overview.dart'
    as _izqdo623;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_studio_item.dart'
    as _irywxl2u;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_studio_request.dart'
    as _i6q8e6ut;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_turn_view.dart'
    as _id13ccyf;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_upload_input.dart'
    as _ive68yja;
import 'package:poodle_client/src/protocol/modules/notebook/notebook_upload_ticket.dart'
    as _iudbf9ve;
import 'package:poodle_client/src/protocol/modules/notifications/notification_item.dart'
    as _i4wyle5u;
import 'package:poodle_client/src/protocol/modules/search/search_recent.dart'
    as _ivpnxyts;
import 'package:poodle_client/src/protocol/modules/search/search_response.dart'
    as _ihg9oqpt;
import 'package:poodle_client/src/protocol/modules/student_learning/student_grades_response.dart'
    as _iuszwrzt;
import 'package:poodle_client/src/protocol/modules/student_learning/student_tasks_response.dart'
    as _iw2sqntt;
import 'package:poodle_client/src/protocol/modules/teaching/teaching_activity_view.dart'
    as _iy9mrm6d;
import 'package:poodle_client/src/protocol/modules/teaching/teaching_course_view.dart'
    as _ij0l49uv;
import 'package:poodle_client/src/protocol/modules/teaching/teaching_member_view.dart'
    as _iopdwa8s;
import 'package:poodle_client/src/protocol/modules/teaching/teaching_save_input.dart'
    as _ijb5aojr;
import 'package:poodle_client/src/protocol/modules/teaching/teaching_settings.dart'
    as _iysm72fm;
import 'package:poodle_client/src/protocol/modules/teaching/teaching_upload_ticket.dart'
    as _iq0338zw;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  @override
  _ida.Future<_isc.UuidValue> startRegistration({
    required String email,
    String? locale,
  }) => caller.callServerEndpoint<_isc.UuidValue>(
    'emailIdp',
    'startRegistration',
    {
      'email': email,
      'locale': locale,
    },
  );

  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({
    required String email,
    String? locale,
  }) => caller.callServerEndpoint<_isc.UuidValue>(
    'emailIdp',
    'startPasswordReset',
    {
      'email': email,
      'locale': locale,
    },
  );

  _ida.Future<_iacc.AuthSuccess> googleLogin({required String idToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'emailIdp',
        'googleLogin',
        {'idToken': idToken},
      );

  _ida.Future<void> linkGoogle({required String idToken}) =>
      caller.callServerEndpoint<void>(
        'emailIdp',
        'linkGoogle',
        {'idToken': idToken},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointAdminOverview extends _isc.EndpointRef {
  EndpointAdminOverview(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminOverview';

  _ida.Future<_i5irv79u.AdminOverview> summary() =>
      caller.callServerEndpoint<_i5irv79u.AdminOverview>(
        'adminOverview',
        'summary',
        {},
      );

  _ida.Future<List<_ia5bj8wh.AdminDirectoryRow>> list(
    String category,
    int offset,
  ) => caller.callServerEndpoint<List<_ia5bj8wh.AdminDirectoryRow>>(
    'adminOverview',
    'list',
    {
      'category': category,
      'offset': offset,
    },
  );
}

/// {@category Endpoint}
class EndpointCourseContent extends _isc.EndpointRef {
  EndpointCourseContent(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'courseContent';

  _ida.Future<_ipiih5y5.CourseDetail> getCourseContent(
    _isc.UuidValue courseId,
  ) => caller.callServerEndpoint<_ipiih5y5.CourseDetail>(
    'courseContent',
    'getCourseContent',
    {'courseId': courseId},
  );

  _ida.Future<_i1uyt7np.CourseActivity> getActivity(
    _isc.UuidValue courseId,
    _isc.UuidValue activityId,
  ) => caller.callServerEndpoint<_i1uyt7np.CourseActivity>(
    'courseContent',
    'getActivity',
    {
      'courseId': courseId,
      'activityId': activityId,
    },
  );

  _ida.Future<_i4i4so7h.CourseFileAccess> getFileUrl(
    _isc.UuidValue courseId,
    _isc.UuidValue activityId,
  ) => caller.callServerEndpoint<_i4i4so7h.CourseFileAccess>(
    'courseContent',
    'getFileUrl',
    {
      'courseId': courseId,
      'activityId': activityId,
    },
  );
}

/// University-scoped course access and creation.
/// {@category Endpoint}
class EndpointCourse extends _isc.EndpointRef {
  EndpointCourse(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'course';

  _ida.Future<_ip3pjnpw.CourseSummary> create(String title) =>
      caller.callServerEndpoint<_ip3pjnpw.CourseSummary>(
        'course',
        'create',
        {'title': title},
      );

  _ida.Future<_ip3pjnpw.CourseSummary> setPublished(
    _isc.UuidValue courseId,
    bool published,
  ) => caller.callServerEndpoint<_ip3pjnpw.CourseSummary>(
    'course',
    'setPublished',
    {
      'courseId': courseId,
      'published': published,
    },
  );

  _ida.Future<List<_ip3pjnpw.CourseSummary>> listMyCourses() =>
      caller.callServerEndpoint<List<_ip3pjnpw.CourseSummary>>(
        'course',
        'listMyCourses',
        {},
      );

  _ida.Future<_ip3pjnpw.CourseSummary> getCourse(_isc.UuidValue courseId) =>
      caller.callServerEndpoint<_ip3pjnpw.CourseSummary>(
        'course',
        'getCourse',
        {'courseId': courseId},
      );

  _ida.Future<_ip3pjnpw.CourseSummary> setStarred(
    _isc.UuidValue courseId,
    bool starred,
  ) => caller.callServerEndpoint<_ip3pjnpw.CourseSummary>(
    'course',
    'setStarred',
    {
      'courseId': courseId,
      'starred': starred,
    },
  );

  _ida.Future<_ip3pjnpw.CourseSummary> setHidden(
    _isc.UuidValue courseId,
    bool hidden,
  ) => caller.callServerEndpoint<_ip3pjnpw.CourseSummary>(
    'course',
    'setHidden',
    {
      'courseId': courseId,
      'hidden': hidden,
    },
  );
}

/// {@category Endpoint}
class EndpointAccount extends _isc.EndpointRef {
  EndpointAccount(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'account';

  _ida.Future<_iuyrsnts.AccountSnapshot> me() =>
      caller.callServerEndpoint<_iuyrsnts.AccountSnapshot>(
        'account',
        'me',
        {},
      );

  _ida.Future<_i4agt7qy.PendingEmailChangeSummary?> pendingEmailChange() =>
      caller.callServerEndpoint<_i4agt7qy.PendingEmailChangeSummary?>(
        'account',
        'pendingEmailChange',
        {},
      );

  _ida.Future<_i4agt7qy.PendingEmailChangeSummary> startEmailChange({
    required String newEmail,
    required String currentPassword,
    required String locale,
  }) => caller.callServerEndpoint<_i4agt7qy.PendingEmailChangeSummary>(
    'account',
    'startEmailChange',
    {
      'newEmail': newEmail,
      'currentPassword': currentPassword,
      'locale': locale,
    },
  );

  _ida.Future<_i4agt7qy.PendingEmailChangeSummary> resendEmailChange() =>
      caller.callServerEndpoint<_i4agt7qy.PendingEmailChangeSummary>(
        'account',
        'resendEmailChange',
        {},
      );

  _ida.Future<void> cancelEmailChange() => caller.callServerEndpoint<void>(
    'account',
    'cancelEmailChange',
    {},
  );

  _ida.Future<void> confirmEmailChange({required String code}) =>
      caller.callServerEndpoint<void>(
        'account',
        'confirmEmailChange',
        {'code': code},
      );
}

/// {@category Endpoint}
class EndpointAdminInvitations extends _isc.EndpointRef {
  EndpointAdminInvitations(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminInvitations';

  _ida.Future<List<_i9078z8p.InvitationSummary>> list({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i9078z8p.InvitationSummary>>(
    'adminInvitations',
    'list',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  _ida.Future<_i9078z8p.InvitationSummary> create({required String email}) =>
      caller.callServerEndpoint<_i9078z8p.InvitationSummary>(
        'adminInvitations',
        'create',
        {'email': email},
      );

  _ida.Future<void> revoke({required _isc.UuidValue invitationId}) =>
      caller.callServerEndpoint<void>(
        'adminInvitations',
        'revoke',
        {'invitationId': invitationId},
      );
}

/// Public requests do not grant account access. Review requires platform authority.
/// {@category Endpoint}
class EndpointAdministratorRequests extends _isc.EndpointRef {
  EndpointAdministratorRequests(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'administratorRequests';

  _ida.Future<_isc.UuidValue> begin({
    required String name,
    required String email,
    required String university,
    required String position,
    required String note,
    required String locale,
  }) => caller.callServerEndpoint<_isc.UuidValue>(
    'administratorRequests',
    'begin',
    {
      'name': name,
      'email': email,
      'university': university,
      'position': position,
      'note': note,
      'locale': locale,
    },
  );

  _ida.Future<void> verify({
    required _isc.UuidValue requestId,
    required String code,
  }) => caller.callServerEndpoint<void>(
    'administratorRequests',
    'verify',
    {
      'requestId': requestId,
      'code': code,
    },
  );

  _ida.Future<List<_i31qaluo.AdministratorRequestSummary>> list({
    required int offset,
  }) => caller.callServerEndpoint<List<_i31qaluo.AdministratorRequestSummary>>(
    'administratorRequests',
    'list',
    {'offset': offset},
  );

  _ida.Future<int> pendingCount() => caller.callServerEndpoint<int>(
    'administratorRequests',
    'pendingCount',
    {},
  );

  _ida.Future<_i31qaluo.AdministratorRequestSummary?> get(
    _isc.UuidValue requestId,
  ) => caller.callServerEndpoint<_i31qaluo.AdministratorRequestSummary?>(
    'administratorRequests',
    'get',
    {'requestId': requestId},
  );

  _ida.Future<List<_i5j7k3lx.UniversitySummary>> universities() =>
      caller.callServerEndpoint<List<_i5j7k3lx.UniversitySummary>>(
        'administratorRequests',
        'universities',
        {},
      );

  _ida.Future<_i5j7k3lx.UniversitySummary> approve({
    required _isc.UuidValue requestId,
    required String universityName,
    required String slug,
    required String reviewNote,
    _isc.UuidValue? universityId,
  }) => caller.callServerEndpoint<_i5j7k3lx.UniversitySummary>(
    'administratorRequests',
    'approve',
    {
      'requestId': requestId,
      'universityName': universityName,
      'slug': slug,
      'reviewNote': reviewNote,
      'universityId': universityId,
    },
  );

  _ida.Future<void> reject({
    required _isc.UuidValue requestId,
    required String reason,
  }) => caller.callServerEndpoint<void>(
    'administratorRequests',
    'reject',
    {
      'requestId': requestId,
      'reason': reason,
    },
  );

  _ida.Future<int> retryMail() => caller.callServerEndpoint<int>(
    'administratorRequests',
    'retryMail',
    {},
  );
}

/// {@category Endpoint}
class EndpointUniversityAccess extends _isc.EndpointRef {
  EndpointUniversityAccess(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'universityAccess';

  _ida.Future<void> invite({
    required String email,
    required String purpose,
    _isc.UuidValue? courseId,
  }) => caller.callServerEndpoint<void>(
    'universityAccess',
    'invite',
    {
      'email': email,
      'purpose': purpose,
      'courseId': courseId,
    },
  );

  _ida.Future<List<_i9078z8p.InvitationSummary>> invitations({
    required int offset,
  }) => caller.callServerEndpoint<List<_i9078z8p.InvitationSummary>>(
    'universityAccess',
    'invitations',
    {'offset': offset},
  );

  _ida.Future<void> revoke(_isc.UuidValue invitationId) =>
      caller.callServerEndpoint<void>(
        'universityAccess',
        'revoke',
        {'invitationId': invitationId},
      );

  _ida.Future<List<_iijs4wax.UniversityMemberSummary>> members({
    required int offset,
  }) => caller.callServerEndpoint<List<_iijs4wax.UniversityMemberSummary>>(
    'universityAccess',
    'members',
    {'offset': offset},
  );

  _ida.Future<void> setAdministrator({
    required _isc.UuidValue userId,
    required bool enabled,
  }) => caller.callServerEndpoint<void>(
    'universityAccess',
    'setAdministrator',
    {
      'userId': userId,
      'enabled': enabled,
    },
  );
}

/// {@category Endpoint}
class EndpointMessaging extends _isc.EndpointRef {
  EndpointMessaging(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'messaging';

  _ida.Future<_i8gd8qxe.ConversationItem> openSelf() =>
      caller.callServerEndpoint<_i8gd8qxe.ConversationItem>(
        'messaging',
        'openSelf',
        {},
      );

  _ida.Future<_i8gd8qxe.ConversationItem> openPeer(_isc.UuidValue peerId) =>
      caller.callServerEndpoint<_i8gd8qxe.ConversationItem>(
        'messaging',
        'openPeer',
        {'peerId': peerId},
      );

  _ida.Future<_ilotj6jx.MessageItem> send(
    _isc.UuidValue conversationId,
    _isc.UuidValue clientSendId,
    String text,
  ) => caller.callServerEndpoint<_ilotj6jx.MessageItem>(
    'messaging',
    'send',
    {
      'conversationId': conversationId,
      'clientSendId': clientSendId,
      'text': text,
    },
  );

  _ida.Future<List<_i8gd8qxe.ConversationItem>> listConversations() =>
      caller.callServerEndpoint<List<_i8gd8qxe.ConversationItem>>(
        'messaging',
        'listConversations',
        {},
      );

  _ida.Future<List<_isrbg5p2.EligiblePeer>> eligiblePeers(String query) =>
      caller.callServerEndpoint<List<_isrbg5p2.EligiblePeer>>(
        'messaging',
        'eligiblePeers',
        {'query': query},
      );

  _ida.Future<List<_ilotj6jx.MessageItem>> listMessages(
    _isc.UuidValue conversationId,
    int? beforeId,
    int limit,
  ) => caller.callServerEndpoint<List<_ilotj6jx.MessageItem>>(
    'messaging',
    'listMessages',
    {
      'conversationId': conversationId,
      'beforeId': beforeId,
      'limit': limit,
    },
  );

  _ida.Future<void> markRead(
    _isc.UuidValue conversationId,
    int throughMessageId,
  ) => caller.callServerEndpoint<void>(
    'messaging',
    'markRead',
    {
      'conversationId': conversationId,
      'throughMessageId': throughMessageId,
    },
  );
}

/// {@category Endpoint}
class EndpointMyFiles extends _isc.EndpointRef {
  EndpointMyFiles(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'myFiles';

  _ida.Future<List<_iutl1srs.MyUpload>> listUploads() =>
      caller.callServerEndpoint<List<_iutl1srs.MyUpload>>(
        'myFiles',
        'listUploads',
        {},
      );
}

/// {@category Endpoint}
class EndpointNotebook extends _isc.EndpointRef {
  EndpointNotebook(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notebook';

  _ida.Future<_iuz9iu6p.NotebookNoteView> saveNote(
    _isc.UuidValue notebookId,
    _isc.UuidValue turnId,
  ) => caller.callServerEndpoint<_iuz9iu6p.NotebookNoteView>(
    'notebook',
    'saveNote',
    {
      'notebookId': notebookId,
      'turnId': turnId,
    },
  );

  _ida.Future<List<_iuz9iu6p.NotebookNoteView>> getNotes(
    _isc.UuidValue notebookId,
  ) => caller.callServerEndpoint<List<_iuz9iu6p.NotebookNoteView>>(
    'notebook',
    'getNotes',
    {'notebookId': notebookId},
  );

  _ida.Future<void> deleteNote(
    _isc.UuidValue notebookId,
    _isc.UuidValue noteId,
  ) => caller.callServerEndpoint<void>(
    'notebook',
    'deleteNote',
    {
      'notebookId': notebookId,
      'noteId': noteId,
    },
  );

  _ida.Future<_ijcpnvpu.NotebookAssessmentSetup> getAssessmentSetup(
    _isc.UuidValue courseId,
    _isc.UuidValue assessmentActivityId,
  ) => caller.callServerEndpoint<_ijcpnvpu.NotebookAssessmentSetup>(
    'notebook',
    'getAssessmentSetup',
    {
      'courseId': courseId,
      'assessmentActivityId': assessmentActivityId,
    },
  );

  /// Returns the stored supporting passage after current access checks.
  _ida.Future<String> getCitationPassage(
    _isc.UuidValue notebookId,
    _isc.UuidValue turnId,
    _isc.UuidValue chunkId,
  ) => caller.callServerEndpoint<String>(
    'notebook',
    'getCitationPassage',
    {
      'notebookId': notebookId,
      'turnId': turnId,
      'chunkId': chunkId,
    },
  );

  /// Begins a bounded, owner-only upload into private storage.
  _ida.Future<_iudbf9ve.NotebookUploadTicket> beginUpload(
    _ive68yja.NotebookUploadInput input,
  ) => caller.callServerEndpoint<_iudbf9ve.NotebookUploadTicket>(
    'notebook',
    'beginUpload',
    {'input': input},
  );

  _ida.Future<_iiovfcmq.NotebookJobStatus> finishUpload(
    _isc.UuidValue notebookId,
    _isc.UuidValue jobId,
  ) => caller.callServerEndpoint<_iiovfcmq.NotebookJobStatus>(
    'notebook',
    'finishUpload',
    {
      'notebookId': notebookId,
      'jobId': jobId,
    },
  );

  _ida.Future<void> removeUpload(
    _isc.UuidValue notebookId,
    _isc.UuidValue sourceId,
  ) => caller.callServerEndpoint<void>(
    'notebook',
    'removeUpload',
    {
      'notebookId': notebookId,
      'sourceId': sourceId,
    },
  );

  /// Returns private history after rechecking current source access.
  _ida.Future<List<_id13ccyf.NotebookTurnView>> getTurns(
    _isc.UuidValue notebookId,
  ) => caller.callServerEndpoint<List<_id13ccyf.NotebookTurnView>>(
    'notebook',
    'getTurns',
    {'notebookId': notebookId},
  );

  _ida.Future<_izqdo623.NotebookOverview> openNotebook(
    _isc.UuidValue courseId,
    _isc.UuidValue assessmentActivityId,
  ) => caller.callServerEndpoint<_izqdo623.NotebookOverview>(
    'notebook',
    'openNotebook',
    {
      'courseId': courseId,
      'assessmentActivityId': assessmentActivityId,
    },
  );

  _ida.Future<_ipsbqoy1.NotebookAssessmentConfigView> configureAssessment(
    _iq1ufyg4.NotebookAssessmentConfigInput input,
  ) => caller.callServerEndpoint<_ipsbqoy1.NotebookAssessmentConfigView>(
    'notebook',
    'configureAssessment',
    {'input': input},
  );

  _ida.Future<void> setSelectedSources(
    _isc.UuidValue notebookId,
    List<_isc.UuidValue> sourceIds,
  ) => caller.callServerEndpoint<void>(
    'notebook',
    'setSelectedSources',
    {
      'notebookId': notebookId,
      'sourceIds': sourceIds,
    },
  );

  _ida.Future<_iiovfcmq.NotebookJobStatus> ask(
    _idfiduog.NotebookChatInput input,
  ) => caller.callServerEndpoint<_iiovfcmq.NotebookJobStatus>(
    'notebook',
    'ask',
    {'input': input},
  );

  _ida.Future<_iiovfcmq.NotebookJobStatus> getJobStatus(
    _isc.UuidValue notebookId,
    _isc.UuidValue jobId,
  ) => caller.callServerEndpoint<_iiovfcmq.NotebookJobStatus>(
    'notebook',
    'getJobStatus',
    {
      'notebookId': notebookId,
      'jobId': jobId,
    },
  );

  _ida.Future<_iiovfcmq.NotebookJobStatus> generateStudioItem(
    _i6q8e6ut.NotebookStudioRequest input,
  ) => caller.callServerEndpoint<_iiovfcmq.NotebookJobStatus>(
    'notebook',
    'generateStudioItem',
    {'input': input},
  );

  _ida.Future<List<_iiovfcmq.NotebookJobStatus>> getStudioJobs(
    _isc.UuidValue notebookId,
  ) => caller.callServerEndpoint<List<_iiovfcmq.NotebookJobStatus>>(
    'notebook',
    'getStudioJobs',
    {'notebookId': notebookId},
  );

  _ida.Future<List<_irywxl2u.NotebookStudioItem>> getStudioItems(
    _isc.UuidValue notebookId,
  ) => caller.callServerEndpoint<List<_irywxl2u.NotebookStudioItem>>(
    'notebook',
    'getStudioItems',
    {'notebookId': notebookId},
  );

  _ida.Future<_irywxl2u.NotebookStudioItem> getStudioItem(
    _isc.UuidValue notebookId,
    _isc.UuidValue artifactId,
  ) => caller.callServerEndpoint<_irywxl2u.NotebookStudioItem>(
    'notebook',
    'getStudioItem',
    {
      'notebookId': notebookId,
      'artifactId': artifactId,
    },
  );

  _ida.Future<String> getStudioCitationPassage(
    _isc.UuidValue notebookId,
    _isc.UuidValue artifactId,
    _isc.UuidValue chunkId,
  ) => caller.callServerEndpoint<String>(
    'notebook',
    'getStudioCitationPassage',
    {
      'notebookId': notebookId,
      'artifactId': artifactId,
      'chunkId': chunkId,
    },
  );

  _ida.Future<_ijjzb9sz.NotebookAudioAccess> getStudioAudioAccess(
    _isc.UuidValue notebookId,
    _isc.UuidValue artifactId,
  ) => caller.callServerEndpoint<_ijjzb9sz.NotebookAudioAccess>(
    'notebook',
    'getStudioAudioAccess',
    {
      'notebookId': notebookId,
      'artifactId': artifactId,
    },
  );
}

/// {@category Endpoint}
class EndpointNotifications extends _isc.EndpointRef {
  EndpointNotifications(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notifications';

  _ida.Future<List<_i4wyle5u.NotificationItem>> list(
    int offset,
    int limit,
    String? category,
    bool unreadOnly,
  ) => caller.callServerEndpoint<List<_i4wyle5u.NotificationItem>>(
    'notifications',
    'list',
    {
      'offset': offset,
      'limit': limit,
      'category': category,
      'unreadOnly': unreadOnly,
    },
  );

  _ida.Future<int> unreadCount() => caller.callServerEndpoint<int>(
    'notifications',
    'unreadCount',
    {},
  );

  _ida.Future<_i4wyle5u.NotificationItem?> get(_isc.UuidValue id) =>
      caller.callServerEndpoint<_i4wyle5u.NotificationItem?>(
        'notifications',
        'get',
        {'id': id},
      );

  _ida.Future<void> markRead(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'notifications',
        'markRead',
        {'id': id},
      );

  _ida.Future<void> markAllRead() => caller.callServerEndpoint<void>(
    'notifications',
    'markAllRead',
    {},
  );
}

/// Registration IDs are leases: delayed logout cannot remove a newer binding.
/// {@category Endpoint}
class EndpointPushDevices extends _isc.EndpointRef {
  EndpointPushDevices(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'pushDevices';

  _ida.Future<_isc.UuidValue> register(
    _isc.UuidValue installationId,
    String platform,
    String token,
  ) => caller.callServerEndpoint<_isc.UuidValue>(
    'pushDevices',
    'register',
    {
      'installationId': installationId,
      'platform': platform,
      'token': token,
    },
  );

  _ida.Future<void> unregister(_isc.UuidValue registrationId) =>
      caller.callServerEndpoint<void>(
        'pushDevices',
        'unregister',
        {'registrationId': registrationId},
      );
}

/// {@category Endpoint}
class EndpointSearch extends _isc.EndpointRef {
  EndpointSearch(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'search';

  _ida.Future<_ihg9oqpt.SearchResponse> search(
    String query, {
    _isc.UuidValue? courseId,
    String? kind,
  }) => caller.callServerEndpoint<_ihg9oqpt.SearchResponse>(
    'search',
    'search',
    {
      'query': query,
      'courseId': courseId,
      'kind': kind,
    },
  );

  _ida.Future<List<_ivpnxyts.SearchRecent>> listRecent() =>
      caller.callServerEndpoint<List<_ivpnxyts.SearchRecent>>(
        'search',
        'listRecent',
        {},
      );

  _ida.Future<List<_ivpnxyts.SearchRecent>> saveRecent(String query) =>
      caller.callServerEndpoint<List<_ivpnxyts.SearchRecent>>(
        'search',
        'saveRecent',
        {'query': query},
      );

  _ida.Future<List<_ivpnxyts.SearchRecent>> deleteRecent(int id) =>
      caller.callServerEndpoint<List<_ivpnxyts.SearchRecent>>(
        'search',
        'deleteRecent',
        {'id': id},
      );

  _ida.Future<List<_ivpnxyts.SearchRecent>> clearRecent() =>
      caller.callServerEndpoint<List<_ivpnxyts.SearchRecent>>(
        'search',
        'clearRecent',
        {},
      );
}

/// {@category Endpoint}
class EndpointStudentLearning extends _isc.EndpointRef {
  EndpointStudentLearning(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'studentLearning';

  _ida.Future<_iw2sqntt.StudentTasksResponse> listTasks() =>
      caller.callServerEndpoint<_iw2sqntt.StudentTasksResponse>(
        'studentLearning',
        'listTasks',
        {},
      );

  _ida.Future<_iuszwrzt.StudentGradesResponse> listGrades() =>
      caller.callServerEndpoint<_iuszwrzt.StudentGradesResponse>(
        'studentLearning',
        'listGrades',
        {},
      );
}

/// {@category Endpoint}
class EndpointTeaching extends _isc.EndpointRef {
  EndpointTeaching(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'teaching';

  _ida.Future<List<_ij0l49uv.TeachingCourseView>> dashboard() =>
      caller.callServerEndpoint<List<_ij0l49uv.TeachingCourseView>>(
        'teaching',
        'dashboard',
        {},
      );

  _ida.Future<List<_iopdwa8s.TeachingMemberView>> members(
    _isc.UuidValue courseId,
  ) => caller.callServerEndpoint<List<_iopdwa8s.TeachingMemberView>>(
    'teaching',
    'members',
    {'courseId': courseId},
  );

  _ida.Future<List<_iy9mrm6d.TeachingActivityView>> listActivities(
    _isc.UuidValue courseId,
  ) => caller.callServerEndpoint<List<_iy9mrm6d.TeachingActivityView>>(
    'teaching',
    'listActivities',
    {'courseId': courseId},
  );

  _ida.Future<_iy9mrm6d.TeachingActivityView> getActivity(
    _isc.UuidValue courseId,
    _isc.UuidValue activityId,
  ) => caller.callServerEndpoint<_iy9mrm6d.TeachingActivityView>(
    'teaching',
    'getActivity',
    {
      'courseId': courseId,
      'activityId': activityId,
    },
  );

  _ida.Future<_iy9mrm6d.TeachingActivityView> saveActivity(
    _ijb5aojr.TeachingSaveInput input,
  ) => caller.callServerEndpoint<_iy9mrm6d.TeachingActivityView>(
    'teaching',
    'saveActivity',
    {'input': input},
  );

  _ida.Future<_iysm72fm.TeachingSettings> getDefaults() =>
      caller.callServerEndpoint<_iysm72fm.TeachingSettings>(
        'teaching',
        'getDefaults',
        {},
      );

  _ida.Future<_iysm72fm.TeachingSettings> saveDefaults(
    _iysm72fm.TeachingSettings settings,
  ) => caller.callServerEndpoint<_iysm72fm.TeachingSettings>(
    'teaching',
    'saveDefaults',
    {'settings': settings},
  );

  _ida.Future<_iq0338zw.TeachingUploadTicket> beginUpload(
    _isc.UuidValue courseId,
    _isc.UuidValue activityId,
    String fileName,
    int sizeBytes,
  ) => caller.callServerEndpoint<_iq0338zw.TeachingUploadTicket>(
    'teaching',
    'beginUpload',
    {
      'courseId': courseId,
      'activityId': activityId,
      'fileName': fileName,
      'sizeBytes': sizeBytes,
    },
  );

  _ida.Future<_iy9mrm6d.TeachingActivityView> submitAssignment(
    _isc.UuidValue courseId,
    _isc.UuidValue activityId,
    String text,
    _isc.UuidValue? uploadId,
    String requestKey,
  ) => caller.callServerEndpoint<_iy9mrm6d.TeachingActivityView>(
    'teaching',
    'submitAssignment',
    {
      'courseId': courseId,
      'activityId': activityId,
      'text': text,
      'uploadId': uploadId,
      'requestKey': requestKey,
    },
  );

  _ida.Future<_iy9mrm6d.TeachingActivityView> gradeAssignment(
    _isc.UuidValue courseId,
    _isc.UuidValue activityId,
    _isc.UuidValue submissionId,
    double points,
    String feedback,
    bool publish,
  ) => caller.callServerEndpoint<_iy9mrm6d.TeachingActivityView>(
    'teaching',
    'gradeAssignment',
    {
      'courseId': courseId,
      'activityId': activityId,
      'submissionId': submissionId,
      'points': points,
      'feedback': feedback,
      'publish': publish,
    },
  );

  _ida.Future<_iy9mrm6d.TeachingActivityView> reopenAssignment(
    _isc.UuidValue courseId,
    _isc.UuidValue activityId,
    _isc.UuidValue ownerId,
    DateTime deadline,
  ) => caller.callServerEndpoint<_iy9mrm6d.TeachingActivityView>(
    'teaching',
    'reopenAssignment',
    {
      'courseId': courseId,
      'activityId': activityId,
      'ownerId': ownerId,
      'deadline': deadline,
    },
  );

  _ida.Future<_i4i4so7h.CourseFileAccess> submissionFile(
    _isc.UuidValue courseId,
    _isc.UuidValue activityId,
    _isc.UuidValue submissionId,
  ) => caller.callServerEndpoint<_i4i4so7h.CourseFileAccess>(
    'teaching',
    'submissionFile',
    {
      'courseId': courseId,
      'activityId': activityId,
      'submissionId': submissionId,
    },
  );

  _ida.Future<_iy9mrm6d.TeachingActivityView> startTest(
    _isc.UuidValue courseId,
    _isc.UuidValue activityId,
  ) => caller.callServerEndpoint<_iy9mrm6d.TeachingActivityView>(
    'teaching',
    'startTest',
    {
      'courseId': courseId,
      'activityId': activityId,
    },
  );

  _ida.Future<_iy9mrm6d.TeachingActivityView> saveAnswers(
    _isc.UuidValue courseId,
    _isc.UuidValue activityId,
    _isc.UuidValue attemptId,
    List<int> answers,
    bool finish,
  ) => caller.callServerEndpoint<_iy9mrm6d.TeachingActivityView>(
    'teaching',
    'saveAnswers',
    {
      'courseId': courseId,
      'activityId': activityId,
      'attemptId': attemptId,
      'answers': answers,
      'finish': finish,
    },
  );

  _ida.Future<_iy9mrm6d.TeachingActivityView> releaseTest(
    _isc.UuidValue courseId,
    _isc.UuidValue activityId,
  ) => caller.callServerEndpoint<_iy9mrm6d.TeachingActivityView>(
    'teaching',
    'releaseTest',
    {
      'courseId': courseId,
      'activityId': activityId,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    adminOverview = EndpointAdminOverview(this);
    courseContent = EndpointCourseContent(this);
    course = EndpointCourse(this);
    account = EndpointAccount(this);
    adminInvitations = EndpointAdminInvitations(this);
    administratorRequests = EndpointAdministratorRequests(this);
    universityAccess = EndpointUniversityAccess(this);
    messaging = EndpointMessaging(this);
    myFiles = EndpointMyFiles(this);
    notebook = EndpointNotebook(this);
    notifications = EndpointNotifications(this);
    pushDevices = EndpointPushDevices(this);
    search = EndpointSearch(this);
    studentLearning = EndpointStudentLearning(this);
    teaching = EndpointTeaching(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAdminOverview adminOverview;

  late final EndpointCourseContent courseContent;

  late final EndpointCourse course;

  late final EndpointAccount account;

  late final EndpointAdminInvitations adminInvitations;

  late final EndpointAdministratorRequests administratorRequests;

  late final EndpointUniversityAccess universityAccess;

  late final EndpointMessaging messaging;

  late final EndpointMyFiles myFiles;

  late final EndpointNotebook notebook;

  late final EndpointNotifications notifications;

  late final EndpointPushDevices pushDevices;

  late final EndpointSearch search;

  late final EndpointStudentLearning studentLearning;

  late final EndpointTeaching teaching;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'adminOverview': adminOverview,
    'courseContent': courseContent,
    'course': course,
    'account': account,
    'adminInvitations': adminInvitations,
    'administratorRequests': administratorRequests,
    'universityAccess': universityAccess,
    'messaging': messaging,
    'myFiles': myFiles,
    'notebook': notebook,
    'notifications': notifications,
    'pushDevices': pushDevices,
    'search': search,
    'studentLearning': studentLearning,
    'teaching': teaching,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
