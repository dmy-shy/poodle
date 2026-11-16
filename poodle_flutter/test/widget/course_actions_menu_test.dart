import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/features/courses/presentation/widgets/course_actions_menu.dart';

void main() {
  testWidgets('menu remains usable at the reference phone width', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomRight,
            child: CourseActionsMenu(
              onDownload: () {},
              onHide: () {},
              onStar: () {},
              downloadEnabled: false,
              starred: true,
              hidden: true,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Course actions'));
    await tester.pumpAndSettle();
    expect(find.text('Download course'), findsOneWidget);
    expect(find.text('Show in view'), findsOneWidget);
    expect(find.text('Unstar this course'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('course actions match the reference and invoke their actions', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CourseActionsMenu(
            onDownload: () => selected = 'download',
            onHide: () => selected = 'hide',
            onStar: () => selected = 'star',
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Course actions'));
    await tester.pumpAndSettle();
    expect(find.text('Download course'), findsOneWidget);
    expect(find.text('Remove from view'), findsOneWidget);
    expect(find.text('Star this course'), findsOneWidget);
    await tester.tap(find.text('Star this course'));
    await tester.pumpAndSettle();
    expect(selected, 'star');
    expect(find.text('Download course'), findsNothing);
  });
}
