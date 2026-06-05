import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WhatsappNotificationShimmer extends StatelessWidget {
  const WhatsappNotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final placeholder = AppColors.border(context);

    return ListView.builder(
      padding: EdgeInsets.all(4.wp),
      itemCount: 3,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.divider(context),
        highlightColor: AppColors.scaffoldBg(context),
        child: Container(
          margin: EdgeInsets.only(bottom: 2.hp),
          height: 12.hp,
          decoration: BoxDecoration(
            color: placeholder,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
