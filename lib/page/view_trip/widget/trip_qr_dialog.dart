import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/global/whatsapp_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../global/global_values.dart';

class TripQRDialog extends StatelessWidget {
  const TripQRDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ViewTripController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(24),
        constraints: BoxConstraints(maxWidth: 90.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Obx(() {
          final trip = controller.state.trip.value;
          if (trip == null) return SizedBox.shrink();

          final joinToken = trip.joinToken;
          final tripName = trip.name;
          final isCreator = trip.createdById == UserStore.to.profile['id'];
          final joinUrl = joinToken.isNotEmpty
              ? '${frontendBaseUrl()}/trips/join/$joinToken'
              : '';

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${"invite_to".tr} $tripName',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),

              SizedBox(height: 0.5.hp),

              Text(
                'trip_qr_description'.tr,
                style: TextStyle(
                  fontSize: 8.5.sp,
                  color: AppColors.textSecondary(context),
                ),
              ),

              SizedBox(height: 2.hp),

              if (joinUrl.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.hp),
                  child: Text(
                    'no_join_link'.tr,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                )
              else ...[
                // QR Code
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: joinUrl,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Color(0xFF0f172a),
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Color(0xFF0f172a),
                    ),
                  ),
                ),

                SizedBox(height: 2.hp),

                // Link row
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border(context)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          joinUrl,
                          style: TextStyle(
                            fontSize: 7.5.sp,
                            color: AppColors.textSecondary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () => _copyLink(joinUrl),
                        child: Icon(
                          Icons.copy,
                          size: 18,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.hp),

                // Action buttons
                Row(
                  children: [
                    // Share button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _shareLink(context, tripName, joinUrl),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.2.hp),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: AppColors.border(context)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share_outlined, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'share'.tr,
                              style: TextStyle(fontSize: 9.sp),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: 8),

                    // WhatsApp button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            _shareViaWhatsApp(context, tripName, joinUrl),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.2.hp),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: AppColors.border(context)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.message_outlined,
                              size: 18,
                              color: Color(0xFF25D366),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'WhatsApp',
                              style: TextStyle(fontSize: 9.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                if (isCreator) ...[
                  SizedBox(height: 1.hp),

                  Obx(() {
                    final isRegenerating =
                        controller.state.isRegeneratingToken.value;

                    return SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: isRegenerating
                            ? null
                            : () => _confirmRegenerate(context, controller),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.2.hp),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: AppColors.border(context)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isRegenerating)
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              Icon(Icons.refresh, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'new_link'.tr,
                              style: TextStyle(fontSize: 9.sp),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ],
          );
        }),
      ),
    );
  }

  void _copyLink(String url) {
    Clipboard.setData(ClipboardData(text: url));
    AppSnackbar.success(title: 'copied'.tr, message: 'link_copied'.tr);
  }

  void _shareLink(BuildContext context, String tripName, String joinUrl) {
    SharePlus.instance.share(
      ShareParams(
        title: '${"join".tr} $tripName',
        text:
            '${"trip_share_text".tr.replaceAll("{{name}}", tripName)}\n\n$joinUrl',
      ),
    );
  }

  void _shareViaWhatsApp(
    BuildContext context,
    String tripName,
    String joinUrl,
  ) {
    final message =
        '${"trip_share_text".tr.replaceAll("{{name}}", tripName)}\n\n$joinUrl';

    WhatsAppHelper.sendWhatsAppMessage(
      phoneNumber: '',
      message: message,
      context: context,
    );
  }

  void _confirmRegenerate(BuildContext context, ViewTripController controller) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('regenerate_link'.tr),
        content: Text('regenerate_link_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.regenerateJoinToken();
            },
            child: Text('regenerate'.tr, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

void showTripQRDialog(BuildContext context) {
  showDialog(context: context, builder: (_) => const TripQRDialog());
}
