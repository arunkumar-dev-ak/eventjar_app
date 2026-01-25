import 'package:eventjar/controller/profile_form/social/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/profile_form/social_form/widget/social_form_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SocialFormPage extends GetView<SocialFormController> {
  const SocialFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultFontSize = 9.5.sp;

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
                  // LinkedIn
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.linkedin,
                            size: 14,
                            color: Colors.blue.shade600,
                          ),
                          SizedBox(width: 2.wp),
                          Text(
                            'LinkedIn Profile URL',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.hp),
                      SocialFormElement(
                        controller: controller.linkedinController,
                        label: '',
                        hintText: 'https://linkedin.com/in/yourprofile',
                        keyboardType: TextInputType.url,
                        validator: controller.linkedinValidator,
                      ),
                    ],
                  ),
                  SizedBox(height: 3.hp),

                  // WhatsApp / Telegram
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.commentDots,
                            size: 14,
                            color: Colors.green.shade600,
                          ),
                          SizedBox(width: 2.wp),
                          Text(
                            'WhatsApp / Telegram',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.hp),
                      SocialFormElement(
                        controller: controller.whatsappController,
                        label: '',
                        hintText: '+1234567890',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        // validator: controller.whatsappValidator,
                      ),
                    ],
                  ),
                  SizedBox(height: 3.hp),

                  // Instagram
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.instagram,
                            size: 14,
                            color: Colors.pink.shade400,
                          ),
                          SizedBox(width: 2.wp),
                          Text(
                            'Instagram',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.hp),
                      SocialFormElement(
                        controller: controller.instagramController,
                        label: '',
                        hintText: 'https://instagram.com/yourprofile',
                        keyboardType: TextInputType.url,
                        validator: controller.instagramValidator,
                      ),
                    ],
                  ),
                  SizedBox(height: 3.hp),

                  // Twitter
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.twitter,
                            size: 14,
                            color: Colors.blue.shade400,
                          ),
                          SizedBox(width: 2.wp),
                          Text(
                            'X (Twitter)',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.hp),
                      SocialFormElement(
                        controller: controller.twitterController,
                        label: '',
                        hintText: 'https://x.com/yourprofile',
                        keyboardType: TextInputType.url,
                        validator: controller.twitterValidator,
                      ),
                    ],
                  ),
                  SizedBox(height: 3.hp),

                  // Facebook
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.facebook,
                            size: 14,
                            color: Colors.blue.shade700,
                          ),
                          SizedBox(width: 2.wp),
                          Text(
                            'Facebook',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.hp),
                      SocialFormElement(
                        controller: controller.facebookController,
                        label: '',
                        hintText: 'https://facebook.com/yourprofile',
                        keyboardType: TextInputType.url,
                        validator: controller.facebookValidator,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.hp),

                  // Contact Visibility Toggle
                  Container(
                    padding: EdgeInsets.all(4.wp),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Visibility',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Allow other attendees to see your contact information',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => Switch(
                            value: controller.state.contactVisibility.value,
                            onChanged: (value) {
                              controller.state.contactVisibility.value = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.hp),

                  // Buttons
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
