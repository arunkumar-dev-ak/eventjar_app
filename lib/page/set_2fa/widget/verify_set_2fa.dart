import 'package:eventjar/controller/set_2fa/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/set_2fa/widget/enable_button_set_2fa.dart';
import 'package:eventjar/page/set_2fa/widget/instruction_section_2fa.dart';
import 'package:eventjar/page/set_2fa/widget/otp_input_set_2fa.dart';
import 'package:eventjar/page/set_2fa/widget/qr_code_set_2fa.dart';
import 'package:eventjar/page/set_2fa/widget/secret_set_2fa.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class Set2faVerifySection extends GetView<Set2faController> {
  const Set2faVerifySection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final data = state.secretData.value;

    if (data == null) return const SizedBox();

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.wp),
      child: Column(
        children: [
          SizedBox(height: 2.hp),

          // 🔐 ICON
          Container(
            padding: EdgeInsets.all(3.wp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withValues(alpha: 0.1),
            ),
            child: Icon(Icons.security, size: 28.sp, color: Colors.blue),
          ),

          SizedBox(height: 2.hp),

          Text(
            "Setup Your Authenticator App",
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.hp),

          Text(
            "Scan the QR code or enter the secret manually",
            style: TextStyle(fontSize: 9.sp, color: AppColors.textSecondary(context)),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 3.hp),

          QrCodeCard(qrCode: data.qrCode),

          SizedBox(height: 2.hp),

          buildOrDivider(),

          SizedBox(height: 2.hp),

          Text(
            "Enter this secret manually",
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 2.hp),

          SecretBox(secret: data.secret),

          SizedBox(height: 3.hp),

          const InstructionSection(),

          SizedBox(height: 3.hp),

          Set2faOtpInputSection(),

          SizedBox(height: 2.hp),

          Obx(() {
            if (state.error.value.isEmpty) return const SizedBox();
            return Text(
              state.error.value,
              style: TextStyle(color: Colors.red, fontSize: 8.sp),
            );
          }),

          SizedBox(height: 3.hp),

          Enable2FAButton(),
        ],
      ),
    );
  }

  Widget buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: AppColors.dividerStatic)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.wp),
          child: Text(
            "OR",
            style: TextStyle(
              color: AppColors.textHintStatic,
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        Expanded(child: Divider(thickness: 1, color: AppColors.dividerStatic)),
      ],
    );
  }
}
