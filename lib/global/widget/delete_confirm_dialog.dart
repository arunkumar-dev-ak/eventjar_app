import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String title;
  final String itemName;
  final String warningText;
  final VoidCallback onDelete;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBgColor;
  final String? actionText;
  final Color? actionColor;
  final String? promptText;

  DeleteConfirmDialog({
    super.key,
    required this.title,
    required this.itemName,
    required this.onDelete,
    String? warningText,
    this.icon,
    this.iconColor,
    this.iconBgColor,
    this.actionText,
    this.actionColor,
    this.promptText,
  }) : warningText = warningText ?? 'permanent_action_warning'.tr;

  @override
  Widget build(BuildContext context) {
    final resolvedIcon = icon ?? Icons.delete_forever_rounded;
    final resolvedIconColor = iconColor ?? Colors.red.shade500;
    final resolvedIconBgColor = iconBgColor ?? Colors.red.shade50;
    final resolvedActionText = actionText ?? 'delete'.tr;
    final resolvedActionColor = actionColor ?? Colors.red.shade500;
    final resolvedPromptText =
        promptText ?? '${'delete_confirm_prompt'.tr} "$itemName"?';

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
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: resolvedIconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                resolvedIcon,
                size: 36,
                color: resolvedIconColor,
              ),
            ),
            SizedBox(height: 1.hp),

            Text(
              title,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.hp),

            Text(
              resolvedPromptText,
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
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      warningText,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.hp),

            Row(
              children: [
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
                    onPressed: () => Navigator.of(context).pop(),
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
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: resolvedActionColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 1.5.hp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDelete();
                    },
                    child: Text(
                      resolvedActionText,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
