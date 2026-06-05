import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoveMemberDialog extends GetView<ViewTripController> {
  final String memberName;
  final String memberId;

  const RemoveMemberDialog({required this.memberName, required this.memberId});

  Future<void> _handleRemoveRequest(BuildContext context) async {
    // Await the controller method which handles the state and API call
    final success = await controller.removeMemberFromTrip(memberId);

    // Only pop the dialog if the API call was successful
    if (success && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(maxWidth: 90.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.red.shade900.withValues(alpha: 0.3)
                      : Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_remove_rounded,
                  size: 32,
                  color: isDark ? Colors.red.shade300 : Colors.red.shade600,
                ),
              );
            }),
            SizedBox(height: 1.hp),
            Text(
              'remove_member'.tr,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.hp),
            Text(
              'Are you sure you want to remove $memberName from this trip?',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textSecondary(context),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.hp),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.chipBg(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.textSecondary(context),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'remove_member_warning'.tr,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.hp),

            // Wrap the buttons in an Obx to listen to the global loading state
            Obx(() {
              final isLoading = controller.state.isRemovingMember.value;

              return Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.chipBg(context),
                        foregroundColor: AppColors.textSecondary(context),
                        padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      // Disable tap if loading
                      onPressed: isLoading
                          ? null
                          : () => Navigator.of(context).pop(false),
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.wp),

                  // Remove/Submit Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      // Disable tap if loading
                      onPressed: isLoading
                          ? null
                          : () => _handleRemoveRequest(context),
                      child: isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'remove'.tr,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
