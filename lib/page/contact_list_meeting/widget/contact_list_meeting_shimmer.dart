import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContactListShimmerLoading extends StatelessWidget {
  const ContactListShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final placeholder = AppColors.border(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Shimmer.fromColors(
          baseColor: AppColors.divider(context),
          highlightColor: AppColors.scaffoldBg(context),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: placeholder,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Shimmer.fromColors(
          baseColor: AppColors.divider(context),
          highlightColor: AppColors.scaffoldBg(context),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: placeholder,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
