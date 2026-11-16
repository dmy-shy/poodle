import 'package:poodle_server/src/modules/notebook/notebook_policy.dart';
import 'package:test/test.dart';

void main() {
  group('NotebookPolicy', () {
    test('accepts only published file materials in the same course', () {
      expect(
        NotebookPolicy.validDefaultMaterials(
          targetCourseId: 'course-a',
          materials: const [
            NotebookMaterialPolicyInput(
              id: 'file-1',
              courseId: 'course-a',
              published: true,
              isFile: true,
            ),
          ],
        ),
        isTrue,
      );
      expect(
        NotebookPolicy.validDefaultMaterials(
          targetCourseId: 'course-a',
          materials: const [
            NotebookMaterialPolicyInput(
              id: 'file-1',
              courseId: 'course-b',
              published: true,
              isFile: true,
            ),
          ],
        ),
        isFalse,
      );
      expect(
        NotebookPolicy.validDefaultMaterials(
          targetCourseId: 'course-a',
          materials: const [
            NotebookMaterialPolicyInput(
              id: 'draft',
              courseId: 'course-a',
              published: false,
              isFile: true,
            ),
          ],
        ),
        isFalse,
      );
    });

    test('normalizes and validates the supported upload formats', () {
      expect(NotebookPolicy.normalizeFormats([]), isEmpty);
      expect(
        NotebookPolicy.normalizeFormats([' PDF ', 'txt', 'md', 'docx']),
        ['docx', 'md', 'pdf', 'txt'],
      );
      expect(
        () => NotebookPolicy.normalizeFormats(['pdf', 'exe']),
        throwsArgumentError,
      );
    });

    test('reserves spend within the configured monthly ceiling', () {
      expect(
        NotebookPolicy.canReserveMicros(
          spentMicros: 9_990_000,
          reservedMicros: 0,
          requestMicros: 20_000,
          configuredCapMicros: 10_000_000,
        ),
        isFalse,
      );
      expect(
        NotebookPolicy.canReserveMicros(
          spentMicros: 9_000_000,
          reservedMicros: 500_000,
          requestMicros: 500_000,
          configuredCapMicros: 10_000_000,
        ),
        isTrue,
      );
      expect(
        NotebookPolicy.validConfiguredCapMicros(30_000_000),
        isTrue,
      );
      expect(
        NotebookPolicy.validConfiguredCapMicros(30_000_001),
        isFalse,
      );
    });
  });
}
