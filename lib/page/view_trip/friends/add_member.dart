import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAddMemberPopup(BuildContext context) {
  final controller = Get.find<ViewTripController>();
  final currentUserId = UserStore.to.profile['id'] as String;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final Color primaryColor = AppColors.gradientDarkStart;
  final Color headerColor = AppColors.gradientDarkStart;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        constraints: BoxConstraints(maxHeight: 70.hp, maxWidth: 90.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "add_a_friend".tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: controller.onFriendRefreshClicked,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: EdgeInsets.fromLTRB(24, 1.5.hp, 24, 1.hp),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'search_friends'.tr,
                  hintStyle: TextStyle(
                    fontSize: 9.5.sp,
                    color: AppColors.textHint(context),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.border(context)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.border(context)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: headerColor, width: 1.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: AppColors.textHint(context),
                  ),
                ),
                onChanged: controller.onFriendSearchChanged,
              ),
            ),

            // List
            Expanded(
              child: Obx(() {
                final bool isListLoading =
                    controller.state.isFriendDropdownLoading.value;
                final bool isLoadMoreLoading =
                    controller.state.isFriendDropdownLoadMoreLoading.value;
                final friends = controller.state.dropdownFriends;

                if (friends.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isListLoading
                              ? Icons.hourglass_empty
                              : Icons.search_off,
                          size: 40,
                          color: AppColors.iconMuted(context),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isListLoading
                              ? 'loading_friends'.tr
                              : 'no_eligible_friends'.tr,
                          style: TextStyle(
                            color: AppColors.textSecondary(context),
                            fontSize: 9.5.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final total =
                    controller
                        .state
                        .friendDropdownMeta
                        .value
                        ?.paging
                        .totalCount ??
                    0;
                final hasMore = friends.length < total;

                return Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      itemCount: friends.length + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= friends.length) {
                          if (isLoadMoreLoading) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: controller.onFriendLoadMoreClicked,
                            child: Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primaryColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                'load_more'.tr,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          );
                        }

                        final friendItem = friends[index];
                        final displayName = friendItem.getFriendDisplayName(
                          currentUserId,
                        );

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.divider(context),
                              width: 1.5,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                HapticHelper.selection();
                                Navigator.pop(context);
                                controller.addSelectedFriendToTrip(friendItem);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: isDark
                                          ? headerColor.withValues(alpha: 0.15)
                                          : Colors.blue.shade50,
                                      child: Text(
                                        displayName.isNotEmpty
                                            ? displayName[0].toUpperCase()
                                            : '?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.blue.shade700,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 3.wp),
                                    Expanded(
                                      child: Text(
                                        displayName,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary(context),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (isListLoading)
                      Positioned.fill(
                        child: Container(
                          color: AppColors.cardBg(
                            context,
                          ).withValues(alpha: 0.8),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                      ),
                  ],
                );
              }),
            ),

            // Close button
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 2.hp),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: AppColors.border(context)),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
