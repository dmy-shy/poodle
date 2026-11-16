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
import 'package:poodle_server/src/generated/future_calls.dart' as _ia6dpipn;
import 'package:poodle_server/src/generated/modules/notebook/notebook_assessment_config_input.dart'
    as _iixici8r;
import 'package:poodle_server/src/generated/modules/notebook/notebook_chat_input.dart'
    as _iyw4gpx7;
import 'package:poodle_server/src/generated/modules/notebook/notebook_studio_request.dart'
    as _iarzqt9e;
import 'package:poodle_server/src/generated/modules/notebook/notebook_upload_input.dart'
    as _ihydbftd;
import 'package:poodle_server/src/generated/modules/teaching/teaching_save_input.dart'
    as _i4fz2kgh;
import 'package:poodle_server/src/generated/modules/teaching/teaching_settings.dart'
    as _ile4zehq;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../modules/admin/admin_overview_endpoint.dart' as _i1ns2di1;
import '../modules/course_content/course_content_endpoint.dart' as _irvn9uye;
import '../modules/courses/course_endpoint.dart' as _i2rng0bo;
import '../modules/identity/account_endpoint.dart' as _ik9okekz;
import '../modules/identity/admin_invitations_endpoint.dart' as _i3di23cc;
import '../modules/identity/administrator_requests_endpoint.dart' as _it0nd8ey;
import '../modules/identity/university_access_endpoint.dart' as _irvex875;
import '../modules/messaging/messaging_endpoint.dart' as _iuy2g8yy;
import '../modules/my_files/my_files_endpoint.dart' as _i6xnhkw5;
import '../modules/notebook/notebook_endpoint.dart' as _igzx34cy;
import '../modules/notifications/notifications_endpoint.dart' as _ixfuytjp;
import '../modules/notifications/push_devices_endpoint.dart' as _ikun4key;
import '../modules/search/search_endpoint.dart' as _ife56g8m;
import '../modules/student_learning/student_learning_endpoint.dart'
    as _iksi4z8f;
import '../modules/teaching/teaching_endpoint.dart' as _ikzi1wna;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'adminOverview': _i1ns2di1.AdminOverviewEndpoint()
        ..initialize(
          server,
          'adminOverview',
          null,
        ),
      'courseContent': _irvn9uye.CourseContentEndpoint()
        ..initialize(
          server,
          'courseContent',
          null,
        ),
      'course': _i2rng0bo.CourseEndpoint()
        ..initialize(
          server,
          'course',
          null,
        ),
      'account': _ik9okekz.AccountEndpoint()
        ..initialize(
          server,
          'account',
          null,
        ),
      'adminInvitations': _i3di23cc.AdminInvitationsEndpoint()
        ..initialize(
          server,
          'adminInvitations',
          null,
        ),
      'administratorRequests': _it0nd8ey.AdministratorRequestsEndpoint()
        ..initialize(
          server,
          'administratorRequests',
          null,
        ),
      'universityAccess': _irvex875.UniversityAccessEndpoint()
        ..initialize(
          server,
          'universityAccess',
          null,
        ),
      'messaging': _iuy2g8yy.MessagingEndpoint()
        ..initialize(
          server,
          'messaging',
          null,
        ),
      'myFiles': _i6xnhkw5.MyFilesEndpoint()
        ..initialize(
          server,
          'myFiles',
          null,
        ),
      'notebook': _igzx34cy.NotebookEndpoint()
        ..initialize(
          server,
          'notebook',
          null,
        ),
      'notifications': _ixfuytjp.NotificationsEndpoint()
        ..initialize(
          server,
          'notifications',
          null,
        ),
      'pushDevices': _ikun4key.PushDevicesEndpoint()
        ..initialize(
          server,
          'pushDevices',
          null,
        ),
      'search': _ife56g8m.SearchEndpoint()
        ..initialize(
          server,
          'search',
          null,
        ),
      'studentLearning': _iksi4z8f.StudentLearningEndpoint()
        ..initialize(
          server,
          'studentLearning',
          null,
        ),
      'teaching': _ikzi1wna.TeachingEndpoint()
        ..initialize(
          server,
          'teaching',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'locale': _is.ParameterDescription(
              name: 'locale',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                    locale: params['locale'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'locale': _is.ParameterDescription(
              name: 'locale',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                    locale: params['locale'],
                  ),
        ),
        'googleLogin': _is.MethodConnector(
          name: 'googleLogin',
          params: {
            'idToken': _is.ParameterDescription(
              name: 'idToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .googleLogin(
                    session,
                    idToken: params['idToken'],
                  ),
        ),
        'linkGoogle': _is.MethodConnector(
          name: 'linkGoogle',
          params: {
            'idToken': _is.ParameterDescription(
              name: 'idToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .linkGoogle(
                    session,
                    idToken: params['idToken'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['adminOverview'] = _is.EndpointConnector(
      name: 'adminOverview',
      endpoint: endpoints['adminOverview']!,
      methodConnectors: {
        'summary': _is.MethodConnector(
          name: 'summary',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminOverview']
                          as _i1ns2di1.AdminOverviewEndpoint)
                      .summary(session),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminOverview']
                          as _i1ns2di1.AdminOverviewEndpoint)
                      .list(
                        session,
                        params['category'],
                        params['offset'],
                      ),
        ),
      },
    );
    connectors['courseContent'] = _is.EndpointConnector(
      name: 'courseContent',
      endpoint: endpoints['courseContent']!,
      methodConnectors: {
        'getCourseContent': _is.MethodConnector(
          name: 'getCourseContent',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['courseContent']
                          as _irvn9uye.CourseContentEndpoint)
                      .getCourseContent(
                        session,
                        params['courseId'],
                      ),
        ),
        'getActivity': _is.MethodConnector(
          name: 'getActivity',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['courseContent']
                          as _irvn9uye.CourseContentEndpoint)
                      .getActivity(
                        session,
                        params['courseId'],
                        params['activityId'],
                      ),
        ),
        'getFileUrl': _is.MethodConnector(
          name: 'getFileUrl',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['courseContent']
                          as _irvn9uye.CourseContentEndpoint)
                      .getFileUrl(
                        session,
                        params['courseId'],
                        params['activityId'],
                      ),
        ),
      },
    );
    connectors['course'] = _is.EndpointConnector(
      name: 'course',
      endpoint: endpoints['course']!,
      methodConnectors: {
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['course'] as _i2rng0bo.CourseEndpoint).create(
                    session,
                    params['title'],
                  ),
        ),
        'setPublished': _is.MethodConnector(
          name: 'setPublished',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'published': _is.ParameterDescription(
              name: 'published',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['course'] as _i2rng0bo.CourseEndpoint)
                  .setPublished(
                    session,
                    params['courseId'],
                    params['published'],
                  ),
        ),
        'listMyCourses': _is.MethodConnector(
          name: 'listMyCourses',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['course'] as _i2rng0bo.CourseEndpoint)
                  .listMyCourses(session),
        ),
        'getCourse': _is.MethodConnector(
          name: 'getCourse',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['course'] as _i2rng0bo.CourseEndpoint).getCourse(
                    session,
                    params['courseId'],
                  ),
        ),
        'setStarred': _is.MethodConnector(
          name: 'setStarred',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'starred': _is.ParameterDescription(
              name: 'starred',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['course'] as _i2rng0bo.CourseEndpoint).setStarred(
                    session,
                    params['courseId'],
                    params['starred'],
                  ),
        ),
        'setHidden': _is.MethodConnector(
          name: 'setHidden',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'hidden': _is.ParameterDescription(
              name: 'hidden',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['course'] as _i2rng0bo.CourseEndpoint).setHidden(
                    session,
                    params['courseId'],
                    params['hidden'],
                  ),
        ),
      },
    );
    connectors['account'] = _is.EndpointConnector(
      name: 'account',
      endpoint: endpoints['account']!,
      methodConnectors: {
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _ik9okekz.AccountEndpoint).me(
                session,
              ),
        ),
        'pendingEmailChange': _is.MethodConnector(
          name: 'pendingEmailChange',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _ik9okekz.AccountEndpoint)
                  .pendingEmailChange(session),
        ),
        'startEmailChange': _is.MethodConnector(
          name: 'startEmailChange',
          params: {
            'newEmail': _is.ParameterDescription(
              name: 'newEmail',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'currentPassword': _is.ParameterDescription(
              name: 'currentPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'locale': _is.ParameterDescription(
              name: 'locale',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _ik9okekz.AccountEndpoint)
                  .startEmailChange(
                    session,
                    newEmail: params['newEmail'],
                    currentPassword: params['currentPassword'],
                    locale: params['locale'],
                  ),
        ),
        'resendEmailChange': _is.MethodConnector(
          name: 'resendEmailChange',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _ik9okekz.AccountEndpoint)
                  .resendEmailChange(session),
        ),
        'cancelEmailChange': _is.MethodConnector(
          name: 'cancelEmailChange',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _ik9okekz.AccountEndpoint)
                  .cancelEmailChange(session),
        ),
        'confirmEmailChange': _is.MethodConnector(
          name: 'confirmEmailChange',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _ik9okekz.AccountEndpoint)
                  .confirmEmailChange(
                    session,
                    code: params['code'],
                  ),
        ),
      },
    );
    connectors['adminInvitations'] = _is.EndpointConnector(
      name: 'adminInvitations',
      endpoint: endpoints['adminInvitations']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminInvitations']
                          as _i3di23cc.AdminInvitationsEndpoint)
                      .list(
                        session,
                        limit: params['limit'],
                        offset: params['offset'],
                      ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminInvitations']
                          as _i3di23cc.AdminInvitationsEndpoint)
                      .create(
                        session,
                        email: params['email'],
                      ),
        ),
        'revoke': _is.MethodConnector(
          name: 'revoke',
          params: {
            'invitationId': _is.ParameterDescription(
              name: 'invitationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminInvitations']
                          as _i3di23cc.AdminInvitationsEndpoint)
                      .revoke(
                        session,
                        invitationId: params['invitationId'],
                      ),
        ),
      },
    );
    connectors['administratorRequests'] = _is.EndpointConnector(
      name: 'administratorRequests',
      endpoint: endpoints['administratorRequests']!,
      methodConnectors: {
        'begin': _is.MethodConnector(
          name: 'begin',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'university': _is.ParameterDescription(
              name: 'university',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'position': _is.ParameterDescription(
              name: 'position',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'locale': _is.ParameterDescription(
              name: 'locale',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['administratorRequests']
                          as _it0nd8ey.AdministratorRequestsEndpoint)
                      .begin(
                        session,
                        name: params['name'],
                        email: params['email'],
                        university: params['university'],
                        position: params['position'],
                        note: params['note'],
                        locale: params['locale'],
                      ),
        ),
        'verify': _is.MethodConnector(
          name: 'verify',
          params: {
            'requestId': _is.ParameterDescription(
              name: 'requestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['administratorRequests']
                          as _it0nd8ey.AdministratorRequestsEndpoint)
                      .verify(
                        session,
                        requestId: params['requestId'],
                        code: params['code'],
                      ),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['administratorRequests']
                          as _it0nd8ey.AdministratorRequestsEndpoint)
                      .list(
                        session,
                        offset: params['offset'],
                      ),
        ),
        'pendingCount': _is.MethodConnector(
          name: 'pendingCount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['administratorRequests']
                          as _it0nd8ey.AdministratorRequestsEndpoint)
                      .pendingCount(session),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'requestId': _is.ParameterDescription(
              name: 'requestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['administratorRequests']
                          as _it0nd8ey.AdministratorRequestsEndpoint)
                      .get(
                        session,
                        params['requestId'],
                      ),
        ),
        'universities': _is.MethodConnector(
          name: 'universities',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['administratorRequests']
                          as _it0nd8ey.AdministratorRequestsEndpoint)
                      .universities(session),
        ),
        'approve': _is.MethodConnector(
          name: 'approve',
          params: {
            'requestId': _is.ParameterDescription(
              name: 'requestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'universityName': _is.ParameterDescription(
              name: 'universityName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'slug': _is.ParameterDescription(
              name: 'slug',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'reviewNote': _is.ParameterDescription(
              name: 'reviewNote',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'universityId': _is.ParameterDescription(
              name: 'universityId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['administratorRequests']
                          as _it0nd8ey.AdministratorRequestsEndpoint)
                      .approve(
                        session,
                        requestId: params['requestId'],
                        universityName: params['universityName'],
                        slug: params['slug'],
                        reviewNote: params['reviewNote'],
                        universityId: params['universityId'],
                      ),
        ),
        'reject': _is.MethodConnector(
          name: 'reject',
          params: {
            'requestId': _is.ParameterDescription(
              name: 'requestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['administratorRequests']
                          as _it0nd8ey.AdministratorRequestsEndpoint)
                      .reject(
                        session,
                        requestId: params['requestId'],
                        reason: params['reason'],
                      ),
        ),
        'retryMail': _is.MethodConnector(
          name: 'retryMail',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['administratorRequests']
                          as _it0nd8ey.AdministratorRequestsEndpoint)
                      .retryMail(session),
        ),
      },
    );
    connectors['universityAccess'] = _is.EndpointConnector(
      name: 'universityAccess',
      endpoint: endpoints['universityAccess']!,
      methodConnectors: {
        'invite': _is.MethodConnector(
          name: 'invite',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'purpose': _is.ParameterDescription(
              name: 'purpose',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['universityAccess']
                          as _irvex875.UniversityAccessEndpoint)
                      .invite(
                        session,
                        email: params['email'],
                        purpose: params['purpose'],
                        courseId: params['courseId'],
                      ),
        ),
        'invitations': _is.MethodConnector(
          name: 'invitations',
          params: {
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['universityAccess']
                          as _irvex875.UniversityAccessEndpoint)
                      .invitations(
                        session,
                        offset: params['offset'],
                      ),
        ),
        'revoke': _is.MethodConnector(
          name: 'revoke',
          params: {
            'invitationId': _is.ParameterDescription(
              name: 'invitationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['universityAccess']
                          as _irvex875.UniversityAccessEndpoint)
                      .revoke(
                        session,
                        params['invitationId'],
                      ),
        ),
        'members': _is.MethodConnector(
          name: 'members',
          params: {
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['universityAccess']
                          as _irvex875.UniversityAccessEndpoint)
                      .members(
                        session,
                        offset: params['offset'],
                      ),
        ),
        'setAdministrator': _is.MethodConnector(
          name: 'setAdministrator',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'enabled': _is.ParameterDescription(
              name: 'enabled',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['universityAccess']
                          as _irvex875.UniversityAccessEndpoint)
                      .setAdministrator(
                        session,
                        userId: params['userId'],
                        enabled: params['enabled'],
                      ),
        ),
      },
    );
    connectors['messaging'] = _is.EndpointConnector(
      name: 'messaging',
      endpoint: endpoints['messaging']!,
      methodConnectors: {
        'openSelf': _is.MethodConnector(
          name: 'openSelf',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['messaging'] as _iuy2g8yy.MessagingEndpoint)
                  .openSelf(session),
        ),
        'openPeer': _is.MethodConnector(
          name: 'openPeer',
          params: {
            'peerId': _is.ParameterDescription(
              name: 'peerId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['messaging'] as _iuy2g8yy.MessagingEndpoint)
                  .openPeer(
                    session,
                    params['peerId'],
                  ),
        ),
        'send': _is.MethodConnector(
          name: 'send',
          params: {
            'conversationId': _is.ParameterDescription(
              name: 'conversationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'clientSendId': _is.ParameterDescription(
              name: 'clientSendId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['messaging'] as _iuy2g8yy.MessagingEndpoint).send(
                    session,
                    params['conversationId'],
                    params['clientSendId'],
                    params['text'],
                  ),
        ),
        'listConversations': _is.MethodConnector(
          name: 'listConversations',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['messaging'] as _iuy2g8yy.MessagingEndpoint)
                  .listConversations(session),
        ),
        'eligiblePeers': _is.MethodConnector(
          name: 'eligiblePeers',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['messaging'] as _iuy2g8yy.MessagingEndpoint)
                  .eligiblePeers(
                    session,
                    params['query'],
                  ),
        ),
        'listMessages': _is.MethodConnector(
          name: 'listMessages',
          params: {
            'conversationId': _is.ParameterDescription(
              name: 'conversationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'beforeId': _is.ParameterDescription(
              name: 'beforeId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['messaging'] as _iuy2g8yy.MessagingEndpoint)
                  .listMessages(
                    session,
                    params['conversationId'],
                    params['beforeId'],
                    params['limit'],
                  ),
        ),
        'markRead': _is.MethodConnector(
          name: 'markRead',
          params: {
            'conversationId': _is.ParameterDescription(
              name: 'conversationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'throughMessageId': _is.ParameterDescription(
              name: 'throughMessageId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['messaging'] as _iuy2g8yy.MessagingEndpoint)
                  .markRead(
                    session,
                    params['conversationId'],
                    params['throughMessageId'],
                  ),
        ),
      },
    );
    connectors['myFiles'] = _is.EndpointConnector(
      name: 'myFiles',
      endpoint: endpoints['myFiles']!,
      methodConnectors: {
        'listUploads': _is.MethodConnector(
          name: 'listUploads',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['myFiles'] as _i6xnhkw5.MyFilesEndpoint)
                  .listUploads(session),
        ),
      },
    );
    connectors['notebook'] = _is.EndpointConnector(
      name: 'notebook',
      endpoint: endpoints['notebook']!,
      methodConnectors: {
        'saveNote': _is.MethodConnector(
          name: 'saveNote',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'turnId': _is.ParameterDescription(
              name: 'turnId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .saveNote(
                    session,
                    params['notebookId'],
                    params['turnId'],
                  ),
        ),
        'getNotes': _is.MethodConnector(
          name: 'getNotes',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .getNotes(
                    session,
                    params['notebookId'],
                  ),
        ),
        'deleteNote': _is.MethodConnector(
          name: 'deleteNote',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'noteId': _is.ParameterDescription(
              name: 'noteId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .deleteNote(
                    session,
                    params['notebookId'],
                    params['noteId'],
                  ),
        ),
        'getAssessmentSetup': _is.MethodConnector(
          name: 'getAssessmentSetup',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'assessmentActivityId': _is.ParameterDescription(
              name: 'assessmentActivityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .getAssessmentSetup(
                    session,
                    params['courseId'],
                    params['assessmentActivityId'],
                  ),
        ),
        'getCitationPassage': _is.MethodConnector(
          name: 'getCitationPassage',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'turnId': _is.ParameterDescription(
              name: 'turnId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'chunkId': _is.ParameterDescription(
              name: 'chunkId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .getCitationPassage(
                    session,
                    params['notebookId'],
                    params['turnId'],
                    params['chunkId'],
                  ),
        ),
        'beginUpload': _is.MethodConnector(
          name: 'beginUpload',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_ihydbftd.NotebookUploadInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .beginUpload(
                    session,
                    params['input'],
                  ),
        ),
        'finishUpload': _is.MethodConnector(
          name: 'finishUpload',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'jobId': _is.ParameterDescription(
              name: 'jobId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .finishUpload(
                    session,
                    params['notebookId'],
                    params['jobId'],
                  ),
        ),
        'removeUpload': _is.MethodConnector(
          name: 'removeUpload',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'sourceId': _is.ParameterDescription(
              name: 'sourceId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .removeUpload(
                    session,
                    params['notebookId'],
                    params['sourceId'],
                  ),
        ),
        'getTurns': _is.MethodConnector(
          name: 'getTurns',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .getTurns(
                    session,
                    params['notebookId'],
                  ),
        ),
        'openNotebook': _is.MethodConnector(
          name: 'openNotebook',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'assessmentActivityId': _is.ParameterDescription(
              name: 'assessmentActivityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .openNotebook(
                    session,
                    params['courseId'],
                    params['assessmentActivityId'],
                  ),
        ),
        'configureAssessment': _is.MethodConnector(
          name: 'configureAssessment',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_iixici8r.NotebookAssessmentConfigInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .configureAssessment(
                    session,
                    params['input'],
                  ),
        ),
        'setSelectedSources': _is.MethodConnector(
          name: 'setSelectedSources',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'sourceIds': _is.ParameterDescription(
              name: 'sourceIds',
              type: _is.getType<List<_is.UuidValue>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .setSelectedSources(
                    session,
                    params['notebookId'],
                    params['sourceIds'],
                  ),
        ),
        'ask': _is.MethodConnector(
          name: 'ask',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_iyw4gpx7.NotebookChatInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notebook'] as _igzx34cy.NotebookEndpoint).ask(
                    session,
                    params['input'],
                  ),
        ),
        'getJobStatus': _is.MethodConnector(
          name: 'getJobStatus',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'jobId': _is.ParameterDescription(
              name: 'jobId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .getJobStatus(
                    session,
                    params['notebookId'],
                    params['jobId'],
                  ),
        ),
        'generateStudioItem': _is.MethodConnector(
          name: 'generateStudioItem',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_iarzqt9e.NotebookStudioRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .generateStudioItem(
                    session,
                    params['input'],
                  ),
        ),
        'getStudioJobs': _is.MethodConnector(
          name: 'getStudioJobs',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .getStudioJobs(
                    session,
                    params['notebookId'],
                  ),
        ),
        'getStudioItems': _is.MethodConnector(
          name: 'getStudioItems',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .getStudioItems(
                    session,
                    params['notebookId'],
                  ),
        ),
        'getStudioItem': _is.MethodConnector(
          name: 'getStudioItem',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'artifactId': _is.ParameterDescription(
              name: 'artifactId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .getStudioItem(
                    session,
                    params['notebookId'],
                    params['artifactId'],
                  ),
        ),
        'getStudioCitationPassage': _is.MethodConnector(
          name: 'getStudioCitationPassage',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'artifactId': _is.ParameterDescription(
              name: 'artifactId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'chunkId': _is.ParameterDescription(
              name: 'chunkId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .getStudioCitationPassage(
                    session,
                    params['notebookId'],
                    params['artifactId'],
                    params['chunkId'],
                  ),
        ),
        'getStudioAudioAccess': _is.MethodConnector(
          name: 'getStudioAudioAccess',
          params: {
            'notebookId': _is.ParameterDescription(
              name: 'notebookId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'artifactId': _is.ParameterDescription(
              name: 'artifactId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notebook'] as _igzx34cy.NotebookEndpoint)
                  .getStudioAudioAccess(
                    session,
                    params['notebookId'],
                    params['artifactId'],
                  ),
        ),
      },
    );
    connectors['notifications'] = _is.EndpointConnector(
      name: 'notifications',
      endpoint: endpoints['notifications']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'unreadOnly': _is.ParameterDescription(
              name: 'unreadOnly',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notifications']
                          as _ixfuytjp.NotificationsEndpoint)
                      .list(
                        session,
                        params['offset'],
                        params['limit'],
                        params['category'],
                        params['unreadOnly'],
                      ),
        ),
        'unreadCount': _is.MethodConnector(
          name: 'unreadCount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notifications']
                          as _ixfuytjp.NotificationsEndpoint)
                      .unreadCount(session),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notifications']
                          as _ixfuytjp.NotificationsEndpoint)
                      .get(
                        session,
                        params['id'],
                      ),
        ),
        'markRead': _is.MethodConnector(
          name: 'markRead',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notifications']
                          as _ixfuytjp.NotificationsEndpoint)
                      .markRead(
                        session,
                        params['id'],
                      ),
        ),
        'markAllRead': _is.MethodConnector(
          name: 'markAllRead',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notifications']
                          as _ixfuytjp.NotificationsEndpoint)
                      .markAllRead(session),
        ),
      },
    );
    connectors['pushDevices'] = _is.EndpointConnector(
      name: 'pushDevices',
      endpoint: endpoints['pushDevices']!,
      methodConnectors: {
        'register': _is.MethodConnector(
          name: 'register',
          params: {
            'installationId': _is.ParameterDescription(
              name: 'installationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'platform': _is.ParameterDescription(
              name: 'platform',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pushDevices'] as _ikun4key.PushDevicesEndpoint)
                      .register(
                        session,
                        params['installationId'],
                        params['platform'],
                        params['token'],
                      ),
        ),
        'unregister': _is.MethodConnector(
          name: 'unregister',
          params: {
            'registrationId': _is.ParameterDescription(
              name: 'registrationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pushDevices'] as _ikun4key.PushDevicesEndpoint)
                      .unregister(
                        session,
                        params['registrationId'],
                      ),
        ),
      },
    );
    connectors['search'] = _is.EndpointConnector(
      name: 'search',
      endpoint: endpoints['search']!,
      methodConnectors: {
        'search': _is.MethodConnector(
          name: 'search',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'kind': _is.ParameterDescription(
              name: 'kind',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['search'] as _ife56g8m.SearchEndpoint).search(
                    session,
                    params['query'],
                    courseId: params['courseId'],
                    kind: params['kind'],
                  ),
        ),
        'listRecent': _is.MethodConnector(
          name: 'listRecent',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['search'] as _ife56g8m.SearchEndpoint)
                  .listRecent(session),
        ),
        'saveRecent': _is.MethodConnector(
          name: 'saveRecent',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['search'] as _ife56g8m.SearchEndpoint).saveRecent(
                    session,
                    params['query'],
                  ),
        ),
        'deleteRecent': _is.MethodConnector(
          name: 'deleteRecent',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['search'] as _ife56g8m.SearchEndpoint)
                  .deleteRecent(
                    session,
                    params['id'],
                  ),
        ),
        'clearRecent': _is.MethodConnector(
          name: 'clearRecent',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['search'] as _ife56g8m.SearchEndpoint)
                  .clearRecent(session),
        ),
      },
    );
    connectors['studentLearning'] = _is.EndpointConnector(
      name: 'studentLearning',
      endpoint: endpoints['studentLearning']!,
      methodConnectors: {
        'listTasks': _is.MethodConnector(
          name: 'listTasks',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['studentLearning']
                          as _iksi4z8f.StudentLearningEndpoint)
                      .listTasks(session),
        ),
        'listGrades': _is.MethodConnector(
          name: 'listGrades',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['studentLearning']
                          as _iksi4z8f.StudentLearningEndpoint)
                      .listGrades(session),
        ),
      },
    );
    connectors['teaching'] = _is.EndpointConnector(
      name: 'teaching',
      endpoint: endpoints['teaching']!,
      methodConnectors: {
        'dashboard': _is.MethodConnector(
          name: 'dashboard',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .dashboard(session),
        ),
        'members': _is.MethodConnector(
          name: 'members',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint).members(
                    session,
                    params['courseId'],
                  ),
        ),
        'listActivities': _is.MethodConnector(
          name: 'listActivities',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .listActivities(
                    session,
                    params['courseId'],
                  ),
        ),
        'getActivity': _is.MethodConnector(
          name: 'getActivity',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .getActivity(
                    session,
                    params['courseId'],
                    params['activityId'],
                  ),
        ),
        'saveActivity': _is.MethodConnector(
          name: 'saveActivity',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i4fz2kgh.TeachingSaveInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .saveActivity(
                    session,
                    params['input'],
                  ),
        ),
        'getDefaults': _is.MethodConnector(
          name: 'getDefaults',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .getDefaults(session),
        ),
        'saveDefaults': _is.MethodConnector(
          name: 'saveDefaults',
          params: {
            'settings': _is.ParameterDescription(
              name: 'settings',
              type: _is.getType<_ile4zehq.TeachingSettings>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .saveDefaults(
                    session,
                    params['settings'],
                  ),
        ),
        'beginUpload': _is.MethodConnector(
          name: 'beginUpload',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'fileName': _is.ParameterDescription(
              name: 'fileName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'sizeBytes': _is.ParameterDescription(
              name: 'sizeBytes',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .beginUpload(
                    session,
                    params['courseId'],
                    params['activityId'],
                    params['fileName'],
                    params['sizeBytes'],
                  ),
        ),
        'submitAssignment': _is.MethodConnector(
          name: 'submitAssignment',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'uploadId': _is.ParameterDescription(
              name: 'uploadId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'requestKey': _is.ParameterDescription(
              name: 'requestKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .submitAssignment(
                    session,
                    params['courseId'],
                    params['activityId'],
                    params['text'],
                    params['uploadId'],
                    params['requestKey'],
                  ),
        ),
        'gradeAssignment': _is.MethodConnector(
          name: 'gradeAssignment',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'submissionId': _is.ParameterDescription(
              name: 'submissionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'points': _is.ParameterDescription(
              name: 'points',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'feedback': _is.ParameterDescription(
              name: 'feedback',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'publish': _is.ParameterDescription(
              name: 'publish',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .gradeAssignment(
                    session,
                    params['courseId'],
                    params['activityId'],
                    params['submissionId'],
                    params['points'],
                    params['feedback'],
                    params['publish'],
                  ),
        ),
        'reopenAssignment': _is.MethodConnector(
          name: 'reopenAssignment',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'ownerId': _is.ParameterDescription(
              name: 'ownerId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'deadline': _is.ParameterDescription(
              name: 'deadline',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .reopenAssignment(
                    session,
                    params['courseId'],
                    params['activityId'],
                    params['ownerId'],
                    params['deadline'],
                  ),
        ),
        'submissionFile': _is.MethodConnector(
          name: 'submissionFile',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'submissionId': _is.ParameterDescription(
              name: 'submissionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .submissionFile(
                    session,
                    params['courseId'],
                    params['activityId'],
                    params['submissionId'],
                  ),
        ),
        'startTest': _is.MethodConnector(
          name: 'startTest',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .startTest(
                    session,
                    params['courseId'],
                    params['activityId'],
                  ),
        ),
        'saveAnswers': _is.MethodConnector(
          name: 'saveAnswers',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'attemptId': _is.ParameterDescription(
              name: 'attemptId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'answers': _is.ParameterDescription(
              name: 'answers',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
            'finish': _is.ParameterDescription(
              name: 'finish',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .saveAnswers(
                    session,
                    params['courseId'],
                    params['activityId'],
                    params['attemptId'],
                    params['answers'],
                    params['finish'],
                  ),
        ),
        'releaseTest': _is.MethodConnector(
          name: 'releaseTest',
          params: {
            'courseId': _is.ParameterDescription(
              name: 'courseId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'activityId': _is.ParameterDescription(
              name: 'activityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['teaching'] as _ikzi1wna.TeachingEndpoint)
                  .releaseTest(
                    session,
                    params['courseId'],
                    params['activityId'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _ia6dpipn.FutureCalls();
  }
}
