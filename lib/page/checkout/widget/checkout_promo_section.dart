import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/checkout/widget/checkout_promo_code_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPromoSection extends StatelessWidget {
  const CheckoutPromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();

    return Obx(() {
      final promo = controller.state.promoCodeResponse.value;
      final isApplied =
          promo?.valid == true && (promo?.discountAmount ?? 0) > 0;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.wp),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: AppColors.shadow(context),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            // key: const PageStorageKey("promo_tile"),

            /// 🔥 Important: use value from GetX
            initiallyExpanded: controller.state.isPromoExpanded.value,

            onExpansionChanged: (val) {
              controller.state.isPromoExpanded.value = val;
            },

            tilePadding: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.hp),
            childrenPadding: EdgeInsets.fromLTRB(4.wp, 0, 4.wp, 3.hp),

            trailing: Icon(
              controller.state.isPromoExpanded.value
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 22,
              color: isApplied ? Colors.green : AppColors.textSecondary(context),
            ),

            title: Row(
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  size: 20,
                  color: isApplied ? Colors.green : AppColors.textSecondary(context),
                ),
                SizedBox(width: 3.wp),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isApplied ? "Promo Applied" : "Have a promo code?",
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.3.hp),
                      Text(
                        isApplied
                            ? "You saved ₹${promo!.discountAmount.toStringAsFixed(0)}"
                            : "Apply coupon & save instantly",
                        style: TextStyle(
                          fontSize: 8.5.sp,
                          color: isApplied
                              ? Colors.green
                              : AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            children: const [CheckoutPromoCodeSection()],
          ),
        ),
      );
    });
  }
}
