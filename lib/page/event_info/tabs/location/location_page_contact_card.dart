import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

// Contact Card
Widget buildContactCard({required String phone, String? name, String? email}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (name != null && name.isNotEmpty) ...[
        _buildContactRow(
          icon: Icons.person,
          text: name,
          color: AppColors.gradientDarkStart,
        ),
        SizedBox(height: 1.hp),
      ],
      _buildContactRow(
        icon: Icons.phone,
        text: phone,
        color: AppColors.gradientDarkStart,
      ),
    ],
  );
}

Widget buildIconContainer({required IconData icon, required Color color}) {
  return Container(
    padding: EdgeInsets.all(2.wp),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(icon, color: color, size: 20),
  );
}

Widget _buildContactRow({
  required IconData icon,
  required String text,
  required Color color,
}) {
  return Row(
    children: [
      buildIconContainer(icon: icon, color: color),
      SizedBox(width: 3.wp),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    ],
  );
}
