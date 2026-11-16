import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

import 'src/auth/google_identity.dart';
import 'src/auth/identity_auth_config.dart';
import 'src/auth/transactional_email.dart';
import 'src/generated/serverpod.dart';
import 'src/modules/identity/development_academic_seed.dart';
import 'src/modules/identity/platform_operator_bootstrap.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);
  final googleCredential = pod.getPassword('googleClientSecret')?.trim();
  TransactionalEmail.configure(
    resendApiKey: pod.getPassword('resendApiKey'),
    from: pod.getPassword('transactionalEmailFrom'),
    actionOrigin: pod.getPassword('accountActionOrigin'),
  );

  pod.initializeAuthServices(
    tokenManagerBuilders: [JwtConfigFromPasswords(issuer: 'poodle')],
    identityProviderBuilders: [
      identityEmailConfig(
        pepper:
            pod.getPassword('emailSecretHashPepper') ??
            (throw StateError('Missing emailSecretHashPepper password.')),
        runMode: pod.runMode,
      ),
      if (googleCredential != null && googleCredential.isNotEmpty)
        GoogleIdpConfig(
          clientSecret: GoogleClientSecret.fromJsonString(googleCredential),
          googleAccountDetailsValidation: validateGoogleIdentity,
        ),
    ],
  );

  // Configure cloud storage.
  // This setup works with Serverpod Cloud without extra configuration.
  // If you want to use a custom provider for cloud storage, replace these
  // with your preferred provider.
  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  // Start the server.
  await pod.start();
  await DevelopmentAcademicSeed.fromLocalConfig(pod);
  await PlatformOperatorBootstrap.fromConfig(pod);
  await pod.futureCalls.cancel('institution-mail');
  await pod.futureCalls
      .callRecurring(identifier: 'institution-mail')
      .every(const Duration(minutes: 1))
      .institutionMail
      .deliver();
}
