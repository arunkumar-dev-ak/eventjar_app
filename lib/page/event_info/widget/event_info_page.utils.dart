import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget eventInfoAppBarImageNotFound() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.grey.shade200,
          Colors.grey.shade300,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.image_outlined,
              color: Colors.grey.shade400,
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No Image Available',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget eventInfoAppBarImageShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade200,
    highlightColor: Colors.grey.shade50,
    period: const Duration(milliseconds: 1500),
    child: Container(color: Colors.grey.shade200),
  );
}
