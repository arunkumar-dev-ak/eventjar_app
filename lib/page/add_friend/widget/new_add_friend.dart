import 'package:eventjar/controller/add_friend/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/form_element.dart';
import 'package:eventjar/page/add_friend/widget/send_invitation_add_friend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/country_picker_dialog.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
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

        IntlPhoneField(
          decoration: _phoneDecoration('Phone Number *', context),
          pickerDialogStyle: _pickerStyle(),
          initialCountryCode: controller.state.selectedCountry.value.code,
          onChanged: (_) {},
          onCountryChanged: (country) {
            controller.state.selectedCountry.value = country;
          },
          controller: controller.phoneController,
          validator: (value) {
            if (value == null || !value.isValidNumber()) {
              return 'Invalid phone number';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),

        SizedBox(height: 2.hp),

        FormElement(
          controller: controller.emailController,
          label: 'email'.tr,
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: 2.hp),

        SendInvitationAddFriend(),
      ],
    );
  }

  InputDecoration _phoneDecoration(String label, BuildContext context) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontSize: 10.sp,
        color: AppColors.textPrimary(context).withValues(alpha: 0.6),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.border(context), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.blue.shade300
              : Colors.blue.shade700,
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
      ),
      errorStyle: const TextStyle(height: 0),
    );
  }

  PickerDialogStyle _pickerStyle() {
    return PickerDialogStyle(
      countryNameStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 10.sp),
      countryCodeStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
    );
  }
}
