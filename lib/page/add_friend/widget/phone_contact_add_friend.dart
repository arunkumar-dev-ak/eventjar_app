import 'package:eventjar/controller/add_friend/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/add_friend/widget/new_add_friend.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneContactAddFriend extends GetView<AddFriendController> {
  const PhoneContactAddFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final isPicking =
              controller.phoneContactService.isPickingContact.value;

          return SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isPicking ? null : () => controller.pickPhoneContact(),
              icon: isPicking
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.contacts_outlined),
              label: Text(
                isPicking
                    ? 'picking_contact'.tr
                    : 'pick_from_phone'.tr,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.8.hp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: AppColors.border(context),
                  width: 1.5,
                ),
              ),
            ),
          );
        }),

        SizedBox(height: 2.hp),

        const NewAddFriend(),
      ],
    );
  }
}
