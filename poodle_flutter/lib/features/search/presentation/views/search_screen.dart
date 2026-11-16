import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poodle_client/poodle_client.dart';
import 'package:provider/provider.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../view_models/search_view_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.pushed = false, this.preview = false});
  final bool pushed;
  final bool preview;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  String? _account;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _open(SearchHit hit) {
    final base = '/search-result/${hit.courseId}';
    final location = hit.activityId != null
        ? '$base/activity/${hit.activityId}'
        : hit.sectionId != null
        ? '$base?section=${hit.sectionId}'
        : base;
    context.push(location);
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SearchViewModel>();
    final auth = context.watch<AuthRepository>();
    final account = auth.session?.userId ?? auth.session?.email;
    if (_account != account) {
      _account = account;
      _input.clear();
    }
    final l = AppLocalizations.of(context);
    final result = model.response;
    final showEmptyRecent =
        model.submitted == null &&
        !model.historyBusy &&
        !model.historyFailed &&
        model.recent.isEmpty;
    final courses = model.courses;
    final kinds = <String?, String>{
      null: l.searchAllKinds,
      'course': l.coursesTab,
      'section': l.courseSections,
      'activity': l.searchActivities,
    };
    final drawer = Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l.searchCourseFilter,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (courses.isNotEmpty)
              DropdownButtonFormField<String>(
                key: ValueKey(
                  'search-course-filter:$account:${model.courseId}',
                ),
                initialValue: model.courseId ?? '',
                isExpanded: true,
                items: [
                  DropdownMenuItem(value: '', child: Text(l.searchAllCourses)),
                  for (final course in courses)
                    DropdownMenuItem(
                      value: course.id,
                      child: Text(
                        course.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (id) => model.filter(
                  course: id == '' ? null : id,
                  type: model.kind,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              l.searchTypeFilter,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            for (final entry in kinds.entries)
              ListTile(
                title: Text(entry.value),
                leading: Icon(
                  model.kind == entry.key
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                onTap: () =>
                    model.filter(course: model.courseId, type: entry.key),
              ),
          ],
        ),
      ),
    );
    void submit(String query) {
      FocusScope.of(context).unfocus();
      if (_scroll.hasClients) _scroll.jumpTo(0);
      model.submit(query);
    }

    return Scaffold(
      drawer: drawer,
      appBar: widget.pushed
          ? AppBar(
              leading: BackButton(onPressed: () => context.pop()),
              title: Text(l.searchTab),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: CustomScrollView(
              controller: _scroll,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  sliver: SliverList.list(
                    children: [
                      Row(
                        children: [
                          Builder(
                            builder: (context) => IconButton(
                              tooltip: l.searchFilters,
                              icon: const Icon(Icons.tune),
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _input,
                              textInputAction: TextInputAction.search,
                              onSubmitted: submit,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: l.searchQueryLabel,
                                errorText: model.invalid
                                    ? l.searchQueryInvalid
                                    : null,
                                suffixIcon:
                                    ValueListenableBuilder<TextEditingValue>(
                                      valueListenable: _input,
                                      builder: (_, value, _) => Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (value.text.isNotEmpty)
                                            IconButton(
                                              tooltip: l.searchClearQuery,
                                              onPressed: () {
                                                _input.clear();
                                                model.clearQuery();
                                              },
                                              icon: const Icon(Icons.clear),
                                            ),
                                          IconButton(
                                            tooltip: l.searchTab,
                                            onPressed: () =>
                                                submit(_input.text),
                                            icon: const Icon(Icons.search),
                                          ),
                                        ],
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (model.busy)
                        Semantics(
                          liveRegion: true,
                          child: LinearProgressIndicator(
                            semanticsLabel: l.searchLoading,
                          ),
                        ),
                      if (model.failure != null) ...[
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            model.failure == AuthFailure.network
                                ? l.searchOffline
                                : l.searchFailed,
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton(
                            onPressed: model.retry,
                            child: Text(l.authRetry),
                          ),
                        ),
                      ],
                      if (model.submitted == null) ...[
                        if (model.recent.isNotEmpty)
                          Semantics(
                            header: true,
                            child: Text(
                              l.searchRecent,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        if (model.historyBusy) const LinearProgressIndicator(),
                        for (final item in model.recent)
                          ListTile(
                            title: Text(item.query),
                            leading: const ExcludeSemantics(
                              child: Icon(Icons.history),
                            ),
                            onTap: () {
                              _input.text = item.query;
                              submit(item.query);
                            },
                            trailing: IconButton(
                              tooltip: l.searchRemoveRecent(item.query),
                              onPressed: model.historyBusy
                                  ? null
                                  : () => model.deleteRecent(item.id),
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        if (model.recent.isNotEmpty)
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: TextButton(
                              onPressed: model.historyBusy
                                  ? null
                                  : model.clearRecent,
                              child: Text(l.searchClearRecent),
                            ),
                          ),
                      ],
                      if (model.historyFailed) ...[
                        Semantics(
                          liveRegion: true,
                          child: Text(l.searchHistoryFailed),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton(
                            onPressed: model.reloadHistory,
                            child: Text(l.authRetry),
                          ),
                        ),
                      ],
                      if (result != null && !model.busy) ...[
                        if (result.results.isEmpty)
                          Center(
                            child: Column(
                              children: [
                                const Icon(Icons.search_off, size: 96),
                                Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    l.searchNoMatches,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                ),
                                Text(
                                  l.searchNoMatchesHint,
                                  textAlign: TextAlign.center,
                                ),
                                TextButton(
                                  onPressed: () {
                                    _input.clear();
                                    model.clearQuery();
                                  },
                                  child: Text(l.searchClearSearch),
                                ),
                              ],
                            ),
                          ),
                        if (result.results.isNotEmpty)
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              l.searchResultCount(result.results.length),
                            ),
                          ),
                        if (result.keywordOnly) Text(l.searchKeywordOnly),
                        if (result.incomplete) Text(l.searchIncomplete),
                        if (result.capped) Text(l.searchCapped),
                        for (final hit in result.results)
                          MergeSemantics(
                            child: Card(
                              child: ListTile(
                                title: Text(hit.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      [
                                        kinds[hit.kind] ?? l.searchActivities,
                                        if (hit.breadcrumb.isNotEmpty)
                                          hit.breadcrumb,
                                        if (hit.draft) l.courseDraft,
                                        if (hit.page != null)
                                          l.searchPage(hit.page!),
                                        if (hit.page == null &&
                                            hit.location != null)
                                          l.searchFileExcerpt,
                                      ].join(' • '),
                                    ),
                                    if (hit.excerpt.isNotEmpty)
                                      Text(hit.excerpt),
                                  ],
                                ),
                                trailing: const ExcludeSemantics(
                                  child: Icon(Icons.chevron_right),
                                ),
                                onTap: () => _open(hit),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
                if (showEmptyRecent)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history,
                              size: 72,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(l.searchNoRecent, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
