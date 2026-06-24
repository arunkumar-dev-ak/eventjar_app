import 'package:eventjar/controller/nis/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/nis/widget/nis_breakdown_item.dart';
import 'package:eventjar/page/nis/widget/nis_gauge.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class NisPage extends GetView<NisController> {
  const NisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          'dashboard'.tr,
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
        if (controller.isLoading) {
          return _buildShimmer();
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.wp,
                    vertical: 1.5.hp,
                  ),
                  child: Column(
                    children: [
                      _buildScoreCard(context),
                      SizedBox(height: 1.5.hp),
                      _buildAiInsightsButton(context),
                      SizedBox(height: 1.5.hp),
                      _buildBreakdownSection(context),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildScoreCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'your_network_intelligence_score'.tr,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 1.hp),
          NisGauge(score: controller.overallScore),
          SizedBox(height: 1.hp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.ratingLabel,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                  color: _getRatingColor(controller.overallScore),
                ),
              ),
              SizedBox(width: 1.5.wp),
              Icon(
                Icons.star_rounded,
                color: const Color(0xFFFFC107),
                size: 5.5.wp,
              ),
            ],
          ),
          SizedBox(height: 1.5.hp),
          _buildPercentileCard(context),
        ],
      ),
    );
  }

  Widget _buildPercentileCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.2.hp),
      decoration: BoxDecoration(
        color: AppColors.chipBg(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.wp),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.trending_up_rounded,
              color: const Color(0xFF2E7D32),
              size: 5.5.wp,
            ),
          ),
          SizedBox(width: 2.5.wp),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 9.5.sp,
                  color: AppColors.textPrimary(context),
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: "${'youre_in_the_top'.tr} "),
                  TextSpan(
                    text: '${controller.topPercentile}%',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' ${'of'.tr} '),
                  TextSpan(
                    text: _formatNumber(controller.totalProfessionals),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' ${'professionals_in_your_industry'.tr}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'nis_breakdown'.tr,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(RouteName.nisBreakdownPage),
                child: Text(
                  'view_all'.tr,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gradientDarkStart,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.hp),
          NisBreakdownItem(
            icon: Icons.groups_rounded,
            iconColor: const Color(0xFF1565C0),
            barColor: const Color(0xFF1565C0),
            label: 'network_size'.tr,
            score: controller.networkSize,
          ),
          NisBreakdownItem(
            icon: Icons.verified_rounded,
            iconColor: const Color(0xFF00897B),
            barColor: const Color(0xFF00897B),
            label: 'network_quality'.tr,
            score: controller.networkQuality,
          ),
          NisBreakdownItem(
            icon: Icons.chat_bubble_rounded,
            iconColor: const Color(0xFFF9A825),
            barColor: const Color(0xFFF9A825),
            label: 'engagement_level'.tr,
            score: controller.engagementLevel,
          ),
          NisBreakdownItem(
            icon: Icons.campaign_rounded,
            iconColor: const Color(0xFF7B1FA2),
            barColor: const Color(0xFF7B1FA2),
            label: 'influence_visibility'.tr,
            score: controller.influenceVisibility,
          ),
          NisBreakdownItem(
            icon: Icons.psychology_rounded,
            iconColor: const Color(0xFF00ACC1),
            barColor: const Color(0xFF00ACC1),
            label: 'relationship_intelligence'.tr,
            score: controller.relationshipIntelligence,
          ),
        ],
      ),
    );
  }

  Widget _buildAiInsightsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.nisInsightsPage);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
        decoration: BoxDecoration(
          gradient: AppColors.buttonGradientFor(context),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientDarkStart.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 6.wp),
            SizedBox(width: 2.5.wp),
            Text(
              'ai_based_insights'.tr,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 2.wp),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white70,
              size: 4.wp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.borderStatic,
      highlightColor: AppColors.chipBgStatic,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.wp),
        child: Column(
          children: [
            SizedBox(height: 2.hp),
            Container(
              width: double.infinity,
              height: 40.hp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            SizedBox(height: 1.5.hp),
            Container(
              width: double.infinity,
              height: 35.hp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRatingColor(int score) {
    if (score >= 80) return const Color(0xFF2E7D32);
    if (score >= 60) return const Color(0xFFF9A825);
    if (score >= 40) return const Color(0xFFFF8F00);
    return const Color(0xFFD32F2F);
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}k';
    }
    return number.toString();
  }
}
