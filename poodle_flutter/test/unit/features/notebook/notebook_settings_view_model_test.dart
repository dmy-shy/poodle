import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/data/repositories/notebook_repository.dart';
import 'package:poodle_flutter/features/notebook/presentation/view_models/notebook_settings_view_model.dart';
import '../../../support/fake_notebook_repository.dart';

void main() {
  late FakeNotebookRepository repository;
  late NotebookSettingsViewModel model;
  setUp(() {
    repository = FakeNotebookRepository()..bindAccount('teacher');
    model = NotebookSettingsViewModel(repository, 'course', 'assessment');
  });
  tearDown(() {
    model.dispose();
    repository.dispose();
  });
  test(
    'loads settings and saves changed choices with the confirmed revision',
    () async {
      await model.load();
      expect(model.canSave, false);
      model.material('other', true);
      model.format('pdf', true);
      expect(model.canSave, true);
      await model.save();
      expect(repository.revisions, [1]);
      expect(model.setup!.revision, 2);
      expect(model.materials, {'source', 'other'});
      expect(model.formats, {'txt', 'pdf'});
      expect(model.saved, true);
      expect(model.canSave, false);
    },
  );
  test(
    'requires supported choices and explicit removal of unavailable defaults',
    () async {
      repository.settings = StudyNotebookSetup(
        1,
        ['withdrawn'],
        ['txt'],
        repository.settings.materials,
      );
      await model.load();
      model.material('other', true);
      expect(model.canSave, false);
      model.material('withdrawn', false);
      expect(model.canSave, true);
      model.format('txt', false);
      model.format('exe', true);
      expect(model.formats, isEmpty);
      expect(model.canSave, true);
      model.material('forged', true);
      expect(model.materials, {'other'});
      await model.save();
      expect(repository.settings.formats, isEmpty);
      model.material('other', false);
      expect(model.canSave, false);
    },
  );
  test(
    'conflict or ambiguous failure requires reload, never retries an old revision',
    () async {
      for (final failure in [
        NotebookFailure.changed,
        NotebookFailure.network,
      ]) {
        await model.load();
        model.format('pdf', true);
        repository.failure = failure;
        await model.save();
        expect(model.needsReload, true);
        expect(model.error, failure);
        final count = repository.revisions.length;
        await model.save();
        expect(repository.revisions, hasLength(count));
        repository.failure = null;
        await model.load();
        expect(model.needsReload, false);
      }
    },
  );
  test('account change clears choices and fences a delayed read', () async {
    repository.settingsHold = Completer<StudyNotebookSetup>();
    final loading = model.load();
    repository.bindAccount('student');
    repository.settingsHold!.complete(repository.settings);
    await loading;
    expect(model.setup, isNull);
    expect(model.materials, isEmpty);
    expect(model.formats, isEmpty);
    expect(model.busy, false);
  });
  test(
    'account change during save cannot reload into the next account',
    () async {
      await model.load();
      model.format('pdf', true);
      repository.configureHold = Completer<void>();
      final saving = model.save();
      repository.bindAccount('other');
      repository.configureHold!.complete();
      await saving;
      expect(model.setup, isNull);
      expect(model.saved, false);
    },
  );
}
