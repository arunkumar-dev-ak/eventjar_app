import 'package:country_code_picker/country_code_picker.dart';
import 'package:eventjar/controller/profile_form/basic_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/page/profile_form/basic_info/basic_info_form_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intl_phone_field/country_picker_dialog.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:get/get.dart';

class BasicInfoPage extends GetView<BasicInfoFormController> {
  const BasicInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = 10.sp;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 4,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.5),
      ),
      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: SizedBox(
          width: 100.wp,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 3.hp),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name
                  BasicInfoFormElement(
                    controller: controller.fullNameController,
                    label: 'Full Name',
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Full name is required';
                      }
                      if (val.trim().length < 2) {
                        return 'Full name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.hp),

                  // Mobile Number
                  Obx(() {
                    return IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: 'Mobile Number *',
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.blue.shade700,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 2.0,
                          ),
                        ),
                        errorStyle: const TextStyle(height: 0),
                      ),
                      pickerDialogStyle: PickerDialogStyle(
                        countryNameStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                        ),
                        countryCodeStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      initialCountryCode:
                          controller.state.selectedCountry.value.code,
                      onChanged: (_) {},
                      onCountryChanged: (country) {
                        controller.state.selectedCountry.value = country;
                      },
                      controller: controller.mobileController,
                      validator: (value) {
                        if (value == null || !value.isValidNumber()) {
                          return 'Invalid phone number';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    );
                  }),

                  SizedBox(height: 2.hp),

                  // Professional Title
                  BasicInfoFormElement(
                    controller: controller.professionalTitleController,
                    label: 'Professional Title',
                    validator: (val) => null, // Optional field
                  ),
                  SizedBox(height: 3.hp),

                  // Buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.clearForm,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.wp,
                              vertical: 1.8.hp,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: Colors.blue.shade700,
                              width: 2,
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade700,
                            elevation: 0,
                          ),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: defaultFontSize,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.wp),
                      Expanded(
                        child: Obx(() {
                          final isLoading = controller.state.isLoading.value;
                          return ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Get.focusScope?.unfocus();
                                    controller.submitForm(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.wp,
                                vertical: 1.8.hp,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              shadowColor: Colors.blue.shade700.withValues(
                                alpha: 0.5,
                              ),
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    height: defaultFontSize,
                                    width: defaultFontSize,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Update Info',
                                    style: TextStyle(
                                      fontSize: defaultFontSize,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
