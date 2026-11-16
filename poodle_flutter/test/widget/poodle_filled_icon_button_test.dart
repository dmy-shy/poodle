import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/ui/components/poodle_filled_icon_button.dart';
import 'package:poodle_flutter/ui/theme/poodle_theme.dart';

void main() {
  testWidgets(
    'filled buttons preserve a legible glyph under an inherited theme',
    (tester) async {
      final theme = PoodleTheme.build();
      final colors = theme.colorScheme;
      for (final enabled in [true, false]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: IconTheme(
                data: IconThemeData(color: colors.primary),
                child: PoodleFilledIconButton(
                  tooltip: 'Send',
                  icon: Icons.arrow_upward,
                  onPressed: enabled ? () {} : null,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final glyph = tester.element(find.byIcon(Icons.arrow_upward));
        expect(
          IconTheme.of(glyph).color,
          enabled ? colors.onPrimary : colors.onSurface.withValues(alpha: 0.38),
        );
      }
    },
  );
}
