import 'package:country_code_picker/country_code_picker.dart';
import 'package:eventjar/controller/profile_form/business_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/profile_form/business_info/widget/business_category_dropdown.dart';
import 'package:eventjar/page/profile_form/business_info/widget/business_info_form_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BusinessInfoPage extends GetView<BusinessInfoFormController> {
  const BusinessInfoPage({super.key});

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
                  // Business Name
                  BusinessInfoFormElement(
                    controller: controller.businessNameController,
                    label: 'Business Name',
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Business name is required'
                        : null,
                  ),
                  SizedBox(height: 2.hp),

                  // Business Category Dropdown
                  BusinessCategoryDropdown(),
                  SizedBox(height: 2.hp),

                  // Business Website
                  BusinessInfoFormElement(
                    controller: controller.businessWebsiteController,
                    label: 'Business Website',
                    keyboardType: TextInputType.url,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return null;
                      }
                      final urlRegex = RegExp(
                        r'^https?://(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
                      );
                      return urlRegex.hasMatch(val.trim())
                          ? null
                          : 'Enter valid URL';
                    },
                  ),
                  SizedBox(height: 2.hp),

                  // Business Email
                  BusinessInfoFormElement(
                    controller: controller.businessEmailController,
                    label: 'Business Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return null;
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      return emailRegex.hasMatch(val.trim())
                          ? null
                          : 'Enter valid email';
                    },
                  ),
                  SizedBox(height: 2.hp),

                  // Business Phone
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Country code picker
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: CountryCodePicker(
                          onChanged: (country) {
                            controller.state.selectedCountryCode.value =
                                country.dialCode ?? '+91';
                          },
                          initialSelection: 'IN',
                          favorite: const ['+91', 'IN'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          dialogBackgroundColor: Colors.white,
                          textStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: defaultFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Phone TextFormField
                      Expanded(
                        child: BusinessInfoFormElement(
                          controller: controller.businessPhoneController,
                          label: 'Business Phone',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(15),
                          ],
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Business phone is required'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.hp),

                  // Business Address
                  BusinessInfoFormElement(
                    controller: controller.businessAddressController,
                    label: 'Business Address',
                    maxLines: 2,
                  ),
                  SizedBox(height: 2.hp),

                  // Years In Business
                  BusinessInfoFormElement(
                    controller: controller.yearsInBusinessController,
                    label: 'Years In Business',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3), // Max 999 years
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return null;
                      }
                      final years = int.tryParse(val.trim());
                      return years != null && years >= 0 && years <= 100
                          ? null
                          : 'Enter valid years (0-100)';
                    },
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
                            'Clear',
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
                                    controller.submitForm();
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
