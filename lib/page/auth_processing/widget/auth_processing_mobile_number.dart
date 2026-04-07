import 'package:eventjar/controller/auth_processing/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/auth_processing/widget/auth_processing_back_button.dart';
import 'package:eventjar/page/auth_processing/widget/auth_processing_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/country_picker_dialog.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:get/get.dart';

class AuthProcessignMobileNumber extends GetView<AuthProcessingController> {
  const AuthProcessignMobileNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.wp,
      decoration: const BoxDecoration(gradient: AppColors.appBarGradient),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*----- Back Button -----*/
            const AuthProcessingBackButton(),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*----- Header -----*/
                  Padding(
                    padding: EdgeInsets.only(
                      left: 6.wp,
                      top: 2.hp,
                      bottom: 4.hp,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Almost Done",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.hp),
                        Text(
                          "Please provide your mobile number to complete your profile.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /*----- White Form Container -----*/
                  Expanded(
                    child: Container(
                      width: 100.wp,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 6.wp,
                          right: 6.wp,
                          top: 5.hp, // Spacing from top of white curve
                          bottom: 5.wp,
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                            key: controller.state.formKey,
                            child: Column(
                              children: [
                                // IntlPhoneField exactly as requested
                                IntlPhoneField(
                                  decoration: _phoneDecoration(
                                    'Phone Number *',
                                  ),
                                  pickerDialogStyle: _pickerStyle(),
                                  initialCountryCode: 'IN',
                                  onChanged: (phone) {
                                    // Optional: Update controller with full number
                                  },
                                  onCountryChanged: (country) {
                                    controller.state.selectedCountry.value =
                                        country;
                                  },
                                  controller: controller.state.mobileController,
                                  validator: (value) {
                                    if (value == null ||
                                        !value.isValidNumber()) {
                                      return 'Invalid phone number';
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  focusNode: controller.phoneFocusNode,
                                ),

                                SizedBox(height: 4.hp),

                                /*----- Submit Button -----*/
                                const AuthProcessingSubmitButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted decoration methods
  InputDecoration _phoneDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 10.sp),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.borderStatic, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.isDark ? Colors.blue.shade300 : Colors.blue.shade700, width: 2.0),
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
      countryCodeStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    );
  }
}
