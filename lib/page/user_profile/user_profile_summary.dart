import 'package:eventjar/controller/user_profile/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget userProfilebuildSummary() {
  final controller = Get.find<UserProfileController>();
  final extended = controller.state.userProfile.value?.extendedProfile;
  final hasBio = controller.bio.isNotEmpty;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Bio Section
      if (hasBio) ...[
        Text(
          controller.bio,
          style: TextStyle(
            fontSize: 9.sp,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
          maxLines: 6,
          overflow: TextOverflow.ellipsis,
        ),
      ] else ...[
        Container(
          padding: EdgeInsets.all(4.wp),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                size: 20,
                color: Colors.grey.shade400,
              ),
              SizedBox(width: 3.wp),
              Expanded(
                child: Text(
                  'Add a bio to tell others about yourself',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],

      SizedBox(height: 2.hp),

      // Quick Stats Row
      Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.work_history_rounded,
              label: 'Experience',
              value: extended?.yearsInBusiness != null
                  ? '${extended!.yearsInBusiness} Years'
                  : 'N/A',
              color: Colors.orange,
            ),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: _buildStatCard(
              icon: Icons.calendar_month_rounded,
              label: 'Availability',
              value: extended?.availabilitySlots ?? 'Not set',
              color: Colors.green,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildStatCard({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
}) {
  final isEmpty = value == 'N/A' || value == 'Not set';

  return Container(
    padding: EdgeInsets.all(3.wp),
    decoration: BoxDecoration(
      color: isEmpty ? Colors.grey.shade50 : color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isEmpty ? Colors.grey.shade200 : color.withValues(alpha: 0.2),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isEmpty ? Colors.grey.shade400 : color,
            ),
            SizedBox(width: 2.wp),
            Text(
              label,
              style: TextStyle(
                fontSize: 7.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.hp),
        Text(
          value,
          style: TextStyle(
            fontSize: 9.sp,
            color: isEmpty ? Colors.grey.shade400 : Colors.grey.shade800,
            fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
            fontStyle: isEmpty ? FontStyle.italic : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
