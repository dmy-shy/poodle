import 'package:flutter/material.dart';

class EmailAvatar extends StatelessWidget {
  const EmailAvatar({super.key, required this.email, this.radius = 20});

  final String email;
  final double radius;

  static final _letterOrDigit = RegExp(r'[\p{L}\p{Nd}]', unicode: true);

  @override
  Widget build(BuildContext context) {
    final label = email
        .split('@')
        .first
        .toUpperCase()
        .characters
        .where(_letterOrDigit.hasMatch)
        .take(2)
        .join();

    return CircleAvatar(
      radius: radius,
      child: label.isEmpty
          ? Icon(Icons.person_outline, size: radius)
          : Padding(
              padding: const EdgeInsets.all(4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ExcludeSemantics(
                  child: Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: radius * 0.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
