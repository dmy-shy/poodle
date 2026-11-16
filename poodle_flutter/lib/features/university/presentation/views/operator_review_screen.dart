import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../data/repositories/institution_repository.dart';
import '../view_models/operator_review_view_model.dart';
import '../widgets/institution_widgets.dart';

class OperatorReviewScreen extends StatelessWidget {
  const OperatorReviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final model = context.watch<OperatorReviewViewModel>();
    final text = AppLocalizations.of(context);
    return InstitutionPage(
      title: text.institutionOperator,
      children: [
        Text(text.institutionReviewIntro),
        if (model.busy) const LinearProgressIndicator(),
        if (model.error case final code?) InstitutionError(code: code),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: model.busy ? null : model.load,
            icon: const Icon(Icons.refresh),
            label: Text(text.institutionRefresh),
          ),
        ),
        if (model.focusUnavailable) Text(text.institutionRequestUnavailable),
        if (!model.busy && model.requests.isEmpty) Text(text.institutionEmpty),
        for (final request in model.requests)
          _RequestCard(key: ValueKey(request.id), request: request),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: model.busy || model.offset == 0
                    ? null
                    : () => model.page(-1),
                child: Text(text.authPreviousPage),
              ),
              TextButton(
                onPressed: model.busy || model.requests.length < 20
                    ? null
                    : () => model.page(1),
                child: Text(text.authNextPage),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RequestCard extends StatefulWidget {
  const _RequestCard({super.key, required this.request});
  final AdministratorRequest request;
  @override
  State<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<_RequestCard> {
  late final _name = TextEditingController(text: widget.request.university);
  final _slug = TextEditingController(), _note = TextEditingController();
  String? _university;
  bool _noteMissing = false;
  @override
  void dispose() {
    _name.dispose();
    _slug.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<OperatorReviewViewModel>();
    final text = AppLocalizations.of(context);
    final r = widget.request;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              text.institutionApplicant,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(r.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            SelectableText(r.email),
            const SizedBox(height: 12),
            Text('${text.institutionUniversity}: ${r.university}'),
            const SizedBox(height: 8),
            Text('${text.institutionPosition}: ${r.position}'),
            if (r.note.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(r.note),
            ],
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(switch (r.status) {
                  'pending' => text.institutionPending,
                  'approved' => text.institutionApproved,
                  'rejected' => text.institutionRejected,
                  _ => r.status,
                }),
              ),
            ),
            if (r.reviewNote case final note?) ...[
              const SizedBox(height: 12),
              Text(note),
            ],
            if (r.status == 'pending') ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                text.institutionReviewDecision,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _university ?? '',
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: text.institutionUniversityAssignment,
                ),
                items: [
                  DropdownMenuItem(
                    value: '',
                    child: Text(
                      text.institutionNewUniversity,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  for (final u in model.universities)
                    DropdownMenuItem(
                      value: u.id,
                      child: Text(u.name, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: model.busy
                    ? null
                    : (value) => setState(
                        () => _university = value == '' ? null : value,
                      ),
              ),
              if (_university == null) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _name,
                  enabled: !model.busy,
                  decoration: InputDecoration(
                    labelText: text.institutionUniversity,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _slug,
                  enabled: !model.busy,
                  decoration: InputDecoration(
                    labelText: text.institutionSlug,
                    hintText: 'volyn-university',
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TextField(
                key: ValueKey('review-note-${r.id}'),
                controller: _note,
                enabled: !model.busy,
                maxLines: 3,
                maxLength: 2000,
                decoration: InputDecoration(
                  labelText: text.institutionReviewNote,
                  helperText: text.institutionReviewNoteRequired,
                  errorText: _noteMissing
                      ? text.institutionReviewNoteRequired
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: model.busy
                        ? null
                        : () {
                            if (_note.text.trim().isEmpty) {
                              setState(() => _noteMissing = true);
                              return;
                            }
                            setState(() => _noteMissing = false);
                            model.approve(
                              r,
                              universityId: _university,
                              name: _name.text,
                              slug: _university == null
                                  ? _slug.text
                                  : 'existing-university',
                              note: _note.text,
                            );
                          },
                    child: Text(text.institutionApprove),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: model.busy
                        ? null
                        : () {
                            if (_note.text.trim().isEmpty) {
                              setState(() => _noteMissing = true);
                              return;
                            }
                            setState(() => _noteMissing = false);
                            model.reject(r.id, _note.text);
                          },
                    child: Text(text.institutionReject),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
