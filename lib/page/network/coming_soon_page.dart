import 'package:flutter/material.dart';

class ComingSoonWidget extends StatelessWidget {
  final String message;

  const ComingSoonWidget({
    super.key,
    this.message =
        "Exciting features are on the way! We’re continuously improving to serve you better.",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction, size: 72, color: Colors.blueGrey.shade400),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Thank you for your patience and support.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey.shade400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
