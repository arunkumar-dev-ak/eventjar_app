import 'package:flutter/material.dart';

class ExpenseShimmerCard extends StatelessWidget {
  const ExpenseShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
