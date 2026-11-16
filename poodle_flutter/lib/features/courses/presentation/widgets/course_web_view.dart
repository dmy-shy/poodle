import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../../data/services/course_browser_controller.dart';
import '../view_models/course_browser_view_model.dart';

typedef CourseWebViewBuilder = Widget Function(CourseBrowserViewModel model);

/// The native boundary. No app credentials, headers or JS handlers are supplied.
class CourseWebView extends StatelessWidget {
  const CourseWebView({super.key, required this.model});
  final CourseBrowserViewModel model;

  @override
  Widget build(BuildContext context) {
    // Plugin debug events include full URLs; keep those out of app logs too.
    PlatformInAppWebViewController.debugLoggingSettings.enabled = false;
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(model.initialUri.toString())),
      initialSettings: InAppWebViewSettings(
        useShouldOverrideUrlLoading: true,
        useOnDownloadStart: true,
        useOnNavigationResponse: true,
        supportMultipleWindows: true,
        javaScriptCanOpenWindowsAutomatically: false,
        allowFileAccess: false,
        allowContentAccess: false,
        allowFileAccessFromFileURLs: false,
        allowUniversalAccessFromFileURLs: false,
        sharedCookiesEnabled: false,
        thirdPartyCookiesEnabled: false,
        mixedContentMode: MixedContentMode.MIXED_CONTENT_NEVER_ALLOW,
        // Flutter handles route back-swipe; page history uses the toolbar/Back.
        allowsBackForwardNavigationGestures: false,
        isInspectable: false,
      ),
      onWebViewCreated: (controller) =>
          model.attach(_NativeBrowserController(controller)),
      shouldOverrideUrlLoading: (_, action) async =>
          model.navigationAllowed(
            action.request.url?.toString(),
            isMainFrame: action.isForMainFrame,
          )
          ? NavigationActionPolicy.ALLOW
          : NavigationActionPolicy.CANCEL,
      onLoadStart: (controller, url) {
        // Also covers native navigations not reported by the policy callback.
        if (!model.loadStarted(url?.toString())) {
          unawaited(controller.stopLoading().catchError((_) {}));
        }
      },
      onLoadStop: (_, url) => model.loadFinished(url?.toString()),
      onUpdateVisitedHistory: (_, url, _) => model.pageChanged(url?.toString()),
      onTitleChanged: (_, title) => model.titleChanged(title),
      onProgressChanged: (_, progress) => model.progressChanged(progress),
      onReceivedError: (_, request, error) {
        if (error.type == WebResourceErrorType.CANCELLED) return;
        model.loadFailed(
          request.url.toString(),
          isMainFrame: request.isForMainFrame != false,
        );
      },
      onReceivedHttpError: (_, request, _) => model.loadFailed(
        request.url.toString(),
        isMainFrame: request.isForMainFrame != false,
      ),
      // No trust callback: the OS validates certificates using its default policy.
      onCreateWindow: (_, _) async {
        model.unsupported();
        return false;
      },
      onDownloadStartRequest: (controller, _) {
        unawaited(controller.stopLoading().catchError((_) {}));
        model.unsupported();
      },
      onNavigationResponse: (_, response) async {
        if (response.isForMainFrame) {
          if (!model.navigationAllowed(response.response?.url?.toString())) {
            return NavigationResponseAction.CANCEL;
          }
          final attachment =
              response.response?.headers?.entries.any(
                (entry) =>
                    entry.key.toLowerCase() == 'content-disposition' &&
                    entry.value.toLowerCase().startsWith('attachment'),
              ) ??
              false;
          if (!response.canShowMIMEType || attachment) {
            model.unsupported();
            return NavigationResponseAction.CANCEL;
          }
        }
        return NavigationResponseAction.ALLOW;
      },
      onPermissionRequest: (_, request) async => PermissionResponse(
        resources: request.resources,
        action: PermissionResponseAction.DENY,
      ),
      onGeolocationPermissionsShowPrompt: (_, origin) async =>
          GeolocationPermissionShowPromptResponse(
            origin: origin,
            allow: false,
            retain: false,
          ),
      onWebContentProcessDidTerminate: (_) =>
          model.loadFailed(model.currentUri.toString()),
      onRenderProcessGone: (_, _) =>
          model.loadFailed(model.currentUri.toString()),
    );
  }
}

class _NativeBrowserController implements CourseBrowserController {
  _NativeBrowserController(this.controller);
  final InAppWebViewController controller;
  @override
  Future<bool> canGoBack() => controller.canGoBack();
  @override
  Future<void> goBack() => controller.goBack();
  @override
  Future<void> reload() => controller.reload();
}
