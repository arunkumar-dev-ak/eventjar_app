import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget eventInfoAppBarImageNotFound() {
  return Stack(
    fit: StackFit.expand,
    children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.1),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 35,
        ),
      ),
    ],
  );
}

Widget eventInfoAppBarImageShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(color: Colors.grey.shade300),
  );
}
