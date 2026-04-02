import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void myTicketShowQRSheet({
  required BuildContext context,
  required String qrData,
  required String confirmationCode,
  required String registeredDate,
  required String eventTitle,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _QRBottomSheet(
      qrData: qrData,
      confirmationCode: confirmationCode,
      registeredDate: registeredDate,
      eventTitle: eventTitle,
    ),
  );
}

class _QRBottomSheet extends StatelessWidget {
  final String qrData;
  final String confirmationCode;
  final String registeredDate;
  final String eventTitle;

  const _QRBottomSheet({
    required this.qrData,
    required this.confirmationCode,
    required this.registeredDate,
    required this.eventTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(6.wp, 1.5.hp, 6.wp, 4.hp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 10.wp,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.hp),

          // Header
          Text(
            'Your Ticket',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 0.5.hp),
          Text(
            eventTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9.sp,
              color: AppColors.textSecondary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.5.hp),

          // QR Code
          Container(
            padding: EdgeInsets.all(4.wp),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider(context), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 55.wp,
              backgroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 2.5.hp),

          // Confirmation code + registered date
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 1.5.hp),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.divider(context)),
            ),
            child: Column(
              children: [
                Text(
                  'Confirmation Code',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.hp),
                Text(
                  confirmationCode,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 1.5.hp),
                Text(
                  'Registered On',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.hp),
                Text(
                  registeredDate,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.hp),

          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
