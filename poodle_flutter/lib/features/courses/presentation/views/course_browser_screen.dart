import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/course_repository.dart';
import '../../../../data/services/course_link_policy.dart';
import '../view_models/course_browser_view_model.dart';
import '../widgets/course_web_view.dart';

/// A short-lived route payload; URLs are never encoded into router locations.
class CourseBrowserRequest {
  const CourseBrowserRequest({
    required this.uri,
    required this.title,
    required this.courseId,
    required this.activityId,
    required this.generation,
  });
  final Uri uri;
  final String title, courseId, activityId;
  final int generation;
}

class CourseBrowserScreen extends StatefulWidget {
  const CourseBrowserScreen({
    super.key,
    required this.repository,
    required this.courseId,
    required this.activityId,
    required this.activityPath,
    this.request,
    this.webViewBuilder,
  });
  final CourseRepository repository;
  final String courseId, activityId, activityPath;
  final CourseBrowserRequest? request;
  final CourseWebViewBuilder? webViewBuilder;

  @override
  State<CourseBrowserScreen> createState() => _CourseBrowserScreenState();
}

class _CourseBrowserScreenState extends State<CourseBrowserScreen> {
  CourseBrowserViewModel? _model;
  Widget? _webView;
  bool _invalidated = false;

  @override
  void initState() {
    super.initState();
    widget.repository.addListener(_accountChanged);
    final request = widget.request;
    if (request == null ||
        request.generation != widget.repository.generation ||
        request.courseId != widget.courseId ||
        request.activityId != widget.activityId ||
        !validCourseId(widget.courseId) ||
        !validCourseId(widget.activityId) ||
        courseLinkUri(request.uri.toString()) == null) {
      return;
    }
    final model = CourseBrowserViewModel(
      initialUri: request.uri,
      title: request.title,
    );
    _model = model;
    _webView =
        widget.webViewBuilder?.call(model) ?? CourseWebView(model: model);
  }

  void _accountChanged() {
    if (widget.request?.generation == widget.repository.generation) return;
    _model?.invalidate();
    setState(() {
      _invalidated = true;
      _webView = null;
    });
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(widget.activityPath);
    }
  }

  Future<void> _back() async {
    if (await _model?.goBack() == true || !mounted) return;
    _close();
  }

  @override
  void dispose() {
    widget.repository.removeListener(_accountChanged);
    _model?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final model = _model;
    if (model == null || _invalidated) {
      return Scaffold(
        primary: false,
        appBar: AppBar(
          primary: false,
          title: Text(text.courseLink),
          leading: BackButton(onPressed: _close),
        ),
        body: Center(child: Text(text.courseUnavailable)),
      );
    }
    return AnimatedBuilder(
      animation: model,
      child: _webView,
      builder: (context, webView) => PopScope(
        canPop: !model.canGoBack,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _back();
        },
        child: Scaffold(
          // The signed-in shell already handles the status-bar safe area.
          primary: false,
          appBar: AppBar(
            primary: false,
            toolbarHeight: 48 * MediaQuery.textScalerOf(context).scale(14) / 14,
            titleSpacing: 0,
            leading: BackButton(onPressed: _back),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  model.currentUri.host,
                  style: Theme.of(context).textTheme.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: text.browserReload,
                onPressed: model.reload,
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                tooltip: text.browserClose,
                onPressed: _close,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (model.loading)
                    LinearProgressIndicator(
                      value: model.progress > 0 ? model.progress / 100 : null,
                      semanticsLabel: text.browserLoading,
                    ),
                  if (model.notice != null)
                    Container(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      padding: const EdgeInsetsDirectional.only(start: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight * 0.4,
                              ),
                              child: SingleChildScrollView(
                                child: Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    model.notice == CourseBrowserNotice.blocked
                                        ? text.browserBlocked
                                        : text.browserUnsupported,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: text.browserDismiss,
                            onPressed: model.dismissNotice,
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Offstage(offstage: model.failed, child: webView),
                        if (model.failed)
                          Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Semantics(
                                    liveRegion: true,
                                    child: Text(text.browserLoadError),
                                  ),
                                  const SizedBox(height: 16),
                                  FilledButton(
                                    onPressed: model.reload,
                                    child: Text(text.authRetry),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
