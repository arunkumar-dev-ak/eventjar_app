import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/my_ticket/my_ticket_shaper_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

Widget myTicketBuildBadge(String label, Color textColor, Color bgColor) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 0.5.hp),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: textColor.withValues(alpha: 0.3), width: 1),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: textColor,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget myTicketBuildInfoRow(
  IconData icon,
  String label,
  String value,
  Color iconColor,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(1.5.wp),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: iconColor),
      ),
      SizedBox(width: 3.wp),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 8.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.3.hp),
            Text(
              value,
              style: TextStyle(
                fontSize: 9.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget myTicketBuildQRCodeSection(
  String qrData,
  String confirmationCode,
  String registeredDate,
) {
  return Column(
    children: [
      SizedBox(height: 1.hp),
      CustomPaint(
        painter: TicketShapePainter(
          borderColor: Colors.grey.shade300,
          borderRadius: 12,
          circleRadius: 12,
        ),
        child: Container(
          padding: EdgeInsets.all(4.wp),
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // QR Code
              Container(
                padding: EdgeInsets.all(2.wp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 120,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 3.wp),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirmation Number',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.hp),
                    Text(
                      confirmationCode,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.hp),
                    Text(
                      'Registered On',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.hp),
                    Text(
                      registeredDate,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

// Helper methods for date formatting
// String _formatDate(DateTime date) {
//   return DateFormat('dd MMM yyyy').format(date);
// }

// String _formatTime(DateTime date) {
//   return DateFormat('hh:mm a').format(date);
// }

// String _formatDateTime(DateTime date) {
//   return DateFormat('dd MMM yyyy, hh:mm a').format(date);
// }
