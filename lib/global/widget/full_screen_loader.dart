import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenLoader extends StatelessWidget {
  final bool isLoading;
  final String message;

  FullScreenLoader({
    super.key,
    required this.isLoading,
    String? message,
  }) : message = message ?? 'getting_details'.tr;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned.fill(
      child: AbsorbPointer(
        absorbing: true, // 🔒 blocks clicks
        child: Container(
          color: isDark
              ? Colors.black.withValues(alpha: 0.6)
              : Colors.black.withValues(alpha: 0.3),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
