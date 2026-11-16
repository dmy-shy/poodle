import 'package:poodle_server/src/auth/google_identity.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Google account validation requires verified email but not a profile',
    () {
      expect(
        () => validateGoogleIdentity((
          userIdentifier: 'subject',
          email: 'a@example.test',
          name: null,
          fullName: null,
          image: null,
          verifiedEmail: true,
        )),
        returnsNormally,
      );
      expect(
        () => validateGoogleIdentity((
          userIdentifier: 'subject',
          email: 'a@example.test',
          name: null,
          fullName: null,
          image: null,
          verifiedEmail: false,
        )),
        throwsA(isA<Exception>()),
      );
    },
  );
}
