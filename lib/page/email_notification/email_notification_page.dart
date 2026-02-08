import 'package:eventjar/controller/email_notification/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/email_notification/widget/email_notification_form_element.dart';
import 'package:eventjar/page/email_notification/widget/email_notification_oauth_button.dart';
import 'package:eventjar/page/email_notification/widget/email_notification_setup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailNotificationPage extends GetView<EmailNotificationController> {
  const EmailNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = controller.state.provider.value!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Email Configuration",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 4,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.5),
      ),
      body: GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.wp),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Setup Instruction Card
                emailNotificationSetupCard(provider),

                SizedBox(height: 2.hp),

                // 🔹 OAuth Button
                if (provider.supportsOAuth == true &&
                    provider.oauthProvider != null)
                  emailNotificationOauthButton(provider),

                SizedBox(height: 2.hp),

                // 🔹 SMTP HOST
                EmailNotificationFormElement(
                  controller: controller.smtpHost,
                  label: 'SMTP Host *',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),

                SizedBox(height: 2.hp),

                // SMTP PORT
                EmailNotificationFormElement(
                  controller: controller.smtpPort,
                  label: 'SMTP Port *',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';

                    final port = int.tryParse(v);
                    if (port == null) return 'Port must be a number';
                    if (port < 1 || port > 65535) return 'Invalid port';

                    return null;
                  },
                ),

                SizedBox(height: 2.hp),

                // USERNAME
                EmailNotificationFormElement(
                  controller: controller.username,
                  label: 'Username / Email *',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),

                SizedBox(height: 2.hp),

                // PASSWORD
                Obx(
                  () => TextFormField(
                    controller: controller.password,
                    obscureText: !controller.state.showPassword.value,
                    style: TextStyle(fontSize: 10.sp),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: "*********",
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.state.showPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 18.sp,
                        ),
                        onPressed: controller.togglePassword,
                      ),
                      labelStyle: TextStyle(fontSize: 10.sp),
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
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),

                SizedBox(height: 2.hp),

                // FROM NAME
                EmailNotificationFormElement(
                  controller: controller.fromName,
                  label: 'From Name *',
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),

                SizedBox(height: 2.hp),

                // FROM EMAIL
                EmailNotificationFormElement(
                  controller: controller.fromEmail,
                  label: 'From Email *',
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';

                    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

                    if (!emailRegex.hasMatch(v)) return 'Enter valid email';

                    return null;
                  },
                ),

                SizedBox(height: 2.hp),

                // REPLY TO
                EmailNotificationFormElement(
                  controller: controller.replyToEmail,
                  label: 'Reply To Email (Optional)',
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;

                    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

                    if (!emailRegex.hasMatch(v)) return 'Enter valid email';

                    return null;
                  },
                ),

                SizedBox(height: 2.hp),

                // TLS SWITCH
                Obx(
                  () => SwitchListTile(
                    value: controller.state.isSecure.value,
                    onChanged: (v) => controller.state.isSecure.value = v,
                    title: const Text("Use Secure Connection (TLS/SSL)"),
                    subtitle: const Text(
                      "Enable secure connection to SMTP server",
                    ),
                  ),
                ),

                SizedBox(height: 3.hp),

                /// BUTTONS
                SafeArea(
                  child: Row(
                    children: [
                      /// Test Configuration
                      Expanded(
                        child: Obx(
                          () => OutlinedButton(
                            onPressed: controller.state.isTesting.value
                                ? null
                                : controller.testEmailConfig,
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
                            ),
                            child: controller.state.isTesting.value
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.blue.shade700,
                                    ),
                                  )
                                : Text(
                                    "Test Configuration",
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      SizedBox(width: 3.wp),

                      /// Save Email Settings
                      Expanded(
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.state.isLoading.value
                                ? null
                                : controller.saveEmailConfig,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.wp,
                                vertical: 1.8.hp,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              elevation: 5,
                            ),
                            child: controller.state.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Save Email Settings",
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w700,
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
        ),
      ),
    );
  }
}
