import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../view_models/login_view_model.dart';

extension AuthMessages on AppLocalizations {
  String? emailError(EmailIssue? issue) => switch (issue) {
    EmailIssue.required => emailRequired,
    EmailIssue.invalid => emailInvalid,
    null => null,
  };
  String failureMessage(AuthFailure failure) => switch (failure) {
    AuthFailure.invalidCredentials => invalidCredentials,
    AuthFailure.network => networkError,
    AuthFailure.googleProofInvalid => googleProofInvalid,
    AuthFailure.googleLinkRequired => googleLinkRequired,
    AuthFailure.googleEmailMismatch => googleEmailMismatch,
    AuthFailure.googleLinkConflict => googleLinkConflict,
    AuthFailure.invitationUnavailable => invitationUnavailable,
    AuthFailure.emailUnavailable ||
    AuthFailure.emailChangeExpired ||
    AuthFailure.emailChangeThrottled ||
    AuthFailure.passwordUnavailable => authUnavailable,

    AuthFailure.storage => authStorageError,
    AuthFailure.forbidden => authAccessDenied,
    AuthFailure.invalidCode => authInvalidCode,
    AuthFailure.passwordPolicy => authPasswordPolicy,
    AuthFailure.unavailable || AuthFailure.cancelled => authUnavailable,
  };
}
