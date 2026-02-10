import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shimmer/shimmer.dart';

import '../../../global/glitter.dart';
import '../../../model/home/home_model.dart';

class HomeProfile extends GetView<HomeController> {
  const HomeProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoggedIn = controller.isLoggedIn.value;
      final profileData = controller.state.userProfile.value;
      if (!isLoggedIn) return _buildSignInCard();
      if (profileData == null) {
        return _buildShimmerProfile();
      }
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Profile Card Background with Glitter
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: double.infinity,
              margin: EdgeInsets.only(
                bottom:
                    controller.allStepsComplete && controller.scoreCardExpanded
                    ? (72.0 + (4 * 52.0) + 1) - 72 + 30
                    : 30,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE3F2FD),
                    Color(0xFFBBDEFB),
                    Color(0xFF90CAF9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: GlitterPainter()),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.wp, 1.hp, 3.wp, 1.hp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: profileData.avatarUrl == null
                                    ? Image.asset(
                                        'assets/king.png',
                                        width: 24.wp,
                                        height: 28.wp,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        profileData.avatarUrl!,
                                        width: 30.wp,
                                        height: 30.wp,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(width: 4.wp),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profileData.name.toString().toUpperCase(),
                                      style: TextStyle(
                                        color: const Color(0xFF1A1A2E),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 1.hp),
                                    Text(
                                      profileData.email,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 1.hp),
                                    Text(
                                      profileData.phone ?? "Yet to add",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    //SizedBox(height: 1.hp),
                                    //_buildBadgeMedals(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.5.hp),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Floating Networking Score Card
            Positioned(
              left: 2.5.wp,
              right: 2.5.wp,
              bottom: 6,
              child: _buildNetworkingScoreCard(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSignInCard() {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteName.signInPage),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
        padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 2.hp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF42A5F5)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1565C0).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.5.wp),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            SizedBox(width: 4.wp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign up or Log in to your account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 0.5.hp),
                  Text(
                    'Access your profile, events & contacts',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 7.5.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerProfile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.wp, vertical: 1.5.hp),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.fromLTRB(3.wp, 1.hp, 3.wp, 1.hp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 24.wp,
                    height: 28.wp,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  SizedBox(width: 4.wp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40.wp,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 0.8.hp),
                        Container(
                          width: 30.wp,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 0.6.hp),
                        Container(
                          width: 25.wp,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 1.hp),
                        Row(
                          children: List.generate(
                            6,
                            (_) => Padding(
                              padding: EdgeInsets.only(right: 0.5.wp),
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.5.hp),
            Container(
              width: double.infinity,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkingScoreCard() {
    if (controller.allStepsComplete) {
      return _buildNetworkScoreCard();
    }
    return _buildVerificationScoreCard();
  }

  // --- Verification flow (incomplete steps) ---

  Widget _buildVerificationScoreCard() {
    final pages = _buildVerificationPages();
    if (pages.isEmpty) return const SizedBox.shrink();

    final int totalPages = pages.length;
    final int currentPage = controller.scoreCardCurrentPage.clamp(
      0,
      totalPages - 1,
    );

    return Container(
      width: double.infinity,
      height: 72,
      decoration: _scoreCardDecoration(),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: currentPage > 0
                      ? () {
                          controller.scoreCardPageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  child: Container(
                    width: 28,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: currentPage > 0
                        ? Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 20,
                          )
                        : SizedBox(width: 20),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: controller.scoreCardPageController,
                    onPageChanged: (index) {
                      controller.state.scoreCardCurrentPage.value = index;
                      controller.resetAutoScrollTimer();
                    },
                    children: pages,
                  ),
                ),
                GestureDetector(
                  onTap: currentPage < totalPages - 1
                      ? () {
                          controller.scoreCardPageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  child: Container(
                    width: 28,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: currentPage < totalPages - 1
                        ? Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 20,
                          )
                        : SizedBox(width: 20),
                  ),
                ),
              ],
            ),
          ),
          if (totalPages > 1)
            Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  totalPages,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    width: i == currentPage ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: i == currentPage
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildVerificationPages() {
    final profile = controller.state.userProfile.value;
    if (profile == null) return [];

    final pending = <Widget>[];
    final completed = <Widget>[];

    // Phone verification
    if (!profile.phoneVerified) {
      pending.add(
        _buildActionPage(
          icon: Icons.phone_outlined,
          title: 'Verify number',
          subtitle: 'Confirm your phone number',
          buttonLabel: 'Verify',
          onTap: () => _showPhoneOtpDialog(Get.context!),
        ),
      );
    } else {
      completed.add(
        _buildActionPage(
          icon: Icons.phone_outlined,
          title: 'Number verified',
          subtitle: 'Phone number confirmed',
          isCompleted: true,
        ),
      );
    }

    // Email verification
    if (!profile.isVerified) {
      pending.add(
        _buildActionPage(
          icon: Icons.email_outlined,
          title: 'Verify email',
          subtitle: 'Confirm your email address',
          buttonLabel: 'Verify',
          onTap: () => _showEmailVerifyDialog(Get.context!),
        ),
      );
    } else {
      completed.add(
        _buildActionPage(
          icon: Icons.email_outlined,
          title: 'Email verified',
          subtitle: 'Email address confirmed',
          isCompleted: true,
        ),
      );
    }

    // Add contact
    if (!controller.hasAddedContact) {
      pending.add(
        _buildActionPage(
          icon: Icons.person_add_outlined,
          title: 'Add first contact',
          subtitle: 'Start building your network',
          buttonLabel: 'Add',
          onTap: () => controller.navigateToAddContact(),
        ),
      );
    } else {
      completed.add(
        _buildActionPage(
          icon: Icons.person_add_outlined,
          title: 'Contact added',
          subtitle: 'First contact saved',
          isCompleted: true,
        ),
      );
    }

    // Unverified first, then verified
    return [...pending, ...completed];
  }

  // --- Networking score card (all steps complete) ---

  static const _trophyTiers = [
    (
      name: 'Starter',
      range: '0 - 50',
      min: 0,
      max: 50,
      color: Color(0xFFB8860B),
    ),
    (
      name: 'Connector',
      range: '51 - 250',
      min: 51,
      max: 250,
      color: Color(0xFFDAA520),
    ),
    (
      name: 'Networker',
      range: '251 - 500',
      min: 251,
      max: 500,
      color: Color(0xFFC49000),
    ),
    (
      name: 'Champion',
      range: '500+',
      min: 501,
      max: 999999,
      color: Color(0xFFB8860B),
    ),
  ];

  Widget _buildNetworkScoreCard() {
    final isExpanded = controller.scoreCardExpanded;
    final tierIndex = controller.currentTierIndex;
    final tier = _trophyTiers[tierIndex];
    final contacts = controller.totalContacts;

    final textColor = isExpanded ? const Color(0xFF0D47A1) : Colors.white;

    return GestureDetector(
      onTap: controller.toggleScoreCard,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: isExpanded ? 72.0 + (_trophyTiers.length * 52.0) + 1 : 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(14),
          ),
          gradient: LinearGradient(
            colors: isExpanded
                ? const [
                    Color(0xFF90CAF9),
                    Color(0xFF64B5F6),
                    Color(0xFF42A5F5),
                  ]
                : const [
                    Color(0xFF1565C0),
                    Color(0xFF1E88E5),
                    Color(0xFF42A5F5),
                  ],
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
                height: 72,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.wp,
                    vertical: 1.2.hp,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.emoji_events, color: tier.color, size: 28),
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
                          size: 22,
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
                    ? const Color(0xFF0D47A1).withValues(alpha: 0.35)
                    : const Color(0xFF0D47A1);
                final subTextColor = isLocked
                    ? const Color(0xFF0D47A1).withValues(alpha: 0.25)
                    : const Color(0xFF0D47A1).withValues(alpha: 0.6);

                return Container(
                  height: 52,
                  padding: EdgeInsets.symmetric(horizontal: 4.wp),
                  decoration: isCurrentTier
                      ? BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.35),
                        )
                      : null,
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: isLocked ? Colors.grey[400] : t.color,
                        size: 24,
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
                          color: const Color(0xFF2E7D32),
                          size: 20,
                        ),
                      if (isCurrentTier)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.wp,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1565C0),
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
                          color: Colors.grey[400],
                          size: 18,
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

  BoxDecoration _scoreCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(14),
        bottomRight: Radius.circular(14),
      ),
      gradient: const LinearGradient(
        colors: [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF42A5F5)],
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
    );
  }

  Widget _buildActionPage({
    required IconData icon,
    required String title,
    required String subtitle,
    String? buttonLabel,
    VoidCallback? onTap,
    bool isCompleted = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 1.hp),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(width: 3.wp),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 7.5.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isCompleted)
            Icon(Icons.check_circle, color: Colors.greenAccent, size: 22),
          if (!isCompleted && buttonLabel != null) ...[
            SizedBox(width: 2.wp),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.wp,
                  vertical: 0.8.hp,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  buttonLabel,
                  style: TextStyle(
                    color: const Color(0xFF1565C0),
                    fontSize: 7.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showPhoneOtpDialog(BuildContext context) async {
    final phone = controller.state.userProfile.value?.phone ?? '';
    controller.resetOtpState();

    // Send OTP first
    await controller.sendPhoneOtp();

    if (!context.mounted) return;

    final pinController = TextEditingController();
    final focusNode = FocusNode();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 45),
                padding: const EdgeInsets.only(
                  top: 55,
                  left: 24,
                  right: 24,
                  bottom: 24,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Verify Phone Number',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the 6-digit code sent to\n$phone',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.placeHolderColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // Pinput OTP field
                    Pinput(
                      length: 6,
                      controller: pinController,
                      focusNode: focusNode,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      defaultPinTheme: PinTheme(
                        width: 48,
                        height: 52,
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 48,
                        height: 52,
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.gradientDarkStart,
                            width: 2,
                          ),
                        ),
                      ),
                      errorPinTheme: PinTheme(
                        width: 48,
                        height: 52,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Error message
                    Obx(() {
                      final error = controller.state.otpError.value;
                      if (error.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 8.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),

                    const SizedBox(height: 12),

                    // Resend OTP
                    Obx(() {
                      final cooldown = controller.state.resendCooldown.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive the code? ",
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: AppColors.placeHolderColor,
                            ),
                          ),
                          GestureDetector(
                            onTap:
                                cooldown > 0 ||
                                    controller.state.isSendingOtp.value
                                ? null
                                : () => controller.sendPhoneOtp(),
                            child: Text(
                              cooldown > 0
                                  ? 'Resend in ${cooldown}s'
                                  : 'Resend',
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: cooldown > 0
                                    ? AppColors.placeHolderColor
                                    : AppColors.gradientDarkStart,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 24),

                    // Verify button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: controller.state.isVerifyingOtp.value
                                ? null
                                : () async {
                                    final otp = pinController.text.trim();
                                    if (otp.length < 6) {
                                      controller.state.otpError.value =
                                          'Please enter the full 6-digit code';
                                      return;
                                    }
                                    final success = await controller
                                        .verifyPhoneOtp(otp);
                                    if (success && ctx.mounted) {
                                      Navigator.of(ctx).pop();
                                    }
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: controller.state.isVerifyingOtp.value
                                    ? AppColors.disabledButtonGradient
                                    : AppColors.buttonGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gradientDarkEnd.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: controller.state.isVerifyingOtp.value
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        'Verify',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Circle icon at top
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: const Icon(
                  Icons.phone_android_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      pinController.dispose();
      focusNode.dispose();
    });
  }

  void _showEmailVerifyDialog(BuildContext context) async {
    final email = controller.state.userProfile.value?.email ?? '';

    final success = await controller.sendEmailVerification();
    if (!success || !context.mounted) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Check your email',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'A verification link has been sent to\n$email',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.placeHolderColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      controller.openEmailApp();
                    },
                    child: Container(
                      width: 90.wp,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        gradient: AppColors.buttonGradient,
                      ),
                      child: Center(
                        child: Text(
                          'Open Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: const Icon(Icons.email, color: Colors.white, size: 40),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBadgeMedals() {
    final medals = [
      Medal(
        baseColor: const Color(0xFFE8913A),
        highlightColor: const Color(0xFFFFD4A8),
        shadowColor: const Color(0xFFB5651D),
        enabled: true,
        name: 'Bronze',
      ),
      Medal(
        baseColor: const Color(0xFFFF8C42),
        highlightColor: const Color(0xFFFFBE8A),
        shadowColor: const Color(0xFFD4652F),
        enabled: true,
        name: 'Copper',
      ),
      Medal(
        baseColor: const Color(0xFF707070),
        highlightColor: const Color(0xFFA0A0A0),
        shadowColor: const Color(0xFF404040),
        enabled: true,
        name: 'Silver',
      ),
      Medal(
        baseColor: const Color(0xFFFFE033),
        highlightColor: const Color(0xFFFFF9C4),
        shadowColor: const Color(0xFFDAA520),
        enabled: true,
        name: 'Gold',
      ),
      Medal(
        baseColor: const Color(0xFF1E88E5),
        highlightColor: const Color(0xFF64B5F6),
        shadowColor: const Color(0xFF0D47A1),
        enabled: true,
        name: 'Diamond',
      ),
      Medal(
        baseColor: const Color(0xFF4CAF50),
        highlightColor: const Color(0xFF81C784),
        shadowColor: const Color(0xFF2E7D32),
        enabled: true,
        name: 'Platinum',
      ),
    ];

    return Row(
      children: [
        ...medals.map(
          (medal) => Padding(
            padding: EdgeInsets.only(right: 0.5.wp),
            child: _buildMedalBadge(medal),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFF1A73E8), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A73E8).withValues(alpha: 0.15),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(Icons.add, size: 11, color: const Color(0xFF1A73E8)),
          ),
        ),
      ],
    );
  }

  Widget _buildMedalBadge(Medal medal) {
    const double size = 22;

    if (!medal.enabled) {
      return Icon(Icons.military_tech, size: size, color: Colors.grey[400]);
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [medal.highlightColor, medal.baseColor, medal.shadowColor],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(bounds);
      },
      child: Icon(
        Icons.military_tech,
        size: size,
        color: Colors.white,
        shadows: [
          Shadow(
            color: medal.shadowColor.withValues(alpha: 0.5),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
