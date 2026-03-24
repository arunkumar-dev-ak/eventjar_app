import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class WhatsappNotificationShimmer extends StatelessWidget {
  const WhatsappNotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(4.wp),
      itemCount: 3,
      itemBuilder: (_, __) => Container(
        margin: EdgeInsets.only(bottom: 2.hp),
        height: 12.hp,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
