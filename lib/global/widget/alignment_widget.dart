import 'package:flutter/material.dart';

class AlignmentWidget extends StatelessWidget {
  final Alignment alignment;
  final Widget child;
  const AlignmentWidget(
      {required this.child, this.alignment = Alignment.center, super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: child,
    );
  }
}
