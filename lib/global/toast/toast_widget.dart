import 'package:flutter/material.dart';

class ToastItem extends StatelessWidget {
  final String? title;
  final String message;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onDismiss;

  const ToastItem({
    super.key,
    this.title,
    required this.message,
    required this.icon,
    required this.gradientColors,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 26),
              const SizedBox(width: 12),

              // 🔹 Text section
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null && title!.isNotEmpty) ...[
                        Text(
                          title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // 🔹 Close icon
              GestureDetector(
                onTap: onDismiss,
                child: const Icon(Icons.close, color: Colors.white70, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
