import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventjar/controller/bio_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/page/bio_profile/widget/bio_profile_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BioProfileBadgesCard extends GetView<BioProfileController> {
  const BioProfileBadgesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BioProfileCard(
      icon: Icons.military_tech_outlined,
      title: 'badges'.tr,
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.5.wp, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.gradientDarkStart.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${controller.badgeAssignments.length}',
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.gradientDarkStart,
          ),
        ),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: controller.badgeAssignments
            .where((b) => b.customBadge?.name != null)
            .map(
              (b) => _buildBadgeItem(
                context,
                label: b.customBadge!.name!,
                color: b.customBadge?.color,
                imageUrl: b.customBadge?.imageUrl?.toString(),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildBadgeItem(
    BuildContext context, {
    required String label,
    String? color,
    String? imageUrl,
  }) {
    final badgeColor = color != null && color.isNotEmpty
        ? Color(int.parse('FF${color.replaceFirst('#', '')}', radix: 16))
        : AppColors.gradientDarkStart;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(vertical: 1.5.hp, horizontal: 2.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (hasImage)
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: getFileUrl(imageUrl),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: badgeColor.withValues(alpha: 0.1),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: badgeColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.military_tech_outlined,
                    color: badgeColor,
                    size: 22,
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badgeColor.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.military_tech_outlined,
                color: badgeColor,
                size: 22,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
