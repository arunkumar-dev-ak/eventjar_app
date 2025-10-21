import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class EventInfoContent extends StatelessWidget {
  const EventInfoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 100.wp,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
