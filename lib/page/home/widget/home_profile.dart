import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/home/widget/scorecard/networking_scorecard.dart';
import 'package:eventjar/page/home/widget/scorecard/verification_scorecard.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../global/glitter.dart';

class HomeProfile extends GetView<HomeController> {
  const HomeProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoggedIn = controller.isLoggedIn.value;
      final isLoading = controller.state.isLoading.value;
      final profileData = controller.state.userProfile.value;
      if (!isLoggedIn) return _buildSignInCard();
      if (isLoading || profileData == null) {
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
                    ? (9.hp + (4 * 6.5.hp) + 1) - 9.hp + 3.7.hp
                    : 3.7.hp,
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
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 1.hp),
                                    Text(
                                      profileData.email,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 1.hp),
                                    Text(
                                      profileData.phone ?? "Yet to add",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 9.sp,
                                      ),
                                    ),
                                    if (profileData.phoneParsed?.countryCode !=
                                        null) ...[
                                      SizedBox(height: 0.8.hp),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: _AnimatedFlag(
                                          countryCode: profileData
                                              .phoneParsed!
                                              .countryCode,
                                        ),
                                      ),
                                    ],
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
              bottom: 0.7.hp,
              child: _buildNetworkingScoreCard(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSignInCard() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.signInPage);
      },
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
                size: 7.wp,
              ),
            ),
            SizedBox(width: 4.wp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign up or Log in to a account',
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
              size: 4.5.wp,
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
                          height: 1.7.hp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 0.8.hp),
                        Container(
                          width: 30.wp,
                          height: 1.2.hp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 0.6.hp),
                        Container(
                          width: 25.wp,
                          height: 1.2.hp,
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
                                width: 5.5.wp,
                                height: 5.5.wp,
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
              height: 9.hp,
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
      // return _buildNetworkScoreCard();
      return buildNetworkScoreCard();
    }
    // return _buildVerificationScoreCard();
    return buildVerificationScoreCard();
  }

  // --- Verification flow (incomplete steps) ---

  // Widget _buildVerificationScoreCard() {
  //   final pages = _buildVerificationPages();
  //   if (pages.isEmpty) return const SizedBox.shrink();

  //   final int totalPages = pages.length;
  //   final int currentPage = controller.scoreCardCurrentPage.clamp(
  //     0,
  //     totalPages - 1,
  //   );

  //   return Container(
  //     width: double.infinity,
  //     height: 9.hp,
  //     decoration: _scoreCardDecoration(),
  //     child: Column(
  //       children: [
  //         Expanded(
  //           child: Row(
  //             children: [
  //               GestureDetector(
  //                 onTap: currentPage > 0
  //                     ? () {
  //                         controller.scoreCardPageController.previousPage(
  //                           duration: const Duration(milliseconds: 300),
  //                           curve: Curves.easeInOut,
  //                         );
  //                       }
  //                     : null,
  //                 child: Container(
  //                   width: 7.wp,
  //                   height: double.infinity,
  //                   alignment: Alignment.center,
  //                   child: currentPage > 0
  //                       ? Icon(
  //                           Icons.chevron_left,
  //                           color: Colors.white,
  //                           size: 5.wp,
  //                         )
  //                       : SizedBox(width: 5.wp),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: PageView(
  //                   controller: controller.scoreCardPageController,
  //                   onPageChanged: (index) {
  //                     controller.state.scoreCardCurrentPage.value = index;
  //                     controller.resetAutoScrollTimer();
  //                   },
  //                   children: pages,
  //                 ),
  //               ),
  //               GestureDetector(
  //                 onTap: currentPage < totalPages - 1
  //                     ? () {
  //                         controller.scoreCardPageController.nextPage(
  //                           duration: const Duration(milliseconds: 300),
  //                           curve: Curves.easeInOut,
  //                         );
  //                       }
  //                     : null,
  //                 child: Container(
  //                   width: 7.wp,
  //                   height: double.infinity,
  //                   alignment: Alignment.center,
  //                   child: currentPage < totalPages - 1
  //                       ? Icon(
  //                           Icons.chevron_right,
  //                           color: Colors.white,
  //                           size: 5.wp,
  //                         )
  //                       : SizedBox(width: 5.wp),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         if (totalPages > 1)
  //           Padding(
  //             padding: EdgeInsets.only(bottom: 0.7.hp),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: List.generate(
  //                 totalPages,
  //                 (i) => AnimatedContainer(
  //                   duration: const Duration(milliseconds: 200),
  //                   margin: EdgeInsets.symmetric(horizontal: 0.8.wp),
  //                   width: i == currentPage ? 4.wp : 1.5.wp,
  //                   height: 0.7.hp,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(3),
  //                     color: i == currentPage
  //                         ? Colors.white
  //                         : Colors.white.withValues(alpha: 0.35),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // List<Widget> _buildVerificationPages() {
  //   final profile = controller.state.userProfile.value;
  //   if (profile == null) return [];

  //   final pending = <Widget>[];
  //   final completed = <Widget>[];

  //   // Phone verification
  //   if (!profile.phoneVerified) {
  //     pending.add(
  //       _buildActionPage(
  //         icon: Icons.phone_outlined,
  //         title: 'Verify number',
  //         subtitle: 'Confirm your phone number',
  //         buttonLabel: 'Verify',
  //         onTap: () => _showPhoneOtpDialog(Get.context!),
  //       ),
  //     );
  //   } else {
  //     completed.add(
  //       _buildActionPage(
  //         icon: Icons.phone_outlined,
  //         title: 'Number verified',
  //         subtitle: 'Phone number confirmed',
  //         isCompleted: true,
  //       ),
  //     );
  //   }

  //   // Email verification
  //   if (!profile.isVerified) {
  //     pending.add(
  //       _buildActionPage(
  //         icon: Icons.email_outlined,
  //         title: 'Verify email',
  //         subtitle: 'Confirm your email address',
  //         buttonLabel: 'Verify',
  //         onTap: () => _showEmailVerifyDialog(Get.context!),
  //       ),
  //     );
  //   } else {
  //     completed.add(
  //       _buildActionPage(
  //         icon: Icons.email_outlined,
  //         title: 'Email verified',
  //         subtitle: 'Email address confirmed',
  //         isCompleted: true,
  //       ),
  //     );
  //   }

  //   // Add contact
  //   if (!controller.hasAddedContact) {
  //     pending.add(
  //       _buildActionPage(
  //         icon: Icons.person_add_outlined,
  //         title: 'Add first contact',
  //         subtitle: 'Start building your network',
  //         buttonLabel: 'Add',
  //         onTap: () => controller.navigateToAddContact(),
  //       ),
  //     );
  //   } else {
  //     completed.add(
  //       _buildActionPage(
  //         icon: Icons.person_add_outlined,
  //         title: 'Contact added',
  //         subtitle: 'First contact saved',
  //         isCompleted: true,
  //       ),
  //     );
  //   }

  //   // Unverified first, then verified
  //   return [...pending, ...completed];
  // }

  // --- Networking score card (all steps complete) ---

  // static const _trophyTiers = [
  //   (
  //     name: 'Starter',
  //     range: '0 - 50',
  //     min: 0,
  //     max: 50,
  //     colorLight: Color(0xFFD4915E), // Bronze Light
  //     colorDark: Color(0xFF8B5A2B), // Bronze Dark
  //   ),
  //   (
  //     name: 'Connector',
  //     range: '51 - 250',
  //     min: 51,
  //     max: 250,
  //     colorLight: Color(0xFFE5E4E2), // silver Light
  //     colorDark: Color.fromARGB(255, 101, 101, 101), // silver Dark
  //   ),
  //   (
  //     name: 'Networker',
  //     range: '251 - 500',
  //     min: 251,
  //     max: 500,
  //     colorLight: Color(0xFFFFE066), // Gold Light
  //     colorDark: Color(0xFFB8860B), // Gold Dark
  //   ),
  //   (
  //     name: 'Champion',
  //     range: '501+',
  //     min: 501,
  //     max: 999999,
  //     colorLight: Color.fromARGB(255, 232, 170, 242), // Pinkish lavender shine
  //     colorDark: Color(0xFF7B1FA2), // Rich royal purple
  //   ),
  // ];

  // Widget _buildTrophyIcon({
  //   required Color colorLight,
  //   required Color colorDark,
  //   required double size,
  // }) {
  //   return ShaderMask(
  //     blendMode: BlendMode.srcIn,
  //     shaderCallback: (Rect bounds) {
  //       return LinearGradient(
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //         colors: [colorLight, colorDark],
  //       ).createShader(bounds);
  //     },
  //     child: Icon(Icons.emoji_events, size: size, color: Colors.white),
  //   );
  // }

  // Widget _buildNetworkScoreCard() {
  //   final isExpanded = controller.scoreCardExpanded;
  //   final tierIndex = controller.currentTierIndex;
  //   final tier = _trophyTiers[tierIndex];
  //   final contacts = controller.totalContacts;

  //   final textColor = Colors.white;

  //   return GestureDetector(
  //     onTap: controller.toggleScoreCard,
  //     child: AnimatedContainer(
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //       width: double.infinity,
  //       height: isExpanded ? 9.hp + (_trophyTiers.length * 6.5.hp) + 1 : 9.hp,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.only(
  //           bottomLeft: Radius.circular(14),
  //           bottomRight: Radius.circular(14),
  //         ),
  //         gradient: LinearGradient(
  //           colors: isExpanded
  //               ? const [
  //                   Color(0xFF0D47A1),
  //                   Color(0xFF1565C0),
  //                   Color(0xFF1E88E5),
  //                 ]
  //               : const [
  //                   Color(0xFF1565C0),
  //                   Color(0xFF1E88E5),
  //                   Color(0xFF42A5F5),
  //                 ],
  //           begin: Alignment.centerLeft,
  //           end: Alignment.centerRight,
  //         ),
  //         boxShadow: [
  //           BoxShadow(
  //             color: const Color(0xFF1565C0).withValues(alpha: 0.5),
  //             blurRadius: 20,
  //             spreadRadius: 2,
  //             offset: const Offset(0, 8),
  //           ),
  //           BoxShadow(
  //             color: Colors.black.withValues(alpha: 0.15),
  //             blurRadius: 10,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       clipBehavior: Clip.antiAlias,
  //       child: SingleChildScrollView(
  //         physics: const NeverScrollableScrollPhysics(),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Header (always visible)
  //             SizedBox(
  //               height: 9.hp,
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: 4.wp,
  //                   vertical: 1.2.hp,
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     _buildTrophyIcon(
  //                       colorLight: tier.colorLight,
  //                       colorDark: tier.colorDark,
  //                       size: 9.5.wp,
  //                     ),
  //                     SizedBox(width: 3.wp),
  //                     Expanded(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             tier.name,
  //                             style: TextStyle(
  //                               color: textColor,
  //                               fontSize: 9.5.sp,
  //                               fontWeight: FontWeight.w700,
  //                             ),
  //                           ),
  //                           SizedBox(height: 2),
  //                           Text(
  //                             '$contacts / ${tier.max > 9999 ? '500+' : tier.max} contacts',
  //                             style: TextStyle(
  //                               color: textColor.withValues(alpha: 0.7),
  //                               fontSize: 7.5.sp,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     AnimatedRotation(
  //                       turns: isExpanded ? 0.5 : 0,
  //                       duration: const Duration(milliseconds: 300),
  //                       child: Icon(
  //                         Icons.keyboard_arrow_down,
  //                         color: textColor,
  //                         size: 5.5.wp,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             // Divider + tier list (always rendered, clipped when collapsed)
  //             Container(
  //               width: double.infinity,
  //               height: 1,
  //               color: Colors.white.withValues(alpha: 0.4),
  //             ),
  //             ...List.generate(_trophyTiers.length, (i) {
  //               final t = _trophyTiers[i];
  //               final isCurrentTier = i == tierIndex;
  //               final isCompleted = i < tierIndex;
  //               final isLocked = i > tierIndex;

  //               final tierTextColor = isLocked
  //                   ? Colors.white.withValues(alpha: 0.35)
  //                   : Colors.white;
  //               final subTextColor = isLocked
  //                   ? Colors.white.withValues(alpha: 0.25)
  //                   : Colors.white.withValues(alpha: 0.7);

  //               return Container(
  //                 height: 6.5.hp,
  //                 padding: EdgeInsets.symmetric(horizontal: 4.wp),
  //                 decoration: isCurrentTier
  //                     ? BoxDecoration(
  //                         color: Colors.white.withValues(alpha: 0.1),
  //                       )
  //                     : null,
  //                 child: Row(
  //                   children: [
  //                     _buildTrophyIcon(
  //                       colorLight: t.colorLight,
  //                       colorDark: t.colorDark,
  //                       size: 7.5.wp,
  //                     ),
  //                     SizedBox(width: 3.wp),
  //                     Expanded(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             t.name,
  //                             style: TextStyle(
  //                               color: tierTextColor,
  //                               fontSize: 8.5.sp,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                           ),
  //                           SizedBox(height: 1),
  //                           Text(
  //                             '${t.range} contacts',
  //                             style: TextStyle(
  //                               color: subTextColor,
  //                               fontSize: 7.sp,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     if (isCompleted)
  //                       Icon(
  //                         Icons.check_circle,
  //                         color: const Color(0xFF69F0AE),
  //                         size: 5.wp,
  //                       ),
  //                     if (isCurrentTier)
  //                       Container(
  //                         padding: EdgeInsets.symmetric(
  //                           horizontal: 2.wp,
  //                           vertical: 2,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           color: Colors.white.withValues(alpha: 0.2),
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         child: Text(
  //                           'Current',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 6.5.sp,
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                         ),
  //                       ),
  //                     if (isLocked)
  //                       Icon(
  //                         Icons.lock_outline,
  //                         color: Colors.white.withValues(alpha: 0.3),
  //                         size: 4.5.wp,
  //                       ),
  //                   ],
  //                 ),
  //               );
  //             }),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // BoxDecoration _scoreCardDecoration() {
  //   return BoxDecoration(
  //     borderRadius: BorderRadius.only(
  //       bottomLeft: Radius.circular(14),
  //       bottomRight: Radius.circular(14),
  //     ),
  //     gradient: const LinearGradient(
  //       colors: [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF42A5F5)],
  //       begin: Alignment.centerLeft,
  //       end: Alignment.centerRight,
  //     ),
  //     boxShadow: [
  //       BoxShadow(
  //         color: const Color(0xFF1565C0).withValues(alpha: 0.5),
  //         blurRadius: 20,
  //         spreadRadius: 2,
  //         offset: const Offset(0, 8),
  //       ),
  //       BoxShadow(
  //         color: Colors.black.withValues(alpha: 0.15),
  //         blurRadius: 10,
  //         offset: const Offset(0, 4),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildActionPage({
  //   required IconData icon,
  //   required String title,
  //   required String subtitle,
  //   String? buttonLabel,
  //   VoidCallback? onTap,
  //   bool isCompleted = false,
  // }) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.5.hp),
  //     child: Row(
  //       children: [
  //         Icon(icon, color: Colors.white, size: 5.wp),
  //         SizedBox(width: 2.wp),
  //         Expanded(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 9.sp,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //               SizedBox(height: 2),
  //               Text(
  //                 subtitle,
  //                 style: TextStyle(
  //                   color: Colors.white.withValues(alpha: 0.8),
  //                   fontSize: 7.5.sp,
  //                 ),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ],
  //           ),
  //         ),
  //         if (isCompleted)
  //           Icon(Icons.check_circle, color: Colors.greenAccent, size: 5.wp),
  //         if (!isCompleted && buttonLabel != null) ...[
  //           SizedBox(width: 1.5.wp),
  //           GestureDetector(
  //             onTap: onTap,
  //             child: Container(
  //               padding: EdgeInsets.symmetric(
  //                 horizontal: 2.5.wp,
  //                 vertical: 0.6.hp,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(8),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withValues(alpha: 0.1),
  //                     blurRadius: 4,
  //                     offset: const Offset(0, 2),
  //                   ),
  //                 ],
  //               ),
  //               child: Text(
  //                 buttonLabel,
  //                 style: TextStyle(
  //                   color: const Color(0xFF1565C0),
  //                   fontSize: 7.5.sp,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  // void _showPhoneOtpDialog(BuildContext context) async {
  //   if (controller.state.isSendingOtp.value) return;
  //   final phone = controller.state.userProfile.value?.phone ?? '';
  //   controller.resetOtpState();

  //   // Send OTP first
  //   final success = await controller.sendPhoneOtp();

  //   if (!success || !context.mounted) return;

  //   final pinController = TextEditingController();
  //   final focusNode = FocusNode();

  //   showModalBottomSheet<void>(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext ctx) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           bottom: MediaQuery.of(ctx).viewInsets.bottom,
  //         ),
  //         child: Stack(
  //           alignment: Alignment.topCenter,
  //           children: [
  //             Container(
  //               margin: EdgeInsets.only(top: 5.5.hp),
  //               padding: EdgeInsets.only(
  //                 top: 7.hp,
  //                 left: 6.wp,
  //                 right: 6.wp,
  //                 bottom: 3.hp,
  //               ),
  //               decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(25),
  //                   topRight: Radius.circular(25),
  //                 ),
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(
  //                     'Verify Phone Number',
  //                     style: TextStyle(
  //                       fontSize: 12.sp,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.grey.shade900,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   SizedBox(height: 1.hp),
  //                   Text(
  //                     'Enter the 6-digit code sent to\n$phone',
  //                     style: TextStyle(
  //                       fontSize: 9.sp,
  //                       color: AppColors.placeHolderColor,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   SizedBox(height: 3.5.hp),

  //                   // Pinput OTP field
  //                   Pinput(
  //                     length: 6,
  //                     controller: pinController,
  //                     focusNode: focusNode,
  //                     autofocus: true,
  //                     keyboardType: TextInputType.number,
  //                     defaultPinTheme: PinTheme(
  //                       width: 12.wp,
  //                       height: 6.5.hp,
  //                       textStyle: TextStyle(
  //                         fontSize: 12.sp,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.grey.shade900,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: Colors.grey.shade50,
  //                         borderRadius: BorderRadius.circular(12),
  //                         border: Border.all(color: Colors.grey.shade300),
  //                       ),
  //                     ),
  //                     focusedPinTheme: PinTheme(
  //                       width: 12.wp,
  //                       height: 6.5.hp,
  //                       textStyle: TextStyle(
  //                         fontSize: 12.sp,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.grey.shade900,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(12),
  //                         border: Border.all(
  //                           color: AppColors.gradientDarkStart,
  //                           width: 2,
  //                         ),
  //                       ),
  //                     ),
  //                     errorPinTheme: PinTheme(
  //                       width: 12.wp,
  //                       height: 6.5.hp,
  //                       textStyle: TextStyle(
  //                         fontSize: 12.sp,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.red,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: Colors.red.shade50,
  //                         borderRadius: BorderRadius.circular(12),
  //                         border: Border.all(color: Colors.red.shade300),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 1.hp),

  //                   // Error message
  //                   Obx(() {
  //                     final error = controller.state.otpError.value;
  //                     if (error.isEmpty) return const SizedBox.shrink();
  //                     return Padding(
  //                       padding: EdgeInsets.only(top: 0.5.hp),
  //                       child: Text(
  //                         error,
  //                         style: TextStyle(
  //                           color: Colors.red.shade600,
  //                           fontSize: 8.sp,
  //                         ),
  //                         textAlign: TextAlign.center,
  //                       ),
  //                     );
  //                   }),

  //                   SizedBox(height: 1.5.hp),

  //                   // Resend OTP
  //                   Obx(() {
  //                     final cooldown = controller.state.resendCooldown.value;
  //                     return Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Text(
  //                           "Didn't receive the code? ",
  //                           style: TextStyle(
  //                             fontSize: 8.sp,
  //                             color: AppColors.placeHolderColor,
  //                           ),
  //                         ),
  //                         GestureDetector(
  //                           onTap:
  //                               cooldown > 0 ||
  //                                   controller.state.isSendingOtp.value
  //                               ? null
  //                               : () => controller.sendPhoneOtp(),
  //                           child: Text(
  //                             cooldown > 0
  //                                 ? 'Resend in ${cooldown}s'
  //                                 : 'Resend',
  //                             style: TextStyle(
  //                               fontSize: 8.sp,
  //                               color: cooldown > 0
  //                                   ? AppColors.placeHolderColor
  //                                   : AppColors.gradientDarkStart,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     );
  //                   }),

  //                   SizedBox(height: 3.hp),

  //                   // Verify button
  //                   Obx(
  //                     () => SizedBox(
  //                       width: double.infinity,
  //                       height: 6.5.hp,
  //                       child: Material(
  //                         color: Colors.transparent,
  //                         child: InkWell(
  //                           borderRadius: BorderRadius.circular(14),
  //                           onTap: controller.state.isVerifyingOtp.value
  //                               ? null
  //                               : () async {
  //                                   final otp = pinController.text.trim();
  //                                   if (otp.length < 6) {
  //                                     controller.state.otpError.value =
  //                                         'Please enter the full 6-digit code';
  //                                     return;
  //                                   }
  //                                   final success = await controller
  //                                       .verifyPhoneOtp(otp);
  //                                   if (success && ctx.mounted) {
  //                                     Navigator.of(ctx).pop();
  //                                   }
  //                                 },
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(14),
  //                               gradient: controller.state.isVerifyingOtp.value
  //                                   ? AppColors.disabledButtonGradient
  //                                   : AppColors.buttonGradient,
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: AppColors.gradientDarkEnd.withValues(
  //                                     alpha: 0.3,
  //                                   ),
  //                                   blurRadius: 12,
  //                                   offset: const Offset(0, 4),
  //                                 ),
  //                               ],
  //                             ),
  //                             child: Center(
  //                               child: controller.state.isVerifyingOtp.value
  //                                   ? SizedBox(
  //                                       width: 5.5.wp,
  //                                       height: 5.5.wp,
  //                                       child: const CircularProgressIndicator(
  //                                         color: Colors.white,
  //                                         strokeWidth: 2.5,
  //                                       ),
  //                                     )
  //                                   : Text(
  //                                       'Verify',
  //                                       style: TextStyle(
  //                                         color: Colors.white,
  //                                         fontSize: 11.sp,
  //                                         fontWeight: FontWeight.bold,
  //                                       ),
  //                                     ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),

  //                   SizedBox(height: 2.hp),
  //                 ],
  //               ),
  //             ),

  //             // Circle icon at top
  //             Container(
  //               width: 22.wp,
  //               height: 22.wp,
  //               decoration: BoxDecoration(
  //                 gradient: AppColors.buttonGradient,
  //                 shape: BoxShape.circle,
  //                 border: Border.all(color: Colors.white, width: 4),
  //               ),
  //               child: Icon(
  //                 Icons.phone_android_rounded,
  //                 color: Colors.white,
  //                 size: 9.wp,
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   ).then((_) {
  //     pinController.dispose();
  //     focusNode.dispose();
  //   });
  // }

  // void _showEmailVerifyDialog(BuildContext context) async {
  //   final email = controller.state.userProfile.value?.email ?? '';

  //   final success = await controller.sendEmailVerification();
  //   if (!success || !context.mounted) return;

  //   showModalBottomSheet<void>(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext ctx) {
  //       return Stack(
  //         alignment: Alignment.topCenter,
  //         children: [
  //           Container(
  //             margin: EdgeInsets.only(top: 6.hp),
  //             padding: EdgeInsets.only(
  //               top: 7.5.hp,
  //               left: 6.wp,
  //               right: 6.wp,
  //               bottom: 3.hp,
  //             ),
  //             decoration: const BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(25),
  //                 topRight: Radius.circular(25),
  //               ),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   'Check your email',
  //                   style: TextStyle(
  //                     fontSize: 16.sp,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.grey.shade900,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(height: 1.2.hp),
  //                 Text(
  //                   'A verification link has been sent to\n$email',
  //                   style: TextStyle(
  //                     fontSize: 11.sp,
  //                     color: AppColors.placeHolderColor,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(height: 2.5.hp),
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.of(ctx).pop();
  //                     controller.openEmailApp();
  //                   },
  //                   child: Container(
  //                     width: 90.wp,
  //                     height: 7.5.hp,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(16.0),
  //                       gradient: AppColors.buttonGradient,
  //                     ),
  //                     child: Center(
  //                       child: Text(
  //                         'Open Email',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 11.sp,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             width: 24.wp,
  //             height: 24.wp,
  //             decoration: BoxDecoration(
  //               gradient: AppColors.buttonGradient,
  //               shape: BoxShape.circle,
  //               border: Border.all(color: Colors.white, width: 4),
  //             ),
  //             child: Icon(Icons.email, color: Colors.white, size: 10.wp),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Widget _buildBadgeMedals() {
  //   final medals = [
  //     Medal(
  //       baseColor: const Color(0xFFE8913A),
  //       highlightColor: const Color(0xFFFFD4A8),
  //       shadowColor: const Color(0xFFB5651D),
  //       enabled: true,
  //       name: 'Bronze',
  //     ),
  //     Medal(
  //       baseColor: const Color(0xFFFF8C42),
  //       highlightColor: const Color(0xFFFFBE8A),
  //       shadowColor: const Color(0xFFD4652F),
  //       enabled: true,
  //       name: 'Copper',
  //     ),
  //     Medal(
  //       baseColor: const Color(0xFF707070),
  //       highlightColor: const Color(0xFFA0A0A0),
  //       shadowColor: const Color(0xFF404040),
  //       enabled: true,
  //       name: 'Silver',
  //     ),
  //     Medal(
  //       baseColor: const Color(0xFFFFE033),
  //       highlightColor: const Color(0xFFFFF9C4),
  //       shadowColor: const Color(0xFFDAA520),
  //       enabled: true,
  //       name: 'Gold',
  //     ),
  //     Medal(
  //       baseColor: const Color(0xFF1E88E5),
  //       highlightColor: const Color(0xFF64B5F6),
  //       shadowColor: const Color(0xFF0D47A1),
  //       enabled: true,
  //       name: 'Diamond',
  //     ),
  //     Medal(
  //       baseColor: const Color(0xFF4CAF50),
  //       highlightColor: const Color(0xFF81C784),
  //       shadowColor: const Color(0xFF2E7D32),
  //       enabled: true,
  //       name: 'Platinum',
  //     ),
  //   ];

  //   return Row(
  //     children: [
  //       ...medals.map(
  //         (medal) => Padding(
  //           padding: EdgeInsets.only(right: 0.5.wp),
  //           child: _buildMedalBadge(medal),
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: () {},
  //         child: Container(
  //           width: 4.5.wp,
  //           height: 4.5.wp,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: Colors.white,
  //             border: Border.all(color: const Color(0xFF1A73E8), width: 1.2),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: const Color(0xFF1A73E8).withValues(alpha: 0.15),
  //                 blurRadius: 2,
  //                 offset: const Offset(0, 1),
  //               ),
  //             ],
  //           ),
  //           child: Icon(Icons.add, size: 3.wp, color: const Color(0xFF1A73E8)),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildMedalBadge(Medal medal) {
  //   final double size = 5.5.wp;

  //   if (!medal.enabled) {
  //     return Icon(Icons.military_tech, size: size, color: Colors.grey[400]);
  //   }

  //   return ShaderMask(
  //     blendMode: BlendMode.srcIn,
  //     shaderCallback: (Rect bounds) {
  //       return LinearGradient(
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //         colors: [medal.highlightColor, medal.baseColor, medal.shadowColor],
  //         stops: const [0.0, 0.5, 1.0],
  //       ).createShader(bounds);
  //     },
  //     child: Icon(
  //       Icons.military_tech,
  //       size: size,
  //       color: Colors.white,
  //       shadows: [
  //         Shadow(
  //           color: medal.shadowColor.withValues(alpha: 0.5),
  //           blurRadius: 2,
  //           offset: const Offset(0, 1),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class _AnimatedFlag extends StatefulWidget {
  final String countryCode;

  const _AnimatedFlag({required this.countryCode});

  @override
  State<_AnimatedFlag> createState() => _AnimatedFlagState();
}

class _AnimatedFlagState extends State<_AnimatedFlag>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flag = _dialCodeToFlag(widget.countryCode);
    if (flag == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Colors.transparent,
                Colors.white70,
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + 2.0 * _shimmerController.value, -0.3),
              end: Alignment(0.0 + 2.0 * _shimmerController.value, 0.3),
            ).createShader(bounds);
          },
          child: child!,
        );
      },
      child: Text(flag, style: TextStyle(fontSize: 14.sp)),
    );
  }

  static String? _dialCodeToFlag(String dialCode) {
    final code = dialCode.replaceAll('+', '').trim();
    final iso = _dialCodeToIso[code];
    if (iso == null || iso.length != 2) return null;

    // Convert ISO 3166-1 alpha-2 to flag emoji
    final flagOffset = 0x1F1E6;
    final asciiOffset = 0x41;
    final first = iso.codeUnitAt(0) - asciiOffset + flagOffset;
    final second = iso.codeUnitAt(1) - asciiOffset + flagOffset;
    return String.fromCharCodes([first, second]);
  }

  static const _dialCodeToIso = {
    '1': 'US',
    '7': 'RU',
    '20': 'EG',
    '27': 'ZA',
    '30': 'GR',
    '31': 'NL',
    '32': 'BE',
    '33': 'FR',
    '34': 'ES',
    '36': 'HU',
    '39': 'IT',
    '40': 'RO',
    '41': 'CH',
    '43': 'AT',
    '44': 'GB',
    '45': 'DK',
    '46': 'SE',
    '47': 'NO',
    '48': 'PL',
    '49': 'DE',
    '51': 'PE',
    '52': 'MX',
    '53': 'CU',
    '54': 'AR',
    '55': 'BR',
    '56': 'CL',
    '57': 'CO',
    '58': 'VE',
    '60': 'MY',
    '61': 'AU',
    '62': 'ID',
    '63': 'PH',
    '64': 'NZ',
    '65': 'SG',
    '66': 'TH',
    '81': 'JP',
    '82': 'KR',
    '84': 'VN',
    '86': 'CN',
    '90': 'TR',
    '91': 'IN',
    '92': 'PK',
    '93': 'AF',
    '94': 'LK',
    '95': 'MM',
    '98': 'IR',
    '211': 'SS',
    '212': 'MA',
    '213': 'DZ',
    '216': 'TN',
    '218': 'LY',
    '220': 'GM',
    '221': 'SN',
    '222': 'MR',
    '223': 'ML',
    '224': 'GN',
    '225': 'CI',
    '226': 'BF',
    '227': 'NE',
    '228': 'TG',
    '229': 'BJ',
    '230': 'MU',
    '231': 'LR',
    '232': 'SL',
    '233': 'GH',
    '234': 'NG',
    '235': 'TD',
    '236': 'CF',
    '237': 'CM',
    '238': 'CV',
    '239': 'ST',
    '240': 'GQ',
    '241': 'GA',
    '242': 'CG',
    '243': 'CD',
    '244': 'AO',
    '245': 'GW',
    '246': 'IO',
    '247': 'AC',
    '248': 'SC',
    '249': 'SD',
    '250': 'RW',
    '251': 'ET',
    '252': 'SO',
    '253': 'DJ',
    '254': 'KE',
    '255': 'TZ',
    '256': 'UG',
    '257': 'BI',
    '258': 'MZ',
    '260': 'ZM',
    '261': 'MG',
    '262': 'RE',
    '263': 'ZW',
    '264': 'NA',
    '265': 'MW',
    '266': 'LS',
    '267': 'BW',
    '268': 'SZ',
    '269': 'KM',
    '290': 'SH',
    '291': 'ER',
    '297': 'AW',
    '298': 'FO',
    '299': 'GL',
    '350': 'GI',
    '351': 'PT',
    '352': 'LU',
    '353': 'IE',
    '354': 'IS',
    '355': 'AL',
    '356': 'MT',
    '357': 'CY',
    '358': 'FI',
    '359': 'BG',
    '370': 'LT',
    '371': 'LV',
    '372': 'EE',
    '373': 'MD',
    '374': 'AM',
    '375': 'BY',
    '376': 'AD',
    '377': 'MC',
    '378': 'SM',
    '380': 'UA',
    '381': 'RS',
    '382': 'ME',
    '385': 'HR',
    '386': 'SI',
    '387': 'BA',
    '389': 'MK',
    '420': 'CZ',
    '421': 'SK',
    '423': 'LI',
    '500': 'FK',
    '501': 'BZ',
    '502': 'GT',
    '503': 'SV',
    '504': 'HN',
    '505': 'NI',
    '506': 'CR',
    '507': 'PA',
    '508': 'PM',
    '509': 'HT',
    '590': 'GP',
    '591': 'BO',
    '592': 'GY',
    '593': 'EC',
    '594': 'GF',
    '595': 'PY',
    '596': 'MQ',
    '597': 'SR',
    '598': 'UY',
    '599': 'CW',
    '670': 'TL',
    '672': 'NF',
    '673': 'BN',
    '674': 'NR',
    '675': 'PG',
    '676': 'TO',
    '677': 'SB',
    '678': 'VU',
    '679': 'FJ',
    '680': 'PW',
    '681': 'WF',
    '682': 'CK',
    '683': 'NU',
    '685': 'WS',
    '686': 'KI',
    '687': 'NC',
    '688': 'TV',
    '689': 'PF',
    '690': 'TK',
    '691': 'FM',
    '692': 'MH',
    '850': 'KP',
    '852': 'HK',
    '853': 'MO',
    '855': 'KH',
    '856': 'LA',
    '880': 'BD',
    '886': 'TW',
    '960': 'MV',
    '961': 'LB',
    '962': 'JO',
    '963': 'SY',
    '964': 'IQ',
    '965': 'KW',
    '966': 'SA',
    '967': 'YE',
    '968': 'OM',
    '970': 'PS',
    '971': 'AE',
    '972': 'IL',
    '973': 'BH',
    '974': 'QA',
    '975': 'BT',
    '976': 'MN',
    '977': 'NP',
    '992': 'TJ',
    '993': 'TM',
    '994': 'AZ',
    '995': 'GE',
    '996': 'KG',
    '998': 'UZ',
  };
}
