import 'package:eventjar/controller/splashScreen/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/widget/full_screen_loader.dart';
import 'package:eventjar/page/splash_screen/widget/language_selection_popup.dart';
import 'package:eventjar/page/splash_screen/widget/network_animation_binder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../global/app_colors.dart';
import '../../global/widget/gradient_text.dart';

class SplashScreenPage extends GetView<SplashScreenController> {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/splash/splash_screen_bg.png',
              fit: BoxFit.cover,
              color: isDark ? Colors.black.withValues(alpha: 0.5) : null,
              colorBlendMode: isDark ? BlendMode.darken : null,
            ),
            // Dark overlay gradient for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          const Color(0xFF0a1e3d).withValues(alpha: 0.9),
                          const Color(0xFF0f2a4a).withValues(alpha: 0.85),
                          const Color(0xFF0a3d2a).withValues(alpha: 0.8),
                        ]
                      : [
                          const Color(0xFF1c56bf).withValues(alpha: 0.7),
                          const Color(0xFF2d5a87).withValues(alpha: 0.5),
                          const Color(0xFF1ceb8c).withValues(alpha: 0.3),
                        ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Network connecting animation
            AnimatedBuilder(
              animation: controller.mainAnimationController,
              builder: (context, child) {
                return NetworkAnimationWidget(
                  opacity: controller.networkOpacity.value,
                );
              },
            ),
            // Content
            SafeArea(
              child: AnimatedBuilder(
                animation: controller.mainAnimationController,
                builder: (context, child) {
                  return Column(
                    children: [
                      SizedBox(height: 12.hp),
                      // Main headings
                      _buildAnimatedText(
                        text: 'Connect.',
                        opacity: controller.connectOpacity.value,
                        offset: controller.connectSlide.value,
                        fontSize: 20.sp,
                      ),
                      _buildAnimatedText(
                        text: 'Collaborate.',
                        opacity: controller.collaborateOpacity.value,
                        offset: controller.collaborateSlide.value,
                        fontSize: 20.sp,
                      ),
                      _buildAnimatedText(
                        text: 'Grow.',
                        opacity: controller.growOpacity.value,
                        offset: controller.growSlide.value,
                        fontSize: 20.sp,
                      ),
                      SizedBox(height: 3.hp),
                      // Tagline
                      SlideTransition(
                        position: controller.taglineSlide,
                        child: Opacity(
                          opacity: controller.taglineOpacity.value,
                          child: Column(
                            children: [
                              Text(
                                'The smart networking app',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'for smart professionals.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Feature icons
                      Opacity(
                        opacity: controller.iconsOpacity.value,
                        child: Transform.scale(
                          scale: controller.iconsScale.value,
                          child: _buildFeatureIcons(),
                        ),
                      ),
                      SizedBox(height: 5.hp),
                      // Logo
                      Opacity(
                        opacity: controller.logoOpacity.value,
                        child: Transform.scale(
                          scale: controller.logoScale.value,
                          child: _buildLogo(),
                        ),
                      ),
                      SizedBox(height: 5.hp),
                    ],
                  );
                },
              ),
            ),

            // Language selection popup (first launch only)
            Obx(
              () => controller.state.showLanguagePopup.value
                  ? Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: LanguageSelectionPopup(
                        onLanguageSelected: controller.onLanguageSelected,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // loader for deeplink
            Obx(
              () => FullScreenLoader(
                isLoading: controller.state.isResolvingDeepLink.value,
                message: "Preparing your experience...",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedText({
    required String text,
    required double opacity,
    required Offset offset,
    required double fontSize,
  }) {
    return SlideTransition(
      position: AlwaysStoppedAnimation(offset),
      child: Opacity(
        opacity: opacity,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildFeatureIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconContainer(
          icon: Icons.qr_code_2,
          backgroundColor: Colors.white,
          iconColor: const Color(0xFF1a365d),
        ),
        SizedBox(width: 4.wp),
        _buildIconContainer(
          icon: Icons.contactless,
          backgroundColor: const Color(0xFF0891b2),
          iconColor: Colors.white,
        ),
        SizedBox(width: 4.wp),
        _buildIconContainer(
          icon: Icons.chat,
          backgroundColor: const Color(0xFF25D366),
          iconColor: Colors.white,
          isWhatsApp: true,
        ),
        SizedBox(width: 4.wp),
        _buildIconContainer(
          icon: Icons.email_outlined,
          backgroundColor: Colors.white,
          iconColor: const Color(0xFF1a365d),
        ),
      ],
    );
  }

  Widget _buildIconContainer({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    bool isWhatsApp = false,
  }) {
    return Builder(
      builder: (context) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        final bg = dark && backgroundColor == Colors.white
            ? Colors.white.withValues(alpha: 0.15)
            : backgroundColor;
        final ic = dark && iconColor == const Color(0xFF1a365d)
            ? Colors.white
            : iconColor;
        return Container(
          width: 12.wp,
          height: 12.wp,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.4 : 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: ic, size: 8.wp),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SvgPicture.asset(
        //   'assets/event_jar_logo.svg',
        //   width: 10.wp,
        //   height: 10.wp,
        //   // colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        // ),
        SizedBox(width: 2.wp),
        Builder(
          builder: (context) {
            final dark = Theme.of(context).brightness == Brightness.dark;
            return GradientText(
              textSize: 20.sp,
              content: "MyEventJar",
              gradientStart: dark ? AppColors.gradientLightStart : AppColors.gradientDarkStart,
              gradientEnd: dark ? AppColors.gradientLightEnd : AppColors.gradientDarkEnd,
              fontWeight: FontWeight.bold,
            );
          },
        ),
      ],
    );
  }
}
