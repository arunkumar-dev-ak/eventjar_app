import 'package:flutter/material.dart';

class ScanQrCorner extends StatelessWidget {
  final Alignment alignment;

  const ScanQrCorner({required this.alignment, super.key});

  @override
  Widget build(BuildContext context) {
    final isTop =
        alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final isLeft =
        alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;

    return Positioned(
      top: isTop ? 0 : null,
      bottom: !isTop ? 0 : null,
      left: isLeft ? 0 : null,
      right: !isLeft ? 0 : null,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: isTop && isLeft ? const Radius.circular(12) : Radius.zero,
            topRight: isTop && !isLeft
                ? const Radius.circular(12)
                : Radius.zero,
            bottomLeft: !isTop && isLeft
                ? const Radius.circular(12)
                : Radius.zero,
            bottomRight: !isTop && !isLeft
                ? const Radius.circular(12)
                : Radius.zero,
          ),
        ),
      ),
    );
  }
}
