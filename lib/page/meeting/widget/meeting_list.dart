import 'package:eventjar/controller/meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/meeting/widget/meeting_card.dart';
import 'package:eventjar/page/meeting/widget/meeting_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingList extends GetView<MeetingController> {
  const MeetingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.isLoading.value) {
        return RefreshIndicator(
          onRefresh: () => controller.fetchMeetingsOnReload(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => meetingShimmer(),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchMeetingsOnReload(),
        child: IgnorePointer(
          ignoring: controller.state.isSearching.value ? true : false,
          child: Stack(
            children: [
              // Content (disabled during search)
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
              _buildContent(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildContent() {
    final meetings = controller.state.meetings;

    // Empty state
    if (meetings.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 25.hp),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 64, color: AppColors.textHintStatic),
                SizedBox(height: 16),
                Text(
                  'No meetings match your filters',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondaryStatic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Try adjusting your status or date range',
                  style: TextStyle(fontSize: 14, color: AppColors.textHintStatic),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: meetings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        // Meeting card
        final meeting = meetings[index];
        return MeetingCard(meeting: meeting);
      },
    );
  }
}
