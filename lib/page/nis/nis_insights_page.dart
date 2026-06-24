import 'package:eventjar/controller/nis_insights/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/nis/widget/score_trend_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class NisInsightsPage extends GetView<NisInsightsController> {
  const NisInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          'insights'.tr,
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
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
          children: [
            _buildScoreTrendCard(context),
            SizedBox(height: 1.5.hp),
            _buildHelpingFactorsCard(context),
            SizedBox(height: 1.5.hp),
            _buildAreasToImproveCard(context),
          ],
        );
      }),
    );
  }

  Widget _buildScoreTrendCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.wp),
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
                'score_trend'.tr,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
              _buildPeriodDropdown(context),
            ],
          ),
          SizedBox(height: 2.hp),
          ScoreTrendChart(data: controller.scoreHistory),
        ],
      ),
    );
  }

  Widget _buildPeriodDropdown(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.6.hp),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border(context)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedPeriod,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 4.5.wp,
            color: AppColors.textSecondary(context),
          ),
          style: TextStyle(
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
          items: controller.periods
              .map((p) => DropdownMenuItem(value: p, child: Text(p.tr)))
              .toList(),
          onChanged: (val) {
            if (val != null) controller.changePeriod(val);
          },
        ),
      ),
    );
  }

  Widget _buildHelpingFactorsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.wp),
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
          Text(
            'whats_helping_your_score'.tr,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 1.5.hp),
          ...controller.helpingFactors.map(
            (factor) => _buildHelpingItem(context, factor),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpingItem(BuildContext context, dynamic factor) {
    final iconData = _getFactorIcon(factor.iconType);
    final iconColor = _getFactorColor(factor.iconType);

    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.hp),
      child: Row(
        children: [
          Container(
            width: 11.wp,
            height: 11.wp,
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(iconData, color: Colors.white, size: 5.5.wp),
          ),
          SizedBox(width: 3.wp),
          Expanded(
            child: Text(
              factor.text,
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary(context),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreasToImproveCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.wp),
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
          Text(
            'areas_to_improve'.tr,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 1.hp),
          ...controller.areasToImprove.map(
            (area) => _buildImproveItem(context, area),
          ),
        ],
      ),
    );
  }

  Widget _buildImproveItem(BuildContext context, dynamic area) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.2.hp),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider(context), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              area.text,
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary(context),
                height: 1.3,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 4.wp,
            color: AppColors.textSecondary(context),
          ),
        ],
      ),
    );
  }

  IconData _getFactorIcon(String type) {
    switch (type) {
      case 'events':
        return Icons.event_rounded;
      case 'connections':
        return Icons.group_add_rounded;
      case 'followups':
        return Icons.check_circle_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  Color _getFactorColor(String type) {
    switch (type) {
      case 'events':
        return const Color(0xFF2E7D32);
      case 'connections':
        return const Color(0xFF1565C0);
      case 'followups':
        return const Color(0xFFF57C00);
      default:
        return Colors.grey;
    }
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
              height: 35.hp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            SizedBox(height: 1.5.hp),
            Container(
              width: double.infinity,
              height: 25.hp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            SizedBox(height: 1.5.hp),
            Container(
              width: double.infinity,
              height: 15.hp,
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
}
