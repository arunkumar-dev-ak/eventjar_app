import 'dart:math' as math;

import '../../controller/scan_card/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/responsive/responsive.dart';

class ScanCard extends GetView<ScanCardController> {
  const ScanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [
              //     Color(0xFF1C56BF).withValues(alpha: 0.2),
              //     Color(0xFF167B4D).withValues(alpha: 0.1),
              //     Colors.white,
              //   ],
              // ),
            ),
          ),
          // Floating icons background
          _buildFloatingIcons(),
          // Main content
          SafeArea(
            child: controller.isInitialized
                ? FadeTransition(
                    opacity: controller.fadeAnimation,
                    child: Column(
                      children: [
                        //  _buildAppBar(cardController),
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: 2.hp),
                                  _buildImagePreview(),
                                  SizedBox(height: 4.hp),
                                  _buildResults(),
                                  SizedBox(height: 10.hp),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        // Hide bottom navigation when card details are shown
        if (controller.cardInfo.value.hasData) {
          return const SizedBox.shrink();
        }
        return _buildBottomNavigation();
      }),
    );
  }

  Widget _buildImagePreview() {
    return Obx(() {
      final image = controller.selectedImage.value;
      final isLoading = controller.isLoading.value;

      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: image == null ? Colors.white : null,
          gradient: image == null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    controller.primaryColor.withValues(alpha: 0.08),
                    controller.secondaryColor.withValues(alpha: 0.08),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: controller.primaryColor.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: controller.primaryColor.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              if (image != null)
                Image.file(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              else
                _buildPlaceholder(),
              if (isLoading) _buildScanningOverlay(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [controller.primaryColor, controller.secondaryColor],
            ).createShader(bounds),
            child: const Icon(
              Icons.credit_card_rounded,
              size: 72,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2.hp),
          Text(
            'Scan a Visting card to begin',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.hp),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: controller.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app, size: 16, color: controller.primaryColor),
                SizedBox(width: 2.wp),
                Text(
                  'Tap Camera or Gallery below',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: controller.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: controller.scanLineAnimation,
            builder: (context, child) {
              return Positioned(
                top: controller.scanLineAnimation.value * 220,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        controller.secondaryColor.withValues(alpha: 0.8),
                        controller.secondaryColor,
                        controller.secondaryColor.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: controller.secondaryColor.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLoadingIndicator(),
                const SizedBox(height: 16),
                const Text(
                  'Scanning...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(controller.secondaryColor),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: controller.primaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(top: false, child: _buildScanButtons()),
    );
  }

  Widget _buildScanButtons() {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      return Row(
        children: [
          Expanded(
            child: _buildAnimatedButton(
              icon: Icons.camera_alt_rounded,
              label: 'Camera',
              onPressed: isLoading ? null : controller.pickImageFromCamera,
              isPrimary: true,
              delay: 0,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildAnimatedButton(
              icon: Icons.photo_library_rounded,
              label: 'Gallery',
              onPressed: isLoading ? null : controller.pickImageFromGallery,
              isPrimary: false,
              delay: 100,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildResults() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox.shrink();
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return _buildErrorCard(controller.errorMessage.value);
      }

      final info = controller.cardInfo.value;
      if (!info.hasData) {
        return const SizedBox.shrink();
      }

      return _buildResultsCard(info);
    });
  }

  Widget _buildErrorCard(String message) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade50,
                    Colors.red.shade100.withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsCard(dynamic info) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: controller.primaryColor.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          controller.primaryColor.withValues(alpha: 0.1),
                          controller.secondaryColor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                controller.primaryColor,
                                controller.secondaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Card Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: controller.primaryColor,
                                ),
                              ),
                              Text(
                                'Successfully extracted',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.red),
                          onPressed: controller.clearData,
                          tooltip: 'Clear',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (info.name != null)
                          _buildInfoRow(
                            Icons.person_outline,
                            'Name',
                            info.name!,
                            0,
                          ),
                        if (info.email != null)
                          _buildInfoRow(
                            Icons.email_outlined,
                            'Email',
                            info.email!,
                            1,
                          ),
                        if (info.phone != null)
                          _buildInfoRow(
                            Icons.phone_outlined,
                            'Phone',
                            info.phone!,
                            2,
                          ),
                        SizedBox(height: 2.hp),

                        _buildAnimatedButton(
                          icon: Icons.save_as,
                          label: 'Edit or Save',
                          onPressed: () {
                            controller.navigateToAddContact();
                          },
                          isPrimary: true,
                          delay: 0,
                        ),

                        //_buildRawTextSection(info),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - animValue), 0),
          child: Opacity(
            opacity: animValue,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          controller.primaryColor.withValues(alpha: 0.1),
                          controller.secondaryColor.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 20, color: controller.primaryColor),
                  ),
                  SizedBox(width: 4.wp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 0.5.hp),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.copy_rounded,
                  //     size: 20,
                  //     color: Colors.grey[400],
                  //   ),
                  //   onPressed: () {
                  //     Clipboard.setData(ClipboardData(text: value));
                  //     Get.snackbar(
                  //       'Copied',
                  //       '$label copied to clipboard',
                  //       snackPosition: SnackPosition.BOTTOM,
                  //       duration: const Duration(seconds: 2),
                  //       backgroundColor: controller.secondaryColor,
                  //       colorText: Colors.white,
                  //       margin: const EdgeInsets.all(16),
                  //       borderRadius: 12,
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget _buildRawTextSection(dynamic info) {
  //   return Builder(
  //     builder: (context) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
  //         child: ExpansionTile(
  //           tilePadding: const EdgeInsets.symmetric(horizontal: 4),
  //           title: Row(
  //             children: [
  //               Icon(
  //                 Icons.text_snippet_outlined,
  //                 size: 20,
  //                 color: Colors.grey[600],
  //               ),
  //               const SizedBox(width: 10),
  //               Text(
  //                 'Raw Text',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.grey[700],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           children: [
  //             Container(
  //               width: double.infinity,
  //               padding: const EdgeInsets.all(14),
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[100],
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Stack(
  //                 children: [
  //                   SelectableText(
  //                     info.rawText ?? 'No text extracted',
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.grey[800],
  //                       height: 1.5,
  //                     ),
  //                   ),
  //                   Positioned(
  //                     top: 0,
  //                     right: 0,
  //                     child: IconButton(
  //                       icon: Icon(
  //                         Icons.copy_rounded,
  //                         size: 18,
  //                         color: Colors.grey[500],
  //                       ),
  //                       onPressed: () {
  //                         if (info.rawText != null) {
  //                           Clipboard.setData(
  //                             ClipboardData(text: info.rawText!),
  //                           );
  //                           Get.snackbar(
  //                             'Copied',
  //                             'Raw text copied to clipboard',
  //                             snackPosition: SnackPosition.BOTTOM,
  //                             duration: const Duration(seconds: 2),
  //                             backgroundColor: controller.secondaryColor,
  //                             colorText: Colors.white,
  //                             margin: const EdgeInsets.all(16),
  //                             borderRadius: 12,
  //                           );
  //                         }
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildAnimatedButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required bool isPrimary,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isPrimary
                  ? LinearGradient(
                      colors: [controller.primaryColor, Color(0xFF2A6AD4)],
                    )
                  : LinearGradient(
                      colors: [controller.secondaryColor, Color(0xFF1E9960)],
                    ),
              boxShadow: [
                BoxShadow(
                  color:
                      (isPrimary
                              ? controller.primaryColor
                              : controller.secondaryColor)
                          .withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingIcons() {
    final icons = [
      _FloatingIconData(
        icon: Icons.credit_card_rounded,
        startX: 0.1,
        startY: 0.15,
        size: 40,
        color: controller.primaryColor,
        delay: 0.0,
      ),
      _FloatingIconData(
        icon: Icons.contact_mail_rounded,
        startX: 0.85,
        startY: 0.2,
        size: 35,
        color: controller.secondaryColor,
        delay: 0.2,
      ),
      _FloatingIconData(
        icon: Icons.badge_rounded,
        startX: 0.15,
        startY: 0.7,
        size: 32,
        color: controller.primaryColor,
        delay: 0.4,
      ),
      _FloatingIconData(
        icon: Icons.person_pin_rounded,
        startX: 0.9,
        startY: 0.65,
        size: 38,
        color: controller.secondaryColor,
        delay: 0.6,
      ),
      _FloatingIconData(
        icon: Icons.card_membership_rounded,
        startX: 0.5,
        startY: 0.08,
        size: 30,
        color: controller.primaryColor,
        delay: 0.3,
      ),
      _FloatingIconData(
        icon: Icons.contacts_rounded,
        startX: 0.75,
        startY: 0.85,
        size: 34,
        color: controller.secondaryColor,
        delay: 0.5,
      ),
    ];

    if (!controller.isInitialized) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: controller.floatingIconsController,
      builder: (context, child) {
        return Stack(
          children: icons.map((iconData) {
            final progress =
                (controller.floatingIconsController.value + iconData.delay) %
                1.0;
            final yOffset = math.sin(progress * 2 * math.pi) * 15;
            final rotation = math.sin(progress * 2 * math.pi) * 0.1;
            final scale = 1.0 + math.sin(progress * 2 * math.pi) * 0.1;

            return Positioned(
              left:
                  MediaQuery.of(context).size.width * iconData.startX -
                  iconData.size / 2,
              top:
                  MediaQuery.of(context).size.height * iconData.startY +
                  yOffset,
              child: Transform.rotate(
                angle: rotation,
                child: Transform.scale(
                  scale: scale,
                  child: Icon(
                    iconData.icon,
                    size: iconData.size,
                    color: iconData.color.withValues(alpha: 0.15),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _FloatingIconData {
  final IconData icon;
  final double startX;
  final double startY;
  final double size;
  final Color color;
  final double delay;

  _FloatingIconData({
    required this.icon,
    required this.startX,
    required this.startY,
    required this.size,
    required this.color,
    required this.delay,
  });
}
