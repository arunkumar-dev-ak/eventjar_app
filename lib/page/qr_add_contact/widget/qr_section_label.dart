import 'package:flutter/material.dart';

class QrSectionLabel extends StatelessWidget {
  final String text;

  const QrSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface.withValues(alpha: 0.8),
      ),
    );
  }
}
