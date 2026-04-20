import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

enum FormButtonType { outline, primary }

class FormButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final FormButtonType type;
  final IconData? icon;

  const FormButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.type = FormButtonType.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // COMMON CHILD
    Widget child = isLoading
        ? SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(
              color: type == FormButtonType.primary
                  ? Colors.white
                  : (isDark ? Colors.blue.shade300 : Colors.blue.shade700),
              strokeWidth: 2,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 4.5.wp,
                  color: type == FormButtonType.primary
                      ? Colors.white
                      : (isDark ? Colors.blue.shade300 : Colors.blue.shade700),
                ),
                SizedBox(width: 1.5.wp),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w700,
                  color: type == FormButtonType.primary
                      ? Colors.white
                      : (isDark ? Colors.blue.shade300 : Colors.blue.shade700),
                ),
              ),
            ],
          );

    // OUTLINE BUTTON
    if (type == FormButtonType.outline) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 6.wp, vertical: 1.8.hp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
            width: 2,
          ),
          backgroundColor: AppColors.cardBg(context),
          foregroundColor: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
        ),
        child: child,
      );
    }

    // PRIMARY BUTTON
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 6.wp, vertical: 1.8.hp),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.gradientDarkStart,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      child: child,
    );
  }
}
