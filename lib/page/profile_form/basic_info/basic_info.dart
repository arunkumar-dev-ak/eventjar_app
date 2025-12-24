import 'package:eventjar/controller/profile_form/basic_info/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/profile_form/basic_info/basic_info_form_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Full name is required'
                      : null,
                ),
                SizedBox(height: 2.hp),

                // Username
                BasicInfoFormElement(
                  controller: controller.usernameController,
                  label: 'Username',
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Username is required'
                      : null,
                ),
                SizedBox(height: 2.hp),

                // Email
                BasicInfoFormElement(
                  controller: controller.emailController,
                  label: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(val.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.hp),

                // Mobile Number
                BasicInfoFormElement(
                  controller: controller.mobileController,
                  label: 'Mobile Number',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Mobile number is required'
                      : null,
                ),
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
    );
  }
}
