import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String assetPath;
  final VoidCallback onTap;
  final Color color;
  final bool isLoading;

  const SocialButton({
    required this.text,
    required this.assetPath,
    required this.onTap,
    required this.color,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dimmedColor = color.withValues(alpha: isLoading ? 0.04 : 0.08);
    final borderColor = color.withValues(alpha: isLoading ? 0.15 : 0.3);

    return Opacity(
      opacity: isLoading ? 0.7 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isLoading ? null : onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.2.hp, horizontal: 3.wp),
            decoration: BoxDecoration(
              color: dimmedColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Container(
                    padding: EdgeInsets.all(1.wp),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(assetPath, height: 20, width: 20),
                  ),

                SizedBox(width: 2.5.wp),

                Text(
                  isLoading ? "$text..." : text,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87.withValues(
                      alpha: isLoading ? 0.6 : 1.0,
                    ),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
