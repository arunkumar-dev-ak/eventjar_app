import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MoreGridItem {
  final dynamic icon;
  final String label;
  final VoidCallback? onTap;
  final bool isFontAwesome;

  const MoreGridItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.isFontAwesome = false,
  });
}

class MoreSectionTitle extends StatelessWidget {
  final String title;

  const MoreSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.wp),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 8.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary(context),
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class MoreIconGrid extends StatelessWidget {
  final bool isDark;
  final List<MoreGridItem> items;

  const MoreIconGrid({super.key, required this.isDark, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        return _buildGridTile(context, item);
      },
    );
  }

  Widget _buildGridTile(BuildContext context, MoreGridItem item) {
    final iconColor =
        isDark ? const Color(0xFF5B9BEF) : AppColors.gradientDarkStart;
    final borderColor =
        isDark ? const Color(0xFF2A4A6A) : const Color(0xFFB6D9FF);
    final bgColor =
        isDark ? const Color(0xFF1A2A3A) : const Color(0xFFF5FAFF);

    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            alignment: Alignment.center,
            child: item.isFontAwesome
                ? Center(child: FaIcon(item.icon, size: 22, color: iconColor))
                : Icon(item.icon, size: 24, color: iconColor),
          ),
          SizedBox(height: 0.8.hp),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 7.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
