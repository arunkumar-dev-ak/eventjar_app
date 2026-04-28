import 'package:eventjar/controller/add_friend/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/form_element.dart';
import 'package:eventjar/page/add_friend/widget/send_invitation_add_friend.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewAddFriend extends GetView<AddFriendController> {
  const NewAddFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormElement(
          controller: controller.nameController,
          label: "Name *",
          validator: (val) =>
              val == null || val.isEmpty ? "Name required" : null,
        ),

        SizedBox(height: 2.hp),

        FormElement(
          controller: controller.phoneController,
          label: "Phone Number *",
          keyboardType: TextInputType.phone,
          validator: (val) =>
              val == null || val.length < 10 ? "Invalid phone" : null,
        ),

        SizedBox(height: 2.hp),

        FormElement(
          controller: controller.emailController,
          label: "Email",
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: 2.hp),

        SendInvitationAddFriend(),
      ],
    );
  }
}
