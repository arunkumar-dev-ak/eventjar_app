import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

Widget thankYouMessageBuildMethodCard({
  required String title,
  required IconData icon,
  required bool isSelected,
  required bool isDisabled,
  required bool isLoading,
  String? badgeText,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: (isDisabled || isLoading) ? null : onTap, // ✅ Disable during loading
    child: AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: double.infinity,
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: isLoading
            ? Colors.grey[100] // ✅ Loading: light grey shimmer
            : isDisabled
            ? Colors.grey[100]
            : isSelected
            ? Colors.blue.withValues(alpha: 0.08)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLoading
              ? Colors.grey[300]!
              : isDisabled
              ? Colors.grey[300]!
              : isSelected
              ? Colors.blue
              : Colors.grey[300]!,
          width: isLoading || isDisabled ? 1 : 1.5,
        ),
        boxShadow: isLoading || isDisabled
            ? [] // ✅ No shadow during loading/disabled
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Icon + Title + Badge/Loading
          Expanded(
            child: Row(
              children: [
                // ✅ LOADING SPINNER or ICON
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
                        color: isDisabled
                            ? Colors.grey[400]
                            : isSelected
                            ? Colors.blue
                            : Colors.grey[600],
                      ),
                SizedBox(width: 3.wp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ LOADING TEXT or TITLE
                      isLoading
                          ? Text(
                              title,
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Text(
                              title,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: isSelected && !isDisabled
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isDisabled
                                    ? Colors.grey[500]
                                    : isSelected
                                    ? Colors.blue[700]
                                    : Colors.grey[700],
                              ),
                            ),

                      // Badge or Loading dots
                      if (!isLoading && isDisabled && badgeText != null) ...[
                        SizedBox(height: 0.5.hp),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              fontSize: 7.sp,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ] else if (isLoading) ...[
                        SizedBox(height: 0.5.hp),
                        Container(
                          padding: EdgeInsets.symmetric(
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

          // Right side: Selection indicator (only when not loading/disabled)
          if (!isDisabled && !isLoading)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
        ],
      ),
    ),
  );
}
