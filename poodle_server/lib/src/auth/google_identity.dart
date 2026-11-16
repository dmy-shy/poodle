import 'package:serverpod_auth_idp_server/providers/google.dart';
import '../modules/identity/identity_policy.dart';

void validateGoogleIdentity(GoogleAccountDetails details) {
  if (details.verifiedEmail != true || details.userIdentifier.isEmpty) {
    throw GoogleUserInfoMissingDataException();
  }
  IdentityPolicy.normalizeEmail(details.email);
}
