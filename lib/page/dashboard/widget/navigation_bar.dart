import 'dart:math' as math;

import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final DashboardController controller = Get.find();

  CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Obx(() {
      final selectedIndex = controller.state.selectedIndex.value;
      final isLoggedIn = controller.isLoggedIn.value;
      final profileData = controller.profile;

      return Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(top: BorderSide(color: borderColor, width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(
                  context: context,
                  filledIcon: Icons.home_rounded,
                  outlinedIcon: Icons.home_outlined,
                  label: "Home",
                  index: 0,
                  selectedIndex: selectedIndex,
                  isDark: isDark,
                ),
                _buildNavItem(
                  context: context,
                  filledIcon: LucideIcons.network,
                  outlinedIcon: LucideIcons.network,
                  label: "Network",
                  index: 1,
                  selectedIndex: selectedIndex,
                  isDark: isDark,
                ),
                _AnimatedCenterButton(
                  isSelected: selectedIndex == 2,
                  isLoggedIn: isLoggedIn,
                  profileData: profileData,
                  isDark: isDark,
                  onTap: () => controller.changeTab(2),
                ),
                _buildNavItem(
                  context: context,
                  filledIcon: FontAwesomeIcons.ticket,
                  outlinedIcon: LucideIcons.ticket,
                  label: "Tickets",
                  index: 3,
                  selectedIndex: selectedIndex,
                  isDark: isDark,
                  isFontAwesome: true,
                ),
                _buildNavItem(
                  context: context,
                  filledIcon: Icons.grid_view_rounded,
                  outlinedIcon: Icons.grid_view_outlined,
                  label: "More",
                  index: 4,
                  selectedIndex: selectedIndex,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData filledIcon,
    required IconData outlinedIcon,
    required String label,
    required int index,
    required int selectedIndex,
    required bool isDark,
    bool isFontAwesome = false,
  }) {
    final isSelected = index == selectedIndex;
    final activeColor = AppColors.gradientDarkStart;
    final inactiveColor = isDark ? Colors.grey.shade500 : Colors.grey.shade400;
    final color = isSelected ? activeColor : inactiveColor;
    final icon = isSelected ? filledIcon : outlinedIcon;

    Widget iconWidget;
    if (isFontAwesome) {
      iconWidget = FaIcon(icon, size: 26, color: color);
    } else if (isSelected && icon == LucideIcons.network) {
      // Lucide icons have no filled variant — simulate fill with stacked strokes
      iconWidget = SizedBox(
        width: 28,
        height: 28,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 28, color: color.withValues(alpha: 0.3)),
            Icon(icon, size: 26, color: color),
          ],
        ),
      );
    } else {
      iconWidget = Icon(icon, size: 28, color: color);
    }

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 7.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Animated Center Button with Flip + Rotating Ring ───

class _AnimatedCenterButton extends StatefulWidget {
  final bool isSelected;
  final bool isLoggedIn;
  final Map<String, dynamic> profileData;
  final bool isDark;
  final VoidCallback onTap;

  const _AnimatedCenterButton({
    required this.isSelected,
    required this.isLoggedIn,
    required this.profileData,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_AnimatedCenterButton> createState() => _AnimatedCenterButtonState();
}

class _AnimatedCenterButtonState extends State<_AnimatedCenterButton>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _flipController;

  @override
  void initState() {
    super.initState();

    // Rotating gradient ring — always runs
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    );

    if (!widget.isSelected) {
      _flipController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedCenterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      // Switched to profile tab — stop flip, reset to 0
      _flipController.stop();
      _flipController.reset();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      // Left profile tab — start flipping again
      _flipController.repeat();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 58,
        height: 58,
        child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _flipController]),
          builder: (context, _) {
            return CustomPaint(
              painter: _GlowRingPainter(
                rotationValue: _rotationController.value,
                isDark: widget.isDark,
              ),
              child: Center(
                child: _buildFlippingContent(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFlippingContent() {
    final bgColor = widget.isDark ? const Color(0xFF1A1A1A) : Colors.white;
    const innerSize = 40.0;

    // When profile tab is selected — no flip, just show "Profile"
    if (widget.isSelected) {
      return _buildElevatedCircle(innerSize, bgColor, _buildAccountText());
    }

    // On other tabs — flip between icon/avatar and "Profile" text
    final flipValue = _flipController.value;
    double angle;
    bool showBack;

    // 0.0  – 0.20 : hold front face (2.4s)
    // 0.20 – 0.45 : slow flip front → back (3s)
    // 0.45 – 0.65 : hold back face (2.4s)
    // 0.65 – 0.90 : slow flip back → front (3s)
    // 0.90 – 1.0  : hold front face (1.2s)
    if (flipValue <= 0.20) {
      angle = 0;
      showBack = false;
    } else if (flipValue <= 0.45) {
      final t = (flipValue - 0.20) / 0.25;
      final eased = Curves.easeInOut.transform(t);
      angle = eased * math.pi;
      showBack = angle > math.pi / 2;
    } else if (flipValue <= 0.65) {
      angle = math.pi;
      showBack = true;
    } else if (flipValue <= 0.90) {
      final t = (flipValue - 0.65) / 0.25;
      final eased = Curves.easeInOut.transform(t);
      angle = math.pi + eased * math.pi;
      showBack = angle < math.pi * 1.5;
    } else {
      angle = 0;
      showBack = false;
    }

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(angle),
      child: _buildElevatedCircle(
        innerSize,
        bgColor,
        showBack ? _buildBackFace() : _buildFrontFace(),
      ),
    );
  }

  Widget _buildElevatedCircle(double size, Color bgColor, Widget child) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientDarkStart.withValues(alpha: 0.25),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: widget.isDark ? 0.4 : 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }

  /// Front face — profile avatar or person icon
  Widget _buildFrontFace() {
    final profileData = widget.profileData;

    if (widget.isLoggedIn &&
        profileData.isNotEmpty &&
        _getDisplayName(profileData) != "User") {
      return ClipOval(
        child: SizedBox(
          width: 32,
          height: 32,
          child: profileData['avatarUrl'] != null &&
                  profileData['avatarUrl'].toString().isNotEmpty
              ? Image.network(
                  getFileUrl(profileData['avatarUrl']),
                  fit: BoxFit.cover,
                  width: 38,
                  height: 38,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildInitialsAvatar(name: profileData['name'] ?? ''),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildInitialsAvatar(
                      name: profileData['name'] ?? '',
                    );
                  },
                )
              : _buildInitialsAvatar(name: profileData['name'] ?? ''),
        ),
      );
    }

    return Icon(
      Icons.person_rounded,
      size: 24,
      color: widget.isSelected
          ? AppColors.gradientDarkStart
          : (widget.isDark ? Colors.grey.shade400 : Colors.grey.shade500),
    );
  }

  /// Static "Profile" text — used when profile tab is selected
  Widget _buildAccountText() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          AppColors.gradientDarkStart,
          AppColors.gradientDarkEnd,
        ],
      ).createShader(bounds),
      child: Text(
        "Profile",
        maxLines: 1,
        overflow: TextOverflow.visible,
        style: TextStyle(
          fontSize: 5.5.sp,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  /// Back face — "Profile" text (mirrored so it reads correctly during flip)
  Widget _buildBackFace() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: _buildAccountText(),
    );
  }

  String _getDisplayName(Map<String, dynamic> profileData) {
    if (profileData.isEmpty) return "User";
    return profileData['name'] ??
        profileData['username'] ??
        profileData['email']?.split('@').first ??
        "User";
  }

  Widget _buildInitialsAvatar({required String name}) {
    final initials = name.isNotEmpty
        ? name
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .join()
              .substring(0, 1)
        : '?';

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }
}

// ─── Glow Ring Painter ───

class _GlowRingPainter extends CustomPainter {
  final double rotationValue;
  final bool isDark;

  _GlowRingPainter({
    required this.rotationValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final angle = rotationValue * 2 * math.pi;

    // Outer glow — always visible
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    glowPaint.shader = SweepGradient(
      colors: [
        AppColors.gradientDarkStart.withValues(alpha: 0.0),
        AppColors.gradientDarkStart.withValues(alpha: 0.3),
        AppColors.gradientDarkEnd.withValues(alpha: 0.4),
        AppColors.gradientDarkStart.withValues(alpha: 0.3),
        AppColors.gradientDarkStart.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(angle),
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, glowPaint);

    // Main ring with rotating gradient — always visible
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    ringPaint.shader = SweepGradient(
      colors: const [
        AppColors.gradientDarkStart,
        AppColors.gradientDarkEnd,
        AppColors.gradientDarkStart,
      ],
      stops: const [0.0, 0.5, 1.0],
      transform: GradientRotation(angle),
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _GlowRingPainter oldDelegate) {
    return oldDelegate.rotationValue != rotationValue;
  }
}
