import 'package:eventjar/controller/join_trip/controller.dart';
import 'package:eventjar/controller/join_trip/state.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class JoinTripSuccess extends GetView<JoinTripController> {
  const JoinTripSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final tripData = controller.state.tripData.value;
    if (tripData == null) return const SizedBox.shrink();

    final isAlready =
        controller.state.status.value == JoinTripStatus.alreadyMember;

    return Container(
      width: 100.wp,
      color: AppColors.isDark ? AppColors.darkCard : AppColors.liteBlue,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              width: 60.wp,
              repeat: false,
            ),

            SizedBox(height: 2.hp),

            Text(
              isAlready
                  ? 'already_in_trip'.tr
                  : 'joined_trip_success'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 1.5.hp),

            // Trip name
            Text(
              tripData.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 0.5.hp),

            // Destination
            if (tripData.destination.isNotEmpty)
              Text(
                tripData.destination,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 10.sp,
                ),
              ),

            SizedBox(height: 2.hp),

            // Creator info
            if (tripData.createdBy != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCreatorAvatar(context, tripData.createdBy!),
                  SizedBox(width: 8),
                  Text(
                    '${"created_by".tr} ${tripData.createdBy!.name}',
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 9.sp,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.hp),
            ],

            // Member count
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 18,
                  color: AppColors.textSecondary(context),
                ),
                SizedBox(width: 4),
                Text(
                  '${tripData.memberCount} ${"members".tr}',
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.hp),

            // Redirecting text
            Text(
              'redirecting_to_trip'.tr,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 9.sp,
                fontStyle: FontStyle.italic,
              ),
            ),

            SizedBox(height: 1.hp),

            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.textSecondary(context),
              ),
            ),

            SizedBox(height: 3.hp),

            // Manual navigate button
            TextButton(
              onPressed: controller.navigateToViewTrip,
              child: Text(
                'go_to_trip'.tr,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorAvatar(
    BuildContext context,
    dynamic creator,
  ) {
    final avatarUrl = creator.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return CircleAvatar(
      radius: 14,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: hasAvatar ? NetworkImage(getFileUrl(avatarUrl)) : null,
      child: hasAvatar
          ? null
          : Text(
              creator.name.isNotEmpty ? creator.name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textPrimary(context),
              ),
            ),
    );
  }
}
