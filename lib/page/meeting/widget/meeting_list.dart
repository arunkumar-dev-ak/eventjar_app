import 'package:eventjar/controller/meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/meeting/widget/meeting_card.dart';
import 'package:eventjar/page/meeting/widget/meeting_shimmer.dart';
import 'package:eventjar/page/meeting/widget/network_meeting_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingList extends GetView<MeetingController> {
  const MeetingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOneOnOneTab = controller.state.selectedTab.value == 0;

      if (isOneOnOneTab) {
        return _buildOneOnOneTab(context);
      }
      return _buildQualifiedContactTab(context);
    });
  }

  Widget _buildOneOnOneTab(BuildContext context) {
    if (controller.state.isOneOnOneLoading.value) {
      return _buildShimmer();
    }

    final meetings = controller.state.oneOnOneMeetings;

    if (meetings.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => controller.fetchOneOnOneMeetings(forceRefresh: true),
        child: _buildEmptyState(
          icon: Icons.people_outline,
          title: 'no_one_on_one_meetings'.tr,
          subtitle: 'no_one_on_one_meetings_desc'.tr,
        ),
      );
    }

    final hasNextPage = controller.state.oneOnOneHasNextPage.value;

    return RefreshIndicator(
      onRefresh: () => controller.fetchOneOnOneMeetings(forceRefresh: true),
      child: ListView.separated(
        controller: controller.oneOnOneScrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: hasNextPage ? meetings.length + 1 : meetings.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= meetings.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: meetingShimmer(),
            );
          }
          final meeting = meetings[index];
          return GestureDetector(
            onTap: () => controller.handleOneOnOneMeetingTap(meeting),
            child: NetworkMeetingCard(meeting: meeting),
          );
        },
      ),
    );
  }

  Widget _buildQualifiedContactTab(BuildContext context) {
    if (controller.state.isLoading.value) {
      return _buildShimmer();
    }

    return RefreshIndicator(
      onRefresh: () => controller.fetchMeetingsOnReload(),
      child: IgnorePointer(
        ignoring: controller.state.isSearching.value,
        child: Stack(
          children: [
            if (controller.state.isSearching.value) ...[
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.chipBgStatic,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.dividerStatic,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.textSecondaryStatic,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Processing...",
                        style: TextStyle(
                          color: AppColors.textPrimaryStatic,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            _buildQualifiedContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildQualifiedContent() {
    final meetings = controller.state.meetings;

    if (meetings.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_busy,
        title: 'no_meetings_match_filters'.tr,
        subtitle: 'try_adjusting_filters_desc'.tr,
      );
    }

    return ListView.separated(
      controller: controller.qualifiedContactScrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: meetings.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return MeetingCard(meeting: meeting);
      },
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => meetingShimmer(),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 25.hp),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: AppColors.textHintStatic),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondaryStatic,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textHintStatic,
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}
