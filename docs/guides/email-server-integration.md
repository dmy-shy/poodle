POODLE — SERVER INTEGRATION (2026-11-15)

Flutter requests a verification code from Serverpod; only Serverpod calls Resend.
The existing server passwords resendApiKey and transactionalEmailFrom are reused.
Keep these credentials in Serverpod configuration. No credentials belong in Flutter.
No database migration is required.

Published template routing
  registration -> poodle-registration-en / poodle-registration-uk
  reset        -> poodle-password-reset-en / poodle-password-reset-uk
  email        -> poodle-email-change-en / poodle-email-change-uk
  administratorRequest -> poodle-administrator-request-en / poodle-administrator-request-uk

Registration/reset accept an optional locale; omission and unsupported languages
fall back to English. Flutter forwards the primary system language, matching the
app language policy. Request-local zones keep concurrent SDK callbacks isolated.
Email change uses the locale stored on its pending request.

Resend receives from, to, and template {id, variables}; the template owns its
subject and content. Runtime variables are CODE and EXPIRES_AT_UTC (strings).
The hosted logo is embedded in the published templates. Registration EN retains
an unused LOGO_URL variable with a hosted fallback; callers need not supply it.

SDK registration/reset use the existing secure numeric eight-digit generator.
The SDK still handles verification, hashing, rate limits and proof completion.
Expiry derives from SDK request.createdAt plus the same configured 15-minute
lifetime used by the verifier. Email-change resends retain their stored expiry.

Template delivery has a 10-second timeout. Rejections propagate to the caller;
response bodies and credentials are not included in errors. Request+payload HMAC
keys keep retries idempotent and rotate with a new code without exposing the code
in the key. Failed email-change delivery rolls back the pending code update.
Administrator requests pass their stored request ID, locale and verification
deadline to the template sender. Institution messages retain plain-text delivery.

Verification
  60 passing server tests: all unit tests, auth_email_templates, identity_jwt,
  administrator_requests and platform_operator_bootstrap integration suites.
  37 passing Flutter tests: serverpod_auth_gateway, live_auth_repository and
  live_auth_flow suites. Changed source analysis passed; Dart formatting applied.
  Serverpod watcher regenerated clients/endpoints; generated files were not edited.
  MCP hot restart completed; server compiled and restarted successfully.
  Runtime reported an ext.relic.notifyStaticChange browser-refresh warning.

Remaining acceptance
  A controlled real inbox check for English and Ukrainian registration, reset and
  email change and administrator requests, including resend behavior and
  Gmail/Outlook rendering.
  Automated integration tests intercept Resend HTTP; they do not send real mail.

Resend contract reference
  https://resend.com/docs/api-reference/emails/send-email
