import 'package:eventjar/controller/qualify_lead/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QualifyLeadActionButtons extends StatelessWidget {
  final QualifyLeadController controller;

  const QualifyLeadActionButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(vertical: 2.hp),
                textStyle: TextStyle(fontSize: 9.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: controller.state.isLoading.value
                  ? null
                  : () => controller.resetForm(),
              child: Text('Reset', style: TextStyle(fontSize: 9.sp)),
            ),
          ),
          SizedBox(width: 2.wp),
          Expanded(
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.hp),
                  textStyle: TextStyle(fontSize: 9.sp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  if (controller.state.isLoading.value) {
                    return;
                  }
                  if (controller.formKey.currentState?.validate() ?? false) {
                    controller.qualifyLead();
                  }
                },
                child: controller.state.isLoading.value
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text('Qualify Lead', style: TextStyle(fontSize: 9.sp)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
