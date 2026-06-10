import 'package:eventjar/controller/bio_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BioProfileSliverHeader extends GetView<BioProfileController> {
  static const double avatarRadius = 60;

  const BioProfileSliverHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 16.hp,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientDarkStart,
                  AppColors.gradientDarkStart.withValues(alpha: 0.85),
                  AppColors.gradientLightEnd.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: topPad),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  onPressed: () => controller.goBack(),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16.hp - avatarRadius - 6,
            left: 0,
            right: 0,
            child: Center(child: _buildAvatar(context)),
          ),
          Positioned(
            right: 3.wp,
            top: topPad + 8,
            child: _BioSocialLinksVertical(controller: controller),
          ),
          SizedBox(height: 16.hp + avatarRadius - 6),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.cardBg(context), width: 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: controller.avatarUrl.isNotEmpty
          ? CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.cardBg(context),
              backgroundImage: NetworkImage(getFileUrl(controller.avatarUrl)),
            )
          : CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.gradientDarkStart.withValues(
                alpha: 0.1,
              ),
              child: Text(
                _getInitials(controller.name),
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gradientDarkStart,
                ),
              ),
            ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class BioProfileNameSection extends GetView<BioProfileController> {
  const BioProfileNameSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.wp),
      child: Column(
        children: [
          Text(
            controller.name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
              letterSpacing: -0.3,
            ),
          ),
          if (controller.username.isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.gradientDarkStart.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '@${controller.username}',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gradientDarkStart,
                ),
              ),
            ),
          ],
          if (controller.shortBio.isNotEmpty) ...[
            SizedBox(height: 1.hp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.wp),
              child: Text(
                controller.shortBio,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  color: AppColors.textSecondary(context),
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BioSocialLinksVertical extends StatelessWidget {
  final BioProfileController controller;

  const _BioSocialLinksVertical({required this.controller});

  List<_SocialItem> _getSocialLinks() {
    final social = controller.socialLinks;
    if (social == null) return [];
    return [
      if (social.linkedin != null && social.linkedin!.isNotEmpty)
        _SocialItem('linkedin', FontAwesomeIcons.linkedinIn, social.linkedin!),
      if (social.twitter != null && social.twitter!.isNotEmpty)
        _SocialItem('twitter', FontAwesomeIcons.xTwitter, social.twitter!),
      if (social.instagram != null && social.instagram!.isNotEmpty)
        _SocialItem(
          'instagram',
          FontAwesomeIcons.instagram,
          social.instagram!,
        ),
      if (social.facebook != null && social.facebook!.isNotEmpty)
        _SocialItem('facebook', FontAwesomeIcons.facebookF, social.facebook!),
    ];
  }

  Color _socialColor(String platform) {
    switch (platform) {
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'twitter':
        return const Color(0xFF000000);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      default:
        return AppColors.gradientDarkStart;
    }
  }

  @override
  Widget build(BuildContext context) {
    final links = _getSocialLinks();
    if (links.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: links.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: GestureDetector(
              onTap: () {
                final url = item.url.startsWith('http')
                    ? item.url
                    : 'https://${item.url}';
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              },
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: FaIcon(
                    item.icon,
                    size: 14,
                    color: _socialColor(item.platform),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SocialItem {
  final String platform;
  final FaIconData icon;
  final String url;

  _SocialItem(this.platform, this.icon, this.url);
}
