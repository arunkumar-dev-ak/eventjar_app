import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildNetworkScoreCard() {
  final HomeController controller = Get.find<HomeController>();
  final isExpanded = controller.scoreCardExpanded;
  final tierIndex = controller.currentTierIndex;
  final tier = _trophyTiers[tierIndex];
  final contacts = controller.totalContacts;

  final textColor = Colors.white;

  return GestureDetector(
    onTap: controller.toggleScoreCard,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: isExpanded ? 9.hp + (_trophyTiers.length * 6.5.hp) + 1 : 9.hp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
        gradient: LinearGradient(
          colors: isExpanded
              ? const [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)]
              : const [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF42A5F5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header (always visible)
            SizedBox(
              height: 9.hp,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.wp,
                  vertical: 1.2.hp,
                ),
                child: Row(
                  children: [
                    _buildTrophyIcon(
                      colorLight: tier.colorLight,
                      colorDark: tier.colorDark,
                      size: 9.5.wp,
                    ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tier.name,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '$contacts / ${tier.max > 9999 ? '500+' : tier.max} contacts',
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.7),
                              fontSize: 7.5.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: textColor,
                        size: 5.5.wp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Divider + tier list (always rendered, clipped when collapsed)
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.white.withValues(alpha: 0.4),
            ),
            ...List.generate(_trophyTiers.length, (i) {
              final t = _trophyTiers[i];
              final isCurrentTier = i == tierIndex;
              final isCompleted = i < tierIndex;
              final isLocked = i > tierIndex;

              final tierTextColor = isLocked
                  ? Colors.white.withValues(alpha: 0.35)
                  : Colors.white;
              final subTextColor = isLocked
                  ? Colors.white.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.7);

              return Container(
                height: 6.5.hp,
                padding: EdgeInsets.symmetric(horizontal: 4.wp),
                decoration: isCurrentTier
                    ? BoxDecoration(color: Colors.white.withValues(alpha: 0.1))
                    : null,
                child: Row(
                  children: [
                    _buildTrophyIcon(
                      colorLight: t.colorLight,
                      colorDark: t.colorDark,
                      size: 7.5.wp,
                    ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.name,
                            style: TextStyle(
                              color: tierTextColor,
                              fontSize: 8.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            '${t.range} contacts',
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 7.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCompleted)
                      Icon(
                        Icons.check_circle,
                        color: const Color(0xFF69F0AE),
                        size: 5.wp,
                      ),
                    if (isCurrentTier)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.wp,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Current',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (isLocked)
                      Icon(
                        Icons.lock_outline,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 4.5.wp,
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    ),
  );
}

const _trophyTiers = [
  (
    name: 'Starter',
    range: '0 - 50',
    min: 0,
    max: 50,
    colorLight: Color(0xFFD4915E), // Bronze Light
    colorDark: Color(0xFF8B5A2B), // Bronze Dark
  ),
  (
    name: 'Connector',
    range: '51 - 250',
    min: 51,
    max: 250,
    colorLight: Color(0xFFE5E4E2), // silver Light
    colorDark: Color.fromARGB(255, 101, 101, 101), // silver Dark
  ),
  (
    name: 'Networker',
    range: '251 - 500',
    min: 251,
    max: 500,
    colorLight: Color(0xFFFFE066), // Gold Light
    colorDark: Color(0xFFB8860B), // Gold Dark
  ),
  (
    name: 'Champion',
    range: '501+',
    min: 501,
    max: 999999,
    colorLight: Color.fromARGB(255, 232, 170, 242), // Pinkish lavender shine
    colorDark: Color(0xFF7B1FA2), // Rich royal purple
  ),
];

Widget _buildTrophyIcon({
  required Color colorLight,
  required Color colorDark,
  required double size,
}) {
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [colorLight, colorDark],
      ).createShader(bounds);
    },
    child: Icon(Icons.emoji_events, size: size, color: Colors.white),
  );
}
