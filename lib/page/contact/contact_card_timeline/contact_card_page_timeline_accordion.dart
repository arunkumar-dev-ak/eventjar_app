// Custom Leading Icon
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:flutter/material.dart';

Widget buildEnhancedLeadingIconForAccordion() {
  return Container(
    padding: EdgeInsets.all(1.wp),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.blue.withValues(alpha: 0.01),
          Colors.blue.withValues(alpha: 0.10),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.blue.withValues(alpha: 0.3), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Icon(
      Icons.timeline_outlined,
      color: Colors.blue.shade500,
      size: 9.sp,
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: 0.05),
          offset: Offset(0, 0.5),
          blurRadius: 2,
        ),
      ],
    ),
  );
}

// Enhanced Title
Widget buildEnhancedTitleForAccordion(Contact contact) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'View Contact Timeline',
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: Colors.blue.shade800,
        ),
      ),
      SizedBox(width: 1.wp),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 1.5.wp, vertical: 0.3.hp),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'Stage ${contact.stage.index + 1}/5',
          style: TextStyle(
            fontSize: 6.sp,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade700,
          ),
        ),
      ),
    ],
  );
}
