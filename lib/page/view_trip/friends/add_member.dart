import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/haptic_helper.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAddMemberPopup(BuildContext context) {
  // Find the existing controller
  final controller = Get.find<ViewTripController>();
  final currentUserId = UserStore.to.profile['id'] as String;

  final Color primaryColor = AppColors.gradientDarkStart;
  final Color headerColor = Colors.blue.shade600;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 400),
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
            // ---------------- HEADER ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "Add a Friend",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: controller.onFriendRefreshClicked,
                    tooltip: 'Refresh',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.5.hp),

            // ---------------- SEARCH BAR ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'search_friends'.tr,
                  filled: true,
                  fillColor: AppColors.cardBg(context),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border(context)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
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
            SizedBox(height: 1.hp),

            // ---------------- LIST & PAGINATION ----------------
            SizedBox(
              height: 350,
              child: Obx(() {
                final bool isListLoading =
                    controller.state.isFriendDropdownLoading.value;
                final bool isLoadMoreLoading =
                    controller.state.isFriendDropdownLoadMoreLoading.value;
                final friends = controller.state.dropdownFriends;

                // Empty State
                if (friends.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            ? 'Loading friends...'
                            : 'No eligible friends found.',
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  );
                }

                return Stack(
                  children: [
                    // List View
                    ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      itemCount: friends.length + 1,
                      itemBuilder: (context, index) {
                        // Load More Logic
                        if (index >= friends.length) {
                          if (isLoadMoreLoading) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
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

                          final total =
                              controller
                                  .state
                                  .friendDropdownMeta
                                  .value
                                  ?.paging
                                  ?.totalCount ??
                              0;
                          if (friends.length >= total) return const SizedBox();

                          return GestureDetector(
                            onTap: controller.onFriendLoadMoreClicked,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              alignment: Alignment.center,
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

                        // Friend Item
                        final friendItem = friends[index];
                        final displayName = friendItem.getFriendDisplayName(
                          currentUserId,
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
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
                                // 1. Close Popup
                                Navigator.pop(context);
                                // 2. Call API to Add
                                controller.addSelectedFriendToTrip(friendItem);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue.shade50,
                                      ),
                                      child: Center(
                                        child: Text(
                                          displayName.isNotEmpty
                                              ? displayName[0].toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade700,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 3.wp),
                                    Expanded(
                                      child: Text(
                                        displayName,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
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

                    // Loading Overlay
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
          ],
        ),
      ),
    ),
  );
}
