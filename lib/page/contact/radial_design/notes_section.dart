import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

Widget buildNotesSection(String notes, Color stageColor) {
  return Container(
    margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
    child: ExpansionTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: stageColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.note_alt_outlined, size: 18, color: stageColor),
      ),
      title: Text(
        "Notes",
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryStatic,
        ),
      ),
      tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: EdgeInsets.symmetric(
        horizontal: 2.wp,
        vertical: 2.wp,
      ), // Indent content
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.dividerStatic),
      ),
      backgroundColor: AppColors.scaffoldBgStatic,
      collapsedBackgroundColor: Colors.transparent,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.dividerStatic),
      ),
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.cardBgStatic,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.chipBgStatic),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            notes,
            style: TextStyle(
              fontSize: 8.sp,
              color: AppColors.textPrimaryStatic,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}
