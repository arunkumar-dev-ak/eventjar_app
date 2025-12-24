import 'package:flutter/material.dart';

Widget buildNotesSection(String notes, Color stageColor) {
  return Container(
    margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: stageColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.note_alt_outlined, size: 18, color: stageColor),
            ),
            SizedBox(width: 12),
            Text(
              "Notes",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          notes,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade800,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}
