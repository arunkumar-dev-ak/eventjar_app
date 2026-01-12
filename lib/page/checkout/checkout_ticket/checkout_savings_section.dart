import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/checkout/checkout_ticket/checkout_promo_code_section.dart';
import 'package:flutter/material.dart';

Widget buildCheckoutSavingsSection() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4.wp),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.orange.shade100, width: 2),
      boxShadow: [
        BoxShadow(
          color: Colors.orange.shade50,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Theme(
      // Remove default divider + splash
      data: ThemeData(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 4.wp),
        childrenPadding: EdgeInsets.fromLTRB(4.wp, 0, 4.wp, 4.wp),
        initiallyExpanded: false,

        // Header
        title: Row(
          children: [
            Icon(
              Icons.local_offer_outlined,
              color: Colors.orange.shade700,
              size: 20,
            ),
            SizedBox(width: 2.wp),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Savings Corner",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
                Text(
                  "Apply coupon & save instantly",
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Expand / Collapse icon
        trailing: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.orange.shade700,
          size: 26,
        ),

        // Expanded Content
        children: const [CheckoutPromoCodeSection()],
      ),
    ),
  );
}
