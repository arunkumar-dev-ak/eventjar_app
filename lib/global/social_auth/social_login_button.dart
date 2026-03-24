import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String assetPath;
  final VoidCallback onTap;
  final Color color;

  const SocialButton({
    required this.text,
    required this.assetPath,
    required this.onTap,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.2.hp, horizontal: 3.wp),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(1.wp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(assetPath, height: 20, width: 20),
              ),

              SizedBox(width: 2.5.wp),

              Text(
                text,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
