POODLE EMAIL TEMPLATES — PUBLISHED IN RESEND

Status: all six templates published in Resend on 2026-11-15.
Sender, subjects, concise previews, aliases and hosted logo configured.
IDs and hosted logo URL are recorded in manifest.json.
Server integration is implemented. Controlled inbox acceptance remains pending.
No real emails were sent during integration.
Resend imports normalize HTML; body alignment was centered in the dashboard.

Contents
  templates/: six approved source HTML files and plain-text alternatives.
  resend/: upload variants with the hosted HTTPS logo embedded.
  manifest.json: subjects, preview text, stable aliases and variable definitions.
  preview/: rendered HTML containing fictitious sample values, never upload these.
  ../output/playwright/email-templates/: mobile and desktop screenshots.

Validation: python3 email_templates/tools/verify.py
Local preview: python3 -m http.server 8766 --bind 127.0.0.1
Open /email_templates/preview/poodle-password-reset-en.html

Approval checklist
  Brand/layout; readable English and Ukrainian; prominent selectable code;
  accurate purpose and expiry; exact app action labels; clear recovery and safety.

AFTER explicit approval only
  Import each templates/*.html into Resend, set subject/preview from manifest,
  declare CODE and EXPIRES_AT_UTC as string variables with no fallback code.
  Use the listed aliases. Configure the verified sender in the server/Resend.
  Review plain-text rendering against the supplied .txt alternatives.
  Publish after dashboard review and controlled inbox acceptance.
  Never upload preview/*.html: the sample code is only for screenshot review.

Integration contract (implemented)
  CODE: server-generated eight-digit string; preserve leading zeros.
  EXPIRES_AT_UTC: actual expiry formatted YYYY-MM-DD HH:mm, not a fresh 15-minute
  countdown on resend. Displayed with explicit UTC label in both languages.
  Serverpod sends from/to/template only; no inline html/text with template.
  Local browser previews do not certify Gmail/Outlook inbox compatibility.
  Material design/copy changes require refreshed screenshots and reapproval.

LOGO UPDATE
Main logo copied unchanged from poodle_flutter/assets/icons/android-mobile-icon.png.
The published templates embed the Resend-hosted logo URL.
LOGO_URL remains a source-template placeholder for portability.
Registration EN additionally retains an unused LOGO_URL variable with hosted fallback.
At send time provide CODE and EXPIRES_AT_UTC as strings.
