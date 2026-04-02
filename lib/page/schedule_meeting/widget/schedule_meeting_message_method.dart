import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

Widget scheduleMeetingMessageBuildMethodCard({
  required String title,
  required IconData icon,
  required bool isSelected,
  required bool isLoading,
  String? badgeText,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: isLoading ? null : onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: isLoading
            ? AppColors.chipBgStatic
            : isSelected
            ? Colors.blue.withValues(alpha: 0.08)
            : AppColors.scaffoldBgStatic,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLoading
              ? AppColors.dividerStatic
              : isSelected
              ? Colors.blue
              : AppColors.dividerStatic,
          width: 1.5,
        ),
        boxShadow: isLoading
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT
          Expanded(
            child: Row(
              children: [
                isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.withValues(alpha: 0.5),
                          ),
                        ),
                      )
                    : Icon(
                        icon,
                        color: isSelected ? Colors.blue : AppColors.textSecondaryStatic,
                      ),
                SizedBox(width: 3.wp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.blue[700]
                              : AppColors.textSecondaryStatic,
                        ),
                      ),

                      if (!isLoading) ...[
                        SizedBox(height: 0.5.hp),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: badgeText == null
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText ?? 'Automation Enabled',
                            style: TextStyle(
                              fontSize: 7.sp,
                              color: badgeText == null
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ] else ...[
                        SizedBox(height: 0.5.hp),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 7.sp,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT SELECTOR
          if (!isLoading)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.blue : AppColors.textHintStatic,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
        ],
      ),
    ),
  );
}
