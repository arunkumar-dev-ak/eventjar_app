import 'package:eventjar/controller/nis/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NisBreakdownPage extends GetView<NisController> {
  const NisBreakdownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          'nis_breakdown'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
      ),
      body: Obx(() {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
          children: [
            _buildBreakdownCard(
              context,
              icon: Icons.groups_rounded,
              iconColor: const Color(0xFF2E7D32),
              barColor: const Color(0xFF1565C0),
              title: 'network_size'.tr,
              description: 'network_size_desc'.tr,
              score: controller.networkSize,
            ),
            _buildBreakdownCard(
              context,
              icon: Icons.verified_rounded,
              iconColor: const Color(0xFF00897B),
              barColor: const Color(0xFF00897B),
              title: 'network_quality'.tr,
              description: 'network_quality_desc'.tr,
              score: controller.networkQuality,
            ),
            _buildBreakdownCard(
              context,
              icon: Icons.chat_bubble_rounded,
              iconColor: const Color(0xFFF9A825),
              barColor: const Color(0xFFF9A825),
              title: 'engagement_level'.tr,
              description: 'engagement_level_desc'.tr,
              score: controller.engagementLevel,
            ),
            _buildBreakdownCard(
              context,
              icon: Icons.campaign_rounded,
              iconColor: const Color(0xFF7B1FA2),
              barColor: const Color(0xFF7B1FA2),
              title: 'influence_visibility'.tr,
              description: 'influence_visibility_desc'.tr,
              score: controller.influenceVisibility,
            ),
            _buildBreakdownCard(
              context,
              icon: Icons.psychology_rounded,
              iconColor: const Color(0xFF00ACC1),
              barColor: const Color(0xFF00ACC1),
              title: 'relationship_intelligence'.tr,
              description: 'relationship_intelligence_desc'.tr,
              score: controller.relationshipIntelligence,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBreakdownCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color barColor,
    required String title,
    required String description,
    required int score,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.5.hp),
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12.wp,
            height: 12.wp,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 6.wp),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 0.4.hp),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary(context),
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 1.hp),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: score / 100,
                          minHeight: 0.8.hp,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(barColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.wp),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$score',
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          TextSpan(
                            text: ' /100',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
