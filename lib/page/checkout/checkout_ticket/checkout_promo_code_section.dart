import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventjar/controller/checkout/controller.dart';

class CheckoutPromoCodeSection extends GetView<CheckoutController> {
  const CheckoutPromoCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final promo = controller.state.promoCodeResponse.value;
      final isLoading = controller.state.isPromoLoading.value;

      final bool isApplied = promo?.valid == true;
      final bool hasError = promo != null && promo.valid == false;

      return Container(
        margin: EdgeInsets.only(top: 2.hp),
        padding: EdgeInsets.all(3.wp),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: ,
          children: [
            /// Title
            Text(
              "Savings Corner",
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 1.2.hp),

            /// Input + Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.promoCodeController,
                    enabled: !isApplied && !isLoading,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: "Enter promo code",
                      errorText: hasError ? promo!.message : null,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 3.wp,
                        vertical: 1.2.hp,
                      ),
                      filled: true,
                      fillColor: isApplied
                          ? Colors.grey.shade100
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    style: TextStyle(fontSize: 8.5.sp),
                  ),
                ),
                SizedBox(width: 2.wp),

                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : isApplied
                        ? controller.removePromoCode
                        : controller.validatePromoCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isApplied
                          ? Colors.red.shade400
                          : Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            isApplied ? "Remove" : "Apply",
                            style: TextStyle(
                              fontSize: 8.5.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),

            /// Success Message
            if (isApplied) ...[
              SizedBox(height: 1.hp),
              Text(
                "Promo applied • You saved ₹${promo!.discountAmount.toStringAsFixed(2)} 🎉",
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
