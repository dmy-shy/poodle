# In-app links implementation

Approved scope: [SPEC-in-app-links.md](../../specs/SPEC-in-app-links.md), implementation
requested 2026-10-23. Existing course-view plan and task history are preserved.

Dependency order: URL policy and fresh activity recheck → browser state and
native widget → guarded routes and bilingual UI → tests and native builds.

- [x] Validate HTTPS destinations and return a fresh, authorized link from the
  course ViewModel. Reject revoked, changed, malformed, and canceled activity
  reads. Verify with focused unit tests; retain PDF/DOCX behavior.
- [x] Add browser controller boundary, ChangeNotifier state, and the
  flutter_inappwebview widget. Verify history, load failure/retry, subresource
  handling, and disposal with a fake controller. Block popups/downloads and
  preserve TLS validation.
- [x] Integrate both course route families with memory-only payloads and
  account invalidation. Add English/Ukrainian controls and loading/error UI.
  Verify routing, return to activity, auth, and large text with widget tests.
- [ ] Run analysis, formatting, regression tests, Android/iOS native builds,
  and available MCP restart/runtime checks. Record measured outcomes and
  outstanding device checks in in-app-links-results.md.

Automated checks and native builds are complete. Native interaction acceptance
and Serverpod log review remain pending; see [results](in-app-links-results.md).

Native risk: stable plugin 6.1.5 may need build-system adaptation for the current
Flutter/AGP/iOS package setup. Build it early; change application configuration
only if a concrete build failure requires it. No database migration is needed.
The Serverpod MCP tools are not exposed in this session; do not substitute a
CLI server launch. Runtime acceptance must be reported accurately.
