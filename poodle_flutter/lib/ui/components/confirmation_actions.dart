import 'package:flutter/material.dart';

class ConfirmationActions extends StatelessWidget {
  const ConfirmationActions({
    super.key,
    required this.cancel,
    required this.confirm,
    this.destructive = false,
  });
  final String cancel, confirm;
  final bool destructive;

  @override
  Widget build(BuildContext context) => DialogActionRow(
    cancel: cancel,
    confirm: confirm,
    destructive: destructive,
    onCancel: () => Navigator.pop(context, false),
    onConfirm: () => Navigator.pop(context, true),
  );
}

/// A single AlertDialog action, so its OverflowBar cannot stack the buttons.
class DialogActionRow extends StatelessWidget {
  const DialogActionRow({
    super.key,
    required this.cancel,
    required this.confirm,
    required this.onCancel,
    required this.onConfirm,
    this.destructive = false,
    this.secondary,
  });

  final String cancel, confirm;
  final VoidCallback? onCancel, onConfirm;
  final bool destructive;
  final Widget? secondary;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const minimum = Size(0, 48);
    const padding = EdgeInsets.symmetric(horizontal: 8, vertical: 12);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (secondary case final action?) Center(child: action),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: minimum,
                    padding: padding,
                  ),
                  onPressed: onCancel,
                  child: Text(cancel, textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: minimum,
                    padding: padding,
                    backgroundColor: destructive ? colors.error : null,
                    foregroundColor: destructive ? colors.onError : null,
                  ),
                  onPressed: onConfirm,
                  child: Text(confirm, textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
