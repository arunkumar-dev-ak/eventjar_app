import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

Widget buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.confirmation_number_outlined, size: 64, color: Colors.grey),
        SizedBox(height: 2.hp),
        Text(
          "No tickets yet",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 1.hp),
        Text(
          "Register for events to see your tickets here",
          style: TextStyle(fontSize: 9.sp, color: Colors.grey.shade500),
        ),
      ],
    ),
  );
}
